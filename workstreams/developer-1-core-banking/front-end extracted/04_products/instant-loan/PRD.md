# PRD - Instant Loan (SHARED - identical in front-end and back-end)

Small, fast, transparent loans disbursed to the customer's main account. Run by the owner's company together with a licensed lending partner (funding and/or lending licence), registered under the FCCPC digital lending framework. Loan sizes, pricing and eligibility are configuration (OPEN). It is independent of Pay Am Small and of cooperative loans. It sits under the Save & Borrow tab.

## Decisions applied
D-009, D-019. Open items O-001 (sizes, tenors, pricing, eligibility, partner split) and O-007 (lawyer review). Safety features from the plan: lender identity shown, one-screen cost summary, affordability check, small starting limits that grow with on-time repayment, privacy promise (no contacts or photos), respectful collections, hardship option, complaint route, early repayment without penalty if economics allow.

## Roles
| Role | Description |
|---|---|
| Borrower | Verified customer with an eligible limit. |
| Credit analyst | Reviews referred applications, tunes scorecards. |
| Collections officer | Handles arrears with respectful, rule-bound contact. |
| Compliance officer | Registration, disclosures, complaints, reporting. |
| Lending partner | External funder/lender; receives settlements and reports. |

## Eligibility and offers
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| LOAN-ELG-001 | Show eligibility and limit based on verified identity, account history and optional credit bureau data; explain how limits grow. | P0 | Both |
| LOAN-ELG-002 | Start with small limits; increase with on-time repayment per configurable ladder. | P0 | BE |
| LOAN-ELG-003 | Product catalogue (amount range, tenor options, fee and interest model) is configuration with versioning and dual-control changes. [OPEN] | P0 | BE |
| LOAN-ELG-004 | Decision engine: rules plus scorecard; outcomes APPROVE, DECLINE with reason code, REFER to analyst. | P0 | BE |
| LOAN-ELG-005 | Blocklist and exposure caps: no new loan if arrears, one active loan at a time (configurable). | P0 | BE |

## Application and disclosure
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| LOAN-APP-001 | Customer chooses amount and tenor; sees one-screen cost summary: interest, fees, total repayment, due dates, effective cost. | P0 | Both |
| LOAN-APP-002 | Affordability check shown before acceptance (repayment vs typical inflows). | P0 | Both |
| LOAN-APP-003 | Display lender identity (company and partner) and registration status inside the app. | P0 | Both |
| LOAN-APP-004 | Loan agreement accepted in-app (versioned, timestamped, PIN) with key facts summary. | P0 | Both |
| LOAN-APP-005 | Privacy promise screen: data used, no access to contacts or photos. | P0 | FE |
| LOAN-APP-006 | No unsolicited loan marketing; offers appear only inside the Borrow area or after opt-in. | P0 | Both |

## Disbursement and servicing
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| LOAN-DIS-001 | Instant disbursement to the main account after acceptance. | P0 | BE |
| LOAN-DIS-002 | Repayment schedule generated and stored at disbursement; shown in app. | P0 | Both |
| LOAN-REP-001 | Repay manually (full or partial, any time) or by auto-repay with consent. | P0 | Both |
| LOAN-REP-002 | Early repayment without penalty [PROPOSED]; interest recalculated per product rule. | P1 | Both |
| LOAN-REP-003 | Reminders before due date by push and SMS; clear receipts. | P0 | Both |
| LOAN-REP-004 | Limit increase offered after successful repayment. | P1 | Both |

## Arrears, hardship and collections
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| LOAN-ARR-001 | Arrears states and late fees per product rule, capped and disclosed. | P0 | BE |
| LOAN-ARR-002 | Hardship request: customer can ask for more time or restructuring; handled by a person. | P0 | Both |
| LOAN-ARR-003 | Collections conduct rules: approved channels and hours, no harassment, no third-party contact, no shaming. | P0 | BE |
| LOAN-ARR-004 | Complaint route and dispute button on every loan screen. | P0 | Both |

## Partner and finance
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| LOAN-PRT-001 | Funding model configurable: company-funded, partner-funded, or split; revenue split configuration. | P0 | BE |
| LOAN-PRT-002 | Periodic settlement and reporting to the partner with reconciliation. | P0 | BE |
| LOAN-PRT-003 | Portfolio reporting: disbursed, outstanding, PAR buckets, write-offs, yield. | P0 | BE |
| LOAN-CMP-001 | Registration status, required disclosures and records retained for regulatory inspection (see compliance docs). | P0 | BE |

## Non-goals / later
- Credit-bureau reporting of repayment behaviour
- Salary-linked advances
- Larger tickets

## Open items
- Loan sizes, tenors, interest and fee model, partner split (O-001)
- Whether credit bureau data is used from day one
- Early-repayment economics
- Lender entity and registration path (O-007, O-009)
