# Profile API Gap — S-CB-071

## Implemented against the current contract

The authenticated mobile Profile route reads the account through the existing `GET /accounts/me` operation. An opt-in `/demo/profile` route uses an explicitly fictional account fixture so the Stitch-aligned screen can be previewed without backend access. It displays `accountName` and `tier` when present, with loading and retry states. The layout follows the Developer 1 S-CB-071 Stitch composition (identity header, personal information, contact details), while omitting sample-only profile values.

## Required API decisions before enabling profile edits

The current contract has no authenticated profile-read operation. `GET /accounts/me` returns account identity/balance/tier/limits only; it does not define phone, email, residential address, profile image, KYC match/verification flags, date of birth, gender or next-of-kin fields. `POST /onboarding/profile` is a signup submission and is not a safe substitute for reading or editing a verified customer's profile.

The contract also has no OTP step-up purpose/operation for profile changes and no profile update or photo-upload operation. The screen therefore shows the supplied account name and tier, labels contact fields unavailable, and presents a clear explanation when Edit is selected. It does not display the Stitch fixture person's details, imply verification, or submit changes.

## Backend/product inputs

Agree an authenticated profile response schema and field-level privacy rules; specify which fields are editable after KYC; define OTP request/verify and profile update operations including idempotency, rate limits, audit behavior and pending-verification states; and define secure profile-image upload rules if photos are supported. Update both Developer 1 OpenAPI copies and the consolidated extracted API reference only after backend agreement. Then implement the documented flow and validate backend parity.
