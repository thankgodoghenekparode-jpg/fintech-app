# API Consumption - Ajo / Esusu

Contract: `04_api_spec.yaml` in the back-end product folder (copy in this folder).

| Method | Path | Purpose | Used by screens | Idempotency-Key |
|---|---|---|---|---|
| POST | /ajo/circles | Create circle | S-AJO-002 | No |
| GET | /ajo/circles | List my circles | S-AJO-001 | No |
| GET | /ajo/circles/by-code/{code} | Preview a circle by code | S-AJO-004 | No |
| POST | /ajo/join | Join a circle (accept terms) | S-AJO-004 | Yes |
| GET | /ajo/circle | Circle detail, rounds and tracker | S-AJO-005, W-AJO-001 | No |
| GET | /ajo/circle/schedule | My schedule and slot | S-AJO-006 | No |
| POST | /ajo/circle/cancel | Cancel before start (refund) | S-AJO-003 | Yes |
| POST | /ajo/circle/order/draw | Run the random order draw | S-AJO-010 | Yes |
| PUT | /ajo/circle/order/choice | Choose or propose a slot | S-AJO-010 | No |
| POST | /ajo/circle/order/confirm | Confirm and lock order | S-AJO-010 | Yes |
| PUT | /ajo/circle/auto-debit | Enable or disable auto-debit (consent) | S-AJO-007 | Yes |
| POST | /ajo/circle/contributions | Pay a contribution early | S-AJO-007 | Yes |
| POST | /ajo/circle/cover/deposit | Fund a security deposit | S-AJO-008 | Yes |
| POST | /ajo/circle/cover/guarantor | Request a cover guarantor | S-AJO-008 | Yes |
| GET | /ajo/guarantees | My guarantee requests | S-AJO-009 | No |
| POST | /ajo/guarantees/{guaranteeId}/respond | Accept or decline guarantee | S-AJO-009 | Yes |
| GET | /ajo/circle/rounds/{roundNo} | Round detail | S-AJO-011 | No |
| GET | /ajo/circle/members | Roster with trust badges | S-AJO-012, W-AJO-001 | No |
| POST | /ajo/circle/report | Report a concern | S-AJO-013 | No |
| GET | /ajo/circle/summary | Cycle summary | S-AJO-014 | No |
| POST | /ajo/circle/renew | Create next circle from this group | S-AJO-014 | Yes |

All tenant-scoped calls send `X-Tenant-Id`. Money-moving calls send `Idempotency-Key` and `X-Pin-Token`.
