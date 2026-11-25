# Validation and Errors - Spending Insights and Rewards

## Field validation
| Field | Rule | Message |
|---|---|---|
| Budget amount | > 0 kobo | `ins.budget.amount` |
| Alert threshold | between 50 and 100 percent | `ins.budget.threshold` |
| Referral code | valid, not own code | `ins.referral.invalid` |

## Server errors
| Code | User message | UI behaviour |
|---|---|---|
| INS_CONSENT_REQUIRED | Turn on personalised insights to see this. | Preferences |
| INS_CAMPAIGN_ENDED | This reward campaign has ended. | Message |
| INS_REFERRAL_INVALID | That referral code is not valid. | Message |
| INS_REWARD_PENDING | Your reward is on its way. | Info |
