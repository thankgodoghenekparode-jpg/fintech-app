import { randomUUID } from 'node:crypto';
import { createServer } from 'node:http';

const port = Number(process.env.MOCK_API_PORT ?? 8787);
const pinTokenLifetimeSeconds = 60;
const pinTokens = new Map();
const uuidPattern = /^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;
const datePattern = /^\d{4}-\d{2}-\d{2}$/;

function sendJson(response, status, payload) {
  response.writeHead(status, {
    'Content-Type': 'application/json; charset=utf-8',
    'Cache-Control': 'no-store',
  });
  response.end(JSON.stringify(payload));
}

function sendEmpty(response, status) {
  response.writeHead(status, { 'Cache-Control': 'no-store' });
  response.end();
}

function fail(response, status, code, message, requestId) {
  sendJson(response, status, { code, message, requestId });
}

function requestId(request) {
  const supplied = request.headers['x-request-id'];
  return typeof supplied === 'string' && supplied.length > 0
    ? supplied
    : randomUUID();
}

function hasBearerToken(request) {
  return /^Bearer\s+\S+$/i.test(request.headers.authorization ?? '');
}

async function readJson(request) {
  const chunks = [];
  let size = 0;
  for await (const chunk of request) {
    size += chunk.length;
    if (size > 64 * 1024) throw new Error('body_too_large');
    chunks.push(chunk);
  }
  if (size === 0) return null;
  return JSON.parse(Buffer.concat(chunks).toString('utf8'));
}

function isDate(value) {
  if (typeof value !== 'string' || !datePattern.test(value)) return false;
  const date = new Date(`${value}T00:00:00.000Z`);
  return !Number.isNaN(date.valueOf()) && date.toISOString().slice(0, 10) === value;
}

function validIdempotencyKey(request) {
  return uuidPattern.test(request.headers['idempotency-key'] ?? '');
}

function consumePinToken(request) {
  const token = request.headers['x-pin-token'];
  if (typeof token !== 'string') return false;
  const expiresAt = pinTokens.get(token);
  pinTokens.delete(token);
  return typeof expiresAt === 'number' && expiresAt > Date.now();
}

async function handle(request, response) {
  response.setHeader('Access-Control-Allow-Origin', '*');
  response.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, OPTIONS');
  response.setHeader(
    'Access-Control-Allow-Headers',
    'Authorization, Content-Type, Idempotency-Key, X-Pin-Token, X-Request-Id, X-Tenant-Id',
  );
  if (request.method === 'OPTIONS') return sendEmpty(response, 204);

  const url = new URL(request.url ?? '/', `http://${request.headers.host ?? 'localhost'}`);
  const id = requestId(request);
  if (request.method === 'GET' && url.pathname === '/health') {
    return sendJson(response, 200, { status: 'ok', scope: 'target-savings-contract-subset' });
  }

  if (!hasBearerToken(request)) {
    return fail(response, 401, 'MOCK_BEARER_REQUIRED', 'A bearer token is required by this mock.', id);
  }

  let body;
  if (request.method === 'POST' && url.pathname === '/auth/pin/verify') {
    try {
      body = await readJson(request);
    } catch {
      return fail(response, 400, 'VALIDATION_ERROR', 'Expected a JSON request body.', id);
    }
    if (!body || typeof body.pin !== 'string' || !/^\d{4}$/.test(body.pin)) {
      return fail(response, 400, 'VALIDATION_ERROR', 'PIN must contain four digits.', id);
    }
    const token = `mock-${randomUUID()}`;
    pinTokens.set(token, Date.now() + pinTokenLifetimeSeconds * 1000);
    return sendJson(response, 200, {
      pinToken: token,
      expiresInSeconds: pinTokenLifetimeSeconds,
    });
  }

  const goalDetail = url.pathname.match(/^\/targets\/([^/]+)$/);
  const goalAction = url.pathname.match(/^\/targets\/([^/]+)\/(auto-save|topups)$/);
  const isCreate = request.method === 'POST' && url.pathname === '/targets';
  const isList = request.method === 'GET' && url.pathname === '/targets';
  const isDetail = request.method === 'GET' && goalDetail;
  const isAutoSave = request.method === 'PUT' && goalAction?.[2] === 'auto-save';
  const isTopUp = request.method === 'POST' && goalAction?.[2] === 'topups';

  if (!isCreate && !isList && !isDetail && !isAutoSave && !isTopUp) {
    return fail(response, 501, 'MOCK_OPERATION_UNIMPLEMENTED', 'This mock only implements the documented Target Savings mobile subset.', id);
  }

  if (goalDetail && !uuidPattern.test(goalDetail[1])) {
    return fail(response, 400, 'VALIDATION_ERROR', 'Goal reference must be a UUID.', id);
  }
  if (goalAction && !uuidPattern.test(goalAction[1])) {
    return fail(response, 400, 'VALIDATION_ERROR', 'Goal reference must be a UUID.', id);
  }
  if (isList || isDetail) {
    // These OpenAPI responses declare a success status but no body schema/content.
    return sendEmpty(response, 200);
  }
  if (!validIdempotencyKey(request)) {
    return fail(response, 400, 'VALIDATION_ERROR', 'A UUID Idempotency-Key is required.', id);
  }

  if (isAutoSave || isTopUp || isCreate) {
    try {
      body = await readJson(request);
    } catch {
      return fail(response, 400, 'VALIDATION_ERROR', 'Expected a JSON request body.', id);
    }
    if (!body || typeof body !== 'object' || Array.isArray(body)) {
      return fail(response, 400, 'VALIDATION_ERROR', 'Expected a JSON object body.', id);
    }
  }

  if (isCreate) {
    const valid = typeof body.name === 'string' &&
      Number.isInteger(body.targetKobo) && body.targetKobo > 0 &&
      ['FLEXIBLE', 'LOCKED'].includes(body.mode) &&
      (body.targetDate === undefined || isDate(body.targetDate)) &&
      (body.theme === undefined || typeof body.theme === 'string') &&
      (body.firstDepositKobo === undefined ||
        (Number.isInteger(body.firstDepositKobo) && body.firstDepositKobo > 0));
    if (!valid) {
      return fail(response, 400, 'VALIDATION_ERROR', 'Request does not match the documented goal-create fields.', id);
    }
  }
  if (isTopUp && (!Number.isInteger(body.amountKobo) || body.amountKobo <= 0)) {
    return fail(response, 400, 'VALIDATION_ERROR', 'amountKobo must be a positive integer.', id);
  }
  if (isAutoSave && (!['DAILY', 'WEEKLY', 'MONTHLY'].includes(body.frequency) ||
    !Number.isInteger(body.amountKobo) || body.amountKobo <= 0 || !isDate(body.startDate))) {
    return fail(response, 400, 'VALIDATION_ERROR', 'Request does not match the documented auto-save fields.', id);
  }

  if (!consumePinToken(request)) {
    return fail(response, 403, 'FORBIDDEN', 'A valid one-use PIN token is required by this mock.', id);
  }

  // The product OpenAPI declares these status codes without response content.
  return sendEmpty(response, isCreate || isTopUp ? 201 : 200);
}

const server = createServer((request, response) => {
  void handle(request, response).catch(() => {
    if (!response.headersSent) {
      fail(response, 500, 'INTERNAL_ERROR', 'Mock server error.', requestId(request));
    } else {
      response.destroy();
    }
  });
});

server.listen(port, '0.0.0.0', () => {
  process.stdout.write(`Target Savings contract mock listening on :${port}\n`);
});
