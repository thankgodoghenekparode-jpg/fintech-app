# UI/UX Specification - Escrow

Global rules from the design system apply (tokens, components, states, i18n keys, accessibility). Mobile frame 390x844; web frame 1440x900.

### S-ESC-001 - Escrow home (Mobile)
- **Route:** `/escrow`  |  **Requirements:** ESC-DEA-001
- **Purpose:** My deals.
- **Layout (top to bottom):**
  - Tabs: Active, Waiting for me, Completed, Disputes
  - Deal cards: title, amount, role, status chip
  - Button: New deal; link: How escrow works
- **Actions / navigation:** Open deal -> S-ESC-007; New -> S-ESC-002
- **States and edge cases:** Empty; load error

### S-ESC-002 - Create deal (Mobile)
- **Route:** `/escrow/new`  |  **Requirements:** ESC-DEA-001, ESC-DEA-007
- **Purpose:** Start a deal.
- **Layout (top to bottom):**
  - Deal type picker with short explanations
  - Your role (buyer/seller)
  - Title, description, amount, timeline
  - Milestones editor (service) or checkpoints (property) from template
- **Actions / navigation:** Next -> S-ESC-003
- **States and edge cases:** Limit by tier exceeded

### S-ESC-003 - Fees and cancellation terms (Mobile)
- **Route:** `/escrow/new/terms`  |  **Requirements:** ESC-DEA-003, ESC-DEA-004, ESC-DEA-005
- **Purpose:** Choose fee arrangement.
- **Layout (top to bottom):**
  - Fee payer selector: buyer, seller, split (percentages)
  - Table of scenarios with option pickers: before funding, mutual cancel, one-sided cancel, dispute, refund for non-delivery
  - Live fee amounts
  - Plain summary box and confirm tap
- **Actions / navigation:** Next -> S-ESC-004
- **States and edge cases:** Defaults suggested; minimum charge note

### S-ESC-004 - Invite and negotiate (Mobile)
- **Route:** `/escrow/:id/invite`  |  **Requirements:** ESC-DEA-002
- **Purpose:** Bring in the other party.
- **Layout (top to bottom):**
  - Share link/phone invite
  - Comment and counter-offer thread
  - Changes highlighted
- **Actions / navigation:** Send
- **States and edge cases:** Counterparty not verified

### S-ESC-005 - Deal summary and accept (Mobile)
- **Route:** `/escrow/:id/accept`  |  **Requirements:** ESC-DEA-002
- **Purpose:** Lock terms.
- **Layout (top to bottom):**
  - Full summary: parties, amount, timeline, fees, cancel/refund options, dispute window
  - Terms link; Accept with PIN
  - Status of the other party's acceptance
- **Actions / navigation:** Accept
- **States and edge cases:** Terms changed -> re-accept

### S-ESC-006 - Fund deal (Mobile)
- **Route:** `/escrow/:id/fund`  |  **Requirements:** ESC-FND-002
- **Purpose:** Buyer pays in.
- **Layout (top to bottom):**
  - Amount and fee breakdown
  - Pay from wallet or show deal account number
  - Confirm -> PIN
- **Actions / navigation:** Confirm
- **States and edge cases:** Pending bank transfer state

### S-ESC-007 - Deal detail (Mobile)
- **Route:** `/escrow/:id`  |  **Requirements:** ESC-TRU-003
- **Purpose:** Timeline and chat.
- **Layout (top to bottom):**
  - Status header and amount held
  - Timeline of steps with who must act next
  - Chat tab; Documents tab
  - Context actions by role
- **Actions / navigation:** Act on next step
- **States and edge cases:** Frozen banner; overdue timer

### S-ESC-008 - Seller: submit delivery or milestone (Mobile)
- **Route:** `/escrow/:id/deliver`  |  **Requirements:** ESC-REL-001, ESC-REL-002
- **Purpose:** Provide proof.
- **Layout (top to bottom):**
  - Evidence upload (photos, documents, tracking)
  - Milestone selector or delivery code instructions
  - Submit
- **Actions / navigation:** Submit
- **States and edge cases:** Window rules shown

### S-ESC-009 - Buyer: confirm or approve (Mobile)
- **Route:** `/escrow/:id/confirm`  |  **Requirements:** ESC-REL-004
- **Purpose:** Confirm receipt.
- **Layout (top to bottom):**
  - Evidence view
  - Options: Confirm and release, Request revision, Report a problem
  - Enter delivery code when applicable
  - Auto-release date shown
- **Actions / navigation:** Release -> PIN
- **States and edge cases:** Timer countdown

### S-ESC-010 - Open dispute (Mobile)
- **Route:** `/escrow/:id/dispute`  |  **Requirements:** ESC-DSP-001, ESC-DSP-002
- **Purpose:** Raise a dispute.
- **Layout (top to bottom):**
  - Reason picker
  - Description and evidence upload
  - What happens next and deadlines
- **Actions / navigation:** Submit
- **States and edge cases:** Window closed message

### S-ESC-011 - Dispute tracker (Mobile)
- **Route:** `/escrow/:id/dispute/status`  |  **Requirements:** ESC-DSP-003
- **Purpose:** Follow the dispute.
- **Layout (top to bottom):**
  - Timeline: opened, evidence due, review, decision, appeal window
  - Other party's submissions (as permitted)
  - Decision rationale when ready; Appeal button
- **Actions / navigation:** Appeal
- **States and edge cases:** Decision deadline countdown

### S-ESC-012 - Cancel deal (Mobile)
- **Route:** `/escrow/:id/cancel`  |  **Requirements:** ESC-DEA-004
- **Purpose:** Cancel with clarity.
- **Layout (top to bottom):**
  - Which scenario applies and the agreed fee outcome
  - Net refund amount
  - Confirm
- **Actions / navigation:** Confirm
- **States and edge cases:** Needs counterparty agreement

### S-ESC-013 - Receipt and rating (Mobile)
- **Route:** `/escrow/:id/receipt`  |  **Requirements:** ESC-TRU-003
- **Purpose:** Close out.
- **Layout (top to bottom):**
  - Receipt (shareable)
  - Rate the other party
- **Actions / navigation:** Share
- **States and edge cases:** Default

### W-ESC-001 - My deals (business) (Web)
- **Route:** `/escrow/web/deals`  |  **Requirements:** ESC-TRU-005
- **Purpose:** Many deals.
- **Layout (top to bottom):**
  - Table with filters and export
  - Detail drawer
- **Actions / navigation:** Open
- **States and edge cases:** Default

### W-ESC-002 - Dispute queue (Web)
- **Route:** `/backoffice/escrow/disputes`  |  **Requirements:** ESC-DSP-005
- **Purpose:** Officer queue.
- **Layout (top to bottom):**
  - Queue with SLA timers
  - Filters by type, value, age
- **Actions / navigation:** Open case
- **States and edge cases:** Breach indicators

### W-ESC-003 - Dispute case (Web)
- **Route:** `/backoffice/escrow/disputes/:id`  |  **Requirements:** ESC-DSP-003, ESC-DSP-005
- **Purpose:** Decide.
- **Layout (top to bottom):**
  - Deal terms snapshot
  - Evidence from both sides
  - Decision form with rationale and fee outcome
  - Appeal handling
- **Actions / navigation:** Decide
- **States and edge cases:** Second reviewer for appeals

### W-ESC-004 - Templates and fees (Web)
- **Route:** `/backoffice/escrow/config`  |  **Requirements:** ESC-DEA-007, ESC-REL-005
- **Purpose:** Configure.
- **Layout (top to bottom):**
  - Template editor: checkpoints, timers, documents
  - Fee schedule and minimum charge with dual-control
- **Actions / navigation:** Submit for approval
- **States and edge cases:** Pending approval
