# API Conventions

- Base path `/api/v1`. JSON over HTTPS. Contract-first (`openapi_core.yaml`); breaking changes need a new version.
- Auth: `Authorization: Bearer <access token>`. Device id header `X-Device-Id`. Tenant context `X-Tenant-Id` (tenant endpoints). Request id `X-Request-Id` (client generates; server echoes and logs).
- Idempotency: `Idempotency-Key` header on money-moving requests (see IDEMPOTENCY_AND_CONCURRENCY.md).
- Money: integer `amountKobo`; never decimals. Currency `NGN`.
- Dates: ISO 8601 UTC (`2026-10-13T09:30:00Z`).
- IDs: UUID strings. Human references (`reference`, `ticketNumber`) are separate strings.
- Pagination: cursor-based: `?limit=20&cursor=...` returning `{ items, nextCursor }`.
- Errors: `{ "code": "TRF_LIMIT_EXCEEDED", "message": "...", "details": {}, "requestId": "..." }` with proper HTTP status (400 validation, 401 auth, 403 forbidden, 404, 409 conflict, 422 business rule, 429 rate limit, 5xx server).
- Rate limits: returned headers `X-RateLimit-Remaining`, `Retry-After` on 429.
- Quote-then-commit pattern for money: `POST /transfers/quote` returns `quoteId`, fee, total and expiry; `POST /transfers` references `quoteId` and requires a PIN token.
- PIN authorisation: client obtains a short-lived `pinToken` from `POST /auth/pin/verify` and sends it as `X-Pin-Token` on the money request.
- Webhooks (inbound from providers): signature verification, replay protection, idempotent handling.
- Deprecation: `Deprecation` and `Sunset` headers with at least 90 days notice.
