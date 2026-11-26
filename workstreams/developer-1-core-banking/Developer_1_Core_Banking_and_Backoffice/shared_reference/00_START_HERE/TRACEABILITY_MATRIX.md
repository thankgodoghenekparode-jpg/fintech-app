# Traceability Matrix (core banking, starter)

Requirement -> screens -> API -> tables -> tests -> status. Generated in Stage 1 from the PRD, screen inventory and test cases. Product rows are added in Stage 2. Update the Status column as features are built (NOT STARTED / IN PROGRESS / DONE / VERIFIED).

| Requirement | Screens | API | Tables | FE tests | BE tests | Status |
|---|---|---|---|---|---|---|
| CB-ONB-001 | S-CB-001, S-CB-002, S-CB-003 | /auth/otp/*, /onboarding/*, /kyc/status | identity.customers, identity.kyc_records, identity.consents | TC-FE-ONB-001, TC-FE-ONB-002 | - | NOT STARTED |
| CB-ONB-002 | S-CB-004, S-CB-005 | /auth/otp/*, /onboarding/*, /kyc/status | identity.customers, identity.kyc_records, identity.consents | - | - | NOT STARTED |
| CB-ONB-003 | S-CB-006 | /auth/otp/*, /onboarding/*, /kyc/status | identity.customers, identity.kyc_records, identity.consents | TC-FE-ONB-003 | TC-BE-KYC-002 | NOT STARTED |
| CB-ONB-004 | S-CB-007 | /auth/otp/*, /onboarding/*, /kyc/status | identity.customers, identity.kyc_records, identity.consents | - | - | NOT STARTED |
| CB-ONB-005 | S-CB-008 | /auth/otp/*, /onboarding/*, /kyc/status | identity.customers, identity.kyc_records, identity.consents | TC-FE-ONB-004 | - | NOT STARTED |
| CB-ONB-006 | S-CB-009, S-CB-010 | /auth/otp/*, /onboarding/*, /kyc/status | identity.customers, identity.kyc_records, identity.consents | - | - | NOT STARTED |
| CB-ONB-007 | S-CB-012 | /auth/otp/*, /onboarding/*, /kyc/status | identity.customers, identity.kyc_records, identity.consents | - | TC-BE-ACC-001 | NOT STARTED |
| CB-ONB-008 | S-CB-072 | /auth/otp/*, /onboarding/*, /kyc/status | identity.customers, identity.kyc_records, identity.consents | - | - | NOT STARTED |
| CB-ONB-009 | S-CB-072 | /auth/otp/*, /onboarding/*, /kyc/status | identity.customers, identity.kyc_records, identity.consents | - | - | NOT STARTED |
| CB-ONB-010 | - | /auth/otp/*, /onboarding/*, /kyc/status | identity.customers, identity.kyc_records, identity.consents | - | TC-BE-KYC-001 | NOT STARTED |
| CB-ONB-011 | - | /auth/otp/*, /onboarding/*, /kyc/status | identity.customers, identity.kyc_records, identity.consents | TC-FE-ONB-005 | - | NOT STARTED |
| CB-ONB-012 | S-CB-004 | /auth/otp/*, /onboarding/*, /kyc/status | identity.customers, identity.kyc_records, identity.consents | - | - | NOT STARTED |
| CB-SEC-001 | S-CB-009, S-CB-011, S-CB-013, S-CB-015 | /auth/otp/request, /auth/otp/verify, /auth/*, /security/* | auth.credentials, auth.refresh_tokens, identity.devices, platform.audit_log | passcode_reset_test.dart | PASSCODE_RESET_API_GAP.md | PARTIAL |
| CB-SEC-002 | S-CB-014, S-CB-074 | /auth/otp/request, /auth/otp/verify, /security/* | auth.credentials, auth.refresh_tokens, identity.devices, platform.audit_log | new_device_verification_test.dart | NEW_DEVICE_VERIFICATION_API_GAP.md | PARTIAL |
| CB-SEC-003 | S-CB-010, S-CB-034 | /auth/*, /security/* | auth.credentials, auth.refresh_tokens, identity.devices, platform.audit_log | - | TC-BE-AUT-003 | NOT STARTED |
| CB-SEC-004 | - | /auth/*, /security/* | auth.credentials, auth.refresh_tokens, identity.devices, platform.audit_log | - | - | NOT STARTED |
| CB-SEC-005 | S-CB-093 | /auth/*, /security/* | auth.credentials, auth.refresh_tokens, identity.devices, platform.audit_log | TC-FE-SEC-002 | TC-BE-AUT-002 | NOT STARTED |
| CB-SEC-006 | S-CB-073, S-CB-094 | /auth/*, /security/* | auth.credentials, auth.refresh_tokens, identity.devices, platform.audit_log | TC-FE-SET-001 | TC-BE-TRF-005 | NOT STARTED |
| CB-SEC-007 | - | /auth/*, /security/* | auth.credentials, auth.refresh_tokens, identity.devices, platform.audit_log | - | - | NOT STARTED |
| CB-SEC-008 | - | /auth/*, /security/* | auth.credentials, auth.refresh_tokens, identity.devices, platform.audit_log | - | - | NOT STARTED |
| CB-SEC-009 | - | /auth/*, /security/* | auth.credentials, auth.refresh_tokens, identity.devices, platform.audit_log | - | - | NOT STARTED |
| CB-SEC-010 | - | /auth/*, /security/* | auth.credentials, auth.refresh_tokens, identity.devices, platform.audit_log | - | - | NOT STARTED |
| CB-ACC-001 | - | /accounts/me, /accounts/me/transactions, /transactions/{id} | accounts.customer_accounts, ledger.*, payments.transactions | - | - | NOT STARTED |
| CB-ACC-002 | S-CB-020 | /accounts/me, /accounts/me/transactions, /transactions/{id} | accounts.customer_accounts, ledger.*, payments.transactions | TC-FE-HOM-001, TC-FE-HOM-002 | - | NOT STARTED |
| CB-ACC-003 | S-CB-020, S-CB-022, S-CB-043 | /accounts/me, /accounts/me/transactions, /transactions/{id} | accounts.customer_accounts, ledger.*, payments.transactions | - | - | NOT STARTED |
| CB-ACC-004 | - | /accounts/me, /accounts/me/transactions, /transactions/{id} | accounts.customer_accounts, ledger.*, payments.transactions | - | - | NOT STARTED |
| CB-ACC-005 | S-CB-076 | /accounts/me, /accounts/me/transactions, /transactions/{id} | accounts.customer_accounts, ledger.*, payments.transactions | - | - | NOT STARTED |
| CB-ACC-006 | S-CB-025 | /accounts/me, /accounts/me/transactions, /transactions/{id} | accounts.customer_accounts, ledger.*, payments.transactions | - | - | NOT STARTED |
| CB-ACC-007 | - | /accounts/me, /accounts/me/transactions, /transactions/{id} | accounts.customer_accounts, ledger.*, payments.transactions | - | - | NOT STARTED |
| CB-FUN-001 | S-CB-024 | inbound webhook; /accounts/me | ledger.*, payments.transactions | - | TC-BE-FUN-001, TC-BE-FUN-002 | NOT STARTED |
| CB-FUN-002 | S-CB-024 | inbound webhook; /accounts/me | ledger.*, payments.transactions | - | - | NOT STARTED |
| CB-FUN-003 | - | inbound webhook; /accounts/me | ledger.*, payments.transactions | - | - | NOT STARTED |
| CB-FUN-004 | S-CB-024 | inbound webhook; /accounts/me | ledger.*, payments.transactions | - | - | NOT STARTED |
| CB-FUN-005 | - | inbound webhook; /accounts/me | ledger.*, payments.transactions | - | - | NOT STARTED |
| CB-TRF-001 | S-CB-030 | /name-enquiry, /transfers/quote, /transfers, /beneficiaries | payments.transactions, payments.beneficiaries, payments.scheduled_payments, ledger.* | - | TC-BE-TRF-001 | NOT STARTED |
| CB-TRF-002 | S-CB-031 | /name-enquiry, /transfers/quote, /transfers, /beneficiaries | payments.transactions, payments.beneficiaries, payments.scheduled_payments, ledger.* | TC-FE-TRF-001 | - | NOT STARTED |
| CB-TRF-003 | S-CB-031, S-CB-036 | /name-enquiry, /transfers/quote, /transfers, /beneficiaries | payments.transactions, payments.beneficiaries, payments.scheduled_payments, ledger.* | - | - | NOT STARTED |
| CB-TRF-004 | S-CB-032, S-CB-033 | /name-enquiry, /transfers/quote, /transfers, /beneficiaries | payments.transactions, payments.beneficiaries, payments.scheduled_payments, ledger.* | TC-FE-TRF-002 | TC-BE-TRF-006 | NOT STARTED |
| CB-TRF-005 | S-CB-022, S-CB-035 | /name-enquiry, /transfers/quote, /transfers, /beneficiaries | payments.transactions, payments.beneficiaries, payments.scheduled_payments, ledger.* | TC-FE-TRF-006 | TC-BE-TRF-003 | NOT STARTED |
| CB-TRF-006 | S-CB-035 | /name-enquiry, /transfers/quote, /transfers, /beneficiaries | payments.transactions, payments.beneficiaries, payments.scheduled_payments, ledger.* | TC-FE-TRF-004 | TC-BE-IDM-001, TC-BE-IDM-002 | NOT STARTED |
| CB-TRF-007 | S-CB-035 | /name-enquiry, /transfers/quote, /transfers, /beneficiaries | payments.transactions, payments.beneficiaries, payments.scheduled_payments, ledger.* | TC-FE-TRF-005 | TC-BE-TRF-002 | NOT STARTED |
| CB-TRF-008 | S-CB-023 | /name-enquiry, /transfers/quote, /transfers, /beneficiaries | payments.transactions, payments.beneficiaries, payments.scheduled_payments, ledger.* | TC-FE-TRF-007 | - | NOT STARTED |
| CB-TRF-009 | S-CB-037 | /name-enquiry, /transfers/quote, /transfers, /beneficiaries | payments.transactions, payments.beneficiaries, payments.scheduled_payments, ledger.* | - | - | NOT STARTED |
| CB-TRF-010 | S-CB-038 | /name-enquiry, /transfers/quote, /transfers, /beneficiaries | payments.transactions, payments.beneficiaries, payments.scheduled_payments, ledger.* | - | - | NOT STARTED |
| CB-TRF-011 | S-CB-039 | /name-enquiry, /transfers/quote, /transfers, /beneficiaries | payments.transactions, payments.beneficiaries, payments.scheduled_payments, ledger.* | - | - | NOT STARTED |
| CB-TRF-012 | S-CB-032 | /name-enquiry, /transfers/quote, /transfers, /beneficiaries | payments.transactions, payments.beneficiaries, payments.scheduled_payments, ledger.* | TC-FE-TRF-003 | TC-BE-TRF-004 | NOT STARTED |
| CB-TRF-013 | S-CB-032 | /name-enquiry, /transfers/quote, /transfers, /beneficiaries | payments.transactions, payments.beneficiaries, payments.scheduled_payments, ledger.* | - | - | NOT STARTED |
| CB-BIL-001 | S-CB-040 | /bills/* | billpay.purchases, payments.transactions | TC-FE-BIL-001 | - | NOT STARTED |
| CB-BIL-002 | S-CB-041 | /bills/* | billpay.purchases, payments.transactions | - | - | NOT STARTED |
| CB-BIL-003 | S-CB-042 | /bills/* | billpay.purchases, payments.transactions | TC-FE-BIL-002 | - | NOT STARTED |
| CB-BIL-004 | S-CB-042 | /bills/* | billpay.purchases, payments.transactions | TC-FE-BIL-003 | TC-BE-BIL-001, TC-BE-BIL-002 | NOT STARTED |
| CB-BIL-005 | S-CB-037 | /bills/* | billpay.purchases, payments.transactions | - | - | NOT STARTED |
| CB-CRD-001 | S-CB-050, S-CB-052 | /cards, /cards/{id}/* | cards.cards | TC-FE-CRD-001 | - | NOT STARTED |
| CB-CRD-002 | S-CB-052 | /cards, /cards/{id}/* | cards.cards | - | - | NOT STARTED |
| CB-CRD-003 | S-CB-051 | /cards, /cards/{id}/* | cards.cards | TC-FE-CRD-002 | - | NOT STARTED |
| CB-CRD-004 | S-CB-053 | /cards, /cards/{id}/* | cards.cards | TC-FE-CRD-003 | - | NOT STARTED |
| CB-CRD-005 | S-CB-054 | /cards, /cards/{id}/* | cards.cards | TC-FE-SEC-003 | TC-BE-CRD-001 | NOT STARTED |
| CB-CRD-006 | S-CB-051, S-CB-055 | /cards, /cards/{id}/* | cards.cards | - | - | NOT STARTED |
| CB-CRD-007 | - | /cards, /cards/{id}/* | cards.cards | - | - | NOT STARTED |
| CB-CRD-008 | - | /cards, /cards/{id}/* | cards.cards | - | - | NOT STARTED |
| CB-CRD-009 | - | /cards, /cards/{id}/* | cards.cards | - | - | NOT STARTED |
| CB-CRD-010 | - | /cards, /cards/{id}/* | cards.cards | - | - | NOT STARTED |
| CB-SAV-001 | S-CB-020, S-CB-060 | - (FE landing) | - | - | - | NOT STARTED |
| CB-NOT-001 | - | /notifications | notifications.* | - | - | NOT STARTED |
| CB-NOT-002 | S-CB-021 | /notifications | notifications.* | - | - | NOT STARTED |
| CB-NOT-003 | - | /notifications | notifications.* | - | - | NOT STARTED |
| CB-NOT-004 | - | /notifications | notifications.* | - | - | NOT STARTED |
| CB-SUP-001 | S-CB-077 | /tickets | support.tickets, support.ticket_messages | - | - | NOT STARTED |
| CB-SUP-002 | S-CB-078 | /tickets | support.tickets, support.ticket_messages | - | - | NOT STARTED |
| CB-SUP-003 | S-CB-079 | /tickets | support.tickets, support.ticket_messages | TC-FE-SUP-001 | - | NOT STARTED |
| CB-SUP-004 | S-CB-080 | /tickets | support.tickets, support.ticket_messages | - | - | NOT STARTED |
| CB-SUP-005 | S-CB-077 | /tickets | support.tickets, support.ticket_messages | - | - | NOT STARTED |
| CB-SET-001 | S-CB-070, S-CB-071 | /more/profile, /accounts/me | accounts.accountName, accounts.tier | profile_screen_test.dart | PROFILE_API_GAP.md | PARTIAL |
| CB-SET-002 | S-CB-073 | /kyc/status, /security/* | identity.*, accounts.tier_limits | - | - | NOT STARTED |
| CB-SET-003 | S-CB-075 | /kyc/status, /security/* | identity.*, accounts.tier_limits | - | - | NOT STARTED |
| CB-SET-004 | S-CB-076 | /kyc/status, /security/* | identity.*, accounts.tier_limits | - | - | NOT STARTED |
| CB-SET-005 | S-CB-081 | /kyc/status, /security/* | identity.*, accounts.tier_limits | - | - | NOT STARTED |
| CB-SET-006 | S-CB-082 | /kyc/status, /security/* | identity.*, accounts.tier_limits | - | - | NOT STARTED |
| CB-SET-007 | S-CB-083 | /kyc/status, /security/* | identity.*, accounts.tier_limits | - | - | NOT STARTED |
| CB-FEE-001 | - | fee engine (internal) | payments.fee_rules, accounts.tier_limits | - | - | NOT STARTED |
| CB-FEE-002 | - | fee engine (internal) | payments.fee_rules, accounts.tier_limits | - | - | NOT STARTED |
| CB-FEE-003 | - | fee engine (internal) | payments.fee_rules, accounts.tier_limits | - | - | NOT STARTED |
| CB-BOF-001 | - | back-office API (Stage 3) | platform.approvals, platform.staff_users | - | TC-BE-SEC-001 | NOT STARTED |
| CB-BOF-002 | - | back-office API (Stage 3) | platform.approvals, platform.staff_users | - | - | NOT STARTED |
| CB-BOF-003 | - | back-office API (Stage 3) | platform.approvals, platform.staff_users | - | TC-BE-REV-001 | NOT STARTED |
| CB-BOF-004 | - | back-office API (Stage 3) | platform.approvals, platform.staff_users | - | TC-BE-REC-001 | NOT STARTED |
| CB-BOF-005 | - | back-office API (Stage 3) | platform.approvals, platform.staff_users | - | - | NOT STARTED |
| NFR-001 | - | cross-cutting | all | - | - | NOT STARTED |
| NFR-002 | - | cross-cutting | all | - | TC-BE-CON-001, TC-BE-CON-002 | NOT STARTED |
| NFR-003 | - | cross-cutting | all | - | TC-BE-LED-001, TC-BE-LED-002, TC-BE-LED-003, TC-BE-LED-004 | NOT STARTED |
| NFR-004 | S-CB-091 | cross-cutting | all | - | - | NOT STARTED |
| NFR-005 | S-CB-090, S-CB-092 | cross-cutting | all | TC-FE-OFF-001 | - | NOT STARTED |
| NFR-006 | - | cross-cutting | all | - | TC-BE-SEC-002 | NOT STARTED |
| NFR-007 | - | cross-cutting | all | TC-FE-A11Y-001, TC-FE-A11Y-002 | - | NOT STARTED |

## Products (all ten)

| Requirement | Screens | API (sample) | Tables | FE tests | BE tests | Status |
|---|---|---|---|---|---|---|
| LOAN-ELG-001 | S-LOAN-001, S-LOAN-002 | GET /loans; GET /loans/eligibility | instant-loan schema | TC-FE-LOAN-001 | - | NOT STARTED |
| LOAN-ELG-002 | S-LOAN-002 | GET /loans/eligibility | instant-loan schema | - | TC-BE-LOAN-003 | NOT STARTED |
| LOAN-ELG-003 | W-LOAN-003 | GET /backoffice/loans/products; POST /backoffice/loans/products | instant-loan schema | - | TC-BE-LOAN-009 | NOT STARTED |
| LOAN-ELG-004 | W-LOAN-001 | GET /backoffice/loans/applications; POST /backoffice/loans/applications/{id}/decision | instant-loan schema | - | TC-BE-LOAN-001 | NOT STARTED |
| LOAN-ELG-005 | - | - | instant-loan schema | - | - | NOT STARTED |
| LOAN-APP-001 | S-LOAN-003 | POST /loans/quote | instant-loan schema | TC-FE-LOAN-002 | - | NOT STARTED |
| LOAN-APP-002 | S-LOAN-004 | POST /loans/quote | instant-loan schema | TC-FE-LOAN-003 | - | NOT STARTED |
| LOAN-APP-003 | S-LOAN-001, S-LOAN-012 | GET /loans; GET /loans/eligibility | instant-loan schema | TC-FE-LOAN-004 | - | NOT STARTED |
| LOAN-APP-004 | S-LOAN-005 | POST /loans/applications | instant-loan schema | TC-FE-LOAN-005 | - | NOT STARTED |
| LOAN-APP-005 | S-LOAN-005, S-LOAN-012 | GET /loans/eligibility; POST /loans/applications | instant-loan schema | - | - | NOT STARTED |
| LOAN-APP-006 | - | - | instant-loan schema | TC-FE-LOAN-008 | - | NOT STARTED |
| LOAN-DIS-001 | S-LOAN-006 | POST /loans/applications | instant-loan schema | - | TC-BE-LOAN-004 | NOT STARTED |
| LOAN-DIS-002 | S-LOAN-007 | GET /loans/{loanId} | instant-loan schema | - | TC-BE-LOAN-005 | NOT STARTED |
| LOAN-REP-001 | S-LOAN-008, S-LOAN-009 | POST /loans/{loanId}/repayments; PUT /loans/{loanId}/auto-repay | instant-loan schema | TC-FE-LOAN-006 | - | NOT STARTED |
| LOAN-REP-002 | S-LOAN-008 | POST /loans/{loanId}/repayments | instant-loan schema | - | - | NOT STARTED |
| LOAN-REP-003 | S-LOAN-007 | GET /loans/{loanId} | instant-loan schema | - | - | NOT STARTED |
| LOAN-REP-004 | S-LOAN-011 | GET /loans | instant-loan schema | - | - | NOT STARTED |
| LOAN-ARR-001 | W-LOAN-002 | GET /backoffice/loans/portfolio | instant-loan schema | - | TC-BE-LOAN-007 | NOT STARTED |
| LOAN-ARR-002 | S-LOAN-010 | POST /loans/{loanId}/hardship | instant-loan schema | TC-FE-LOAN-007 | - | NOT STARTED |
| LOAN-ARR-003 | W-LOAN-002 | GET /backoffice/loans/portfolio | instant-loan schema | - | TC-BE-LOAN-008 | NOT STARTED |
| LOAN-ARR-004 | - | - | instant-loan schema | - | - | NOT STARTED |
| LOAN-PRT-001 | W-LOAN-004 | GET /backoffice/loans/settlements; POST /backoffice/loans/settlements/{id}/approve | instant-loan schema | - | - | NOT STARTED |
| LOAN-PRT-002 | W-LOAN-004 | GET /backoffice/loans/settlements; POST /backoffice/loans/settlements/{id}/approve | instant-loan schema | - | TC-BE-LOAN-010 | NOT STARTED |
| LOAN-PRT-003 | W-LOAN-002 | GET /backoffice/loans/portfolio | instant-loan schema | - | - | NOT STARTED |
| LOAN-CMP-001 | - | - | instant-loan schema | - | - | NOT STARTED |
| COOP-SET-001 | S-COOP-001, S-COOP-002 | GET /cooperatives; POST /cooperatives; POST /cooperatives/{id}/documents | cooperative schema | TC-FE-COOP-001 | - | NOT STARTED |
| COOP-SET-002 | S-COOP-002 | POST /cooperatives; POST /cooperatives/{id}/documents | cooperative schema | - | TC-BE-COOP-001 | NOT STARTED |
| COOP-SET-003 | S-COOP-002, W-COOP-014 | POST /cooperatives; POST /cooperatives/{id}/documents | cooperative schema | TC-FE-COOP-002 | - | NOT STARTED |
| COOP-SET-004 | S-COOP-002, W-COOP-009 | POST /cooperative/admins; POST /cooperative/admins/succession; POST /cooperatives ... | cooperative schema | - | TC-BE-COOP-002 | NOT STARTED |
| COOP-SET-005 | W-COOP-009 | POST /cooperative/admins; POST /cooperative/admins/succession | cooperative schema | - | - | NOT STARTED |
| COOP-SET-006 | W-COOP-008 | GET /cooperative/rules; POST /cooperative/rules | cooperative schema | - | TC-BE-COOP-003 | NOT STARTED |
| COOP-SET-007 | W-COOP-008 | GET /cooperative/rules; POST /cooperative/rules | cooperative schema | TC-FE-COOP-014 | - | NOT STARTED |
| COOP-SET-008 | W-COOP-009 | POST /cooperative/admins; POST /cooperative/admins/succession | cooperative schema | - | TC-BE-COOP-018 | NOT STARTED |
| COOP-SET-009 | - | - | cooperative schema | - | - | NOT STARTED |
| COOP-MEM-001 | S-COOP-001, S-COOP-003 | GET /cooperatives; GET /cooperatives/by-code/{code}; POST /cooperative/join-requests | cooperative schema | TC-FE-COOP-003 | - | NOT STARTED |
| COOP-MEM-002 | S-COOP-017, W-COOP-003 | GET /cooperative/join-requests; GET /cooperative/loan-applications; POST /cooperative/join-requests/{requestId}/decision ... | cooperative schema | - | - | NOT STARTED |
| COOP-MEM-003 | W-COOP-002 | GET /cooperative/members; POST /cooperative/members/{memberId}/suspend | cooperative schema | - | - | NOT STARTED |
| COOP-MEM-004 | S-COOP-016 | POST /cooperative/leave | cooperative schema | - | TC-BE-COOP-022 | NOT STARTED |
| COOP-MEM-005 | W-COOP-002 | GET /cooperative/members; POST /cooperative/members/{memberId}/suspend | cooperative schema | - | - | NOT STARTED |
| COOP-MEM-006 | - | - | cooperative schema | - | - | NOT STARTED |
| COOP-CON-001 | W-COOP-004 | GET /cooperative/arrears; GET /cooperative/plans; POST /cooperative/plans | cooperative schema | - | - | NOT STARTED |
| COOP-CON-002 | S-COOP-005, S-COOP-006 | GET /cooperative/dues; GET /cooperative/plans; POST /cooperative/contributions ... | cooperative schema | TC-FE-COOP-004, TC-FE-COOP-005 | TC-BE-COOP-006 | NOT STARTED |
| COOP-CON-003 | S-COOP-005 | GET /cooperative/dues; GET /cooperative/plans; PUT /cooperative/plans/{planId}/auto-deduct | cooperative schema | TC-FE-COOP-006 | TC-BE-COOP-004 | NOT STARTED |
| COOP-CON-004 | S-COOP-006 | POST /cooperative/contributions | cooperative schema | - | TC-BE-COOP-005 | NOT STARTED |
| COOP-CON-005 | S-COOP-004, S-COOP-014 | GET /cooperative/overview; GET /cooperative/statement; POST /cooperative/report-concern | cooperative schema | - | - | NOT STARTED |
| COOP-CON-006 | W-COOP-004 | GET /cooperative/arrears; GET /cooperative/plans; POST /cooperative/plans | cooperative schema | - | - | NOT STARTED |
| COOP-SHR-001 | W-COOP-007 | POST /cooperative/dividend-runs; POST /cooperative/dividend-runs/{runId}/approve; PUT /cooperative/share-policy | cooperative schema | - | - | NOT STARTED |
| COOP-SHR-002 | S-COOP-007 | GET /cooperative/shares/me | cooperative schema | - | - | NOT STARTED |
| COOP-SHR-003 | W-COOP-007 | POST /cooperative/dividend-runs; POST /cooperative/dividend-runs/{runId}/approve; PUT /cooperative/share-policy | cooperative schema | - | TC-BE-COOP-019 | NOT STARTED |
| COOP-SHR-004 | - | - | cooperative schema | - | - | NOT STARTED |
| COOP-LON-001 | S-COOP-008 | GET /cooperative/guarantees; GET /cooperative/loans/eligibility | cooperative schema | TC-FE-COOP-007 | TC-BE-COOP-007 | NOT STARTED |
| COOP-LON-002 | S-COOP-004, S-COOP-009 | GET /cooperative/loans/eligibility; GET /cooperative/overview; POST /cooperative/loan-applications/preview ... | cooperative schema | - | - | NOT STARTED |
| COOP-LON-003 | S-COOP-010 | POST /cooperative/loan-applications | cooperative schema | TC-FE-COOP-009 | TC-BE-COOP-008, TC-BE-COOP-009, TC-BE-COOP-010 | NOT STARTED |
| COOP-LON-004 | S-COOP-011 | GET /cooperative/guarantees; POST /cooperative/guarantees/{guaranteeId}/respond | cooperative schema | TC-FE-COOP-010 | - | NOT STARTED |
| COOP-LON-005 | S-COOP-017, W-COOP-005 | GET /cooperative/join-requests; GET /cooperative/loan-applications; POST /cooperative/join-requests/{requestId}/decision ... | cooperative schema | TC-FE-COOP-011 | TC-BE-COOP-011 | NOT STARTED |
| COOP-LON-006 | - | - | cooperative schema | - | TC-BE-COOP-012 | NOT STARTED |
| COOP-LON-007 | - | - | cooperative schema | - | - | NOT STARTED |
| COOP-LON-008 | S-COOP-012, S-COOP-013 | GET /cooperative/loans/{loanId}; POST /cooperative/loans/{loanId}/repayments | cooperative schema | TC-FE-COOP-012 | TC-BE-COOP-013 | NOT STARTED |
| COOP-LON-009 | W-COOP-006 | POST /cooperative/loans/{loanId}/recovery | cooperative schema | - | TC-BE-COOP-014 | NOT STARTED |
| COOP-LON-010 | - | - | cooperative schema | - | TC-BE-COOP-015 | NOT STARTED |
| COOP-LON-011 | S-COOP-009 | GET /cooperative/loans/eligibility; POST /cooperative/loan-applications/preview | cooperative schema | TC-FE-COOP-008 | - | NOT STARTED |
| COOP-LON-012 | - | - | cooperative schema | - | - | NOT STARTED |
| COOP-BOK-001 | W-COOP-001 | GET /cooperative/dashboard | cooperative schema | - | - | NOT STARTED |
| COOP-BOK-002 | W-COOP-010 | GET /cooperative/reports/{type} | cooperative schema | - | TC-BE-COOP-021 | NOT STARTED |
| COOP-BOK-003 | W-COOP-011 | POST /cooperative/withdrawals; POST /cooperative/withdrawals/{withdrawalId}/approve | cooperative schema | TC-FE-COOP-013 | TC-BE-COOP-016, TC-BE-COOP-017 | NOT STARTED |
| COOP-BOK-004 | W-COOP-010 | GET /cooperative/reports/{type} | cooperative schema | - | - | NOT STARTED |
| COOP-BOK-005 | W-COOP-013 | GET /cooperative/audit | cooperative schema | - | - | NOT STARTED |
| COOP-SOC-001 | S-COOP-015, W-COOP-012 | GET /cooperative/announcements; POST /cooperative/announcements; POST /cooperative/meetings | cooperative schema | - | - | NOT STARTED |
| COOP-SOC-002 | S-COOP-015, W-COOP-012 | GET /cooperative/announcements; POST /cooperative/announcements; POST /cooperative/meetings | cooperative schema | - | - | NOT STARTED |
| COOP-SOC-003 | - | - | cooperative schema | - | - | NOT STARTED |
| COOP-SOC-004 | - | - | cooperative schema | - | - | NOT STARTED |
| COOP-PLT-001 | - | - | cooperative schema | - | - | NOT STARTED |
| COOP-PLT-002 | - | - | cooperative schema | - | - | NOT STARTED |
| COOP-PLT-003 | - | - | cooperative schema | TC-FE-COOP-015 | TC-BE-COOP-020 | NOT STARTED |
| AJO-SET-001 | S-AJO-001, S-AJO-002 | GET /ajo/circles; POST /ajo/circles | ajo-esusu schema | TC-FE-AJO-001 | - | NOT STARTED |
| AJO-SET-002 | S-AJO-002 | POST /ajo/circles | ajo-esusu schema | TC-FE-AJO-002 | - | NOT STARTED |
| AJO-SET-003 | - | - | ajo-esusu schema | - | TC-BE-AJO-001 | NOT STARTED |
| AJO-SET-004 | - | - | ajo-esusu schema | - | TC-BE-AJO-005 | NOT STARTED |
| AJO-SET-005 | S-AJO-004 | GET /ajo/circles/by-code/{code}; POST /ajo/join | ajo-esusu schema | TC-FE-AJO-003 | - | NOT STARTED |
| AJO-SET-006 | W-AJO-001 | GET /ajo/circle; GET /ajo/circle/members | ajo-esusu schema | - | TC-BE-AJO-003 | NOT STARTED |
| AJO-SET-007 | - | - | ajo-esusu schema | - | TC-BE-AJO-014 | NOT STARTED |
| AJO-MEM-001 | S-AJO-001, S-AJO-003, S-AJO-004 | GET /ajo/circles; GET /ajo/circles/by-code/{code}; POST /ajo/circle/cancel ... | ajo-esusu schema | - | - | NOT STARTED |
| AJO-MEM-002 | - | - | ajo-esusu schema | - | - | NOT STARTED |
| AJO-MEM-003 | S-AJO-012 | GET /ajo/circle/members | ajo-esusu schema | - | - | NOT STARTED |
| AJO-MEM-004 | - | - | ajo-esusu schema | - | - | NOT STARTED |
| AJO-ORD-001 | S-AJO-002, S-AJO-010 | POST /ajo/circle/order/confirm; POST /ajo/circle/order/draw; POST /ajo/circles ... | ajo-esusu schema | TC-FE-AJO-006 | TC-BE-AJO-004 | NOT STARTED |
| AJO-ORD-002 | S-AJO-010 | POST /ajo/circle/order/confirm; POST /ajo/circle/order/draw; PUT /ajo/circle/order/choice | ajo-esusu schema | - | - | NOT STARTED |
| AJO-ORD-003 | - | - | ajo-esusu schema | - | - | NOT STARTED |
| AJO-CON-001 | S-AJO-006, S-AJO-007 | GET /ajo/circle/schedule; POST /ajo/circle/contributions; PUT /ajo/circle/auto-debit | ajo-esusu schema | - | - | NOT STARTED |
| AJO-CON-002 | S-AJO-007 | POST /ajo/circle/contributions; PUT /ajo/circle/auto-debit | ajo-esusu schema | TC-FE-AJO-008 | - | NOT STARTED |
| AJO-CON-003 | - | - | ajo-esusu schema | - | TC-BE-AJO-007 | NOT STARTED |
| AJO-CON-004 | - | - | ajo-esusu schema | - | - | NOT STARTED |
| AJO-CON-005 | S-AJO-011 | GET /ajo/circle/rounds/{roundNo} | ajo-esusu schema | - | TC-BE-AJO-008 | NOT STARTED |
| AJO-CON-006 | - | - | ajo-esusu schema | TC-FE-AJO-009 | TC-BE-AJO-009 | NOT STARTED |
| AJO-CON-007 | S-AJO-005, W-AJO-001 | GET /ajo/circle; GET /ajo/circle/members | ajo-esusu schema | TC-FE-AJO-007 | - | NOT STARTED |
| AJO-PRO-001 | S-AJO-008 | POST /ajo/circle/cover/deposit; POST /ajo/circle/cover/guarantor | ajo-esusu schema | TC-FE-AJO-004 | TC-BE-AJO-006 | NOT STARTED |
| AJO-PRO-002 | S-AJO-009 | GET /ajo/guarantees; POST /ajo/guarantees/{guaranteeId}/respond | ajo-esusu schema | TC-FE-AJO-005 | - | NOT STARTED |
| AJO-PRO-003 | - | - | ajo-esusu schema | - | - | NOT STARTED |
| AJO-PRO-004 | - | - | ajo-esusu schema | - | - | NOT STARTED |
| AJO-PRO-005 | - | - | ajo-esusu schema | - | TC-BE-AJO-016 | NOT STARTED |
| AJO-DEL-001 | - | - | ajo-esusu schema | - | - | NOT STARTED |
| AJO-DEL-002 | - | - | ajo-esusu schema | - | TC-BE-AJO-012 | NOT STARTED |
| AJO-DEL-003 | S-AJO-012 | GET /ajo/circle/members | ajo-esusu schema | - | - | NOT STARTED |
| AJO-END-001 | S-AJO-014 | GET /ajo/circle/summary; POST /ajo/circle/renew | ajo-esusu schema | TC-FE-AJO-010 | - | NOT STARTED |
| AJO-END-002 | - | - | ajo-esusu schema | - | TC-BE-AJO-015 | NOT STARTED |
| AJO-END-003 | S-AJO-011 | GET /ajo/circle/rounds/{roundNo} | ajo-esusu schema | - | - | NOT STARTED |
| AJO-PLT-001 | - | - | ajo-esusu schema | - | - | NOT STARTED |
| AJO-PLT-002 | S-AJO-013 | POST /ajo/circle/report | ajo-esusu schema | - | TC-BE-AJO-017 | NOT STARTED |
| PAS-VEN-001 | W-PAS-007 | POST /pas/vendors | pay-am-small schema | - | - | NOT STARTED |
| PAS-VEN-002 | W-PAS-007 | POST /pas/vendors | pay-am-small schema | - | TC-BE-PAS-012 | NOT STARTED |
| PAS-VEN-003 | W-PAS-002 | POST /pas/vendor/products | pay-am-small schema | - | - | NOT STARTED |
| PAS-VEN-004 | W-PAS-002 | POST /pas/vendor/products | pay-am-small schema | TC-FE-PAS-008 | TC-BE-PAS-002 | NOT STARTED |
| PAS-VEN-005 | W-PAS-004 | GET /pas/vendor/plans | pay-am-small schema | - | - | NOT STARTED |
| PAS-VEN-006 | W-PAS-001 | - | pay-am-small schema | - | - | NOT STARTED |
| PAS-BUY-001 | S-PAS-001, S-PAS-012 | GET /pas/products | pay-am-small schema | - | - | NOT STARTED |
| PAS-BUY-002 | S-PAS-002 | GET /pas/products/{productId} | pay-am-small schema | - | - | NOT STARTED |
| PAS-BUY-003 | S-PAS-003, S-PAS-004 | POST /pas/plans; POST /pas/plans/quote | pay-am-small schema | TC-FE-PAS-001 | - | NOT STARTED |
| PAS-BUY-004 | S-PAS-003, S-PAS-005 | GET /pas/plans; POST /pas/plans/quote | pay-am-small schema | TC-FE-PAS-002 | - | NOT STARTED |
| PAS-BUY-005 | S-PAS-010 | GET /pas/orders/{orderId} | pay-am-small schema | - | - | NOT STARTED |
| PAS-VLT-001 | S-PAS-006, S-PAS-007 | GET /pas/plans/{planId}; POST /pas/plans/{planId}/topups; PUT /pas/plans/{planId}/auto-debit | pay-am-small schema | TC-FE-PAS-003 | TC-BE-PAS-003 | NOT STARTED |
| PAS-VLT-002 | S-PAS-006 | GET /pas/plans/{planId}; PUT /pas/plans/{planId}/auto-debit | pay-am-small schema | - | TC-BE-PAS-004 | NOT STARTED |
| PAS-VLT-003 | S-PAS-008 | POST /pas/plans/{planId}/withdrawal | pay-am-small schema | TC-FE-PAS-005 | TC-BE-PAS-005 | NOT STARTED |
| PAS-VLT-004 | S-PAS-009 | POST /pas/plans/{planId}/deadline-decision | pay-am-small schema | TC-FE-PAS-004 | TC-BE-PAS-006 | NOT STARTED |
| PAS-VLT-005 | W-PAS-006 | GET /pas/vendor/payouts | pay-am-small schema | - | TC-BE-PAS-007 | NOT STARTED |
| PAS-VLT-006 | W-PAS-006 | GET /pas/vendor/payouts | pay-am-small schema | - | TC-BE-PAS-008 | NOT STARTED |
| PAS-VLT-007 | - | - | pay-am-small schema | - | TC-BE-PAS-009 | NOT STARTED |
| PAS-CRD-001 | W-PAS-005 | POST /pas/vendor/credit-requests/{id}/decision | pay-am-small schema | - | - | NOT STARTED |
| PAS-CRD-002 | S-PAS-011 | GET /pas/plans/{planId}; POST /pas/plans/{planId}/repayments | pay-am-small schema | TC-FE-PAS-007 | TC-BE-PAS-011 | NOT STARTED |
| PAS-CRD-003 | - | - | pay-am-small schema | - | - | NOT STARTED |
| PAS-CRD-004 | - | - | pay-am-small schema | - | TC-BE-PAS-010 | NOT STARTED |
| PAS-ORD-001 | S-PAS-010, W-PAS-003 | GET /pas/orders/{orderId}; POST /pas/vendor/orders/{orderId}/delivered | pay-am-small schema | TC-FE-PAS-006 | - | NOT STARTED |
| PAS-ORD-002 | - | - | pay-am-small schema | - | - | NOT STARTED |
| PAS-ORD-003 | S-PAS-013 | POST /pas/orders/{orderId}/report | pay-am-small schema | - | - | NOT STARTED |
| PAS-PLT-001 | - | - | pay-am-small schema | - | - | NOT STARTED |
| PAS-PLT-002 | - | - | pay-am-small schema | - | - | NOT STARTED |
| ESC-DEA-001 | S-ESC-001, S-ESC-002 | GET /escrow/deals; POST /escrow/deals | escrow schema | - | - | NOT STARTED |
| ESC-DEA-002 | S-ESC-004, S-ESC-005 | POST /escrow/deals/{dealId}/accept; POST /escrow/deals/{dealId}/invite; PUT /escrow/deals/{dealId}/terms | escrow schema | TC-FE-ESC-002 | - | NOT STARTED |
| ESC-DEA-003 | S-ESC-003 | PUT /escrow/deals/{dealId}/terms | escrow schema | - | TC-BE-ESC-003 | NOT STARTED |
| ESC-DEA-004 | S-ESC-003, S-ESC-012 | POST /escrow/deals/{dealId}/cancel; PUT /escrow/deals/{dealId}/terms | escrow schema | TC-FE-ESC-001, TC-FE-ESC-007 | TC-BE-ESC-004 | NOT STARTED |
| ESC-DEA-005 | S-ESC-003 | PUT /escrow/deals/{dealId}/terms | escrow schema | - | TC-BE-ESC-005 | NOT STARTED |
| ESC-DEA-006 | - | - | escrow schema | - | - | NOT STARTED |
| ESC-DEA-007 | S-ESC-002, W-ESC-004 | POST /escrow/deals; PUT /backoffice/escrow/templates/{type} | escrow schema | - | - | NOT STARTED |
| ESC-FND-001 | - | - | escrow schema | - | - | NOT STARTED |
| ESC-FND-002 | S-ESC-006 | POST /escrow/deals/{dealId}/fund | escrow schema | TC-FE-ESC-003 | - | NOT STARTED |
| ESC-FND-003 | - | - | escrow schema | - | TC-BE-ESC-002 | NOT STARTED |
| ESC-REL-001 | S-ESC-008 | POST /escrow/deals/{dealId}/deliver | escrow schema | - | TC-BE-ESC-006 | NOT STARTED |
| ESC-REL-002 | S-ESC-008 | POST /escrow/deals/{dealId}/deliver | escrow schema | TC-FE-ESC-004 | - | NOT STARTED |
| ESC-REL-003 | - | - | escrow schema | TC-FE-ESC-008 | - | NOT STARTED |
| ESC-REL-004 | S-ESC-009 | POST /escrow/deals/{dealId}/confirm | escrow schema | TC-FE-ESC-005 | TC-BE-ESC-012 | NOT STARTED |
| ESC-REL-005 | W-ESC-004 | PUT /backoffice/escrow/templates/{type} | escrow schema | - | - | NOT STARTED |
| ESC-DSP-001 | S-ESC-010 | POST /escrow/deals/{dealId}/disputes | escrow schema | TC-FE-ESC-006 | TC-BE-ESC-008 | NOT STARTED |
| ESC-DSP-002 | S-ESC-010 | POST /escrow/deals/{dealId}/disputes | escrow schema | - | - | NOT STARTED |
| ESC-DSP-003 | S-ESC-011, W-ESC-003 | GET /escrow/deals/{dealId}/disputes/current; POST /backoffice/escrow/disputes/{id}/decision; POST /escrow/deals/{dealId}/disputes/appeal | escrow schema | - | TC-BE-ESC-009, TC-BE-ESC-010 | NOT STARTED |
| ESC-DSP-004 | - | - | escrow schema | - | - | NOT STARTED |
| ESC-DSP-005 | W-ESC-002, W-ESC-003 | GET /backoffice/escrow/disputes; POST /backoffice/escrow/disputes/{id}/decision | escrow schema | - | - | NOT STARTED |
| ESC-TRU-001 | - | - | escrow schema | - | - | NOT STARTED |
| ESC-TRU-002 | - | - | escrow schema | - | - | NOT STARTED |
| ESC-TRU-003 | S-ESC-007, S-ESC-013 | GET /escrow/deals/{dealId}; POST /escrow/deals/{dealId}/messages | escrow schema | - | - | NOT STARTED |
| ESC-TRU-004 | - | - | escrow schema | - | TC-BE-ESC-011 | NOT STARTED |
| ESC-TRU-005 | W-ESC-001 | GET /escrow/deals | escrow schema | - | - | NOT STARTED |
| REV-COL-001 | - | - | revenue schema | - | - | NOT STARTED |
| REV-COL-002 | W-REV-008 | POST /revenue/collectors | revenue schema | - | - | NOT STARTED |
| REV-COL-003 | W-REV-008 | POST /revenue/collectors | revenue schema | - | - | NOT STARTED |
| REV-COL-004 | - | - | revenue schema | - | TC-BE-REV-010 | NOT STARTED |
| REV-ITM-001 | W-REV-002 | POST /revenue/items | revenue schema | - | - | NOT STARTED |
| REV-ITM-002 | W-REV-003 | GET /revenue/payers; POST /revenue/payers/import | revenue schema | TC-FE-REV-006 | - | NOT STARTED |
| REV-ITM-003 | - | - | revenue schema | - | TC-BE-REV-002 | NOT STARTED |
| REV-ITM-004 | - | - | revenue schema | - | - | NOT STARTED |
| REV-PAY-001 | S-REV-001, S-REV-002, S-REV-007 | GET /dues; GET /dues/{billId}; POST /dues/{billId}/payments ... | revenue schema | TC-FE-REV-001 | TC-BE-REV-003 | NOT STARTED |
| REV-PAY-002 | - | - | revenue schema | - | TC-BE-REV-004 | NOT STARTED |
| REV-PAY-003 | - | - | revenue schema | - | - | NOT STARTED |
| REV-PAY-004 | S-REV-009, S-REV-010, W-REV-005 | POST /revenue/cash | revenue schema | TC-FE-REV-005 | - | NOT STARTED |
| REV-PAY-005 | S-REV-004 | GET /dues/receipts | revenue schema | - | - | NOT STARTED |
| REV-PAY-006 | - | - | revenue schema | - | - | NOT STARTED |
| REV-PAY-007 | S-REV-003 | POST /dues/links/accept | revenue schema | TC-FE-REV-003 | - | NOT STARTED |
| REV-PAY-008 | S-REV-006 | - | revenue schema | - | - | NOT STARTED |
| REV-REC-001 | W-REV-004 | GET /revenue/payments | revenue schema | - | TC-BE-REV-005 | NOT STARTED |
| REV-REC-002 | W-REV-006 | PUT /revenue/fee-model | revenue schema | - | - | NOT STARTED |
| REV-REC-003 | W-REV-001, W-REV-007 | GET /revenue/dashboard; GET /revenue/reports/{type} | revenue schema | - | - | NOT STARTED |
| REV-REC-004 | W-REV-007 | GET /revenue/reports/{type} | revenue schema | - | - | NOT STARTED |
| REV-FEE-001 | S-REV-002, W-REV-006 | GET /dues/{billId}; POST /dues/{billId}/payments; PUT /revenue/fee-model | revenue schema | TC-FE-REV-002, TC-FE-REV-007 | TC-BE-REV-007 | NOT STARTED |
| REV-FEE-002 | - | - | revenue schema | - | - | NOT STARTED |
| REV-SAF-001 | S-REV-005 | POST /dues/{billId}/dispute | revenue schema | TC-FE-REV-004 | - | NOT STARTED |
| REV-SAF-002 | S-REV-008 | POST /dues/collectors/{collectorId}/report | revenue schema | - | - | NOT STARTED |
| REV-SAF-003 | - | - | revenue schema | - | TC-BE-REV-008 | NOT STARTED |
| REV-GOV-001 | - | - | revenue schema | - | - | NOT STARTED |
| REV-GOV-002 | - | - | revenue schema | - | - | NOT STARTED |
| TGT-GOL-001 | S-TGT-001, S-TGT-002 | GET /targets; POST /targets | target-savings schema | - | - | NOT STARTED |
| TGT-GOL-002 | S-TGT-002 | POST /targets | target-savings schema | TC-FE-TGT-001 | - | NOT STARTED |
| TGT-GOL-003 | S-TGT-007 | PATCH /targets/{goalId}; POST /targets/{goalId}/close | target-savings schema | - | - | NOT STARTED |
| TGT-GOL-004 | S-TGT-007 | PATCH /targets/{goalId}; POST /targets/{goalId}/close | target-savings schema | - | TC-BE-TGT-007 | NOT STARTED |
| TGT-GOL-005 | - | - | target-savings schema | - | - | NOT STARTED |
| TGT-FUN-001 | S-TGT-004 | POST /targets/{goalId}/topups | target-savings schema | - | - | NOT STARTED |
| TGT-FUN-002 | S-TGT-005 | PUT /targets/{goalId}/auto-save | target-savings schema | TC-FE-TGT-005 | TC-BE-TGT-005 | NOT STARTED |
| TGT-FUN-003 | S-TGT-009 | PUT /targets/rules | target-savings schema | - | TC-BE-TGT-006 | NOT STARTED |
| TGT-FUN-004 | - | - | target-savings schema | - | - | NOT STARTED |
| TGT-LCK-001 | S-TGT-002 | POST /targets | target-savings schema | TC-FE-TGT-002 | - | NOT STARTED |
| TGT-LCK-002 | S-TGT-006 | POST /targets/{goalId}/withdrawals; POST /targets/{goalId}/withdrawals/quote | target-savings schema | TC-FE-TGT-004 | TC-BE-TGT-003 | NOT STARTED |
| TGT-LCK-003 | S-TGT-006 | POST /targets/{goalId}/withdrawals; POST /targets/{goalId}/withdrawals/quote | target-savings schema | TC-FE-TGT-006 | TC-BE-TGT-004 | NOT STARTED |
| TGT-LCK-004 | - | - | target-savings schema | - | - | NOT STARTED |
| TGT-UX-001 | S-TGT-001, S-TGT-003 | GET /targets; GET /targets/{goalId}; POST /targets/{goalId}/rollover | target-savings schema | TC-FE-TGT-003 | - | NOT STARTED |
| TGT-UX-002 | S-TGT-008 | GET /targets/{goalId}/whatif | target-savings schema | - | - | NOT STARTED |
| TGT-UX-003 | - | - | target-savings schema | - | - | NOT STARTED |
| TGT-UX-004 | S-TGT-003 | GET /targets/{goalId}; POST /targets/{goalId}/rollover | target-savings schema | - | - | NOT STARTED |
| TGT-PLT-001 | - | - | target-savings schema | - | TC-BE-TGT-001, TC-BE-TGT-002 | NOT STARTED |
| TGT-PLT-002 | - | - | target-savings schema | - | - | NOT STARTED |
| MER-ACC-001 | S-MER-001, S-MER-002, W-MER-005 | GET /business/home; POST /business; POST /business/team | merchant-tools schema | - | - | NOT STARTED |
| MER-ACC-002 | S-MER-010, W-MER-005 | POST /business/team | merchant-tools schema | TC-FE-MER-005 | - | NOT STARTED |
| MER-ACC-003 | S-MER-008 | GET /business/transactions; POST /business/payouts | merchant-tools schema | - | - | NOT STARTED |
| MER-ACC-004 | - | - | merchant-tools schema | - | - | NOT STARTED |
| MER-PAY-001 | S-MER-003, W-MER-003 | GET /business/payment-requests; GET /pay/{reference}; POST /business/payment-requests ... | merchant-tools schema | TC-FE-MER-002 | - | NOT STARTED |
| MER-PAY-002 | S-MER-004 | POST /business/payment-requests | merchant-tools schema | TC-FE-MER-001 | TC-BE-MER-003 | NOT STARTED |
| MER-PAY-003 | - | - | merchant-tools schema | - | - | NOT STARTED |
| MER-PAY-004 | - | - | merchant-tools schema | - | - | NOT STARTED |
| MER-PAY-005 | S-MER-004, S-MER-007 | POST /business/payment-requests | merchant-tools schema | - | - | NOT STARTED |
| MER-INV-001 | S-MER-005, W-MER-002 | GET /business/invoices; POST /business/invoices | merchant-tools schema | - | - | NOT STARTED |
| MER-INV-002 | S-MER-006, W-MER-002 | GET /business/invoices; POST /business/invoices; POST /business/invoices/{invoiceId}/send | merchant-tools schema | TC-FE-MER-003 | TC-BE-MER-004 | NOT STARTED |
| MER-INV-003 | - | - | merchant-tools schema | - | - | NOT STARTED |
| MER-INV-004 | - | - | merchant-tools schema | - | - | NOT STARTED |
| MER-MON-001 | S-MER-009 | POST /business/payments/{paymentId}/refund | merchant-tools schema | TC-FE-MER-004 | TC-BE-MER-005 | NOT STARTED |
| MER-MON-002 | - | - | merchant-tools schema | - | TC-BE-MER-007 | NOT STARTED |
| MER-MON-003 | S-MER-001, S-MER-008, W-MER-001, W-MER-004 | GET /business/home; GET /business/reports/{type}; GET /business/transactions ... | merchant-tools schema | - | - | NOT STARTED |
| MER-MON-004 | - | - | merchant-tools schema | - | - | NOT STARTED |
| MER-SAF-001 | - | - | merchant-tools schema | - | TC-BE-MER-008 | NOT STARTED |
| MER-SAF-002 | - | - | merchant-tools schema | - | - | NOT STARTED |
| AGT-ONB-001 | S-AGT-007, W-AGT-001 | GET /backoffice/agents; POST /agents/apply; POST /backoffice/agents/{agentId}/decision | agent-network schema | TC-FE-AGT-005 | - | NOT STARTED |
| AGT-ONB-002 | - | - | agent-network schema | - | - | NOT STARTED |
| AGT-ONB-003 | - | - | agent-network schema | - | - | NOT STARTED |
| AGT-ONB-004 | W-AGT-001 | GET /backoffice/agents; POST /backoffice/agents/{agentId}/decision | agent-network schema | - | - | NOT STARTED |
| AGT-CIN-001 | S-AGT-002, S-AGT-011 | POST /agent/cash-in | agent-network schema | TC-FE-AGT-001 | TC-BE-AGT-002 | NOT STARTED |
| AGT-CIN-002 | - | - | agent-network schema | - | - | NOT STARTED |
| AGT-CIN-003 | W-AGT-003 | PUT /backoffice/agents/config | agent-network schema | - | - | NOT STARTED |
| AGT-COT-001 | S-AGT-012 | POST /agents/cash-out/requests; POST /agents/cash-out/requests/{id}/confirm | agent-network schema | - | - | NOT STARTED |
| AGT-COT-002 | S-AGT-003 | POST /agent/cash-out/redeem | agent-network schema | - | - | NOT STARTED |
| AGT-COT-003 | - | - | agent-network schema | TC-FE-AGT-002 | TC-BE-AGT-004 | NOT STARTED |
| AGT-COT-004 | S-AGT-012 | POST /agents/cash-out/requests; POST /agents/cash-out/requests/{id}/confirm | agent-network schema | - | - | NOT STARTED |
| AGT-FLT-001 | S-AGT-001, S-AGT-004 | GET /agent/home; POST /agent/float/topups | agent-network schema | TC-FE-AGT-003 | - | NOT STARTED |
| AGT-FLT-002 | S-AGT-006, W-AGT-002 | POST /agent/day-end | agent-network schema | - | - | NOT STARTED |
| AGT-FLT-003 | S-AGT-001, S-AGT-005, W-AGT-003 | GET /agent/history; GET /agent/home; PUT /backoffice/agents/config | agent-network schema | - | TC-BE-AGT-005 | NOT STARTED |
| AGT-LOC-001 | S-AGT-010 | GET /agents/nearby | agent-network schema | TC-FE-AGT-004 | - | NOT STARTED |
| AGT-LOC-002 | S-AGT-013 | POST /agents/{agentId}/feedback | agent-network schema | - | - | NOT STARTED |
| AGT-RSK-001 | - | - | agent-network schema | - | TC-BE-AGT-007 | NOT STARTED |
| AGT-RSK-002 | - | - | agent-network schema | - | - | NOT STARTED |
| INS-CAT-001 | - | - | spending-insights-rewards schema | TC-FE-INS-001 | - | NOT STARTED |
| INS-CAT-002 | S-INS-001, S-INS-005 | GET /insights/summary | spending-insights-rewards schema | - | - | NOT STARTED |
| INS-CAT-003 | S-INS-001, S-INS-002 | GET /insights/categories/{categoryId}; GET /insights/summary; PUT /insights/transactions/{transactionId}/category | spending-insights-rewards schema | - | - | NOT STARTED |
| INS-CAT-004 | S-INS-009 | PUT /insights/preferences | spending-insights-rewards schema | - | - | NOT STARTED |
| INS-BUD-001 | S-INS-003, S-INS-004 | GET /insights/budgets; POST /insights/budgets | spending-insights-rewards schema | - | - | NOT STARTED |
| INS-BUD-002 | S-INS-004 | POST /insights/budgets | spending-insights-rewards schema | TC-FE-INS-002 | - | NOT STARTED |
| INS-BUD-003 | - | - | spending-insights-rewards schema | - | - | NOT STARTED |
| INS-RWD-001 | S-INS-006, S-INS-007 | GET /rewards | spending-insights-rewards schema | TC-FE-INS-005 | - | NOT STARTED |
| INS-RWD-002 | W-INS-001 | GET /backoffice/rewards/campaigns; POST /backoffice/rewards/campaigns | spending-insights-rewards schema | - | TC-BE-INS-004 | NOT STARTED |
| INS-RWD-003 | S-INS-006 | GET /rewards | spending-insights-rewards schema | - | - | NOT STARTED |
| INS-RWD-004 | W-INS-002 | GET /backoffice/rewards/budget | spending-insights-rewards schema | - | TC-BE-INS-005 | NOT STARTED |
| INS-RWD-005 | S-INS-007 | GET /rewards | spending-insights-rewards schema | - | - | NOT STARTED |
| INS-REF-001 | S-INS-008 | GET /rewards/referral; POST /rewards/referral/apply | spending-insights-rewards schema | - | - | NOT STARTED |
| INS-REF-002 | S-INS-008 | GET /rewards/referral; POST /rewards/referral/apply | spending-insights-rewards schema | TC-FE-INS-004 | - | NOT STARTED |
| INS-REF-003 | W-INS-003 | POST /backoffice/rewards/referrals/{id}/decision | spending-insights-rewards schema | - | TC-BE-INS-008 | NOT STARTED |
| INS-PRV-001 | S-INS-009 | PUT /insights/preferences | spending-insights-rewards schema | TC-FE-INS-003 | - | NOT STARTED |
| INS-PRV-002 | - | - | spending-insights-rewards schema | - | - | NOT STARTED |
