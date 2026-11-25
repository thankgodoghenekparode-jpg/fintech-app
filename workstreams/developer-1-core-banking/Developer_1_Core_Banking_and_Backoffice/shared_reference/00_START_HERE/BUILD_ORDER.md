# Build Order

Two developers work in parallel. Contracts first, then features, so neither side blocks the other.

## Phase 0 - Foundations (week 1-2)
| Back-end | Front-end |
|---|---|
| Repo, modules skeleton, CI, PostgreSQL, Redis, queue | Repo, Flutter app skeleton, CI, theming from design tokens |
| Auth module (OTP, PIN, device binding, tokens) | Design system components, navigation shell (5 tabs) |
| Ledger and accounts module (see ledger docs) | Mock API server from `openapi_core.yaml` |
| Publish and freeze `openapi_core.yaml` v1 | Central text (i18n) layer |

## Phase 1 - Core banking (week 3-8)
Onboarding and KYC, login, home, add money, transfers (Zenith and other banks), bills and airtime, notifications, statements and receipts, failed-transaction handling, cards (naira), settings, support.

## Phase 2 - Platform services
Back-office console basics, reconciliation with Zenith, fraud rules, audit and reporting.

## Phase 3 - Group engine
Shared multi-tenant group engine, then Cooperative, then Ajo/Esusu (Stage 2 docs).

## Phase 4 - Savings and commerce
Target Savings, Revenue, Pay Am Small (price-lock first), Escrow (Stage 2 docs).

## Phase 5 - Credit and extras
Instant Loan (after lending registration and partner are confirmed), Pay Am Small credit mode, merchant tools, agent network, spending insights and rewards.

## Rules for the two-person team
1. The OpenAPI file is the contract. Change it only by agreement; bump the version; update both copies.
2. Front-end builds against the mock server until the real endpoint is ready.
3. One shared Git repository with `front-end/` and `back-end/` roots, or two repositories under one organisation. Protect `main`; require pull requests.
4. Weekly 30-minute contract review: new endpoints, changed fields, spec gaps.

## Suggested product enablement order (feature flags)
1. Core banking -> 2. Target Savings -> 3. Cooperative and Ajo (group engine) -> 4. Revenue (community collectors) -> 5. Merchant tools -> 6. Pay Am Small (price-lock) -> 7. Escrow -> 8. Agent network -> 9. Spending insights and rewards -> 10. Instant Loan (after registration and partner) -> 11. Pay Am Small credit mode (after the lawyer decision).
Back-office screens for each product are built together with that product's back end.
