# UI/UX Specification - Cash-in / Cash-out Agent Network

Global rules from the design system apply (tokens, components, states, i18n keys, accessibility). Mobile frame 390x844; web frame 1440x900.

### S-AGT-001 - Agent home (Mobile)
- **Route:** `/agent`  |  **Requirements:** AGT-FLT-001, AGT-FLT-003
- **Purpose:** Agent dashboard.
- **Layout (top to bottom):**
  - Float balance and low-float alert
  - Today's transactions and commission
  - Actions: Cash-in, Cash-out, Top up float
- **Actions / navigation:** Actions
- **States and edge cases:** Suspended banner

### S-AGT-002 - Cash-in (Mobile)
- **Route:** `/agent/cash-in`  |  **Requirements:** AGT-CIN-001
- **Purpose:** Deposit for customer.
- **Layout (top to bottom):**
  - Customer phone/account lookup with name
  - Amount; fee note
  - Confirm with PIN
- **Actions / navigation:** Confirm
- **States and edge cases:** Limit or float errors

### S-AGT-003 - Cash-out (Mobile)
- **Route:** `/agent/cash-out`  |  **Requirements:** AGT-COT-002
- **Purpose:** Pay out against code.
- **Layout (top to bottom):**
  - Enter code and amount
  - Customer confirmation status
  - Pay cash prompt
- **Actions / navigation:** Confirm
- **States and edge cases:** Expired code

### S-AGT-004 - Float top-up (Mobile)
- **Route:** `/agent/float`  |  **Requirements:** AGT-FLT-001
- **Purpose:** Add float.
- **Layout (top to bottom):**
  - Methods: transfer, branch deposit
  - Pending credits
- **Actions / navigation:** Top up
- **States and edge cases:** Pending

### S-AGT-005 - Commission and history (Mobile)
- **Route:** `/agent/history`  |  **Requirements:** AGT-FLT-003
- **Purpose:** Earnings.
- **Layout (top to bottom):**
  - Summary and list
  - Statement export
- **Actions / navigation:** Export
- **States and edge cases:** Empty

### S-AGT-006 - Day-end summary (Mobile)
- **Route:** `/agent/day-end`  |  **Requirements:** AGT-FLT-002
- **Purpose:** Reconcile.
- **Layout (top to bottom):**
  - Float vs cash summary
  - Submit
- **Actions / navigation:** Submit
- **States and edge cases:** Mismatch warning

### S-AGT-007 - Become an agent (Mobile)
- **Route:** `/agent/apply`  |  **Requirements:** AGT-ONB-001
- **Purpose:** Application.
- **Layout (top to bottom):**
  - Stepper: Identity, Location, Photos, Agreement
- **Actions / navigation:** Submit
- **States and edge cases:** Pending/Rejected

### S-AGT-010 - Find an agent (Mobile)
- **Route:** `/agents/nearby`  |  **Requirements:** AGT-LOC-001
- **Purpose:** Locator.
- **Layout (top to bottom):**
  - Map and list toggle; filters; distance, hours, rating
  - Agent detail card with Request cash-out
- **Actions / navigation:** Request
- **States and edge cases:** Location denied

### S-AGT-011 - Cash-in at an agent (Mobile)
- **Route:** `/agents/cash-in`  |  **Requirements:** AGT-CIN-001
- **Purpose:** Customer view.
- **Layout (top to bottom):**
  - Instructions; show phone/account to agent
  - Confirmation when credited
- **Actions / navigation:** Done
- **States and edge cases:** Pending

### S-AGT-012 - Request cash-out (Mobile)
- **Route:** `/agents/cash-out`  |  **Requirements:** AGT-COT-001, AGT-COT-004
- **Purpose:** Create code.
- **Layout (top to bottom):**
  - Amount, agent, fee, total
  - Generated code with countdown
  - Cancel button
- **Actions / navigation:** Request
- **States and edge cases:** Expired

### S-AGT-013 - Rate or report agent (Mobile)
- **Route:** `/agents/:id/feedback`  |  **Requirements:** AGT-LOC-002
- **Purpose:** Feedback.
- **Layout (top to bottom):**
  - Stars, comment, report option
- **Actions / navigation:** Submit
- **States and edge cases:** Default

### W-AGT-001 - Agent management (Web)
- **Route:** `/backoffice/agents`  |  **Requirements:** AGT-ONB-001, AGT-ONB-004
- **Purpose:** Staff view.
- **Layout (top to bottom):**
  - Applications queue; agents table with status
  - Detail with limits, activity, suspend
- **Actions / navigation:** Approve
- **States and edge cases:** SLA indicators

### W-AGT-002 - Float and reconciliation (Web)
- **Route:** `/backoffice/agents/float`  |  **Requirements:** AGT-FLT-002
- **Purpose:** Control.
- **Layout (top to bottom):**
  - Float balances, exceptions, day-end submissions
- **Actions / navigation:** Resolve
- **States and edge cases:** Exceptions

### W-AGT-003 - Commission and limits (Web)
- **Route:** `/backoffice/agents/config`  |  **Requirements:** AGT-FLT-003, AGT-CIN-003
- **Purpose:** Config.
- **Layout (top to bottom):**
  - Commission schedule and agent limits with dual-control approval
- **Actions / navigation:** Submit for approval
- **States and edge cases:** Pending
