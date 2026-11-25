# Validation and Errors - Target Savings

## Field validation
| Field | Rule | Message |
|---|---|---|
| Goal name | 2-40 chars | `tgt.name.invalid` |
| Target amount | > 0 and within configured maximum | `tgt.target.invalid` |
| Deadline | future date, within maximum horizon | `tgt.date.invalid` |
| Contribution | > 0 and <= available balance when paying | `tgt.amount.invalid` |
| Withdrawal | <= goal balance; partial rules per mode | `tgt.withdraw.invalid` |

## Server errors
| Code | User message | UI behaviour |
|---|---|---|
| TGT_LIMIT_REACHED | You have reached the maximum number of goals. | Message |
| TGT_LOCKED | This goal is locked until {date}. Early withdrawal has a fee of {fee}. | Show penalty |
| TGT_COOLING_OFF | Your withdrawal is waiting for a short reflection period. | Countdown |
| TGT_INSUFFICIENT | Your balance is not enough for this top-up. | Stay |
