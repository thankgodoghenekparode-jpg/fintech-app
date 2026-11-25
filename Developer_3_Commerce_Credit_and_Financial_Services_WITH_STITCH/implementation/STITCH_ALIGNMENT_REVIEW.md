# Developer 3 Merchant Tools audit

Audit scope: this workspace only; S-MER-001 through S-MER-009. The extracted
front-end reference was read-only. Exact light and dark Stitch exports were
inspected at `shared_reference/06_stitch-ui-ux/screens/<screen>/screen.png`.

## Baseline and change attribution

The nested workspace does not provide a usable Git baseline in this
environment: Git commands fail while resolving the configured user path. No
reliable before-state or history was available, so this review does not
attribute individual files or edits to Antigravity. The current implementation
contains nine Flutter feature screens, adapters, widget tests, an isolated
preview application and integration/spec-gap documentation. No bulk rollback
was performed and no existing screen or component was deleted.

## Architecture and scope findings

- Screens are exported from the feature package, with host-injected tenant
  context, copy, theme/token metrics, adapters and callbacks. There is no
  production API client, auth/session implementation, global route registration,
  document uploader, QR encoder, or share/print integration in this slice.
- The temporary preview uses local fixture adapters and synthetic display data.
  Document selection returns a placeholder key; share, print, statement and
  payment cues only show preview feedback. No real API, auth, payment or document
  operation is connected.
- `implementation/web` is only a package stub. The assigned S-MER screens are
  mobile; no web screen was added.
- The feature code uses `src/<screen>/` modules and adapter/presentation models
  near the widgets. The wider extracted architecture describes separate domain
  and data layers, but this package owns no production data source or use cases.
  Keep the adapter boundary until host integration contracts are approved.
- The preview README was stale: it listed only four screens despite the picker
  and exports containing all nine. It now documents all nine and Chrome launch.

## Stitch comparison by screen

Each entry names the exact light/dark pair. Differences below describe the
current feature scope against the supplied reference; the actual feature widgets
were not rendered during this audit, so pixel-level spacing and responsive
behavior remain unverified.

| Screen and reference pair | Confirmed scope/design discrepancy and disposition |
|---|---|
| S-MER-001 Business Home — `business_home_s_mer_001` / `business_home_dark_mode_s_mer_001` | Stitch shows settlement, weekly chart, payment-channel controls, and populated example transactions. The implementation limits content to adapter-supplied business, balance, today sales and recent payments. These omitted screenshot sections have no approved response fields; retain the documented gap. Stitch action labels differ from the functional actions; the package follows functional callbacks. |
| S-MER-002 Create Business — `create_business_s_mer_002` / `create_business_dark_mode_s_mer_002` | Stitch is a dense multi-step registration form with category, address, estimated volume, support number and compliance claims. The page collects only the documented legal name, type, registration number, optional settlement account and injected owner-document key. Do not add screenshot-only fields or compliance claims. Type values and document upload rules remain unresolved. |
| S-MER-003 Payment Links — `payment_links_s_mer_003` / `payment_links_dark_mode_s_mer_003` | Stitch includes custom slugs, customer requirements, richer list management and pause/reactivate controls. The page exposes supported fixed/open amount, description, expiry and single/multi-use inputs and adapter-mapped rows. Missing response schemas prevent safe recreation of several screenshot details/actions. |
| S-MER-004 QR Codes — `qr_codes_s_mer_004` / `qr_codes_dark_mode_s_mer_004` | Stitch includes certification/settlement claims, merchant/account identifiers, audio, presets, customer note and standee ordering. The screen intentionally offers static/dynamic QR flows with injected PNG bytes/status/share/print. No QR payload standard, certification evidence or status endpoint is specified; preview artwork is deliberately non-scannable. |
| S-MER-005 Create Invoice — `create_invoice_s_mer_005` / `create_invoice_dark_mode_s_mer_005` | Stitch includes item, tax and total calculations plus delivery choices and detailed invoice summary. The screen collects supported fields and previews entered values but does not derive totals or tax; create response, customer/item wire shapes and send mapping remain unresolved. Those differences are documented. |
| S-MER-006 Invoices — `invoices_s_mer_006` / `invoices_dark_mode_s_mer_006` | Stitch has KPI tiles, search, richer invoice rows/actions and detailed receipt-style records. The screen renders adapter-provided invoice rows/status/timeline and the documented reminder action. GET response, pagination/filter mapping and reminder reconciliation remain gaps; unsupported edit/void/download claims are omitted. |
| S-MER-007 Cashier — `cashier_s_mer_007` / `cashier_dark_mode_s_mer_007` | Stitch depicts a full-screen cashier keypad/customer payment prompt, shift identity, presets, bank details and payment status actions. The feature uses amount entry and an injected QR/link intent/status boundary; unsupported cashier identity, sample payment, PIN and partner claims are omitted. The preview only simulates confirmation messaging. |
| S-MER-008 Transactions & Payouts — `transactions_and_payouts_s_mer_008` / `transactions_and_payouts_dark_mode_s_mer_008` | Stitch contains settlement figures, payout destination/timing, fee/policy information and detailed ledger rows. The feature shows only host-mapped balances, transactions and destinations. API response, payout lifecycle, destination, quote/fee/limits, and statement contracts remain unresolved; no financial figures are derived. |
| S-MER-009 Refund — `refund_s_mer_009` / `refund_dark_mode_s_mer_009` | Stitch includes fixed reason choices, policy/breakdown and extra authorization states. The feature accepts free-text reason and host-mapped eligibility/maximum only; fixed categories, fee reversal and dual-control threshold have no approved contract. Keep those omissions pending product/API decisions. |

## Corrected in this audit

- Updated the temporary preview to use explicit shared light/dark color tokens,
  Inter with platform sans fallback, and the shared type ramp. Matched spacing,
  card/control radii, input borders, and 52 px filled/outlined/text buttons.
  Removed the desktop width cap so each mobile screen uses its device width.
- Corrected the S-MER-007 primary collection button from 56 px to the shared
  52 px control height.
- Corrected the Business Home Invoice action in the preview picker to open
  Create Invoice (S-MER-005), and its back action returns to Business Home;
  Invoices (S-MER-006) remains separately selectable.
- Updated preview documentation to list all nine screens and document Chrome
  launch and preview-only shell controls.

No feature screen was removed or rewritten. No package dependency was added or
changed. The host still supplies production `ThemeData`; no Inter font asset was
found in the extracted reference files, so the preview requests Inter and relies
on the platform sans fallback when it is unavailable.

## Verification and remaining gaps

- Inspected all 18 exact Stitch reference images (nine light/dark pairs) and
  compared the current implementation scope against handoff, UI, API, and gap
  documentation. This is reference inspection, not rendered-app visual QA.
- The Flutter SDK is under the repository's root `.tools` directory, outside
  this authorized workspace. The Dart formatter was invoked directly from that
  SDK and formatted the two edited Dart files in this workspace; it warned that
  `flutter_lints` could not be resolved. The Flutter CLI is not on PATH, and it
  was not invoked because its missing tool snapshot would write outside the
  authorized workspace. Flutter analysis, widget tests, and a fresh build were
  not executed.
- Existing build artifacts are not evidence of a current build. Chrome was not
  launched and the nine rendered screens were not inspected. Mobile overflow,
  loading/empty/error/success visuals, and per-screen light/dark pixel fidelity
  require a later run with an approved in-workspace Flutter toolchain.
- Git history/diffs could not be established, so created/modified/deleted
  attribution and claims about Antigravity are unconfirmed.

All edits from this audit are limited to this Developer 3 workspace.

## Mobile viewport follow-up

- S-MER-001 has a populated local home adapter fixture. The preview now stretches
  its selected screen to the shell's full width and bounded expanded height;
  Business Home's vertical scroll view opts out of the inherited primary
  controller. No missing fixture or unbounded parent was found in source.
- S-MER-002 step labels now wrap inside equal-width expanded items with compact
  8 px connectors and horizontal insets, instead of relying on each label's
  intrinsic width.
- S-MER-005 header branding now reads “Merchant tools,” matching the other
  merchant feature headers.
- Static layout review of S-MER-003/004/006/007/008/009 found horizontally
  scrollable invoice filters, bounded/expanded card rows, and compact segmented
  controls; no additional source-level overflow deviation was confirmed.
- `dart format` completed for the four edited Dart files (0 files changed on the
  final pass). The formatter warned that `flutter_lints` could not be resolved.
  These changes were not run on a device; mobile overflow and rendered light/dark
  appearance therefore remain runtime-unverified.
