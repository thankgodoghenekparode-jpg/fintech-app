# API Consumption - Pay Am Small

Contract: `04_api_spec.yaml` in the back-end product folder (copy in this folder).

| Method | Path | Purpose | Used by screens | Idempotency-Key |
|---|---|---|---|---|
| POST | /pas/vendors | Open a store | W-PAS-007 | No |
| GET | /pas/products | Marketplace products | S-PAS-001, S-PAS-012 | No |
| GET | /pas/products/{productId} | Product detail | S-PAS-002 | No |
| POST | /pas/vendor/products | Create/update product | W-PAS-002 | No |
| POST | /pas/plans/quote | Plan summary and terms | S-PAS-003, S-PAS-004 | No |
| POST | /pas/plans | Start a plan (vault or credit) | S-PAS-004 | Yes |
| GET | /pas/plans | My plans | S-PAS-005 | No |
| GET | /pas/plans/{planId} | Plan detail | S-PAS-006, S-PAS-011 | No |
| POST | /pas/plans/{planId}/topups | Add money to vault | S-PAS-007 | Yes |
| PUT | /pas/plans/{planId}/auto-debit | Set auto-debit (consent) | S-PAS-006 | Yes |
| POST | /pas/plans/{planId}/withdrawal | Early withdrawal (quote then confirm) | S-PAS-008 | Yes |
| POST | /pas/plans/{planId}/deadline-decision | Extend or refund at deadline | S-PAS-009 | Yes |
| POST | /pas/plans/{planId}/repayments | Repay credit installment | S-PAS-011 | Yes |
| GET | /pas/orders/{orderId} | Order tracking and delivery code | S-PAS-010 | No |
| POST | /pas/vendor/orders/{orderId}/delivered | Confirm delivery with code | W-PAS-003 | Yes |
| GET | /pas/vendor/plans | Vendor view of plans and buyers | W-PAS-004 | No |
| POST | /pas/vendor/credit-requests/{id}/decision | Accept or decline a credit request | W-PAS-005 | Yes |
| GET | /pas/vendor/payouts | Payouts and holdback | W-PAS-006 | No |
| POST | /pas/orders/{orderId}/report | Report an order problem | S-PAS-013 | No |

All tenant-scoped calls send `X-Tenant-Id`. Money-moving calls send `Idempotency-Key` and `X-Pin-Token`.
