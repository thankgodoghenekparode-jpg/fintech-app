# Validation and Errors - Ajo / Esusu

## Field validation
| Field | Rule | Message |
|---|---|---|
| Circle name | 3-60 chars | `ajo.name.invalid` |
| Amount per round | > 0 kobo; within trust-level cap | `ajo.amount.cap` |
| Slots | 2 to configured maximum | `ajo.slots.range` |
| Start date | today or later; not beyond 60 days | `ajo.start.invalid` |
| Invite code | valid and circle recruiting | `ajo.code.invalid` |
| Deposit amount | at least the circle's required cover | `ajo.deposit.min` |
| Guarantor | verified, not self, free balance >= guaranteed amount | `ajo.guarantor.invalid` |

## Server errors
| Code | User message | UI behaviour |
|---|---|---|
| AJO_CIRCLE_FULL | This circle is full. | Show alternatives |
| AJO_NOT_ELIGIBLE | Your trust level does not allow this circle yet. | Explain trust |
| AJO_ORDER_LOCKED | The order is locked now that the circle has started. | Message |
| AJO_COVER_REQUIRED | This slot needs cover before you can join. | Protection setup |
| AJO_AUTODEBIT_REQUIRED | This circle needs auto-debit turned on. | Consent screen |
| AJO_SHORTFALL | This round is waiting for contributions. | Banner |
| AJO_CIRCLE_FROZEN | This circle is on hold while we review a concern. | Banner |
