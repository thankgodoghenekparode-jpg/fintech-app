# Error Codes (core)

| Code | HTTP | Meaning | User-facing action |
|---|---|---|---|
| VALIDATION_ERROR | 400 | Field validation failed (details lists fields) | Fix fields |
| AUTH_INVALID_CREDENTIALS | 401 | Wrong passcode/PIN | Retry; counter |
| AUTH_LOCKED | 423 | Locked after attempts | Locked screen |
| AUTH_TOKEN_EXPIRED | 401 | Access token expired | Silent refresh |
| AUTH_DEVICE_NOT_TRUSTED | 403 | New/untrusted device | Device verification |
| AUTH_STEP_UP_REQUIRED | 403 | Extra verification needed | OTP/selfie |
| FORBIDDEN | 403 | Not allowed | Message |
| NOT_FOUND | 404 | Resource missing | Message |
| OTP_INVALID / OTP_EXPIRED / OTP_RATE_LIMITED | 400/429 | OTP problems | Retry/wait |
| KYC_MISMATCH | 422 | Identity details do not match | Edit details |
| KYC_PROVIDER_UNAVAILABLE | 503 | Identity provider down | Retry later |
| KYC_REJECTED | 422 | Rejected after review | Contact support |
| ACCOUNT_LOCKED / ACCOUNT_RESTRICTED | 423 | Account state blocks action | Locked screen |
| TRF_INSUFFICIENT_FUNDS | 422 | Balance too low | Stay |
| TRF_LIMIT_EXCEEDED | 422 | Tier limit exceeded (details: limit, used) | Upgrade |
| TRF_RECIPIENT_NOT_FOUND | 422 | Name enquiry failed | Re-enter |
| TRF_QUOTE_EXPIRED | 409 | Quote older than allowed | Re-quote |
| TRF_PENDING | 202 | Outcome unknown; transaction PENDING | Pending screen |
| TRF_FAILED | 422 | Failed and any debit reversed | Failed screen |
| TRF_DUPLICATE | 409 | Duplicate detected | Show existing |
| IDEMPOTENCY_KEY_REUSED | 409 | Same key different request | Developer error |
| REQUEST_IN_PROGRESS | 409 | Same key still processing | Wait |
| BIL_VALIDATION_FAILED | 422 | Customer validation failed | Re-enter |
| BIL_VEND_FAILED | 422 | Vend failed; refunded | Result |
| CARD_CREATE_FAILED | 422 | Card could not be created | Retry |
| CARD_FROZEN | 422 | Card frozen | Message |
| RATE_LIMITED | 429 | Too many requests | Wait |
| SYSTEM_UNAVAILABLE | 503 | Dependency down or maintenance | Error state |
| INTERNAL_ERROR | 500 | Unexpected; requestId logged | Error state |
