# Traceability Matrix - Back-office Addendum

Add these rows to the Back office section of `TRACEABILITY_MATRIX.md` (or keep this file beside it).

| Requirement | Screens | API | Tables | Tests | Status |
|---|---|---|---|---|---|
| BO-001 | W-BO-001 | /backoffice/me, auth | backoffice.staff_credentials | TC-BE-BO-001, TC-BE-BO-003 | NOT STARTED |
| BO-002 | W-BO-003 | /backoffice/customers/{id}/unmask | platform.audit_log | TC-BE-BO-020, TC-FE-BO-012 | NOT STARTED |
| BO-003 | W-BO-004 | /backoffice/kyc/* | backoffice.kyc_cases | - | NOT STARTED |
| BO-004 | W-BO-005 | /backoffice/transactions | payments.transactions | - | NOT STARTED |
| BO-005 | W-BO-006 | /backoffice/approvals | platform.approvals | - | NOT STARTED |
| BO-006 | W-BO-007 | /backoffice/config/{key} | platform.config_entries | - | NOT STARTED |
| BO-007 | W-BO-008 | /backoffice/alerts, cases | risk.alerts, risk.cases | - | NOT STARTED |
| BO-008 | W-BO-009 | /backoffice/tickets | support.tickets | - | NOT STARTED |
| BO-009 | W-BO-010 | /backoffice/reconciliation/* | reconciliation.runs, reconciliation.items | - | NOT STARTED |
| BO-010 | W-BO-011 | /backoffice/tenants/* | platform.tenants | - | NOT STARTED |
| BO-012 | W-BO-016 | /backoffice/reports/* | backoffice.report_definitions, report_runs | - | NOT STARTED |
| BO-013 | W-BO-017 | /backoffice/audit | platform.audit_log | - | NOT STARTED |
| BO-014 | W-BO-018 | /backoffice/staff | platform.staff_users | - | NOT STARTED |
| BO-015 | W-BO-019 | /backoffice/feature-flags | platform.feature_flags | - | NOT STARTED |
| BO-016 | W-BO-020 | status endpoints | - | - | NOT STARTED |
| BO-017 | W-BO-021 | /backoffice/me/* | backoffice.staff_credentials, staff_sessions | TC-BE-BO-001, TC-BE-BO-002, TC-FE-BO-001, TC-FE-BO-002 | NOT STARTED |
| BO-018 | W-BO-022 | /backoffice/access-reviews | backoffice.access_reviews, access_review_items | TC-BE-BO-004, TC-BE-BO-005, TC-FE-BO-003 | NOT STARTED |
| BO-019 | W-BO-023 | /backoffice/compliance/screening-hits | compliance.screening_hits | TC-BE-BO-006, TC-BE-BO-007, TC-FE-BO-004 | NOT STARTED |
| BO-020 | W-BO-024 | /backoffice/compliance/str, regulatory-reports | compliance.str_reports, regulatory_reports | TC-BE-BO-008, TC-BE-BO-009, TC-FE-BO-005 | NOT STARTED |
| BO-021 | W-BO-025 | /backoffice/finance/* | finance.daily_snapshots | TC-BE-BO-010, TC-FE-BO-006 | NOT STARTED |
| BO-022 | W-BO-026 | /backoffice/card-disputes | compliance.card_disputes | TC-BE-BO-011, TC-BE-BO-012, TC-FE-BO-007 | NOT STARTED |
| BO-023 | W-BO-027 | /backoffice/privacy/requests | compliance.dsr_requests | TC-BE-BO-013, TC-BE-BO-014, TC-FE-BO-008 | NOT STARTED |
| BO-024 | W-BO-028 | /backoffice/service-notices, notification-templates | backoffice.service_notices, notification_templates | TC-BE-BO-015, TC-BE-BO-016, TC-FE-BO-009 | NOT STARTED |
| BO-025 | W-BO-029 | /backoffice/complaints | compliance.complaints | TC-BE-BO-017, TC-FE-BO-010 | NOT STARTED |
| BO-026 | W-BO-030 | /backoffice/risk/blocklist | risk.blocklist | TC-BE-BO-018, TC-BE-BO-019, TC-FE-BO-011 | NOT STARTED |
