# API Consumption - Cash-in / Cash-out Agent Network

Contract: `04_api_spec.yaml` in the back-end product folder (copy in this folder).

| Method | Path | Purpose | Used by screens | Idempotency-Key |
|---|---|---|---|---|
| POST | /agents/apply | Apply to be an agent | S-AGT-007 | No |
| GET | /agent/home | Agent dashboard | S-AGT-001 | No |
| POST | /agent/cash-in | Cash-in for a customer | S-AGT-002 | Yes |
| POST | /agent/cash-out/redeem | Redeem a cash-out code | S-AGT-003 | Yes |
| POST | /agent/float/topups | Top up float | S-AGT-004 | Yes |
| GET | /agent/history | Transactions and commission | S-AGT-005 | No |
| POST | /agent/day-end | Submit day-end summary | S-AGT-006 | No |
| GET | /agents/nearby | Find agents | S-AGT-010 | No |
| POST | /agents/cash-out/requests | Request a cash-out code | S-AGT-012 | Yes |
| POST | /agents/cash-out/requests/{id}/confirm | Customer confirms cash-out | S-AGT-012 | Yes |
| POST | /agents/{agentId}/feedback | Rate or report an agent | S-AGT-013 | No |
| GET | /backoffice/agents | Agent applications and list | W-AGT-001 | No |
| POST | /backoffice/agents/{agentId}/decision | Approve, reject or suspend | W-AGT-001 | Yes |
| PUT | /backoffice/agents/config | Commission and limits (dual control) | W-AGT-003 | No |

All tenant-scoped calls send `X-Tenant-Id`. Money-moving calls send `Idempotency-Key` and `X-Pin-Token`.
