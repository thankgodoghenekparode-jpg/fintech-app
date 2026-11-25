# Screen Inventory - Cash-in / Cash-out Agent Network

Platforms: M = mobile app, W = web dashboard.

| ID | Screen | Platform | Route | Requirements |
|---|---|---|---|---|
| S-AGT-001 | Agent home | M | `/agent` | AGT-FLT-001, AGT-FLT-003 |
| S-AGT-002 | Cash-in | M | `/agent/cash-in` | AGT-CIN-001 |
| S-AGT-003 | Cash-out | M | `/agent/cash-out` | AGT-COT-002 |
| S-AGT-004 | Float top-up | M | `/agent/float` | AGT-FLT-001 |
| S-AGT-005 | Commission and history | M | `/agent/history` | AGT-FLT-003 |
| S-AGT-006 | Day-end summary | M | `/agent/day-end` | AGT-FLT-002 |
| S-AGT-007 | Become an agent | M | `/agent/apply` | AGT-ONB-001 |
| S-AGT-010 | Find an agent | M | `/agents/nearby` | AGT-LOC-001 |
| S-AGT-011 | Cash-in at an agent | M | `/agents/cash-in` | AGT-CIN-001 |
| S-AGT-012 | Request cash-out | M | `/agents/cash-out` | AGT-COT-001, AGT-COT-004 |
| S-AGT-013 | Rate or report agent | M | `/agents/:id/feedback` | AGT-LOC-002 |
| W-AGT-001 | Agent management | W | `/backoffice/agents` | AGT-ONB-001, AGT-ONB-004 |
| W-AGT-002 | Float and reconciliation | W | `/backoffice/agents/float` | AGT-FLT-002 |
| W-AGT-003 | Commission and limits | W | `/backoffice/agents/config` | AGT-FLT-003, AGT-CIN-003 |
