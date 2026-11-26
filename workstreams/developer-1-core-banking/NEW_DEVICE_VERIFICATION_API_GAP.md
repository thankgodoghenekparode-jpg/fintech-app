# New Device Verification API Gap — S-CB-014

## Implemented against the supplied API

The screen submits `POST /auth/otp/request` and `POST /auth/otp/verify` with the contract's `LOGIN_NEW_DEVICE` purpose. The six-digit code is length- and digit-validated by the UI. The verify response's restricted `sessionToken` is checked but kept in memory only; it is never written as an onboarding or authenticated access token.

After OTP succeeds, the flow stops before claiming the device is trusted. The UI explains that a selfie/liveness step is still required and no sign-in or device approval has occurred. This follows F-02's requirement to block the login flow when new-device verification fails or cannot be completed.

## Contract mismatch

`OtpVerified` has generic optional `sessionToken` and `nextStep` fields. `/onboarding/liveness` accepts `sessionId`, is described for onboarding, and returns an untyped result. No contract defines exchange of a `LOGIN_NEW_DEVICE` token for a liveness session, secure capture upload, liveness outcome, trusted-device registration, final authentication token issuance, or device-limit handling.

## Backend inputs required

Define the restricted session's scope/expiry, a new-device liveness session and upload/result schema, trusted-device registration and device-limit outcomes, and the final token issuance only after all checks pass. Keep OTP attempt/resend rate limits and audit requirements explicit. Once both Developer 1 OpenAPI copies and the extracted reference are updated with backend agreement, the remaining screen step can be wired without treating a local camera recording as server verification.
