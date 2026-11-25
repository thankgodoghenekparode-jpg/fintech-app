# Implementation Status

Status key: Not started / In progress / Done / Blocked. In-progress screens have partial implementation and do not yet meet the handoff definition of done.

## Supplied demo screens

All 87 Developer 2 inventory entries (61 mobile and 26 web) have a reachable, clearly labeled preview using their supplied HTML and sample content. Inventory-defined screen transitions navigate between previews; form controls, filters, tabs, toggles, and clickable cards or rows respond locally. Mobile layouts fit narrow device widths, and desktop previews remain readable on small windows. Payment, money movement, and administrative decisions remain demo-only and never call a backend. These previews do not count as production integrations, so the per-screen status table below continues to track the API/session/security work required for live product flows. See `DESIGN_DEMO_MODE.md`.

| Screen ID | Route | Platform | Status | Key files | Tests |
|---|---|---|---|---|---|
| S-AGT-001 | /agent | M | Blocked | mobile/lib/features/agent_network/presentation/agent_home_demo_screen.dart; mobile/lib/features/agent_network/presentation/agent_network_screen.dart | Demo widget test |
| S-AGT-002 | /agent/cash-in | M | Blocked | mobile/lib/features/agent_network/presentation/agent_network_screen.dart | Not added |
| S-AGT-003 | /agent/cash-out | M | Blocked | mobile/lib/features/agent_network/presentation/agent_network_screen.dart | Not added |
| S-AGT-004 | /agent/float | M | Blocked | mobile/lib/features/agent_network/presentation/agent_network_screen.dart | Not added |
| S-AGT-005 | /agent/history | M | Blocked | mobile/lib/features/agent_network/presentation/agent_network_screen.dart | Not added |
| S-AGT-006 | /agent/day-end | M | Blocked | mobile/lib/features/agent_network/presentation/agent_network_screen.dart | Not added |
| S-AGT-007 | /agent/apply | M | Blocked | mobile/lib/features/agent_network/presentation/agent_network_screen.dart | Not added |
| S-AGT-010 | /agents/nearby | M | Blocked | mobile/lib/features/agent_network/presentation/agent_network_screen.dart | Not added |
| S-AGT-011 | /agents/cash-in | M | Blocked | mobile/lib/features/agent_network/presentation/agent_network_screen.dart | Not added |
| S-AGT-012 | /agents/cash-out | M | Blocked | mobile/lib/features/agent_network/presentation/agent_network_screen.dart | Not added |
| S-AGT-013 | /agents/:id/feedback | M | Blocked | mobile/lib/features/agent_network/presentation/agent_network_screen.dart | Not added |
| W-AGT-001 | /backoffice/agents | W | Blocked | web/src/app/backoffice/agents/page.tsx | Not added |
| W-AGT-002 | /backoffice/agents/float | W | Blocked | web/src/app/backoffice/agents/float/page.tsx | Not added |
| W-AGT-003 | /backoffice/agents/config | W | Blocked | web/src/app/backoffice/agents/config/page.tsx | Not added |
| S-AJO-001 | /ajo | M | In progress | mobile/lib/features/ajo_esusu/presentation/ajo_home_screen.dart | Not added |
| S-AJO-002 | /ajo/new | M | In progress | mobile/lib/features/ajo_esusu/presentation/create_circle_screen.dart | Not added |
| S-AJO-003 | /ajo/:id/invite | M | Blocked | mobile/lib/features/ajo_esusu/presentation/circle_flow_screens.dart | Not added |
| S-AJO-004 | /ajo/join | M | Blocked | mobile/lib/features/ajo_esusu/presentation/join_circle_screen.dart | Not added |
| S-AJO-005 | /ajo/:id | M | Blocked | mobile/lib/features/ajo_esusu/presentation/circle_flow_screens.dart | Not added |
| S-AJO-006 | /ajo/:id/schedule | M | Blocked | mobile/lib/features/ajo_esusu/presentation/circle_flow_screens.dart | Not added |
| S-AJO-007 | /ajo/:id/pay | M | Blocked | mobile/lib/features/ajo_esusu/presentation/circle_flow_screens.dart | Not added |
| S-AJO-008 | /ajo/:id/protection | M | Blocked | mobile/lib/features/ajo_esusu/presentation/circle_flow_screens.dart | Not added |
| S-AJO-009 | /ajo/:id/guarantee/:gid | M | Blocked | mobile/lib/features/ajo_esusu/presentation/circle_flow_screens.dart | Not added |
| S-AJO-010 | /ajo/:id/order | M | Blocked | mobile/lib/features/ajo_esusu/presentation/circle_flow_screens.dart | Not added |
| S-AJO-011 | /ajo/:id/rounds/:rid | M | Blocked | mobile/lib/features/ajo_esusu/presentation/circle_flow_screens.dart | Not added |
| S-AJO-012 | /ajo/:id/members | M | Blocked | mobile/lib/features/ajo_esusu/presentation/circle_flow_screens.dart | Not added |
| S-AJO-013 | /ajo/:id/report | M | Blocked | mobile/lib/features/ajo_esusu/presentation/report_concern_screen.dart | Not added |
| S-AJO-014 | /ajo/:id/summary | M | Blocked | mobile/lib/features/ajo_esusu/presentation/circle_flow_screens.dart | Not added |
| W-AJO-001 | /group/:t/ajo | W | In progress | web/src/app/group/[t]/ajo/page.tsx | Not added |
| S-COOP-001 | /coop | M | In progress | mobile/lib/features/cooperative/presentation/cooperative_home_screen.dart | Not added |
| S-COOP-002 | /coop/new | M | Blocked | mobile/lib/features/cooperative/presentation/create_cooperative_screen.dart | Not added |
| S-COOP-003 | /coop/join | M | Blocked | mobile/lib/features/cooperative/presentation/join_cooperative_screen.dart | Not added |
| S-COOP-004 | /coop/:id | M | Blocked | mobile/lib/features/cooperative/presentation/cooperative_overview_screen.dart | Not added |
| S-COOP-005 | /coop/:id/contributions | M | Blocked | mobile/lib/features/cooperative/presentation/contributions_screen.dart | Not added |
| S-COOP-006 | /coop/:id/contributions/pay | M | Blocked | mobile/lib/features/cooperative/presentation/cooperative_flow_screen.dart | Not added |
| S-COOP-007 | /coop/:id/shares | M | Blocked | mobile/lib/features/cooperative/presentation/shares_screen.dart | Not added |
| S-COOP-008 | /coop/:id/loans | M | Blocked | mobile/lib/features/cooperative/presentation/loans_overview_screen.dart | Not added |
| S-COOP-009 | /coop/:id/loans/new | M | Blocked | mobile/lib/features/cooperative/presentation/cooperative_flow_screen.dart | Not added |
| S-COOP-010 | /coop/:id/loans/new/guarantors | M | Blocked | mobile/lib/features/cooperative/presentation/cooperative_flow_screen.dart | Not added |
| S-COOP-011 | /coop/:id/guarantees/:gid | M | Blocked | mobile/lib/features/cooperative/presentation/cooperative_flow_screen.dart | Not added |
| S-COOP-012 | /coop/:id/loans/:lid | M | Blocked | mobile/lib/features/cooperative/presentation/cooperative_flow_screen.dart | Not added |
| S-COOP-013 | /coop/:id/loans/:lid/repay | M | Blocked | mobile/lib/features/cooperative/presentation/cooperative_flow_screen.dart | Not added |
| S-COOP-014 | /coop/:id/statement | M | Blocked | mobile/lib/features/cooperative/presentation/statement_screen.dart | Not added |
| S-COOP-015 | /coop/:id/hub | M | Blocked | mobile/lib/features/cooperative/presentation/cooperative_hub_screen.dart | Not added |
| S-COOP-016 | /coop/:id/leave | M | Blocked | mobile/lib/features/cooperative/presentation/leave_cooperative_screen.dart | Not added |
| S-COOP-017 | /coop/:id/admin/approvals | M | Blocked | mobile/lib/features/cooperative/presentation/admin_approvals_screen.dart | Not added |
| W-COOP-001 | /group/:t/dashboard | W | In progress | web/src/app/group/[t]/dashboard/page.tsx | Not added |
| W-COOP-002 | /group/:t/members | W | In progress | web/src/app/group/[t]/members/page.tsx | Not added |
| W-COOP-003 | /group/:t/join-requests | W | Blocked | web/src/app/group/[t]/join-requests/page.tsx | Not added |
| W-COOP-004 | /group/:t/contributions | W | Blocked | web/src/app/group/[t]/contributions/page.tsx | Not added |
| W-COOP-005 | /group/:t/loan-applications | W | Blocked | web/src/app/group/[t]/loan-applications/page.tsx | Not added |
| W-COOP-006 | /group/:t/loans | W | Blocked | web/src/app/group/[t]/loans/page.tsx | Not added |
| W-COOP-007 | /group/:t/shares | W | Blocked | web/src/app/group/[t]/shares/page.tsx | Not added |
| W-COOP-008 | /group/:t/rules | W | Blocked | web/src/app/group/[t]/rules/page.tsx | Not added |
| W-COOP-009 | /group/:t/admins | W | Blocked | web/src/app/group/[t]/admins/page.tsx | Not added |
| W-COOP-010 | /group/:t/reports | W | Blocked | web/src/app/group/[t]/reports/page.tsx | Not added |
| W-COOP-011 | /group/:t/withdrawals | W | Blocked | web/src/app/group/[t]/withdrawals/page.tsx | Not added |
| W-COOP-012 | /group/:t/hub | W | Blocked | web/src/app/group/[t]/hub/page.tsx | Not added |
| W-COOP-013 | /group/:t/audit | W | Blocked | web/src/app/group/[t]/audit/page.tsx | Not added |
| W-COOP-014 | /group/:t/verification | W | Blocked | web/src/app/group/[t]/verification/page.tsx | Not added |
| S-REV-001 | /dues | M | Blocked | mobile/lib/features/revenue/presentation/revenue_screen.dart | Not added |
| S-REV-002 | /dues/:id | M | Blocked | mobile/lib/features/revenue/presentation/revenue_screen.dart | Not added |
| S-REV-003 | /dues/link | M | Blocked | mobile/lib/features/revenue/presentation/revenue_screen.dart | Not added |
| S-REV-004 | /dues/receipts | M | Blocked | mobile/lib/features/revenue/presentation/revenue_screen.dart | Not added |
| S-REV-005 | /dues/:id/dispute | M | Blocked | mobile/lib/features/revenue/presentation/revenue_screen.dart | Not added |
| S-REV-006 | /dues/behalf | M | Blocked | mobile/lib/features/revenue/presentation/revenue_screen.dart | Not added |
| S-REV-007 | /dues/autopay | M | Blocked | mobile/lib/features/revenue/presentation/revenue_screen.dart | Not added |
| S-REV-008 | /dues/:id/report | M | Blocked | mobile/lib/features/revenue/presentation/revenue_screen.dart | Not added |
| S-REV-009 | /collect | M | Blocked | mobile/lib/features/revenue/presentation/revenue_screen.dart | Not added |
| S-REV-010 | /collect/:payer | M | Blocked | mobile/lib/features/revenue/presentation/revenue_screen.dart | Not added |
| W-REV-001 | /collector/:t/dashboard | W | Blocked | web/src/app/collector/[t]/dashboard/page.tsx | Not added |
| W-REV-002 | /collector/:t/items | W | Blocked | web/src/app/collector/[t]/items/page.tsx | Not added |
| W-REV-003 | /collector/:t/payers | W | Blocked | web/src/app/collector/[t]/payers/page.tsx | Not added |
| W-REV-004 | /collector/:t/collections | W | Blocked | web/src/app/collector/[t]/collections/page.tsx | Not added |
| W-REV-005 | /collector/:t/field | W | Blocked | web/src/app/collector/[t]/field/page.tsx | Not added |
| W-REV-006 | /collector/:t/settlement | W | Blocked | web/src/app/collector/[t]/settlement/page.tsx | Not added |
| W-REV-007 | /collector/:t/reports | W | Blocked | web/src/app/collector/[t]/reports/page.tsx | Not added |
| W-REV-008 | /collector/:t/verification | W | Blocked | web/src/app/collector/[t]/verification/page.tsx | Not added |
| S-TGT-001 | /targets | M | In progress | mobile/lib/main.dart, mobile/lib/features/target_savings/presentation/target_savings_demo_screen.dart | Not added |
| S-TGT-002 | /targets/new | M | In progress | mobile/lib/features/target_savings/presentation/create_goal_screen.dart | Not added |
| S-TGT-003 | /targets/:id | M | Blocked | mobile/lib/features/target_savings/presentation/target_goal_flow_screens.dart | Not added |
| S-TGT-004 | /targets/:id/add | M | In progress | mobile/lib/features/target_savings/presentation/target_top_up_screen.dart | Not added |
| S-TGT-005 | /targets/:id/auto | M | In progress | mobile/lib/features/target_savings/presentation/auto_save_setup_screen.dart | Not added |
| S-TGT-006 | /targets/:id/withdraw | M | Blocked | mobile/lib/features/target_savings/presentation/target_goal_flow_screens.dart | Not added |
| S-TGT-007 | /targets/:id/edit | M | Blocked | mobile/lib/features/target_savings/presentation/target_goal_flow_screens.dart | Not added |
| S-TGT-008 | /targets/:id/whatif | M | Blocked | mobile/lib/features/target_savings/presentation/target_goal_flow_screens.dart | Not added |
| S-TGT-009 | /targets/rules | M | Blocked | mobile/lib/features/target_savings/presentation/target_goal_flow_screens.dart | Not added |



