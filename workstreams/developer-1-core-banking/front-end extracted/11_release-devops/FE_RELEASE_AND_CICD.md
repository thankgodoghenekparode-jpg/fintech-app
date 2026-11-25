# Front-end Release and CI/CD

## Environments
Dev (mock + dev API), Staging (production-like, test Zenith sandbox if available), Production. Separate app IDs/bundle IDs suffixes for dev and staging.

## CI (on every pull request)
Lint, format check, unit and widget tests, golden tests, build debug, bundle size check, token consistency check, OpenAPI client regeneration check.

## CD
- Main branch -> internal distribution (Firebase App Distribution / TestFlight).
- Release branch -> staged rollout (5% -> 25% -> 100%) with crash-free threshold gate (99.5%).
- Web: preview deploy per pull request; production deploy on tag.

## Signing and secrets
Keystore and certificates in a secrets manager; never in the repo. CI uses short-lived credentials.

## Store readiness checklist
Privacy policy URL, data safety forms, permission justifications, screenshots, age rating (financial service), support contact, terms, accessibility statement, content review for brand/trademark (no third-party bank marks).

## Versioning and force update
Semantic versions; minimum supported version served by the back end; Force update screen (S-CB-092) triggers below minimum.

## Monitoring
Crash reporting, performance traces, release health dashboard, alert on crash spike or login failure spike.
