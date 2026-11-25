# Account Closure API Unblocking Addendum

**Status: Local frontend proposal. Backend, product, compliance and legal approval are required before production submission.**

## References

- Developer 1 S-CB-083 route `/more/close-account`: explanation, zero-balance and active-product checklist, reason, PIN confirmation, blocked reasons and submitted confirmation.
- Extracted `PRD_CORE_BANKING.md`, CB-ACC-007 and CB-SET-007: account lifecycle and closure request.
- Stitch S-CB-083 is a visual reference only. Its account balances, product/dispute counts, partner names and six-year retention statement are not approved customer data or legal wording and are not copied into the app.
- `openapi_core.yaml` defines `POST /auth/pin/verify` and one-action `X-Pin-Token`, but contains no closure eligibility or request operation.

## Proposed operations

### `GET /accounts/me/closure-eligibility`

Server evaluates current balance, pending transactions, active cards, savings/groups, loans, disputes and any required settlement. It returns authoritative blockers rather than relying on potentially stale client modules.

```json
{
  "eligible": false,
  "checkedAt": "2026-11-25T09:00:00Z",
  "blockers": [
    {
      "code": "NON_ZERO_BALANCE",
      "title": "Transfer your remaining balance",
      "detail": "The account must have a zero available balance before a closure request.",
      "actionLabel": "Review account balance",
      "actionRoute": "/account-details"
    }
  ]
}
```

`actionRoute` must be an allow-listed in-app route. The server owns eligibility and must recheck it during submission to prevent stale-check races.

### `POST /accounts/me/closure-requests`

Create a closure request, not an immediate account deletion. Require `X-Pin-Token` from the existing one-action PIN verification flow and `Idempotency-Key`.

```json
{
  "reason": "OTHER_BANKING_SERVICE",
  "feedback": "Optional customer feedback"
}
```

Proposed reason values are `OTHER_BANKING_SERVICE`, `MOVING_ABROAD`, `FEES_OR_SERVICE`, `TEMPORARY_CLOSURE`, and `OTHER`; product must approve this enum before backend implementation.

Proposed response: `requestId`, `status` (`PENDING_REVIEW` or `BLOCKED`), `createdAt`, and authoritative `blockers`. Return `409`/`422` with the same blocker shape if eligibility changed after the precheck. Do not report closure as complete until the server reports a final closed state through an approved lifecycle operation.

## Frontend status

The screen reads server eligibility, shows exact backend blockers, requires a reason and a short-lived PIN token, then submits an idempotent closure request. No account is closed locally. Backend implementation, response parity, approved reason enum, customer support wording and lifecycle policy remain gates. See `SPEC_GAPS.md`.
