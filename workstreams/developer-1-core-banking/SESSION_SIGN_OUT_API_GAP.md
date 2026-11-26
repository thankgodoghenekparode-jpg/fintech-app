# Session Sign-out Contract Gap

## Source references

S-CB-070's More screen and the session-lock screen include a sign-out action. The supplied Developer 1 and extracted OpenAPI contracts define login and refresh, but no logout/session-revocation operation. The Stitch More export includes a Log Out button; its sample app version, licence and NDIC claims are not approved content and are not copied.

## Current frontend behavior

Sign-out is device-local. After confirmation, the app attempts to delete the access token, refresh token, unfinished onboarding session token, and biometric-unlock opt-in from secure storage, then returns to Welcome. It preserves the stable device ID. A storage deletion error prevents the success navigation and is shown as an error. No API endpoint is called, and other device sessions are not changed.

The flow removes credentials from this installation; it does not prove that a server-held refresh token has been revoked. Do not describe this as remote or all-device sign-out.

## Backend follow-up

If product/security requires immediate server-side revocation, backend must define and implement an approved logout/session-revocation operation, including refresh-token invalidation/rotation behavior, authentication requirements, response, and failure semantics. The frontend must not invent this endpoint or claim remote revocation until that contract exists.
