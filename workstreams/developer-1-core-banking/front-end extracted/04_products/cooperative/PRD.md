# PRD - Cooperative (SHARED - identical in front-end and back-end)

A multi-tenant cooperative (thrift and credit society, association, women's group and similar). Members save regularly, hold share capital, and borrow from the cooperative with guarantors. Admins run the cooperative; the platform provides a dedicated Zenith-backed account, savings, accurate bookkeeping and money movement, and earns a commission. This is NOT ajo/esusu (rotating savings), which is a separate product sharing the same group engine.

## Decisions applied
D-010 to D-015, D-017, D-018, D-019 (see DECISIONS_LOG). Proposed defaults P-001 to P-003 apply (restricted account until verification, minimum verified members, dual approval and cooling-off on large withdrawals).

## Roles
| Role | Description |
|---|---|
| Principal Admin | 2-3 people who run the cooperative; full rights; approve rule changes, large withdrawals and admin succession. |
| Admin (custom roles) | Assigned by principal admins, for example Treasurer, Secretary, Loans Officer. Permission sets are configurable. |
| Member | Verified app user approved into the cooperative. |
| Guarantor | A member who accepts to guarantee another member's loan; savings locked proportionally. |
| Applicant | Customer who has requested to join. |
| Platform staff | Verify documents, change trust level, freeze, view audit (back office). |

## Setup and tenancy
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| COOP-SET-001 | Any verified customer can create a cooperative: name, type (registered or informal), description, meeting schedule. | P0 | Both |
| COOP-SET-002 | Creation provisions a dedicated Zenith-backed account for the cooperative; it stays RESTRICTED until verification passes [PROPOSED]. [CONFIRM WITH ZENITH] | P0 | BE |
| COOP-SET-003 | Registered cooperatives upload registration certificate and bye-laws; staff verify and set trust level VERIFIED. Informal ones use the graduated trust model (STARTER, ESTABLISHED, VERIFIED). | P0 | Both |
| COOP-SET-004 | 2-3 principal admins required; creator is the first; others are invited and must accept; minimum 2 verified principal admins before the cooperative goes live [PROPOSED]. | P0 | Both |
| COOP-SET-005 | Principal admins can assign additional admin roles with permission sets. | P0 | Both |
| COOP-SET-006 | Cooperative rule sets (contributions, loans, shares, penalties) are versioned; changes apply only to future items and need member notice. | P0 | Both |
| COOP-SET-007 | Rule changes require approval of at least two principal admins and a notice period before effect [PROPOSED]. | P1 | Both |
| COOP-SET-008 | Admin succession: a departing admin is replaced by an appointed admin with the full admin management role; requires identity verification and approval by remaining principal admins or a member vote [PROPOSED]. | P0 | Both |
| COOP-SET-009 | Dissolution: members refunded savings and shares; unpaid loans and guarantors handled per rule; cooperative account closed after settlement. | P1 | Both |

## Membership
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| COOP-MEM-001 | Customer joins via invite code or link and submits a join request. | P0 | Both |
| COOP-MEM-002 | Admins approve or reject with reason; applicant is notified. | P0 | Both |
| COOP-MEM-003 | Member record: member number, join date, status, roles. | P0 | Both |
| COOP-MEM-004 | Member can request to leave; settlement of savings and shares after loan and guarantee checks. | P1 | Both |
| COOP-MEM-005 | Admin can suspend or remove a member with reason; blocked while the member has loans or active guarantees unless handled. | P1 | Both |
| COOP-MEM-006 | Bulk invitations by link or CSV. | P2 | Both |

## Contributions and savings
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| COOP-CON-001 | Admins define contribution plans: daily, weekly, monthly or yearly; fixed amount or by member category; start date; multiple plans allowed (for example dues, welfare). | P0 | Both |
| COOP-CON-002 | Member pays manually (any amount, any time) or enables auto-deduction from their main account with consent. | P0 | Both |
| COOP-CON-003 | Auto-deduction on due date with retry rules, reminders and grace period; missed contributions flagged; penalty per rule. | P0 | Both |
| COOP-CON-004 | Contributions post to the cooperative account and to the member's savings sub-ledger. | P0 | BE |
| COOP-CON-005 | Member statement: contributions, savings, shares, loans, guarantees. | P0 | Both |
| COOP-CON-006 | Admin view of arrears and compliance per member and per plan. | P0 | Both |

## Share capital
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| COOP-SHR-001 | Admins define share units, price, minimum and maximum shares per member. | P0 | Both |
| COOP-SHR-002 | Shares allocated or purchased per rule (for example from contributions); in-app certificate. | P0 | Both |
| COOP-SHR-003 | Period-end dividend or interest declaration by admins with approval; posted to members. | P1 | Both |
| COOP-SHR-004 | Per-member share limit configurable; regulatory maximum to be applied. [CONFIRM WITH LAWYER] | P1 | BE |

## Loans and guarantors
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| COOP-LON-001 | Eligibility: after an admin-defined waiting period, no arrears, savings threshold per rule. | P0 | Both |
| COOP-LON-002 | Member requests a loan: amount, purpose, tenor; sees eligibility and rule limits before submitting. | P0 | Both |
| COOP-LON-003 | Requires 3 guarantors whose combined savings are at least 2x or 3x the loan amount (multiplier set by admins). | P0 | Both |
| COOP-LON-004 | Each guarantor receives an in-app request and accepts with PIN through an in-app agreement, or declines. | P0 | Both |
| COOP-LON-005 | Admin approval workflow with dual approval and reasons. | P0 | Both |
| COOP-LON-006 | On disbursement, each guarantor's savings are locked (hold) in proportion until the loan is repaid. | P0 | BE |
| COOP-LON-007 | Disbursement from the cooperative account to the borrower's main account. | P0 | BE |
| COOP-LON-008 | Repayment schedule per rule; manual or automatic repayment; early repayment allowed. | P0 | Both |
| COOP-LON-009 | Default handling: reminders, arrears status, recovery from guarantors' locked savings per rule after prior notice. | P0 | Both |
| COOP-LON-010 | Holds released automatically on full repayment. | P0 | BE |
| COOP-LON-011 | Interest and fees per cooperative rule, computed by the schedule engine. | P0 | BE |
| COOP-LON-012 | Loan top-up or restructuring with admin approval. | P2 | Both |

## Books, dashboard and reports
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| COOP-BOK-001 | Dashboard: pool balance split into member savings, share capital, loans out, guarantor-locked amounts, income; contributions due and received; loan requests; arrears. | P0 | Both |
| COOP-BOK-002 | Double-entry cooperative books with trial balance and export. | P0 | BE |
| COOP-BOK-003 | Withdrawals from the cooperative account need dual admin approval; cooling-off notice for large amounts [PROPOSED]; destinations limited to verified accounts. | P0 | Both |
| COOP-BOK-004 | Period and annual reports, member statements, AGM pack. | P1 | Both |
| COOP-BOK-005 | Audit trail of admin actions (members see a summary; platform sees full detail). | P0 | Both |

## Social hub
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| COOP-SOC-001 | Announcements to members. | P1 | Both |
| COOP-SOC-002 | Meeting scheduling, attendance and minutes. | P1 | Both |
| COOP-SOC-003 | Polls and votes (elections, rule changes). | P2 | Both |
| COOP-SOC-004 | Limited member directory. | P2 | Both |

## Platform
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| COOP-PLT-001 | Platform commission configuration per cooperative (mix: percent per contribution, loan fee, subscription). | P0 | BE |
| COOP-PLT-002 | Members can report a concern; staff can freeze the cooperative account; unusual activity flags. | P0 | Both |
| COOP-PLT-003 | Back-office tenant view: verify documents, set trust level, freeze, audit. | P0 | Both |

## Non-goals / later
- Interest-bearing savings, investment products (not planned)
- Inter-cooperative transfers
- Cooperative-owned physical cards

## Open items
- O-001..O-004 relevant: commission numbers, limits, dedicated account volume and cost with Zenith
- Regulatory maximum per-member share limit and cooperative law specifics (lawyer)
- Guarantor agreement text and enforceability of savings lock/deduction (lawyer)
- Cooling-off hours and large-withdrawal threshold values
- Minimum verified members before go-live (default 5)
