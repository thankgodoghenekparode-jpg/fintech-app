# Merchant Tools web feature package

This package contains the frontend-only W-MER-001 Business Dashboard, W-MER-002 Invoices, W-MER-003 Payment Links, W-MER-004 Reports and Exports, and W-MER-005 Team and Verification screens. It is a feature package for the eventual Next.js host, not the host application. Production routes, authentication, localization, API clients, response mapping, and tenant selection remain owned by the host.

## Isolated preview

The non-production Vite harness lives in `preview/`. From this directory run:

```powershell
npm.cmd install --legacy-peer-deps
npm.cmd run dev
```

Open the local URL Vite prints (normally `http://127.0.0.1:5173`). The preview uses the Merchant workspace sidebar to navigate W-MER-001 through W-MER-005, with light/dark switching and synthetic in-memory records. It does not connect to an API, authentication, payment, or document service. Dashboard figures, report totals, team rows, and verification status are synthetic; preview export and invitation actions complete locally and create/send no external artifacts. A created payment link is stored only in preview memory and no share URL or API response is generated.

## Checks

```powershell
npm.cmd run format:check
npm.cmd run lint
npm.cmd run typecheck
npm.cmd test
npm.cmd run build
```

## Host integration boundary

Inject the `BusinessDashboardAdapter`, `InvoiceAdapter`, `PaymentLinkAdapter`, `ReportsAdapter`, and `TeamVerificationAdapter`, tenant ID, and localized copy into the exported pages. Presentation types are frontend contracts, not wire DTOs. The host owns response mapping, verification state, team permissions, and any unavailable team-list/removal or verification operations. See the Developer 3 `INTEGRATION_NOTES.md` and `SPEC_GAPS.md` for unresolved API details and unsupported behavior.
