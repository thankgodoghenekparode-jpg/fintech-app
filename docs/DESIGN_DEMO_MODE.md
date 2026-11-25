# Design demo mode

This mode renders the supplied `code.html` design screens for the Developer 2 handoff routes. The HTML is displayed inside the mobile app's web view and the web app's embedded frame. Sample values remain the supplied design content; the app does not turn them into account data or API responses. The demo interaction script makes tabs, sample filters, amount presets, local form validation, toggles, and buttons respond. Actions with a matching destination in the supplied screen inventory navigate to that screen. Financial and administrative actions show a demo-only notice and are never sent to a backend.

The gallery covers 61 mobile references (`S-AGT`, `S-AJO`, `S-COOP`, `S-REV`, and `S-TGT`) and 26 web references (`W-AGT`, `W-AJO`, `W-COOP`, and `W-REV`). The HTML files are copied to `mobile/assets/design_html/` and `web/public/design_html/`, preserving their screen IDs and matching the selected supplied screenshots. Mobile layouts use the current viewport width, including narrow devices. Desktop previews remain readable with horizontal scrolling on narrow windows. **S-AGT-001 is a native Flutter screen** built from the supplied Agent Home sample; it includes local balance visibility and activity filters. The mobile Target Savings sample screen remains separately available with `TARGET_SAVINGS_DEMO=true`.

## Run

From `mobile/`:

```powershell
flutter --no-version-check run -d chrome --no-pub --dart-define=DEVELOPER_TWO_DESIGN_DEMO=true
```

From `web/` in PowerShell:

```powershell
$env:DEVELOPER_TWO_DESIGN_DEMO = 'true'
npm.cmd run dev:wasm
```

The preview is opt-in. Without the flag, existing routes render as before. In mobile, select **Browse supplied design previews** on the home screen; in web, select the preview link on the landing page or open `/demo-preview`. Each gallery links to the supplied design screen for every inventory entry. Product routes open their corresponding preview when the demo flag is enabled. Route IDs and source route mappings are in `mobile/lib/main.dart` and `web/src/middleware.ts`; safe demo transitions are in `mobile/assets/demo_actions.js` and the matching `web/public/demo-actions.js`.

## Limits

All 87 supplied inventory screens now have a reachable preview. Forms, filters, tabs, toggles, and clickable sample cards or rows respond locally. These are supplied design prototypes, not connected product flows. Their sample values are not live balances or records. Local interaction does not represent completed money movement or a saved administrative change. The screens still need the API response schemas, authenticated session/tenant context, and shared PIN/security integration recorded in `SPEC_GAPS.md` and `INTEGRATION_NOTES.md` before those services can be connected.

