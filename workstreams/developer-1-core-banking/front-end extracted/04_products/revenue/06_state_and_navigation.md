# State and Navigation - Revenue

Payer view combines bills from many collectors; collector context via `X-Tenant-Id`. Fee amounts shown to payers come from the server fee quote. Field collector mode is limited to recording and receipts and works with a short offline queue that syncs with idempotency keys.

## Routes
| Screen | Route | Platform |
|---|---|---|
| S-REV-001 | `/dues` | M |
| S-REV-002 | `/dues/:id` | M |
| S-REV-003 | `/dues/link` | M |
| S-REV-004 | `/dues/receipts` | M |
| S-REV-005 | `/dues/:id/dispute` | M |
| S-REV-006 | `/dues/behalf` | M |
| S-REV-007 | `/dues/autopay` | M |
| S-REV-008 | `/dues/:id/report` | M |
| S-REV-009 | `/collect` | M |
| S-REV-010 | `/collect/:payer` | M |
| W-REV-001 | `/collector/:t/dashboard` | W |
| W-REV-002 | `/collector/:t/items` | W |
| W-REV-003 | `/collector/:t/payers` | W |
| W-REV-004 | `/collector/:t/collections` | W |
| W-REV-005 | `/collector/:t/field` | W |
| W-REV-006 | `/collector/:t/settlement` | W |
| W-REV-007 | `/collector/:t/reports` | W |
| W-REV-008 | `/collector/:t/verification` | W |
