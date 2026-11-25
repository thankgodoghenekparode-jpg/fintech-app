# Stitch Prompts - Target Savings

Paste the master brief and tokens first (`../../00_START_HERE_STITCH.md`). One prompt per screen. Mobile frames 390x844, web frames 1440x900.

## S-TGT-001 - Target Savings home

```text
Design the "Target Savings home" screen of the YourApp banking product "Target Savings" (390 x 844 mobile, light mode), following the master design brief and tokens.
Purpose: List goals.
Layout, top to bottom:
- Header with total saved across goals
- Goal cards: name, theme, progress ring, saved/target, days left, mode badge
- Button: New goal
- Empty state with a simple example
Navigation: Open -> S-TGT-003; New -> S-TGT-002.
Also show or consider: Empty; load error.
Rules: neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; calm uncluttered layout; consistent with all previous screens.
```

## S-TGT-002 - Create goal

```text
Design the "Create goal" screen of the YourApp banking product "Target Savings" (390 x 844 mobile, light mode), following the master design brief and tokens.
Purpose: Create a goal in steps.
Layout, top to bottom:
- Stepper: Goal, Plan, Mode, Funding, Review
- Goal: name, target amount, theme
- Plan: deadline or contribution; live calculation
- Mode: Flexible or Locked with penalty shown plainly
- Funding: auto-save toggle and first deposit
- Review and PIN
Navigation: Create -> S-TGT-003.
Also show or consider: Validation; limit on number of goals.
Rules: neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; calm uncluttered layout; consistent with all previous screens.
```

## S-TGT-003 - Goal detail

```text
Design the "Goal detail" screen of the YourApp banking product "Target Savings" (390 x 844 mobile, light mode), following the master design brief and tokens.
Purpose: Track one goal.
Layout, top to bottom:
- Big progress ring with saved amount and target
- Remaining amount and days left
- Buttons: Add money, Withdraw, Edit
- Auto-save status with next run
- History list
Navigation: Add -> S-TGT-004; Withdraw -> S-TGT-006.
Also show or consider: Paused; matured; closed.
Rules: neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; calm uncluttered layout; consistent with all previous screens.
```

## S-TGT-004 - Add money

```text
Design the "Add money" screen of the YourApp banking product "Target Savings" (390 x 844 mobile, light mode), following the master design brief and tokens.
Purpose: Top up a goal.
Layout, top to bottom:
- AmountInput with quick chips
- Source: main account balance
- Confirm sheet -> PIN
Navigation: Confirm.
Also show or consider: Insufficient funds; success moment with milestone if reached.
Rules: neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; calm uncluttered layout; consistent with all previous screens.
```

## S-TGT-005 - Auto-save setup

```text
Design the "Auto-save setup" screen of the YourApp banking product "Target Savings" (390 x 844 mobile, light mode), following the master design brief and tokens.
Purpose: Set schedule.
Layout, top to bottom:
- Frequency, amount, start date
- Consent explanation and toggle
- Preview of when the goal will be reached
Navigation: Save with PIN.
Also show or consider: Funds-short warning.
Rules: neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; calm uncluttered layout; consistent with all previous screens.
```

## S-TGT-006 - Withdraw

```text
Design the "Withdraw" screen of the YourApp banking product "Target Savings" (390 x 844 mobile, light mode), following the master design brief and tokens.
Purpose: Withdraw with clarity.
Layout, top to bottom:
- Amount (full or partial where allowed)
- Summary: gross, penalty or fee, net
- Message encouraging keeping the goal when early
- Confirm with PIN; optional cooling-off notice
Navigation: Confirm.
Also show or consider: Cooling-off active; blocked partial withdrawals per rule.
Rules: neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; calm uncluttered layout; consistent with all previous screens.
```

## S-TGT-007 - Edit, pause or close

```text
Design the "Edit, pause or close" screen of the YourApp banking product "Target Savings" (390 x 844 mobile, light mode), following the master design brief and tokens.
Purpose: Manage a goal.
Layout, top to bottom:
- Edit name, theme, target
- Pause auto-save
- Close goal with return-of-funds summary
Navigation: Save / Close.
Also show or consider: Extension rule messages.
Rules: neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; calm uncluttered layout; consistent with all previous screens.
```

## S-TGT-008 - What-if calculator

```text
Design the "What-if calculator" screen of the YourApp banking product "Target Savings" (390 x 844 mobile, light mode), following the master design brief and tokens.
Purpose: Explore plans.
Layout, top to bottom:
- Sliders for contribution and date
- Live result: new end date or required amount
Navigation: Apply plan.
Also show or consider: Default.
Rules: neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; calm uncluttered layout; consistent with all previous screens.
```

## S-TGT-009 - Save rules

```text
Design the "Save rules" screen of the YourApp banking product "Target Savings" (390 x 844 mobile, light mode), following the master design brief and tokens.
Purpose: Percent-of-credit saving.
Layout, top to bottom:
- Rule list: percentage, target goal, minimum credit
- Create/edit rule with consent
Navigation: Save rule.
Also show or consider: Empty.
Rules: neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; calm uncluttered layout; consistent with all previous screens.
```
