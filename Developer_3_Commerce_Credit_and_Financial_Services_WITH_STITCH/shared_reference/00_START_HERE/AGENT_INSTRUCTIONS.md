# Instructions for AI Code Agents

Read this file fully before writing any code.

## Ground rules
1. The documents are the source of truth. If code and documents disagree, stop and flag it. Do not silently choose.
2. Never invent business rules. If a rule is missing, mark `TODO(spec-gap)` in code and list it in `SPEC_GAPS.md` in the repo root.
3. Items marked `[OPEN]` or `[CONFIRM WITH ZENITH]` must be built as configurable values (config or database), never hard-coded.
4. Money rules: amounts are integers in kobo (minor units), never floating point. Currency is NGN in v1. Every money-moving request carries an idempotency key. Every movement is a balanced double-entry posting.
5. Every requirement has an ID (for example `CB-TRF-004`). Reference IDs in commit messages, tests and code comments.
6. Do not use the Zenith Bank name, logo or icons anywhere in the app, code or assets.
7. All user-facing text comes from the central text layer (i18n keys), never hard-coded in widgets or components.
8. Security first: no secrets in code, no sensitive data in logs, encrypt sensitive fields, record every sensitive action in the audit log.

## Front-end agent: read order
1. `front-end/00_overview/*`
2. `front-end/01_architecture/*`
3. `front-end/02_design-system/*`
4. `front-end/03_core-banking/PRD_CORE_BANKING.md`, `SCREEN_INVENTORY.md`, `USER_FLOWS.md`, `UI_UX_SPEC.md`, `VALIDATION_AND_ERRORS.md`
5. `front-end/05_flowcharts-drawio/*.md` (text versions of each flow)
6. `front-end/07_api-contracts/openapi_core.yaml`
7. `front-end/08_security`, `09_accessibility-performance`, `10_testing-qa`, `12_content-and-legal-screens`
8. Product folders in `front-end/04_products/` (Stage 2)

## Back-end agent: read order
1. `back-end/00_overview/*`
2. `back-end/01_architecture/*`
3. `back-end/03_ledger-and-accounts/*` (the ledger is the heart of the system)
4. `back-end/02_database/schema_core.sql`
5. `back-end/04_api/openapi_core.yaml`, `API_CONVENTIONS.md`, `ERROR_CODES.md`
6. `back-end/05_security-auth/*`, `06_integrations/*`
7. `back-end/07_core-banking/*`
8. `back-end/17_flowcharts-drawio/*.md`
9. Product folders in `back-end/08_products/` (Stage 2)

## Definition of done (every feature)
- Implements all acceptance criteria for its requirement IDs.
- Unit and integration tests written, named after the test case IDs.
- Error states and empty states handled as specified.
- No hard-coded text, limits or fees.
- API matches the OpenAPI contract exactly; contract tests pass.
- Audit logging and security requirements satisfied.
- Entry added to the traceability matrix.

## When something is unclear
Write the question into `SPEC_GAPS.md` with the requirement ID, the options you see and your recommended default, then continue with the default behind a configuration flag.

## Additional read order (all stages)
- Both agents: `00_overview/CONFIG_AND_FEATURE_FLAGS.md` and `00_overview/DECISIONS_LOG.md` before any product work; products only after core banking works.
- Product work: open the product's `PRD.md`, then (front-end) `01_user_flows.md` to `07_test_cases.md`; (back-end) `01_business_rules.md` to `08_test_cases.md`.
- Back-office: `back-end/10_back-office-admin/*`, `front-end/03_core-banking/BACKOFFICE_UI_SPEC.md`, `front-end/07_api-contracts/openapi_backoffice.yaml`.
- Operations and release: `back-end/12_operations`, `13_devops-infrastructure`, `14_testing-qa`, `front-end/11_release-devops`.
- Compliance and legal documents are DRAFTS: implement the product behaviour they describe, but do not treat their text as final legal wording.
- Notifications: `back-end/11_notifications/NOTIFICATION_CATALOG.md` (shared with the front-end).
