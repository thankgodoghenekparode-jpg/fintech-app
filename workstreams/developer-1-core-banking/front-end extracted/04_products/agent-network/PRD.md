# PRD - Cash-in / Cash-out Agent Network (SHARED - identical in front-end and back-end)

A network of agents who take cash from customers and credit their accounts (cash-in) or pay out cash against a customer's request (cash-out), earning commission. Agents hold a float wallet. Revenue field collectors can later become agents. Agent banking rules apply [CONFIRM WITH ZENITH and regulation].

## Decisions applied
D-026 (agent network chosen). Agent oversight, limits and commission are configuration. Customers and agents use the same app; agent mode is enabled for verified agents.

## Roles
| Role | Description |
|---|---|
| Agent | Verified individual or business operating a point. |
| Agent Manager / Super-agent | Oversees a group of agents (later). |
| Customer | Deposits or withdraws cash. |
| Platform staff | Onboard, monitor, reconcile, suspend. |

## Agent onboarding
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| AGT-ONB-001 | Agent application: identity (BVN, NIN, liveness), business/location details, photos; staff review; training acknowledgement. | P0 | Both |
| AGT-ONB-002 | Agent gets a float wallet (dedicated account/sub-ledger) and a unique agent code. | P0 | BE |
| AGT-ONB-003 | Agent profile appears in the locator with hours and services. | P1 | Both |
| AGT-ONB-004 | Suspension and termination rules. | P0 | BE |

## Cash-in (deposit)
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| AGT-CIN-001 | Customer gives cash; agent enters customer phone/account, confirms name, amount; PIN; agent float is debited and customer credited instantly. | P0 | Both |
| AGT-CIN-002 | Customer receives confirmation and receipt; agent receives receipt. | P0 | Both |
| AGT-CIN-003 | Per-transaction and daily limits per agent and per customer tier. | P0 | BE |

## Cash-out (withdrawal)
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| AGT-COT-001 | Customer requests withdrawal in app: amount and chosen agent (or any nearby); receives a code and the amount is held. | P0 | Both |
| AGT-COT-002 | Agent enters code and amount; customer confirms with PIN or biometric; agent pays cash; customer debited and agent float credited. | P0 | Both |
| AGT-COT-003 | Request expires after a short time; hold released automatically. | P0 | BE |
| AGT-COT-004 | Cash-out fees shown before the request. | P0 | Both |

## Float and settlement
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| AGT-FLT-001 | Agent tops up float by transfer or deposit at a branch/aggregator; float balance and low-float alerts. | P0 | Both |
| AGT-FLT-002 | Daily agent reconciliation and cash-vs-float summary. | P0 | Both |
| AGT-FLT-003 | Commission accrues per transaction by configured rate and is paid to the agent wallet on schedule. | P0 | BE |

## Locator and customer
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| AGT-LOC-001 | Customers find nearby agents (map and list) with distance, hours and services. | P0 | Both |
| AGT-LOC-002 | Customer rating and report on agents. | P1 | Both |

## Risk and compliance
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| AGT-RSK-001 | Fraud and AML monitoring on agent activity (structuring, unusual patterns); staff can limit or suspend. | P0 | BE |
| AGT-RSK-002 | Customer must be present and verified: ID prompts per rules; no cash-in for customers who are restricted. | P0 | Both |

## Non-goals / later
- Super-agent hierarchy
- Revenue field collectors as agents (integration)
- Agent loans/float financing

## Open items
- Commission rates and limits
- Agent banking licensing and Zenith rules
- Float top-up channels
- Agent liability for errors
