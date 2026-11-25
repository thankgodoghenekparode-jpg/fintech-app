# INS-F01 Categorisation and Monthly Summary

From transactions to insights.

Requirements: INS-CAT-001..004

## Steps and branches

- **[a] START:** Transaction posted -> [b]
- **[b] STEP:** Categorise by rules and merchant data -> [c]
- **[c] DECISION:** Customer corrects category? -> if yes: [d]; if no: [e]
- **[d] STEP:** Store correction; learn per customer -> [e]
- **[e] STEP:** Update category totals -> [f]
- **[f] STEP:** Month end: build summary -> [g]
- **[g] DECISION:** Consent for personalised tips? -> if yes: [h]; if no: [i]
- **[h] STEP:** Add gentle tips -> [i]
- **[i] END:** Notify summary ready
