# Screen Inventory - Instant Loan

Platforms: M = mobile app, W = web dashboard.

| ID | Screen | Platform | Route | Requirements |
|---|---|---|---|---|
| S-LOAN-001 | Borrow home | M | `/borrow` | LOAN-ELG-001, LOAN-APP-003 |
| S-LOAN-002 | Eligibility and limit | M | `/borrow/eligibility` | LOAN-ELG-001, LOAN-ELG-002 |
| S-LOAN-003 | Choose amount and tenor | M | `/borrow/new` | LOAN-APP-001 |
| S-LOAN-004 | Affordability check | M | `/borrow/affordability` | LOAN-APP-002 |
| S-LOAN-005 | Review and agreement | M | `/borrow/review` | LOAN-APP-004, LOAN-APP-005 |
| S-LOAN-006 | Result | M | `/borrow/result` | LOAN-DIS-001 |
| S-LOAN-007 | Loan detail | M | `/borrow/loans/:id` | LOAN-DIS-002, LOAN-REP-003 |
| S-LOAN-008 | Repay | M | `/borrow/loans/:id/repay` | LOAN-REP-001, LOAN-REP-002 |
| S-LOAN-009 | Auto-repay settings | M | `/borrow/loans/:id/auto` | LOAN-REP-001 |
| S-LOAN-010 | Hardship request | M | `/borrow/loans/:id/help` | LOAN-ARR-002 |
| S-LOAN-011 | Loan history | M | `/borrow/history` | LOAN-REP-004 |
| S-LOAN-012 | Lender info and privacy | M | `/borrow/about` | LOAN-APP-003, LOAN-APP-005 |
| W-LOAN-001 | Applications queue | W | `/backoffice/loans/applications` | LOAN-ELG-004 |
| W-LOAN-002 | Portfolio and collections | W | `/backoffice/loans/portfolio` | LOAN-ARR-001, LOAN-ARR-003, LOAN-PRT-003 |
| W-LOAN-003 | Product configuration | W | `/backoffice/loans/products` | LOAN-ELG-003 |
| W-LOAN-004 | Partner settlement | W | `/backoffice/loans/settlement` | LOAN-PRT-001, LOAN-PRT-002 |
