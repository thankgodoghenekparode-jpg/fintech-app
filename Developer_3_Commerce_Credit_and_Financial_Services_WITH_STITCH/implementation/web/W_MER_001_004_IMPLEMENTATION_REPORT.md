# W-MER-001 and W-MER-004 implementation report

## Scope and references

Implemented only W-MER-001 Business dashboard (`/business/:t/dashboard`) and W-MER-004 Reports and exports (`/business/:t/reports`) inside `implementation/web/`. The functional specifications are in `work_scope/04_products/merchant-tools/03_ui_ux_spec.md` and the approved inventory in `02_screen_inventory.md`. Exact Stitch exports inspected were:

- `shared_reference/06_stitch-ui-ux/screens/business_dashboard_w_mer_001_1/` and `business_dashboard_w_mer_001_2/` (`screen.png`, `code.html` in both).
- `shared_reference/06_stitch-ui-ux/screens/reports_and_exports_w_mer_004_1/` and `reports_and_exports_w_mer_004_2/` (`screen.png`, `code.html` in both).

Both pairs are light visual alternatives; the package theme supports light and dark. The functional spec governs any unsupported or conflicting screenshot details. Shared styling follows the read-only front-end extracted tokens and web architecture: berry palette, Inter/system font stack, tabular financial numerals, tokenized spacing/radii, 52px controls, responsive layout, and CSS-variable dark theme.

## Functionality

- W-MER-001 renders host-supplied sales, fees, refunds, outstanding-invoice KPIs, a host-supplied chart series, recent activity, drill-down callbacks, loading/empty/error/retry, and restricted-access states.
- W-MER-004 renders host-supplied sales, fees, refunds, tax summary, date bounds, export action, loading/empty/error/retry, restricted-access, and generating/success/error states. Reversed date bounds use inline validation.
- `BusinessDashboardAdapter` and `ReportsAdapter` are injected. These presentation types are not wire DTOs. Preview data is synthetic, and preview export completes locally without creating a file.
- The existing four-screen preview registers W-MER-001–004, offers screen selection/sidebar navigation and a light/dark toggle, and is marked non-production. W-MER-002/003 implementations were preserved. W-MER-005 remains not started.

## API gaps

`GET /business/home` and `GET /business/reports/{type}` have no documented 200 response schema. Report `type` has no allowed-value enum; optional `format` has no enum or file response/content-type contract. Host tenant/auth/permission handling, response mapping, report/date semantics, export format and file delivery must be provided after API confirmation. The feature does not invent these contracts, regulatory/provider claims, financial calculations, report options or downloadable files. See `implementation/SPEC_GAPS.md` and `implementation/INTEGRATION_NOTES.md`.

## Files

Added:

- `implementation/web/src/dashboard/dashboard_types.ts`
- `implementation/web/src/dashboard/business_dashboard_page.tsx`
- `implementation/web/src/dashboard/business_dashboard_page.test.tsx`
- `implementation/web/src/reports/reports_types.ts`
- `implementation/web/src/reports/reports_and_exports_page.tsx`
- `implementation/web/src/reports/reports_and_exports_page.test.tsx`

Updated to expose/register the screens and provide shared UI, theme, preview fixtures/copy, documentation, and tests:

- `implementation/web/src/components/merchant_workspace_shell.tsx`
- `implementation/web/src/components/ui.tsx`
- `implementation/web/src/shared/copy.ts`
- `implementation/web/src/index.ts`
- `implementation/web/src/styles.css`
- `implementation/web/src/test_copy.ts`
- `implementation/web/preview/main.tsx`
- `implementation/web/README.md`
- `implementation/INTEGRATION_NOTES.md`
- `implementation/SPEC_GAPS.md`
- `implementation/IMPLEMENTATION_STATUS.md`

No package configuration or dependency was added for this batch. Repository Git status could not provide a reliable baseline because Git failed to stat `C:/Users/hp`; the file list above describes this implementation batch, not a claim that all listed files were new relative to repository history.

## Verification

- `npm.cmd run format`: passed (files already formatted).
- `npm.cmd run format:check`: passed.
- `npm.cmd run lint`: passed.
- `npm.cmd run typecheck`: passed for feature and preview TypeScript configs.
- `npm.cmd test`: passed, 4 test files and 13 tests, including 2 dashboard and 4 reports tests. Initial sandboxed Vitest startup was denied while esbuild inspected an ancestor directory; the approved local rerun passed.
- `npm.cmd run build`: passed, Vite production build completed (42 modules).
- Preview HTTP smoke: `GET /` and `GET /main.tsx` returned 200 from the existing local Vite server and exposed the updated four-screen entry. Starting another dev process failed because port 5173 was already in use. No browser was opened, so this is not a claim of rendered visual inspection.
- Visual reference inspection was limited to the supplied Stitch `screen.png`/`code.html`; no rendered comparison screenshot was captured in this run.

## Launch preview

From `implementation/web/` run `npm.cmd run dev`, then open the Vite URL (default `http://127.0.0.1:5173`). Use the Merchant workspace sidebar to navigate W-MER-001 through W-MER-005 and the theme button to switch light/dark. If port 5173 is already occupied, stop the existing preview process or choose another Vite port with the local CLI option.
