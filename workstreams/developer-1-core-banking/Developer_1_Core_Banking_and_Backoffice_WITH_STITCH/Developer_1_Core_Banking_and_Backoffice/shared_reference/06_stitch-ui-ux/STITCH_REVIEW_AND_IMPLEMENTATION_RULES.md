# Stitch UI/UX Review — Core Banking & Back-office

## Purpose
This folder contains the Stitch screen exports assigned to this developer. Use these as visual references alongside the original product documentation already in this handoff.

## Review conclusion
The Stitch package is broadly aligned with the Nigerian naira banking product in the master brief: it covers the core banking app, community finance, commerce, lending, escrow, agent services and role-specific web dashboards. The warm berry/coral visual language, Inter typography, Naira formatting, mobile-first layout and shared component patterns are consistent with the product direction.

## Important corrections before implementation
1. **Do not hard-code a clearing/sponsor bank identity.** Some Stitch exports include references such as "Zenith Bank Partner", "Zenith Clearing", "Zenith Bank Plc" and other bank names. Bank names in beneficiary pickers, transfer examples, or supported bank lists may be legitimate sample data. However, account issuer, clearing partner, sponsor bank, settlement gateway and legal partner labels must come from approved product configuration/API data, not be assumed from Stitch mockups.
2. **Keep the YourApp placeholder identity** until the business confirms the final brand and approved partner wording. Do not copy any external bank's logo, colour system, name or trademark as the app's own identity.
3. **Resolve competing theme exports carefully.** The Stitch archive contains more than one `DESIGN.md` theme export and their values are not identical to the master Stitch tokens. Do not mix these palettes. The original project's `shared_reference/02_design-system/DESIGN_TOKENS.json` is the production source of truth. Use the Stitch master brief/tokens and `theme_dark_tokens.md` only where consistent with that source. If an export conflicts, follow the production tokens and log the discrepancy.
4. **Stitch HTML is a visual reference, not production implementation.** Rebuild components in the documented Flutter/Next.js architecture. Do not paste the exported HTML into the production app or assume its buttons, data, validation, security or navigation are functional.
5. **Do not invent backend behaviour.** Use the original PRD, API contract, flowcharts, validation/error and security documents for behaviour. If a visual screen and a functional document disagree, follow the functional document and record the discrepancy for review.
6. **Financial safety is mandatory.** Show fees, totals, transaction status, pending/reversal states and confirmation details as specified. Never blindly retry a money-moving action; preserve idempotency and status reconciliation.
7. **Accessibility and resilience:** preserve clear labels, icon plus text for statuses, 48px minimum touch targets, 52px primary controls, readable contrast, responsive layouts and weak-network states.

## Included Stitch assets
- Assigned exported screen variants: 168
- Each screen folder includes `screen.png` and `code.html` where supplied.
- Shared master brief, inventory, design tokens, component prompts and relevant design references are in `master/` and `design_references/`.
- Product-specific Stitch prompt documents relevant to this developer are in `product_prompts/`.

## Required implementation workflow
1. Read the developer's original `AI_BUILD_PROMPT.md` and all assigned functional documents first.
2. Read `master/01_master_design_brief.md`, `master/02_design_tokens_for_stitch.md`, `master/03_screen_inventory_for_stitch.md`, `master/component_library.md`, `master/design_principles.md`, and `master/flutter_architecture.md` (as applicable).
3. Review each assigned `screens/<screen-folder>/screen.png` and use the matching `code.html` only to understand layout/content.
4. Build the screen in the real app architecture, reusing shared components and tokens.
5. Match the screen's purpose and hierarchy, not accidental mock data or partner identities.
6. Test light/dark, loading/empty/error/pending/success states, responsive behaviour and navigation.
7. Report any missing screens, conflicting specifications or unapproved bank/partner wording instead of guessing.
