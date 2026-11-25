# Screen Inventory - Pay Am Small

Platforms: M = mobile app, W = web dashboard.

| ID | Screen | Platform | Route | Requirements |
|---|---|---|---|---|
| S-PAS-001 | Marketplace home | M | `/shop` | PAS-BUY-001 |
| S-PAS-002 | Product detail | M | `/shop/products/:id` | PAS-BUY-002 |
| S-PAS-003 | Plan setup | M | `/shop/plan` | PAS-BUY-003, PAS-BUY-004 |
| S-PAS-004 | Plan summary and terms | M | `/shop/plan/review` | PAS-BUY-003 |
| S-PAS-005 | My plans | M | `/shop/plans` | PAS-BUY-004 |
| S-PAS-006 | Vault detail | M | `/shop/plans/:id` | PAS-VLT-001, PAS-VLT-002 |
| S-PAS-007 | Add money to vault | M | `/shop/plans/:id/add` | PAS-VLT-001 |
| S-PAS-008 | Withdraw from vault | M | `/shop/plans/:id/withdraw` | PAS-VLT-003 |
| S-PAS-009 | Deadline decision | M | `/shop/plans/:id/deadline` | PAS-VLT-004 |
| S-PAS-010 | Order tracking | M | `/shop/orders/:id` | PAS-ORD-001, PAS-BUY-005 |
| S-PAS-011 | Credit repayment | M | `/shop/credit/:id` | PAS-CRD-002 |
| S-PAS-012 | Vendor storefront | M | `/shop/vendors/:id` | PAS-BUY-001 |
| S-PAS-013 | Report an order problem | M | `/shop/orders/:id/report` | PAS-ORD-003 |
| W-PAS-001 | Vendor dashboard | W | `/vendor/:t/dashboard` | PAS-VEN-006 |
| W-PAS-002 | Products and prices | W | `/vendor/:t/products` | PAS-VEN-003, PAS-VEN-004 |
| W-PAS-003 | Orders and fulfilment | W | `/vendor/:t/orders` | PAS-ORD-001 |
| W-PAS-004 | Plans and customers | W | `/vendor/:t/plans` | PAS-VEN-005 |
| W-PAS-005 | Credit offers | W | `/vendor/:t/credit` | PAS-CRD-001 |
| W-PAS-006 | Payouts and wallet | W | `/vendor/:t/payouts` | PAS-VLT-005, PAS-VLT-006 |
| W-PAS-007 | Team and verification | W | `/vendor/:t/team` | PAS-VEN-001, PAS-VEN-002 |
