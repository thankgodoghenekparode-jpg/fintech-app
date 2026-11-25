# API Consumption - Revenue

Contract: `04_api_spec.yaml` in the back-end product folder (copy in this folder).

| Method | Path | Purpose | Used by screens | Idempotency-Key |
|---|---|---|---|---|
| POST | /revenue/collectors | Create collector | W-REV-008 | No |
| POST | /revenue/items | Create revenue item | W-REV-002 | No |
| POST | /revenue/payers/import | Import payers | W-REV-003 | Yes |
| GET | /revenue/payers | List payers | W-REV-003 | No |
| GET | /revenue/dashboard | Collector figures | W-REV-001 | No |
| GET | /revenue/payments | Payments and exceptions | W-REV-004 | No |
| PUT | /revenue/fee-model | Set fee model | W-REV-006 | Yes |
| POST | /revenue/cash | Record cash payment (field collector) | S-REV-010, S-REV-009 | Yes |
| GET | /revenue/reports/{type} | Reports | W-REV-007 | No |
| GET | /dues | My bills across collectors | S-REV-001 | No |
| GET | /dues/{billId} | Bill detail and fee quote | S-REV-002 | No |
| POST | /dues/{billId}/payments | Pay a bill in app | S-REV-002 | Yes |
| PUT | /dues/auto-pay | Set auto-pay (consent) | S-REV-007 | Yes |
| POST | /dues/links/accept | Accept payer link | S-REV-003 | No |
| POST | /dues/{billId}/dispute | This isn't mine | S-REV-005 | No |
| POST | /dues/collectors/{collectorId}/report | Report abuse | S-REV-008 | No |
| GET | /dues/receipts | Receipts | S-REV-004 | No |

All tenant-scoped calls send `X-Tenant-Id`. Money-moving calls send `Idempotency-Key` and `X-Pin-Token`.
