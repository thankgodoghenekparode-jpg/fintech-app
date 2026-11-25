# PRD - Spending Insights and Rewards (SHARED - identical in front-end and back-end)

Helps customers understand and improve their money habits (automatic categories, monthly summaries, budgets with alerts) and rewards healthy app use with small, budgeted rewards and referral bonuses. Referral rewards are paid only after the new user completes a first real transaction. Rewards are cost-controlled by a platform budget. Analytics and personalisation use only consented data.

## Decisions applied
D-026 (insights and rewards chosen) and the go-to-market decision on referral rewards paid after a first real transaction. Rewards are configuration with budget caps; no interest is paid.

## Roles
| Role | Description |
|---|---|
| Customer | Sees own insights, budgets and rewards. |
| Product/Marketing admin | Configures campaigns and budgets. |
| Risk analyst | Reviews referral and reward abuse. |
| Finance | Controls reward budget and accounting. |

## Insights
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| INS-CAT-001 | Automatic categorisation of transactions (food, transport, bills, airtime, transfers, savings, etc.) with user correction. | P0 | Both |
| INS-CAT-002 | Monthly summary: income, spend, top categories, comparison with last month. | P0 | Both |
| INS-CAT-003 | Spending by category and merchant with drill-down and search. | P1 | Both |
| INS-CAT-004 | Gentle tips and nudges (for example start a goal) that are never pushy and can be turned off. | P1 | Both |

## Budgets
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| INS-BUD-001 | Create monthly budgets by category with progress. | P0 | Both |
| INS-BUD-002 | Alerts at 80% and 100% of a budget; configurable. | P0 | Both |
| INS-BUD-003 | Optional link to Target Savings: suggest saving the unspent amount (customer decides). | P2 | Both |

## Rewards
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| INS-RWD-001 | Reward campaigns: for example cashback on bill payments, streak rewards for using auto-save, milestone rewards. | P0 | Both |
| INS-RWD-002 | Reward rules engine: eligibility, amount or percent, caps per user and per campaign, validity period. | P0 | BE |
| INS-RWD-003 | Rewards credited to the customer's main account (or a rewards balance) with clear terms and expiry. | P0 | Both |
| INS-RWD-004 | Global reward budget with alerts; campaigns pause automatically when exhausted. | P0 | BE |
| INS-RWD-005 | No interest and no financial-product claims in reward messaging; terms shown in plain words. | P0 | FE |

## Referrals
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| INS-REF-001 | Each customer has a referral code and link; referred user enters it at sign-up. | P0 | Both |
| INS-REF-002 | Referral reward is paid to the referrer (and optionally the new user) only after the new user completes a first real transaction (minimum amount [OPEN]). | P0 | BE |
| INS-REF-003 | Fraud controls: device, phone and BVN duplicate checks, caps per referrer, delay window. | P0 | BE |

## Privacy
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| INS-PRV-001 | Analytics and personalised insights require consent; customers can withdraw anytime. | P0 | Both |
| INS-PRV-002 | Insights computed from the customer's own transactions only; no sharing with third parties. | P0 | BE |

## Non-goals / later
- Merchant-funded offers
- Spending forecasts
- Savings recommendations by machine learning

## Open items
- Reward values and budgets
- Minimum qualifying first transaction
- Reward form: cash vs points
- Whether rewards are taxable or reportable (lawyer)
