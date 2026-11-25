# F-01 Onboarding and KYC

New user sign-up through account creation.

Requirements: CB-ONB-001..012

## Steps and branches

- **[a] START:** Open app -> [b]
- **[b] STEP:** Welcome screen -> [c]
- **[c] INPUT/OUTPUT:** Enter phone number -> [d]
- **[d] STEP:** Send OTP -> [e]
- **[e] DECISION:** OTP correct? -> if no: [e1]; if yes: [f]
- **[e1] ERROR:** Show error; retry or lock after limit -> if retry: [d]
- **[f] INPUT/OUTPUT:** Enter name, DOB, email -> [g]
- **[g] STEP:** Accept terms and privacy (versioned) -> [h]
- **[h] INPUT/OUTPUT:** Enter BVN -> [i]
- **[i] DECISION:** BVN valid and matches? -> if no: [i1]; if yes: [j]
- **[i1] ERROR:** Explain mismatch; allow edit -> if edit: [h]
- **[j] INPUT/OUTPUT:** Enter NIN -> [k]
- **[k] DECISION:** NIN valid and matches? -> if no: [k1]; if yes: [l]
- **[k1] ERROR:** Explain mismatch; allow edit -> if edit: [j]
- **[l] STEP:** Selfie with liveness check -> [m]
- **[m] DECISION:** Liveness and face match OK? -> if no: [m1]; if yes: [n]
- **[m1] ERROR:** Retry (max 3) then manual review -> if retry: [l]
- **[n] STEP:** Create passcode -> [o]
- **[o] STEP:** Create transaction PIN -> [p]
- **[p] STEP:** Enable biometrics (optional) -> [q]
- **[q] STEP:** Create account via foundation bank; assign tier -> [r]
- **[r] DECISION:** Account created? -> if no: [r1]; if yes: [s]
- **[r1] ERROR:** Show setting-up state; retry in background -> if retry: [q]
- **[s] END:** Account ready - go to Home
