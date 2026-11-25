# Screen Inventory - Cooperative

Platforms: M = mobile app, W = web dashboard.

| ID | Screen | Platform | Route | Requirements |
|---|---|---|---|---|
| S-COOP-001 | Cooperatives home | M | `/coop` | COOP-SET-001, COOP-MEM-001 |
| S-COOP-002 | Create cooperative | M | `/coop/new` | COOP-SET-001..004 |
| S-COOP-003 | Join cooperative | M | `/coop/join` | COOP-MEM-001 |
| S-COOP-004 | Cooperative overview (member) | M | `/coop/:id` | COOP-CON-005, COOP-LON-002 |
| S-COOP-005 | My contributions | M | `/coop/:id/contributions` | COOP-CON-002, COOP-CON-003 |
| S-COOP-006 | Pay contribution | M | `/coop/:id/contributions/pay` | COOP-CON-002, COOP-CON-004 |
| S-COOP-007 | Shares and certificate | M | `/coop/:id/shares` | COOP-SHR-002 |
| S-COOP-008 | Loans overview | M | `/coop/:id/loans` | COOP-LON-001 |
| S-COOP-009 | Loan request | M | `/coop/:id/loans/new` | COOP-LON-002, COOP-LON-011 |
| S-COOP-010 | Choose guarantors | M | `/coop/:id/loans/new/guarantors` | COOP-LON-003 |
| S-COOP-011 | Guarantee request (guarantor) | M | `/coop/:id/guarantees/:gid` | COOP-LON-004 |
| S-COOP-012 | Loan detail | M | `/coop/:id/loans/:lid` | COOP-LON-008 |
| S-COOP-013 | Repay loan | M | `/coop/:id/loans/:lid/repay` | COOP-LON-008 |
| S-COOP-014 | My statement | M | `/coop/:id/statement` | COOP-CON-005 |
| S-COOP-015 | Announcements and meetings | M | `/coop/:id/hub` | COOP-SOC-001, COOP-SOC-002 |
| S-COOP-016 | Leave cooperative | M | `/coop/:id/leave` | COOP-MEM-004 |
| S-COOP-017 | Admin approvals (mobile) | M | `/coop/:id/admin/approvals` | COOP-MEM-002, COOP-LON-005 |
| W-COOP-001 | Admin dashboard | W | `/group/:t/dashboard` | COOP-BOK-001 |
| W-COOP-002 | Members | W | `/group/:t/members` | COOP-MEM-003, COOP-MEM-005 |
| W-COOP-003 | Join requests | W | `/group/:t/join-requests` | COOP-MEM-002 |
| W-COOP-004 | Plans and arrears | W | `/group/:t/contributions` | COOP-CON-001, COOP-CON-006 |
| W-COOP-005 | Loan applications | W | `/group/:t/loan-applications` | COOP-LON-005 |
| W-COOP-006 | Loans portfolio | W | `/group/:t/loans` | COOP-LON-009 |
| W-COOP-007 | Shares and dividends | W | `/group/:t/shares` | COOP-SHR-001, COOP-SHR-003 |
| W-COOP-008 | Rules and settings | W | `/group/:t/rules` | COOP-SET-006, COOP-SET-007 |
| W-COOP-009 | Admins and roles | W | `/group/:t/admins` | COOP-SET-004, COOP-SET-005, COOP-SET-008 |
| W-COOP-010 | Ledger and reports | W | `/group/:t/reports` | COOP-BOK-002, COOP-BOK-004 |
| W-COOP-011 | Withdrawals and approvals | W | `/group/:t/withdrawals` | COOP-BOK-003 |
| W-COOP-012 | Announcements and meetings | W | `/group/:t/hub` | COOP-SOC-001, COOP-SOC-002 |
| W-COOP-013 | Audit trail | W | `/group/:t/audit` | COOP-BOK-005 |
| W-COOP-014 | Verification and trust level | W | `/group/:t/verification` | COOP-SET-003 |
