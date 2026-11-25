# UI/UX Specification - Pay Am Small

Global rules from the design system apply (tokens, components, states, i18n keys, accessibility). Mobile frame 390x844; web frame 1440x900.

### S-PAS-001 - Marketplace home (Mobile)
- **Route:** `/shop`  |  **Requirements:** PAS-BUY-001
- **Purpose:** Browse.
- **Layout (top to bottom):**
  - Search bar
  - Category chips
  - Featured vendors and products with price and plan badges (Price-lock, Credit)
  - Verified Vendor badges
- **Actions / navigation:** Open product -> S-PAS-002
- **States and edge cases:** Empty; load error

### S-PAS-002 - Product detail (Mobile)
- **Route:** `/shop/products/:id`  |  **Requirements:** PAS-BUY-002
- **Purpose:** Product and options.
- **Layout (top to bottom):**
  - Images, title, price, vendor with rating and badge
  - Option tabs: Pay in full, Price-lock, Credit (if offered)
  - Delivery terms and locked-price promise
  - Button: Continue
- **Actions / navigation:** Continue -> S-PAS-003
- **States and edge cases:** Out of stock; option unavailable

### S-PAS-003 - Plan setup (Mobile)
- **Route:** `/shop/plan`  |  **Requirements:** PAS-BUY-003, PAS-BUY-004
- **Purpose:** Configure plan.
- **Layout (top to bottom):**
  - Items in this vault (add more items)
  - Price-lock: target amount, deadline, auto-save schedule or manual
  - Penalty and deadline rules in plain language
  - Fee summary
- **Actions / navigation:** Continue -> S-PAS-004
- **States and edge cases:** Vendor unavailable

### S-PAS-004 - Plan summary and terms (Mobile)
- **Route:** `/shop/plan/review`  |  **Requirements:** PAS-BUY-003
- **Purpose:** Accept terms.
- **Layout (top to bottom):**
  - Key facts: total, locked price, deadline, penalty, refund fee, vendor, who carries risk (credit)
  - Expandable full terms
  - Checkbox and Accept -> PIN
- **Actions / navigation:** Accept
- **States and edge cases:** Terms version changed

### S-PAS-005 - My plans (Mobile)
- **Route:** `/shop/plans`  |  **Requirements:** PAS-BUY-004
- **Purpose:** List vaults and credit orders.
- **Layout (top to bottom):**
  - Tabs: Vaults, Credit, Completed
  - Cards with progress ring and next due
- **Actions / navigation:** Open
- **States and edge cases:** Empty

### S-PAS-006 - Vault detail (Mobile)
- **Route:** `/shop/plans/:id`  |  **Requirements:** PAS-VLT-001, PAS-VLT-002
- **Purpose:** Track vault.
- **Layout (top to bottom):**
  - Progress ring, saved/target, deadline
  - Items list
  - Auto-debit status and next run
  - Buttons: Add money, Withdraw
- **Actions / navigation:** Add -> S-PAS-007; Withdraw -> S-PAS-008
- **States and edge cases:** Retry banner; grace period notice

### S-PAS-007 - Add money to vault (Mobile)
- **Route:** `/shop/plans/:id/add`  |  **Requirements:** PAS-VLT-001
- **Purpose:** Pay any amount.
- **Layout (top to bottom):**
  - AmountInput with remaining chip
  - Confirm -> PIN
- **Actions / navigation:** Confirm
- **States and edge cases:** Insufficient funds; complete -> success moment

### S-PAS-008 - Withdraw from vault (Mobile)
- **Route:** `/shop/plans/:id/withdraw`  |  **Requirements:** PAS-VLT-003
- **Purpose:** Early exit.
- **Layout (top to bottom):**
  - Summary: saved, penalty (set at setup), net
  - Reminder of locked price benefit
  - Confirm -> PIN
- **Actions / navigation:** Confirm
- **States and edge cases:** Default

### S-PAS-009 - Deadline decision (Mobile)
- **Route:** `/shop/plans/:id/deadline`  |  **Requirements:** PAS-VLT-004
- **Purpose:** Extend or refund.
- **Layout (top to bottom):**
  - Two options with consequences
  - Extension fee/ new date or refund net amount
  - Confirm
- **Actions / navigation:** Choose
- **States and edge cases:** Extension limit reached

### S-PAS-010 - Order tracking (Mobile)
- **Route:** `/shop/orders/:id`  |  **Requirements:** PAS-ORD-001, PAS-BUY-005
- **Purpose:** Track delivery.
- **Layout (top to bottom):**
  - Status timeline
  - Delivery code (show to rider/vendor)
  - Vendor contact and Report a problem
- **Actions / navigation:** Report -> S-PAS-013
- **States and edge cases:** Delayed banner

### S-PAS-011 - Credit repayment (Mobile)
- **Route:** `/shop/credit/:id`  |  **Requirements:** PAS-CRD-002
- **Purpose:** Repay installments.
- **Layout (top to bottom):**
  - Schedule with due dates
  - Pay now / auto-repay toggle
  - Clear note: vendor-funded terms
- **Actions / navigation:** Pay
- **States and edge cases:** Overdue notice with capped late fee

### S-PAS-012 - Vendor storefront (Mobile)
- **Route:** `/shop/vendors/:id`  |  **Requirements:** PAS-BUY-001
- **Purpose:** Vendor page.
- **Layout (top to bottom):**
  - Badge, rating, about, delivery info
  - Product grid
- **Actions / navigation:** Open product
- **States and edge cases:** Suspended vendor notice

### S-PAS-013 - Report an order problem (Mobile)
- **Route:** `/shop/orders/:id/report`  |  **Requirements:** PAS-ORD-003
- **Purpose:** Raise issue.
- **Layout (top to bottom):**
  - Reason, description, evidence
  - Submit; ticket number and timeline
- **Actions / navigation:** Submit
- **States and edge cases:** Default

### W-PAS-001 - Vendor dashboard (Web)
- **Route:** `/vendor/:t/dashboard`  |  **Requirements:** PAS-VEN-006
- **Purpose:** Overview.
- **Layout (top to bottom):**
  - KPI tiles: orders, active plans, payouts, disputes
  - Charts: sales and plan completion
  - Alerts: low stock, late deliveries
- **Actions / navigation:** Drill down
- **States and edge cases:** Restricted account banner

### W-PAS-002 - Products and prices (Web)
- **Route:** `/vendor/:t/products`  |  **Requirements:** PAS-VEN-003, PAS-VEN-004
- **Purpose:** Manage catalogue.
- **Layout (top to bottom):**
  - Product table; edit drawer with price, stock, plan options, committed delivery days
  - Locked-price commitment notice
- **Actions / navigation:** Save
- **States and edge cases:** Price change blocked for active plans

### W-PAS-003 - Orders and fulfilment (Web)
- **Route:** `/vendor/:t/orders`  |  **Requirements:** PAS-ORD-001
- **Purpose:** Fulfil orders.
- **Layout (top to bottom):**
  - Orders table by status
  - Mark shipped/delivered; delivery code entry
  - Proof upload
- **Actions / navigation:** Update
- **States and edge cases:** Overdue indicators

### W-PAS-004 - Plans and customers (Web)
- **Route:** `/vendor/:t/plans`  |  **Requirements:** PAS-VEN-005
- **Purpose:** Plan status.
- **Layout (top to bottom):**
  - Table of vaults and credit orders with progress
  - Buyer identity badge and repayment history (credit)
- **Actions / navigation:** Open
- **States and edge cases:** Default

### W-PAS-005 - Credit offers (Web)
- **Route:** `/vendor/:t/credit`  |  **Requirements:** PAS-CRD-001
- **Purpose:** Decide credit orders.
- **Layout (top to bottom):**
  - Pending credit requests with buyer profile
  - Accept/Decline with reason
  - Per-product credit toggle
- **Actions / navigation:** Decide
- **States and edge cases:** Risk reminder text

### W-PAS-006 - Payouts and wallet (Web)
- **Route:** `/vendor/:t/payouts`  |  **Requirements:** PAS-VLT-005, PAS-VLT-006
- **Purpose:** Money view.
- **Layout (top to bottom):**
  - Balance, holdback, payouts list
  - Statements and export
  - Settlement account
- **Actions / navigation:** Export
- **States and edge cases:** Pending holdback release

### W-PAS-007 - Team and verification (Web)
- **Route:** `/vendor/:t/team`  |  **Requirements:** PAS-VEN-001, PAS-VEN-002
- **Purpose:** Roles and documents.
- **Layout (top to bottom):**
  - Team list and roles
  - Verification status and documents
- **Actions / navigation:** Invite
- **States and edge cases:** Rejected with reason
