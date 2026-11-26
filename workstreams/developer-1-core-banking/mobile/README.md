# YourApp Flutter app

This folder contains the customer mobile app for the Developer 1 core banking workstream.

## Run against a backend

The app reads its API origin from the compile-time `API_BASE_URL` value. Use the base URL of a backend that implements the Developer 1 OpenAPI contract; include any required `/api` prefix, and end with no route path. For example:

```powershell
flutter run --dart-define=API_BASE_URL=https://your-development-api.example
```

For an Android emulator connecting to a backend on the host machine, use the emulator's host alias (commonly `10.0.2.2`) and the backend's actual port. A physical phone needs a host address reachable on its network. HTTPS and a development account with a provisioned transaction PIN are required to exercise card operations.

The app does not include a backend or default API URL. Without `API_BASE_URL`, authenticated screens cannot load live data. The Flutter web preview served at `http://127.0.0.1:7357` is a static UI preview; it is not a fintech API.

## Card flow

The card screens call the operations in `Developer_1_Core_Banking_and_Backoffice/work_scope/07_api-contracts/openapi_core.yaml`: list/create, freeze, reveal details, update limits, card transactions, settings read/update, rename/theme and delete. PIN-gated calls verify the transaction PIN and send the short-lived `X-Pin-Token`; creation also sends `Idempotency-Key`. The current local OpenAPI is v1.5.0; its card additions originated in v1.1.0 and statement request/download proposal in v1.5.0. Statement backend parity is pending; see `STATEMENTS_API_UNBLOCKING_ADDENDUM.md`. Backend parity is pending and this local contract does not establish backend deployment or approval.

## Help and support

Help Centre and support ticket list/create/detail/reply screens use the local OpenAPI v1.4.0 ticket proposal, which the backend must implement before those live API operations can work. Bank-approved phone/email/chat channels, agent availability, attachments, regulator escalation instructions, and response-time promises were not supplied, so the app does not display Stitch sample values for those items. Review `SUPPORT_API_UNBLOCKING_ADDENDUM.md` before backend integration.

## Branch and agent locator

S-CB-082 is available from More at `/locator`. It requests device location only after **Use my location** is tapped; if permission is denied, customers can search by area. The screen calls the documented `GET /agents/nearby` operation. The response model and optional `q` area-search parameter are local proposals because the extracted agent API provides neither. Backend approval and parity are required before live search works; see `../AGENT_LOCATOR_API_UNBLOCKING_ADDENDUM.md`. Stitch sample points are not used as fixture customer locations. Branch results and map tiles remain unavailable until approved branch data and a map provider are supplied.

## Account closure

S-CB-083 is available from More at `/more/close-account`. It checks server-side eligibility, displays returned blockers, requires a reason and one-action PIN verification, and submits a closure request with an idempotency key. It does not close an account locally. The eligibility/request endpoints are a local proposal because the supplied OpenAPI defines PIN verification but no account closure operation; backend, product, compliance and legal approval are required. Demo preview uses a labeled blocker fixture and disables PIN/submission. See `../ACCOUNT_CLOSURE_API_UNBLOCKING_ADDENDUM.md`.

## Offline behaviour

S-CB-090 watches the device network-interface state. When the device reports no interface, the app-wide guard hides account data and actions and provides a retry screen. A network interface does not prove internet or banking-service availability; API errors while connected remain normal service errors. The UI does not claim cached balances/receipts because there is no safe persistent offline archive. The preview catalog includes a non-live offline screen preview.

## Maintenance state

S-CB-091 is available at `/maintenance`; the demo catalog has a separate preview route. No maintenance schedule, status endpoint, status-page URL or approved emergency contact was supplied. The screen does not copy illustrative Stitch times, service guarantees, regulatory claims, or phone numbers. Its retry action checks device connectivity only and cannot confirm that banking services have resumed. Backend-triggered maintenance navigation requires an approved maintenance signal and status contract.

## Force update

S-CB-092 is available at `/update`; a preview is linked from the demo catalog. The installed version is read from platform package metadata. The handoff says the backend should provide the minimum version but defines no policy endpoint, production app IDs or store links. The frontend accepts a typed update policy, validates HTTPS Google Play/App Store links, and opens the store only when an update is explicitly required. Without policy the screen remains an unconfigured state and the action is disabled. See `../FORCE_UPDATE_API_UNBLOCKING_ADDENDUM.md`.

## Session lock

S-CB-093 is available at `/lock`; the demo catalog links a preview at `/demo/lock`. Authenticated screens lock after two minutes without pointer or keyboard activity, and when the app returns from background by default. Configure these app defaults with `--dart-define=SESSION_INACTIVITY_SECONDS=120` and `--dart-define=LOCK_SESSION_ON_BACKGROUND=true`. Passcode unlock uses the existing `POST /auth/login` contract; enrolled biometrics run local authentication before the existing `POST /auth/refresh`. Log out clears access and refresh tokens. The preview never submits credentials. Confirm timeout policy with security and complete native screen-capture/app-switcher protection and lifecycle verification before production.

## Account locked or restricted

S-CB-094 is reached when login receives the documented `AUTH_LOCKED`/423 response. `/account-locked` shows generic lockout guidance and a validated request reference when available. Authenticated users can open the Help Centre. Signed-out users are told that a public support route is not configured. The separate `/demo/account-locked` preview shows the self-lock recovery steps from F-09, but does not call an unlock operation. The API has no typed restriction details, OTP/selfie unlock flow, or public support channel; see `../ACCOUNT_RESTRICTION_API_UNBLOCKING_ADDENDUM.md`.

## Security hub and account self-lock

S-CB-073 is available from More at `/more/security`. The **Lock my account** action explains that debits and cards are restricted while credits remain available, asks for confirmation, collects the transaction PIN with an in-app keypad, verifies it with `POST /auth/pin/verify`, and calls the documented bodyless `POST /security/lock` with its one-use `X-Pin-Token`. On success it opens `/account-locked` with the self-lock reason. The `/demo/security` route is preview-only and never requests a PIN or calls the API. The supplied lock operation has no typed success body, and F-09 unlock OTP/selfie endpoints and a signed-out support channel are still absent; backend parity must be confirmed before production. See `../ACCOUNT_LOCK_API_UNBLOCKING_ADDENDUM.md` and `../ACCOUNT_RESTRICTION_API_UNBLOCKING_ADDENDUM.md`.

S-CB-074 is available at `/more/devices`; it loads `GET /security/devices`, marks the current device, and asks for confirmation and PIN before `DELETE /security/devices/{id}`. The endpoint paths exist in the supplied OpenAPI, but its list response is untyped and DELETE does not specify PIN authorization. The client uses the proposed typed fields and `X-Pin-Token` requirement documented in `../DEVICE_SESSIONS_API_UNBLOCKING_ADDENDUM.md`; backend approval/parity and session-revocation behavior are pending. `/demo/devices` is sample-only, and bulk sign-out is not implemented because no endpoint is defined.

To inspect card visuals without a backend, build with `--dart-define=ENABLE_CARD_UI_PREVIEW=true`. The Welcome screen then shows **Preview cards UI**, which opens two clearly labelled sample cards in read-only mode. This flag should be omitted from normal production builds.

To show a wider, signed-in-style sample experience without credentials or a backend, run:

```powershell
flutter run -d chrome --dart-define=ENABLE_DEMO_LOGIN=true
```

The Welcome screen then shows **Demo login**. It opens sample Home and Cards tabs plus sample Account Details, Add money, report-problem and Payments hub screens. On the sample Home, tap **Add money** or **Preview report a problem** to inspect those flows. Account/transaction data is fictional; these screens are clearly marked as demos and cannot receive funds or create support tickets. Demo mode is disabled by default and is not an authentication flow. You can combine the demo and card-only preview flags when needed.

For a browser preview build with the demo, card gallery, and draft legal links enabled, run from this `mobile` directory:

```powershell
& 'C:\Users\user\development\flutter\bin\flutter.bat' build web --dart-define=ENABLE_DEMO_LOGIN=true --dart-define=ENABLE_CARD_UI_PREVIEW=true --dart-define=ENABLE_DRAFT_LEGAL_PREVIEW=true
node tool/preview_server.js
```

Open `http://127.0.0.1:7357`, choose **Demo login**, then **Browse implemented screens**. The catalog links the available preview screens and identifies modules that need a connected backend. The local server serves the built files only; it is not a fintech API.


S-CB-076 Statements uses the local v1.5.0 contract proposal for PDF request creation, account-scoped request history, server-configured range validation, registered-email delivery, and authenticated PDF retrieval. Backend implementation and security/product approval are pending; see STATEMENTS_API_UNBLOCKING_ADDENDUM.md. The UI follows the Developer 1 requirements, F-10 flow and Stitch layout while omitting unsupported certification, fee, CSV and sample-account claims.
