# TGT-F03 Withdrawal (Flexible, Locked, Early)

Release funds with friction and penalty.

Requirements: TGT-LCK-001..002

## Steps and branches

- **[a] START:** Tap Withdraw -> [b]
- **[b] DECISION:** Mode and date -> if flexible: [c]; if locked early: [d]; if locked mature: [e]
- **[c] STEP:** Flexible: show any fee and net amount -> [h]
- **[d] STEP:** Locked and before date: show penalty and net amount; suggest alternatives (keep saving) -> [f]
- **[e] STEP:** Locked and at maturity: no penalty -> [h]
- **[h] STEP:** Confirm with PIN -> [i]
- **[f] DECISION:** Early withdrawal cooling-off enabled? -> if yes: [g]; if no: [h]
- **[i] STEP:** Release pocket to main account; post penalty if any -> [j]
- **[g] STEP:** Wait period; reminder to reconsider -> [h]
- **[j] END:** Goal updated or closed
