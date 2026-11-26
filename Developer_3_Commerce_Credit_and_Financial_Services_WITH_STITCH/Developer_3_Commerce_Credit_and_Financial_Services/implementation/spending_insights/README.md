# Spending Insights & Rewards — Developer 3

This is an additive Flutter feature package. Batch 1 contains mobile S-INS-001,
S-INS-002 and S-INS-005. Batch 2 adds S-INS-003, S-INS-004 and S-INS-009 in
the same isolated preview app. It does not register
routes in the shared host or change Merchant Tools, Pay Am Small or Escrow.

## Run the isolated preview

In Windows PowerShell:

```powershell
Set-Location -LiteralPath 'C:\Users\hp\OneDrive\Documents\Fintech_Bank\Developer_3_Commerce_Credit_and_Financial_Services_WITH_STITCH\Developer_3_Commerce_Credit_and_Financial_Services\implementation\spending_insights\preview'
& 'C:\Users\hp\OneDrive\Documents\Fintech_Bank\.tools\flutter\bin\flutter.bat' run -d chrome --no-pub
```

Run `flutter pub get` first only when package resolution is needed and the
machine's Pub cache is writable. The verified preview already has its package
configuration and can launch with `--no-pub`.

The isolated preview has a persistent non-production notice, a theme toggle,
and a screen directory. Batch 1 routes:

- S-INS-001: `/insights?month=2026-11`
- S-INS-002: `/insights/category/food?month=2026-11`
- S-INS-005: `/insights/summary/2026-11`

Batch 2 routes:

- S-INS-003: `/insights/budgets`
- S-INS-004: `/insights/budgets/new`
- S-INS-009: `/insights/preferences`

Batch 3 routes:

- S-INS-006: `/rewards`
- S-INS-007: `/rewards/:campaignId` (opened from a host-supplied campaign or the unavailable-data preview link)

Batch 4 routes:

- S-INS-008: `/rewards/refer`
- W-INS-001: `/backoffice/rewards/campaigns`

Batch 5 route:

- W-INS-002: `/backoffice/rewards/budget`

Final batch route:

- W-INS-003: `/backoffice/rewards/referrals`

The November/October fixtures, budget cards and previous-month suggestions are
synthetic layout examples, not customer data. Budget creation and preference
saving require a connected host and are unavailable in preview; the preview
never reports a successful write. Preferences show “Not provided” until an
explicit choice is made, with no consent default implied. Re-categorisation is
unavailable in preview; sharing requires the host share service and is disabled.

## Host integration boundary

The `SpendingInsightsAdapter` accepts host-mapped presentation models, not
assumed API response DTOs. The documented reads are `GET /insights/summary`
and `GET /insights/categories/{categoryId}`; category correction uses
`PUT /insights/transactions/{transactionId}/category`. The OpenAPI contract
does not define successful response schemas for these endpoints. The host must
map server-computed values, consent status, chart proportions, category data,
merchant data, comparison copy and transaction descriptions. The feature does
not calculate spend, income, category shares, trends or recommendations.

Batch 2 contract gaps: budget and preference endpoints have no complete success
response schemas. Budgets use `GET /insights/budgets` and
`POST /insights/budgets`; no budget update operation is documented, so editing
is not offered. Create requests support a category, amount in kobo and optional
alert thresholds. The host must map progress, remaining amount and alert status.
Preferences use `PUT /insights/preferences`; the host must map nullable saved
choices and enforce consent. The preview does not persist choices.

Batch 3 uses only documented `GET /rewards` for the reward balance, recent
credits and campaigns. The success response schema is undocumented and there
is no separate campaign-detail endpoint; the host must map campaign-specific
action, reward, cap, dates, terms, status and progress from its response. The
preview supplies no reward or campaign fixture and displays the unavailable
state rather than inventing financial or campaign data.

Batch 4 contract gaps: `GET /rewards/referral` and
`GET /backoffice/rewards/campaigns` have no published success response
schemas. The campaign creation POST defines only `rules` (an open object),
`budgetKobo`, `startsAt` and `endsAt`; the host must supply its approved rules
schema and enforce Marketing admin permissions and dual-control approval. There
is no documented campaign update endpoint. Referral sharing is a host/platform
callback; preview referral information and campaign list data are unavailable,
and campaign submission returns an explicit unavailable response from the
preview adapter.

W-INS-002 reads documented `GET /backoffice/rewards/budget` data through the
Finance-authorized host adapter. Its success response schema is undocumented;
the host must map budget/spend amounts, chart fractions, alert messages and any
exhausted status. No pause/resume API is documented, so those controls remain
disabled. Preview data is unavailable rather than fabricated.

W-INS-003 receives flagged referral records only from an injected host queue
provider; no queue-list endpoint or response schema is documented. Decisions
use the documented `POST /backoffice/rewards/referrals/{id}/decision` request
with `APPROVE` or `REJECT` and an optional reason. The host must enforce Risk
analyst permission and provide the required idempotency key and PIN token.
Preview queue data and decision submission are unavailable; no review outcomes
or customer records are fabricated.

The API's recategorisation body contains a category string, but no allowed
category enum is documented. The screen therefore passes the customer's text
to the injected host adapter, which must enforce authoritative server rules.
Sharing is a host callback and is not an API endpoint in this feature spec.

## References

The official screen prompts are in the read-only extracted reference at
`06_stitch-ui-ux/05_products/spending-insights-rewards/screens.md`. That product
folder currently contains no exported per-screen `screen.png` or `code.html`.
The implementation follows the prompt structure and shared master brief and
tokens. Inter is bundled from the existing Developer 3 Escrow preview font
asset; its OFL notice is included beside the font.
