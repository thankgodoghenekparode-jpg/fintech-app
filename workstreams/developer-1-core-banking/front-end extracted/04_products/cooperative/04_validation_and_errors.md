# Validation and Errors - Cooperative

## Field validation
| Field | Rule | Message |
|---|---|---|
| Cooperative name | 3-60 chars; unique per creator; no brand impersonation | `coop.name.invalid` |
| Principal admins | 2 or 3 | `coop.admins.count` |
| Contribution amount | > 0 kobo; within plan limits | `coop.plan.amount` |
| Loan amount | > 0 and <= rule maximum | `coop.loan.max` |
| Tenor | within rule options | `coop.loan.tenor` |
| Guarantors | exactly 3 distinct members; not the borrower | `coop.guarantors.invalid` |
| Guarantor cover | combined free savings >= multiplier x amount | `coop.guarantors.cover` |
| Share count | between min and max per member | `coop.shares.range` |
| Rejection reason | required, 5-300 chars | `coop.reason.required` |

## Server errors
| Code | User message | UI behaviour |
|---|---|---|
| COOP_NOT_MEMBER | You are not a member of this cooperative. | Return to list |
| COOP_NOT_ACTIVE | This cooperative is not active yet. | Show status |
| COOP_NOT_ELIGIBLE | You are not eligible for a loan yet. {reason} | Show reasons |
| COOP_GUARANTOR_INSUFFICIENT | Your guarantors do not yet cover enough savings. | Add guarantor |
| COOP_GUARANTOR_DECLINED | A guarantor declined. Choose another to continue. | Replace guarantor |
| COOP_RULES_PENDING | Rule changes are waiting for approval. | Banner |
| COOP_DUAL_APPROVAL_REQUIRED | A second admin must approve this. | Pending state |
| COOP_COOLING_OFF | This withdrawal is in its notice period. | Countdown |
| COOP_HAS_OBLIGATIONS | You still have a loan or guarantee. Resolve it first. | Show list |
