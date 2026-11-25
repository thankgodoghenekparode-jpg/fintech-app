# W-MER-002 / W-MER-003 implementation report

## Scope and references

Implemented the approved Merchant web screens only:

- W-MER-002, Invoices — `/business/:t/invoices`.
- W-MER-003, Payment Links — `/business/:t/links`.

Stitch exports used:

- `shared_reference/06_stitch-ui-ux/screens/invoices_w_mer_002_1/` and `invoices_w_mer_002_2/`.
- `shared_reference/06_stitch-ui-ux/screens/payment_links_w_mer_003_1/` and `payment_links_w_mer_003_2/`.

Shared architecture and tokens follow the read-only extracted reference documents `DESIGN_TOKENS.json`, `COMPONENT_LIBRARY.md`, `WEB_DASHBOARD_ARCHITECTURE.md`, and `CODING_STANDARDS.md`. Pages use the berry palette, Inter font stack, spacing/radius/button/input variables, shared shell controls, responsive layout, and light/dark token variants. Unsupported sample KPIs, provider/security claims, payment-rail claims, analytics, and management actions from the Stitch exports were excluded.

## Functionality

- Invoices: host-supplied invoice presentation rows; search/status filters; selected invoice detail; loading, empty, no-results, retryable error, and send feedback states; one-invoice send intent with the documented LINK/SMS/EMAIL channels. Create invoice delegates only to an optional host navigation callback and is disabled when omitted.
- Payment Links: host-supplied link presentation rows; search/status filters; selected link detail; loading, empty, no-results, retryable error, and action feedback states; creation intent using only documented fields and exact integer-kobo amount parsing.
- The isolated preview offers W-MER-002/W-MER-003 selection, sidebar navigation, and light/dark switching. It displays synthetic records only. All create/send actions stay in memory; no API, authentication, payment, or document operation is connected. The preview is visibly marked NON-PRODUCTION.

## API and product gaps preserved

- Invoice GET response schema and pagination/status mapping are unspecified. Invoice POST customer/items shapes and response schema are unspecified. The page does not guess a create request or response; invoice creation remains host-owned and the action is unavailable in this feature. Invoice editing and bulk reminders are omitted because no supported contract exists.
- Payment-link GET/POST response schemas are unspecified, including authoritative identifiers/share URL. Expiry timezone/boundary semantics remain unresolved. The feature does not create a share URL/reference, deactivate links, show analytics, or infer use counts.
- Production integration requires host adapter mappings and approved response contracts. Presentation interfaces are not wire DTOs.

## Verification

- Prettier format and format check: passed.
- ESLint: passed.
- TypeScript checks for feature and preview: passed.
- Vitest: 2 test files, 7 tests passed.
- Production build: passed with Vite 6.4.6 (38 modules transformed).
- Development preview HTTP smoke check: `/` and `/main.tsx` both returned HTTP 200; both feature page imports were present.
- No browser was opened and no rendered screenshot/visual inspection of the running preview was performed.
- `npm install` reported six dependency-tree advisories (2 moderate, 1 high, 3 critical). No automated audit fix was applied.

## Launch

From `implementation/web` run `npm install --legacy-peer-deps` (the feature package declares host peer dependencies) and `npm run dev`, then open the local URL printed by Vite (normally `http://127.0.0.1:5173`).

## Boundary

All authored project code, package files, preview files, and documentation are within the approved Developer 3 workspace. npm also wrote its normal registry metadata/package cache under the user profile during dependency installation; no shared host, mobile, other developer, or extracted-reference project files were edited.
