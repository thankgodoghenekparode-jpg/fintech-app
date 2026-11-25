# Pay Am Small Preview Capability Audit

**Scope:** S-PAS-001, S-PAS-002, S-PAS-012, S-PAS-003, and S-PAS-004. The isolated preview is non-production and uses synthetic fixtures. This audit changed no application source or tests.

## A. Current screen capabilities

### S-PAS-001 — Marketplace Home

- Shows a page title/subtitle, search field and search/tune action, horizontally scrolling category chips, product cards, and vendor rows.
- Search submits a query to the injected marketplace adapter. Category chips filter the currently loaded products. Product cards navigate to S-PAS-002; vendor rows navigate to S-PAS-012.
- Supports loading, empty results, and retryable adapter errors. The preview fixture has one synthetic product/vendor, so it does not expose every state from its visible UI.
- Light/dark colors and typography come from the preview theme. The marketplace screen test covers a 390 px width; a narrower home-specific viewport is not covered by its current test.

### S-PAS-002 — Product Details

- Shows the product image or image placeholder, category, title, host-provided price when available, vendor row, supported purchase options, delivery terms, and price-lock terms.
- Tapping the vendor opens S-PAS-012. Selecting an available option updates selection; Continue is disabled if the product is unavailable or no option is available. In the preview, Price-lock Continue opens S-PAS-003. Pay in full only shows a preview message; no purchase endpoint is connected.
- The page scrolls while Continue stays pinned. Loading, retryable error, missing product, out-of-stock, and unavailable-option states are represented.
- Tests exercise 390 × 844 and 320 × 720 layouts and verify that delivery terms remain reachable above the pinned button.

### S-PAS-012 — Vendor Storefront

- Shows the host-provided vendor name/profile, verification status, optional rating/review count, about text and delivery terms when present, plus a responsive product grid.
- Tapping a product opens S-PAS-002. It supports loading, retryable error, unavailable/suspended vendor, and empty product states.
- Its narrow-layout test covers 390 × 844 and 320 × 720; the product-card grid is checked for fitting its content.
- Storefront content is synthetic in this preview. No vendor-profile endpoint is connected.

### S-PAS-003 — Plan Setup

- Shows the plan step indicator, selected vault product(s), an optional Add another item action, deadline picker, funding-method segmented control, quote facts, and quote rules/terms.
- Opening the screen requests a quote through the injected adapter. Selecting a deadline requests a refreshed quote. Continue passes the returned quote to S-PAS-004 and remains disabled until usable quote terms are available.
- Manual funding is selected. Automated funding is visibly disabled because the API does not define the `autoSave` fields. Add another item is unavailable in the preview because it has no cart callback.
- The page represents quote loading, retryable quote errors, server-mapped deadline/vendor/restriction errors, and missing quote terms. It does not locally invent a vendor deadline window.
- Tests cover quote request fields, navigation with the returned quote, date selection/server validation, loading, missing terms, and a 320 × 720 viewport.

### S-PAS-004 — Plan Summary & Terms

- Shows the selected product/vendor summary, server/host-mapped quote facts, expandable full terms, consent checkbox, and pinned Accept & continue to PIN action.
- Consent and usable quote terms are required before the action enables. Accept calls the injected plan adapter; the production host adapter is responsible for PIN authorization and required request headers. In the preview, the adapter returns a clearly synthetic preview-completion state without creating a plan.
- Represents pending authorization, general/restricted errors, terms-changed refresh, and success/preview completion. Terms-changed is a host-mapped presentation state; the API error catalog does not define its code.
- Tests cover expandable terms, consent gating, create request quote credentials, loading, success, refresh, restricted error, scrolling, and a 320 × 720 viewport.

All five screens inherit the isolated preview’s light/dark theme. The preview’s screen menu can open each screen directly, and its theme button switches modes. The existing preview navigation test checks palette/typography values in light and dark mode and visits both new plan screens.

## B. Automated tests and exact results

The focused tests had already passed in the preceding implementation verification; I inspected the current screen/test wiring and did not repeat them because no source or test files changed for this audit.

- From `implementation/pay_am_small/mobile`:
  `flutter test --no-pub test\marketplace_home_page_test.dart test\product_detail_page_test.dart test\vendor_storefront_page_test.dart test\plan_setup_page_test.dart test\plan_review_page_test.dart` — **passed, 16 tests**.
- From `implementation/pay_am_small/preview`:
  `flutter test --no-pub test\preview_navigation_test.dart` — **passed, 1 test**. It exercises the preview screen menu, marketplace → product → vendor/product navigation, product → plan setup → review, synthetic completion, and light/dark switching.
- The preceding implementation verification also reported Dart formatting clean and Flutter analysis clean for mobile and preview. Those commands were not rerun during this audit.
- The tests cover widget behavior and layout constraints, not actual browser rendering. No browser automation tool was available in this session; Chrome was not launched.

## C. Confirmed working

- Widget tests confirm the supported marketplace/product/storefront behaviors, navigation callbacks, async loading/error/empty states, plan quote and review flow, checkbox gating, expandable terms, server-mapped errors, and narrow layouts listed above.
- Preview test confirms all five routes are reachable through the menu, the non-production banner remains visible, and light/dark theme values are applied to the active screens.
- The supported preview journey reaches S-PAS-004 and its synthetic completion state. It does not perform a real plan creation.

## D. Failed or not verified

- No failure was reported by the latest focused test runs. Tests were not rerun for this audit.
- Actual Chrome rendering, visual fidelity at desktop/mobile browser breakpoints, browser-specific overflow, and real device interaction were **not verified** here.
- Marketplace Home has no current dedicated 320 px test. Its existing test uses 390 px and 390 × 1200 viewports.
- Live adapter/backend behavior, real quote mappings, real PIN authorization, and real plan creation cannot be verified with this isolated synthetic preview.
- Built-in fixtures do not provide UI controls to induce all failure, suspension, or empty states manually; those cases are covered by injected-adapter widget tests instead.

## E. Intentionally unavailable

- Real products, vendor profiles, quotes, payment, PIN, authentication, and backend calls: the preview uses local synthetic adapters only.
- Vendor-funded Credit, automated savings/debit scheduling, and account selection: unsupported or incomplete contract/product specifications.
- Add-item/cart behavior in Plan Setup: no preview cart integration or approved add-item contract.
- Pay-in-full purchase: no approved purchase endpoint in this feature contract; the preview displays an informational message only.
- Production error-code mapping for terms-changed and vendor-specific deadline ranges: the API/error contract does not supply these details.

The quote endpoint has no success response schema; plan creation has no documented success response schema and requires host-managed PIN/idempotency headers. These limitations are documented in the Pay Am Small README and remain host-integration/API gaps.

## F. Manual Chrome checks

From `implementation/pay_am_small/preview`, run:

```powershell
flutter run -d chrome
```

Then:

1. Use the top-right screen menu to open S-PAS-001. Search for `Haier Thermocool`, try a category chip, and open its product card.
2. On S-PAS-002, scroll through delivery and price-lock terms while checking that Continue stays visible. Open the vendor row, then open its product to verify the storefront/product path.
3. Return to Product Details, select Price-lock, and continue. On S-PAS-003, wait for the synthetic quote, open the deadline picker, and check that automated funding and Add another item are unavailable.
4. Continue to S-PAS-004, expand the terms, scroll to consent, accept, and confirm that the result explicitly says preview-only and did not create a real plan.
5. Use the theme button on each screen. In Chrome DevTools device emulation, inspect 390 × 844 and 320 × 720, especially the marketplace list, product terms/pinned button, plan setup footer, and review consent/footer.
6. Use the screen menu to open all five screens directly and confirm the persistent NON-PRODUCTION warning remains visible.

Manual Chrome interaction is still needed to assess actual browser appearance and hit targets. Do not treat the synthetic completion message as payment, PIN authorization, or a created plan.

## G. Batch 3 readiness

No Batch 3 screen should be blocked by a failing test in the latest reported run. Before production integration, the host/API owners still need to define quote/create response schemas, the `autoSave` child schema, PIN/idempotency handoff, vendor deadline-window data, and any approved cart/account-selection behavior. Keep those as explicit gaps rather than presenting the preview’s synthetic values as financial rules.
