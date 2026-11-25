# State and Navigation - Cooperative

Cooperative context is stored in session (`X-Tenant-Id`). Member and admin views share data models; admin screens are available on web and a subset on mobile. Pending states: join request, guarantor acceptance, admin approval, cooling-off. All amounts in kobo; schedules rendered from server-provided schedule objects (never recomputed on the client).

## Routes
| Screen | Route | Platform |
|---|---|---|
| S-COOP-001 | `/coop` | M |
| S-COOP-002 | `/coop/new` | M |
| S-COOP-003 | `/coop/join` | M |
| S-COOP-004 | `/coop/:id` | M |
| S-COOP-005 | `/coop/:id/contributions` | M |
| S-COOP-006 | `/coop/:id/contributions/pay` | M |
| S-COOP-007 | `/coop/:id/shares` | M |
| S-COOP-008 | `/coop/:id/loans` | M |
| S-COOP-009 | `/coop/:id/loans/new` | M |
| S-COOP-010 | `/coop/:id/loans/new/guarantors` | M |
| S-COOP-011 | `/coop/:id/guarantees/:gid` | M |
| S-COOP-012 | `/coop/:id/loans/:lid` | M |
| S-COOP-013 | `/coop/:id/loans/:lid/repay` | M |
| S-COOP-014 | `/coop/:id/statement` | M |
| S-COOP-015 | `/coop/:id/hub` | M |
| S-COOP-016 | `/coop/:id/leave` | M |
| S-COOP-017 | `/coop/:id/admin/approvals` | M |
| W-COOP-001 | `/group/:t/dashboard` | W |
| W-COOP-002 | `/group/:t/members` | W |
| W-COOP-003 | `/group/:t/join-requests` | W |
| W-COOP-004 | `/group/:t/contributions` | W |
| W-COOP-005 | `/group/:t/loan-applications` | W |
| W-COOP-006 | `/group/:t/loans` | W |
| W-COOP-007 | `/group/:t/shares` | W |
| W-COOP-008 | `/group/:t/rules` | W |
| W-COOP-009 | `/group/:t/admins` | W |
| W-COOP-010 | `/group/:t/reports` | W |
| W-COOP-011 | `/group/:t/withdrawals` | W |
| W-COOP-012 | `/group/:t/hub` | W |
| W-COOP-013 | `/group/:t/audit` | W |
| W-COOP-014 | `/group/:t/verification` | W |
