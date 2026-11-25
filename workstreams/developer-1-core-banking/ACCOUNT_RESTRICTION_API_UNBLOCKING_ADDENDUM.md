# Account Restriction and Recovery API Addendum

Status: frontend gap analysis and proposal only. This document does not change the approved API contract or claim backend support.

## Existing contract evidence

- `AUTH_LOCKED` is HTTP 423 after authentication attempts and routes to S-CB-094. The shared error object includes `code`, `message`, and `requestId`; it does not define a restriction-reason schema.
- `POST /security/lock` starts a customer-requested lock and requires a one-action PIN token. Its success response is untyped.
- `GET /accounts/me` exposes a status enum (`ACTIVE`, `LOCKED`, `RESTRICTED`, `DORMANT`, `CLOSED`) but no reason, enforcement timestamp, review state, allowed-services list, or recovery state.
- There is no documented account-unlock operation, account-restriction detail operation, recovery OTP operation, or self-lock selfie session/upload result flow.
- `/tickets` and support chat require an authenticated session. No approved public phone number, email, or signed-out support route is provided.

## Current frontend behavior

The login screen routes an `AUTH_LOCKED`/423 response to `/account-locked` and displays only the mapped reason and a sanitized request reference when the response supplies one. The default reason is the documented authentication lockout. The model can represent self-lock and compliance review when a typed source is added, but the current contract cannot supply those details.

Authenticated users can open the existing Help Centre. Signed-out users are shown that the app has no approved public support channel configured. For a self-lock, the screen describes the handoff's OTP and selfie recovery steps but clearly explains that the app cannot start them yet. No unlock call is made.

## Backend/product decisions needed

1. Define a typed restriction response with reason enum, user-safe message, request/reference ID, status, enforcement time if appropriate, and explicit available services/actions.
2. Define whether login-attempt lockout, a customer-requested self-lock, and a compliance restriction share one route or need separate states.
3. Define the OTP/selfie identity verification and account-unlock operations, including attempts, expiry, review outcome, and idempotency/security requirements.
4. Supply an approved unauthenticated support channel or public support operation for users who cannot sign in.
5. Confirm which incoming/outgoing payments, card activity, and balances remain available for each restriction reason before displaying those claims.

## Stitch content excluded from live copy

The S-CB-094 Stitch export contains illustrative reference/date values, a sample balance, a two-minute completion estimate, claims about incoming transfers and paused card/transfer activity, and CBN/NDIC protection language. The UI does not ship those examples as bank facts. Use only values approved and returned by the backend/legal owners.
