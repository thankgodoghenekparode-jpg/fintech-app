# State and Navigation - Escrow

Deal state, timers, fees and net amounts come from the server. The next required action and who must take it is returned as `nextAction`. Evidence uploads use signed URLs. Terms are shown from the locked snapshot.

## Routes
| Screen | Route | Platform |
|---|---|---|
| S-ESC-001 | `/escrow` | M |
| S-ESC-002 | `/escrow/new` | M |
| S-ESC-003 | `/escrow/new/terms` | M |
| S-ESC-004 | `/escrow/:id/invite` | M |
| S-ESC-005 | `/escrow/:id/accept` | M |
| S-ESC-006 | `/escrow/:id/fund` | M |
| S-ESC-007 | `/escrow/:id` | M |
| S-ESC-008 | `/escrow/:id/deliver` | M |
| S-ESC-009 | `/escrow/:id/confirm` | M |
| S-ESC-010 | `/escrow/:id/dispute` | M |
| S-ESC-011 | `/escrow/:id/dispute/status` | M |
| S-ESC-012 | `/escrow/:id/cancel` | M |
| S-ESC-013 | `/escrow/:id/receipt` | M |
| W-ESC-001 | `/escrow/web/deals` | W |
| W-ESC-002 | `/backoffice/escrow/disputes` | W |
| W-ESC-003 | `/backoffice/escrow/disputes/:id` | W |
| W-ESC-004 | `/backoffice/escrow/config` | W |
