# LOAN-F01 Apply to Disbursement

Eligibility, offer, acceptance and payout.

Requirements: LOAN-ELG-001..004, LOAN-APP-001..004, LOAN-DIS-001

## Steps and branches

- **[a] START:** Save & Borrow > Borrow -> [b]
- **[b] STEP:** Show lender identity and eligibility/limit -> [c]
- **[c] DECISION:** Eligible? -> if no: [d]; if yes: [e]
- **[d] ERROR:** Explain reasons and how to improve
- **[e] INPUT/OUTPUT:** Choose amount and tenor -> [f]
- **[f] STEP:** Cost summary and affordability check -> [g]
- **[g] STEP:** Decision engine -> [h]
- **[h] DECISION:** Outcome -> if approve: [k]; if refer: [i]; if decline: [j]
- **[k] STEP:** Show agreement and key facts; accept with PIN -> [l]
- **[i] STEP:** Referred: analyst review -> if approved: [k]; if declined: [j]
- **[j] ERROR:** Declined with reason code and message
- **[l] STEP:** Disburse to main account; create schedule -> [m]
- **[m] END:** Loan active
