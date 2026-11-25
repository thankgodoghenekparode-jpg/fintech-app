# Front-end Security Specification

## Storage
- Tokens, device ID and keys only in Keychain/Keystore via secure storage. Never in shared preferences, logs or crash reports.
- No PIN, passcode, BVN, NIN or card data persisted on device. Card details are fetched on demand and held in memory only while shown.

## Authentication on device
- Biometric unlock gates the stored refresh token; falling back to passcode.
- PIN pad is a custom in-app keypad (no OS keyboard, no autofill, no clipboard).
- After N wrong attempts (configured by the back end) show lock state; never reveal which factor was wrong beyond the specified messages.

## Session
- Auto-lock after inactivity (default 2 minutes) and when app goes to background (configurable).
- On 401: attempt one silent refresh; if it fails, return to login.
- On device revocation signal: clear local data and force login.

## Platform hardening
- Root/jailbreak detection (warn and restrict sensitive actions per back-end policy).
- Screenshot/screen-recording protection on PIN, card detail, KYC and statements screens; hide content in app switcher.
- Certificate pinning with a rotation plan (backup pins); no cleartext traffic.
- Obfuscation and symbol stripping on release builds; no debug logging in release.
- Detect emulator/debugger for fraud signal only (send as device risk header).

## Input and transport
- All requests over TLS 1.2+; sign critical requests with device key if the back end requires.
- Idempotency key per money intent; never reuse across intents.
- Validate and sanitise all server text rendered in the UI.
- Deep links require authentication and validate IDs belong to the user.

## Privacy
- Request permissions just in time (camera for selfie/QR, contacts optional, location for locator only) with clear explanations.
- Analytics events contain no personal data or amounts; consent-gated.
- Clipboard: card numbers copied by user are cleared after 60 seconds where the OS allows.

## Web dashboards
- HTTP-only, Secure, SameSite cookies; CSRF protection; CSP headers; no tokens in local storage.
- Mask sensitive data by default; unmask requires reason and is logged by the back end.
- Session timeout 15 minutes idle for staff; step-up for approvals.
