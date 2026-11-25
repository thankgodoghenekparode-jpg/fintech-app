# OpenCode Master Prompt Pack (DRAFT for your review)

This pack tells an AI coding agent (OpenCode, or any similar agent) how to build the whole project in stages from the documentation package. It has five parts:

1. Setup (once)
2. `AGENTS.md` - the standing rules (copy to the repo root)
3. Session-start prompt (paste at the start of every session)
4. Stage prompts: Back-end (B0-B19), Front-end (F0-F19), Integration (I1-I3)
5. Reusable prompts (gate review, spec gap, contract change, bug fix, security, release)

Two people, two agents: the back-end developer runs the B-stages, the front-end developer runs the F-stages, and both run the I-stages together. Each stage is small enough to finish in one or a few sessions. Do not skip the gate review after each stage.

---

## 1. Setup (once)

1. Create one GitHub repository (or two under one organisation).
2. Unzip `fintech-bank-docs.zip` and put the folder at `docs/` in the repo root (so you have `docs/front-end`, `docs/back-end`, `docs/00_START_HERE`).
3. Create the repo skeleton from `docs/back-end/00_overview/REPO_STRUCTURE.md` and `docs/front-end/00_overview/REPO_STRUCTURE.md`: `backend/`, `mobile/`, `web/`, `packages/`.
4. Copy the `AGENTS.md` block below to the repo root as `AGENTS.md` (most agent tools read this file; if yours uses another rules file, paste it there).
5. Protect `main` (pull requests only, CI required). Copy the sample workflows from `docs/back-end/13_devops-infrastructure/samples/` and `docs/front-end/11_release-devops/samples/`.
6. Create `SPEC_GAPS.md` in the repo root from `docs/00_START_HERE/SPEC_GAPS_TEMPLATE.md`.
7. Run `python3 docs/00_START_HERE/check_shared_docs.py` to confirm the docs are intact.
8. Start each work session with the prompt in Part 3, then give one stage prompt from Part 4.

---

## 2. AGENTS.md (copy to repo root)

```markdown
# AGENTS.md - Fintech Bank

You are a senior engineer building a naira banking app (backed by a licensed bank) from a complete documentation package in `./docs`. The documentation is the source of truth.

## Stack (decided)
- Mobile: Flutter (Dart). State: Riverpod. Navigation: go_router. HTTP: dio. Models: freezed + json_serializable. Secure storage: flutter_secure_storage.
- Web (dashboards and back office): React + TypeScript with Next.js, TanStack Query, React Hook Form + Zod, Tailwind.
- Back-end: Kotlin + Spring Boot 3 (JVM 21), modular monolith with Spring Modulith, PostgreSQL 16 + Flyway, Redis, message broker via transactional outbox, Gradle (Kotlin DSL), JUnit 5 + Testcontainers + ArchUnit.
- API: contract-first OpenAPI in `docs/back-end/04_api` and per-product specs.

## Where things are
- Start: `docs/00_START_HERE/` (README, AGENT_INSTRUCTIONS, BUILD_ORDER, TRACEABILITY_MATRIX).
- Decisions and open items: `docs/front-end/00_overview/DECISIONS_LOG.md` (identical copy in back-end).
- Config and feature flags: `docs/*/00_overview/CONFIG_AND_FEATURE_FLAGS.md`.
- Back-end: `docs/back-end/` (architecture, database, ledger, api, security, integrations, core banking, products, compliance, operations).
- Front-end: `docs/front-end/` (design system, core banking, products, flowcharts, Stitch pack, api contracts).
- Product docs: `docs/back-end/08_products/<product>/` and `docs/front-end/04_products/<product>/`.

## Hard rules (never break)
1. The docs are the source of truth. If code and docs disagree, stop and report; do not silently choose.
2. Never invent business rules, limits, fees or legal text. If something is missing, write it to `SPEC_GAPS.md` (requirement ID, options, recommended default), implement the default behind a configuration flag, and continue.
3. Anything marked [OPEN], [PROPOSED] or [CONFIRM WITH ZENITH] is configuration or a feature flag, never a constant.
4. Money: integer kobo (`Long` / `int`) everywhere. No floating point. Currency NGN. One shared formatter for display only.
5. Ledger: every money movement is a balanced double-entry posting inside one database transaction. Never update or delete ledger entries; correct with compensating entries. No remote calls inside a ledger transaction.
6. Every money-moving or state-changing financial endpoint is idempotent (`Idempotency-Key`). Unknown outcomes stay PENDING; never mark FAILED without confirmation.
7. Security: no secrets in code or logs; no PII, PINs, tokens, card data in logs; Argon2id for passcode/PIN; encrypt sensitive fields; audit every sensitive action; permissions checked on the server.
8. Multi-tenancy: every tenant-scoped table has `tenant_id`; queries filter by it; row-level security as defence in depth; test cross-tenant access.
9. Modules talk only through public APIs and events (Spring Modulith/ArchUnit must pass). Products never write ledger tables directly; they call the ledger module.
10. Never use the foundation bank's name, logo or icons in the app, code, assets or copy.
11. All user-facing text comes from the central text layer (i18n keys). No hard-coded strings, limits, fees or amounts in UI.
12. Compliance and legal documents are drafts: implement the behaviour they describe, never copy them as final legal text.

## Process rules
- Work in stages. Before coding, read the stage's documents listed in the prompt and the related rows in `TRACEABILITY_MATRIX.md`.
- Reference requirement IDs (for example CB-TRF-004, COOP-LON-003) in commits, tests and code comments. Name tests after the test case IDs in the docs.
- Small commits, conventional messages: `feat(CB-TRF-004): ...`, `test(...)`, `fix(...)`, `docs(...)`.
- Write tests with the code. Money paths need failure-mode tests (timeout, duplicate, unknown outcome). Ledger code needs property tests.
- Keep the two API contracts in sync: if you change an OpenAPI file, change both copies, then run `python3 docs/00_START_HERE/check_shared_docs.py`.
- Update `TRACEABILITY_MATRIX.md` status (NOT STARTED -> IN PROGRESS -> DONE -> VERIFIED) for every requirement you touch.
- Do not add dependencies without need; prefer the stack above. No unlicensed code.

## Commands (adapt if the repo differs)
- Back-end: `./gradlew build`, `./gradlew test`, `./gradlew integrationTest`, `./gradlew ktlintCheck detekt`.
- Mobile: `flutter pub get`, `dart run build_runner build --delete-conflicting-outputs`, `flutter analyze`, `flutter test`.
- Web: `npm ci`, `npm run lint`, `npm run typecheck`, `npm test`, `npm run build`.
- Docs sync: `python3 docs/00_START_HERE/check_shared_docs.py`.

## Stop and ask a human when
- A decision marked [OPEN] must be made to proceed and no safe default exists.
- A change would weaken a hard rule, a security control or a compliance control.
- A required external credential, sandbox or Zenith detail is missing and cannot be stubbed behind an interface.
- Two documents conflict.

## Definition of done (every feature)
All acceptance criteria for its requirement IDs met; unit and integration tests pass; error, empty and offline states handled; API matches OpenAPI exactly; no hard-coded text, limits or fees; audit and security requirements satisfied; traceability matrix updated; CI green.

## Report format (end of every stage)
1. What was built (requirement IDs). 2. Tests added and results. 3. Files/migrations changed. 4. Spec gaps raised. 5. Risks and follow-ups. 6. Exact commands to run and verify.
```

---

## 3. Session-start prompt (paste at the start of every session)

```text
Read AGENTS.md. Then read docs/00_START_HERE/README.md, AGENT_INSTRUCTIONS.md, BUILD_ORDER.md and docs/front-end/00_overview/DECISIONS_LOG.md.
Look at git log and docs/00_START_HERE/TRACEABILITY_MATRIX.md to work out which stages are already done. Tell me in five lines: (1) which stage we are on, (2) what is done, (3) what is in progress, (4) any open spec gaps in SPEC_GAPS.md, (5) your plan for this session.
Then continue with the stage I give you. Do not ask questions you can answer from the docs. Follow AGENTS.md exactly. If a stop-and-ask condition applies, stop and tell me.
```

---

## 4. Stage prompts

How to use: paste ONE stage prompt at a time. Each says what to read, what to build, and when it is done. Paths are relative to `docs/`.

### 4A. Back-end stages (B0-B19)

**B0 - Repo and tooling**
```text
STAGE B0: Back-end repository and tooling.
Read: back-end/00_overview/*, back-end/13_devops-infrastructure/* (including samples/), back-end/01_architecture/ARCHITECTURE_OVERVIEW.md and MODULE_BOUNDARIES.md.
Build: Gradle (Kotlin DSL) project with the module layout from REPO_STRUCTURE.md (app, modules/*, integrations, shared-kernel); Spring Boot 3 + Spring Modulith; docker-compose for PostgreSQL, Redis, RabbitMQ/Kafka, WireMock; Flyway wired with V001 from back-end/02_database/schema_core.sql (review it, fix any SQL issue you find and record it in SPEC_GAPS.md); health and info endpoints; ktlint + detekt; Modulith verification test and ArchUnit rules; CI workflow from samples; OpenAPI code generation set up from back-end/04_api/openapi_core.yaml.
Done when: ./gradlew build passes, docker compose up works, Flyway migrates cleanly on an empty database, CI is green, the architecture test fails if a module boundary is broken (prove it with a deliberate violation, then revert).
```

**B1 - Platform foundation**
```text
STAGE B1: Platform and shared kernel.
Read: back-end/00_overview/CODING_STANDARDS.md, 01_architecture/* (ADRs, EVENT_CATALOG, MULTI_TENANCY_MODEL), 03_ledger-and-accounts/IDEMPOTENCY_AND_CONCURRENCY.md, 04_api/API_CONVENTIONS.md and ERROR_CODES.md, 00_overview/CONFIG_AND_FEATURE_FLAGS.md.
Build: Money value object (Long kobo), ids (UUIDv7), clock, typed errors mapped to the error codes, request-id/trace filters, idempotency middleware using platform.idempotency_keys (same key + same hash returns stored response; different hash returns IDEMPOTENCY_KEY_REUSED; in-progress returns REQUEST_IN_PROGRESS), transactional outbox + publisher, audit log service, config entries with versions and dual-control approvals (platform.approvals, requester != approver), feature flags, tenants and membership tables and services, staff users.
Tests: idempotency (replay, conflict, concurrent), outbox at-least-once, approvals cannot be self-approved, config version effective dates.
Done when: all tests pass and the module exposes public APIs only.
```

**B2 - Ledger and accounts**
```text
STAGE B2: Ledger and accounts.
Read: back-end/03_ledger-and-accounts/* (LEDGER_DESIGN, ACCOUNT_MODEL, RECONCILIATION), back-end/02_database/schema_core.sql (ledger and accounts schemas), back-end/07_core-banking/CORE_TEST_CASES.md (TC-BE-LED, TC-BE-IDM, TC-BE-CON).
Build: ledger module with a single public posting API (balanced check, deterministic account locking by id, available balance after lock), system accounts seed, customer accounts and pockets, holds API, daily_usage counters, limits from accounts.tier_limits, balance verification job, immutable-entry triggers and deferred balance trigger as in the schema.
Tests: property tests (random postings always balance), trigger tests (update/delete blocked, unbalanced fails at commit), 100 parallel debits never overspend, opposite transfers do not deadlock, holds reduce available balance.
Done when: TC-BE-LED-*, TC-BE-IDM-*, TC-BE-CON-* all pass.
```

**B3 - Identity, KYC and auth**
```text
STAGE B3: Identity, KYC and authentication.
Read: back-end/05_security-auth/*, back-end/06_integrations/INTEGRATION_CATALOG.md (INT-04 to INT-07, INT-10), back-end/07_core-banking/PRD_CORE_BANKING.md (CB-ONB, CB-SEC), KYC_TIERS_AND_LIMITS.md, flowcharts back-end/17_flowcharts-drawio/shared-core-flows/F-01 and F-02 and B-06, B-08.
Build: OTP service (Redis, hashed, rate limited); onboarding endpoints per openapi_core.yaml; adapters behind interfaces with WireMock stubs for BVN, NIN, liveness, sanctions, SMS; credentials (Argon2id, separate salts, lockouts); JWT access + rotating refresh tokens with reuse detection; device binding and device list/removal; PIN verification returning single-use pin tokens; consents (versioned); customer account creation through the foundation-bank adapter (idempotent, PENDING_ACCOUNT on failure); tier assignment.
Tests: TC-BE-AUT-*, TC-BE-KYC-*, TC-BE-ACC-001, provider-down behaviour, duplicate BVN.
Done when: the onboarding and login journeys work end to end against stubs and tests pass.
```

**B4 - Payments (transfers)**
```text
STAGE B4: Payments.
Read: back-end/07_core-banking/TRANSFERS.md, FEES_AND_CHARGES.md, FUNDING.md, REVERSALS_AND_DISPUTES.md, back-end/06_integrations (INT-01 to INT-03), flows B-01, B-02, B-03, back-end/04_api/openapi_core.yaml (name-enquiry, transfers, beneficiaries).
Build: name enquiry; fee and limit engine (config-driven); quote then submit with pin token; internal transfer posting; interbank debit-first posting with in-transit account, status-query job with backoff, automatic reversal on confirmed failure, PENDING for unknown outcomes; inbound credit webhook (signature, dedupe, suspense for unknown accounts); beneficiaries; scheduled payments job; transaction history and detail endpoints; receipts data.
Tests: TC-BE-TRF-*, TC-BE-FUN-*, timeout/duplicate/unknown-outcome scenarios against WireMock.
Done when: all pass and the transfer journey works with stubs.
```

**B5 - Bills, cards, notifications, support, statements**
```text
STAGE B5: Bills and airtime, cards, notifications, support, statements.
Read: back-end/07_core-banking/BILLS_AIRTIME.md, CARDS.md, STATEMENTS_RECEIPTS.md, back-end/11_notifications/*, back-end/09... (consumer protection only), flows B-07, INT-08 to INT-13.
Build: billpay module (validate, vend, pending/refund logic); cards module (create, freeze, limits, reveal details via provider proxy without storing PAN/CVV, webhooks); notifications module (catalogue keys, channels, delivery rules, in-app inbox, preferences, provider adapters with fallbacks); support tickets linked to transactions; statements as async jobs with signed URLs.
Tests: TC-BE-BIL-*, TC-BE-CRD-001, notification dedupe and fallback.
Done when: tests pass and the core API in openapi_core.yaml is fully implemented.
```

**B6 - Back-office core and reconciliation**
```text
STAGE B6: Back-office core, approvals and reconciliation.
Read: back-end/10_back-office-admin/*, back-end/10_back-office-admin/openapi_backoffice.yaml, back-end/03_ledger-and-accounts/RECONCILIATION.md, flows BO-F01 to BO-F05 and B-04, B-05, roles in 00_overview/ROLES_AND_PERMISSIONS.md.
Build: staff auth with MFA and roles; customer 360 with masking and unmask-with-reason (audited); KYC queue and decisions; transaction search; approvals inbox and dual-control execution for reversals, manual postings, limits and config; freeze/unfreeze; audit log API; daily reconciliation job and exceptions workflow; suspense handling; basic reports.
Tests: TC-BE-REV-001, TC-BE-REC-001, TC-BE-SEC-001, role and masking tests.
Done when: openapi_backoffice.yaml is implemented and tests pass.
```

**B7 - Target Savings**
```text
STAGE B7: Target Savings. Read: back-end/08_products/target-savings/* (all files) and the matching flows in back-end/17_flowcharts-drawio/target-savings/. Build everything in 01_business_rules.md to 07_events_and_notifications.md: migration from 05_database_schema.sql, endpoints per 04_api_spec.yaml, pockets via the ledger module, auto-save jobs, withdrawal quote/confirm with penalty snapshot, ledger postings per 06_ledger_entries.md, events and notifications. Tests: every case in 08_test_cases.md. Feature flag product.target_savings. Done when all pass.
```

**B8 - Group engine and Cooperative**
```text
STAGE B8: Group engine and Cooperative.
Read: back-end/01_architecture/MULTI_TENANCY_MODEL.md, back-end/08_products/cooperative/* and back-end/08_products/ajo-esusu/01_business_rules.md (to design the shared engine), flowcharts back-end/17_flowcharts-drawio/cooperative/.
Build first the shared group engine (tenants, members and roles, approval workflows, schedules, rules engine with versioned JSON rule sets validated by schema, holds, dashboards data) inside the platform/shared area; then the cooperative module on top: lifecycle, join requests, contribution plans and dues, auto-deduct with retries and penalties, shares and dividends, loan applications with guarantors and dual approval, holds, repayments and recovery, dual-control withdrawals with cooling-off, succession, books (two linked ledger transactions per event as in 06_ledger_entries.md), reports, row-level security.
Tests: all TC-BE-COOP-* plus RLS tests. Feature flag product.cooperative. Done when all pass.
```

**B9 - Ajo / Esusu**
```text
STAGE B9: Ajo/Esusu. Read: back-end/08_products/ajo-esusu/* and flowcharts. Build on the group engine from B8: circles, members, order (random draw with stored seed, chosen, organizer-set), rounds and payouts with idempotency keys ajo:<circle>:<round>, auto-debit with retries and grace, protection modes (deposit and guarantor cover, invocation order), delinquency and defaults, trust scores, cycle end and account closure. The platform never covers shortfalls from its own funds. Tests: TC-BE-AJO-*. Flag product.ajo.
```

**B10 - Revenue**
```text
STAGE B10: Revenue. Read: back-end/08_products/revenue/* and flowcharts. Build: collector tenants and verification, items and bill generation, payer registry and CSV import, payer-specific virtual accounts and automatic matching, in-app payments with the fee model (collector pays by default; in-app free for payers), cash recording as off-platform until deposit, settlement, disputes ("This isn't mine"), abuse reports and suspension, reports. Tests: TC-BE-REV-*. Flags product.revenue (government features stay off).
```

**B11 - Merchant tools**
```text
STAGE B11: Merchant tools. Read: back-end/08_products/merchant-tools/* and flowcharts. Build: business tenants and verification (reuse the platform business-verification capability), payment links and QR (static/dynamic) with link-specific virtual accounts, invoices and statuses, payments and fees, refunds with limits and dual control, payouts, team roles, reports. Tests: TC-BE-MER-*. Flag product.merchant.
```

**B12 - Pay Am Small (price-lock)**
```text
STAGE B12: Pay Am Small, price-lock mode only.
Read: back-end/08_products/pay-am-small/* and flowcharts; decisions D-020 to D-022 and P-004, P-006.
Build: vendors (tenants, verification, products, stock reservation and price lock), vaults as customer pockets, one vault for items bought together, auto-debit and manual top-ups, deadline decisions (extend or refund minus fee), early withdrawal with the penalty snapshot, vault completion payout to vendors with commission and holdback, delivery codes, orders and fulfilment, non-fulfilment refunds, ratings. It is NOT escrow: no buyer release step. Keep the credit endpoints compiled but disabled behind product.pay_am_small.credit.
Tests: TC-BE-PAS-001 to 009 and 012. Flag product.pay_am_small.
```

**B13 - Escrow**
```text
STAGE B13: Escrow. Read: back-end/08_products/escrow/* and flowcharts. Build: templates, deals and terms snapshot with both-party acceptance, fee payer and per-scenario cancellation fee options, dedicated deal account, funding, delivery and milestone submission, delivery code, releases and auto-release timers (never while disputed), disputes (freeze, evidence, deadlines, decision, one appeal by a different officer), cancellations with minimum charge, agent commission, ratings, chat and evidence storage with signed URLs, staff dispute console APIs. Tests: TC-BE-ESC-*. Flag product.escrow.
```

**B14 - Agent network**
```text
STAGE B14: Agent network. Read: back-end/08_products/agent-network/* and flowcharts. Build: agent onboarding and approval, float wallets, cash-in, cash-out with single-use expiring codes and holds, commission accrual and payout, day-end reconciliation, locator search, limits and monitoring hooks. Tests: TC-BE-AGT-*. Flag product.agents.
```

**B15 - Spending insights and rewards**
```text
STAGE B15: Insights and rewards. Read: back-end/08_products/spending-insights-rewards/* and flowcharts. Build: categorisation rules with user overrides, monthly summaries, budgets and alerts, consent-gated personalisation, reward campaigns with caps and a global budget, idempotent reward evaluation, delayed credit and reversal, referrals paid only after the first qualifying transaction with fraud checks. Tests: TC-BE-INS-*. Flags product.insights, product.rewards.
```

**B16 - Instant Loan**
```text
STAGE B16: Instant Loan. Read: back-end/08_products/instant-loan/*, back-end/09_compliance-and-policies/DIGITAL_LENDING_COMPLIANCE.md and flowcharts. Build: versioned products (dual control), decision engine with stored inputs/reason codes, limit ladder, quotes with cost summary and affordability data, agreement acceptance with version and hash, disbursement and schedule, repayments and auto-repay, arrears and hardship cases, collections contact rules (approved channels and hours; no third-party contact), funding sources and partner settlement. Keep behind product.instant_loan; do not enable until the registration status is confirmed. Tests: TC-BE-LOAN-*.
```

**B17 - Pay Am Small credit mode**
```text
STAGE B17: Pay Am Small credit mode (vendor-funded). Read: back-end/08_products/pay-am-small/* (credit sections) and decision O-009. Build credit requests and vendor decisions, credit plans and repayment pass-through to vendors less commission, late fee caps, records for vendors. Keep disabled behind product.pay_am_small.credit until the lawyer decision is recorded in the DECISIONS_LOG. Tests: TC-BE-PAS-010 and 011.
```

**B18 - Compliance hooks and reporting**
```text
STAGE B18: Compliance hooks and reporting.
Read: back-end/09_compliance-and-policies/* (TRANSACTION_MONITORING_RULES, SANCTIONS_PEP_SCREENING, RECORD_RETENTION_SCHEDULE, DATA_PROTECTION_NDPA), back-end/15_reporting-analytics/*, back-end/11_notifications/*.
Build: rules engine implementing TM-001 to TM-015 as configurable rules with actions (alert, step-up, hold, block) and case queue; sanctions/PEP screening integration points; retention and anonymisation jobs; data-subject request tooling; reporting views on a read replica; analytics event pipeline (consent gated). Tests: rule unit tests with fixtures; retention job tests.
```

**B19 - Hardening and launch readiness**
```text
STAGE B19: Hardening.
Read: back-end/12_operations/*, back-end/14_testing-qa/*, back-end/05_security-auth/SECURITY_REQUIREMENTS.md.
Do: implement monitoring metrics, dashboards definitions and alerts from MONITORING_AND_ALERTING.md; structured logging audit (no PII); rate limits; security fixes from the security test plan; performance tests (k6/Gatling) per PERFORMANCE_TEST_PLAN.md and fix bottlenecks; DR restore drill script; runbook verification (each runbook step is executable or documented); final traceability review listing any NOT STARTED P0 requirement.
Done when: launch readiness checklist items for the back end are green, and you list what remains.
```

### 4B. Front-end stages (F0-F19)

**F0 - Repo, tokens and mock server**
```text
STAGE F0: Front-end repo and tooling.
Read: front-end/00_overview/*, front-end/01_architecture/*, front-end/02_design-system/DESIGN_TOKENS.json, front-end/07_api-contracts/*, front-end/11_release-devops/*.
Build: mobile/ Flutter project with the feature-first structure from REPO_STRUCTURE.md; web/ Next.js project; packages/design-tokens generating Flutter and web theme code from DESIGN_TOKENS.json; packages/api-client generated from openapi_core.yaml (Dart and TypeScript); a mock API server generated from the OpenAPI files (Prism or similar); i18n setup (ARB for Flutter, next-intl for web) with English keys; lint rules; CI from samples.
Done when: both apps run, tokens generate, the client compiles, and CI is green.
```

**F1 - Design system components**
```text
STAGE F1: Design system.
Read: front-end/02_design-system/* (COMPONENT_LIBRARY, CARD_DESIGN_SPEC, MOTION_AND_FEEDBACK, DESIGN_PRINCIPLES), front-end/12_content-and-legal-screens/CONTENT_GUIDE.md.
Build every component in COMPONENT_LIBRARY.md for Flutter (and the web list for Next.js) using tokens only, in light and dark, with states (default, pressed, disabled, loading, error) and accessibility labels. Include AppButton, AppTextField variants, PinPad, OtpInput, AmountInput, StatusChip, ListRow, TransactionRow, BottomSheet, ConfirmSheet, Banner, EmptyState, ErrorState, SkeletonLoader, progress ring/bar, BottomNavBar, CardView with all six themes and frozen state, Receipt layout. Add a component gallery screen and golden tests.
Done when: goldens pass in light/dark and large text, and the gallery shows every component.
```

**F2 - Onboarding and auth**
```text
STAGE F2: Onboarding and login.
Read: front-end/03_core-banking/PRD_CORE_BANKING.md (CB-ONB, CB-SEC), SCREEN_INVENTORY.md, UI_UX_SPEC.md (S-CB-001 to S-CB-015), VALIDATION_AND_ERRORS.md, USER_FLOWS.md F-01/F-02, flowcharts F-01 and F-02, front-end/08_security/FE_SECURITY_SPEC.md, the Stitch screens for these IDs as visual reference.
Build: screens S-CB-001 to S-CB-015 with controllers (Riverpod), the API client calls, secure token storage, biometric unlock, device binding flow, custom PIN pad, session manager (inactivity lock, refresh once on 401), central text keys for all copy, validation per the table.
Tests: TC-FE-ONB-*, TC-FE-SEC-001/002, widget tests for every state (loading, error, empty).
Done when: the full journey works against the mock server and goldens pass.
```

**F3 - Home, accounts and history**
```text
STAGE F3: Home and accounts. Read: PRD (CB-ACC, CB-SAV), UI_UX_SPEC S-CB-020 to S-CB-025, S-CB-043, S-CB-060, S-CB-070 to S-CB-075. Build: five-tab shell and navigation map, Home (balance hide/show persisted, quick actions, card carousel, recent activity), notification centre, transaction detail, receipt (share as image and PDF), add money, account details, history with search/filter/pagination, Save & Borrow landing driven by feature flags, More hub. Tests: TC-FE-HOM-*, TC-FE-TRF-007.
```

**F4 - Transfers**
```text
STAGE F4: Transfers. Read: PRD (CB-TRF), UI_UX_SPEC S-CB-030 to S-CB-039, flowchart F-04, FLUTTER_ARCHITECTURE.md (money-moving screen pattern). Build: recipient selection with name enquiry, amount with limits, quote then confirm sheet, PIN, one idempotency key per intent, processing/success/pending/failed result with status polling and push updates, beneficiaries, scheduled payments, request money, QR. Never show "failed" for unknown outcomes. Tests: TC-FE-TRF-001 to 006 including double-tap and timeout-then-pending.
```

**F5 - Bills and airtime**
```text
STAGE F5: Bills and airtime. Read: PRD (CB-BIL), UI_UX_SPEC S-CB-040 to S-CB-042, flowchart F-05. Build the airtime/data and bills flows with validation, packages, saved billers, schedule option, token display, refund messaging. Tests: TC-FE-BIL-*.
```

**F6 - Cards**
```text
STAGE F6: Cards. Read: PRD (CB-CRD), CARD_DESIGN_SPEC.md, UI_UX_SPEC S-CB-050 to S-CB-055, flowchart F-06, FE_SECURITY_SPEC.md. Build card list/carousel, create flow with live theme preview, freeze toggle, limits, secure details reveal (PIN, 30-second auto-hide, screen-capture protection, in-memory only), alerts. Tests: TC-FE-CRD-*, TC-FE-SEC-003.
```

**F7 - Support, KYC upgrade, settings, system states**
```text
STAGE F7: Support, KYC upgrade, settings, system states. Read: PRD (CB-SUP, CB-SET), UI_UX_SPEC S-CB-071 to S-CB-094, flowcharts F-07 to F-10, front-end/12_content-and-legal-screens/*. Build help centre, support chat, report-a-problem, tickets, KYC tier upgrade with document upload, security hub (devices, lock account), limits, statements, legal and consent screens, locator, close account, offline/maintenance/force-update/locked screens. Tests: TC-FE-SUP-001, TC-FE-SET-001, TC-FE-OFF-001, accessibility tests TC-FE-A11Y-*.
```

**F8 - Web shell and back-office console**
```text
STAGE F8: Web shell and back office. Read: front-end/01_architecture/WEB_DASHBOARD_ARCHITECTURE.md, front-end/03_core-banking/BACKOFFICE_UI_SPEC.md, front-end/07_api-contracts/openapi_backoffice.yaml, flowcharts backoffice/*, FE_SECURITY_SPEC.md (web section). Build the Next.js shell (role-based navigation, tenant switcher, DataTable, FilterDrawer, DetailDrawer, ApprovalBanner, AuditTimeline), then the staff screens W-BO-001 to W-BO-011 and W-BO-016 to W-BO-020 against the mock server. Mask data by default; unmask requires a reason modal. Tests: Vitest and Playwright smoke per screen.
```

**F9 - Target Savings**
```text
STAGE F9: Target Savings (mobile). Read: front-end/04_products/target-savings/* (all files), flowcharts target-savings/, Stitch prompts in front-end/06_stitch-ui-ux/05_products/target-savings/. Build screens S-TGT-001 to S-TGT-009 with server-driven quotes (never compute money on the client), milestone moments, friction on early withdrawal. Tests: TC-FE-TGT-*.
```

**F10 - Cooperative (mobile and web)**
```text
STAGE F10: Cooperative. Read: front-end/04_products/cooperative/* and flowcharts cooperative/. Build mobile screens S-COOP-001 to S-COOP-017 and web admin screens W-COOP-001 to W-COOP-014, with tenant context (X-Tenant-Id), guarantor flow with PIN, cover meter, schedule rendering from server data, dual-approval states, cooling-off countdown, rule versions with pending approval banners. Tests: TC-FE-COOP-*.
```

**F11 - Ajo / Esusu**
```text
STAGE F11: Ajo/Esusu. Read: front-end/04_products/ajo-esusu/*. Build S-AJO-001 to S-AJO-014 and W-AJO-001: create circle with protection mode explanation, invite, join, protection setup, order draw display, tracker with who paid and payout countdown, trust badges, summary and renewal. State clearly that the platform does not guarantee payouts. Tests: TC-FE-AJO-*.
```

**F12 - Revenue**
```text
STAGE F12: Revenue. Read: front-end/04_products/revenue/*. Build payer screens S-REV-001 to S-REV-008, field collector screens S-REV-009 and S-REV-010 (short offline queue with idempotency), and collector web W-REV-001 to W-REV-008 including import wizard and fee model preview. Tests: TC-FE-REV-*.
```

**F13 - Merchant tools and Agent network**
```text
STAGE F13: Merchant tools and Agent network. Read: front-end/04_products/merchant-tools/* and agent-network/*. Build S-MER-001 to S-MER-010 and W-MER-001 to W-MER-005 (cashier mode listens for payment events), then S-AGT-001 to S-AGT-013 and W-AGT-001 to W-AGT-003 (agent mode switcher in More, locator, cash-out code countdown). Tests: TC-FE-MER-*, TC-FE-AGT-*.
```

**F14 - Pay Am Small (buyer mobile and vendor web)**
```text
STAGE F14: Pay Am Small. Read: front-end/04_products/pay-am-small/*. Build S-PAS-001 to S-PAS-013 and vendor web W-PAS-001 to W-PAS-007: marketplace, plan setup with penalty and deadline rules before PIN, vault detail, deadline decision, order tracking with delivery code, credit repayment screen (hidden unless product.pay_am_small.credit is on). Do not use escrow wording. Tests: TC-FE-PAS-*.
```

**F15 - Escrow**
```text
STAGE F15: Escrow. Read: front-end/04_products/escrow/*. Build S-ESC-001 to S-ESC-013 and W-ESC-001 to W-ESC-004: create deal with templates, fee and cancellation options with the mandatory plain summary, negotiation and acceptance, funding, delivery and milestones, confirm/release with delivery code, dispute flow and tracker, cancel, receipt and rating. Show the server-provided nextAction on every deal. Tests: TC-FE-ESC-*.
```

**F16 - Insights and rewards**
```text
STAGE F16: Insights and rewards. Read: front-end/04_products/spending-insights-rewards/*. Build S-INS-001 to S-INS-009 and W-INS-001 to W-INS-003, consent-gated personalisation, budgets and alerts, rewards and referral screens. No interest or return claims in copy. Tests: TC-FE-INS-*.
```

**F17 - Instant Loan**
```text
STAGE F17: Instant Loan. Read: front-end/04_products/instant-loan/* and back-end/09_compliance-and-policies/DIGITAL_LENDING_COMPLIANCE.md. Build S-LOAN-001 to S-LOAN-012 and W-LOAN-001 to W-LOAN-004: lender identity and registration labels from configuration, server cost summary, affordability, agreement with PIN, repayment, hardship, privacy promise. No promotion outside the Borrow area; no urgency patterns. Keep behind product.instant_loan. Tests: TC-FE-LOAN-*.
```

**F18 - Accessibility, performance, hardening**
```text
STAGE F18: Accessibility, performance and hardening. Read: front-end/09_accessibility-performance/*, front-end/08_security/*, front-end/10_testing-qa/*. Do: audit every screen against the accessibility checklist (contrast, text scaling to 200%, labels, tap targets, screen reader order) and fix; measure cold start, list performance and app size against the budgets on a low-end Android profile and fix; verify no PII or sensitive data in logs or analytics; check offline, pending and error states on every money screen; review all copy against CONTENT_GUIDE.md. Output a pass/fail table by screen ID.
```

**F19 - Release**
```text
STAGE F19: Release. Read: front-end/11_release-devops/FE_RELEASE_AND_CICD.md and front-end/12_content-and-legal-screens/*. Do: configure signing and environments, staged rollout pipeline, store listing checklist (privacy policy URL, data safety forms, permission justifications, screenshots), minimum-version force update, crash and performance monitoring, release notes. Confirm no third-party bank marks in any asset. List remaining blockers.
```

### 4C. Integration stages (both developers, with both agents)

**I1 - Contract sync and first end-to-end (after B5 and F7)**
```text
STAGE I1: Integration. Both sides: run python3 docs/00_START_HERE/check_shared_docs.py. Regenerate the Dart/TypeScript clients from the back-end OpenAPI. Switch the mobile app from the mock server to the real back end (dev environment with stubbed providers). Run end-to-end journeys: onboarding to account, add money (simulated inbound credit), transfer (success, pending, failed), bill purchase, card create/freeze. Fix contract mismatches by changing the code (or, with agreement, both OpenAPI copies). Record results per journey.
```

**I2 - Products integration (after each product pair)**
```text
STAGE I2: For product <NAME>, switch the front-end from mocks to the real endpoints, run the product's end-to-end journeys from the flowcharts (happy path and the main failure paths), verify tenant isolation, feature flag on/off behaviour, notifications received, and ledger postings (balanced, correct accounts). Report defects with requirement IDs.
```

**I3 - Pre-launch (everything)**
```text
STAGE I3: Pre-launch verification. Run the full regression, load test, security checks, DR restore drill and the UAT scripts. Produce the launch readiness report: P0 requirements status from TRACEABILITY_MATRIX.md, open spec gaps, open [OPEN] decisions that block launch, and a go/no-go recommendation per product.
```

---

## 5. Reusable prompts

**Stage gate review (after every stage)**
```text
Do a gate review of the stage you just finished. (1) Re-read the stage's documents and list every requirement ID in scope. (2) For each, show where it is implemented and which test covers it; list any not implemented. (3) Run the full build, tests, lint and the shared-docs check and paste the results. (4) Check AGENTS.md hard rules one by one against your changes (money in kobo, balanced ledger, idempotency, no PII in logs, tenant isolation, no hard-coded text or limits, no bank branding). (5) Update TRACEABILITY_MATRIX.md statuses. (6) Write the report in the AGENTS.md format. Do not mark the stage done if anything fails.
```

**Spec gap**
```text
You found something the docs do not specify. Do not invent it. Add an entry to SPEC_GAPS.md (requirement ID, the question, the options, your recommended default). Implement the default behind a configuration flag, add a test for it, and continue. Tell me about it in the stage report.
```

**API contract change**
```text
A change to the API is needed. Propose the exact change to the OpenAPI file (paths, schemas, error codes), explain why, and list the screens and endpoints affected. After I approve: update docs/back-end/.../openapi*.yaml and its front-end copy, run python3 docs/00_START_HERE/check_shared_docs.py, regenerate clients, update tests, and bump the changelog.
```

**Bug fix**
```text
Fix this bug: <description>. First write a failing test that reproduces it (name it after the requirement ID or test case ID). Then fix it with the smallest change. If money, ledger or authentication is involved, also add a regression test for the failure mode. Run the whole suite. Explain the root cause in three sentences.
```

**Security review**
```text
Review the code from this stage for security: authz on every endpoint (including tenant checks), input validation, idempotency abuse, injection, secrets and logging of sensitive data, rate limits, webhook signature and replay handling, file upload handling, error messages leaking internals, insecure defaults. List findings by severity with file and line, fix high and critical ones, and add tests.
```

**Refactor with boundaries**
```text
Refactor without changing behaviour: <goal>. Keep module boundaries (Modulith/ArchUnit must pass). Keep public APIs and OpenAPI unchanged. All existing tests must pass before and after. Show the diff summary.
```

**Release prompt (per release)**
```text
Prepare release <version>: run the full test suites, the contract and shared-docs checks, dependency and container scans, and the migration test against the previous schema. Draft release notes from commits (requirement IDs), list feature flags and their intended state, list any config values that must be set, write the rollback steps, and stop for human approval before tagging.
```

## 6. Rules of thumb for you (the human)
- Run one stage per session when possible, and always finish with the gate review prompt.
- If the agent starts to invent rules, remind it of rule 2 in AGENTS.md and ask it to use SPEC_GAPS.md.
- Keep the two sides in sync weekly: contract review, shared docs check, traceability matrix review.
- Enable a product only when its stage is verified, its flag is on in staging, and its compliance items (documentation Part 09, 16) are cleared. Loans and Pay Am Small credit mode stay off until the lawyer and Zenith decisions are recorded.
- Keep the [OPEN] decisions list in front of you: those need your decisions, not the agent's.
