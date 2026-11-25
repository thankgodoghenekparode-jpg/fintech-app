# Developer 1 — Core Banking & Back-office

Isolated workstream containing Developer 1's Flutter customer app, Next.js back-office shell, handoff documents, Stitch references, and implementation notes. Existing repository paths are preserved; this directory is additive so the other developers' projects remain untouched.

## Contents

- `mobile/` — Flutter/Dart customer banking frontend.
- `web/` — Next.js/React back-office frontend.
- `Developer_1_Core_Banking_and_Backoffice/` — canonical Developer 1 handoff.
- `Developer_1_Core_Banking_and_Backoffice_WITH_STITCH/` — handoff with Stitch screenshots and HTML exports.
- `front-end extracted/` — consolidated frontend specifications and supporting references.
- `docs/` — current implementation status, gaps, and API proposals.

## Demo preview

From `mobile/`, build the browser demo:

```powershell
flutter pub get
flutter build web --dart-define=ENABLE_DEMO_LOGIN=true --dart-define=ENABLE_CARD_UI_PREVIEW=true --dart-define=ENABLE_DRAFT_LEGAL_PREVIEW=true
node tool/preview_server.js
```

Open `http://127.0.0.1:7357`, choose **Demo login**, then **Browse implemented screens**. Demo data is labeled and does not contact a live banking API. Screens requiring backend data are marked in the catalog.

## Verification and blockers

The current Flutter suite has 64 passing tests. Local API proposals require backend parity and product/compliance/legal approval before production integration. See `docs/IMPLEMENTATION_STATUS.md` and `docs/SPEC_GAPS.md`.
