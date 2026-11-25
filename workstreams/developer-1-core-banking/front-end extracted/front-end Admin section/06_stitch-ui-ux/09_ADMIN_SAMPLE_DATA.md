# Admin Sample Data for Stitch (back office and product dashboards)

**All data is fictional.** Use these rows and numbers so each admin screen looks real (tables with 5-10 rows, KPI tiles with figures, status chips). Sensitive fields are masked as shown. The same data is in `../00_overview/mock-data/backoffice_mock.json`.

How to use: when you give Stitch a back-office or dashboard screen prompt, add this line: *"Fill the screen with the sample data for this screen from the uploaded file 09_ADMIN_SAMPLE_DATA."*

## W-BO-018 / W-BO-021 Staff and roles
| name | role | email | mfa | lastAccess | status |
|---|---|---|---|---|---|
| Adaeze Okafor | Super Admin | adaeze.okafor@example.test | Enrolled | Today 09:12 | Active |
| Tunde Bakare | Compliance Officer | tunde.bakare@example.test | Enrolled | Today 08:47 | Active |
| Ibrahim Musa | KYC Officer | ibrahim.musa@example.test | Enrolled | Today 09:30 | Active |
| Ngozi Eze | Support Agent | ngozi.eze@example.test | Enrolled | Today 09:05 | Active |
| Chinedu Obi | Risk Analyst | chinedu.obi@example.test | Enrolled | Yesterday 17:40 | Active |
| Funke Adeyemi | Finance Officer | funke.adeyemi@example.test | Enrolled | Today 08:15 | Active |
| Emeka Nwosu | Dispute Officer | emeka.nwosu@example.test | Pending setup | 3 days ago | Invited |
| Zainab Abdullahi | Product Admin | zainab.abdullahi@example.test | Enrolled | Today 07:58 | Active |

## W-BO-002 Work queues (tiles with counts and over-SLA)
| queue | count | overSla |
|---|---|---|
| KYC cases | 23 | 2 |
| Risk alerts | 41 | 5 |
| Support tickets | 118 | 9 |
| Approvals waiting | 7 | 0 |
| Escrow disputes | 6 | 1 |
| Reconciliation exceptions | 14 | 3 |
| Sanctions hits | 3 | 0 |
| Data requests | 4 | 1 |

## W-BO-004 KYC queue
| id | customer | requestedTier | trigger | risk | sla | status |
|---|---|---|---|---|---|---|
| KYC-20931 | B*** A***** | 2 | Tier upgrade | Low | 3h left | Open |
| KYC-20930 | C*** O*** | 1 | Liveness mismatch | Medium | 1h left | In review |
| KYC-20927 | F**** E*** | 3 | Address proof | Low | Tomorrow | Needs info |
| KYC-20924 | M**** I**** | 1 | BVN name mismatch | High | Overdue 1h | Referred |
| KYC-20921 | O****** N**** | 2 | Tier upgrade | Low | 5h left | Open |
| KYC-20919 | S**** U**** | 1 | Sanctions possible match | High | 2h left | Referred |

## W-BO-005 Transactions
| ref | type | amount | fee | status | time |
|---|---|---|---|---|---|
| TRF-8841203 | Transfer (interbank) | ₦250,000.00 | ₦26.88 | Successful | 09:41 |
| TRF-8841199 | Transfer (interbank) | ₦1,200,000.00 | ₦53.75 | Pending | 09:38 |
| BIL-5520731 | Electricity | ₦15,000.00 | ₦0.00 | Successful | 09:30 |
| TRF-8841102 | Transfer (internal) | ₦5,000.00 | ₦0.00 | Successful | 09:12 |
| TRF-8840977 | Transfer (interbank) | ₦80,000.00 | ₦26.88 | Reversed | 08:55 |
| AIR-2201934 | Airtime | ₦2,000.00 | ₦0.00 | Failed (refunded) | 08:40 |

## W-BO-006 Approvals inbox
| id | action | detail | amount | requestedBy | status |
|---|---|---|---|---|---|
| APR-3321 | Reversal | TRF-8840977 duplicate debit | ₦80,000.00 | Ngozi Eze | Pending |
| APR-3320 | Limit change | Tier 2 daily out | - | Chinedu Obi | Pending |
| APR-3318 | Config change | Interbank fee schedule v4 | - | Zainab Abdullahi | Pending |
| APR-3315 | Manual posting | Suspense clearance REC-771 | ₦45,000.00 | Funke Adeyemi | Pending |
| APR-3311 | Unfreeze account | Case RSK-1180 cleared | - | Chinedu Obi | Approved |

## W-BO-008 Risk alerts
| id | rule | entity | score | status | sla |
|---|---|---|---|---|---|
| ALT-55102 | TM-003 Rapid in-out | Account ****4417 | 82 | Open | 2h left |
| ALT-55099 | TM-001 Velocity | Customer C-90412 | 71 | Triaged | 5h left |
| ALT-55090 | TM-008 Group withdrawal after admin change | Cooperative Unity Women Thrift | 90 | Case opened | 1h left |
| ALT-55085 | TM-011 Agent near-limit deposits | Agent AG-2034 | 64 | Open | Tomorrow |
| ALT-55081 | TM-014 Referral cluster | Device D-7781 | 77 | Open | 4h left |
| ALT-55070 | TM-010 Escrow new users high value | Deal ESC-3021 | 69 | Closed: false positive | - |

## W-BO-009 Support workspace
| id | subject | customer | category | priority | sla |
|---|---|---|---|---|---|
| TKT-48211 | Transfer shows pending | Chioma A. | Transfers | High | 1h left |
| TKT-48209 | Card declined online | Yusuf M. | Cards | Normal | 3h left |
| TKT-48200 | Cannot upgrade tier | Grace E. | KYC | Normal | Today |
| TKT-48195 | Unauthorised debit | Samuel O. | Fraud | Urgent | 30m left |
| TKT-48190 | Cooperative loan question | Amina B. | Cooperative | Low | Tomorrow |

## W-BO-011 Tenants
| type | name | status | trust | members | flag |
|---|---|---|---|---|---|
| Cooperative | Unity Women Thrift Society | Active | Verified | 184 | Large withdrawal pending |
| Ajo circle | Market Women Weekly Circle | Active | Established | 12 | - |
| Vendor | Bright Home Appliances | Verified | Verified | 3 staff | - |
| Collector | Greenfield Estate Residents | Pending verification | Starter | 220 payers | Documents missing |
| Business | Lekki Fresh Foods Ltd | Verified | Verified | 5 staff | - |
| Agent | Agent AG-2034 (Mile 12) | Active | - | - | Alert TM-011 |

## W-BO-023 Sanctions and PEP hits
| id | subject | list | score | status | sla |
|---|---|---|---|---|---|
| SCR-1201 | Customer C-90455 | PEP database | 88% | In review | 4h left |
| SCR-1199 | Collector Greenfield Estate (officer) | Sanctions list | 72% | Open | Today |
| SCR-1190 | Agent applicant A-771 | Adverse media | 65% | Open | Tomorrow |
| SCR-1184 | Customer C-88120 | PEP database | 91% | Escalated | - |

## W-BO-024 STR register (restricted)
| id | case | status | filed | ref |
|---|---|---|---|---|
| STR-0042 | RSK-1176 | Filed | 2026-10-08 | (restricted) |
| STR-0043 | RSK-1180 | Approved, ready to file | - | (restricted) |
| STR-0044 | RSK-1188 | Draft | - | (restricted) |

## W-BO-024 Regulatory calendar
| report | period | due | status | owner |
|---|---|---|---|---|
| Monthly transaction statistics | September 2026 | 2026-10-10 | Submitted | Funke Adeyemi |
| Complaints return | Q3 2026 | 2026-10-15 | In review | Tunde Bakare |
| Agent network report | September 2026 | 2026-10-12 | Overdue | Zainab Abdullahi |
| Data protection audit data | 2026 | 2026-12-31 | Upcoming | Tunde Bakare |

## W-BO-026 Card disputes
| id | customer | txn | reason | status | deadline |
|---|---|---|---|---|---|
| CHB-3101 | Samuel O. | POS-77120 ₦48,000.00 | Unauthorised | Evidence requested | 2026-10-24 |
| CHB-3098 | Aisha K. | WEB-55012 ₦12,500.00 | Not received | Submitted to issuer | 2026-10-30 |
| CHB-3090 | Peter N. | WEB-54871 ₦6,000.00 | Duplicate charge | Won | - |
| CHB-3085 | Rita U. | POS-76802 ₦20,000.00 | Wrong amount | Open | 2026-10-27 |

## W-BO-027 Data subject requests
| id | customer | type | status | due |
|---|---|---|---|---|
| DSR-210 | C-70213 | Access | In progress | in 12 days |
| DSR-209 | C-65110 | Erasure | Verifying identity | in 20 days |
| DSR-205 | C-60010 | Rectification | Fulfilled | - |
| DSR-203 | C-59001 | Objection (marketing) | Fulfilled | - |

## W-BO-029 Complaints register
| id | category | severity | reportable | status | sla |
|---|---|---|---|---|---|
| CMP-1550 | Failed transfer | High | Yes | Investigating | 6h left |
| CMP-1549 | Unauthorised debit | Urgent | Yes | Investigating | 2h left |
| CMP-1544 | Card dispute | Normal | No | Resolved | - |
| CMP-1540 | Loan collections conduct | High | Yes | Escalated | Today |
| CMP-1537 | App usability | Low | No | Closed | - |

## W-BO-030 Blocklists
| type | value | reason | added | expires |
|---|---|---|---|---|
| Device | d-7781 (hashed) | Referral abuse cluster | 2026-10-12 | 2027-01-12 |
| Phone | +23480****091 (hashed) | Mule account | 2026-10-10 | Never |
| BVN | BVN-*** (hashed) | Confirmed fraud | 2026-09-30 | Never |
| IP | 41.***.***.17 | Credential stuffing | 2026-10-13 | 2026-10-20 |
| Account | ****4417 | Rapid in-out pattern | 2026-10-13 | Review in 7 days |

## W-BO-028 Service notices
| title | audience | channels | status | approval |
|---|---|---|---|---|
| Planned maintenance Sunday 02:00-04:00 | All customers | Push, in-app | Scheduled | Approved |
| Transfers to some banks are slow | Customers with pending transfers | In-app banner | Sent | Approved |
| New card themes available | Opted-in customers | Push | Pending approval | Pending |

## W-BO-017 Audit log
| time | actor | action | entity | ip |
|---|---|---|---|---|
| 09:44 | Ibrahim Musa | KYC decision: approve tier 2 | KYC-20931 | 102.89.*.* |
| 09:31 | Ngozi Eze | Unmask phone (reason: fraud ticket) | Customer C-90412 | 102.89.*.* |
| 09:15 | Chinedu Obi | Freeze requested | Account ****4417 | 102.89.*.* |
| 09:02 | Funke Adeyemi | Reconciliation exception assigned | REC-771 | 102.89.*.* |
| 08:50 | Zainab Abdullahi | Config change submitted | fees.transfer.interbank v4 | 102.89.*.* |
| 08:47 | Tunde Bakare | Sanctions hit decision: escalate | SCR-1184 | 102.89.*.* |

## W-BO-020 System status
| service | status | detail |
|---|---|---|
| API | Healthy | p95 420 ms |
| Ledger | Healthy | 0 imbalances |
| Interbank provider | Degraded | Timeouts 4% |
| SMS primary | Healthy | Delivery 97% |
| KYC provider | Healthy | p95 2.1 s |
| Card issuer | Healthy | - |
| Job queue | Healthy | Lag 3 s |

## W-BO-010 Reconciliation
Date: Yesterday | Status: Completed, not signed off | Matched: 12,884 items, ₦412,330,500.00 | Exceptions: 14 items, ₦2,184,000.00 | Suspense: ₦45,000.00
| id | external | internal | amount | type | assigned |
|---|---|---|---|---|---|
| REC-771 | ZEN-55120 | - | ₦45,000.00 | Missing internal | Funke Adeyemi |
| REC-772 | ZEN-55181 | TRF-8839100 | ₦100,000.00 | Amount mismatch (₦99,900.00 internal) | Funke Adeyemi |
| REC-773 | - | TRF-8839950 | ₦30,000.00 | Missing external | Unassigned |
| REC-774 | ZEN-55199 | TRF-8839980 | ₦12,500.00 | Duplicate | Unassigned |
| REC-775 | ZEN-55203 | TRF-8839992 | ₦640,000.00 | Amount mismatch | Unassigned |

## W-BO-025 Finance dashboard
KPI tiles: Fee income (month to date): ₦18,420,300.00; Commission income: ₦6,240,900.00; Statutory payable: ₦1,305,200.00; Settlements pending: ₦9,860,000.00; Float at foundation bank: ₦2,418,000,000.00; Reward cost vs budget: ₦3.1M of ₦10M (31%)

Fee income by product:
| product | income |
|---|---|
| Core transfers | ₦7,100,000.00 |
| Bills and airtime | ₦2,300,000.00 |
| Cooperative commission | ₦2,050,000.00 |
| Ajo fees | ₦980,000.00 |
| Pay Am Small commission | ₦3,900,000.00 |
| Escrow fees | ₦1,450,000.00 |
| Revenue collections fees | ₦640,000.00 |

## W-BO-022 Access reviews
Period Q4 2026, due 2026-12-15, status In progress
| staff | role | lastAccess | decision |
|---|---|---|---|
| Ngozi Eze | Support Agent | Today | Keep |
| Emeka Nwosu | Dispute Officer | 3 days ago | Pending |
| Chinedu Obi | Risk Analyst | Yesterday | Keep |
| Old contractor (Peter Ade) | Support Agent | 62 days ago | Revoke |

## Product dashboards (web)

**Cooperative** (Unity Women Thrift Society): KPIs: Pool balance ₦38,420,000.00; Member savings ₦29,100,000.00; Share capital ₦6,000,000.00; Loans out ₦8,350,000.00; Guarantor-locked ₦12,400,000.00; Arrears ₦640,000.00 (9 members)

- Approvals: Join request: Mrs. Okonkwo | Loan ₦500,000.00: Mr. Danjuma (3/3 guarantors accepted) | Withdrawal ₦2,000,000.00 (cooling-off 36h left)

**Vendor** (Bright Home Appliances): KPIs: Open orders 14; Active plans 63; Payouts this month ₦3,820,000.00; Holdback pending ₦410,000.00; Disputes 1; Low stock 3 items

- Orders: ORD-9021 Gas cooker, vault 78% funded | ORD-9019 Fridge, vault full, ship by Fri | ORD-9015 Fan, delivered, holdback releases tomorrow

**Collector** (Greenfield Estate Residents): KPIs: Billed ₦4,400,000.00; Collected ₦3,115,000.00 (71%); Outstanding ₦1,285,000.00; Cash not deposited ₦95,000.00; Disputes 2

- Items: Security levy ₦5,000 monthly | Waste collection ₦2,500 monthly | Estate development levy ₦20,000 yearly

**Merchant** (Lekki Fresh Foods Ltd): KPIs: Sales today ₦412,500.00; Fees ₦3,100.00; Refunds ₦12,000.00; Unpaid invoices 6 (₦540,000.00)

**Loans** (Loan portfolio): KPIs: Outstanding ₦120,400,000.00; PAR30 4.8%; Repayment rate 93%; Hardship cases 11; Disbursed this week ₦18,200,000.00

**Escrow** (Escrow operations): KPIs: Open deals 312; Held ₦186,000,000.00; Disputes open 6; Avg decision time 3.2 days

- Disputes: ESC-3018 Goods: not as described | ESC-3009 Service: milestone rejected | ESC-2990 Property: keys not handed over

**Rewards** (Rewards): KPIs: Budget used ₦3.1M of ₦10M; Active campaigns 3; Referrals qualified 412; Flagged referrals 18

**Agents** (Agent network): KPIs: Active agents 640; Float total ₦184,000,000.00; Cash-in today ₦62,300,000.00; Cash-out today ₦48,100,000.00; Day-end exceptions 4
