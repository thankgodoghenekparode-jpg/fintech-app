# Screen Inventory - Merchant and Small-Business Tools

Platforms: M = mobile app, W = web dashboard.

| ID | Screen | Platform | Route | Requirements |
|---|---|---|---|---|
| S-MER-001 | Business home | M | `/business` | MER-ACC-001, MER-MON-003 |
| S-MER-002 | Create business | M | `/business/new` | MER-ACC-001 |
| S-MER-003 | Payment links | M | `/business/links` | MER-PAY-001 |
| S-MER-004 | QR codes | M | `/business/qr` | MER-PAY-002, MER-PAY-005 |
| S-MER-005 | Create invoice | M | `/business/invoices/new` | MER-INV-001 |
| S-MER-006 | Invoices | M | `/business/invoices` | MER-INV-002 |
| S-MER-007 | Cashier | M | `/business/cashier` | MER-PAY-005 |
| S-MER-008 | Transactions and payouts | M | `/business/transactions` | MER-ACC-003, MER-MON-003 |
| S-MER-009 | Refund | M | `/business/refund/:id` | MER-MON-001 |
| S-MER-010 | Team | M | `/business/team` | MER-ACC-002 |
| W-MER-001 | Business dashboard | W | `/business/:t/dashboard` | MER-MON-003 |
| W-MER-002 | Invoices | W | `/business/:t/invoices` | MER-INV-001, MER-INV-002 |
| W-MER-003 | Payment links | W | `/business/:t/links` | MER-PAY-001 |
| W-MER-004 | Reports and exports | W | `/business/:t/reports` | MER-MON-003 |
| W-MER-005 | Team and verification | W | `/business/:t/team` | MER-ACC-001, MER-ACC-002 |
