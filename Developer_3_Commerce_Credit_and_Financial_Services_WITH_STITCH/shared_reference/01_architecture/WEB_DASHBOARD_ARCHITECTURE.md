# Web Dashboard Architecture

## Apps (one Next.js project, route groups)
| Route group | Users |
|---|---|
| `/admin-console` | Staff back office (support, KYC, disputes, risk, finance, compliance) |
| `/group` | Cooperative and ajo admins |
| `/vendor` | Pay Am Small vendors |
| `/collector` | Revenue collectors |
| `/escrow` | Escrow deal management (web view) |

## Principles
1. Role-based navigation driven by permissions returned by the API; never trust the client.
2. Tenant context in the URL (`/group/{tenantId}/...`) and in an `X-Tenant-Id` header.
3. Server-side pagination, filter and sort for every table. Export through back-end jobs.
4. Dual-control actions show pending approvals clearly.
5. Sensitive fields masked by default; unmask requires a reason and is logged.
6. Responsive down to tablet; mobile web is read-mostly.

## Shared UI
Table, filters, detail drawer, approval banner, audit timeline, status chip, empty/error states, file upload with progress.
