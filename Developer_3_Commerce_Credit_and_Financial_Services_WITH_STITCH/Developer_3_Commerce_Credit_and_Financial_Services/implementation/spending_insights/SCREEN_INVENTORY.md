# Spending Insights & Rewards — official inventory and plan

Source: extracted product `04_products/spending-insights-rewards/02_screen_inventory.md`.
The source assigns 9 mobile screens and 3 web dashboard screens (12 total).

| ID | Official name | Platform / route | Stitch reference | Batch |
|---|---|---|---|---|
| S-INS-001 | Insights home | M `/insights` | `06_stitch-ui-ux/05_products/spending-insights-rewards/screens.md`, S-INS-001 prompt; no PNG/HTML export found | 1 |
| S-INS-002 | Category detail | M `/insights/category/:id` | Same `screens.md`, S-INS-002 prompt; no PNG/HTML export found | 1 |
| S-INS-003 | Budgets | M `/insights/budgets` | Same `screens.md`, S-INS-003 prompt; no PNG/HTML export found | 2 |
| S-INS-004 | Create budget | M `/insights/budgets/new` | Same `screens.md`, S-INS-004 prompt; no PNG/HTML export found | 2 |
| S-INS-005 | Monthly summary | M `/insights/summary/:month` | Same `screens.md`, S-INS-005 prompt; no PNG/HTML export found | 1 |
| S-INS-006 | Rewards home | M `/rewards` | Same `screens.md`, S-INS-006 prompt; no PNG/HTML export found | 3 |
| S-INS-007 | Campaign detail | M `/rewards/:id` | Same `screens.md`, S-INS-007 prompt; no PNG/HTML export found | 3 |
| S-INS-008 | Refer a friend | M `/rewards/refer` | Same `screens.md`, S-INS-008 prompt; no PNG/HTML export found | 4 |
| S-INS-009 | Privacy and preferences | M `/insights/preferences` | Same `screens.md`, S-INS-009 prompt; no PNG/HTML export found | 2 |
| W-INS-001 | Campaigns and rules | W `/backoffice/rewards/campaigns` | Same `screens.md`, W-INS-001 prompt; no PNG/HTML export found | 4 |
| W-INS-002 | Reward budget and cost | W `/backoffice/rewards/budget` | Same `screens.md`, W-INS-002 prompt; no PNG/HTML export found | 5 |
| W-INS-003 | Referral review | W `/backoffice/rewards/referrals` | Same `screens.md`, W-INS-003 prompt; no PNG/HTML export found | 6 |

## Batch 1 journey

Insights home → category detail. The monthly summary is also reachable from the
home screen and shares the host-provided monthly summary model. Batch 2 is
budgets, create budget and privacy/preferences; Batch 3 is reward home and
campaign detail; Batch 4 is referral; web administration is separated into
campaign configuration/cost control and referral review.

## Product/API gaps affecting Batch 1

- `GET /insights/summary` and `GET /insights/categories/{categoryId}` have no
  documented 200 response schema. Host mapping is required.
- The recategorisation API accepts a category string but does not define its
  allowed values or a category-enumeration contract.
- Screen share is a host/platform operation; no share API is documented.
- Consent controls are on S-INS-009, outside this batch. This batch respects
  host-supplied consent and hides personalised views while consent is off.
- Figures and chart proportions must be computed and supplied by the server;
  this feature does not derive them.
