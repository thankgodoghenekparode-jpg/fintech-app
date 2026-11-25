# Front-end Test Strategy and Core Banking Test Cases

## Layers
1. Unit tests: formatters, validators, controllers, mappers (target 80% on logic code).
2. Widget tests: each design-system component and each screen state (loading, empty, error, success).
3. Golden tests: key screens in light/dark and large text.
4. Integration tests against the mock server and later the staging back end (critical journeys: onboarding, login, transfer, bill, card).
5. Contract tests: generated API client vs OpenAPI.
6. Accessibility and performance checks (see accessibility document).
7. Device matrix: 3 low-end Android, 2 mid-range Android, 2 iPhones (current and two versions back), small and large screens.

## Release gate
All P0 test cases pass; no open severity-1/2 defects; accessibility checks pass; performance budget met.

## Core banking test cases
| ID | Scenario | Requirement |
|---|---|---|
| TC-FE-ONB-001 | Sign up with valid phone and OTP reaches Personal details | CB-ONB-001 |
| TC-FE-ONB-002 | Wrong OTP shows error and does not advance; 5 wrong tries lock | CB-ONB-001 |
| TC-FE-ONB-003 | BVN mismatch shows explanation and allows edit | CB-ONB-003 |
| TC-FE-ONB-004 | Liveness failure allows 3 retries then manual-review message | CB-ONB-005 |
| TC-FE-ONB-005 | Quit mid-onboarding and resume at the same step | CB-ONB-011 |
| TC-FE-SEC-001 | New device triggers OTP and selfie before Home | CB-SEC-002 |
| TC-FE-SEC-002 | Inactivity locks the app; biometric unlocks | CB-SEC-005 |
| TC-FE-SEC-003 | Card details auto-hide after 30 seconds and screenshots are blocked | CB-CRD-005 |
| TC-FE-HOM-001 | Home shows skeleton, then balance, cards and 5 recent transactions | CB-ACC-002 |
| TC-FE-HOM-002 | Hide/show balance persists across sessions | CB-ACC-002 |
| TC-FE-TRF-001 | Transfer happy path: recipient, name enquiry, amount, confirm, PIN, success, receipt | CB-TRF-002 |
| TC-FE-TRF-002 | Insufficient funds blocks Continue with clear message | CB-TRF-004 |
| TC-FE-TRF-003 | Above-limit amount shows Upgrade link | CB-TRF-012 |
| TC-FE-TRF-004 | Double-tap on Confirm sends once (same idempotency key) | CB-TRF-006 |
| TC-FE-TRF-005 | Timeout after submit shows Pending, not Failed; later updates to final state | CB-TRF-007 |
| TC-FE-TRF-006 | Failed transfer shows reason and Try again without duplicating | CB-TRF-005 |
| TC-FE-TRF-007 | Receipt shares as image and PDF with correct fields | CB-TRF-008 |
| TC-FE-BIL-001 | Airtime purchase success and receipt | CB-BIL-001 |
| TC-FE-BIL-002 | Meter validation failure blocks payment | CB-BIL-003 |
| TC-FE-BIL-003 | Failed vend shows refund message | CB-BIL-004 |
| TC-FE-CRD-001 | Create card with name and theme appears in carousel | CB-CRD-001 |
| TC-FE-CRD-002 | Freeze toggles instantly and shows overlay | CB-CRD-003 |
| TC-FE-CRD-003 | Limit cannot exceed account tier limit | CB-CRD-004 |
| TC-FE-SUP-001 | Report a problem creates ticket and shows number | CB-SUP-003 |
| TC-FE-SET-001 | Lock account requires PIN and shows locked state | CB-SEC-006 |
| TC-FE-OFF-001 | Offline shows banner, cached data, disables money actions | NFR-005 |
| TC-FE-A11Y-001 | All screens pass screen reader walkthrough | NFR-007 |
| TC-FE-A11Y-002 | 200% text size does not clip on any core screen | NFR-007 |
