# State and Navigation - Merchant and Small-Business Tools

Business context via `X-Tenant-Id`. Cashier mode keeps a minimal UI and listens for payment events (push/real-time) to confirm payments. Amounts, fees and totals come from the server.

## Routes
| Screen | Route | Platform |
|---|---|---|
| S-MER-001 | `/business` | M |
| S-MER-002 | `/business/new` | M |
| S-MER-003 | `/business/links` | M |
| S-MER-004 | `/business/qr` | M |
| S-MER-005 | `/business/invoices/new` | M |
| S-MER-006 | `/business/invoices` | M |
| S-MER-007 | `/business/cashier` | M |
| S-MER-008 | `/business/transactions` | M |
| S-MER-009 | `/business/refund/:id` | M |
| S-MER-010 | `/business/team` | M |
| W-MER-001 | `/business/:t/dashboard` | W |
| W-MER-002 | `/business/:t/invoices` | W |
| W-MER-003 | `/business/:t/links` | W |
| W-MER-004 | `/business/:t/reports` | W |
| W-MER-005 | `/business/:t/team` | W |
