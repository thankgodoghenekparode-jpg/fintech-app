# INS-F04 Referral Reward

Pay only after first real transaction.

Requirements: INS-REF-001..003

## Steps and branches

- **[a] START:** New user signs up with referral code -> [b]
- **[b] STEP:** Link referrer and referee; run duplicate checks -> [c]
- **[c] DECISION:** Referee completes first real transaction? -> if not yet: [d]; if yes: [e]
- **[d] STEP:** Wait; expire after window -> [c]
- **[e] STEP:** Risk checks and caps -> [f]
- **[f] DECISION:** Passes? -> if no: [g]; if yes: [h]
- **[g] STEP:** Flag for review -> [i]
- **[h] STEP:** Credit referral rewards -> [i]
- **[i] END:** Notify both
