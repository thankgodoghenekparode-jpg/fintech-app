# COOP-F01 Create Cooperative

Customer creates a cooperative and brings it live.

Requirements: COOP-SET-001..005

## Steps and branches

- **[a] START:** Customer taps Create cooperative -> [b]
- **[b] INPUT/OUTPUT:** Enter name, type, description, meeting schedule -> [c]
- **[c] DECISION:** Registered cooperative? -> if yes: [d]; if no: [e]
- **[d] INPUT/OUTPUT:** Upload certificate and bye-laws -> [f]
- **[e] INPUT/OUTPUT:** Add officer identity details (informal) -> [f]
- **[f] STEP:** Create tenant; provision dedicated account (RESTRICTED) -> [g]
- **[g] STEP:** Invite 1-2 more principal admins -> [h]
- **[h] DECISION:** Min admins accepted and KYC passed? -> if no: [i]; if yes: [j]
- **[i] STEP:** Waiting: reminders to admins -> [h]
- **[j] STEP:** Staff verification of documents / trust level set -> [k]
- **[k] DECISION:** Verified? -> if no: [l]; if yes: [m]
- **[l] ERROR:** Rejected with reason; fix and resubmit -> if resubmit: [j]
- **[m] STEP:** Activate: set rules and plans; account active -> [n]
- **[n] END:** Cooperative live; invite members
