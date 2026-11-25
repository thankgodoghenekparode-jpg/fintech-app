# Validation and Errors - Escrow

## Field validation
| Field | Rule | Message |
|---|---|---|
| Deal amount | > 0; within tier and type limits | `esc.amount.invalid` |
| Milestones | sum equals deal amount | `esc.milestones.sum` |
| Fee split | percentages total 100 | `esc.fee.split` |
| Evidence | file types and sizes limited | `esc.evidence.invalid` |
| Delivery code | 6 digits | `esc.code.invalid` |

## Server errors
| Code | User message | UI behaviour |
|---|---|---|
| ESC_NOT_VERIFIED | Both parties must be verified for this deal. | Verification |
| ESC_TERMS_CHANGED | The terms changed. Please review and accept again. | Re-accept |
| ESC_DEAL_FROZEN | This deal is frozen while a dispute is reviewed. | Banner |
| ESC_WINDOW_CLOSED | The dispute window has closed. | Message |
| ESC_LIMIT_EXCEEDED | This deal is above your limit. Upgrade to continue. | Upgrade |
| ESC_ALREADY_FUNDED | This deal is already funded. | Show deal |
