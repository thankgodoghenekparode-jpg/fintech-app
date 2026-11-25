# Validation and Errors - Pay Am Small

## Field validation
| Field | Rule | Message |
|---|---|---|
| Product price | > 0 kobo | `pas.price.invalid` |
| Plan deadline | within vendor's committed lock window | `pas.deadline.invalid` |
| Top-up amount | > 0; not above remaining | `pas.topup.invalid` |
| Delivery code | 6 digits | `pas.code.invalid` |

## Server errors
| Code | User message | UI behaviour |
|---|---|---|
| PAS_PRICE_CHANGED | The vendor changed this item. Your locked price still applies. | Info |
| PAS_STOCK_UNAVAILABLE | This item can no longer be reserved. | Choose another |
| PAS_VAULT_CLOSED | This plan is already complete. | Show order |
| PAS_VENDOR_SUSPENDED | This vendor is not available right now. | Refund path |
| PAS_CREDIT_DECLINED | The vendor did not accept the credit request. You can use Price-lock instead. | Suggest |
| PAS_DEADLINE_PASSED | Your plan reached its deadline. Choose extend or refund. | S-PAS-009 |
