# UI/UX Specification - Spending Insights and Rewards

Global rules from the design system apply (tokens, components, states, i18n keys, accessibility). Mobile frame 390x844; web frame 1440x900.

### S-INS-001 - Insights home (Mobile)
- **Route:** `/insights`  |  **Requirements:** INS-CAT-002, INS-CAT-003
- **Purpose:** This month at a glance.
- **Layout (top to bottom):**
  - Month selector
  - Spend vs income summary
  - Category donut/bars with amounts
  - Top merchants; tip card (dismissible)
- **Actions / navigation:** Open category -> S-INS-002
- **States and edge cases:** Not enough data; consent off notice

### S-INS-002 - Category detail (Mobile)
- **Route:** `/insights/category/:id`  |  **Requirements:** INS-CAT-003
- **Purpose:** Drill down.
- **Layout (top to bottom):**
  - Total, trend vs last month
  - Transactions list with Re-categorise
- **Actions / navigation:** Re-categorise
- **States and edge cases:** Empty

### S-INS-003 - Budgets (Mobile)
- **Route:** `/insights/budgets`  |  **Requirements:** INS-BUD-001
- **Purpose:** Budgets overview.
- **Layout (top to bottom):**
  - Budget cards with progress and remaining
  - Add budget
- **Actions / navigation:** Create -> S-INS-004
- **States and edge cases:** Empty

### S-INS-004 - Create budget (Mobile)
- **Route:** `/insights/budgets/new`  |  **Requirements:** INS-BUD-001, INS-BUD-002
- **Purpose:** Set a budget.
- **Layout (top to bottom):**
  - Category, monthly amount, alert thresholds
  - Suggestion based on last month
- **Actions / navigation:** Save
- **States and edge cases:** Validation

### S-INS-005 - Monthly summary (Mobile)
- **Route:** `/insights/summary/:month`  |  **Requirements:** INS-CAT-002
- **Purpose:** Shareable summary.
- **Layout (top to bottom):**
  - Highlights, comparisons, savings opportunities
  - Optional: Start a savings goal
- **Actions / navigation:** Share
- **States and edge cases:** Default

### S-INS-006 - Rewards home (Mobile)
- **Route:** `/rewards`  |  **Requirements:** INS-RWD-001, INS-RWD-003
- **Purpose:** See rewards.
- **Layout (top to bottom):**
  - Reward balance and recent credits
  - Active campaigns with progress
  - Terms link
- **Actions / navigation:** Open campaign
- **States and edge cases:** No campaigns

### S-INS-007 - Campaign detail (Mobile)
- **Route:** `/rewards/:id`  |  **Requirements:** INS-RWD-001, INS-RWD-005
- **Purpose:** Rules in plain words.
- **Layout (top to bottom):**
  - What to do, reward, caps, dates, terms
  - Progress
- **Actions / navigation:** Back
- **States and edge cases:** Ended or exhausted

### S-INS-008 - Refer a friend (Mobile)
- **Route:** `/rewards/refer`  |  **Requirements:** INS-REF-001, INS-REF-002
- **Purpose:** Referral.
- **Layout (top to bottom):**
  - Code and link with Share
  - How it works: reward after your friend's first real transaction
  - List of referrals with status
- **Actions / navigation:** Share
- **States and edge cases:** Pending and paid states

### S-INS-009 - Privacy and preferences (Mobile)
- **Route:** `/insights/preferences`  |  **Requirements:** INS-PRV-001, INS-CAT-004
- **Purpose:** Control data use.
- **Layout (top to bottom):**
  - Toggles: Personalised insights, Tips, Alerts
  - Explanation of data used
- **Actions / navigation:** Save
- **States and edge cases:** Withdrawn consent effect

### W-INS-001 - Campaigns and rules (Web)
- **Route:** `/backoffice/rewards/campaigns`  |  **Requirements:** INS-RWD-002
- **Purpose:** Configure.
- **Layout (top to bottom):**
  - Campaign list and editor (rules, caps, dates)
  - Dual-control approval
- **Actions / navigation:** Submit
- **States and edge cases:** Pending approval

### W-INS-002 - Reward budget and cost (Web)
- **Route:** `/backoffice/rewards/budget`  |  **Requirements:** INS-RWD-004
- **Purpose:** Control cost.
- **Layout (top to bottom):**
  - Budget vs spend charts; alerts; pause/resume
- **Actions / navigation:** Pause
- **States and edge cases:** Exhausted banner

### W-INS-003 - Referral review (Web)
- **Route:** `/backoffice/rewards/referrals`  |  **Requirements:** INS-REF-003
- **Purpose:** Abuse review.
- **Layout (top to bottom):**
  - Flagged referrals table with signals; approve/reject
- **Actions / navigation:** Decide
- **States and edge cases:** Default
