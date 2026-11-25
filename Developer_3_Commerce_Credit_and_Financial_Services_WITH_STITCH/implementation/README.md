# Developer 3 Feature Packages

These are product feature packages, not standalone applications. They stay within this Developer 3 handoff and do not modify the shared Flutter or Next.js application roots.

## Screen to Stitch reference map

Stitch screenshots are visual references. Functional behavior comes from each product's PRD, screen inventory, API spec, user flows, validation, and state documents. Where a visual conflicts with a functional requirement, follow the functional requirement and record the difference.

| Screen | Platform / route | Stitch export folder(s) |
|---|---|---|
| S-MER-001 Business home | Mobile `/business` | `business_home_s_mer_001`; `business_home_dark_mode_s_mer_001` |
| S-MER-002 Create business | Mobile `/business/new` | `create_business_s_mer_002`; `create_business_dark_mode_s_mer_002` |
| S-MER-003 Payment links | Mobile `/business/links` | `payment_links_s_mer_003`; `payment_links_dark_mode_s_mer_003` |
| S-MER-004 QR codes | Mobile `/business/qr` | `qr_codes_s_mer_004`; `qr_codes_dark_mode_s_mer_004` |
| S-MER-005 Create invoice | Mobile `/business/invoices/new` | `create_invoice_s_mer_005`; `create_invoice_dark_mode_s_mer_005` |
| S-MER-006 Invoices | Mobile `/business/invoices` | `invoices_s_mer_006`; `invoices_dark_mode_s_mer_006` |
| S-MER-007 Cashier | Mobile `/business/cashier` | `cashier_s_mer_007`; `cashier_dark_mode_s_mer_007` |
| S-MER-008 Transactions and payouts | Mobile `/business/transactions` | `transactions_and_payouts_s_mer_008`; `transactions_and_payouts_dark_mode_s_mer_008` |
| S-MER-009 Refund | Mobile `/business/refund/:id` | `refund_s_mer_009`; `refund_dark_mode_s_mer_009` |
| S-MER-010 Team | Mobile `/business/team` | `team_s_mer_010`; `team_dark_mode_s_mer_010` |
| W-MER-001 Business dashboard | Web `/business/:t/dashboard` | `business_dashboard_w_mer_001_1`; `business_dashboard_w_mer_001_2` |
| W-MER-002 Invoices | Web `/business/:t/invoices` | `invoices_w_mer_002_1`; `invoices_w_mer_002_2` |
| W-MER-003 Payment links | Web `/business/:t/links` | `payment_links_w_mer_003_1`; `payment_links_w_mer_003_2` |
| W-MER-004 Reports and exports | Web `/business/:t/reports` | `reports_and_exports_w_mer_004_1`; `reports_and_exports_w_mer_004_2` |
| W-MER-005 Team and verification | Web `/business/:t/team` | `team_and_verification_w_mer_005_1`; `team_and_verification_w_mer_005_2` |

Each listed folder has a `screen.png` and `code.html` visual export. Implemented mobile slices now include S-MER-001 through S-MER-010. Business Home follows the functional layout. Create business follows the four-step hierarchy while collecting documented request fields. Payment Links displays adapter-supplied active/expired list data and creates fixed/open links using documented request fields. QR Codes presents static and amount QR flows with host-provided QR images and live status labels. Team displays host-mapped directory presentation data and exposes only the documented invite intent; list/edit/remove/permission APIs remain gaps. Unspecified response data and Stitch-only claims/fields are not invented. Colors and typography consume host `ThemeData`; controls use themed Flutter Material widgets because the host currently has no implemented shared component widgets. The package does not copy the alternate CSS palette embedded in Stitch HTML.

The handoff describes 164 Stitch variants, while the current extracted `screens/` directory contains 163 screen folders with PNG and HTML exports. All 15 Merchant Tools screen IDs map to existing export folders above; the overall package count discrepancy remains for review.

The S-MER-001 reference includes example balances, a chart, payment-channel rows, and sample transactions. Example financial values and identities are not production data. The functional spec requires balance, today's sales, actions, and recent payments; unsupported chart and channel sections are omitted until their data contracts are defined. The functional spec's actions (Collect, Payment link, Invoice, Refund) take precedence over the Stitch labels (Payment Link, Show QR, Create Invoice, Cashier Mode).

## Packages

- `mobile/` is a Flutter library package using Flutter and Riverpod. It exports feature screens and injected data adapter contracts; the host remains responsible for `go_router` registration, tenant/session context, shared tokens, localization, and action routing.
- `web/` is a React feature package contract for future inventory-assigned web screens. It is not a Next.js app and contains no web screen in this first slice because S-MER-001 is mobile-only.
- `localization/merchant_en.arb` contributes Merchant copy keys for merging into the host's central text layer. The package screen uses an injected copy interface and does not create a competing localization runtime.

See `INTEGRATION_NOTES.md` and `SPEC_GAPS.md` before host integration.
