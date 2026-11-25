import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/i18n/app_text.dart';
import 'core/demo/reference_demo_screen.dart';
import 'core/demo/reference_demo_gallery_screen.dart';
import 'core/demo/more_demo_screen.dart';
import 'features/ajo_esusu/presentation/ajo_home_screen.dart';
import 'features/ajo_esusu/presentation/create_circle_screen.dart';
import 'features/ajo_esusu/presentation/circle_flow_screens.dart';
import 'features/ajo_esusu/presentation/join_circle_screen.dart';
import 'features/ajo_esusu/presentation/report_concern_screen.dart';
import 'features/cooperative/presentation/cooperative_home_screen.dart';
import 'features/cooperative/presentation/admin_approvals_screen.dart';
import 'features/cooperative/presentation/cooperative_hub_screen.dart';
import 'features/cooperative/presentation/cooperative_flow_screen.dart';
import 'features/cooperative/presentation/cooperative_overview_screen.dart';
import 'features/cooperative/presentation/contributions_screen.dart';
import 'features/cooperative/presentation/create_cooperative_screen.dart';
import 'features/cooperative/presentation/join_cooperative_screen.dart';
import 'features/cooperative/presentation/leave_cooperative_screen.dart';
import 'features/cooperative/presentation/loans_overview_screen.dart';
import 'features/cooperative/presentation/shares_screen.dart';
import 'features/cooperative/presentation/statement_screen.dart';
import 'features/target_savings/presentation/create_goal_screen.dart';
import 'features/target_savings/presentation/auto_save_setup_screen.dart';
import 'features/target_savings/presentation/target_goal_flow_screens.dart';
import 'features/target_savings/presentation/target_top_up_screen.dart';
import 'features/target_savings/presentation/target_savings_demo_screen.dart';
import 'features/agent_network/presentation/agent_network_screen.dart';
import 'features/agent_network/presentation/agent_home_demo_screen.dart';
import 'features/revenue/presentation/revenue_screen.dart';

void main() {
  runApp(const ProviderScope(child: DeveloperTwoApp()));
}

String? _designScreenIdForPath(String path) {
  const exactRoutes = <String, String>{
    '/agent': 'S-AGT-001',
    '/agent/cash-in': 'S-AGT-002',
    '/agent/cash-out': 'S-AGT-003',
    '/agent/float': 'S-AGT-004',
    '/agent/history': 'S-AGT-005',
    '/agent/day-end': 'S-AGT-006',
    '/agent/apply': 'S-AGT-007',
    '/agents/nearby': 'S-AGT-010',
    '/agents/cash-in': 'S-AGT-011',
    '/agents/cash-out': 'S-AGT-012',
    '/ajo': 'S-AJO-001',
    '/ajo/new': 'S-AJO-002',
    '/ajo/join': 'S-AJO-004',
    '/coop': 'S-COOP-001',
    '/coop/new': 'S-COOP-002',
    '/coop/join': 'S-COOP-003',
    '/targets': 'S-TGT-001',
    '/targets/new': 'S-TGT-002',
    '/targets/rules': 'S-TGT-009',
    '/dues': 'S-REV-001',
    '/dues/link': 'S-REV-003',
    '/dues/receipts': 'S-REV-004',
    '/dues/behalf': 'S-REV-006',
    '/dues/autopay': 'S-REV-007',
    '/collect': 'S-REV-009',
  };
  final exact = exactRoutes[path];
  if (exact != null) return exact;

  const patterns = <(String, String)>[
    (r'^/agents/[^/]+/feedback$', 'S-AGT-013'),
    (r'^/ajo/[^/]+/invite$', 'S-AJO-003'),
    (r'^/ajo/[^/]+/schedule$', 'S-AJO-006'),
    (r'^/ajo/[^/]+/pay$', 'S-AJO-007'),
    (r'^/ajo/[^/]+/protection$', 'S-AJO-008'),
    (r'^/ajo/[^/]+/guarantee/[^/]+$', 'S-AJO-009'),
    (r'^/ajo/[^/]+/order$', 'S-AJO-010'),
    (r'^/ajo/[^/]+/rounds/[^/]+$', 'S-AJO-011'),
    (r'^/ajo/[^/]+/members$', 'S-AJO-012'),
    (r'^/ajo/[^/]+/report$', 'S-AJO-013'),
    (r'^/ajo/[^/]+/summary$', 'S-AJO-014'),
    (r'^/ajo/[^/]+$', 'S-AJO-005'),
    (r'^/coop/[^/]+/contributions/pay$', 'S-COOP-006'),
    (r'^/coop/[^/]+/contributions$', 'S-COOP-005'),
    (r'^/coop/[^/]+/shares$', 'S-COOP-007'),
    (r'^/coop/[^/]+/loans/new/guarantors$', 'S-COOP-010'),
    (r'^/coop/[^/]+/loans/new$', 'S-COOP-009'),
    (r'^/coop/[^/]+/guarantees/[^/]+$', 'S-COOP-011'),
    (r'^/coop/[^/]+/loans/[^/]+/repay$', 'S-COOP-013'),
    (r'^/coop/[^/]+/loans/[^/]+$', 'S-COOP-012'),
    (r'^/coop/[^/]+/loans$', 'S-COOP-008'),
    (r'^/coop/[^/]+/statement$', 'S-COOP-014'),
    (r'^/coop/[^/]+/hub$', 'S-COOP-015'),
    (r'^/coop/[^/]+/leave$', 'S-COOP-016'),
    (r'^/coop/[^/]+/admin/approvals$', 'S-COOP-017'),
    (r'^/coop/[^/]+$', 'S-COOP-004'),
    (r'^/targets/[^/]+/add$', 'S-TGT-004'),
    (r'^/targets/[^/]+/auto$', 'S-TGT-005'),
    (r'^/targets/[^/]+/withdraw$', 'S-TGT-006'),
    (r'^/targets/[^/]+/edit$', 'S-TGT-007'),
    (r'^/targets/[^/]+/whatif$', 'S-TGT-008'),
    (r'^/targets/[^/]+$', 'S-TGT-003'),
    (r'^/dues/[^/]+/dispute$', 'S-REV-005'),
    (r'^/dues/[^/]+/report$', 'S-REV-008'),
    (r'^/dues/[^/]+$', 'S-REV-002'),
    (r'^/collect/[^/]+$', 'S-REV-010'),
  ];
  for (final (pattern, screenId) in patterns) {
    if (RegExp(pattern).hasMatch(path)) return screenId;
  }
  return null;
}

class DeveloperTwoApp extends StatelessWidget {
  const DeveloperTwoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppText.appTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF8E1B4A)),
        useMaterial3: true,
      ),
      routerConfig: GoRouter(
        redirect: (context, state) {
          if (!const bool.fromEnvironment('DEVELOPER_TWO_DESIGN_DEMO')) {
            return null;
          }
          final screenId = _designScreenIdForPath(state.uri.path);
          if (screenId == null) return null;
          return '/design-preview/$screenId?from=${Uri.encodeQueryComponent(state.uri.path)}';
        },
        routes: [
          GoRoute(
            path: '/design-previews',
            builder: (context, state) => const ReferenceDemoGalleryScreen(),
          ),
          GoRoute(
            path: '/more',
            builder: (context, state) => const MoreDemoScreen(),
          ),
          GoRoute(
            path: '/design-preview/:screenId',
            builder: (context, state) {
              final screenId = state.pathParameters['screenId']!;
              if (screenId == 'S-AGT-001') {
                return const AgentHomeDemoScreen();
              }
              return ReferenceDemoScreen(
                screenId: screenId,
                sourceRoute: state.uri.queryParameters['from'] ?? '',
              );
            },
          ),
          GoRoute(
              path: '/',
              builder: (context, state) => const WorkstreamHomePage()),
          GoRoute(
            path: '/coop',
            builder: (context, state) => const CooperativeHomeScreen(),
          ),
          GoRoute(
            path: '/coop/new',
            builder: (context, state) => const CreateCooperativeScreen(),
          ),
          GoRoute(
            path: '/coop/join',
            builder: (context, state) => const JoinCooperativeScreen(),
          ),
          GoRoute(
            path: '/coop/:id',
            builder: (context, state) => CooperativeOverviewScreen(
              cooperativeId: state.pathParameters['id']!,
            ),
          ),
          GoRoute(
            path: '/coop/:id/contributions',
            builder: (context, state) => ContributionsScreen(
              cooperativeId: state.pathParameters['id']!,
            ),
          ),
          GoRoute(
            path: '/coop/:id/contributions/pay',
            builder: (context, state) => CooperativeFlowUnavailableScreen(
              cooperativeId: state.pathParameters['id']!,
              title: 'Pay contribution',
              description:
                  'Review the due amount and payment source before confirming.',
            ),
          ),
          GoRoute(
            path: '/coop/:id/shares',
            builder: (context, state) => SharesScreen(
              cooperativeId: state.pathParameters['id']!,
            ),
          ),
          GoRoute(
            path: '/coop/:id/loans',
            builder: (context, state) => LoansOverviewScreen(
              cooperativeId: state.pathParameters['id']!,
            ),
          ),
          GoRoute(
            path: '/coop/:id/loans/new',
            builder: (context, state) => CooperativeFlowUnavailableScreen(
              cooperativeId: state.pathParameters['id']!,
              title: 'Request a loan',
              description:
                  'Review eligibility, amount, repayment term, and guarantor requirements.',
            ),
          ),
          GoRoute(
            path: '/coop/:id/loans/new/guarantors',
            builder: (context, state) => CooperativeFlowUnavailableScreen(
              cooperativeId: state.pathParameters['id']!,
              title: 'Choose guarantors',
              description:
                  'Select eligible cooperative members to support the loan request.',
            ),
          ),
          GoRoute(
            path: '/coop/:id/guarantees/:gid',
            builder: (context, state) => CooperativeFlowUnavailableScreen(
              cooperativeId: state.pathParameters['id']!,
              recordId: state.pathParameters['gid'],
              title: 'Guarantee request',
              description:
                  'Review the borrower, amount, and liability before responding.',
            ),
          ),
          GoRoute(
            path: '/coop/:id/loans/:lid',
            builder: (context, state) => CooperativeFlowUnavailableScreen(
              cooperativeId: state.pathParameters['id']!,
              recordId: state.pathParameters['lid'],
              title: 'Loan details',
              description:
                  'Review the loan balance, repayment schedule, and guarantees.',
            ),
          ),
          GoRoute(
            path: '/coop/:id/loans/:lid/repay',
            builder: (context, state) => CooperativeFlowUnavailableScreen(
              cooperativeId: state.pathParameters['id']!,
              recordId: state.pathParameters['lid'],
              title: 'Repay loan',
              description:
                  'Review the amount and repayment allocation before paying.',
            ),
          ),
          GoRoute(
            path: '/coop/:id/hub',
            builder: (context, state) => CooperativeHubScreen(
              cooperativeId: state.pathParameters['id']!,
            ),
          ),
          GoRoute(
            path: '/coop/:id/leave',
            builder: (context, state) => LeaveCooperativeScreen(
              cooperativeId: state.pathParameters['id']!,
            ),
          ),
          GoRoute(
            path: '/coop/:id/statement',
            builder: (context, state) => CooperativeStatementScreen(
              cooperativeId: state.pathParameters['id']!,
            ),
          ),
          GoRoute(
            path: '/coop/:id/admin/approvals',
            builder: (context, state) => AdminApprovalsScreen(
              cooperativeId: state.pathParameters['id']!,
            ),
          ),
          GoRoute(
            path: '/ajo',
            builder: (context, state) => const AjoHomeScreen(),
          ),
          GoRoute(
            path: '/ajo/new',
            builder: (context, state) => const CreateCircleScreen(),
          ),
          GoRoute(
            path: '/ajo/join',
            builder: (context, state) => const JoinCircleScreen(),
          ),
          GoRoute(
            path: '/ajo/:id',
            builder: (context, state) => AjoCircleUnavailableScreen(
              circleId: state.pathParameters['id']!,
              title: 'Circle overview',
              description:
                  'Review the circle, members, rounds, and contributions.',
            ),
          ),
          GoRoute(
            path: '/ajo/:id/invite',
            builder: (context, state) => AjoCircleUnavailableScreen(
              circleId: state.pathParameters['id']!,
              title: 'Invite members',
              description:
                  'Share an invite code so trusted members can preview and join.',
            ),
          ),
          GoRoute(
            path: '/ajo/:id/schedule',
            builder: (context, state) => AjoCircleUnavailableScreen(
              circleId: state.pathParameters['id']!,
              title: 'My payout schedule',
              description:
                  'See your slot and the upcoming contribution rounds.',
            ),
          ),
          GoRoute(
            path: '/ajo/:id/pay',
            builder: (context, state) => AjoCircleUnavailableScreen(
              circleId: state.pathParameters['id']!,
              title: 'Pay a contribution',
              description: 'Review a due round before making a contribution.',
            ),
          ),
          GoRoute(
            path: '/ajo/:id/protection',
            builder: (context, state) => AjoCircleUnavailableScreen(
              circleId: state.pathParameters['id']!,
              title: 'Circle protection',
              description:
                  'Review the circle protection option and your coverage.',
            ),
          ),
          GoRoute(
            path: '/ajo/:id/guarantee/:gid',
            builder: (context, state) => AjoCircleUnavailableScreen(
              circleId: state.pathParameters['id']!,
              title: 'Guarantee request',
              description:
                  'Review the request and its terms before responding.',
            ),
          ),
          GoRoute(
            path: '/ajo/:id/order',
            builder: (context, state) => AjoCircleUnavailableScreen(
              circleId: state.pathParameters['id']!,
              title: 'Payout order',
              description:
                  'Review how payout slots are selected and confirmed.',
            ),
          ),
          GoRoute(
            path: '/ajo/:id/rounds/:rid',
            builder: (context, state) => AjoCircleUnavailableScreen(
              circleId: state.pathParameters['id']!,
              title: 'Round details',
              description: 'Review the round contributions and payout status.',
            ),
          ),
          GoRoute(
            path: '/ajo/:id/members',
            builder: (context, state) => AjoCircleUnavailableScreen(
              circleId: state.pathParameters['id']!,
              title: 'Circle members',
              description: 'Review the circle roster and member trust badges.',
            ),
          ),
          GoRoute(
            path: '/ajo/:id/summary',
            builder: (context, state) => AjoCircleUnavailableScreen(
              circleId: state.pathParameters['id']!,
              title: 'Cycle summary',
              description:
                  'Review the completed cycle before deciding what to do next.',
            ),
          ),
          GoRoute(
            path: '/ajo/:id/report',
            builder: (context, state) => ReportConcernScreen(
              circleId: state.pathParameters['id']!,
            ),
          ),
          GoRoute(
            path: '/targets',
            builder: (context, state) => const TargetSavingsHomeScreen(),
          ),
          GoRoute(
            path: '/targets/new',
            builder: (context, state) => const CreateGoalScreen(),
          ),
          GoRoute(
            path: '/targets/:id',
            builder: (context, state) => TargetGoalUnavailableScreen(
              goalId: state.pathParameters['id']!,
              title: 'Goal details',
              description:
                  'Track progress, review activity, and manage your savings goal.',
            ),
          ),
          GoRoute(
            path: '/targets/:id/add',
            builder: (context, state) => TargetGoalTopUpScreen(
              goalId: state.pathParameters['id']!,
            ),
          ),
          GoRoute(
            path: '/targets/:id/auto',
            builder: (context, state) => AutoSaveSetupScreen(
              goalId: state.pathParameters['id']!,
            ),
          ),
          GoRoute(
            path: '/targets/:id/withdraw',
            builder: (context, state) => TargetGoalUnavailableScreen(
              goalId: state.pathParameters['id']!,
              title: 'Withdraw from goal',
              description:
                  'Review a withdrawal quote before deciding to withdraw.',
            ),
          ),
          GoRoute(
            path: '/targets/:id/edit',
            builder: (context, state) => TargetGoalUnavailableScreen(
              goalId: state.pathParameters['id']!,
              title: 'Edit or pause goal',
              description:
                  'Update goal details or pause it according to the product rules.',
            ),
          ),
          GoRoute(
            path: '/targets/:id/whatif',
            builder: (context, state) => TargetGoalUnavailableScreen(
              goalId: state.pathParameters['id']!,
              title: 'Savings projection',
              description:
                  'Explore how a different contribution amount could affect your target date.',
            ),
          ),
          GoRoute(
            path: '/targets/rules',
            builder: (context, state) => const TargetGoalUnavailableScreen(
              title: 'Target savings rules',
              description:
                  'Review limits, withdrawal timing, and goal maturity rules.',
            ),
          ),
          GoRoute(
            path: '/agent',
            builder: (context, state) => const AgentNetworkScreen(
              title: 'Agent home',
              description: 'Review float, today’s activity, and commission.',
              actions: ['Cash-in', 'Cash-out', 'Top up float'],
            ),
          ),
          GoRoute(
            path: '/agent/cash-in',
            builder: (context, state) => const AgentNetworkScreen(
              title: 'Cash-in',
              description: 'Credit a customer account after receiving cash.',
              fields: ['Customer phone or account', 'Amount in naira'],
              actions: ['Confirm cash-in'],
            ),
          ),
          GoRoute(
            path: '/agent/cash-out',
            builder: (context, state) => const AgentNetworkScreen(
              title: 'Cash-out',
              description:
                  'Redeem a customer cash-out code after checking the amount and confirmation.',
              fields: ['Cash-out code', 'Amount in naira'],
              actions: ['Redeem code'],
            ),
          ),
          GoRoute(
            path: '/agent/float',
            builder: (context, state) => const AgentNetworkScreen(
              title: 'Float top-up',
              description:
                  'Review supported float funding methods and pending credits.',
              fields: ['Amount in naira', 'Funding method'],
              actions: ['Top up float'],
            ),
          ),
          GoRoute(
            path: '/agent/history',
            builder: (context, state) => const AgentNetworkScreen(
              title: 'Commission and history',
              description:
                  'Review agent transactions and commission for a selected date range.',
              fields: ['From date', 'To date'],
              actions: ['Export statement'],
            ),
          ),
          GoRoute(
            path: '/agent/day-end',
            builder: (context, state) => const AgentNetworkScreen(
              title: 'Day-end summary',
              description:
                  'Reconcile declared cash against float and transaction activity.',
              fields: ['Declared cash in naira', 'Notes'],
              actions: ['Submit day-end'],
            ),
          ),
          GoRoute(
            path: '/agent/apply',
            builder: (context, state) => const AgentNetworkScreen(
              title: 'Become an agent',
              description:
                  'Start an agent application with identity, location, and business details.',
              fields: [
                'Identity details',
                'Business and location',
                'Business photos'
              ],
              actions: ['Submit application'],
            ),
          ),
          GoRoute(
            path: '/agents/nearby',
            builder: (context, state) => const AgentNetworkScreen(
              title: 'Find an agent',
              description:
                  'Find nearby agents and review their services and opening hours.',
              actions: ['List view', 'Map view'],
            ),
          ),
          GoRoute(
            path: '/agents/cash-in',
            builder: (context, state) => const AgentNetworkScreen(
              title: 'Cash-in at an agent',
              description:
                  'Show an agent the account details needed to credit your account.',
              fields: ['Your account or phone'],
              actions: ['Done'],
            ),
          ),
          GoRoute(
            path: '/agents/cash-out',
            builder: (context, state) => const AgentNetworkScreen(
              title: 'Request cash-out',
              description: 'Request a cash-out code for a nearby agent.',
              fields: ['Amount in naira', 'Agent (optional)'],
              actions: ['Request code'],
            ),
          ),
          GoRoute(
            path: '/agents/:id/feedback',
            builder: (context, state) => const AgentNetworkScreen(
              title: 'Rate or report agent',
              description:
                  'Share feedback about this agent or report a concern.',
              fields: ['Rating', 'Comment'],
              actions: ['Submit feedback'],
            ),
          ),
          GoRoute(
            path: '/dues',
            builder: (context, state) => const RevenueScreen(
              title: 'Dues and levies',
              description: 'Review bills from organizations and collectors.',
            ),
          ),
          GoRoute(
            path: '/dues/:id',
            builder: (context, state) => const RevenueScreen(
              title: 'Due detail and pay',
              description: 'Review a bill, fee quote, and payment options.',
              actions: ['Pay this bill'],
            ),
          ),
          GoRoute(
            path: '/dues/link',
            builder: (context, state) => const RevenueScreen(
              title: 'Link to collector',
              description:
                  'Enter a collector link and review it before accepting.',
              fields: ['Collector link or code'],
              actions: ['Preview and accept link'],
            ),
          ),
          GoRoute(
            path: '/dues/receipts',
            builder: (context, state) => const RevenueScreen(
              title: 'Receipts',
              description: 'Review receipts for your bill payments.',
            ),
          ),
          GoRoute(
            path: '/dues/:id/dispute',
            builder: (context, state) => const RevenueScreen(
              title: 'This isn’t mine',
              description: 'Dispute a bill that does not belong to you.',
              fields: ['Reason for dispute'],
              actions: ['Submit dispute'],
            ),
          ),
          GoRoute(
            path: '/dues/behalf',
            builder: (context, state) => const RevenueScreen(
              title: 'Pay on behalf',
              description: 'Find a bill and pay it for another person.',
              fields: ['Payer phone or bill reference'],
              actions: ['Review bill'],
            ),
          ),
          GoRoute(
            path: '/dues/autopay',
            builder: (context, state) => const RevenueScreen(
              title: 'Auto-pay settings',
              description: 'Manage consent for automatic bill payments.',
              fields: ['Select bill', 'Payment account'],
              actions: ['Save auto-pay settings'],
            ),
          ),
          GoRoute(
            path: '/dues/:id/report',
            builder: (context, state) => const RevenueScreen(
              title: 'Report abuse',
              description: 'Report a collector or a concerning bill request.',
              fields: ['Report details'],
              actions: ['Submit report'],
            ),
          ),
          GoRoute(
            path: '/collect',
            builder: (context, state) => const RevenueScreen(
              title: 'Find payer',
              description: 'Search for a payer and review the amount due.',
              fields: ['Payer phone or reference'],
              actions: ['Find payer'],
            ),
          ),
          GoRoute(
            path: '/collect/:payer',
            builder: (context, state) => const RevenueScreen(
              title: 'Record cash',
              description: 'Record a cash payment collected from a payer.',
              fields: ['Amount received in naira', 'Receipt reference'],
              actions: ['Record cash payment'],
            ),
          ),
        ],
      ),
    );
  }
}

class WorkstreamHomePage extends StatelessWidget {
  const WorkstreamHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppText.appTitle)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(AppText.heading,
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          const Text(AppText.description),
          const SizedBox(height: 24),
          if (const bool.fromEnvironment('DEVELOPER_TWO_DESIGN_DEMO')) ...[
            Card(
              child: ListTile(
                leading: const Icon(Icons.collections_outlined),
                title: const Text('Browse supplied design previews'),
                subtitle: const Text('61 mobile screens · sample content only'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.go('/design-previews'),
              ),
            ),
            const SizedBox(height: 12),
          ],
          for (final product in AppText.products)
            Card(
              child: ListTile(
                title: Text(product),
                trailing: const Icon(Icons.chevron_right),
                onTap: product == AppText.products.first
                    ? () => context.go('/coop')
                    : product == AppText.products[1]
                        ? () => context.go('/ajo')
                        : product == AppText.products[2]
                            ? () => context.go('/targets')
                            : product == AppText.products[3]
                                ? () => context.go('/dues')
                                : product == AppText.products[4]
                                    ? () => context.go('/agent')
                                    : null,
              ),
            ),
        ],
      ),
    );
  }
}

class TargetSavingsHomeScreen extends StatelessWidget {
  const TargetSavingsHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (const bool.fromEnvironment('TARGET_SAVINGS_DEMO')) {
      return const TargetSavingsDemoScreen();
    }
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text(AppText.targetSavings)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(AppText.targetSavingsIntro,
              style: theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(AppText.targetSavingsDescription,
              style: theme.textTheme.bodyLarge),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppText.targetSavingsTotal,
                      style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.info_outline,
                          color: theme.colorScheme.onSurfaceVariant),
                      const SizedBox(width: 8),
                      Text(AppText.targetSavingsStatusUnavailable,
                          style: theme.textTheme.titleMedium),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(AppText.targetSavingsListUnavailable,
                      style: theme.textTheme.bodySmall),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(AppText.targetSavingsGoals, style: theme.textTheme.titleLarge),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.savings_outlined, size: 32),
                  const SizedBox(height: 12),
                  Text(AppText.targetSavingsPreviewTitle,
                      style: theme.textTheme.titleMedium),
                  const SizedBox(height: 6),
                  Text(AppText.targetSavingsPreviewDescription,
                      style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: () => context.push('/targets/new'),
            icon: const Icon(Icons.add),
            label: const Text(AppText.createTargetSavingsGoal),
          ),
        ],
      ),
    );
  }
}
