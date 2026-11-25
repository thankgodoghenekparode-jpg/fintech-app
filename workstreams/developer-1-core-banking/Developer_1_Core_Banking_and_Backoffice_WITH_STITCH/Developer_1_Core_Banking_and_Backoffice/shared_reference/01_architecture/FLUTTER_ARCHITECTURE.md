# Flutter Architecture

## Layers (per feature)
Presentation (screens, widgets, Riverpod controllers) -> Domain (entities, use cases) -> Data (repositories, API clients, DTOs).

## Cross-cutting core
- `ApiClient` (dio): base URL per environment, auth interceptor (attach access token, refresh on 401 once), idempotency interceptor, error mapper (server error code -> typed failure), retry only for safe GETs.
- `SessionManager`: tokens in secure storage; inactivity timer; lock-on-background; force logout on revoked device.
- `SecurityService`: biometric prompt, PIN pad, root/jailbreak check, screen-capture protection toggles.
- `Formatter`: money, dates (Africa/Lagos), phone numbers, account numbers.
- `TextLayer`: i18n access; fallback to English.
- `FeatureFlags`: remote-config driven; used for [OPEN] items.
- `ErrorPresenter`: maps typed failures to user-friendly messages (see `VALIDATION_AND_ERRORS.md`).

## Money-moving screen pattern
1. Collect input -> local validation.
2. Call `quote` endpoint (fee, limits, total) -> show confirmation sheet.
3. User enters PIN/biometric -> app generates one idempotency key for this intent.
4. Submit -> show Processing state.
5. Result: Success / Pending / Failed. Pending screens poll status (backoff) and also update from push.
6. Receipt screen is always reachable from history.

## Offline and weak network
- Read screens show cached data with a "last updated" label.
- Money actions require connectivity; if the network drops after submit, show Pending and reconcile by idempotency key and status query; never prompt the user to resubmit blindly.

## Deep links
`app://transfer/receipt/{id}`, `app://cards/{id}`, `app://dues/{id}`, `app://group/{id}` and similar; every deep link requires authentication.

## Multi-tenant UI (Stage 2)
A tenant switcher (for users who manage a cooperative, vendor store or collector) lives in More; context is stored in the session and sent as `X-Tenant-Id`.
