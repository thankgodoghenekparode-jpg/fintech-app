# Legal and Consent Screens

Documents shown in the app (final text supplied by Zenith and the lawyer; templates in `back-end/16_legal-templates/` in Stage 3):
| Document | Where shown | Consent type |
|---|---|---|
| Terms and Conditions | Onboarding S-CB-005; More > Legal | Required, versioned |
| Privacy Notice (Nigeria Data Protection Act) | Onboarding; More > Legal | Required acknowledgement |
| Data Use and Marketing Consent | Onboarding (optional boxes); consent management | Optional, revocable |
| Fee Schedule | More > Legal; shown before fee-bearing actions | Informational |
| Card Terms | Create card flow | Required |
| Product-specific terms | Each product's setup (loan, cooperative, ajo, escrow, Pay Am Small, revenue) | Required, versioned (Stage 2) |
| Guarantor Agreement | Cooperative loan guarantor acceptance | Required, signed in-app (Stage 2) |

## Behaviour
1. Consent records store document version, timestamp, device and user ID.
2. When a document version changes, prompt re-acceptance at next login for required documents.
3. Show a plain-language summary above each long document, with the full text one tap away.
4. Withdrawing optional consent is one tap in More > Legal.

## Product documents (Stage 2/3)
Templates for lawyers are in `back-end/16_legal-templates/`. Each product setup screen links its terms: Loan Agreement (S-LOAN-005), Cooperative Terms and Guarantor Agreement (S-COOP-011), Ajo Terms (S-AJO-004), Pay Am Small Terms (S-PAS-004), Escrow Terms (S-ESC-005), Collector linking notice (S-REV-003), Agent Agreement (S-AGT-007), Merchant Agreement (S-MER-002), Target Savings Terms (S-TGT-002), Rewards Terms (S-INS-007).
