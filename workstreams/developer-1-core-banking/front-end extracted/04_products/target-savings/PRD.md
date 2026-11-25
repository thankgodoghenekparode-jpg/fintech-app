# PRD - Target Savings (SHARED - identical in front-end and back-end)

Personal goal-based saving. The customer creates a named goal with a target amount and a deadline or schedule, funds it manually or automatically, and withdraws at maturity or earlier with clear rules. It is a pure saving-discipline tool in v1: no interest. Each goal is a pocket (ledger sub-balance) inside the customer's Zenith-backed account, not a separate bank account.

## Decisions applied
D-025 (no interest in v1), P-007 (goal = ledger pocket). Early-withdrawal penalty and extension rules are [OPEN] and must be configuration.

## Roles
| Role | Description |
|---|---|
| Customer | Owner of the goals; each customer manages only their own goals. |
| Platform staff | View goals for support (masked), adjust configuration. |

## Goals
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| TGT-GOL-001 | Create a goal: name, target amount, deadline or contribution schedule, theme/icon. | P0 | Both |
| TGT-GOL-002 | App computes the required contribution from target and deadline (and the date from target and contribution). | P0 | Both |
| TGT-GOL-003 | Edit goal name, theme and target; changing a locked goal's date follows the extension rule [OPEN]. | P1 | Both |
| TGT-GOL-004 | Pause or close a goal; closing returns funds to the main account (penalty rules may apply). | P0 | Both |
| TGT-GOL-005 | Maximum number of active goals per customer is configurable. | P1 | BE |

## Funding
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| TGT-FUN-001 | Manual top-up of any amount at any time from the main account. | P0 | Both |
| TGT-FUN-002 | Auto-save schedule (daily, weekly, monthly) with consent; retries and reminders when funds are short. | P0 | Both |
| TGT-FUN-003 | Optional rule: save a percentage of every incoming credit to a goal. | P1 | Both |
| TGT-FUN-004 | Round-up savings from card spending. | P2 | Both |

## Lock modes and withdrawal
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| TGT-LCK-001 | Two modes: FLEXIBLE (withdraw anytime, optional fee) and LOCKED (until the target date, penalty for early withdrawal). Mode and penalty are shown during setup. | P0 | Both |
| TGT-LCK-002 | Early withdrawal requires a confirmation screen showing penalty and net amount, then PIN; optional short cooling-off [PROPOSED]. | P0 | Both |
| TGT-LCK-003 | At maturity (date reached or target met) funds are released to the main account automatically or rolled into a new goal by choice. | P0 | Both |
| TGT-LCK-004 | Penalty amounts and extension rules are configuration. [OPEN] | P0 | BE |

## Experience
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| TGT-UX-001 | Progress ring/bar, remaining amount and days, and milestone moments at 25, 50, 75 and 100 percent. | P0 | FE |
| TGT-UX-002 | What-if calculator: change contribution or date to see the outcome. | P1 | FE |
| TGT-UX-003 | Reminders and gentle nudges (configurable, never pushy). | P1 | Both |
| TGT-UX-004 | Statements and history per goal. | P1 | Both |

## Platform
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| TGT-PLT-001 | Goal balances are ledger pockets under the main account; held amounts reduce available balance. | P0 | BE |
| TGT-PLT-002 | No interest in v1; design allows adding it later without restructuring. | P0 | BE |

## Non-goals / later
- Interest-bearing goals
- Shared or family goals
- Round-up from card spend (P2)

## Open items
- Early-withdrawal penalty values
- Whether locked goals can be extended and how many times
- Cooling-off hours before early withdrawal
- Maximum goals per customer
