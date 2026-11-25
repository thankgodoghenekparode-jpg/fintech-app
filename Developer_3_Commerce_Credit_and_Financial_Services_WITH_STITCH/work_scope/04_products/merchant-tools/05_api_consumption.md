# API Consumption - Merchant and Small-Business Tools

Contract: `04_api_spec.yaml` in the back-end product folder (copy in this folder).

| Method | Path | Purpose | Used by screens | Idempotency-Key |
|---|---|---|---|---|
| POST | /business | Create business | S-MER-002 | No |
| GET | /business/home | Business home figures | S-MER-001, W-MER-001 | No |
| POST | /business/payment-requests | Create link or QR | S-MER-003, S-MER-004, S-MER-007, W-MER-003 | No |
| GET | /business/payment-requests | List links and QR | S-MER-003, W-MER-003 | No |
| POST | /business/invoices | Create invoice | S-MER-005, W-MER-002 | No |
| GET | /business/invoices | List invoices | S-MER-006, W-MER-002 | No |
| POST | /business/invoices/{invoiceId}/send | Send or remind | S-MER-006 | No |
| GET | /business/transactions | Payments and payouts | S-MER-008 | No |
| POST | /business/payouts | Request payout | S-MER-008 | Yes |
| POST | /business/payments/{paymentId}/refund | Refund | S-MER-009 | Yes |
| POST | /business/team | Add team member | S-MER-010, W-MER-005 | No |
| GET | /business/reports/{type} | Reports | W-MER-004 | No |
| GET | /pay/{reference} | Public: resolve a link/QR reference | S-MER-003 | No |
| POST | /pay/{reference}/pay | Pay a link or QR from the app | S-MER-003 | Yes |

All tenant-scoped calls send `X-Tenant-Id`. Money-moving calls send `Idempotency-Key` and `X-Pin-Token`.
