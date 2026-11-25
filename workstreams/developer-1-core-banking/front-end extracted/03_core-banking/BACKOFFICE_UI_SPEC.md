# Back-office UI/UX Specification (web)

Frame 1440x900. Use the design system tokens and the web components (DataTable, FilterDrawer, DetailDrawer, ApprovalBanner, AuditTimeline). Mask sensitive data by default. Product consoles are specified in the product folders and linked from here.

### W-BO-001 - Sign in and MFA
- **Route:** `/admin/login`  |  **Requirements:** BO-001
- **Purpose:** Staff sign-in.
- **Layout:**
  - Wordmark, email, password, MFA code
  - Session notice
- **Actions:** Sign in
- **States:** Locked; MFA failure

### W-BO-002 - Home / work queues
- **Route:** `/admin`  |  **Requirements:** BO-016
- **Purpose:** Today's work.
- **Layout:**
  - Queue tiles: KYC, alerts, tickets, approvals, disputes, exceptions with counts and SLA
  - Pending approvals strip
- **Actions:** Open queue
- **States:** SLA breach indicators

### W-BO-003 - Customer search and 360
- **Route:** `/admin/customers/:id`  |  **Requirements:** BO-002
- **Purpose:** Customer view.
- **Layout:**
  - Masked profile header; tabs: Accounts, Transactions, KYC, Devices, Tickets, Notes, Products
  - Actions: Lock, Request reversal, Unmask (reason)
- **Actions:** Actions
- **States:** Unmask prompts reason modal

### W-BO-004 - KYC queue and case
- **Route:** `/admin/kyc`  |  **Requirements:** BO-003
- **Purpose:** Review KYC.
- **Layout:**
  - Queue table; case view with documents, liveness, match scores, sanctions result
  - Decision panel with reason codes
- **Actions:** Decide
- **States:** Missing documents

### W-BO-005 - Transactions
- **Route:** `/admin/transactions`  |  **Requirements:** BO-004
- **Purpose:** Search transactions.
- **Layout:**
  - Filters; table; detail drawer with ledger entries and provider references
  - Request reversal button
- **Actions:** Open
- **States:** Pending transactions highlighted

### W-BO-006 - Approvals inbox
- **Route:** `/admin/approvals`  |  **Requirements:** BO-005
- **Purpose:** Dual control.
- **Layout:**
  - Pending list with requester, action, payload summary, evidence
  - Approve/Reject with reason
- **Actions:** Decide
- **States:** Cannot approve own request

### W-BO-007 - Configuration
- **Route:** `/admin/config`  |  **Requirements:** BO-006
- **Purpose:** Limits, fees, tiers.
- **Layout:**
  - Config keys list with current and draft versions
  - Edit form, effective date, submit for approval
  - Version history with diff
- **Actions:** Submit
- **States:** Pending approval

### W-BO-008 - Risk alerts and cases
- **Route:** `/admin/risk`  |  **Requirements:** BO-007
- **Purpose:** Fraud and AML.
- **Layout:**
  - Alert queue with rule, score, entities
  - Case workspace: timeline, notes, actions (allow, step-up, hold, block, report)
- **Actions:** Act
- **States:** Restricted STR section

### W-BO-009 - Support workspace
- **Route:** `/admin/support`  |  **Requirements:** BO-008
- **Purpose:** Tickets.
- **Layout:**
  - Ticket list with SLA timers
  - Conversation, linked transaction, macros, status
- **Actions:** Reply
- **States:** Escalation flags

### W-BO-010 - Reconciliation
- **Route:** `/admin/reconciliation`  |  **Requirements:** BO-009
- **Purpose:** Daily recon.
- **Layout:**
  - Date picker; summary tiles; exceptions table; suspense balances
  - Resolve action creating approvals
- **Actions:** Resolve
- **States:** Unreconciled day banner

### W-BO-011 - Tenants
- **Route:** `/admin/tenants`  |  **Requirements:** BO-010
- **Purpose:** Manage groups and businesses.
- **Layout:**
  - Tabs by tenant type; table with status and trust level
  - Detail drawer: documents, members, activity, actions (verify, trust level, freeze)
- **Actions:** Verify
- **States:** Frozen state

### W-BO-012 - Loans console
- **Route:** `/admin/loans`  |  **Requirements:** BO-011
- **Purpose:** See product console in Instant Loan docs (W-LOAN-001..004).
- **Layout:**
  - Applications, portfolio, products, settlement tabs
- **Actions:** Open
- **States:** As product docs

### W-BO-013 - Escrow disputes
- **Route:** `/admin/escrow`  |  **Requirements:** BO-011
- **Purpose:** See W-ESC-002..004.
- **Layout:**
  - Queue and case view
- **Actions:** Open
- **States:** As product docs

### W-BO-014 - Rewards and campaigns
- **Route:** `/admin/rewards`  |  **Requirements:** BO-011
- **Purpose:** See W-INS-001..003.
- **Layout:**
  - Campaigns, budget, referral review
- **Actions:** Open
- **States:** As product docs

### W-BO-015 - Agents
- **Route:** `/admin/agents`  |  **Requirements:** BO-011
- **Purpose:** See W-AGT-001..003.
- **Layout:**
  - Applications, float, config
- **Actions:** Open
- **States:** As product docs

### W-BO-016 - Reports
- **Route:** `/admin/reports`  |  **Requirements:** BO-012
- **Purpose:** Reports and exports.
- **Layout:**
  - Catalogue with filters, schedule, download history
- **Actions:** Run
- **States:** Generating

### W-BO-017 - Audit log
- **Route:** `/admin/audit`  |  **Requirements:** BO-013
- **Purpose:** Search audit.
- **Layout:**
  - Filters by actor, action, entity, date; table; export
- **Actions:** Export
- **States:** Large range warning

### W-BO-018 - Staff and roles
- **Route:** `/admin/staff`  |  **Requirements:** BO-014
- **Purpose:** Manage staff.
- **Layout:**
  - Staff table, roles, MFA status, last access
  - Invite, deactivate, access review
- **Actions:** Invite
- **States:** Self-removal blocked

### W-BO-019 - Flags and templates
- **Route:** `/admin/flags`  |  **Requirements:** BO-015
- **Purpose:** Feature flags and message templates.
- **Layout:**
  - Flags with environments
  - Template editor with preview and approval
- **Actions:** Submit
- **States:** Pending approval

### W-BO-020 - System status
- **Route:** `/admin/status`  |  **Requirements:** BO-016
- **Purpose:** Health.
- **Layout:**
  - Service status, queue depth, provider health, latest incidents
- **Actions:** Open incident
- **States:** Degraded banners
