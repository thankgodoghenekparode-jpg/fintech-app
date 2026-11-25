# PRD - Escrow (SHARED - identical in front-end and back-end)

An independent, full escrow product for any deal between two parties: online goods, services and freelance work (milestones), rent and property (with an optional agent), vehicles and other trades. One engine with deal templates. Each deal gets its own protected Zenith-backed account. The two parties decide who pays the fee and what happens to the fee on cancellation or refund, chosen at setup from listed options with a clear explanation. Disputes have a structured process with deadlines. Escrow does not depend on any other product.

## Decisions applied
D-023 (independent, all deal types, fee payer and cancel/refund fee treatment chosen by the parties at setup) and P-005 (small minimum charge on failed deals). Dispute decisions are made by trained platform staff under terms accepted by both parties.

## Roles
| Role | Description |
|---|---|
| Buyer | Funds the deal and confirms receipt. |
| Seller | Delivers goods or services. |
| Agent / Broker | Optional third party earning a disclosed commission (mainly property). |
| Dispute Officer | Reviews evidence and decides disputes. |
| Compliance / Finance | Monitors, holds, reconciles. |

## Deal creation and terms
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| ESC-DEA-001 | Either party can create a deal: type (goods, service/milestones, property/rent, vehicle, other), parties, amount, description, timeline, release conditions. | P0 | Both |
| ESC-DEA-002 | Counterparty invited by link, phone or in-app; can accept or negotiate terms; both acceptances lock the terms (snapshot). | P0 | Both |
| ESC-DEA-003 | Fee payer chosen by the parties: buyer, seller or split with percentages. | P0 | Both |
| ESC-DEA-004 | Cancellation/refund fee treatment chosen from listed options per scenario at setup, with a plain summary both must confirm. | P0 | Both |
| ESC-DEA-005 | Minimum platform charge on failed deals shown clearly [PROPOSED]. | P1 | Both |
| ESC-DEA-006 | Optional agent/broker with disclosed commission split. | P1 | Both |
| ESC-DEA-007 | Templates define default checkpoints, timers and documents for each deal type. | P0 | BE |

## Funding and holding
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| ESC-FND-001 | Each deal has a dedicated protected account generated at Zenith [CONFIRM WITH ZENITH on volume]. | P0 | BE |
| ESC-FND-002 | Buyer funds the deal by wallet or bank transfer; seller notified when funded. | P0 | Both |
| ESC-FND-003 | Funds cannot be withdrawn by anyone except through release, refund or dispute decision. | P0 | BE |

## Fulfilment and release
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| ESC-REL-001 | Goods: shipment proof, delivery code, inspection window. | P0 | Both |
| ESC-REL-002 | Services: milestones with approval windows and staged releases; revisions. | P0 | Both |
| ESC-REL-003 | Property: document checkpoints (agreement, inspection, keys, title), multiple parties, longer timers, stricter KYC. | P1 | Both |
| ESC-REL-004 | Release triggers: buyer confirmation, delivery code, milestone approval, or auto-release after the timer if the buyer is silent and seller shows proof. | P0 | Both |
| ESC-REL-005 | Auto-release timers and reminders configurable per template. | P0 | BE |

## Disputes
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| ESC-DSP-001 | Either party can open a dispute within the dispute window; funds freeze. | P0 | Both |
| ESC-DSP-002 | Structured evidence upload (photos, chats, documents, delivery proof) and a response deadline for the other party. | P0 | Both |
| ESC-DSP-003 | Decision deadline stated up front; outcomes: release, refund or split; one appeal. | P0 | Both |
| ESC-DSP-004 | Dispute fee follows the outcome or setup choice (loser pays, split, or opener pays). | P1 | Both |
| ESC-DSP-005 | Dispute officers' decisions require rationale and are audited. | P0 | BE |

## Trust, safety and records
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| ESC-TRU-001 | Both parties verified (identity tier by deal value); badges and ratings visible. | P0 | Both |
| ESC-TRU-002 | Fraud rules on deals (new accounts, high value, rapid cancellations). | P0 | BE |
| ESC-TRU-003 | In-app chat per deal with retention; shareable deal link and receipts. | P0 | Both |
| ESC-TRU-004 | Limits by KYC tier and deal type; property deals need higher tier. | P0 | BE |
| ESC-TRU-005 | Business sellers dashboard on web: many deals, exports. | P1 | Both |

## Non-goals / later
- Cross-border escrow
- AI-assisted evidence review (human decides)
- Escrow as optional add-on for Pay Am Small orders

## Open items
- Default timers per template
- Minimum charge amount (P-005)
- Dispute fee default
- Deal value limits by tier
- Custody structure confirmation with Zenith and lawyer
