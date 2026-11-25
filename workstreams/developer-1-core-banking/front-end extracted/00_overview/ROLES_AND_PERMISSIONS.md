# Roles and Permissions (SHARED - identical in front-end and back-end)

## Customer roles
| Role | Notes |
|---|---|
| Customer | Registered app user. KYC tier decides limits. |
| Guarantor | A customer who accepts to guarantee a cooperative loan; their savings are locked proportionally. |
| Payer | Person who owes a due in Revenue (may or may not be an app user). |
| Buyer / Seller / Agent | Escrow deal roles. |

## Tenant roles
| Product | Roles |
|---|---|
| Cooperative | Principal Admin (2-3), Admin (treasurer, secretary and similar), Member |
| Ajo / Esusu | Circle Creator/Organizer (limited powers, cannot move money alone), Member |
| Pay Am Small vendor | Owner, Manager, Order/Delivery Handler, Finance |
| Revenue collector | Owner, Treasurer, Field Collector, Auditor |

## Platform staff roles (back office)
Customer Support Agent, KYC Officer, Dispute Officer, Risk/Fraud Analyst, Compliance Officer, Finance/Reconciliation Officer, Product Admin, Super Admin.

## Core permission matrix (core banking)
| Action | Customer | Support | KYC Officer | Risk | Finance | Compliance | Super Admin |
|---|---|---|---|---|---|---|---|
| View own data | Y | - | - | - | - | - | - |
| View customer profile | - | Y (masked) | Y | Y | Y (masked) | Y | Y |
| Approve KYC tier | - | - | Y | - | - | Y | Y |
| Change limits | - | - | - | Y (request) | - | Y (approve) | Y |
| Freeze/unfreeze account | Y (own lock) | Y (request) | - | Y | - | Y | Y |
| Reverse transaction | - | request | - | request | Y (approve, dual control) | - | Y |
| Export reports | - | - | - | Y | Y | Y | Y |
| Manage staff users | - | - | - | - | - | - | Y |

## Rules
1. Least privilege. Staff see masked personal data by default; unmasking is logged.
2. Dual control (two people) for reversals, limit increases and any manual balance-affecting action.
3. Tenant isolation: a tenant admin can only see data of their own tenant.
4. Every permission check happens on the back end; the front end only hides controls.
