# W-MER-005 Team and verification implementation report

## Scope and references

Implemented only W-MER-005 inside `implementation/web/`; W-MER-001 through W-MER-004 remain in place. The approved route is `/business/:t/team`; the screen inventory maps it to MER-ACC-001 and MER-ACC-002. Functional layout is a team/permissions table and verification status, with invite action and rejected-reason state.

Exact Stitch references inspected:

- `shared_reference/06_stitch-ui-ux/screens/team_and_verification_w_mer_005_1/screen.png` and `code.html`.
- `shared_reference/06_stitch-ui-ux/screens/team_and_verification_w_mer_005_2/screen.png` and `code.html`.

The implementation follows their roster, permission-detail, verification-status, rejection-reason and invite hierarchy using the feature package’s existing berry tokens, Inter/system typography, spacing, radii, common controls and light/dark CSS variables. Unsupported Stitch content is omitted: terminal hardware/bindings/limits, permission editing, removal/revocation, audit/security logs, document operations, certification/provider/compliance claims, verification tiers and example IDs/data.

## Functionality

- Host-injected adapter supplies presentation roster rows, role permission descriptions, and verification state/message/rejection reason. Loading, empty, retryable error, pending, verified and rejected states are represented.
- Invite dialog collects phone and one of the documented MANAGER, CASHIER, or ACCOUNTANT roles. The adapter receives only `{ tenantId, phone, role }`; the page does not assume a response body or refresh/add a member on its own.
- The existing isolated preview now registers W-MER-005 in its selector and sidebar and uses synthetic roster/verification data. Its invite action is local-only and sends no invitation. Existing light/dark switching is shared across all five screens.

## API gaps

The API defines only `POST /business/team` (Owner role, required phone, and role enum MANAGER/CASHIER/ACCOUNTANT). It defines no team-list or removal operation, no list response schema, and no role-permission matrix. MER-ACC-002 mentions owner removal, but no removal API is documented. MER-ACC-001 and the UI spec require verification status/rejected reason, but there is no verification endpoint/schema or document read/upload/download operation. The screen therefore takes these values from a host presentation adapter and adds no removal, permission-editing or document action. No verification state is inferred from `POST /business`.

## Files changed

Added:

- `implementation/web/src/team_verification/team_verification_types.ts`
- `implementation/web/src/team_verification/team_verification_page.tsx`
- `implementation/web/src/team_verification/team_verification_page.test.tsx`
- `implementation/web/W_MER_005_IMPLEMENTATION_REPORT.md`

Updated for exports, navigation, styling, preview registration/copy, and integration documentation:

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

No dependency or package configuration changed. Git status is unavailable in this workspace because Git fails to stat `C:/Users/hp`, so this list records the files modified for the W-MER-005 task and is not an assertion of repository-wide baseline changes. Build outputs are in ignored local `dist/` directories within `implementation/web/`.

## Verification

- `npm.cmd run format`: passed.
- `npm.cmd run format:check`: passed.
- `npm.cmd run lint`: passed.
- `npm.cmd run typecheck`: passed for feature and preview TypeScript configs.
- `npm.cmd test`: passed, 5 files and 18 tests across W-MER-001–005; W-MER-005 has 5 focused tests.
- `npm.cmd run build`: passed; Vite production preview build completed (44 modules).
- Preview HTTP smoke: `/` and `/main.tsx` returned 200; transformed entry includes W-MER-005 selection and the shared light/dark toggle.
- The two supplied Stitch screenshots and HTML exports were inspected. No browser-rendered screenshot comparison was captured, so rendered visual verification is not claimed.

## Preview launch

From `implementation/web/`, run `npm.cmd run dev`, then open the URL Vite prints (normally `http://127.0.0.1:5173`). Choose “W-MER-005 · Team and verification”; the theme button switches light/dark. Preview data and invite action are synthetic/local-only.
