# API Consumption - Escrow

Contract: `04_api_spec.yaml` in the back-end product folder (copy in this folder).

| Method | Path | Purpose | Used by screens | Idempotency-Key |
|---|---|---|---|---|
| POST | /escrow/deals | Create deal | S-ESC-002 | No |
| GET | /escrow/deals | List my deals | S-ESC-001, W-ESC-001 | No |
| GET | /escrow/deals/{dealId} | Deal detail and next action | S-ESC-007 | No |
| PUT | /escrow/deals/{dealId}/terms | Propose fee and cancellation terms | S-ESC-003, S-ESC-004 | No |
| POST | /escrow/deals/{dealId}/invite | Invite counterparty | S-ESC-004 | No |
| POST | /escrow/deals/{dealId}/accept | Accept locked terms | S-ESC-005 | Yes |
| POST | /escrow/deals/{dealId}/fund | Fund deal | S-ESC-006 | Yes |
| POST | /escrow/deals/{dealId}/deliver | Submit delivery or milestone | S-ESC-008 | Yes |
| POST | /escrow/deals/{dealId}/confirm | Buyer confirms or approves | S-ESC-009 | Yes |
| POST | /escrow/deals/{dealId}/cancel | Cancel deal | S-ESC-012 | Yes |
| POST | /escrow/deals/{dealId}/disputes | Open dispute | S-ESC-010 | Yes |
| GET | /escrow/deals/{dealId}/disputes/current | Dispute status | S-ESC-011 | No |
| POST | /escrow/deals/{dealId}/disputes/appeal | Request appeal | S-ESC-011 | Yes |
| POST | /escrow/deals/{dealId}/messages | Send deal chat message | S-ESC-007 | No |
| GET | /backoffice/escrow/disputes | Dispute queue | W-ESC-002 | No |
| POST | /backoffice/escrow/disputes/{id}/decision | Decide dispute | W-ESC-003 | Yes |
| PUT | /backoffice/escrow/templates/{type} | Propose template change (dual control) | W-ESC-004 | No |

All tenant-scoped calls send `X-Tenant-Id`. Money-moving calls send `Idempotency-Key` and `X-Pin-Token`.
