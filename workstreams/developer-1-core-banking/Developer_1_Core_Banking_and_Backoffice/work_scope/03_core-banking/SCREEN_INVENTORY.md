# Screen Inventory - Core Banking (Stage 1)

61 screens. IDs are used in flowcharts, Stitch prompts, tests and the traceability matrix. Product screens (Stage 2) continue the numbering with their own prefixes (for example S-LOAN-001).

| ID | Screen | Group | Route | Requirements |
|---|---|---|---|---|
| S-CB-001 | Welcome | Onboarding & Auth | `/welcome` | CB-ONB-001 |
| S-CB-002 | Phone number | Onboarding & Auth | `/signup/phone` | CB-ONB-001 |
| S-CB-003 | Verify OTP | Onboarding & Auth | `/signup/otp` | CB-ONB-001 |
| S-CB-004 | Personal details | Onboarding & Auth | `/signup/details` | CB-ONB-002, CB-ONB-012 |
| S-CB-005 | Terms and privacy consent | Onboarding & Auth | `/signup/consent` | CB-ONB-002 |
| S-CB-006 | BVN verification | Onboarding & Auth | `/signup/bvn` | CB-ONB-003 |
| S-CB-007 | NIN verification | Onboarding & Auth | `/signup/nin` | CB-ONB-004 |
| S-CB-008 | Selfie and liveness | Onboarding & Auth | `/signup/selfie` | CB-ONB-005 |
| S-CB-009 | Create passcode | Onboarding & Auth | `/signup/passcode` | CB-ONB-006, CB-SEC-001 |
| S-CB-010 | Create transaction PIN | Onboarding & Auth | `/signup/pin` | CB-ONB-006, CB-SEC-003 |
| S-CB-011 | Enable biometrics | Onboarding & Auth | `/signup/biometrics` | CB-SEC-001 |
| S-CB-012 | Account created | Onboarding & Auth | `/signup/done` | CB-ONB-007 |
| S-CB-013 | Login | Onboarding & Auth | `/login` | CB-SEC-001 |
| S-CB-014 | New device verification | Onboarding & Auth | `/login/new-device` | CB-SEC-002 |
| S-CB-015 | Reset passcode | Onboarding & Auth | `/login/reset` | CB-SEC-001 |
| S-CB-020 | Home | Home | `/home` | CB-ACC-002, CB-ACC-003, CB-SAV-001 |
| S-CB-021 | Notification centre | Home | `/notifications` | CB-NOT-002 |
| S-CB-022 | Transaction detail | Home | `/transactions/:id` | CB-ACC-003, CB-TRF-005 |
| S-CB-023 | Receipt | Home | `/transactions/:id/receipt` | CB-TRF-008 |
| S-CB-024 | Add money | Home | `/add-money` | CB-FUN-001, CB-FUN-002, CB-FUN-004 |
| S-CB-025 | Account details | Home | `/account-details` | CB-ACC-006 |
| S-CB-030 | Payments hub | Payments | `/payments` | CB-TRF-001 |
| S-CB-031 | Send: choose recipient | Payments | `/send/recipient` | CB-TRF-002, CB-TRF-003 |
| S-CB-032 | Send: amount | Payments | `/send/amount` | CB-TRF-004, CB-TRF-012, CB-TRF-013 |
| S-CB-033 | Send: confirm | Payments | `/send/confirm` | CB-TRF-004 |
| S-CB-034 | PIN entry | Payments | `(sheet)` | CB-SEC-003 |
| S-CB-035 | Processing and result | Payments | `/send/result` | CB-TRF-005, CB-TRF-006, CB-TRF-007 |
| S-CB-036 | Beneficiaries | Payments | `/beneficiaries` | CB-TRF-003 |
| S-CB-037 | Scheduled payments | Payments | `/scheduled` | CB-TRF-009, CB-BIL-005 |
| S-CB-038 | Request money | Payments | `/request` | CB-TRF-010 |
| S-CB-039 | QR scan and pay | Payments | `/qr` | CB-TRF-011 |
| S-CB-040 | Airtime and data | Payments | `/airtime` | CB-BIL-001 |
| S-CB-041 | Bills: categories | Payments | `/bills` | CB-BIL-002 |
| S-CB-042 | Bills: pay | Payments | `/bills/pay` | CB-BIL-003, CB-BIL-004 |
| S-CB-043 | Transaction history | Payments | `/history` | CB-ACC-003 |
| S-CB-050 | Cards home | Cards | `/cards` | CB-CRD-001 |
| S-CB-051 | Card detail | Cards | `/cards/:id` | CB-CRD-003, CB-CRD-006 |
| S-CB-052 | Create card | Cards | `/cards/new` | CB-CRD-001, CB-CRD-002 |
| S-CB-053 | Card limits | Cards | `/cards/:id/limits` | CB-CRD-004 |
| S-CB-054 | Reveal card details | Cards | `/cards/:id/details` | CB-CRD-005 |
| S-CB-055 | Card alerts and settings | Cards | `/cards/:id/settings` | CB-CRD-006 |
| S-CB-060 | Save & Borrow landing | Save & Borrow | `/save-borrow` | CB-SAV-001 |
| S-CB-070 | More | More | `/more` | CB-SET-001 |
| S-CB-071 | Profile | More | `/more/profile` | CB-SET-001 |
| S-CB-072 | KYC status and upgrade | More | `/more/kyc` | CB-ONB-008, CB-ONB-009 |
| S-CB-073 | Security hub | More | `/more/security` | CB-SET-002, CB-SEC-006 |
| S-CB-074 | Devices | More | `/more/devices` | CB-SEC-002 |
| S-CB-075 | Limits | More | `/more/limits` | CB-SET-003 |
| S-CB-076 | Statements | More | `/more/statements` | CB-ACC-005, CB-SET-004 |
| S-CB-077 | Help centre | More | `/help` | CB-SUP-001, CB-SUP-005 |
| S-CB-078 | Support chat | More | `/help/chat` | CB-SUP-002 |
| S-CB-079 | Report a problem | More | `/transactions/:id/report` | CB-SUP-003 |
| S-CB-080 | Complaints and tickets | More | `/help/tickets` | CB-SUP-004 |
| S-CB-081 | Legal and consent | More | `/more/legal` | CB-SET-005 |
| S-CB-082 | Branch and agent locator | More | `/locator` | CB-SET-006 |
| S-CB-083 | Close account | More | `/more/close-account` | CB-SET-007 |
| S-CB-090 | Offline | System | `(overlay)` | NFR-005 |
| S-CB-091 | Maintenance | System | `/maintenance` | NFR-004 |
| S-CB-092 | Force update | System | `/update` | NFR-005 |
| S-CB-093 | Session locked | System | `/lock` | CB-SEC-005 |
| S-CB-094 | Account locked or restricted | System | `/account-locked` | CB-SEC-006 |
