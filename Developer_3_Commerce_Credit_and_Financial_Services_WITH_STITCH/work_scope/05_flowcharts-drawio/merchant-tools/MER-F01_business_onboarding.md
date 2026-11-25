# MER-F01 Business Onboarding (KYB)

Open a business account.

Requirements: MER-ACC-001..003

## Steps and branches

- **[a] START:** Owner taps Create business -> [b]
- **[b] INPUT/OUTPUT:** Business name, type, registration, owner ID, settlement bank -> [c]
- **[c] STEP:** Create tenant; dedicated account RESTRICTED -> [d]
- **[d] STEP:** Verification review -> [e]
- **[e] DECISION:** Verified? -> if no: [f]; if yes: [g]
- **[f] ERROR:** Rejected with reason; resubmit -> [b]
- **[g] STEP:** Activate; add team -> [h]
- **[h] END:** Ready to collect
