# Scheduled Payments API Addendum (Draft)

**Scope:** Developer 1 mobile screen S-CB-037, aligned to the Developer 1 and extracted UI specs and the Stitch `scheduled_payments_s_cb_037` reference.

**Status:** Frontend proposal for backend review. This does not assert that the backend currently supports these operations. Do not release live schedule management until backend parity, security review, and execution semantics are confirmed.

## Required operations

All routes use the existing `/api/v1` base path and bearer authentication. Amounts are integer kobo. Mutations use `Idempotency-Key`; creation and changes to payment terms also require the existing `X-Pin-Token` from `POST /auth/pin/verify`.

| Method and path | Purpose |
|---|---|
| `GET /scheduled-payments?status=ACTIVE\|PAUSED\|COMPLETED` | List schedules for the selected screen tab. |
| `POST /scheduled-payments` | Create a one-time or recurring transfer/bill schedule. |
| `PATCH /scheduled-payments/{id}` | Edit schedule terms or change status to `ACTIVE`/`PAUSED`. |
| `DELETE /scheduled-payments/{id}` | Cancel a schedule. Must not reverse an execution already submitted. |

## Proposed schedule representation

```json
{
  "id": "uuid",
  "kind": "TRANSFER",
  "beneficiaryId": "uuid",
  "billerCode": null,
  "productCode": null,
  "customerRef": null,
  "label": "Rent support",
  "amountKobo": 1500000,
  "frequency": "WEEKLY",
  "startAt": "2026-11-23T06:00:00Z",
  "endAt": null,
  "nextRunAt": "2026-11-30T06:00:00Z",
  "status": "ACTIVE",
  "lastFailureCode": null,
  "lastFailureMessage": null,
  "createdAt": "2026-11-20T12:00:00Z",
  "updatedAt": "2026-11-20T12:00:00Z"
}
```

`kind` is `TRANSFER` or `BILL`; `frequency` is `ONCE`, `DAILY`, `WEEKLY`, or `MONTHLY`; `status` is `ACTIVE`, `PAUSED`, `COMPLETED`, or `FAILED`. A transfer references a saved `beneficiaryId`. A bill references a `billerCode`, optional `productCode`, and `customerRef`. Exactly one destination shape is allowed. `label` is display-only and must not be treated as a verified beneficiary or biller name.

Create requires `kind`, the appropriate destination, `amountKobo`, `frequency`, and `startAt`; `endAt` is optional. PATCH accepts only editable terms and/or an allowed status transition. API responses return the complete schedule representation above. List results must be stable and include all matching statuses, including failed schedules in an appropriate tab or explicit failure grouping.

## Backend decisions required before production

- Confirm schedule cutoff, timezone, holiday/weekend behavior, monthly dates that do not exist, one-time completion, and `nextRunAt` calculation. The Stitch reference says 06:00 WAT; treat that as a product proposal until confirmed.
- Define execution lifecycle, insufficient-funds retry policy, failure codes, notification behavior, concurrent-update conflicts, and whether edits apply to the next run or a later run.
- Define cancellation cutoff and guarantee that pause/cancel races cannot debit after the server confirms the state change.
- Confirm biller catalog/validation schemas and whether a bill schedule can retain a validated customer reference safely.
- Confirm PIN-token scope/lifetime for schedule creation and edits, and idempotency retention/replay behavior for each mutation.
- Confirm pagination, ordering, maximum schedule count, and server authorization to the authenticated account.

Until these are answered and implemented by the backend, live list/create/edit/pause/cancel must remain unavailable. A separate clearly labelled demo preview may use fictional local fixture data and must never submit requests.
