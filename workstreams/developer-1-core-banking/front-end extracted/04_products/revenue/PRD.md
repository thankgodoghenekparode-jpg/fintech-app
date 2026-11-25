# PRD - Revenue (SHARED - identical in front-end and back-end)

A collections product for organisations that charge dues, levies and fees: communities, estates, markets, associations, schools and religious bodies (government collectors in later phases). Each collector is a multi-tenant organisation with a dedicated Zenith-backed account. Payers may optionally be app users and pay in the app; others pay through payer-specific virtual accounts, USSD, links, card or cash recorded by field collectors. Fees are the collector's choice (default: collector pays; in-app payments free for payers).

## Decisions applied
D-024. Phases: community/organisation revenue first; paying government bills through existing platforms second; government agencies as collectors third (after licensing and approvals). Safety: collector verification and abuse reporting to avoid illegitimate levies.

## Roles
| Role | Description |
|---|---|
| Collector Owner | Owns the organisation tenant. |
| Treasurer | Manages items, billing and reconciliation. |
| Field Collector | Collects dues in person and records cash. |
| Auditor | Read-only access to records. |
| Payer | Person who owes a due; may or may not be an app user. |
| Platform staff | Verify collectors, handle abuse reports, support. |

## Collectors and verification
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| REV-COL-001 | Create a collector organisation with type, name, purpose and authority/registration documents; dedicated account provisioned and RESTRICTED until verified. | P0 | Both |
| REV-COL-002 | Staff verify collectors (registration or authority letter) before payers can be billed; Verified badge shown to payers. | P0 | Both |
| REV-COL-003 | Roles: owner, treasurer, field collector, auditor with permissions. | P0 | Both |
| REV-COL-004 | Suspension and takedown for abusive or illegitimate collectors. | P0 | BE |

## Revenue items and billing
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| REV-ITM-001 | Create revenue items: one-off or recurring (daily to yearly), fixed amount or category-based (for example shop size), due dates, discounts, late fees. | P0 | Both |
| REV-ITM-002 | Payer registry: add manually, import spreadsheet, invite by link; categories and groups. | P0 | Both |
| REV-ITM-003 | Generate bills/invoices for payers automatically by schedule. | P0 | BE |
| REV-ITM-004 | Reminders by SMS, WhatsApp link and push; configurable cadence. | P1 | Both |

## Payment channels
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| REV-PAY-001 | App-user payers see Dues & Levies and pay in one tap from their main account; auto-pay with consent. | P0 | Both |
| REV-PAY-002 | Payer-specific virtual account numbers for bank transfer with automatic reconciliation. | P0 | BE |
| REV-PAY-003 | Payment link and USSD for non-app users; card payment. | P1 | Both |
| REV-PAY-004 | Field collectors record cash payments and issue receipts; cash is tracked as off-platform until deposited. | P0 | Both |
| REV-PAY-005 | Receipts for every payment (app or SMS/link). | P0 | Both |
| REV-PAY-006 | Partial payments and overpayments handled by rule. | P1 | BE |
| REV-PAY-007 | Optional linking of a payer record to an app account only with the payer's acceptance. | P0 | Both |
| REV-PAY-008 | Pay on behalf of another payer. | P2 | Both |

## Reconciliation, settlement, reports
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| REV-REC-001 | Automatic matching of inbound payments to bills; exceptions queue. | P0 | BE |
| REV-REC-002 | Settlement to the collector account instantly or on schedule, less commission. | P0 | BE |
| REV-REC-003 | Collected vs outstanding, defaulters list, per item and per category reports with export. | P0 | Both |
| REV-REC-004 | Audit trail and statements for auditors. | P0 | Both |

## Fees and safety
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| REV-FEE-001 | Fee model per collector: collector pays (default), payer pays, or split; fees shown to the payer before paying; in-app payments free for payers by default. | P0 | Both |
| REV-FEE-002 | Flat or capped fees preferred; free or reduced tier for small organisations [OPEN pricing]. | P1 | BE |
| REV-SAF-001 | 'This isn't mine' dispute button for payers; collectors see disputes. | P0 | Both |
| REV-SAF-002 | Report abuse button; staff can suspend a collector. | P0 | Both |
| REV-SAF-003 | Payer data privacy: collectors only see their own payers and bills. | P0 | BE |

## Government phases
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| REV-GOV-001 | Phase 2: 'Pay government bills' using existing licensed platforms through integration (no collection by us). | P2 | Both |
| REV-GOV-002 | Phase 3: government agencies as collectors only after licensing, contracts and approvals. | P2 | Both |

## Non-goals / later
- Government collectors (Phase 3)
- Payroll deduction collection
- Marketplace-style event ticketing

## Open items
- Commission and fee numbers
- Free tier rules
- Virtual account volume and cost with Zenith
- Legal basis for different collector types (lawyer)
- Cash remittance tracking rules
