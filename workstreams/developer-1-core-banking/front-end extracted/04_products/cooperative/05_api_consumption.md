# API Consumption - Cooperative

Contract: `04_api_spec.yaml` in the back-end product folder (copy in this folder).

| Method | Path | Purpose | Used by screens | Idempotency-Key |
|---|---|---|---|---|
| POST | /cooperatives | Create cooperative | S-COOP-002 | No |
| GET | /cooperatives | List my cooperatives | S-COOP-001 | No |
| GET | /cooperatives/by-code/{code} | Preview a cooperative by invite code | S-COOP-003 | No |
| POST | /cooperatives/{id}/documents | Upload registration documents | S-COOP-002, W-COOP-014 | No |
| GET | /cooperative/overview | Member overview inside a cooperative | S-COOP-004 | No |
| POST | /cooperative/join-requests | Request to join (by invite code) | S-COOP-003 | No |
| GET | /cooperative/join-requests | List join requests (admin) | W-COOP-003, S-COOP-017 | No |
| POST | /cooperative/join-requests/{requestId}/decision | Approve or reject a join request | W-COOP-003, S-COOP-017 | No |
| GET | /cooperative/members | List members | W-COOP-002 | No |
| POST | /cooperative/members/{memberId}/suspend | Suspend or remove member | W-COOP-002 | No |
| POST | /cooperative/leave | Request to leave | S-COOP-016 | Yes |
| GET | /cooperative/plans | List contribution plans | S-COOP-005, W-COOP-004 | No |
| POST | /cooperative/plans | Create contribution plan (new rule version if changing) | W-COOP-004 | No |
| GET | /cooperative/dues | My dues and history | S-COOP-005 | No |
| POST | /cooperative/contributions | Pay a contribution (manual) | S-COOP-006 | Yes |
| PUT | /cooperative/plans/{planId}/auto-deduct | Enable or disable auto-deduction (consent) | S-COOP-005 | Yes |
| GET | /cooperative/arrears | Arrears by member and plan | W-COOP-004 | No |
| GET | /cooperative/shares/me | My shares and certificate | S-COOP-007 | No |
| PUT | /cooperative/share-policy | Set share policy | W-COOP-007 | No |
| POST | /cooperative/dividend-runs | Propose a dividend run | W-COOP-007 | No |
| POST | /cooperative/dividend-runs/{runId}/approve | Approve a dividend run (second admin) | W-COOP-007 | Yes |
| GET | /cooperative/loans/eligibility | Loan eligibility and limits | S-COOP-008, S-COOP-009 | No |
| POST | /cooperative/loan-applications/preview | Preview schedule and cost | S-COOP-009 | No |
| POST | /cooperative/loan-applications | Submit loan application with guarantors | S-COOP-010 | Yes |
| GET | /cooperative/guarantees | My guarantee requests and obligations | S-COOP-008, S-COOP-011 | No |
| POST | /cooperative/guarantees/{guaranteeId}/respond | Accept or decline a guarantee | S-COOP-011 | Yes |
| GET | /cooperative/loan-applications | Loan application queue (admin) | W-COOP-005, S-COOP-017 | No |
| POST | /cooperative/loan-applications/{applicationId}/decision | Approve or reject (dual control) | W-COOP-005, S-COOP-017 | Yes |
| GET | /cooperative/loans/{loanId} | Loan detail and schedule | S-COOP-012 | No |
| POST | /cooperative/loans/{loanId}/repayments | Repay loan | S-COOP-013 | Yes |
| POST | /cooperative/loans/{loanId}/recovery | Start guarantor recovery (after notice) | W-COOP-006 | Yes |
| GET | /cooperative/dashboard | Admin dashboard figures | W-COOP-001 | No |
| GET | /cooperative/statement | My statement | S-COOP-014 | No |
| GET | /cooperative/reports/{type} | Trial balance, income summary, AGM pack | W-COOP-010 | No |
| POST | /cooperative/withdrawals | Request a withdrawal (dual control) | W-COOP-011 | Yes |
| POST | /cooperative/withdrawals/{withdrawalId}/approve | Approve withdrawal (second admin) | W-COOP-011, S-COOP-017 | Yes |
| GET | /cooperative/rules | Active and draft rule sets | W-COOP-008 | No |
| POST | /cooperative/rules | Submit a rule set draft for approval | W-COOP-008 | No |
| POST | /cooperative/admins | Invite or assign an admin role | W-COOP-009 | No |
| POST | /cooperative/admins/succession | Appoint a replacement admin | W-COOP-009 | Yes |
| GET | /cooperative/announcements | Announcements | S-COOP-015, W-COOP-012 | No |
| POST | /cooperative/announcements | Publish announcement | W-COOP-012 | No |
| POST | /cooperative/meetings | Schedule meeting | W-COOP-012 | No |
| POST | /cooperative/report-concern | Report a concern about the cooperative | S-COOP-004 | No |
| GET | /cooperative/audit | Audit trail | W-COOP-013 | No |

All tenant-scoped calls send `X-Tenant-Id`. Money-moving calls send `Idempotency-Key` and `X-Pin-Token`.
