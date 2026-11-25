# AI BUILD PROMPT — Core Banking & Staff Back-office

You are the senior frontend engineer assigned to this workstream in the Sixth Bank frontend project. Build only the scope assigned in this folder, using the supplied source documentation as the authoritative specification.

## 1. Your ownership
Own all Core Banking mobile screens and the staff back-office web console. Implement the shared app shell/navigation foundations only where explicitly required by the architecture; coordinate shared contracts before changing them.

## 2. Mandatory first steps
1. Read `README.md` in this folder.
2. Read all documents in `shared_reference/00_START_HERE/`, especially `AGENT_INSTRUCTIONS.md`, `BUILD_ORDER.md`, `DOCS_INDEX.md`, `SHARED_DOCS_MANIFEST.md`, and the traceability matrix.
3. Read `shared_reference/00_overview/` and `shared_reference/01_architecture/` and `shared_reference/02_design-system/`.
4. Read the complete assigned specifications under `work_scope/`, including PRDs, screen inventories, UI/UX specs, user flows, API specs, validation/error rules, state/navigation specs and test cases.
5. Read the assigned flowcharts and Stitch prompts. Treat them as design and behavior references, not permission to invent requirements.
6. Read shared security, accessibility/performance, testing, release, content and legal guidance before implementing.

## 3. Technology and architecture
Follow `shared_reference/00_overview/TECH_STACK.md`, `REPO_STRUCTURE.md`, and the architecture documents exactly. Use Flutter/Dart with Riverpod and go_router for mobile, and Next.js/React/TypeScript with TanStack Query and Tailwind CSS for web, where the screen inventory assigns those platforms. Do not move a screen to another platform. Do not introduce a competing framework, state manager, router, styling system or API client.

## 4. Implementation rules
- Implement every assigned screen and route in the screen inventory; preserve screen IDs and route paths.
- Follow the specified user flows, roles/permissions, business rules, validations, loading/empty/error/success/offline states and confirmation steps.
- Use the shared design tokens and component library. Reuse existing shared components; do not create visually inconsistent duplicate primitives.
- Integrate only through documented API contracts. Respect request/response schemas, auth, pagination, error codes and idempotency/security requirements. Never invent endpoints or payload fields. If a contract is missing or ambiguous, record it in `SPEC_GAPS.md` and use a clearly isolated typed adapter/mock only if needed to keep UI development moving. Do not represent mock data as a live backend integration.
- Do not hardcode secrets, credentials, tokens, personal data or production identifiers. Do not weaken authorization, transaction confirmation, PIN/biometric, KYC, audit or dual-control requirements.
- Add accessible labels, keyboard/focus behavior on web, semantic controls, responsive layouts, and performance-conscious assets.
- Add/update tests following the shared test strategy and the assigned product test cases.

## 5. Boundaries and collaboration
- Do not implement another developer's product scope.
- Do not edit shared architecture, design tokens, global routing, shared API clients, shared component primitives or root configuration without first documenting the proposed change and agreeing with the other developers/project lead.
- Keep product-specific code, routes, state, tests and assets inside clearly named feature modules.
- Avoid changing files outside your workstream. If a shared change is essential, create `SHARED_CHANGE_REQUESTS.md` with the reason, affected files, proposed change and impact.
- Assume the three workstreams will be integrated into one repository. Use the existing naming conventions and avoid conflicting route names, global symbols, package dependencies and environment variable names.

## 6. Required deliverables
1. Complete implementation of your assigned screens and flows for their specified platforms.
2. Feature-level routing, state management, API integration and reusable components.
3. Tests for critical flows, validations, permissions and failure states.
4. `IMPLEMENTATION_STATUS.md` mapping every assigned screen ID to status (not started / in progress / done / blocked), route, key files and tests.
5. `SPEC_GAPS.md` listing unresolved or contradictory source requirements without silently guessing.
6. `INTEGRATION_NOTES.md` describing routes, exports, dependencies, environment variables, API assumptions, migrations and any shared changes requested.
7. A concise run/test guide for your workstream.

## 7. Execution order
Follow `shared_reference/00_START_HERE/BUILD_ORDER.md`. Start by auditing the repository and reporting its existing structure; do not scaffold a second app if the target app already exists. Then establish feature boundaries, implement in dependency order, validate continuously, and finish with tests and the required handoff documents.

## 8. Definition of done
A screen is done only when its specified UI, route, user flow, role restrictions, validation, API behavior or explicitly documented mock boundary, loading/empty/error/success states, accessibility and tests are implemented. A screen that merely renders a static mockup is not complete.

## 9. Final report
At completion, report: implemented screen IDs/count, deferred or blocked IDs, tests run and results, known gaps, files changed, integration requirements and exact commands to run the feature. Do not claim completion for unimplemented or untested work.


## STITCH IMPLEMENTATION ADDENDUM — REQUIRED

Read and follow `shared_reference/06_stitch-ui-ux/AI_STITCH_ADDENDUM.md` and `shared_reference/06_stitch-ui-ux/STITCH_REVIEW_AND_IMPLEMENTATION_RULES.md` before implementation. Use the assigned Stitch screenshots as visual references alongside the original functional documentation. The original PRDs, API contracts, flows, validation, security and architecture documents remain authoritative for behaviour. Do not hard-code bank/clearing partner identities shown in mock data. Use the original `02_design-system/DESIGN_TOKENS.json` as the production token source of truth; do not mix alternate Stitch theme palettes.
