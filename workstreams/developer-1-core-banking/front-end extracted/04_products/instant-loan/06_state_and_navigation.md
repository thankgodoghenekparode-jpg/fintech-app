# State and Navigation - Instant Loan

All costs, schedules and limits come from the server (cost summary quote). The client never calculates interest. Lender identity and registration labels come from configuration. Offers appear only inside the Borrow area.

## Routes
| Screen | Route | Platform |
|---|---|---|
| S-LOAN-001 | `/borrow` | M |
| S-LOAN-002 | `/borrow/eligibility` | M |
| S-LOAN-003 | `/borrow/new` | M |
| S-LOAN-004 | `/borrow/affordability` | M |
| S-LOAN-005 | `/borrow/review` | M |
| S-LOAN-006 | `/borrow/result` | M |
| S-LOAN-007 | `/borrow/loans/:id` | M |
| S-LOAN-008 | `/borrow/loans/:id/repay` | M |
| S-LOAN-009 | `/borrow/loans/:id/auto` | M |
| S-LOAN-010 | `/borrow/loans/:id/help` | M |
| S-LOAN-011 | `/borrow/history` | M |
| S-LOAN-012 | `/borrow/about` | M |
| W-LOAN-001 | `/backoffice/loans/applications` | W |
| W-LOAN-002 | `/backoffice/loans/portfolio` | W |
| W-LOAN-003 | `/backoffice/loans/products` | W |
| W-LOAN-004 | `/backoffice/loans/settlement` | W |
