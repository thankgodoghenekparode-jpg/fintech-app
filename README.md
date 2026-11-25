# Developer 2 Frontend

Isolated frontend workspace for Group Banking & Community. Contains Flutter mobile and Next.js web shells for later integration.

Owned products: Cooperative, Ajo / Esusu, Target Savings, Revenue, Agent Network.

- `mobile/`: Flutter, Riverpod, go_router
- `web/`: Next.js App Router and TypeScript
- `docs/`: implementation status, specification gaps, integration notes

This is an in-progress implementation with all 87 handoff inventory routes represented in `docs/IMPLEMENTATION_STATUS.md`: 10 are in progress and 77 are blocked by missing backend schemas, session/PIN integration, or other documented dependencies. The mobile route coverage includes Cooperative, Ajo / Esusu, Target Savings, Revenue, and Agent Network. The web route coverage includes Cooperative administration, the Ajo organizer view, Revenue collector operations, and Agent Network backoffice. Screens with missing contracts show unavailable states and keep consequential actions disabled. Cooperative creation and Ajo creation use documented request shapes; Ajo reporting and several other flows remain disabled where required context or upload/response contracts are missing. Requirements remain in `../Developer_2_Group_Banking_and_Community_WITH_STITCH/Developer_2_Group_Banking_and_Community/`.

## Run

Mobile: from `mobile/`, run `flutter pub get`, then `flutter run --dart-define=API_BASE_URL=<backend-base-url>`.

Web: dependencies are installed; from `web/`, run `npm run dev`. On this Windows host the native SWC binary is rejected, so use `npm run dev:wasm` and `npm run build:wasm`; the WASM fallback is for local development only.

To preview supplied screens as clearly labeled, read-only design images, see [docs/DESIGN_DEMO_MODE.md](docs/DESIGN_DEMO_MODE.md). This opt-in mode uses `DEVELOPER_TWO_DESIGN_DEMO=true`; it does not provide live account data or enable actions.

The cooperative-create call also expects an access token in secure storage under the temporary `access_token` key. The key and refresh flow must be replaced with the shared SessionManager during integration. Registered cooperatives cannot be submitted until their document flow is connected.

The apps currently expose a Developer 2 shell. Shared navigation, auth, API client, and product routes must be aligned before integration.

## Handoff and verification

- `docs/IMPLEMENTATION_STATUS.md` tracks each handoff screen ID, route, platform, current status, and primary file.
- `docs/SPEC_GAPS.md` lists missing contracts and their user-facing impact.
- `docs/INTEGRATION_NOTES.md` records auth, API, and cross-team integration dependencies.
- `docs/NEXT_STEPS.md` lists the ordered handoff required to unlock blocked screens.
- `mock-api/README.md` documents the local Target Savings contract mock and its limits.
- Mobile static analysis: from `mobile/`, run `dart analyze` (or `flutter analyze`).
- Web production build: from `web/`, run `npm run build:wasm` on Windows when native SWC is unavailable.


