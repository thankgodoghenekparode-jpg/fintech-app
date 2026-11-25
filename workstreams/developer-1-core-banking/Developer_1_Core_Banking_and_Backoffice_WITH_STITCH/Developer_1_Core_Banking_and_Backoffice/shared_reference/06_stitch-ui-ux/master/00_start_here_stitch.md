# Start Here - Using This Folder With Stitch

Give Stitch ONLY this folder (`front-end/06_stitch-ui-ux/`). Everything needed to design the screens is inside.

## Order of use
1. Paste `01_MASTER_DESIGN_BRIEF.md` first (sets the product, audience, mood and rules).
2. Paste `02_DESIGN_TOKENS_FOR_STITCH.md` (colours, type, spacing).
3. Generate the component sheet from `06_COMPONENT_SHEET_PROMPTS.md` and keep it as the reference.
4. Generate screens one at a time from `04_core-banking-screen-prompts/` in the order of `03_SCREEN_INVENTORY_FOR_STITCH.md`.
5. Product screens follow in `05_products/<product>/screens.md`, then the back-office console in `08_backoffice-screen-prompts.md`. The full ordered list is `03_SCREEN_INVENTORY_FOR_STITCH.md`.
6. After each batch, check consistency against the master brief (same header, same buttons, same card style).

## Tips
- Stitch inputs have length limits; each screen prompt is written to stand alone and stay short. If a limit is hit, shorten the "Layout" list rather than the rules.
- Generate light mode first, then ask for dark mode using the dark tokens.
- Keep the same colours, type and spacing across every screen; re-paste the brief if the style drifts.
- Export per Stitch's options (design files or code). The developer uses `../02_design-system/DESIGN_TOKENS.json` as the source of truth, not the exported values.

## Hard rules for every screen
1. Never use any real bank's logo, name or icon (especially not Zenith). Use a neutral placeholder wordmark "YourApp".
2. Brand colour is never used for error or warning states.
3. Amounts always show the naira sign (₦) and tabular numerals.
4. Statuses use icon plus text.
5. Mobile first at 390 x 844; five bottom tabs only: Home, Payments, Cards, Save & Borrow, More.

## What is NOT in this folder
Back-end documents and flowcharts are not needed by Stitch. (Flowcharts help you check the journeys, in `../05_flowcharts-drawio/`.)
