# Instant Loan — Developer 3 Batches 1–4

An additive, isolated Flutter feature for S-LOAN-001 through S-LOAN-012. It
does not modify shared app navigation or other Developer 3 modules.

## Run the isolated preview (Windows PowerShell)

```powershell
Set-Location -LiteralPath 'C:\Users\hp\OneDrive\Documents\Fintech_Bank\Developer_3_Commerce_Credit_and_Financial_Services_WITH_STITCH\Developer_3_Commerce_Credit_and_Financial_Services\implementation\instant_loan\preview'
& 'C:\Users\hp\OneDrive\Documents\Fintech_Bank\.tools\flutter\bin\flutter.bat' run -d chrome --no-pub
```

Routes:

- S-LOAN-001: `/borrow`
- S-LOAN-002: `/borrow/eligibility`
- S-LOAN-003: `/borrow/new`
- S-LOAN-004: `/borrow/affordability`
- S-LOAN-005: `/borrow/review`
- S-LOAN-006: `/borrow/result`
- S-LOAN-007: `/borrow/loans/:id`
- S-LOAN-008: `/borrow/loans/:id/repay`
- S-LOAN-009: `/borrow/loans/:id/auto`
- S-LOAN-010: `/borrow/loans/:id/help`
- S-LOAN-011: `/borrow/history`
- S-LOAN-012: `/borrow/about`

## Batch 5 — Back-office web screens

The web feature exports `LoanApplicationsPage` and `LoanPortfolioPage` with
typed host-facing presentation adapters from `implementation/web/src/index.ts`.
The shared web preview registers:

- W-LOAN-001 Applications queue: `/backoffice/loans/applications`
- W-LOAN-002 Portfolio and collections: `/backoffice/loans/portfolio`
- W-LOAN-003 Product configuration: `/backoffice/loans/products`
- W-LOAN-004 Partner settlement: `/backoffice/loans/settlement`

From `implementation/web`, run `npm run dev` and open any route on the
Vite address (normally `http://127.0.0.1:5173`). The preview uses no loan or
portfolio records and displays an explicit host-data-unavailable state. It does
not connect to an API, authorization service, decision flow, or collection
operation. The screen list and light/dark switch are available on both routes.

Integration notes: the documented GET operations do not specify success
response schemas. The application decision contract requires `decision`
(`APPROVE` or `DECLINE`) and `reason`, plus `Idempotency-Key` and `X-Pin-Token`;
the host must supply those authorization values. The PRD also describes REFER
as a decision-engine outcome, but the decision endpoint schema does not accept
REFER. Portfolio display values, contact histories, contact-hour restrictions,
approved collection scripts, and hardship case fields must all be host supplied.
No collection-action endpoint is documented.

The final web screens likewise use host-facing presentation adapters, not
guessed response DTOs. Product configuration uses the documented generic
`config` object and `effectiveFrom` fields; only host-supplied configuration
keys are editable. The host remains responsible for product-admin permissions
and its dual-control approval workflow. The settlement period selector uses
periods returned by the host (the GET operation documents no period query
parameter). Settlement approval requires host-provided Finance authorization,
`Idempotency-Key` and `X-Pin-Token`; no approval or export operation is active in
the isolated preview. No export endpoint is documented, so the interface only
enables export when the host injects a handler.

The Instant Loan Stitch folder contains prompts for W-LOAN-003 and W-LOAN-004
in `06_stitch-ui-ux/05_products/instant-loan/screens.md`, but no per-screen
`screen.png` or `code.html` exports. These screens use the prompt structure and
shared tokens; screenshot comparison was not available.

The preview has a persistent NON-PRODUCTION banner and a light/dark theme
switch. The preview adapter returns no borrower or loan data and does not call
production services. Use the screen directory to open each route; Batch 3 uses
the placeholder path id `preview-loan` and displays unavailable states.

## Host integration and contract gaps

`InstantLoanAdapter` maps documented `GET /loans/eligibility`, `GET /loans`,
and `POST /loans/quote`. The OpenAPI document omits success response schemas
for these endpoints. The host must supply eligibility, lender registration,
limit progression, product amount range, available tenors, any active-loan
summary, and all quote totals, fees, interest, instalments, due dates and
affordability copy. The feature renders host-supplied values and does not
calculate costs or infer approval.

The S-LOAN-003 Continue action is available to a host callback only when a
server quote includes its required quote ID. The S-LOAN-002
privacy link presents only the documented commitment that contacts and photos
are not accessed; it does not access device data.

The Stitch folder contains `screens.md` prompts but no per-screen PNG or HTML
exports. Layout follows those prompts and the shared design brief/tokens;
per-screen screenshot comparison was not possible.

Batch 2 continues the quoted loan flow: S-LOAN-003 passes its server quote to
S-LOAN-004; the affordability screen passes that quote to S-LOAN-005; and the
application outcome returned through the host adapter is passed to S-LOAN-006.
S-LOAN-004 does not calculate affordability locally. It requires host-mapped
repayment, typical monthly inflows and a server-computed chart proportion.

`POST /loans/quote` and `POST /loans/applications` have no published success
response schemas. The host must supply the complete affordability comparison,
agreement version/text/key facts, and any confirmed result data. The host also
owns PIN authorization and must include the documented `Idempotency-Key` and
`X-Pin-Token` on application submission. A stale agreement is surfaced for
host-driven reload. The preview has no quote, agreement or application data;
application submission remains unavailable and no disbursement is simulated.

For Batch 3, the API publishes no response schemas for `GET /loans/{loanId}`,
`POST /loans/{loanId}/repayments`, or `PUT /loans/{loanId}/auto-repay`. The
host must map loan status, balances, schedule, receipts, repayment options,
early-repayment savings, auto-repay consent/date and confirmed operation
results. The host owns PIN authorization and the documented
`Idempotency-Key`/`X-Pin-Token` headers for money-moving/consent operations.
Insufficient-funds error mapping is not specified by the API contract and must
be provided by the host where it can identify that condition. The preview
keeps all these operations unavailable and does not simulate a repayment or
consent update. The hardship destination is a later screen; the Need help
callbacks remain host-supplied.

The Stitch source provides screen prompts but no screen PNG or HTML exports;
the screens follow the approved prompt and shared tokens, without claiming
per-screen screenshot comparison.

Batch 4 exports screens with injected copy objects. English strings are
contributed in `implementation/localization/instant_loan_en.arb` for the
central host localization layer. The isolated preview supplies an English
copy adapter that mirrors the ARB; production integration injects the host's
generated central-localization implementation. The mobile feature adds no
competing localization runtime.

`GET /loans` and `GET /loans/eligibility` have no success schemas. The host
must map history, lender identity and approved complaint/regulator details.
Limit-history data has no documented endpoint/contract. Hardship reason
choices and response-time commitments are unspecified; the host must supply
approved reason choices or the form remains disabled. The hardship API has no
attachment field, so document upload remains unavailable. The preview supplies
no loan, history, lender contact, approved reason options or operation result.
