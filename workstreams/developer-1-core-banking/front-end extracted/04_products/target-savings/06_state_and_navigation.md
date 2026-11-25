# State and Navigation - Target Savings

Goals are server-driven (progress, penalty and net amounts come from quote endpoints; never recompute money on the client). Milestone moments are triggered by the response of a successful top-up.

## Routes
| Screen | Route | Platform |
|---|---|---|
| S-TGT-001 | `/targets` | M |
| S-TGT-002 | `/targets/new` | M |
| S-TGT-003 | `/targets/:id` | M |
| S-TGT-004 | `/targets/:id/add` | M |
| S-TGT-005 | `/targets/:id/auto` | M |
| S-TGT-006 | `/targets/:id/withdraw` | M |
| S-TGT-007 | `/targets/:id/edit` | M |
| S-TGT-008 | `/targets/:id/whatif` | M |
| S-TGT-009 | `/targets/rules` | M |
