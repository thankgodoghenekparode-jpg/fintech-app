# PRD - Merchant and Small-Business Tools (SHARED - identical in front-end and back-end)

Tools for small businesses to get paid and keep records: a business account (verified business with a dedicated Zenith-backed account), payment links, QR collection (static and dynamic), simple invoicing, team roles, refunds and basic reports. It reuses the platform's business verification service and tenancy; Pay Am Small vendors may use the same business verification but remain a separate product.

## Decisions applied
D-026 (merchant tools chosen as an addition). Independent product module; shares the foundation business-verification capability with Pay Am Small vendors and Revenue collectors.

## Roles
| Role | Description |
|---|---|
| Business Owner | Owns the business tenant. |
| Manager | Manages team, links, invoices, refunds. |
| Cashier | Collects payments via QR/links. |
| Accountant | Read-only financial records and exports. |
| Customer (payer) | Pays a link, QR or invoice; may or may not be an app user. |

## Business account
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| MER-ACC-001 | Create a business: name, type, registration (CAC or equivalent), owner ID; staff verification; dedicated account RESTRICTED until verified. [CONFIRM WITH ZENITH] | P0 | Both |
| MER-ACC-002 | Team members and roles with permissions; owner can add and remove. | P0 | Both |
| MER-ACC-003 | Settlement: balance in business account; payout to a verified bank account or the owner's main account on request or schedule. | P0 | Both |
| MER-ACC-004 | Business profile and public payment page (name, verified badge). | P1 | Both |

## Collecting payments
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| MER-PAY-001 | Payment links: fixed or open amount, description, expiry, single or multi-use; shareable by WhatsApp/SMS. | P0 | Both |
| MER-PAY-002 | Static QR (business) and dynamic QR (amount) following the national QR standard. | P0 | Both |
| MER-PAY-003 | Payers can pay from the app, by bank transfer to a link-specific account, or card (P1) without an account. | P0 | Both |
| MER-PAY-004 | Instant payment notifications and receipts to both sides. | P0 | Both |
| MER-PAY-005 | Cashier mode: simple screen to show QR/amount and see paid status. | P0 | Mobile |

## Invoicing
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| MER-INV-001 | Create invoices with line items, taxes (VAT optional), due date, notes; send by link, SMS or email. | P0 | Both |
| MER-INV-002 | Invoice statuses: Draft, Sent, Viewed, Partially paid, Paid, Overdue, Void; reminders. | P0 | Both |
| MER-INV-003 | Customer list for repeat invoicing. | P1 | Both |
| MER-INV-004 | Recurring invoices. | P2 | Both |

## Money operations
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| MER-MON-001 | Refunds (full or partial) by authorised roles with reason; limited to funds available. | P0 | Both |
| MER-MON-002 | Fees: configurable per business; shown on every payment; fee payer chosen by the business (business pays by default). | P0 | Both |
| MER-MON-003 | Statements, daily sales summary and exports (CSV/PDF). | P0 | Both |
| MER-MON-004 | Reconciliation of transfers into link-specific accounts; unmatched queue. | P0 | BE |

## Safety
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| MER-SAF-001 | Business limits by verification level; unusual activity flags; staff can freeze. | P0 | BE |
| MER-SAF-002 | Customer 'report a problem' on payments to a business. | P1 | Both |

## Non-goals / later
- Physical POS device
- Payroll
- Inventory and stock management
- Loans for merchants

## Open items
- Fees and free tier
- Limits by verification level
- Whether CAC verification uses a provider API
- Dedicated account volume with Zenith
