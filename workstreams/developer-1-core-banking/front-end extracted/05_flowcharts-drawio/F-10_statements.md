# F-10 Statements

Request a statement.

Requirements: CB-ACC-005, CB-SET-004

## Steps and branches

- **[a] START:** More > Statements -> [b]
- **[b] INPUT/OUTPUT:** Select date range -> [c]
- **[c] STEP:** Request generation -> [d]
- **[d] DECISION:** Range OK? -> if no: [e]; if yes: [f]
- **[e] ERROR:** Ask to shorten range -> [b]
- **[f] STEP:** Generate PDF in background -> [g]
- **[g] STEP:** Download or email to user -> [h]
- **[h] END:** Done
