# Validation and Errors - Revenue

## Field validation
| Field | Rule | Message |
|---|---|---|
| Item name | 3-60 chars | `rev.item.name` |
| Amount | > 0 kobo, or category table complete | `rev.item.amount` |
| Import file | CSV/XLSX; required columns; max rows | `rev.import.invalid` |
| Cash amount | > 0 and not above bill outstanding unless overpayment rule | `rev.cash.amount` |
| Phone | Nigerian format | `validation.phone.invalid` |

## Server errors
| Code | User message | UI behaviour |
|---|---|---|
| REV_COLLECTOR_NOT_VERIFIED | This organisation is not verified yet. | Banner |
| REV_BILL_NOT_FOUND | We could not find that bill. | Stay |
| REV_ALREADY_PAID | This bill is already paid. | Show receipt |
| REV_LINK_EXPIRED | This invitation has expired. | Ask collector |
| REV_OVERPAYMENT | This is more than you owe. Pay the exact amount or choose to credit your next bill. | Choice |
| REV_COLLECTOR_SUSPENDED | Payments to this organisation are paused. | Info |
