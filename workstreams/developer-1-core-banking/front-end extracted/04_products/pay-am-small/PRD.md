# PRD - Pay Am Small (SHARED - identical in front-end and back-end)

A marketplace where verified businesses sell items and customers buy in installments. Two modes: PRICE_LOCK (customer saves into a vault, the vendor holds the item and the locked price, the item is released when the vault is full) and CREDIT (buy now pay later, vendor-funded: the vendor delivers first and is paid as installments arrive). Standalone product: it does not use the Instant Loan setup and its release flow is deliberately different from Escrow. Name pending a trademark check (O-005).

## Decisions applied
D-020, D-021, D-022; proposed P-004 (vendor holdback until delivery confirmed) and P-006 (launch price-lock first). Credit mode funding option 1 (vendor-funded) chosen.

## Roles
| Role | Description |
|---|---|
| Customer (buyer) | Verified app user who buys items and funds vaults or repays credit. |
| Vendor Owner | Owns the store tenant. |
| Vendor Manager | Manages products, prices and orders. |
| Order/Delivery Handler | Fulfils orders and records deliveries. |
| Vendor Finance | Views payouts and statements. |
| Platform staff | Vendor verification, disputes, risk, settlements. |

## Vendors and catalogue
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| PAS-VEN-001 | Any verified business can open a store: business registration details, ID of owner, bank/settlement info; staff verification; Verified Vendor badge. | P0 | Both |
| PAS-VEN-002 | Each vendor is a tenant with a dedicated Zenith-backed account/wallet and a team with roles. | P0 | Both |
| PAS-VEN-003 | Product catalogue with price, stock, images, delivery terms and whether PRICE_LOCK and/or CREDIT are offered per product. | P0 | Both |
| PAS-VEN-004 | Vendor commits to honor the locked price for the plan duration and reserves stock when a plan starts. | P0 | BE |
| PAS-VEN-005 | Vendor sees buyer verified identity and repayment history before deciding on credit orders. | P0 | Both |
| PAS-VEN-006 | Vendor dashboard: orders, plans and customers, payouts, disputes, inventory and sales reports. | P0 | Both |

## Buyer experience and plans
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| PAS-BUY-001 | Browse marketplace, search, filter, vendor storefront with ratings. | P0 | Both |
| PAS-BUY-002 | Choose purchase option per item: pay in full, price-lock plan, or credit (if offered). | P0 | Both |
| PAS-BUY-003 | Plan setup shows total price, schedule or flexibility, penalty and deadline rules, fees, who the vendor is; accepted with PIN. | P0 | Both |
| PAS-BUY-004 | One vault covers all items bought together; when it closes a new vault opens for the next purchase. | P0 | Both |
| PAS-BUY-005 | Order tracking, delivery code and receipts. | P0 | Both |

## Vault (price-lock)
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| PAS-VLT-001 | Vault funded automatically on a schedule (with consent) or manually with any amount at any time. | P0 | Both |
| PAS-VLT-002 | Failed auto-debits: retries, reminders, grace period. | P0 | Both |
| PAS-VLT-003 | Early withdrawal allowed with a penalty set at plan setup (vendor/platform rule within limits) [OPEN values]. | P0 | Both |
| PAS-VLT-004 | At deadline without full payment: customer chooses an extension or a refund minus a fee. | P0 | Both |
| PAS-VLT-005 | When the vault is full, the amount is paid to the vendor (less platform commission) and the order is released for fulfilment; there is no buyer release step (Escrow is separate). | P0 | BE |
| PAS-VLT-006 | Vendor holdback: a share of the payout released automatically when the delivery code is confirmed or after a set time [PROPOSED]. | P0 | BE |
| PAS-VLT-007 | Refund if the vendor does not fulfil within the committed days; vendor penalised and rated. | P0 | Both |

## Credit mode (vendor-funded)
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| PAS-CRD-001 | Vendor opts in per product and per order; vendor carries the risk of non-payment; terms say so clearly. | P0 | Both |
| PAS-CRD-002 | Customer repays installments through a separate repayment screen; payments pass to the vendor (less commission). | P0 | Both |
| PAS-CRD-003 | Late fees and reminders per vendor terms within platform caps; platform provides records, not collections muscle. | P1 | BE |
| PAS-CRD-004 | Whether this mode needs digital lending registration is to be confirmed with a lawyer before enabling. [OPEN O-009] | P0 | BE |

## Orders, disputes, platform
| ID | Requirement | Pri | Owner |
|---|---|---|---|
| PAS-ORD-001 | Order lifecycle with delivery code confirmation and proof. | P0 | Both |
| PAS-ORD-002 | Returns and refunds policy per vendor within platform minimums. | P1 | Both |
| PAS-ORD-003 | Order disputes handled by support with vendor response windows (distinct from Escrow). | P1 | Both |
| PAS-PLT-001 | Commission and fee configuration per vendor/category; early-withdrawal and refund fee rules. | P0 | BE |
| PAS-PLT-002 | Vendor ratings, performance score and suspension rules. | P1 | Both |

## Non-goals / later
- Escrow as an optional buyer-protection add-on (when Escrow exists)
- Vendor-funded credit financing partners
- Cross-border vendors

## Open items
- Vendor payout: full vs holdback (P-004)
- Early-withdrawal penalty and extension rules (O-006)
- Credit mode lending registration (O-009)
- Name trademark (O-005)
- Commission rates
