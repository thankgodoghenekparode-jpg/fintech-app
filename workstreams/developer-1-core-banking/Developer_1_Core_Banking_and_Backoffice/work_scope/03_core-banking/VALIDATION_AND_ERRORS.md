# Validation and Error Handling

## Field validation
| Field | Rule | Message key / text |
|---|---|---|
| Phone | Nigerian mobile, 10 digits after +234 (leading 0 stripped) | `validation.phone.invalid` - "Enter a valid Nigerian phone number" |
| OTP | 6 digits | `validation.otp.invalid` - "That code is not right. Try again" |
| BVN / NIN | 11 digits, numeric | `validation.bvn.invalid` - "BVN must be 11 digits" |
| Name | letters, spaces, hyphen, apostrophe; 2-50 chars | `validation.name.invalid` |
| Email | RFC-valid | `validation.email.invalid` |
| Date of birth | valid date; age >= minimum [CONFIRM WITH ZENITH] | `validation.dob.underage` |
| Passcode | 6 digits; no all-same or sequential | `validation.passcode.weak` |
| PIN | 4 digits; not equal to passcode | `validation.pin.weak` |
| Account number | 10 digits | `validation.account.invalid` |
| Amount | > 0, integer kobo, 2 decimals max, <= available balance, <= limits | `validation.amount.*` |

Validate on blur and on submit; never block typing; show errors under the field with an icon (not colour alone).

## Server error mapping
The back end returns `{ "code": "...", "message": "...", "details": {...}, "requestId": "..." }`. Map codes to friendly copy; show the requestId in a small "Reference" line on unexpected errors so support can trace.
| Code | User message | UI behaviour |
|---|---|---|
| AUTH_INVALID_CREDENTIALS | "That passcode is not right." | attempt counter |
| AUTH_LOCKED | "Too many tries. Your account is locked for your safety." | S-CB-094 |
| AUTH_DEVICE_NOT_TRUSTED | "Let's verify this device." | S-CB-014 |
| AUTH_STEP_UP_REQUIRED | "For your safety, please confirm it's you." | OTP/selfie sheet |
| KYC_MISMATCH | "Your details don't match your BVN. Check and try again." | edit |
| KYC_PROVIDER_UNAVAILABLE | "We can't verify right now. Your progress is saved." | retry later |
| TRF_INSUFFICIENT_FUNDS | "You don't have enough balance." | stay on amount |
| TRF_LIMIT_EXCEEDED | "This is above your limit. Upgrade to send more." | Upgrade CTA |
| TRF_RECIPIENT_NOT_FOUND | "We couldn't find that account." | stay |
| TRF_PENDING | "Your transfer is being confirmed. We'll notify you." | Pending screen |
| TRF_FAILED | "That transfer didn't go through. You were not charged." (only if true) | Failed screen |
| TRF_DUPLICATE | "This looks like a transfer you already sent." | show existing result |
| BIL_VALIDATION_FAILED | "We couldn't verify that number." | stay |
| BIL_VEND_FAILED | "The purchase failed. Your money has been returned." | result |
| CARD_CREATE_FAILED | "We couldn't create your card. Try again." | retry |
| RATE_LIMITED | "Please wait a moment and try again." | cooldown |
| SYSTEM_UNAVAILABLE | "We're having trouble. Your money is safe." | ErrorState |
| NETWORK_OFFLINE | "You're offline." | offline banner |

## Principles
1. Say what happened, whether money moved, and what to do next.
2. Never blame the user. Never show raw error text or stack traces.
3. Never say "failed" for an unknown outcome: use Pending.
4. Never tell the user "you were not charged" unless the back end confirms it.
