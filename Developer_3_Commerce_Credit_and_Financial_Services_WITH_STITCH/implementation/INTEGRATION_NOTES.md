# Developer 3 Feature Package Integration Notes

## Merchant Tools, first slice

### Host dependencies

- The Flutter host provides the active `tenantId`, authenticated/instrumented product data adapter, token-derived `ThemeData`, central localized copy implementation, and approved action handlers.
- The adapter maps the eventual approved `GET /business/home` response into the package's `MerchantHomeSnapshot` presentation model. It must not infer missing business rules, calculate fees/totals, or claim the model is the API wire schema.
- The host supplies callbacks for business switching and Collect, Payment link, Invoice, Refund, and Create business. This package does not register routes or implement the target screens.
- The package uses no global navigation, session, auth, API client, or design-system implementation. Do not add it to the shared router until Developer 1 approves the integration change.
- Merchant strings are provided through `MerchantHomeCopy`; merge the ARB contribution into the host central text layer only after Developer 1 approves.

### API boundary

The documented endpoint is `GET /business/home` with `X-Tenant-Id`, but its 200 response has no schema. This slice defines a UI-facing presentation contract and injectable adapter only. It contains no Dio client, fetch call, URL, token handling, polling, or production mock data.

### Future web package

The React package declares compatible peer ranges for the existing Next.js/React/TanStack host. W-MER-001 through W-MER-004 are implemented as frontend feature components with an isolated preview; W-MER-005 is not started. Future W-MER route wrappers must be registered by the host after route and permission ownership is approved.

The web package currently exports TypeScript source. The Next.js host must add it as a local package dependency and approve either `transpilePackages` configuration or a package build-to-JavaScript step before importing it. Neither option is changed in this slice.

### Flutter host registration

After Developer 1 approval, the host can add the package as a path dependency and construct a `GoRoute` for `/business`. The route wrapper must inject the current tenant ID, token-backed `MerchantHomeDataAdapter`, localization implementation, token metrics, business-switch callback, and action handlers. This package exports no global session or `GoRouter` state.

### Test boundary

Feature tests inject in-memory adapters and test-only sample records. Those fixtures verify rendering and state handling only; they do not simulate a live business API or transaction.

## Merchant Tools, S-MER-002 Create business

- `BusinessCreationPage` is a four-step mobile feature screen. It receives localized `BusinessCreationCopy`, the same injected spacing/radius token model as S-MER-001, and host callbacks for back/help.
- The host overrides `businessCreationAdapterProvider` with an implementation of `BusinessCreationAdapter`. Its `createBusiness` input corresponds only to documented `POST /business` fields. The feature package does not implement HTTP, auth, upload, or production response parsing.
- The host must provide `selectOwnerIdDocument`, returning the opaque `ownerIdFileKey` from its approved document service. The selector remains disabled when omitted; no file-picker plugin or upload endpoint is invented here.
- The OpenAPI response for 201 is unspecified. The UI treats successful completion as submitted/pending verification based on MER-F01; it does not consume a response body.
- `type` is required but has no documented allowed values. The current screen accepts text and records the open validation question; confirm canonical type values before tightening validation.
- The screen uses host `ThemeData` and Material `TextFormField`, `OutlinedButton`, and `FilledButton` controls. Host code currently contains token maps and `AppTheme`, but no shared component widget implementations. No shared app or package dependencies were changed.
- No route is registered. The host may later mount the exported `BusinessCreationPage` at `/business/new` after approving its copy, token, document-selector, and API-adapter providers.

## Merchant Tools, S-MER-003 Payment links

- `PaymentLinksPage` takes the active tenant ID, localized `PaymentLinksCopy`, host spacing/radius tokens, and optional back/share callbacks. It does not register `/business/links`.
- The host overrides `merchantPaymentLinksAdapterProvider`. The adapter maps documented `GET /business/payment-requests` and `POST /business/payment-requests` contracts into `MerchantPaymentLink` presentation rows and a `CreatedMerchantPaymentLink` share model. The package does not define wire response DTOs or issue network requests.
- Create requests use `kind: LINK`, `amountKobo` only for fixed-price links, optional description and expiry, and the documented `multiUse` flag. Amount text is parsed to integer kobo without floating point; the UI does not calculate fees, totals, or use counts.
- The response schema does not define the created link reference or share URL. The adapter must return share text from an approved response mapping; system sharing is supplied by the optional `onShare` callback. Copy uses Flutter's platform clipboard API.
- List status and collected totals are presentation data supplied by the adapter; the GET 200 schema is unspecified. The UI displays totals only when the adapter supplies them.
- Expiry selection converts the selected local date/time to UTC for the request. Confirm the backend's timezone/expiry semantics before production use.

## Merchant Tools, S-MER-004 QR codes

- `QrCodesPage` is the mobile `/business/qr` feature screen. It accepts tenant context, localized `QrCodesCopy`, host spacing/radius tokens, and optional host callbacks for back, share, and print. It does not register a route or add dependencies.
- The host overrides `merchantQrCodesAdapterProvider`. `loadStaticQr` maps the documented GET `/business/payment-requests` response to a static QR presentation. `createQr` maps documented POST requests using `kind: QR_STATIC` or `kind: QR_DYNAMIC`; dynamic requests include integer `amountKobo` and optional `description` only.
- The adapter provides decoded PNG bytes for QR display. The screen does not implement the national QR encoding standard or infer a payload/URL from API fields. Use an approved encoder/renderer in the host adapter after the API response contract is available.
- Dynamic status labels and updates are supplied as a mapped initial label and stream. No QR status endpoint is documented; the screen does not poll or create a network stream. The host owns push/status delivery and localization-safe status mapping.
- Share and print/PDF are injected host actions receiving the presentation model. Buttons are disabled when callbacks are not supplied; this package does not add share/printing plugins or invent a PDF format.
- The Stitch export includes settlement/partner claims, merchant identifiers, audio alerts, customer notes, sample amounts, and standee ordering. These are omitted because the functional/API documents do not define them.

## Merchant Tools, S-MER-005 Create invoice

- `InvoiceCreationPage` is the mobile feature screen for `/business/invoices/new`. It uses the existing `MerchantHomeTokens`, host `ThemeData`, an `InvoiceCreationCopy` contribution, host tenant ID, and `invoiceCreationAdapterProvider`; no route is registered here.
- The page collects customer name/contact, one or more line-item descriptions and amounts, optional integer tax basis points, due date, notes, and a link/SMS/email selection. Amount text is parsed to integer kobo without floating-point conversion. The page previews entered values and does not calculate a subtotal, tax amount, or total.
- `CreateInvoiceSubmission` is frontend-only input, not an API DTO. The documented `POST /business/invoices` request leaves `customer` and `items` objects open-ended and does not include the delivery channel. The host must not map this model to wire JSON until the API owner confirms field shapes and delivery sequence.
- `InvoiceCreationAdapter.sendInvoice` is the only submit boundary. There is no HTTP client or invented endpoint in this package. It receives a tenant ID and UI submission. The documented create response has no schema or invoice ID, while the send endpoint requires an existing invoice ID; host integration is blocked on those contracts.
- Unknown submit outcomes disable resubmission to avoid duplicate invoices because the create operation has no documented idempotency key or reconciliation response. The host adapter should throw `InvoiceSubmissionException` with `outcomeUnknown: false` only when it knows the request was rejected; use `true` when acceptance cannot be confirmed. Offline failures can set `isOffline: true` when known.
- The Stitch references are `shared_reference/06_stitch-ui-ux/screens/create_invoice_s_mer_005/` and `create_invoice_dark_mode_s_mer_005/` (`screen.png` and `code.html` in each). The feature uses their customer, date, items, tax, notes, preview/send hierarchy and host light/dark theme. Unsupported invoice identifiers, VAT claims, terms, discounts, bank/account details, payment rails, reminders, PDF/draft actions, and totals are omitted.
- Eight widget tests cover screen sections, required/positive amount validation, item add/remove, preview without submit, adapter submission, pending duplicate-tap protection, delivery contact validation, and blocking a blind retry on unknown outcome. Flutter test/analyze execution remains blocked by the Flutter SDK tool snapshot bootstrap issue.

## Merchant Tools, S-MER-006 Invoices

- `InvoicesPage` is the mobile feature screen for `/business/invoices`; no route is registered in the feature package. The host provides `tenantId`, `InvoicesCopy`, `MerchantHomeTokens`, `ThemeData`, and `MerchantInvoicesAdapter`.
- `loadInvoices` receives the selected All/Unpaid/Overdue/Paid UI filter. The host maps it to the documented `GET /business/invoices` `status` query (and pagination if approved). The API declares a `cursor` query but no response schema, so cursor handling and complete category results are host/API contract blockers.
- `MerchantInvoiceSummary` and `InvoiceTimelineEntry` are screen presentation models, not API DTOs. Invoice identifiers, references, amounts, customer display names, statuses, due dates, and timeline events must be mapped from approved response data; the screen calculates none of them.
- The detail's Remind action asks the user for LINK, SMS, or EMAIL, then calls the injected adapter for the documented `POST /business/invoices/{invoiceId}/send` operation. The adapter owns auth, tenant headers, request/error mapping, and response handling. No API client or endpoint is implemented here.
- A confirmed rejection can be surfaced with `InvoiceReminderException(outcomeUnknown: false)`. An unknown reminder result disables further reminder attempts for that invoice during the current screen session to avoid blind duplicate requests. The host still needs an approved reconciliation strategy.
- Stitch references are `shared_reference/06_stitch-ui-ux/screens/invoices_s_mer_006/` and `invoices_dark_mode_s_mer_006/`. The implementation follows the invoice list, status categories, invoice detail and timeline/reminder hierarchy, while using the host's light/dark `ThemeData`. Unsupported summary totals, counts, payment rails, cash recording, copy-link, receipt/PDF actions, statutory claims, and export sample data are omitted.
- Eight widget tests cover loading, filter tabs and adapter input, empty and retry states, detail/timeline rendering, reminder channel submission/refresh, and unknown-outcome retry protection. Flutter analyzer/test execution remains blocked by the Flutter SDK tool snapshot bootstrap issue.

## Merchant Tools batch, S-MER-007–009

- `CashierPage` (`/business/cashier`) uses `CashierAdapter` to map documented `POST /business/payment-requests` QR_DYNAMIC or LINK intent into an opaque presentation with QR PNG/share text and an optional status stream. Amount conversion uses integer kobo. The host owns the real-time status event and must map only a confirmed paid state. The optional paid callback can trigger approved host audio/haptics. There is no polling, cancellation, backend, or fabricated customer data.
- `TransactionsPage` (`/business/transactions`) maps the undocumented GET response into `TransactionsSnapshot`/`MerchantTransactionRow`; these are presentation models, not wire DTOs. It displays the supplied balance and rows, offers all/collection/payout display filters, and lets the host provide statement and refund navigation callbacks. Payout destinations and permission/block reason must be verified and supplied by the host. `requestPayout` delegates the documented POST to the host adapter, which owns tenant/auth headers, Owner role enforcement, secure PIN flow, a unique idempotency key, reconciliation, and response mapping. The feature does not collect/store PINs or calculate payout limits/fees.
- `RefundPage` (`/business/refund/:id`) loads a host-mapped `RefundContext`, including eligibility, blocked reason and maximum refundable amount, then submits the documented paymentId/amountKobo/reason intent through `MerchantRefundAdapter`. The screen collects a free-text reason and presents a confirmation dialog. The host must enforce Manager permission, validate current funds/window/eligibility, obtain secure PIN confirmation, attach a unique idempotency key and reconcile unknown outcomes. No business threshold or dual-control flow is guessed in this package.
- A generic or explicitly unknown payout/refund outcome locks further submission for the current screen instance to prevent a blind duplicate. A host should reconcile the operation before allowing a new attempt.
- Stitch references followed: `shared_reference/06_stitch-ui-ux/screens/cashier_s_mer_007/` with `cashier_dark_mode_s_mer_007/`; `transactions_and_payouts_s_mer_008/` with `transactions_and_payouts_dark_mode_s_mer_008/`; `refund_s_mer_009/` with `refund_dark_mode_s_mer_009/`. Each directory contains the relevant `screen.png` and `code.html`. Host `ThemeData` drives light/dark appearance. Unsupported sample transactions, fees, partner/regulatory claims, payout timing, bank details, fixed refund reasons, PIN entry and simulated payment controls are excluded.
- Copy is exposed through `CashierCopy`, `TransactionsCopy`, and `RefundCopy`; the host localization layer must implement these interfaces. Existing host spacing/radius tokens and `ThemeData` are used. The package exports the screens but does not add shared navigation or routes.
- Five widget tests were authored for positive amount gating/adapter conversion, mapped transaction/balance display and filter behavior, adapter-provided refund blocking, and rejecting refund amounts above the original payment. The bundled Dart formatter successfully formatted all eight changed Dart files; it warned that `flutter_lints` cannot resolve because package dependencies are not resolved. Dart analyzer was invoked directly: it could not resolve Flutter/Riverpod imports because the package configuration is absent. Widget tests were not run because Flutter still lacks its tool snapshot and bootstrap remains unresolved. No SDK or shared files were changed.

## Merchant Tools, S-MER-010 Team

- `TeamPage` is exported for `/business/team`; the feature package does not register the route. The host supplies tenant ID, `TeamCopy`, `MerchantHomeTokens`, theme, and `MerchantTeamAdapter`.
- `MerchantTeamDirectory` and `MerchantTeamMember` are UI presentation models supplied by the host. They are not API response DTOs: the documented API has no team-list operation or response schema. The host must source/map directory data and invite permission from an approved contract; no permission descriptions are inferred.
- `inviteMember` exposes only the documented `POST /business/team` phone and role intent (`MANAGER`, `CASHIER`, or `ACCOUNTANT`). The host owns auth, tenant headers, request mapping and outcome handling. The 201 response is unspecified, so the feature consumes no response body and does not claim invite acceptance beyond adapter completion.
- No member edit/removal actions, permission matrix, shift/status/terminal/location claims, API client, or route are implemented. These remain blocked on API/product decisions recorded as MER-API-003.
- Exact Stitch references are `shared_reference/06_stitch-ui-ux/screens/team_s_mer_010/` and `team_dark_mode_s_mer_010/`. Theme colors and typography come from the host; spacing/radii use injected `MerchantHomeTokens`.
- `TeamPage` tests cover injected directory rendering/filtering, loading/offline states, and the documented invite intent. The preview fixture is synthetic and its invite callback performs no operation.

## Merchant Tools web screens W-MER-001 and W-MER-004

- W-MER-001 `/business/:t/dashboard` consumes `BusinessDashboardAdapter.loadDashboard({ tenantId })`. The adapter maps approved host data into a UI presentation snapshot with sales, fees, refunds, outstanding invoices, chart points, and recent activity. This is not the `/business/home` wire schema. Drill-down callbacks target host-owned invoices/reports screens.
- W-MER-004 `/business/:t/reports` consumes `ReportsAdapter.loadReport` and `exportReport`; the host supplies the opaque report type. Date bounds are passed as documented `from`/`to` values. The UI displays host-mapped sales, fees, refunds, and tax summary and delegates export without choosing a file format or creating a file itself.
- The exact Stitch exports are `shared_reference/06_stitch-ui-ux/screens/business_dashboard_w_mer_001_1/` and `_2/`, and `reports_and_exports_w_mer_004_1/` and `_2/` (each contains `screen.png` and `code.html`). They are light visual alternatives; dark mode uses the feature package's token-driven theme. Unsupported sample figures, account/customer identifiers, regulatory or provider claims, guaranteed fees/settlement statements, and undocumented controls are omitted.
- `GET /business/home` and `GET /business/reports/{type}` have no documented 200 response schemas. The report type is not constrained by an enum, and `format` is unconstrained without an export response/file contract. No HTTP client, guessed wire DTO, production fixture, report-type choice, export format, or file-generation behavior is implemented. Host mapping and export delivery remain integration gaps.

## Merchant Tools web screen W-MER-005 Team and verification

- W-MER-005 `/business/:t/team` uses an injected `TeamVerificationAdapter`. `loadOverview` accepts host-mapped roster, role permission descriptions, and business-verification state; these are presentation contracts, not API response DTOs. Verification status/rejection reason are not fetched or inferred by this package.
- `inviteMember` accepts only tenant ID, phone, and the documented MANAGER/CASHIER/ACCOUNTANT role, matching `POST /business/team`. The adapter owns auth, tenant headers, request mapping and result interpretation. No success body is assumed.
- The exact Stitch references inspected are `shared_reference/06_stitch-ui-ux/screens/team_and_verification_w_mer_005_1/` and `_2/` (`screen.png` and `code.html` in both). The feature follows the roster, permissions-detail, verification-status, rejected-reason and invite hierarchy. Terminal binding, permission editing, staff removal, document upload/download, audit/security logs, provider/compliance claims, verification tiers and sample business identifiers are omitted because they are not supported by the product contracts.
- API gaps include no team-list or team-removal endpoint, no team-list response or role-permission matrix schema, no verification-status/reason endpoint or schema, and no document read/upload/download operation. MER-ACC-002 mentions owner removal, but no matching operation is defined in the API spec. Host integration must resolve these gaps before wiring production data/actions.

## Merchant Tools web screen W-MER-005 Team and verification

- W-MER-005 `/business/:t/team` uses an injected `TeamVerificationAdapter`. `loadOverview` accepts host-mapped roster rows, role permission descriptions, and business-verification state; these are presentation contracts, not API response DTOs. Verification status/rejection reason are not fetched or inferred by this package.
- `inviteMember` accepts only tenant ID, phone, and the documented MANAGER/CASHIER/ACCOUNTANT role, matching `POST /business/team`. The adapter owns auth, tenant headers, request mapping and result interpretation. No success body is assumed.
- The exact Stitch references inspected are `shared_reference/06_stitch-ui-ux/screens/team_and_verification_w_mer_005_1/` and `_2/` (`screen.png` and `code.html` in both). The feature follows the roster, permission-detail, verification-status, rejected-reason and invite hierarchy. Terminal binding, permission editing, staff removal, document upload/download, audit/security logs, provider/compliance claims, verification tiers and sample business identifiers are omitted because they are not supported by product contracts.
- API gaps include no team-list or team-removal endpoint, no team-list response or role-permission matrix schema, no verification-status/reason endpoint or schema, and no document read/upload/download operation. MER-ACC-002 mentions owner removal, but no matching operation is defined in the API spec. Resolve these gaps before wiring production data/actions.
