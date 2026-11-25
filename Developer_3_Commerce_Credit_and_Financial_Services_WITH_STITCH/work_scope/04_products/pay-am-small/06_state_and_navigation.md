# State and Navigation - Pay Am Small

Vault progress, penalties, refunds and payouts are server-calculated. Vendor tenant context via `X-Tenant-Id` for web. Customer screens never show vendor financial details. Delivery code is shown only to the buyer.

## Routes
| Screen | Route | Platform |
|---|---|---|
| S-PAS-001 | `/shop` | M |
| S-PAS-002 | `/shop/products/:id` | M |
| S-PAS-003 | `/shop/plan` | M |
| S-PAS-004 | `/shop/plan/review` | M |
| S-PAS-005 | `/shop/plans` | M |
| S-PAS-006 | `/shop/plans/:id` | M |
| S-PAS-007 | `/shop/plans/:id/add` | M |
| S-PAS-008 | `/shop/plans/:id/withdraw` | M |
| S-PAS-009 | `/shop/plans/:id/deadline` | M |
| S-PAS-010 | `/shop/orders/:id` | M |
| S-PAS-011 | `/shop/credit/:id` | M |
| S-PAS-012 | `/shop/vendors/:id` | M |
| S-PAS-013 | `/shop/orders/:id/report` | M |
| W-PAS-001 | `/vendor/:t/dashboard` | W |
| W-PAS-002 | `/vendor/:t/products` | W |
| W-PAS-003 | `/vendor/:t/orders` | W |
| W-PAS-004 | `/vendor/:t/plans` | W |
| W-PAS-005 | `/vendor/:t/credit` | W |
| W-PAS-006 | `/vendor/:t/payouts` | W |
| W-PAS-007 | `/vendor/:t/team` | W |
