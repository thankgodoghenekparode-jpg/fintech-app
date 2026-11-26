# Integration Notes

## Workstream ownership

- Developer 1 owns `mobile/` core-banking app features and `web/` staff back-office. Build from `Developer_1_Core_Banking_and_Backoffice/`; use the matching `_WITH_STITCH` folder for Stitch visual references.
- Developer 2 owns group banking/community feature modules.
- Developer 3 owns commerce, credit and financial-services feature modules.
- Use `front-end extracted/` as a shared cross-workstream reference and as the current consolidated source for Developer 2/3 requirements. Keep module routes and feature code isolated by owner.

## Current foundations

- Mobile routes use the screen inventory paths where started. Public welcome, signup and login routes are distinct from the authenticated five-tab shell.
- Mobile API base URL is supplied through `--dart-define=API_BASE_URL=...`; no default environment or backend URL is embedded.
- Mobile access, refresh, device and onboarding session values are written only through `flutter_secure_storage`. Passcodes and OTPs are held in screen memory only.
- Web API base URL is configured with `NEXT_PUBLIC_API_BASE_URL`; web dashboard requests use cookies. The current web dashboard is a temporary account-overview scaffold and does not yet match Developer 1's staff-console platform assignment. Replace it with `/admin/*` routes before counting any web screen as complete.
- API operations must match Developer 1's OpenAPI files. Do not create a local mock backend that returns fabricated banking data.

## Cross-workstream coordination

- The original Developer 1 design tokens and API contract matched `front-end extracted/`. The API contract is now locally revised to v1.5.0 for card, bill, notification, support and statement flows; the top-level Developer 1 copy and its `_WITH_STITCH` mirror are synchronized, while the extracted copy remains an unchanged reference. Review [STATEMENTS_API_UNBLOCKING_ADDENDUM.md](STATEMENTS_API_UNBLOCKING_ADDENDUM.md) and confirm backend parity before statement release.
- S-CB-074 uses the existing `/security/devices` paths with an isolated response-shape proposal and a PIN-token requirement for device removal. Neither source OpenAPI copy was changed. Backend approval, implementation, and session-revocation semantics are required; see [DEVICE_SESSIONS_API_UNBLOCKING_ADDENDUM.md](DEVICE_SESSIONS_API_UNBLOCKING_ADDENDUM.md).
- Shared navigation, token generation, app configuration, API clients and design primitives require coordination before edits that affect all three workstreams.
- Product modules should depend on shared primitives and API clients, never another workstream's presentation code.
