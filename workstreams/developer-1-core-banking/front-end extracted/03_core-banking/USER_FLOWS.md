# User Flows - Core Banking (text versions)

Each flow also exists as a `.drawio` file and Mermaid file in `../05_flowcharts-drawio/` with the same name.

## F-01 Onboarding and KYC
Welcome -> Phone -> OTP -> Personal details -> Consent -> BVN -> NIN -> Selfie/liveness -> Passcode -> Transaction PIN -> Biometrics (optional) -> Account created (S-CB-001 to S-CB-012). Failure branches: OTP wrong/expired, BVN or NIN mismatch, liveness failed (retry 3x then manual review), provider down (retry later, progress saved).

## F-02 Login and device binding
Login (passcode/biometric) -> if known device: Home. If new device: OTP -> selfie -> Home. Wrong passcode counter -> lock (S-CB-094). Forgot passcode -> reset flow (S-CB-015) -> 24h hold on money actions.

## F-03 Add money
Home/Quick action -> Add money -> choose: bank transfer (show account number), card top-up, USSD, agent deposit. Inbound credit -> push + SMS -> balance updates -> history.

## F-04 Transfer to bank
Payments -> Send -> recipient (new or saved) -> name enquiry -> amount -> quote (fee, limits) -> confirm -> PIN (step-up if risky) -> submit with idempotency key -> Success / Pending / Failed. Pending: status polling and push; auto-reversal if failed. Receipt and "Report a problem" available.

## F-05 Airtime and bills
Choose service -> number/biller -> validate customer -> amount/package -> confirm -> PIN -> result with token/receipt. Failed vend -> automatic refund and message.

## F-06 Cards
Cards -> Create (name, theme, limit) -> PIN -> card active. Card detail: freeze/unfreeze, limits, reveal details (PIN, 30s auto-hide), alerts, delete.

## F-07 KYC tier upgrade
More -> KYC -> see next tier requirements -> upload documents -> submit -> pending -> approved (limits increase) or rejected (reason, retry).

## F-08 Report a problem and support
Transaction detail -> Report -> reason + evidence -> ticket created -> tracked in Tickets; chat available.

## F-09 Lock account
More -> Security -> Lock my account -> confirm with PIN -> account restricted; unlock requires verification.

## F-10 Statements
More -> Statements -> pick range -> generate -> download or email.

## F-11 Master navigation map
Five-tab structure and entry points (see NAVIGATION_MAP.md).
