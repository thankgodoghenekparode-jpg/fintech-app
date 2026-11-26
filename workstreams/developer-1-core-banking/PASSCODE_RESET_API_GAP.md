# Passcode Reset API Gap — S-CB-015

## Implemented against the supplied API

The recovery screen requests and verifies OTP using `POST /auth/otp/request` and `POST /auth/otp/verify` with purpose `PASSCODE_RESET`. The six-digit code is validated locally, resend calls the documented request operation, and server rate-limit/errors are surfaced. The returned restricted session token is checked but held only in memory. It is never stored as a customer login or onboarding session.

After OTP verification, the flow stops at the identity-check step. The screen does not collect BVN digits, record a selfie, change the passcode, or sign the customer in. It states that no passcode has changed.

## Missing contract and policy

The API has no recovery identity-verification operation (BVN check or reset-specific liveness), no passcode-reset operation, no authenticated token issuance/session transition after recovery, and no typed restriction/hold response. The Stitch screenshot also shows transaction-PIN entry, but the written flow instead requires OTP plus BVN digits or selfie; no contract supports the PIN challenge in this reset flow, so it is not collected. The functional handoff describes a configurable 24-hour restriction on money actions, while Stitch contains sample copy stating 24 hours. Neither source defines the configuration owner, precise covered actions, start time, expiry, server enforcement, or API fields reporting the restriction.

## Backend/product inputs required

Define the recovery-token scope and expiry; approved identity challenge and attempt limits; passcode replacement and final session issuance; and a server-enforced restriction response with exact duration, covered actions, effective time and expiry. Do not rely on a client timer to enforce a transaction restriction. Confirm the policy before displaying any duration or allowing money actions after reset.
