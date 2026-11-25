# PRD - Core Banking (SHARED - identical in front-end and back-end)

Priority: P0 = launch blocker, P1 = needed soon after launch, P2 = later. Owner: FE, BE or Both.
Values marked [CONFIRM WITH ZENITH] or [OPEN] must be configurable.

## 1. Onboarding and KYC (CB-ONB)
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| CB-ONB-001 | User signs up with phone number verified by OTP. | P0 | Both |
| CB-ONB-002 | User provides name, date of birth, email; accepts terms and privacy consent (versioned, timestamped). | P0 | Both |
| CB-ONB-003 | BVN verification: BVN validated against the identity provider; name and date of birth must match. | P0 | Both |
| CB-ONB-004 | NIN verification as additional identity proof. | P0 | Both |
| CB-ONB-005 | Selfie with liveness check matched to ID photo. | P0 | Both |
| CB-ONB-006 | Create transaction PIN (4 or 6 digits) and enable biometrics (optional). | P0 | Both |
| CB-ONB-007 | Account number generated through Zenith on completion; user sees account number and name. | P0 | Both |
| CB-ONB-008 | KYC tiers: basic (Tier 1), standard (Tier 2), full (Tier 3). Limits per tier are configuration. [CONFIRM WITH ZENITH] | P0 | Both |
| CB-ONB-009 | In-app upgrade path to a higher tier (address proof, extra ID). | P1 | Both |
| CB-ONB-010 | Duplicate detection: one BVN cannot create two active accounts. | P0 | BE |
| CB-ONB-011 | Resume onboarding if interrupted; progress saved server-side. | P1 | Both |
| CB-ONB-012 | Referral code field (optional) at sign-up. | P2 | Both |

## 2. Authentication and security (CB-SEC)
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| CB-SEC-001 | Login with phone/email + passcode or biometrics. | P0 | Both |
| CB-SEC-002 | Device binding: first login on a new device requires OTP plus identity re-check; user can list and remove devices. | P0 | Both |
| CB-SEC-003 | Transaction PIN required for every money-moving action; biometric can substitute where allowed. | P0 | Both |
| CB-SEC-004 | Step-up authentication (OTP/selfie) for risky actions: new beneficiary above threshold, limit change, device change. | P0 | Both |
| CB-SEC-005 | Session timeout after inactivity; token refresh and revocation. | P0 | Both |
| CB-SEC-006 | Lock account instantly (customer-initiated). Unlock needs verification. | P0 | Both |
| CB-SEC-007 | SIM-swap protection: sensitive actions blocked or stepped-up after a SIM change signal. | P1 | BE |
| CB-SEC-008 | Rate limiting, brute-force lockout, fraud rules engine. | P0 | BE |
| CB-SEC-009 | Screen capture blocked on sensitive screens; secure storage for tokens; root/jailbreak detection. | P1 | FE |
| CB-SEC-010 | Full audit trail for sensitive actions. | P0 | BE |

## 3. Accounts and balances (CB-ACC)
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| CB-ACC-001 | Each customer has one naira main account backed by a Zenith-generated account number. | P0 | Both |
| CB-ACC-002 | Balance display with hide/show toggle; available vs ledger balance. | P0 | Both |
| CB-ACC-003 | Transaction history with search, filter (date, type, status) and pagination. | P0 | Both |
| CB-ACC-004 | Pockets (ledger sub-balances) for savings goals and held funds; visible but not spendable unless released. | P0 | Both |
| CB-ACC-005 | Account statements by date range, PDF export and email delivery. | P1 | Both |
| CB-ACC-006 | Account details sharing (name, number, bank) as text/image. | P1 | FE |
| CB-ACC-007 | Account lifecycle: dormancy rules, closure request, change of details. | P1 | Both |

## 4. Funding / add money (CB-FUN)
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| CB-FUN-001 | Receive transfers to the account number from any bank; credit posted in real time. | P0 | BE |
| CB-FUN-002 | Card top-up (debit card), with saved cards tokenized by the processor. | P1 | Both |
| CB-FUN-003 | USSD top-up/transfer fallback. | P2 | BE |
| CB-FUN-004 | Cash deposit via agents (see Agent Network). | P1 | Both |
| CB-FUN-005 | Inbound credit notifications with sender details. | P0 | Both |

## 5. Transfers (CB-TRF)
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| CB-TRF-001 | Transfer to same-platform accounts (instant, no interbank rail). | P0 | Both |
| CB-TRF-002 | Transfer to other Nigerian banks via the interbank rail, with name enquiry shown before confirmation. | P0 | Both |
| CB-TRF-003 | Beneficiary management: save, rename, delete, favourite. | P0 | Both |
| CB-TRF-004 | Exact fee, limit check and total shown before PIN entry. | P0 | Both |
| CB-TRF-005 | Transfer states: Pending, Successful, Failed, Reversed; each visible in history and receipt. | P0 | Both |
| CB-TRF-006 | Idempotent submission: retry or double-tap never sends twice. | P0 | Both |
| CB-TRF-007 | Unknown/timeout outcome handled as Pending with automatic status query and reversal if failed. | P0 | BE |
| CB-TRF-008 | Shareable receipt (image/PDF) with app branding. | P0 | FE |
| CB-TRF-009 | Scheduled and recurring transfers. | P1 | Both |
| CB-TRF-010 | Request money / payment link. | P1 | Both |
| CB-TRF-011 | QR payments (national QR standard). | P1 | Both |
| CB-TRF-012 | Daily and per-transaction limits enforced by tier. [CONFIRM WITH ZENITH] | P0 | BE |
| CB-TRF-013 | Narration (note) on transfers. | P1 | Both |

## 6. Bills and airtime (CB-BIL)
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| CB-BIL-001 | Airtime and data purchase for all major networks, for self or others. | P0 | Both |
| CB-BIL-002 | Bill categories: electricity, cable TV, internet, education, others via an aggregator. | P0 | Both |
| CB-BIL-003 | Customer validation (meter/decoder number) before payment. | P0 | Both |
| CB-BIL-004 | Token/receipt display for prepaid items; failed vend refunded automatically. | P0 | Both |
| CB-BIL-005 | Saved billers, scheduled and recurring bill payments. | P1 | Both |

## 7. Cards (naira) (CB-CRD)
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| CB-CRD-001 | Create a virtual naira card; instant. | P0 | Both |
| CB-CRD-002 | Card customisation: name and colour theme from the card design set. | P1 | Both |
| CB-CRD-003 | Freeze/unfreeze toggle, instant. | P0 | Both |
| CB-CRD-004 | Per-card spending limits. | P1 | Both |
| CB-CRD-005 | Reveal card details only after PIN/biometric; auto-hide after a short time. | P0 | Both |
| CB-CRD-006 | Instant transaction alerts per card. | P0 | Both |
| CB-CRD-007 | Add to Apple Pay / Google Pay. | P2 | Both |
| CB-CRD-008 | One-time (disposable) cards. | P2 | Both |
| CB-CRD-009 | Physical card request and delivery tracking, if Zenith supports it. [CONFIRM WITH ZENITH] | P2 | Both |
| CB-CRD-010 | Card transaction dispute (chargeback) submission. | P1 | Both |

## 7b. Save (basic savings entry) (CB-SAV)
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| CB-SAV-001 | Save & Borrow tab lists available savings and borrowing products as independent entries. | P0 | FE |

## 8. Notifications and receipts (CB-NOT)
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| CB-NOT-001 | Push, SMS and email notifications for every debit and credit. | P0 | Both |
| CB-NOT-002 | In-app notification centre with read/unread. | P0 | Both |
| CB-NOT-003 | Security alerts (new device, PIN change, login from new location). | P0 | Both |
| CB-NOT-004 | User notification preferences (non-mandatory categories only). | P1 | Both |

## 9. Support and disputes (CB-SUP)
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| CB-SUP-001 | In-app help centre (searchable articles). | P1 | Both |
| CB-SUP-002 | In-app chat with a human agent; ticket created with history. | P0 | Both |
| CB-SUP-003 | "Report a problem" on every transaction creates a linked ticket. | P0 | Both |
| CB-SUP-004 | Complaint tracking with status and stated response times. | P0 | Both |
| CB-SUP-005 | Escalation route to the regulator is displayed in the help area. | P1 | FE |

## 10. Settings (CB-SET)
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| CB-SET-001 | Profile, contact details, KYC status and tier. | P0 | Both |
| CB-SET-002 | Security: change passcode, change PIN, biometrics, manage devices, lock account. | P0 | Both |
| CB-SET-003 | Limits view and upgrade prompts. | P0 | Both |
| CB-SET-004 | Statements and tax/transaction exports. | P1 | Both |
| CB-SET-005 | Legal documents, privacy and consent management. | P0 | Both |
| CB-SET-006 | Branch/agent locator. | P1 | Both |
| CB-SET-007 | Delete/close account request flow. | P1 | Both |

## 11. Fees and limits (CB-FEE)
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| CB-FEE-001 | Fee schedule is configuration (per transaction type, tier, channel), including statutory charges. [CONFIRM WITH ZENITH] | P0 | BE |
| CB-FEE-002 | Every fee shown before confirmation and on the receipt. | P0 | Both |
| CB-FEE-003 | Limit rules per tier configurable without code release. | P0 | BE |

## 12. Back office for core banking (CB-BOF)
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| CB-BOF-001 | Customer 360 view with masked data and unmask-with-reason. | P0 | BE |
| CB-BOF-002 | KYC review queue and tier approvals. | P0 | BE |
| CB-BOF-003 | Transaction search, reversal request with dual approval. | P0 | BE |
| CB-BOF-004 | Daily reconciliation dashboard against Zenith; exceptions queue. | P0 | BE |
| CB-BOF-005 | Role-based access, audit logs, exports. | P0 | BE |

## Non-functional requirements (NFR)
| ID | Requirement |
|---|---|
| NFR-001 | Money amounts are integer kobo; no floating point anywhere. |
| NFR-002 | All money-moving endpoints are idempotent. |
| NFR-003 | Ledger always balances; a nightly job verifies debits equal credits. |
| NFR-004 | Target 99.9% availability for transfers during business launch phase (to be confirmed). |
| NFR-005 | Mobile app cold start under 3 seconds on mid-range Android; screens usable on 3G. |
| NFR-006 | All personal data encrypted in transit and at rest; compliance with the Nigeria Data Protection Act. |
| NFR-007 | Accessibility: text scaling, sufficient contrast, screen reader labels. |
