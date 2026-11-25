# COOP-F04 Loan Request to Disbursement

Eligibility, guarantors, approval, hold and payout.

Requirements: COOP-LON-001..007

## Steps and branches

- **[a] START:** Member opens Loans -> [b]
- **[b] DECISION:** Eligible (waiting period, no arrears, savings)? -> if no: [c]; if yes: [d]
- **[c] ERROR:** Show reasons and when eligible -> [a]
- **[d] INPUT/OUTPUT:** Enter amount, purpose, tenor; see schedule and cost -> [e]
- **[e] INPUT/OUTPUT:** Choose 3 guarantors -> [f]
- **[f] STEP:** Guarantors notified -> [g]
- **[g] DECISION:** All 3 accept and total savings >= multiplier x loan? -> if no: [h]; if yes: [i]
- **[h] ERROR:** Declined/expired/insufficient: add or replace guarantor -> if fix: [e]
- **[i] STEP:** Admin review queue (dual approval) -> [j]
- **[j] DECISION:** Approved? -> if no: [k]; if yes: [l]
- **[k] ERROR:** Rejected with reason; notify all
- **[l] STEP:** Lock guarantors' savings (holds) -> [m]
- **[m] STEP:** Disburse from cooperative account to member account -> [n]
- **[n] STEP:** Create repayment schedule; notify -> [o]
- **[o] END:** Loan active
