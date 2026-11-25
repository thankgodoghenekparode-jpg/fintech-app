# PAS-F01 Vendor Onboarding

Open a store.

Requirements: PAS-VEN-001..003

## Steps and branches

- **[a] START:** Business owner taps Open a store -> [b]
- **[b] INPUT/OUTPUT:** Business details, owner ID, settlement account -> [c]
- **[c] STEP:** Create vendor tenant; dedicated account RESTRICTED -> [d]
- **[d] STEP:** Verification review -> [e]
- **[e] DECISION:** Verified? -> if no: [f]; if yes: [g]
- **[f] ERROR:** Rejected with reason; resubmit -> [b]
- **[g] STEP:** Activate store; Verified Vendor badge -> [h]
- **[h] INPUT/OUTPUT:** Add products, prices, plan options -> [i]
- **[i] END:** Store live
