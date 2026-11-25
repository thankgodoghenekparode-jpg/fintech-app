# Decision Log (SHARED - identical in front-end and back-end)

Legend: [DECIDED] confirmed by the owner. [PROPOSED] recommended default, not yet confirmed. [OPEN] unresolved. [CONFIRM WITH ZENITH] depends on the bank.

## Decided
| ID | Decision |
|---|---|
| D-001 | [DECIDED] App is a fintech front end; Zenith Bank is the licensed foundation. Zenith has approved the build. |
| D-002 | [DECIDED] No Zenith name, logo or icons. A few related colours allowed. Own unique identity. |
| D-003 | [DECIDED] UI structure is familiar and slightly close to Zenith's app, but friendly, beautiful and distinct. |
| D-004 | [DECIDED] Version 1 is naira only. Dollar accounts and cards come in version 2. |
| D-005 | [DECIDED] Pidgin / local language dropped for now. Central text layer required. |
| D-006 | [DECIDED] Five bottom tabs: Home, Payments, Cards, Save & Borrow, More. Hybrid home screen. |
| D-007 | [DECIDED] Each product is an independent module over a shared foundation. |
| D-008 | [DECIDED] Stack: Flutter, React + TypeScript (Next.js), Kotlin + Spring Boot, PostgreSQL. Modular monolith. |
| D-009 | [DECIDED] Instant Loan is run by the owner's company with a lending partner; sits under Save & Borrow. |
| D-010 | [DECIDED] Cooperative: multi-tenant; 2-3 principal admins plus other roles; admins approve or reject join requests; fintech provides savings and bookkeeping and earns a commission. |
| D-011 | [DECIDED] Cooperative contributions: daily, weekly, monthly or yearly; manual or automatic deduction. |
| D-012 | [DECIDED] Cooperative loans: admin-set waiting period; admin approval; 3 guarantors whose combined savings are 2x-3x the loan; guarantor savings locked until repaid; deducted on default. |
| D-013 | [DECIDED] Cooperative share capital set by admins; each cooperative sets its own rules, payment plans and loan plans. Rule changes apply only to future loans and need member notice. |
| D-014 | [DECIDED] Registered cooperatives must upload registration certificate and bye-laws; informal associations also allowed. |
| D-015 | [DECIDED] Cooperative exit/dissolution: refund savings and shares; handle unpaid loans and guarantors. Disputes handled by the cooperative itself. If an admin leaves, the next admin is appointed with full admin management role. |
| D-016 | [DECIDED] Ajo/Esusu is multi-tenant, separate from Cooperative. The creator chooses protected (guarantee/deposit) or safeguards-only. Shares the group engine with Cooperative. |
| D-017 | [DECIDED] Each cooperative and each ajo circle gets a dedicated account created at creation. |
| D-018 | [DECIDED] Informal groups use a graduated trust model (Starter, Established, Verified) with growing limits. |
| D-019 | [DECIDED] Transaction limits follow the standard banking tier structure; numbers decided later. |
| D-020 | [DECIDED] Pay Am Small offers both price-lock and buy-now-pay-later credit; any verified business can open a store; credit mode is vendor-funded; it is standalone and separate from Instant Loan. |
| D-021 | [DECIDED] Pay Am Small vault: one vault covers all items bought together; a new vault opens for the next purchase. Early withdrawal allowed with a penalty set at plan setup. At deadline: extension or refund minus a fee. Manual payments any amount any time. Failed auto-debits: retries, reminders, grace period. Vendor must honor the locked price. Vault only for price-lock; credit mode has a separate repayment screen. |
| D-022 | [DECIDED] Pay Am Small release flow must differ from escrow (escrow is its own product). |
| D-023 | [DECIDED] Escrow is an independent, full product covering all deal types. Fee payer chosen by the two parties; fee treatment on cancel/refund chosen from listed options at setup with a clear explanation. |
| D-024 | [DECIDED] Revenue: collectors are tenants; payers may optionally be app users and pay in-app. Fees are the collector's choice; default collector pays; in-app payments free for payers. |
| D-025 | [DECIDED] Target Savings: pure discipline tool, no interest in v1. |
| D-026 | [DECIDED] Additions: merchant tools, agent network, spending insights and rewards. |

## Proposed defaults (not yet confirmed)
| ID | Default |
|---|---|
| P-001 | [PROPOSED] New cooperative/ajo accounts are created immediately but stay restricted until admins' identity checks pass. |
| P-002 | [PROPOSED] Minimum verified members before a group account goes live (suggested 5, configurable). |
| P-003 | [PROPOSED] Two-admin approval and a 24-48 hour cooling-off notice on large group withdrawals. |
| P-004 | [PROPOSED] Pay Am Small vendors paid with a short holdback until delivery code is confirmed. |
| P-005 | [PROPOSED] Escrow keeps a small minimum charge on failed deals to cover real costs. |
| P-006 | [PROPOSED] Pay Am Small launches price-lock first, credit mode after. |
| P-007 | [PROPOSED] Each Target Savings goal is a ledger pocket, not a separate bank account. |

## Open items
| ID | Item |
|---|---|
| O-001 | [OPEN] Loan sizes, tenors, pricing, eligibility, partner revenue split. |
| O-002 | [CONFIRM WITH ZENITH] Programmatic creation of dedicated/virtual accounts at volume; cost and limits per account. |
| O-003 | [CONFIRM WITH ZENITH] Custody structure, deposit insurance coverage, identity requirements for informal groups. |
| O-004 | [CONFIRM WITH ZENITH] Account tier limits and fee schedule. |
| O-005 | [OPEN] Trademark check on the name "Pay Am Small". |
| O-006 | [OPEN] Early-withdrawal penalty rules and extension rules for Target Savings and Pay Am Small. |
| O-007 | [OPEN] Lawyer review: guarantor agreement, lending rules for member loans and credit mode, escrow custody. |
| O-008 | [OPEN] First target customer audience and brand colours. |
| O-009 | [OPEN] Whether Pay Am Small credit mode falls under digital lending registration. |
