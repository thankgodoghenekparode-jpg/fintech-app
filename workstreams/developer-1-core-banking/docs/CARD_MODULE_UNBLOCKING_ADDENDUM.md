# Card Module Unblocking Addendum

**Status:** The Developer 1 OpenAPI file is locally revised to v1.4.0. It includes the v1.1.0 card changes and later bill, notification and support revisions. Matching card Flutter flows have been implemented. This is a frontend/backend contract proposal; it does not prove the bank's deployed backend implements or has approved these operations.

**Purpose:** Record the card contract revision and remaining product/security decisions needed to complete the Developer 1 Flutter app and obtain backend parity.

## Current implementation

The app currently supports:

- Cards home from `GET /cards`, displaying API-provided card label, theme, status, and last four digits.
- Freeze and unfreeze through `POST /cards/{id}/freeze`.
- Card creation through authenticated `POST /auth/pin/verify` followed by `POST /cards`, using the documented `pinToken` and `Idempotency-Key` headers. The token and entered PIN are not written to storage.
- Card detail from the card list, with freeze controls, card-specific recent transactions, rename/theme and confirmed deletion.
- PIN-protected card limits and typed card settings read/update flows against the local v1.1.0 contract.
- Android card-detail reveal through `POST /cards/{id}/details`, with PIN verification, Android `FLAG_SECURE`, automatic hide after 30 seconds, app-background hide, and best-effort clearing of copied values from the clipboard.

Card create, limit and delete PIN entry uses an obscured field on iOS/web and can reach the documented request flow. Full card-number/CVV reveal remains gated on iOS/web because the required screen-capture protection is not available there. The web preview has no backend and cannot exercise real card requests.

For visual inspection without a session, build with `--dart-define=ENABLE_CARD_UI_PREVIEW=true`. The Welcome screen then shows **Preview cards UI**, which opens two clearly labelled, local sample cards. This preview is off by default, read-only, and does not call or represent a bank API response.

## Decisions and changes needed

### 1. Card limits: revised PIN security contract (S-CB-053)

**Frontend contract decision:** This project adopts PIN confirmation. OpenAPI v1.1.0 now requires `X-Pin-Token`, defines the effective `Card` response, and documents 401/422 errors. The frontend sends the token and consumes returned limits. Backend must implement and approve this revision before release.

The limits screen allows either per-transaction or daily limit to be submitted independently, matching the optional fields in the request schema. Blank fields are omitted from the request; both blank fields are rejected in the UI. Clearing an already configured limit is not supported because the contract does not define a clear/reset operation.

### 2. iOS and web capture policy for PIN entry and card reveal (S-CB-052, S-CB-054)

**Current behavior:** Android applies `FLAG_SECURE` while the user enters a transaction PIN or views card details. On iOS/web, PIN values are obscured in create/limit/delete prompts; revealing the full card number/CVV is disabled because capture protection cannot be established.

**iOS decision required:** Approve a supported capture-blocking SDK/implementation and its verification criteria, or explicitly remove/relax the screenshot-blocking requirement for iOS. UIKit's screenshot notification is sent after a screenshot has been taken, so it can report a screenshot but cannot prevent the image from being captured. The [Apple notification reference](https://developer.apple.com/documentation/UIKit/UIApplication/userDidTakeScreenshotNotification?language=swift) documents this timing.

**Web decision required:** Keep full card-number/CVV reveal and transaction-PIN entry unsupported on web, or provide a bank-approved web security control and policy that permits these actions. A browser page does not have Android's native secure-window flag.

**Approval needed from:** Bank security/product owner. Native screen protection is separate from the API contract. Keep the iOS/web full-card reveal gate until an approved control is implemented and verified, or product explicitly removes the requirement for those platforms. PIN-only prompts remain obscured but do not claim to block screenshots.

### 3. Card-specific transaction history (S-CB-051)

OpenAPI v1.1.0 adds `GET /cards/{id}/transactions`, reusing `Transaction` with `limit`, `cursor`, `status`, `from`, and `to` filters and a typed `{ items, nextCursor }` response. The detail screen loads the first page through this route. Backend must implement the route and confirm stable ordering/cursor semantics.

### 4. Card alerts and usage settings (S-CB-055)

The screen spec includes push alerts, SMS alerts, online purchases, and international use (v2), but the API defines no read/update operations for these settings.

OpenAPI v1.1.0 adds typed `GET` and `PUT /cards/{id}/settings` operations for `pushAlerts`, `smsAlerts`, `onlinePurchases`, and optional `internationalPurchases`. The settings screen reads server values and saves changes, reverting a switch if the request fails. Backend must implement the endpoints and confirm notification enrollment and consent semantics.

### 5. Rename, theme change, and card deletion (S-CB-051)

OpenAPI v1.1.0 adds `PATCH /cards/{id}` for `label` and `theme`, reusing the create theme enum. It adds PIN-token-protected `DELETE /cards/{id}` as an irreversible soft deletion that sets status `DELETED` and retains transaction history. The detail screen exposes rename, theme change and confirmed deletion. Backend must implement these semantics and confirm whether deletion can be reversed.

### 6. Card creation fee and review copy (S-CB-052)

The UI spec says the creation fee is `[CONFIRM WITH ZENITH]`; no amount or fee field is present in the card response.

**Product decision required:** Confirm whether a fee applies, the amount and currency, any waiver rules, and the exact pre-submit disclosure. If the fee can vary by customer or product, backend must provide an authoritative quote and define how it is bound to the create request. The frontend must not invent or hard-code a fee.

### 7. Android build and native verification

The Android privacy channel adds `FLAG_SECURE` during sensitive entry/reveal. The project pins Gradle 9.5.0, which is not cached in the current environment. The wrapper has been unable to complete the distribution download from `services.gradle.org`, so the Kotlin host change has not yet been compiled into an APK.

**Verification needed:** Restore Gradle distribution access or provide the pinned distribution through the approved build environment; then run the Android debug build and verify screenshot suppression, PIN verification, reveal timeout, app-background hide, and clipboard cleanup on a device. Also run the iOS build after the security decision in item 2.

## Acceptance checklist

Before removing the card-flow gates or counting the blocked card screens complete:

- [ ] Backend implements and accepts revised OpenAPI v1.1.0 limits, card history, settings, rename/theme, and delete operations (or product changes the UI scope).
- [ ] Product confirms card fees and disclosure text, including whether no fee applies.
- [ ] Security approves iOS and web treatment for full card-number/CVV reveal; PIN-only prompts remain obscured and never persist the PIN.
- [ ] Android build and on-device `FLAG_SECURE` behavior are verified; any approved iOS path is built and verified on an iOS device.
- [ ] Flutter API/UI tests cover accepted and rejected PINs, expired/invalid tokens, duplicate create retries, limit validation, settings updates, pagination, and reveal timeout/hide behavior.

## Contract revision record

The Developer 1 `openapi_core.yaml` was changed locally from v1.0.0 and is currently v1.4.0. Version 1.1.0 added typed card settings and transaction-page schemas, PIN-protected limit and delete operations, card history, settings read/update, rename/theme update, and PIN-token response fields. Later versions add typed bill, notification and support operations. These revisions unblock frontend implementation against the revised local project contract; they do not update a remote API service or bank approval record. The top-level Developer 1 contract and `_WITH_STITCH` copy are synchronized; `front-end extracted/` remains the original reference.

## Source references

- Primary screen requirements: `Developer_1_Core_Banking_and_Backoffice_WITH_STITCH/Developer_1_Core_Banking_and_Backoffice/work_scope/03_core-banking/UI_UX_SPEC.md` (S-CB-050 through S-CB-055).
- Primary API contract: `Developer_1_Core_Banking_and_Backoffice/work_scope/07_api-contracts/openapi_core.yaml` (`/auth/pin/verify`, `/cards`, freeze, details, and limits operations). Its `_WITH_STITCH` copy is synchronized.
- Card visuals/security behavior: `Developer_1_Core_Banking_and_Backoffice_WITH_STITCH/Developer_1_Core_Banking_and_Backoffice/shared_reference/02_design-system/CARD_DESIGN_SPEC.md`.
- Current implementation and open gaps: `IMPLEMENTATION_STATUS.md` and `SPEC_GAPS.md`.
