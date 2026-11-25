# API Consumption - Spending Insights and Rewards

Contract: `04_api_spec.yaml` in the back-end product folder (copy in this folder).

| Method | Path | Purpose | Used by screens | Idempotency-Key |
|---|---|---|---|---|
| GET | /insights/summary | Month summary and categories | S-INS-001, S-INS-005 | No |
| GET | /insights/categories/{categoryId} | Category detail | S-INS-002 | No |
| PUT | /insights/transactions/{transactionId}/category | Re-categorise | S-INS-002 | No |
| GET | /insights/budgets | List budgets | S-INS-003 | No |
| POST | /insights/budgets | Create budget | S-INS-004 | No |
| PUT | /insights/preferences | Update preferences and consent | S-INS-009 | No |
| GET | /rewards | Reward balance, campaigns, history | S-INS-006, S-INS-007 | No |
| GET | /rewards/referral | My referral code and list | S-INS-008 | No |
| POST | /rewards/referral/apply | Apply a referral code | S-INS-008 | No |
| GET | /backoffice/rewards/campaigns | Campaigns | W-INS-001 | No |
| POST | /backoffice/rewards/campaigns | Create campaign (dual control) | W-INS-001 | No |
| GET | /backoffice/rewards/budget | Budget and spend | W-INS-002 | No |
| POST | /backoffice/rewards/referrals/{id}/decision | Review referral | W-INS-003 | Yes |

All tenant-scoped calls send `X-Tenant-Id`. Money-moving calls send `Idempotency-Key` and `X-Pin-Token`.
