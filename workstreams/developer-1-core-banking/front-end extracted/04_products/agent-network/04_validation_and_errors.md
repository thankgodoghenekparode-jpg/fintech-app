# Validation and Errors - Cash-in / Cash-out Agent Network

## Field validation
| Field | Rule | Message |
|---|---|---|
| Amount | > 0 within limits | `agt.amount.invalid` |
| Customer lookup | phone or account valid | `agt.customer.invalid` |
| Cash-out code | 6 digits | `agt.code.invalid` |

## Server errors
| Code | User message | UI behaviour |
|---|---|---|
| AGT_FLOAT_LOW | Your float is too low for this transaction. | Top up |
| AGT_LIMIT | This is above the allowed limit. | Message |
| AGT_CODE_EXPIRED | That code has expired. | Customer re-requests |
| AGT_CUSTOMER_RESTRICTED | This customer cannot transact right now. | Stop |
| AGT_SUSPENDED | Agent services are paused for your account. | Info |
