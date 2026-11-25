# Screen Inventory - Spending Insights and Rewards

Platforms: M = mobile app, W = web dashboard.

| ID | Screen | Platform | Route | Requirements |
|---|---|---|---|---|
| S-INS-001 | Insights home | M | `/insights` | INS-CAT-002, INS-CAT-003 |
| S-INS-002 | Category detail | M | `/insights/category/:id` | INS-CAT-003 |
| S-INS-003 | Budgets | M | `/insights/budgets` | INS-BUD-001 |
| S-INS-004 | Create budget | M | `/insights/budgets/new` | INS-BUD-001, INS-BUD-002 |
| S-INS-005 | Monthly summary | M | `/insights/summary/:month` | INS-CAT-002 |
| S-INS-006 | Rewards home | M | `/rewards` | INS-RWD-001, INS-RWD-003 |
| S-INS-007 | Campaign detail | M | `/rewards/:id` | INS-RWD-001, INS-RWD-005 |
| S-INS-008 | Refer a friend | M | `/rewards/refer` | INS-REF-001, INS-REF-002 |
| S-INS-009 | Privacy and preferences | M | `/insights/preferences` | INS-PRV-001, INS-CAT-004 |
| W-INS-001 | Campaigns and rules | W | `/backoffice/rewards/campaigns` | INS-RWD-002 |
| W-INS-002 | Reward budget and cost | W | `/backoffice/rewards/budget` | INS-RWD-004 |
| W-INS-003 | Referral review | W | `/backoffice/rewards/referrals` | INS-REF-003 |
