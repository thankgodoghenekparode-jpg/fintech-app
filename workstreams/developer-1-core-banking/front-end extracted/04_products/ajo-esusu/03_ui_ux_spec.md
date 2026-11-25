# UI/UX Specification - Ajo / Esusu

Global rules from the design system apply (tokens, components, states, i18n keys, accessibility). Mobile frame 390x844; web frame 1440x900.

### S-AJO-001 - Ajo home (Mobile)
- **Route:** `/ajo`  |  **Requirements:** AJO-SET-001, AJO-MEM-001
- **Purpose:** List my circles and entry points.
- **Layout (top to bottom):**
  - Header: Ajo / Esusu
  - Active circle cards: name, my slot, next due, next payout date
  - Buttons: Create circle, Join with code
  - Empty state explaining how it works in three short steps
- **Actions / navigation:** Open -> S-AJO-005; Create -> S-AJO-002; Join -> S-AJO-004
- **States and edge cases:** Empty; load error; pending joins

### S-AJO-002 - Create circle (Mobile)
- **Route:** `/ajo/new`  |  **Requirements:** AJO-SET-001, AJO-SET-002, AJO-ORD-001
- **Purpose:** Create a circle.
- **Layout (top to bottom):**
  - Stepper: Basics, Protection, Order, Review
  - Basics: name, amount per round, frequency, slots, start date; computed pot and duration shown
  - Protection: choose PROTECTED or SAFEGUARDS_ONLY with plain explanation of each and who carries risk
  - Order: random draw, members choose, or organizer-set with consent
  - Review summary and Create
- **Actions / navigation:** Create -> S-AJO-003
- **States and edge cases:** Trust-level cap exceeded message; validation errors

### S-AJO-003 - Invite members (Mobile)
- **Route:** `/ajo/:id/invite`  |  **Requirements:** AJO-MEM-001
- **Purpose:** Share the invite.
- **Layout (top to bottom):**
  - Invite link and code with Copy and Share (WhatsApp, SMS)
  - Roster of joined vs open slots
  - Readiness checklist (slots filled, terms accepted, auto-debit set, cover provided)
- **Actions / navigation:** Share
- **States and edge cases:** Circle not ready banner

### S-AJO-004 - Join circle (Mobile)
- **Route:** `/ajo/join`  |  **Requirements:** AJO-MEM-001, AJO-SET-005
- **Purpose:** Review and join.
- **Layout (top to bottom):**
  - Circle summary: amount, frequency, slots, pot, start date, protection mode
  - Plain-language terms summary and full text link
  - Required checkbox to accept
  - Button: Join
- **Actions / navigation:** Join -> S-AJO-008 or S-AJO-007
- **States and edge cases:** Circle full; ineligible by trust level; invalid code

### S-AJO-005 - Circle detail (Mobile)
- **Route:** `/ajo/:id`  |  **Requirements:** AJO-CON-007
- **Purpose:** Live tracker.
- **Layout (top to bottom):**
  - Header: name, status chip, pot size
  - Timeline of rounds with recipient and status
  - Current round: who has paid (avatars with ticks), countdown to due date and payout
  - My position and next due
- **Actions / navigation:** Round tap -> S-AJO-011
- **States and edge cases:** Shortfall banner; frozen banner

### S-AJO-006 - My schedule (Mobile)
- **Route:** `/ajo/:id/schedule`  |  **Requirements:** AJO-CON-001
- **Purpose:** See my due dates and slot.
- **Layout (top to bottom):**
  - My payout slot and date
  - List of my contributions with status
  - Auto-debit toggle status
- **Actions / navigation:** Pay now -> S-AJO-007
- **States and edge cases:** Overdue highlighted

### S-AJO-007 - Pay or set up auto-debit (Mobile)
- **Route:** `/ajo/:id/pay`  |  **Requirements:** AJO-CON-001, AJO-CON-002
- **Purpose:** Pay early or enable auto-debit.
- **Layout (top to bottom):**
  - Amount due and date
  - Auto-debit consent toggle (required in some cases) with explanation
  - Confirm sheet -> PIN
- **Actions / navigation:** Confirm
- **States and edge cases:** Insufficient funds; success/pending

### S-AJO-008 - Protection setup (Mobile)
- **Route:** `/ajo/:id/protection`  |  **Requirements:** AJO-PRO-001
- **Purpose:** Provide cover.
- **Layout (top to bottom):**
  - Choice: Guarantor or Security deposit
  - Guarantor: search and send request; Deposit: amount and hold explanation
  - Status of cover
- **Actions / navigation:** Send request / Fund deposit
- **States and edge cases:** Guarantor declined; insufficient balance

### S-AJO-009 - Guarantor request (Mobile)
- **Route:** `/ajo/:id/guarantee/:gid`  |  **Requirements:** AJO-PRO-002
- **Purpose:** Guarantor reviews and accepts.
- **Layout (top to bottom):**
  - Member name, circle, maximum amount guaranteed
  - Amount that will be held
  - Plain agreement summary and full text
  - Buttons: Accept (PIN), Decline
- **Actions / navigation:** Accept/Decline
- **States and edge cases:** Expired; insufficient free balance

### S-AJO-010 - Payout order draw (Mobile)
- **Route:** `/ajo/:id/order`  |  **Requirements:** AJO-ORD-001, AJO-ORD-002
- **Purpose:** Draw or choose slots.
- **Layout (top to bottom):**
  - Random draw: Draw button with transparent result list and verification note
  - Choose: slot picker with conflicts resolved by rule
  - Locked notice once confirmed
- **Actions / navigation:** Confirm order
- **States and edge cases:** Waiting for members

### S-AJO-011 - Round detail and payout (Mobile)
- **Route:** `/ajo/:id/rounds/:rid`  |  **Requirements:** AJO-CON-005, AJO-END-003
- **Purpose:** See a round.
- **Layout (top to bottom):**
  - Round number, recipient, pot, date
  - Contribution list with status
  - Receipt button for my contribution or payout
- **Actions / navigation:** Receipt
- **States and edge cases:** Pending payout; shortfall explanation

### S-AJO-012 - Members and trust (Mobile)
- **Route:** `/ajo/:id/members`  |  **Requirements:** AJO-MEM-003, AJO-DEL-003
- **Purpose:** Roster and trust scores.
- **Layout (top to bottom):**
  - List: avatar, name, slot, trust badge, status
  - Info sheet explaining trust score
- **Actions / navigation:** Report concern
- **States and edge cases:** Defaulted badge

### S-AJO-013 - Report a problem (Mobile)
- **Route:** `/ajo/:id/report`  |  **Requirements:** AJO-PLT-002
- **Purpose:** Report a concern.
- **Layout (top to bottom):**
  - Category, description, evidence upload, submit
- **Actions / navigation:** Submit
- **States and edge cases:** Ticket created confirmation

### S-AJO-014 - Cycle summary and renew (Mobile)
- **Route:** `/ajo/:id/summary`  |  **Requirements:** AJO-END-001
- **Purpose:** Close and renew.
- **Layout (top to bottom):**
  - Totals: contributed, received
  - Trust score change
  - Button: Start a new circle with same group
- **Actions / navigation:** Renew -> S-AJO-002 prefilled
- **States and edge cases:** Default

### W-AJO-001 - Circle management (Web)
- **Route:** `/group/:t/ajo`  |  **Requirements:** AJO-SET-006, AJO-CON-007
- **Purpose:** Organizer dashboard on web.
- **Layout (top to bottom):**
  - Header with status, pot, protection mode
  - Rounds table with paid counts and payout status
  - Members table with status and trust
  - Actions: invite, view terms (no money movement)
- **Actions / navigation:** Invite
- **States and edge cases:** Frozen banner
