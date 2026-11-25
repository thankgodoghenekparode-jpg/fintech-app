# Next Steps for Integration

This workspace has route and screen coverage for all 87 Developer 2 inventory entries. The current status is 10 in progress and 77 blocked. The in-progress screens have documented UI or API slices but are not fully integrated; blocked screens still lack required product responses, shared foundations, or authorization context.

## 1. Shared frontend foundations

Coordinate with the core frontend owner to provide or agree on:

- `SessionManager` token storage, refresh, expiry, and logout behavior.
- Shared PIN pad/security service, one-use token lifecycle, and biometric integration rules. The extracted core contract defines `POST /auth/pin/verify` (`pin` request, `pinToken` response).
- Authenticated tenant selection and how tenant IDs reach mobile and web routes/API requests.
- Shared five-tab mobile navigation, design-token generation, component ownership, and i18n catalog ownership.
- A reachable mock API environment generated from the versioned OpenAPI contracts. A local Target Savings subset is available in `mock-api/`; other products and data-bearing responses still need their documented schemas before mocks can return representative data.

## 2. Backend contract publication

Use the product OpenAPI files as the source of truth. Add typed success responses and required operations without changing product behavior implicitly:

- **Cooperative:** cooperative/member/dashboard/plan/dues/share/loan/admin/meeting/audit/verification reads; loan and guarantee details; withdrawal and statement file formats; cooperative IDs from create/list; registered-document upload and informal officer identity flow.
- **Ajo / Esusu:** circle IDs from create/list/preview, circle detail and schedule fields, tenant mapping, invite-code generation, round/member/guarantee/summary responses, and evidence upload.
- **Target Savings:** typed goal list/detail/history, withdrawal quote, what-if and rules responses; typed create `autoSave` fields and goal ID. The separate auto-save schedule request is implemented. The PIN verification request/response is available in the extracted core contract.

Target goal creation now also shows a local contribution estimate based on the goal amount, target date, selected estimate frequency, and optional first deposit. It is guidance only and does not create an automatic schedule. The top-up flow submits the documented amount-only request after confirmation and PIN verification, with an idempotency key; its success state shows the submitted amount. The main-account balance and posted activity remain unavailable until their response contracts are published.

Ajo circle creation now calculates the estimated pot from contribution amount and member slots, plus the approximate final round from frequency and start date. Both are labeled as planning estimates and are not substituted for a backend schedule response.
The Ajo creation stepper now follows the specified Basics, Protection, Payout order, and Review sequence, with the organizer consent note shown for that option.

Cooperative home now labels its membership list as unavailable instead of implying the member has no cooperative. The create and join actions remain available.
- **Revenue:** bill and fee quote, payer, payment, receipt, dashboard, settlement and report responses; collector tenant context and export formats.
- **Agent Network:** recipient/agent lookup, fee and limit data, cash-out status/expiry, float/history/day-end, onboarding documents, backoffice queues, and configuration read plus dual-approval lifecycle.

Detailed gaps and impacts are tracked in [SPEC_GAPS.md](SPEC_GAPS.md).

## 3. Integration order

1. Replace the isolated token storage conventions with the shared session and tenant context.
2. Generate clients/types from the agreed OpenAPI version and connect typed read endpoints.
3. Replace unavailable states with loading, empty, error, and real-data states.
4. Enable remaining money and governance actions after their PIN, idempotency, quote, approval, and result-state contracts are available; Target Savings goal creation now uses the extracted core PIN contract.
5. Verify every route against the mock/real API and the assigned light/dark visual references; add the agreed frontend tests before merge.

## Current verification

- `npm.cmd run build:wasm` in `web/`: production compilation, type checking, and static page generation pass after the demo routing update.
- `node.exe node_modules/typescript/bin/tsc --noEmit` in `web/`: passes.
- `npm.cmd run lint` cannot run in the current workspace: the Next.js lint command prompts to configure ESLint, and the workspace has neither ESLint nor an ESLint configuration. The native SWC binary also fails to load; the WASM launcher reaches the same ESLint setup prompt.
- `flutter --no-version-check analyze lib test` in `mobile/`: passes with no issues.
- `flutter --no-version-check test --no-pub` in `mobile/`: all 7 tests pass, including the Field Rep Contact dialog.
- `flutter --no-version-check build web --no-pub --dart-define=DEVELOPER_TWO_DESIGN_DEMO=true` in `mobile/`: succeeds.
- `node --check mobile/assets/demo_actions.js` passes, and the mobile and web demo interaction scripts have matching SHA-256 hashes.

The extracted frontend reference set and its remaining Target Savings contract/security limits are catalogued in [REFERENCE_SOURCES.md](REFERENCE_SOURCES.md).
