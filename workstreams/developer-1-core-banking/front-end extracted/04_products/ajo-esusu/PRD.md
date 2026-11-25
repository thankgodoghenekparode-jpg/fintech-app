# PRD - Ajo / Esusu (SHARED - identical in front-end and back-end)

A multi-tenant rotating savings product. A fixed group contributes a fixed amount on a schedule and each member receives the whole pot in turn until everyone has had a turn. It is separate from the Cooperative product (no shares, no pooled loans) but shares the same group engine (tenants, members, roles, schedules, dedicated accounts, dashboards). The creator chooses the protection mode: PROTECTED (guarantor or deposit cover) or SAFEGUARDS_ONLY. The platform does not guarantee payouts.

## Decisions applied
D-016, D-017, D-018, D-019 (see DECISIONS_LOG). Proposed defaults P-001 to P-003 apply. Protection comes from members (guarantors or deposits), never from the platform's own funds.

## Roles
| Role | Description |
|---|---|
| Circle Creator / Organizer | Creates the circle; sets terms; limited powers; cannot move money alone; optional organizer fee. |
| Member | Verified app user who joined the circle and accepted its terms. |
| Cover Guarantor | A verified user who guarantees a member's remaining contributions (PROTECTED mode). |
| Platform staff | Verify, freeze, handle reports, view trust levels. |

## Circle setup
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| AJO-SET-001 | Any verified customer can create a circle: name, contribution amount, frequency (daily, weekly, monthly), number of slots, start date. | P0 | Both |
| AJO-SET-002 | Creator chooses protection mode: PROTECTED (guarantor or deposit) or SAFEGUARDS_ONLY; shown clearly to all invitees. | P0 | Both |
| AJO-SET-003 | Creation provisions a dedicated Zenith-backed account for the circle; RESTRICTED until verification and minimum verified members [PROPOSED]. [CONFIRM WITH ZENITH] | P0 | BE |
| AJO-SET-004 | Informal groups follow the graduated trust model; trust level caps pot size and member count [limits OPEN]. | P0 | Both |
| AJO-SET-005 | Terms summary and full terms shown before anyone joins; acceptance recorded (versioned). | P0 | Both |
| AJO-SET-006 | Circle can be edited only before it starts; after start order, dates and amounts are locked. | P0 | Both |
| AJO-SET-007 | Creator may cancel a circle before it starts; contributions and deposits refunded in full. | P1 | Both |

## Membership
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| AJO-MEM-001 | Members join by invite link or code; each must be a verified app user. | P0 | Both |
| AJO-MEM-002 | Circle goes live when all slots are filled (or minimum verified members reached [PROPOSED]) and everyone has accepted terms and set up auto-debit/protection as required. | P0 | Both |
| AJO-MEM-003 | Members see the full roster with trust scores, slot, and status (not private financial data). | P1 | Both |
| AJO-MEM-004 | Replacement of a defaulting member only through a defined rule (see delinquency). | P1 | Both |

## Payout order
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| AJO-ORD-001 | Order methods: random draw (shown transparently in app), members choose slots, or organizer-set with member consent. | P0 | Both |
| AJO-ORD-002 | Once the cycle starts, order and payout dates are locked. | P0 | Both |
| AJO-ORD-003 | Early slots require extra cover or a minimum trust score in PROTECTED mode [PROPOSED]. | P1 | Both |

## Contributions and payouts
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| AJO-CON-001 | Contributions auto-debited from each member's main account on each due date with consent; manual early payment allowed. | P0 | Both |
| AJO-CON-002 | Auto-debit is mandatory in SAFEGUARDS_ONLY mode and for early slots [PROPOSED]. | P0 | Both |
| AJO-CON-003 | Retry rules, reminders and a grace period for failed debits; late fee optional per circle. | P0 | Both |
| AJO-CON-004 | Each round's pot is held in the circle's dedicated account until payout day. | P0 | BE |
| AJO-CON-005 | On payout date the full pot goes automatically to that round's recipient (less any disclosed fees). | P0 | Both |
| AJO-CON-006 | If the pot is short on payout day: wait within the grace period; then apply cover (PROTECTED) or follow the circle's shortfall rule (delay or partial payout) [OPEN default: delay]. | P0 | Both |
| AJO-CON-007 | Live tracker: who paid, round status, next payout, history, receipts. | P0 | Both |

## Protection
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| AJO-PRO-001 | PROTECTED: each member provides a cover guarantor or a security deposit (amount rule set by creator within platform limits) held in the circle account. | P0 | Both |
| AJO-PRO-002 | Guarantor accepts in-app with PIN; their free savings or balance is held for the amount guaranteed. | P0 | Both |
| AJO-PRO-003 | On default, cover is invoked to complete the pot; remainder of cover released at the end or when contributions are caught up. | P0 | BE |
| AJO-PRO-004 | SAFEGUARDS_ONLY: no cover; safeguards are verified identity, trust score, auto-debit, limits for new users; risk is clearly disclosed. | P0 | Both |
| AJO-PRO-005 | Platform does not guarantee payouts; this is stated in the terms and in the app. | P0 | Both |

## Delinquency and trust
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| AJO-DEL-001 | Missed contributions flagged; reminders; late fee; after N misses (configurable) the member is DEFAULTED. | P0 | Both |
| AJO-DEL-002 | Defaulted members who already received a payout must continue contributions; recovery via cover or collection rules disclosed in terms. | P0 | BE |
| AJO-DEL-003 | Trust score per customer from completed cycles and on-time payments; affects slot eligibility and limits [formula OPEN]. | P1 | BE |

## Close and records
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| AJO-END-001 | At cycle end: summary, trust score update, option to renew with the same group. | P1 | Both |
| AJO-END-002 | Circle account closes automatically after the final payout, release of deposits/holds and reconciliation. | P0 | BE |
| AJO-END-003 | Statements and receipts for each contribution and payout. | P0 | Both |

## Platform
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| AJO-PLT-001 | Platform fee configurable: small fee per payout, per cycle, or an optional organizer fee that the platform facilitates [OPEN]. | P0 | BE |
| AJO-PLT-002 | Members can report a concern; staff can freeze the circle; unusual activity flags. | P0 | Both |

## Non-goals / later
- Guaranteed payouts funded by the platform (priced and reserved) - not in v1
- Bidding or lottery auction models
- Cross-circle transfers

## Open items
- AJO-PLT-001 fee model
- Shortfall default rule (delay vs partial payout)
- Trust score formula and limits by trust level
- Deposit and guarantor cover amounts and early-slot rules
- Zenith volume and cost of one account per circle (thousands of circles)
