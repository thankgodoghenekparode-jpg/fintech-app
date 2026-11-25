# API Consumption - Instant Loan

Contract: `04_api_spec.yaml` in the back-end product folder (copy in this folder).

| Method | Path | Purpose | Used by screens | Idempotency-Key |
|---|---|---|---|---|
| GET | /loans/eligibility | Eligibility, limit and lender identity | S-LOAN-001, S-LOAN-002, S-LOAN-012 | No |
| POST | /loans/quote | Cost summary and affordability | S-LOAN-003, S-LOAN-004 | No |
| POST | /loans/applications | Submit application and accept agreement | S-LOAN-005, S-LOAN-006 | Yes |
| GET | /loans | My loans | S-LOAN-001, S-LOAN-011 | No |
| GET | /loans/{loanId} | Loan detail and schedule | S-LOAN-007 | No |
| POST | /loans/{loanId}/repayments | Repay | S-LOAN-008 | Yes |
| PUT | /loans/{loanId}/auto-repay | Set auto-repay (consent) | S-LOAN-009 | Yes |
| POST | /loans/{loanId}/hardship | Request hardship help | S-LOAN-010 | No |
| GET | /backoffice/loans/applications | Referred applications | W-LOAN-001 | No |
| POST | /backoffice/loans/applications/{id}/decision | Decide referred application | W-LOAN-001 | Yes |
| GET | /backoffice/loans/portfolio | Portfolio metrics and arrears | W-LOAN-002 | No |
| GET | /backoffice/loans/products | Products and versions | W-LOAN-003 | No |
| POST | /backoffice/loans/products | Propose product version (dual control) | W-LOAN-003 | No |
| GET | /backoffice/loans/settlements | Partner settlements | W-LOAN-004 | No |
| POST | /backoffice/loans/settlements/{id}/approve | Approve settlement (dual control) | W-LOAN-004 | Yes |

All tenant-scoped calls send `X-Tenant-Id`. Money-moving calls send `Idempotency-Key` and `X-Pin-Token`.
