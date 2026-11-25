# Stitch Prompts - Cards

Paste the master brief and tokens first. One prompt per screen; each is self-contained.

## S-CB-050 - Cards home

```text
Design the "Cards home" screen of the YourApp mobile banking app (390 x 844, light mode), following the master design brief and tokens.
Purpose: List cards.
Layout, top to bottom:
- Vertical carousel of CardViews
- Per-card quick toggles: Freeze, Details
- 'Create card' tile
Navigation: Tap card -> S-CB-051; Create -> S-CB-052.
Also show or consider these states: Empty: invite to create first card; card list error.
Rules: use a neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; 52 px buttons and inputs; keep it calm and uncluttered.
```

## S-CB-051 - Card detail

```text
Design the "Card detail" screen of the YourApp mobile banking app (390 x 844, light mode), following the master design brief and tokens.
Purpose: Manage one card.
Layout, top to bottom:
- Large CardView
- Action row: Freeze, Show details, Limits, Alerts
- Recent card transactions
- Menu: Rename, Change theme, Delete
Navigation: Show details -> S-CB-054; Limits -> S-CB-053.
Also show or consider these states: Frozen overlay; expired; delete confirm dialog.
Rules: use a neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; 52 px buttons and inputs; keep it calm and uncluttered.
```

## S-CB-052 - Create card

```text
Design the "Create card" screen of the YourApp mobile banking app (390 x 844, light mode), following the master design brief and tokens.
Purpose: Create a virtual naira card.
Layout, top to bottom:
- Step 1: Name the card
- Step 2: Choose theme (live preview)
- Step 3: Optional spend limit
- Review + PIN -> success
Navigation: Create.
Also show or consider these states: Create failed -> retry; card creation fee shown if any [CONFIRM WITH ZENITH].
Rules: use a neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; 52 px buttons and inputs; keep it calm and uncluttered.
```

## S-CB-053 - Card limits

```text
Design the "Card limits" screen of the YourApp mobile banking app (390 x 844, light mode), following the master design brief and tokens.
Purpose: Set card limits.
Layout, top to bottom:
- Per-transaction and daily limits with sliders and numeric fields
- Cannot exceed account tier limits (hint)
Navigation: Save with PIN.
Also show or consider these states: Validation errors.
Rules: use a neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; 52 px buttons and inputs; keep it calm and uncluttered.
```

## S-CB-054 - Reveal card details

```text
Design the "Reveal card details" screen of the YourApp mobile banking app (390 x 844, light mode), following the master design brief and tokens.
Purpose: Show full details securely.
Layout, top to bottom:
- Requires PIN/biometric first
- Number, expiry, CVV with Copy buttons
- Auto-hide countdown (30s)
- Screen capture blocked
Navigation: Copy.
Also show or consider these states: Auth failed; timed out.
Rules: use a neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; 52 px buttons and inputs; keep it calm and uncluttered.
```

## S-CB-055 - Card alerts and settings

```text
Design the "Card alerts and settings" screen of the YourApp mobile banking app (390 x 844, light mode), following the master design brief and tokens.
Purpose: Control alerts.
Layout, top to bottom:
- Toggles: Push alerts, SMS alerts, Online purchases, International (v2)
Navigation: Toggle.
Also show or consider these states: Default.
Rules: use a neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; 52 px buttons and inputs; keep it calm and uncluttered.
```
