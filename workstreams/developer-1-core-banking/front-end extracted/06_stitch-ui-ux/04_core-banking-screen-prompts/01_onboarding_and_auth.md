# Stitch Prompts - Onboarding & Auth

Paste the master brief and tokens first. One prompt per screen; each is self-contained.

## S-CB-001 - Welcome

```text
Design the "Welcome" screen of the YourApp mobile banking app (390 x 844, light mode), following the master design brief and tokens.
Purpose: Introduce the app and start sign-up or login.
Layout, top to bottom:
- Own logo and short tagline at top
- 3-slide carousel (Safe, Simple, Yours) with page dots
- Primary button: Create account
- Secondary button: Log in
- Footer: Terms and Privacy links
Navigation: Create account -> S-CB-002; Log in -> S-CB-013.
Also show or consider these states: Default only; offline banner if no network.
Rules: use a neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; 52 px buttons and inputs; keep it calm and uncluttered.
```

## S-CB-002 - Phone number

```text
Design the "Phone number" screen of the YourApp mobile banking app (390 x 844, light mode), following the master design brief and tokens.
Purpose: Collect and validate phone number.
Layout, top to bottom:
- Back arrow, progress stepper (1 of 8)
- Title: What is your phone number?
- Phone field with +234 prefix
- Helper: We will send a code by SMS
- Primary button: Continue (disabled until valid)
Navigation: Continue -> send OTP -> S-CB-003.
Also show or consider these states: Invalid number error; number already registered -> offer Log in; rate-limited error.
Rules: use a neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; 52 px buttons and inputs; keep it calm and uncluttered.
```

## S-CB-003 - Verify OTP

```text
Design the "Verify OTP" screen of the YourApp mobile banking app (390 x 844, light mode), following the master design brief and tokens.
Purpose: Verify the SMS code.
Layout, top to bottom:
- Title and masked phone
- 6-box OTP input with auto-fill
- Resend code countdown (60s)
- Change number link
Navigation: Auto-submit when filled -> S-CB-004; Resend.
Also show or consider these states: Wrong code (shake + message); expired code; too many attempts -> lockout message.
Rules: use a neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; 52 px buttons and inputs; keep it calm and uncluttered.
```

## S-CB-004 - Personal details

```text
Design the "Personal details" screen of the YourApp mobile banking app (390 x 844, light mode), following the master design brief and tokens.
Purpose: Collect name, date of birth, email, optional referral code.
Layout, top to bottom:
- Stepper (3 of 8)
- Fields: First name, Last name, Date of birth (picker), Email, Referral code (optional)
- Note: Names must match your BVN
- Primary button: Continue
Navigation: Continue -> S-CB-005.
Also show or consider these states: Field-level validation errors; under-age error (minimum age per regulation [CONFIRM WITH ZENITH]).
Rules: use a neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; 52 px buttons and inputs; keep it calm and uncluttered.
```

## S-CB-005 - Terms and privacy consent

```text
Design the "Terms and privacy consent" screen of the YourApp mobile banking app (390 x 844, light mode), following the master design brief and tokens.
Purpose: Capture versioned consent.
Layout, top to bottom:
- Title: Before we continue
- Expandable summaries: Terms, Privacy, Data use
- Required checkboxes (not pre-ticked)
- Links to full documents
- Primary button: I agree and continue
Navigation: Agree -> S-CB-006.
Also show or consider these states: Button disabled until required boxes ticked.
Rules: use a neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; 52 px buttons and inputs; keep it calm and uncluttered.
```

## S-CB-006 - BVN verification

```text
Design the "BVN verification" screen of the YourApp mobile banking app (390 x 844, light mode), following the master design brief and tokens.
Purpose: Verify identity via BVN.
Layout, top to bottom:
- Stepper (5 of 8)
- Title: Verify your identity
- BVN field (11 digits) with info icon explaining why
- Privacy note: We only use this to verify who you are
- Primary button: Verify
Navigation: Verify -> S-CB-007.
Also show or consider these states: Invalid BVN; mismatch with entered details (explain, allow edit); provider down -> retry later.
Rules: use a neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; 52 px buttons and inputs; keep it calm and uncluttered.
```

## S-CB-007 - NIN verification

```text
Design the "NIN verification" screen of the YourApp mobile banking app (390 x 844, light mode), following the master design brief and tokens.
Purpose: Verify NIN.
Layout, top to bottom:
- Stepper (6 of 8)
- NIN field (11 digits)
- Info link: Where do I find my NIN?
- Primary button: Continue
Navigation: Continue -> S-CB-008.
Also show or consider these states: Invalid NIN; mismatch; provider down.
Rules: use a neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; 52 px buttons and inputs; keep it calm and uncluttered.
```

## S-CB-008 - Selfie and liveness

```text
Design the "Selfie and liveness" screen of the YourApp mobile banking app (390 x 844, light mode), following the master design brief and tokens.
Purpose: Capture a live selfie to match ID.
Layout, top to bottom:
- Stepper (7 of 8)
- Camera view with oval guide
- Instructions: Good light, no hat or glasses
- Live prompts (blink, turn head)
- Capture progress ring
Navigation: Auto-capture -> S-CB-009.
Also show or consider these states: Camera permission denied (explain + settings link); liveness failed (retry up to 3); mismatch -> manual review message.
Rules: use a neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; 52 px buttons and inputs; keep it calm and uncluttered.
```

## S-CB-009 - Create passcode

```text
Design the "Create passcode" screen of the YourApp mobile banking app (390 x 844, light mode), following the master design brief and tokens.
Purpose: Create the login passcode.
Layout, top to bottom:
- Title: Create your login passcode
- 6-digit PinPad with dots
- Confirm passcode on second pass
- Tip: avoid birthdays or repeated digits
Navigation: Confirm -> S-CB-010.
Also show or consider these states: Mismatch; weak passcode rejected.
Rules: use a neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; 52 px buttons and inputs; keep it calm and uncluttered.
```

## S-CB-010 - Create transaction PIN

```text
Design the "Create transaction PIN" screen of the YourApp mobile banking app (390 x 844, light mode), following the master design brief and tokens.
Purpose: Create the PIN that approves money movement.
Layout, top to bottom:
- Title: Create your transaction PIN
- 4-digit PinPad with dots
- Confirm on second pass
- Note: Different from your passcode
Navigation: Confirm -> S-CB-011.
Also show or consider these states: Mismatch; same as passcode rejected.
Rules: use a neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; 52 px buttons and inputs; keep it calm and uncluttered.
```

## S-CB-011 - Enable biometrics

```text
Design the "Enable biometrics" screen of the YourApp mobile banking app (390 x 844, light mode), following the master design brief and tokens.
Purpose: Offer fingerprint/face unlock.
Layout, top to bottom:
- Illustration
- Title: Unlock faster
- Primary: Enable biometrics
- Secondary: Not now
Navigation: Enable -> OS prompt -> S-CB-012; Not now -> S-CB-012.
Also show or consider these states: Biometrics unavailable -> skip silently.
Rules: use a neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; 52 px buttons and inputs; keep it calm and uncluttered.
```

## S-CB-012 - Account created

```text
Design the "Account created" screen of the YourApp mobile banking app (390 x 844, light mode), following the master design brief and tokens.
Purpose: Confirm account and show account number.
Layout, top to bottom:
- Success animation (short)
- Title: You are all set, <FirstName>
- Account card: account name, account number with Copy, 'Account held at our foundation bank'
- Primary: Go to Home
- Secondary: Add money
Navigation: Go to Home -> S-CB-020; Add money -> S-CB-024.
Also show or consider these states: Account generation delayed -> 'Setting up your account' with auto-refresh.
Rules: use a neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; 52 px buttons and inputs; keep it calm and uncluttered.
```

## S-CB-013 - Login

```text
Design the "Login" screen of the YourApp mobile banking app (390 x 844, light mode), following the master design brief and tokens.
Purpose: Returning user login.
Layout, top to bottom:
- Greeting with first name and initials avatar
- Passcode PinPad with biometric key
- Link: Forgot passcode
- Link: Not you? Switch account
Navigation: Success -> S-CB-020; Forgot -> S-CB-015.
Also show or consider these states: Wrong passcode (attempt counter); locked after limit -> S-CB-094; new device -> S-CB-014.
Rules: use a neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; 52 px buttons and inputs; keep it calm and uncluttered.
```

## S-CB-014 - New device verification

```text
Design the "New device verification" screen of the YourApp mobile banking app (390 x 844, light mode), following the master design brief and tokens.
Purpose: Verify a new device.
Layout, top to bottom:
- Title: Verify this device
- OTP input
- Then selfie liveness step
- Note explaining why
Navigation: Verified -> S-CB-020.
Also show or consider these states: Failed verification; device limit reached.
Rules: use a neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; 52 px buttons and inputs; keep it calm and uncluttered.
```

## S-CB-015 - Reset passcode

```text
Design the "Reset passcode" screen of the YourApp mobile banking app (390 x 844, light mode), following the master design brief and tokens.
Purpose: Reset forgotten passcode safely.
Layout, top to bottom:
- Steps: OTP -> BVN last digits or selfie -> new passcode
- Stepper
- Warning: money actions locked 24h after reset (configurable)
Navigation: Done -> S-CB-013.
Also show or consider these states: Failed verification; rate limit.
Rules: use a neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; 52 px buttons and inputs; keep it calm and uncluttered.
```
