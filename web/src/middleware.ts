import { NextRequest, NextResponse } from 'next/server';

function screenIdForPath(path: string): string | undefined {
  const exact: Record<string, string> = {
    '/backoffice/agents': 'W-AGT-001',
    '/backoffice/agents/float': 'W-AGT-002',
    '/backoffice/agents/config': 'W-AGT-003',
  };
  const direct = exact[path];
  if (direct) return direct;

  const patterns: Array<[RegExp, string]> = [
    [/^\/group\/[^/]+\/ajo$/, 'W-AJO-001'],
    [/^\/group\/[^/]+\/dashboard$/, 'W-COOP-001'],
    [/^\/group\/[^/]+\/members$/, 'W-COOP-002'],
    [/^\/group\/[^/]+\/join-requests$/, 'W-COOP-003'],
    [/^\/group\/[^/]+\/contributions$/, 'W-COOP-004'],
    [/^\/group\/[^/]+\/loan-applications$/, 'W-COOP-005'],
    [/^\/group\/[^/]+\/loans$/, 'W-COOP-006'],
    [/^\/group\/[^/]+\/shares$/, 'W-COOP-007'],
    [/^\/group\/[^/]+\/rules$/, 'W-COOP-008'],
    [/^\/group\/[^/]+\/admins$/, 'W-COOP-009'],
    [/^\/group\/[^/]+\/reports$/, 'W-COOP-010'],
    [/^\/group\/[^/]+\/withdrawals$/, 'W-COOP-011'],
    [/^\/group\/[^/]+\/hub$/, 'W-COOP-012'],
    [/^\/group\/[^/]+\/audit$/, 'W-COOP-013'],
    [/^\/group\/[^/]+\/verification$/, 'W-COOP-014'],
    [/^\/collector\/[^/]+\/dashboard$/, 'W-REV-001'],
    [/^\/collector\/[^/]+\/items$/, 'W-REV-002'],
    [/^\/collector\/[^/]+\/payers$/, 'W-REV-003'],
    [/^\/collector\/[^/]+\/collections$/, 'W-REV-004'],
    [/^\/collector\/[^/]+\/field$/, 'W-REV-005'],
    [/^\/collector\/[^/]+\/settlement$/, 'W-REV-006'],
    [/^\/collector\/[^/]+\/reports$/, 'W-REV-007'],
    [/^\/collector\/[^/]+\/verification$/, 'W-REV-008'],
  ];
  return patterns.find(([pattern]) => pattern.test(path))?.[1];
}

export function middleware(request: NextRequest) {
  if (process.env.DEVELOPER_TWO_DESIGN_DEMO !== 'true') {
    return NextResponse.next();
  }
  const path = request.nextUrl.pathname;
  const screenId = screenIdForPath(path);
  if (!screenId) return NextResponse.next();

  const previewUrl = request.nextUrl.clone();
  previewUrl.pathname = `/demo-preview/${screenId}`;
  previewUrl.search = '';
  previewUrl.searchParams.set('from', path);
  return NextResponse.rewrite(previewUrl);
}

export const config = {
  matcher: ['/((?!_next|api|favicon.ico).*)'],
};
