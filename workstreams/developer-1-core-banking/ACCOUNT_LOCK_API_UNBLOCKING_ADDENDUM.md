# Account Self-Lock API and Recovery Addendum

## Supplied contract used by the frontend

The Developer 1 and extracted OpenAPI specifications include:

1. `POST /auth/pin/verify`, with `{ "pin": "<four digits>" }`, returning the required `pinToken` and `expiresInSeconds`.
2. `POST /security/lock`, with the one-use token in the `X-Pin-Token` header, no request body, and an undocumented typed success body.

The mobile flow follows those shapes. It does not persist or log the PIN or token. It asks for customer confirmation, then PIN verification, and only after a successful lock response navigates to the self-locked state. A failed call leaves the customer on the Security hub and does not display a success state.

## Required backend and product confirmation

- Confirm that the deployed API implements the supplied `POST /security/lock` operation, including authentication, PIN-token expiry/consumption, failure codes, rate limits and idempotent/retry behavior.
- Publish a typed success response or explicitly confirm that a successful HTTP status with an empty body is the final contract.
- Confirm the exact account capabilities after lock (debits, cards, credits and access) and how the customer is notified. The current mobile app does not infer service state from the lock response.
- Define the authenticated and signed-out unlock/recovery process. F-09 specifies OTP plus selfie verification but supplies no unlock endpoint, OTP initiation/verification contract, liveness provider/session/upload/result contract, failure/manual-review outcomes, or response schema.
- Supply an approved signed-out customer support route and verified support channels for customers who cannot authenticate.

## Frontend boundary

`/more/security` implements only the supplied PIN verification and self-lock operation. `/demo/security` is an isolated visual preview and cannot make API calls. After success, `/account-locked` explains that self-lock recovery needs identity checks and that the app cannot start them yet. Do not enable in-app unlock or tell a locked customer that access has been restored until the recovery contract and backend are implemented and verified.
