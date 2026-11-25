# Validation and Errors - Instant Loan

## Field validation
| Field | Rule | Message |
|---|---|---|
| Amount | within product min/max and customer limit | `loan.amount.range` |
| Tenor | one of product options | `loan.tenor.invalid` |
| Agreement acceptance | required before PIN | `loan.agreement.required` |
| Hardship reason | required, 5-300 chars | `loan.hardship.reason` |

## Server errors
| Code | User message | UI behaviour |
|---|---|---|
| LOAN_NOT_ELIGIBLE | You are not eligible right now. {reason} | Show reasons |
| LOAN_LIMIT_EXCEEDED | That is above your limit. | Stay |
| LOAN_ACTIVE_EXISTS | Please finish your current loan first. | Link to loan |
| LOAN_DECLINED | We cannot offer a loan right now. {reason} You can try again on {date}. | Result screen |
| LOAN_AGREEMENT_OUTDATED | The terms changed. Please review again. | Reload |
| LOAN_DISBURSEMENT_PENDING | Your loan is being processed. | Pending state |
