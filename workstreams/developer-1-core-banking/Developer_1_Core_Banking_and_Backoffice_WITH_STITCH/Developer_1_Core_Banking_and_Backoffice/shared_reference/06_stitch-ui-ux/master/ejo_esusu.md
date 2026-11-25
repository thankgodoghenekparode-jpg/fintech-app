# Stitch Prompts - Ajo / Esusu

Paste the master brief and tokens first (`../../00_START_HERE_STITCH.md`). One prompt per screen. Mobile frames 390x844, web frames 1440x900.

## S-AJO-001 - Ajo home

```text
Design the "Ajo home" screen of the YourApp banking product "Ajo / Esusu" (390 x 844 mobile, light mode), following the master design brief and tokens.
Purpose: List my circles and entry points.
Layout, top to bottom:
- Header: Ajo / Esusu
- Active circle cards: name, my slot, next due, next payout date
- Buttons: Create circle, Join with code
- Empty state explaining how it works in three short steps
Navigation: Open -> S-AJO-005; Create -> S-AJO-002; Join -> S-AJO-004.
Also show or consider: Empty; load error; pending joins.
Rules: neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; calm uncluttered layout; consistent with all previous screens.
```

## S-AJO-002 - Create circle

```text
Design the "Create circle" screen of the YourApp banking product "Ajo / Esusu" (390 x 844 mobile, light mode), following the master design brief and tokens.
Purpose: Create a circle.
Layout, top to bottom:
- Stepper: Basics, Protection, Order, Review
- Basics: name, amount per round, frequency, slots, start date; computed pot and duration shown
- Protection: choose PROTECTED or SAFEGUARDS_ONLY with plain explanation of each and who carries risk
- Order: random draw, members choose, or organizer-set with consent
- Review summary and Create
Navigation: Create -> S-AJO-003.
Also show or consider: Trust-level cap exceeded message; validation errors.
Rules: neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; calm uncluttered layout; consistent with all previous screens.
```

## S-AJO-003 - Invite members

```text
Design the "Invite members" screen of the YourApp banking product "Ajo / Esusu" (390 x 844 mobile, light mode), following the master design brief and tokens.
Purpose: Share the invite.
Layout, top to bottom:
- Invite link and code with Copy and Share (WhatsApp, SMS)
- Roster of joined vs open slots
- Readiness checklist (slots filled, terms accepted, auto-debit set, cover provided)
Navigation: Share.
Also show or consider: Circle not ready banner.
Rules: neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; calm uncluttered layout; consistent with all previous screens.
```

## S-AJO-004 - Join circle

```text
Design the "Join circle" screen of the YourApp banking product "Ajo / Esusu" (390 x 844 mobile, light mode), following the master design brief and tokens.
Purpose: Review and join.
Layout, top to bottom:
- Circle summary: amount, frequency, slots, pot, start date, protection mode
- Plain-language terms summary and full text link
- Required checkbox to accept
- Button: Join
Navigation: Join -> S-AJO-008 or S-AJO-007.
Also show or consider: Circle full; ineligible by trust level; invalid code.
Rules: neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; calm uncluttered layout; consistent with all previous screens.
```

## S-AJO-005 - Circle detail

```text
Design the "Circle detail" screen of the YourApp banking product "Ajo / Esusu" (390 x 844 mobile, light mode), following the master design brief and tokens.
Purpose: Live tracker.
Layout, top to bottom:
- Header: name, status chip, pot size
- Timeline of rounds with recipient and status
- Current round: who has paid (avatars with ticks), countdown to due date and payout
- My position and next due
Navigation: Round tap -> S-AJO-011.
Also show or consider: Shortfall banner; frozen banner.
Rules: neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; calm uncluttered layout; consistent with all previous screens.
```

## S-AJO-006 - My schedule

```text
Design the "My schedule" screen of the YourApp banking product "Ajo / Esusu" (390 x 844 mobile, light mode), following the master design brief and tokens.
Purpose: See my due dates and slot.
Layout, top to bottom:
- My payout slot and date
- List of my contributions with status
- Auto-debit toggle status
Navigation: Pay now -> S-AJO-007.
Also show or consider: Overdue highlighted.
Rules: neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; calm uncluttered layout; consistent with all previous screens.
```

## S-AJO-007 - Pay or set up auto-debit

```text
Design the "Pay or set up auto-debit" screen of the YourApp banking product "Ajo / Esusu" (390 x 844 mobile, light mode), following the master design brief and tokens.
Purpose: Pay early or enable auto-debit.
Layout, top to bottom:
- Amount due and date
- Auto-debit consent toggle (required in some cases) with explanation
- Confirm sheet -> PIN
Navigation: Confirm.
Also show or consider: Insufficient funds; success/pending.
Rules: neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; calm uncluttered layout; consistent with all previous screens.
```

## S-AJO-008 - Protection setup

```text
Design the "Protection setup" screen of the YourApp banking product "Ajo / Esusu" (390 x 844 mobile, light mode), following the master design brief and tokens.
Purpose: Provide cover.
Layout, top to bottom:
- Choice: Guarantor or Security deposit
- Guarantor: search and send request; Deposit: amount and hold explanation
- Status of cover
Navigation: Send request / Fund deposit.
Also show or consider: Guarantor declined; insufficient balance.
Rules: neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; calm uncluttered layout; consistent with all previous screens.
```

## S-AJO-009 - Guarantor request

```text
Design the "Guarantor request" screen of the YourApp banking product "Ajo / Esusu" (390 x 844 mobile, light mode), following the master design brief and tokens.
Purpose: Guarantor reviews and accepts.
Layout, top to bottom:
- Member name, circle, maximum amount guaranteed
- Amount that will be held
- Plain agreement summary and full text
- Buttons: Accept (PIN), Decline
Navigation: Accept/Decline.
Also show or consider: Expired; insufficient free balance.
Rules: neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; calm uncluttered layout; consistent with all previous screens.
```

## S-AJO-010 - Payout order draw

```text
Design the "Payout order draw" screen of the YourApp banking product "Ajo / Esusu" (390 x 844 mobile, light mode), following the master design brief and tokens.
Purpose: Draw or choose slots.
Layout, top to bottom:
- Random draw: Draw button with transparent result list and verification note
- Choose: slot picker with conflicts resolved by rule
- Locked notice once confirmed
Navigation: Confirm order.
Also show or consider: Waiting for members.
Rules: neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; calm uncluttered layout; consistent with all previous screens.
```

## S-AJO-011 - Round detail and payout

```text
Design the "Round detail and payout" screen of the YourApp banking product "Ajo / Esusu" (390 x 844 mobile, light mode), following the master design brief and tokens.
Purpose: See a round.
Layout, top to bottom:
- Round number, recipient, pot, date
- Contribution list with status
- Receipt button for my contribution or payout
Navigation: Receipt.
Also show or consider: Pending payout; shortfall explanation.
Rules: neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; calm uncluttered layout; consistent with all previous screens.
```

## S-AJO-012 - Members and trust

```text
Design the "Members and trust" screen of the YourApp banking product "Ajo / Esusu" (390 x 844 mobile, light mode), following the master design brief and tokens.
Purpose: Roster and trust scores.
Layout, top to bottom:
- List: avatar, name, slot, trust badge, status
- Info sheet explaining trust score
Navigation: Report concern.
Also show or consider: Defaulted badge.
Rules: neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; calm uncluttered layout; consistent with all previous screens.
```

## S-AJO-013 - Report a problem

```text
Design the "Report a problem" screen of the YourApp banking product "Ajo / Esusu" (390 x 844 mobile, light mode), following the master design brief and tokens.
Purpose: Report a concern.
Layout, top to bottom:
- Category, description, evidence upload, submit
Navigation: Submit.
Also show or consider: Ticket created confirmation.
Rules: neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; calm uncluttered layout; consistent with all previous screens.
```

## S-AJO-014 - Cycle summary and renew

```text
Design the "Cycle summary and renew" screen of the YourApp banking product "Ajo / Esusu" (390 x 844 mobile, light mode), following the master design brief and tokens.
Purpose: Close and renew.
Layout, top to bottom:
- Totals: contributed, received
- Trust score change
- Button: Start a new circle with same group
Navigation: Renew -> S-AJO-002 prefilled.
Also show or consider: Default.
Rules: neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; calm uncluttered layout; consistent with all previous screens.
```

## W-AJO-001 - Circle management

```text
Design the "Circle management" screen of the YourApp banking product "Ajo / Esusu" (1440 x 900 web dashboard, light mode), following the master design brief and tokens.
Purpose: Organizer dashboard on web.
Layout, top to bottom:
- Header with status, pot, protection mode
- Rounds table with paid counts and payout status
- Members table with status and trust
- Actions: invite, view terms (no money movement)
Navigation: Invite.
Also show or consider: Frozen banner.
Rules: neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; calm uncluttered layout; consistent with all previous screens.
```
