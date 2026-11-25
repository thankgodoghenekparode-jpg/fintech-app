# Configuration and Feature Flag Catalogue (SHARED - identical in front-end and back-end)

Everything below is a configuration value or feature flag, never a constant in code. Values are placeholders until confirmed (see DECISIONS_LOG). Config lives in `platform.config_entries` (versioned, dual-control) and flags in `platform.feature_flags`.

## Feature flags (default OFF in production until enabled deliberately)
| Flag | Purpose |
|---|---|
| `product.instant_loan` | Enable Instant Loan (needs registration status ready) |
| `product.cooperative` | Cooperative |
| `product.ajo` | Ajo / Esusu |
| `product.pay_am_small` | Pay Am Small marketplace (price-lock) |
| `product.pay_am_small.credit` | Pay Am Small credit mode (needs O-009 decision) |
| `product.escrow` | Escrow |
| `product.revenue` | Revenue (community collectors) |
| `product.revenue.gov_payments` | Pay government bills (phase 2) |
| `product.target_savings` | Target Savings |
| `product.merchant` | Merchant tools |
| `product.agents` | Agent network |
| `product.insights` / `product.rewards` | Insights and Rewards |
| `core.cards.virtual` | Virtual naira cards |
| `core.ussd` | USSD fallback |
| `core.banner.rail_degraded` | In-app banner during rail incidents |
| `core.readonly_mode` | Read-only mode during outages |

## Core configuration keys
| Key | Description | Default / status |
|---|---|---|
| `tier.limits.{tier}.per_txn / daily_out / balance_cap` | KYC tier limits | [CONFIRM WITH ZENITH] |
| `fees.transfer.interbank` etc. | Fee rules | [CONFIRM WITH ZENITH] |
| `auth.passcode.max_attempts` | Lockout attempts | 5 |
| `auth.pin.max_attempts` | PIN lockout | 3 |
| `auth.money_hold_after_reset_hours` | Hold after passcode reset | 24 |
| `auth.session.idle_minutes` | Inactivity lock | 2 (mobile), 15 (staff) |
| `transfer.quote.ttl_seconds` | Quote validity | 120 |
| `transfer.stepup.new_beneficiary_threshold_kobo` | Step-up threshold | [CONFIRM] |
| `idempotency.ttl_hours` | Key retention | 48 |
| `cards.max_per_customer` | Card cap | 5 |

## Product configuration keys (highlights)
| Key | Description | Status |
|---|---|---|
| `coop.min_admins`, `coop.max_admins` | Admin counts | 2 / 3 |
| `coop.withdrawal.cooling_off_hours`, `coop.withdrawal.large_threshold_kobo` | Large withdrawal rule | [PROPOSED] 24-48h |
| `coop.guarantee.expiry_hours` | Guarantee request expiry | 72 |
| `coop.commission.*` | Platform commission mix | [OPEN] |
| `group.trust.{level}.max_pot / max_members / limits` | Trust-level caps | [OPEN] |
| `group.min_verified_members` | Go-live minimum | 5 [PROPOSED] |
| `ajo.default_after_misses`, `ajo.grace_days`, `ajo.shortfall_rule` | Ajo delinquency | 2 / 1 / DELAY |
| `ajo.fee.*` | Platform and organizer fees | [OPEN] |
| `tgt.penalty.*`, `tgt.cooling_off_hours`, `tgt.max_goals` | Target savings rules | [OPEN] |
| `pas.commission.*`, `pas.holdback_bps`, `pas.holdback_days`, `pas.max_penalty_bps`, `pas.max_extensions` | Pay Am Small rules | [OPEN] / [PROPOSED] |
| `esc.template.{type}.timers`, `esc.min_charge_kobo`, `esc.limits.*`, `esc.dispute.window_days` | Escrow | [OPEN] |
| `rev.fee.*`, `rev.free_tier.*`, `rev.autopay.*` | Revenue fees | [OPEN] |
| `loan.product.*`, `loan.ladder.*`, `loan.collections.hours` | Loans | [OPEN] |
| `agt.commission.*`, `agt.limits.*`, `agt.cashout.code_ttl_minutes` | Agents | [OPEN] / 15 |
| `ins.reward.budget`, `ins.referral.min_txn_kobo`, `ins.referral.window_days` | Rewards | [OPEN] / 30 |
| `mer.fee.*`, `mer.limits.*` | Merchant | [OPEN] |

## Rules
1. Changes need dual control and an effective date; history is kept.
2. Clients read user-visible limits and fees from the API; they never ship their own copies.
3. Each flag has an owner and a removal date once a product is stable.
