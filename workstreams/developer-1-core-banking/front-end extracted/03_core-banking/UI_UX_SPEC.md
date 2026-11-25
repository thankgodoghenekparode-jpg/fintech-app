# UI/UX Specification - Core Banking

Global rules: all text via i18n keys; money via the shared formatter; every screen implements loading (skeleton), empty, error and offline states; minimum tap target 48dp; light and dark themes from tokens; no Zenith logo or icons.

Text key convention: `<group>.<screen>.<element>` (example: `onboarding.phone.title`). The English copy shown here is the default text for the key.


## Onboarding & Auth

### S-CB-001 - Welcome
- **Route:** `/welcome`  |  **Requirements:** CB-ONB-001
- **Purpose:** Introduce the app and start sign-up or login.
- **Layout (top to bottom):**
  - Own logo and short tagline at top
  - 3-slide carousel (Safe, Simple, Yours) with page dots
  - Primary button: Create account
  - Secondary button: Log in
  - Footer: Terms and Privacy links
- **Actions / navigation:** Create account -> S-CB-002; Log in -> S-CB-013
- **States and edge cases:** Default only; offline banner if no network

### S-CB-002 - Phone number
- **Route:** `/signup/phone`  |  **Requirements:** CB-ONB-001
- **Purpose:** Collect and validate phone number.
- **Layout (top to bottom):**
  - Back arrow, progress stepper (1 of 8)
  - Title: What is your phone number?
  - Phone field with +234 prefix
  - Helper: We will send a code by SMS
  - Primary button: Continue (disabled until valid)
- **Actions / navigation:** Continue -> send OTP -> S-CB-003
- **States and edge cases:** Invalid number error; number already registered -> offer Log in; rate-limited error

### S-CB-003 - Verify OTP
- **Route:** `/signup/otp`  |  **Requirements:** CB-ONB-001
- **Purpose:** Verify the SMS code.
- **Layout (top to bottom):**
  - Title and masked phone
  - 6-box OTP input with auto-fill
  - Resend code countdown (60s)
  - Change number link
- **Actions / navigation:** Auto-submit when filled -> S-CB-004; Resend
- **States and edge cases:** Wrong code (shake + message); expired code; too many attempts -> lockout message

### S-CB-004 - Personal details
- **Route:** `/signup/details`  |  **Requirements:** CB-ONB-002, CB-ONB-012
- **Purpose:** Collect name, date of birth, email, optional referral code.
- **Layout (top to bottom):**
  - Stepper (3 of 8)
  - Fields: First name, Last name, Date of birth (picker), Email, Referral code (optional)
  - Note: Names must match your BVN
  - Primary button: Continue
- **Actions / navigation:** Continue -> S-CB-005
- **States and edge cases:** Field-level validation errors; under-age error (minimum age per regulation [CONFIRM WITH ZENITH])

### S-CB-005 - Terms and privacy consent
- **Route:** `/signup/consent`  |  **Requirements:** CB-ONB-002
- **Purpose:** Capture versioned consent.
- **Layout (top to bottom):**
  - Title: Before we continue
  - Expandable summaries: Terms, Privacy, Data use
  - Required checkboxes (not pre-ticked)
  - Links to full documents
  - Primary button: I agree and continue
- **Actions / navigation:** Agree -> S-CB-006
- **States and edge cases:** Button disabled until required boxes ticked

### S-CB-006 - BVN verification
- **Route:** `/signup/bvn`  |  **Requirements:** CB-ONB-003
- **Purpose:** Verify identity via BVN.
- **Layout (top to bottom):**
  - Stepper (5 of 8)
  - Title: Verify your identity
  - BVN field (11 digits) with info icon explaining why
  - Privacy note: We only use this to verify who you are
  - Primary button: Verify
- **Actions / navigation:** Verify -> S-CB-007
- **States and edge cases:** Invalid BVN; mismatch with entered details (explain, allow edit); provider down -> retry later

### S-CB-007 - NIN verification
- **Route:** `/signup/nin`  |  **Requirements:** CB-ONB-004
- **Purpose:** Verify NIN.
- **Layout (top to bottom):**
  - Stepper (6 of 8)
  - NIN field (11 digits)
  - Info link: Where do I find my NIN?
  - Primary button: Continue
- **Actions / navigation:** Continue -> S-CB-008
- **States and edge cases:** Invalid NIN; mismatch; provider down

### S-CB-008 - Selfie and liveness
- **Route:** `/signup/selfie`  |  **Requirements:** CB-ONB-005
- **Purpose:** Capture a live selfie to match ID.
- **Layout (top to bottom):**
  - Stepper (7 of 8)
  - Camera view with oval guide
  - Instructions: Good light, no hat or glasses
  - Live prompts (blink, turn head)
  - Capture progress ring
- **Actions / navigation:** Auto-capture -> S-CB-009
- **States and edge cases:** Camera permission denied (explain + settings link); liveness failed (retry up to 3); mismatch -> manual review message

### S-CB-009 - Create passcode
- **Route:** `/signup/passcode`  |  **Requirements:** CB-ONB-006, CB-SEC-001
- **Purpose:** Create the login passcode.
- **Layout (top to bottom):**
  - Title: Create your login passcode
  - 6-digit PinPad with dots
  - Confirm passcode on second pass
  - Tip: avoid birthdays or repeated digits
- **Actions / navigation:** Confirm -> S-CB-010
- **States and edge cases:** Mismatch; weak passcode rejected

### S-CB-010 - Create transaction PIN
- **Route:** `/signup/pin`  |  **Requirements:** CB-ONB-006, CB-SEC-003
- **Purpose:** Create the PIN that approves money movement.
- **Layout (top to bottom):**
  - Title: Create your transaction PIN
  - 4-digit PinPad with dots
  - Confirm on second pass
  - Note: Different from your passcode
- **Actions / navigation:** Confirm -> S-CB-011
- **States and edge cases:** Mismatch; same as passcode rejected

### S-CB-011 - Enable biometrics
- **Route:** `/signup/biometrics`  |  **Requirements:** CB-SEC-001
- **Purpose:** Offer fingerprint/face unlock.
- **Layout (top to bottom):**
  - Illustration
  - Title: Unlock faster
  - Primary: Enable biometrics
  - Secondary: Not now
- **Actions / navigation:** Enable -> OS prompt -> S-CB-012; Not now -> S-CB-012
- **States and edge cases:** Biometrics unavailable -> skip silently

### S-CB-012 - Account created
- **Route:** `/signup/done`  |  **Requirements:** CB-ONB-007
- **Purpose:** Confirm account and show account number.
- **Layout (top to bottom):**
  - Success animation (short)
  - Title: You are all set, <FirstName>
  - Account card: account name, account number with Copy, 'Account held at our foundation bank'
  - Primary: Go to Home
  - Secondary: Add money
- **Actions / navigation:** Go to Home -> S-CB-020; Add money -> S-CB-024
- **States and edge cases:** Account generation delayed -> 'Setting up your account' with auto-refresh

### S-CB-013 - Login
- **Route:** `/login`  |  **Requirements:** CB-SEC-001
- **Purpose:** Returning user login.
- **Layout (top to bottom):**
  - Greeting with first name and initials avatar
  - Passcode PinPad with biometric key
  - Link: Forgot passcode
  - Link: Not you? Switch account
- **Actions / navigation:** Success -> S-CB-020; Forgot -> S-CB-015
- **States and edge cases:** Wrong passcode (attempt counter); locked after limit -> S-CB-094; new device -> S-CB-014

### S-CB-014 - New device verification
- **Route:** `/login/new-device`  |  **Requirements:** CB-SEC-002
- **Purpose:** Verify a new device.
- **Layout (top to bottom):**
  - Title: Verify this device
  - OTP input
  - Then selfie liveness step
  - Note explaining why
- **Actions / navigation:** Verified -> S-CB-020
- **States and edge cases:** Failed verification; device limit reached

### S-CB-015 - Reset passcode
- **Route:** `/login/reset`  |  **Requirements:** CB-SEC-001
- **Purpose:** Reset forgotten passcode safely.
- **Layout (top to bottom):**
  - Steps: OTP -> BVN last digits or selfie -> new passcode
  - Stepper
  - Warning: money actions locked 24h after reset (configurable)
- **Actions / navigation:** Done -> S-CB-013
- **States and edge cases:** Failed verification; rate limit


## Home

### S-CB-020 - Home
- **Route:** `/home`  |  **Requirements:** CB-ACC-002, CB-ACC-003, CB-SAV-001
- **Purpose:** Daily dashboard.
- **Layout (top to bottom):**
  - Top bar: avatar/initials, greeting, notification bell with badge
  - Balance block: label 'Available balance', big amount, eye toggle to hide
  - Quick actions row (5): Send, Airtime & Bills, Add money, Cards, Savings
  - Card carousel (virtual cards) with 'Create card' tile
  - Optional promo/tip banner (dismissible)
  - Recent activity: 5 TransactionRows + See all
- **Actions / navigation:** Quick actions -> respective flows; Row tap -> S-CB-022; Bell -> S-CB-021
- **States and edge cases:** Skeleton while loading; empty activity state; balance error -> retry; offline cached with 'Last updated'

### S-CB-021 - Notification centre
- **Route:** `/notifications`  |  **Requirements:** CB-NOT-002
- **Purpose:** List notifications.
- **Layout (top to bottom):**
  - Title bar with 'Mark all read'
  - Grouped list (Today, Earlier): icon, title, body, time, unread dot
- **Actions / navigation:** Tap -> deep link to the item
- **States and edge cases:** Empty state; load more

### S-CB-022 - Transaction detail
- **Route:** `/transactions/:id`  |  **Requirements:** CB-ACC-003, CB-TRF-005
- **Purpose:** Show one transaction.
- **Layout (top to bottom):**
  - Amount large with +/- and StatusChip
  - Rows: Counterparty, Bank, Narration, Fee, Reference, Date/time, Balance after
  - Buttons: View receipt, Report a problem, Save beneficiary (if debit)
- **Actions / navigation:** Receipt -> S-CB-023; Report -> S-CB-079
- **States and edge cases:** Pending explanation text; failed with reason; reversed with link to the reversal

### S-CB-023 - Receipt
- **Route:** `/transactions/:id/receipt`  |  **Requirements:** CB-TRF-008
- **Purpose:** Shareable receipt.
- **Layout (top to bottom):**
  - Branded receipt layout (see component spec)
  - Buttons: Share (image/PDF), Download, Done
- **Actions / navigation:** Share via OS sheet
- **States and edge cases:** Generating state; share failed toast

### S-CB-024 - Add money
- **Route:** `/add-money`  |  **Requirements:** CB-FUN-001, CB-FUN-002, CB-FUN-004
- **Purpose:** Choose how to fund account.
- **Layout (top to bottom):**
  - Own account number card with Copy and Share
  - Options list: Bank transfer, Card top-up, USSD, Cash deposit at an agent
  - Info: transfers arrive instantly, any bank
- **Actions / navigation:** Card top-up -> card flow; Agent -> locator
- **States and edge cases:** Option hidden if not enabled; card top-up error handling

### S-CB-025 - Account details
- **Route:** `/account-details`  |  **Requirements:** CB-ACC-006
- **Purpose:** Share account details.
- **Layout (top to bottom):**
  - Name, number, bank name, tier
  - Buttons: Copy, Share as text, Share as image
- **Actions / navigation:** Share
- **States and edge cases:** Default


## Payments

### S-CB-030 - Payments hub
- **Route:** `/payments`  |  **Requirements:** CB-TRF-001
- **Purpose:** Entry for all payment tasks.
- **Layout (top to bottom):**
  - Search recipients/billers
  - Grid of actions: Send to bank, Send to saved, Request money, Scan QR, Airtime & data, Bills, Scheduled, Dues & Levies (Stage 2)
  - Recent recipients row
  - Link: Transaction history
- **Actions / navigation:** Each action -> its flow
- **States and edge cases:** Empty recipients state

### S-CB-031 - Send: choose recipient
- **Route:** `/send/recipient`  |  **Requirements:** CB-TRF-002, CB-TRF-003
- **Purpose:** Pick or enter recipient.
- **Layout (top to bottom):**
  - Tabs: New / Saved
  - New: bank selector (searchable), account number (10 digits)
  - Name enquiry result appears under the number (green check + account name)
  - Saved: list with favourites
- **Actions / navigation:** Continue -> S-CB-032
- **States and edge cases:** Name enquiry loading, failed, wrong number; same-platform detection shows 'Instant, free'

### S-CB-032 - Send: amount
- **Route:** `/send/amount`  |  **Requirements:** CB-TRF-004, CB-TRF-012, CB-TRF-013
- **Purpose:** Enter amount and narration.
- **Layout (top to bottom):**
  - Recipient chip with name and bank
  - AmountInput with quick chips
  - Available balance and remaining daily limit hint
  - Narration field (optional)
  - Primary: Continue
- **Actions / navigation:** Continue -> quote -> S-CB-033
- **States and edge cases:** Insufficient funds; above per-transaction/daily limit with 'Upgrade' link

### S-CB-033 - Send: confirm
- **Route:** `/send/confirm`  |  **Requirements:** CB-TRF-004
- **Purpose:** Review before PIN.
- **Layout (top to bottom):**
  - ConfirmSheet: To, Bank, Amount, Fee, Total, Narration
  - Checkbox: Save as beneficiary
  - Primary: Confirm
- **Actions / navigation:** Confirm -> S-CB-034
- **States and edge cases:** Quote expired -> refresh

### S-CB-034 - PIN entry
- **Route:** `(sheet)`  |  **Requirements:** CB-SEC-003
- **Purpose:** Authorise with PIN or biometric.
- **Layout (top to bottom):**
  - Sheet with PinPad, biometric key, forgot PIN link
- **Actions / navigation:** Success -> submit -> S-CB-035
- **States and edge cases:** Wrong PIN attempts; locked after limit; step-up OTP/selfie when required

### S-CB-035 - Processing and result
- **Route:** `/send/result`  |  **Requirements:** CB-TRF-005, CB-TRF-006, CB-TRF-007
- **Purpose:** Show outcome.
- **Layout (top to bottom):**
  - Processing: animation and 'Sending...'
  - Success: green check, amount, recipient, buttons View receipt / Done / Send again
  - Pending: amber, 'Your transfer is being confirmed. We will notify you.' button View status
  - Failed: red, plain reason, buttons Try again / Contact support
- **Actions / navigation:** View receipt -> S-CB-023
- **States and edge cases:** Long processing >8s message; app killed mid-flight -> status found in history

### S-CB-036 - Beneficiaries
- **Route:** `/beneficiaries`  |  **Requirements:** CB-TRF-003
- **Purpose:** Manage saved recipients.
- **Layout (top to bottom):**
  - Search
  - List with favourite star, rename, delete (swipe or menu)
  - Add beneficiary button
- **Actions / navigation:** Tap -> S-CB-032 prefilled
- **States and edge cases:** Empty state; delete confirmation

### S-CB-037 - Scheduled payments
- **Route:** `/scheduled`  |  **Requirements:** CB-TRF-009, CB-BIL-005
- **Purpose:** List and create scheduled/recurring payments.
- **Layout (top to bottom):**
  - List with next run date, amount, status, toggle
  - Create: recipient/biller, amount, frequency (once, daily, weekly, monthly), start date, end
  - Warning: ensure funds are available on the date
- **Actions / navigation:** Create/Edit/Pause/Delete
- **States and edge cases:** Empty; failed run shows reason and retry option

### S-CB-038 - Request money
- **Route:** `/request`  |  **Requirements:** CB-TRF-010
- **Purpose:** Create a payment request/link.
- **Layout (top to bottom):**
  - Amount, note, optional expiry
  - Generated link and QR with Share
  - List of requests with status
- **Actions / navigation:** Share link
- **States and edge cases:** Expired; paid

### S-CB-039 - QR scan and pay
- **Route:** `/qr`  |  **Requirements:** CB-TRF-011
- **Purpose:** Scan or show QR.
- **Layout (top to bottom):**
  - Tabs: Scan / My QR
  - Camera view with frame
  - After scan: merchant name and amount (or enter) -> confirm flow
- **Actions / navigation:** Confirm -> S-CB-033
- **States and edge cases:** Camera denied; invalid QR; unsupported QR

### S-CB-040 - Airtime and data
- **Route:** `/airtime`  |  **Requirements:** CB-BIL-001
- **Purpose:** Buy airtime or data.
- **Layout (top to bottom):**
  - Tabs: Airtime / Data
  - Network selector (auto-detect from number)
  - Phone number (own number shortcut, contacts)
  - Amount chips or data plan list
  - Primary: Continue -> confirm -> PIN
- **Actions / navigation:** Continue -> S-CB-033 (generic confirm)
- **States and edge cases:** Invalid number; plan list failed; vend failed -> automatic refund message

### S-CB-041 - Bills: categories
- **Route:** `/bills`  |  **Requirements:** CB-BIL-002
- **Purpose:** Choose bill type.
- **Layout (top to bottom):**
  - Search
  - Category grid: Electricity, Cable TV, Internet, Education, Others
  - Saved billers section
- **Actions / navigation:** Tap category -> biller list -> S-CB-042
- **States and edge cases:** Biller list loading/error

### S-CB-042 - Bills: pay
- **Route:** `/bills/pay`  |  **Requirements:** CB-BIL-003, CB-BIL-004
- **Purpose:** Validate customer and pay.
- **Layout (top to bottom):**
  - Biller name, package selector
  - Meter/decoder number with Validate (shows customer name)
  - Amount (or package amount)
  - Save biller toggle, Schedule toggle
  - Continue -> confirm -> PIN -> token/receipt
- **Actions / navigation:** Pay
- **States and edge cases:** Validation failed; token shown with Copy; vend failed with auto-refund

### S-CB-043 - Transaction history
- **Route:** `/history`  |  **Requirements:** CB-ACC-003
- **Purpose:** Search and filter transactions.
- **Layout (top to bottom):**
  - Search field, filter chips (type, status, date range)
  - Grouped list by date with TransactionRows
  - Export statement link
- **Actions / navigation:** Row -> S-CB-022
- **States and edge cases:** Empty results; pagination loader


## Cards

### S-CB-050 - Cards home
- **Route:** `/cards`  |  **Requirements:** CB-CRD-001
- **Purpose:** List cards.
- **Layout (top to bottom):**
  - Vertical carousel of CardViews
  - Per-card quick toggles: Freeze, Details
  - 'Create card' tile
- **Actions / navigation:** Tap card -> S-CB-051; Create -> S-CB-052
- **States and edge cases:** Empty: invite to create first card; card list error

### S-CB-051 - Card detail
- **Route:** `/cards/:id`  |  **Requirements:** CB-CRD-003, CB-CRD-006
- **Purpose:** Manage one card.
- **Layout (top to bottom):**
  - Large CardView
  - Action row: Freeze, Show details, Limits, Alerts
  - Recent card transactions
  - Menu: Rename, Change theme, Delete
- **Actions / navigation:** Show details -> S-CB-054; Limits -> S-CB-053
- **States and edge cases:** Frozen overlay; expired; delete confirm dialog

### S-CB-052 - Create card
- **Route:** `/cards/new`  |  **Requirements:** CB-CRD-001, CB-CRD-002
- **Purpose:** Create a virtual naira card.
- **Layout (top to bottom):**
  - Step 1: Name the card
  - Step 2: Choose theme (live preview)
  - Step 3: Optional spend limit
  - Review + PIN -> success
- **Actions / navigation:** Create
- **States and edge cases:** Create failed -> retry; card creation fee shown if any [CONFIRM WITH ZENITH]

### S-CB-053 - Card limits
- **Route:** `/cards/:id/limits`  |  **Requirements:** CB-CRD-004
- **Purpose:** Set card limits.
- **Layout (top to bottom):**
  - Per-transaction and daily limits with sliders and numeric fields
  - Cannot exceed account tier limits (hint)
- **Actions / navigation:** Save with PIN
- **States and edge cases:** Validation errors

### S-CB-054 - Reveal card details
- **Route:** `/cards/:id/details`  |  **Requirements:** CB-CRD-005
- **Purpose:** Show full details securely.
- **Layout (top to bottom):**
  - Requires PIN/biometric first
  - Number, expiry, CVV with Copy buttons
  - Auto-hide countdown (30s)
  - Screen capture blocked
- **Actions / navigation:** Copy
- **States and edge cases:** Auth failed; timed out

### S-CB-055 - Card alerts and settings
- **Route:** `/cards/:id/settings`  |  **Requirements:** CB-CRD-006
- **Purpose:** Control alerts.
- **Layout (top to bottom):**
  - Toggles: Push alerts, SMS alerts, Online purchases, International (v2)
- **Actions / navigation:** Toggle
- **States and edge cases:** Default


## Save & Borrow

### S-CB-060 - Save & Borrow landing
- **Route:** `/save-borrow`  |  **Requirements:** CB-SAV-001
- **Purpose:** Entry to savings and borrowing products.
- **Layout (top to bottom):**
  - Header summary (total saved if any)
  - Product cards (each independent): Target Savings, Group Savings (Cooperatives, Ajo/Esusu), Pay Am Small, Borrow, Escrow
  - Each card: icon, title, one-line benefit, 'Open'
- **Actions / navigation:** Open -> product home (Stage 2)
- **States and edge cases:** Products not enabled are hidden by feature flag


## More

### S-CB-070 - More
- **Route:** `/more`  |  **Requirements:** CB-SET-001
- **Purpose:** Account and settings hub.
- **Layout (top to bottom):**
  - Profile header with tier badge
  - Groups: Profile & KYC, Security, Limits, Statements, Help & Support, Legal, Locator
  - Tenant switcher row (if user manages a tenant, Stage 2)
  - Log out
- **Actions / navigation:** Rows -> screens
- **States and edge cases:** Default

### S-CB-071 - Profile
- **Route:** `/more/profile`  |  **Requirements:** CB-SET-001
- **Purpose:** View/edit contact details.
- **Layout (top to bottom):**
  - Avatar, name (read-only after KYC), phone, email (editable with verification), address
  - Edit via OTP step-up
- **Actions / navigation:** Save
- **States and edge cases:** Validation; verification pending

### S-CB-072 - KYC status and upgrade
- **Route:** `/more/kyc`  |  **Requirements:** CB-ONB-008, CB-ONB-009
- **Purpose:** Show tier and upgrade path.
- **Layout (top to bottom):**
  - Current tier card with limits
  - Next tier requirements checklist (address proof, extra ID)
  - Upload steps with progress
  - Submit
- **Actions / navigation:** Submit -> pending review
- **States and edge cases:** Pending review; rejected with reason and retry

### S-CB-073 - Security hub
- **Route:** `/more/security`  |  **Requirements:** CB-SET-002, CB-SEC-006
- **Purpose:** Manage security.
- **Layout (top to bottom):**
  - Rows: Change passcode, Change PIN, Biometrics toggle, Manage devices, Lock my account
  - Security tips banner
- **Actions / navigation:** Rows -> flows
- **States and edge cases:** Lock account confirmation dialog

### S-CB-074 - Devices
- **Route:** `/more/devices`  |  **Requirements:** CB-SEC-002
- **Purpose:** List and remove devices.
- **Layout (top to bottom):**
  - List: device name, last used, location (approximate), current device badge
  - Remove button with confirm and PIN
- **Actions / navigation:** Remove
- **States and edge cases:** Cannot remove current device message

### S-CB-075 - Limits
- **Route:** `/more/limits`  |  **Requirements:** CB-SET-003
- **Purpose:** Show limits by tier.
- **Layout (top to bottom):**
  - Current limits (per transaction, daily, balance cap) with progress used today
  - Upgrade CTA
- **Actions / navigation:** Upgrade -> S-CB-072
- **States and edge cases:** Default

### S-CB-076 - Statements
- **Route:** `/more/statements`  |  **Requirements:** CB-ACC-005, CB-SET-004
- **Purpose:** Request statements.
- **Layout (top to bottom):**
  - Date range selector, format PDF
  - Buttons: Download, Email to me
  - Past requests list
- **Actions / navigation:** Request
- **States and edge cases:** Generating; failed; large range warning

### S-CB-077 - Help centre
- **Route:** `/help`  |  **Requirements:** CB-SUP-001, CB-SUP-005
- **Purpose:** Self-service help.
- **Layout (top to bottom):**
  - Search
  - Popular topics list
  - Contact options: Chat, Call, Email
  - Regulator escalation info section
- **Actions / navigation:** Chat -> S-CB-078
- **States and edge cases:** Search no results -> contact options

### S-CB-078 - Support chat
- **Route:** `/help/chat`  |  **Requirements:** CB-SUP-002
- **Purpose:** Chat with a human agent.
- **Layout (top to bottom):**
  - Message list, attachments (images), typing indicator, agent name
  - Context chip: linked transaction/ticket if any
- **Actions / navigation:** Send message/attachment
- **States and edge cases:** Offline queue; agent unavailable -> create ticket

### S-CB-079 - Report a problem
- **Route:** `/transactions/:id/report`  |  **Requirements:** CB-SUP-003
- **Purpose:** Report an issue with a transaction.
- **Layout (top to bottom):**
  - Reason picker (Not received, Charged but failed, Wrong amount, Unauthorised, Other)
  - Description, attachments
  - Submit
- **Actions / navigation:** Submit -> ticket created
- **States and edge cases:** Success with ticket number and expected response time

### S-CB-080 - Complaints and tickets
- **Route:** `/help/tickets`  |  **Requirements:** CB-SUP-004
- **Purpose:** Track complaints.
- **Layout (top to bottom):**
  - List of tickets with status chips and last update
  - Detail: timeline, messages, reply box
- **Actions / navigation:** Open ticket
- **States and edge cases:** Empty state

### S-CB-081 - Legal and consent
- **Route:** `/more/legal`  |  **Requirements:** CB-SET-005
- **Purpose:** Read documents and manage consents.
- **Layout (top to bottom):**
  - List: Terms, Privacy, Fee schedule, Data use
  - Consent toggles for optional processing (marketing, analytics)
- **Actions / navigation:** Toggle consent
- **States and edge cases:** Version and date shown for each document

### S-CB-082 - Branch and agent locator
- **Route:** `/locator`  |  **Requirements:** CB-SET-006
- **Purpose:** Find branches/agents.
- **Layout (top to bottom):**
  - Map with pins, search, list toggle
  - Detail card: address, hours, directions
- **Actions / navigation:** Directions
- **States and edge cases:** Location permission denied -> manual search

### S-CB-083 - Close account
- **Route:** `/more/close-account`  |  **Requirements:** CB-SET-007
- **Purpose:** Request account closure.
- **Layout (top to bottom):**
  - Explanation of what happens
  - Checklist: zero balance, no active plans/loans
  - Reason picker, confirm with PIN
- **Actions / navigation:** Submit request
- **States and edge cases:** Blocked with reasons; submitted confirmation


## System

### S-CB-090 - Offline
- **Route:** `(overlay)`  |  **Requirements:** NFR-005
- **Purpose:** Handle no connection.
- **Layout (top to bottom):**
  - Banner: You are offline
  - Cached data where safe
  - Money actions disabled with explanation
- **Actions / navigation:** Retry
- **States and edge cases:** Default

### S-CB-091 - Maintenance
- **Route:** `/maintenance`  |  **Requirements:** NFR-004
- **Purpose:** Planned downtime message.
- **Layout (top to bottom):**
  - Illustration, message, expected time, status link
- **Actions / navigation:** Retry
- **States and edge cases:** Default

### S-CB-092 - Force update
- **Route:** `/update`  |  **Requirements:** NFR-005
- **Purpose:** Require update.
- **Layout (top to bottom):**
  - Message, Update button to store
- **Actions / navigation:** Update
- **States and edge cases:** Default

### S-CB-093 - Session locked
- **Route:** `/lock`  |  **Requirements:** CB-SEC-005
- **Purpose:** Re-authenticate after inactivity.
- **Layout (top to bottom):**
  - Passcode/biometric prompt, Log out link
- **Actions / navigation:** Unlock
- **States and edge cases:** Default

### S-CB-094 - Account locked or restricted
- **Route:** `/account-locked`  |  **Requirements:** CB-SEC-006
- **Purpose:** Explain lock/restriction.
- **Layout (top to bottom):**
  - Reason (self-lock, security, compliance hold), what to do, Contact support button, Unlock steps if self-lock
- **Actions / navigation:** Contact support / Unlock
- **States and edge cases:** Default
