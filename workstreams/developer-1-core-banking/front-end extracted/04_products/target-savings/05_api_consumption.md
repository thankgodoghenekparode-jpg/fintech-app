# API Consumption - Target Savings

Contract: `04_api_spec.yaml` in the back-end product folder (copy in this folder).

| Method | Path | Purpose | Used by screens | Idempotency-Key |
|---|---|---|---|---|
| POST | /targets | Create goal | S-TGT-002 | Yes |
| GET | /targets | List goals | S-TGT-001 | No |
| GET | /targets/{goalId} | Goal detail and history | S-TGT-003 | No |
| PATCH | /targets/{goalId} | Edit goal or pause | S-TGT-007 | No |
| POST | /targets/{goalId}/topups | Top up a goal | S-TGT-004 | Yes |
| PUT | /targets/{goalId}/auto-save | Set auto-save (consent) | S-TGT-005 | Yes |
| POST | /targets/{goalId}/withdrawals/quote | Quote withdrawal (gross, penalty, net) | S-TGT-006 | No |
| POST | /targets/{goalId}/withdrawals | Withdraw (after quote) | S-TGT-006 | Yes |
| POST | /targets/{goalId}/close | Close goal | S-TGT-007 | Yes |
| POST | /targets/{goalId}/rollover | Roll matured goal into a new goal | S-TGT-003 | Yes |
| GET | /targets/{goalId}/whatif | What-if calculation | S-TGT-008 | No |
| PUT | /targets/rules | Percent-of-credit rule | S-TGT-009 | Yes |

All tenant-scoped calls send `X-Tenant-Id`. Money-moving calls send `Idempotency-Key` and `X-Pin-Token`.
