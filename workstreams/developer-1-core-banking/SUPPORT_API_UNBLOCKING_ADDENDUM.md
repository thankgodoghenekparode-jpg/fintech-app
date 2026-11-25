# Support API Unblocking Addendum

**Status:** Developer 1 OpenAPI v1.4.0 locally proposes typed complaint tickets and ticket conversations. Backend implementation and customer-support/security/legal approval remain pending.

## Frontend scope

- S-CB-077 provides a searchable self-service help centre with articles derived only from current app behavior and contract facts. Search no-results still offers ticket filing.
- S-CB-078 provides an asynchronous text conversation over the existing ticket APIs. Starting a conversation creates a ticket whose description is the first customer message; subsequent messages are ticket replies. S-CB-080 provides active/resolved ticket lists, ticket details and a customer reply form.
- New ticket submission accepts a documented category, an optional issue reason, description, and optional linked transaction ID. S-CB-079 sends its selected reason as `issueType` and the originating transaction ID as `transactionId`.
- The ticket contract does not provide real-time agent chat, presence/typing state, agent names, voice calls, image attachment upload, or a durable offline message queue. The chat view therefore labels replies as asynchronous support-ticket messages, shows no online/typing or response-time claims, and reports failed sends while retaining the message in the editor for an explicit retry. Attachments are omitted with an API-gap notice. Phone, email, WhatsApp, regulator escalation address, and response-time/SLA promises remain unavailable unless approved service and API details are supplied.

## Proposed contract additions

- `GET /tickets` returns a typed cursor page with ticket identity, category, subject, status, timestamps and last update.
- `POST /tickets` returns the created ticket and accepts category, optional issue type, description, and optional transaction ID. Issue types are `NOT_RECEIVED`, `CHARGED_BUT_FAILED`, `WRONG_AMOUNT`, `UNAUTHORIZED`, and `OTHER`.
- `GET /tickets/{id}` returns a ticket with its typed message history.
- `POST /tickets/{id}/messages` appends a customer reply and returns the created message.
- S-CB-078 deliberately reuses these ticket operations; no separate live-chat endpoint is proposed in this revision.
- The backend must enforce ticket ownership and linked transaction ownership, validate categories, sanitize content, and provide stable pagination.

## Acceptance checklist

- [ ] Backend implements v1.4.0 ticket list/create/detail/reply responses.
- [ ] Backend confirms allowed categories, status transitions, message limits, ordering and pagination.
- [ ] Backend confirms reply delivery/ordering behavior, client retry semantics, and how customers should resume an open ticket conversation.
- [ ] Product supplies approved contact channels and availability policy.
- [ ] Legal/compliance supplies approved regulator escalation instructions and SLA language.
- [ ] Security reviews sensitive-data handling and attachment policy before attachments are added.
- [ ] Verify ticket lifecycle against backend integration environment.

This local proposal does not establish remote backend support or regulatory approval.

## Screen references

- Requirements and route: `Developer_1_Core_Banking_and_Backoffice/work_scope/03_core-banking/UI_UX_SPEC.md` (S-CB-078) and `Developer_1_Core_Banking_and_Backoffice/work_scope/06_stitch-ui-ux/04_core-banking-screen-prompts/06_more_and_settings.md`.
- Support flow and source handoff: `Developer_1_Core_Banking_and_Backoffice/work_scope/05_flowcharts-drawio/F-08_report_problem_support.md` and `front-end extracted/05_flowcharts-drawio/F-08_report_problem_support.md`.
- Stitch visual references: `Developer_1_Core_Banking_and_Backoffice_WITH_STITCH/Developer_1_Core_Banking_and_Backoffice/shared_reference/06_stitch-ui-ux/screens/support_chat_s_cb_078/` and `support_chat_dark_mode_s_cb_078/`.
- The implemented screen keeps the Stitch message-bubble layout and security reminder, but excludes sample identities/messages, green presence, typing state, call/mic controls and invented transaction details because the typed support API does not provide them.