# UI/UX Specification - Target Savings

Global rules from the design system apply (tokens, components, states, i18n keys, accessibility). Mobile frame 390x844; web frame 1440x900.

### S-TGT-001 - Target Savings home (Mobile)
- **Route:** `/targets`  |  **Requirements:** TGT-GOL-001, TGT-UX-001
- **Purpose:** List goals.
- **Layout (top to bottom):**
  - Header with total saved across goals
  - Goal cards: name, theme, progress ring, saved/target, days left, mode badge
  - Button: New goal
  - Empty state with a simple example
- **Actions / navigation:** Open -> S-TGT-003; New -> S-TGT-002
- **States and edge cases:** Empty; load error

### S-TGT-002 - Create goal (Mobile)
- **Route:** `/targets/new`  |  **Requirements:** TGT-GOL-001, TGT-GOL-002, TGT-LCK-001
- **Purpose:** Create a goal in steps.
- **Layout (top to bottom):**
  - Stepper: Goal, Plan, Mode, Funding, Review
  - Goal: name, target amount, theme
  - Plan: deadline or contribution; live calculation
  - Mode: Flexible or Locked with penalty shown plainly
  - Funding: auto-save toggle and first deposit
  - Review and PIN
- **Actions / navigation:** Create -> S-TGT-003
- **States and edge cases:** Validation; limit on number of goals

### S-TGT-003 - Goal detail (Mobile)
- **Route:** `/targets/:id`  |  **Requirements:** TGT-UX-001, TGT-UX-004
- **Purpose:** Track one goal.
- **Layout (top to bottom):**
  - Big progress ring with saved amount and target
  - Remaining amount and days left
  - Buttons: Add money, Withdraw, Edit
  - Auto-save status with next run
  - History list
- **Actions / navigation:** Add -> S-TGT-004; Withdraw -> S-TGT-006
- **States and edge cases:** Paused; matured; closed

### S-TGT-004 - Add money (Mobile)
- **Route:** `/targets/:id/add`  |  **Requirements:** TGT-FUN-001
- **Purpose:** Top up a goal.
- **Layout (top to bottom):**
  - AmountInput with quick chips
  - Source: main account balance
  - Confirm sheet -> PIN
- **Actions / navigation:** Confirm
- **States and edge cases:** Insufficient funds; success moment with milestone if reached

### S-TGT-005 - Auto-save setup (Mobile)
- **Route:** `/targets/:id/auto`  |  **Requirements:** TGT-FUN-002
- **Purpose:** Set schedule.
- **Layout (top to bottom):**
  - Frequency, amount, start date
  - Consent explanation and toggle
  - Preview of when the goal will be reached
- **Actions / navigation:** Save with PIN
- **States and edge cases:** Funds-short warning

### S-TGT-006 - Withdraw (Mobile)
- **Route:** `/targets/:id/withdraw`  |  **Requirements:** TGT-LCK-002, TGT-LCK-003
- **Purpose:** Withdraw with clarity.
- **Layout (top to bottom):**
  - Amount (full or partial where allowed)
  - Summary: gross, penalty or fee, net
  - Message encouraging keeping the goal when early
  - Confirm with PIN; optional cooling-off notice
- **Actions / navigation:** Confirm
- **States and edge cases:** Cooling-off active; blocked partial withdrawals per rule

### S-TGT-007 - Edit, pause or close (Mobile)
- **Route:** `/targets/:id/edit`  |  **Requirements:** TGT-GOL-003, TGT-GOL-004
- **Purpose:** Manage a goal.
- **Layout (top to bottom):**
  - Edit name, theme, target
  - Pause auto-save
  - Close goal with return-of-funds summary
- **Actions / navigation:** Save / Close
- **States and edge cases:** Extension rule messages

### S-TGT-008 - What-if calculator (Mobile)
- **Route:** `/targets/:id/whatif`  |  **Requirements:** TGT-UX-002
- **Purpose:** Explore plans.
- **Layout (top to bottom):**
  - Sliders for contribution and date
  - Live result: new end date or required amount
- **Actions / navigation:** Apply plan
- **States and edge cases:** Default

### S-TGT-009 - Save rules (Mobile)
- **Route:** `/targets/rules`  |  **Requirements:** TGT-FUN-003
- **Purpose:** Percent-of-credit saving.
- **Layout (top to bottom):**
  - Rule list: percentage, target goal, minimum credit
  - Create/edit rule with consent
- **Actions / navigation:** Save rule
- **States and edge cases:** Empty
