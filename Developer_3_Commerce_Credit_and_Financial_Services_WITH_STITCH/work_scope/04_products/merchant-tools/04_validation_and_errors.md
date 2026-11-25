# Validation and Errors - Merchant and Small-Business Tools

## Field validation
| Field | Rule | Message |
|---|---|---|
| Business name | 3-80 chars | `mer.name.invalid` |
| Link amount | > 0 or open | `mer.link.amount` |
| Invoice items | at least one, amounts > 0 | `mer.invoice.items` |
| Refund amount | <= original payment and available balance | `mer.refund.amount` |

## Server errors
| Code | User message | UI behaviour |
|---|---|---|
| MER_NOT_VERIFIED | Your business is not verified yet. Some features are limited. | Banner |
| MER_LINK_EXPIRED | This payment link has expired. | Message |
| MER_REFUND_BLOCKED | This refund cannot be made right now. {reason} | Message |
| MER_LIMIT_EXCEEDED | This is above your business limit. | Upgrade |
