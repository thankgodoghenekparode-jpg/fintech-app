# Escrow - Developer 3 feature package

This is an additive, frontend-only Escrow feature. It does not connect to a production backend, authentication service, PIN authorization, bank transfer or document service.

## Dedicated Flutter preview

Run in an interactive Windows PowerShell terminal. This is the recommended
connected debug mode; Flutter Web hot reload is enabled by default.

```powershell
Set-Location -LiteralPath 'C:\Users\hp\OneDrive\Documents\Fintech_Bank\Developer_3_Commerce_Credit_and_Financial_Services_WITH_STITCH\Developer_3_Commerce_Credit_and_Financial_Services\implementation\escrow\preview'
& "C:\Users\hp\OneDrive\Documents\Fintech_Bank\.tools\flutter\bin\flutter.bat" run -d chrome --no-pub
```

If package dependencies have not yet been resolved in this checkout, run
`& "C:\Users\hp\OneDrive\Documents\Fintech_Bank\.tools\flutter\bin\flutter.bat" pub get` first.

Keep this terminal session running. Make Dart changes in the preview or
`../mobile/lib`, then press `r` in the terminal to hot reload. Use the More tab

> Escrow preview screens directory to open a newly registered route after the
> reload. Press `R` for a hot restart if a route registration, app initialization
> or the screen directory does not update after hot reload. Hot restart resets
> the current navigation stack to the Escrow home route.

For browsers that cannot attach to the Flutter Chrome debug session, run the
web-server device instead:

```powershell
Set-Location -LiteralPath 'C:\Users\hp\OneDrive\Documents\Fintech_Bank\Developer_3_Commerce_Credit_and_Financial_Services_WITH_STITCH\Developer_3_Commerce_Credit_and_Financial_Services\implementation\escrow\preview'
& "C:\Users\hp\OneDrive\Documents\Fintech_Bank\.tools\flutter\bin\flutter.bat" run -d web-server --web-hostname 127.0.0.1 --web-port 8788 --no-pub
```

Open `http://127.0.0.1:8788/` in a browser. Flutter's web-server device
requires its Dart Debug Chrome extension for live debugging. If the Flutter
terminal reports `No client connected` after `r`, the browser is not attached
to hot reload; manually refresh the tab to load the updated app. A manual
browser refresh is also required when inspecting a separately built or static
`build/web` output after rebuilding it.

To inspect the production web compilation, use `flutter build web --no-pub`.
The preview is independent of Developer 1 integration, non-production, and
shows synthetic examples with missing financial data labelled as unavailable.
Use the More tab > Escrow preview screens to open each registered screen:

- S-ESC-001 Escrow Home: `/escrow`
- S-ESC-002 Create Deal: `/escrow/new`
- S-ESC-003 Fees and Cancellation Terms: `/escrow/new/terms`
- S-ESC-004 Invite Counterparty: `/escrow/:dealId/invite`
- S-ESC-005 Accept Deal: `/escrow/:dealId/accept`
- S-ESC-006 Fund Escrow: `/escrow/:dealId/fund`
- S-ESC-007 Deal Details: `/escrow/:dealId`
- S-ESC-008 Submit Delivery: `/escrow/:dealId/deliver`
- S-ESC-009 Confirm Delivery: `/escrow/:dealId/confirm`
- S-ESC-010 Open Dispute: `/escrow/:dealId/dispute`
- S-ESC-011 Dispute Status and Tracking: `/escrow/:dealId/dispute/status`
- S-ESC-012 Cancel Deal: `/escrow/:dealId/cancel`
- S-ESC-013 Receipt and Rating: `/escrow/:dealId/receipt`

The Batch 2 preview uses a synthetic deal ID only for route inspection. It
does not invent amounts, fee totals, locked terms, transfer details, payment
results or PIN tokens. Invitation submission, deal acceptance and funding
remain unavailable in the preview. The preview is light mode only: the
approved Escrow prompts provide light designs and no exported dark references.

Batch 3 routes are registered with host-unavailable adapters in this preview.
They show unavailable/pending-safe states and do not fabricate a deal, amount,
delivery, evidence, role, deadline, permission or transaction outcome.

Batch 4 routes are registered with preview-only presentation fixtures so the
form and tracker layouts can be inspected without a backend. The open-dispute
form shows a disabled reason picker because no reason enum is documented, a
description field, and a disabled evidence control because no upload contract
exists. Submission stays disabled. The tracker uses the documented stage
labels as an illustrative timeline, explicitly marks itself as not a customer
case, and provides no dates, completed stages, rationale, appeal permission or
outcome. No dispute record is created.

Batch 5 cancellation and receipt routes use explicitly labelled preview-only
contexts. Cancellation shows unavailable scenario, fee and refund values and
keeps confirmation disabled. Receipt shows no transaction values and disables
sharing/rating. The preview does not cancel a deal, share a receipt, or submit a
rating.

## Host integration

The host supplies the feature adapters, authentication, tenant context,
response mapping, locked terms, fee data, supported invitation channels, PIN
authorization and route integration. Feature view models are presentation
contracts, not API response DTOs. Accept, fund, delivery and confirmation
adapters must attach the documented `Idempotency-Key` and `X-Pin-Token` where
required; retries for the same attempt reuse the key.
No fee calculations, minimum charges, limits, templates, checkpoints or
successful transaction fixtures are included.

## Batch 3 contract gaps

- `GET /escrow/deals/{dealId}` has no response schema. Deal details, status,
  held amount, next actor, timeline, participants, permissions, deadlines,
  messages and documents must be mapped by the host.
- A message submission contract exists, but there is no documented message-list
  response shape or document-list contract. Attachments and document open URLs
  require host mapping; the feature only submits a documented message body.
- Delivery submission documents milestone sequence, evidence string references
  and note, but no evidence picker/upload/signing contract. The host must own
  file validation, upload progress and signed reference creation.
- Delivery and confirmation response schemas are absent. The host must map
  pending/recorded results and authorization. PIN tokens and idempotency keys
  are passed only through host adapters.
- The delivery-code length rule is documented as six digits. Applicable
  milestones, release/revision permissions, auto-release dates and status rules
  must be host-supplied; the UI does not infer them.

## Batch 4 contract gaps

- The open-dispute API documents `reason`, `description`, and evidence
  references, but no reason enum, evidence upload contract, accepted evidence
  rules, or response schema. The host must provide options and authorization.
- The current dispute-status endpoint has no response schema; status, timeline,
  submissions visible to each party, responsible party, deadlines, and decision
  rationale must be mapped by the host.
- An appeal endpoint accepts a reason and requires PIN authorization and an
  idempotency key, but the product/API contract does not define eligibility,
  appeal reason rules, second-review workflow, or response schema. Appeal is
  only enabled when the host explicitly supplies permission.
- Dispute window closure, frozen deal state, and dispute deadlines are only
  rendered when host supplied. The feature does not derive dates or decisions.

## Batch 5 contract gaps

- `POST /escrow/deals/{dealId}/cancel` documents a required string `reason`,
  `Idempotency-Key`, and `X-Pin-Token`, but no reason enum, eligibility schema,
  counterparty-agreement state, or response schema. Scenario, agreed fee
  treatment and net refund must come from host-mapped deal/terms state.
- Receipt retrieval/share and rating endpoints or schemas are not documented.
  The host must supply receipt fields, share payload, rating options,
  eligibility and any submission operation. No rating scale or transaction
  record is inferred by the feature.

## Batch 2 contract gaps

- The invite request documents `phone` and `channel`, but no channel enum or
  share-link generation contract is defined.
- Message submission is documented, but message-list response mapping and
  attachments require host mapping; the feature does not invent those schemas.
- Terms `scenarioOptions` is open-ended and the accept/fund responses have no
  response schemas. The host must supply mapped terms snapshots and outcomes.
- The fund endpoint has no request body. Wallet/transfer initiation and method
  selection therefore require a host adapter contract; the screen does not
  encode a guessed request field.

## Stitch references

The Escrow Stitch folder contains the screen prompts in
`front-end extracted/front-end extracted/06_stitch-ui-ux/05_products/escrow/screens.md`.
The folder contains `screens.md`; no per-screen `screen.png` or `code.html`
exports were present during the screen batches. The feature follows available
prompts, the master brief, shared tokens and existing component patterns. No
missing exports are claimed as inspected.

## Batch 6: W-ESC-001 My Deals (Business)

- Web feature route: `/escrow/web/deals` in the existing
  `implementation/web/preview` Vite preview. From `implementation/web`, run
  `npm run dev`, then open `http://127.0.0.1:5173/escrow/web/deals`.
- The page provides host-mapped deal search, status filtering, a responsive
  deal table, a detail drawer and a host-injected export action. The isolated
  preview uses explicitly synthetic rows and a local CSV download of those
  rows only.
- `GET /escrow/deals` and `GET /escrow/deals/{dealId}` are documented, but
  their response schemas are absent. Authentication, tenant scoping and
  response mapping remain host-owned.
- ESC-TRU-005 calls for business deal exports, but the API documentation has no
  export endpoint, payload or file-format contract. Production export remains
  disabled unless the host injects an approved export operation. The local CSV
  behavior exists only in the non-production preview.
- The W-ESC-001 Stitch prompt is in `screens.md`. It specifies the light-mode
  table, filters, export and detail drawer. No exported `screen.png`,
  `code.html`, or dedicated dark-mode reference is available; preview dark
  mode applies shared dark tokens to the same layout.

## Batch 7: W-ESC-002 Dispute Queue and W-ESC-003 Dispute Case

- Both routes are registered in the existing Vite preview: `/backoffice/escrow/disputes`
  and `/backoffice/escrow/disputes/:caseId`. From `implementation/web`, run
  `npm run dev` and open `http://127.0.0.1:5173/backoffice/escrow/disputes`.
  Open the synthetic queue row to navigate to its case; use Back to queue or
  browser history to return. W-ESC-001 remains at `/escrow/web/deals`.
- The preview is explicitly non-production and contains one synthetic layout
  row. It supplies no customer record, evidence, decision, fee outcome, appeal
  permission, or real SLA assessment. Decision submission and authorization
  remain unavailable in preview.
- `GET /backoffice/escrow/disputes` is mapped by an injected queue adapter.
  Its response schema is not documented. There is no documented back-office
  case-read endpoint or case response schema; the host must supply authorized
  case data and permission state.
- Decision submission follows the documented
  `POST /backoffice/escrow/disputes/{id}/decision` fields and requires a
  host-issued `X-Pin-Token` and UUID `Idempotency-Key`. Outcome and rationale
  are required; `splitSellerKobo` is only forwarded as an optional integer
  supplied by the authorized operator. The feature does not calculate a split.
- The UI's fee-outcome summary is host-supplied/read-only because no fee
  decision field is defined in the decision request. Appeal eligibility and
  second-review states do not have complete contracts; the host must map these
  states. No appeal submission or second-review authority is inferred.
- Stitch `screens.md` contains prompts for W-ESC-002 and W-ESC-003. No
  `screen.png`, `code.html`, or dark-mode export exists in the Escrow Stitch
  folder. The preview uses the available prompts and shared design tokens;
  dark mode retains the same layout with shared theme tokens.

## Batch 8: W-ESC-004 Templates and Fees

- Route: `/backoffice/escrow/config` in the existing Vite preview. From
  `implementation/web`, run `npm run dev` and open
  `http://127.0.0.1:5173/backoffice/escrow/config`. The screen is also linked
  from the My Deals and Dispute Queue preview navigation.
- The screen renders host-mapped template configuration sections for
  checkpoints, timers/reminders, required documents, and fee schedule/minimum
  charge. Only fields and values supplied by the host are shown. Host-provided
  field metadata controls editability and required validation; the UI does not
  infer timer units, fee values, limits or configuration rules.
- The preview uses a visibly synthetic template shell with all configuration
  values unavailable and proposal submission disabled. Theme switching and the
  persistent non-production notice remain available. No template or fee
  changes are sent from preview.
- `PUT /backoffice/escrow/templates/{type}` is documented for Product Admin
  proposals and requires a `config` object, but the nested config schema,
  template listing/read endpoint, fee field schema, validation rules, and
  proposal response/approval-status schema are not documented. The injected
  adapter maps presentation setting changes into the API's opaque `config`
  object and must return a pending-approval state only when the host confirms
  it. Dual-control authorization and approval remain host responsibilities;
  no second-approver endpoint is documented.
- The W-ESC-004 Stitch prompt is in `screens.md` and specifies the template
  editor, timers, documents, fee schedule, minimum charge and pending-approval
  state. No exported `screen.png`, `code.html`, or dark-mode reference is
  available. The screen follows the prompt and shared tokens; dark mode keeps
  the same structure and applies shared theme colors.
