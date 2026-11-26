import 'package:material_ui/material_ui.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../l10n/app_localizations.dart';
import '../features/onboarding/presentation/onboarding_screens.dart';
import '../features/onboarding/presentation/new_device_verification_screen.dart';
import '../features/onboarding/presentation/liveness_capture_screen.dart';
import '../features/onboarding/presentation/biometrics_setup_screen.dart';
import '../features/onboarding/presentation/demo_experience_screen.dart';
import '../features/onboarding/presentation/demo_preview_catalog_screen.dart';
import '../features/home/presentation/home_dashboard_screen.dart';
import '../features/home/presentation/account_details_screen.dart';
import '../features/home/presentation/profile_screen.dart';
import '../features/home/presentation/account_limits_screen.dart';
import '../features/home/presentation/statements_screen.dart';
import '../features/home/presentation/add_money_screen.dart';
import '../features/home/presentation/notifications_screen.dart';
import '../features/home/presentation/more_screen.dart';
import '../features/home/presentation/legal_consent_screen.dart';
import '../features/locator/presentation/locator_screen.dart';
import '../features/account_closure/presentation/account_closure_screen.dart';
import '../features/account_closure/data/account_closure_repository.dart';
import '../features/security/presentation/security_hub_screen.dart';
import '../features/security/presentation/security_devices_screen.dart';
import '../features/system/presentation/offline_screen.dart';
import '../features/system/presentation/maintenance_screen.dart';
import '../features/system/presentation/force_update_screen.dart';
import '../features/system/presentation/session_locked_screen.dart';
import '../features/system/presentation/account_locked_screen.dart';
import '../features/support/presentation/support_screens.dart';
import '../features/home/presentation/transaction_detail_screen.dart';
import '../features/home/presentation/transaction_history_screen.dart';
import '../features/home/presentation/cards_home_screen.dart';
import '../features/home/data/home_repository.dart';
import '../features/payments/presentation/payments_hub_screen.dart';
import '../features/payments/data/payments_repository.dart';
import '../features/payments/presentation/scheduled_payments_screen.dart';
import '../features/payments/presentation/bills_demo_screens.dart';
import '../features/payments/presentation/live_bill_screens.dart';
import '../features/cards/presentation/card_create_screen.dart';
import '../features/cards/presentation/card_detail_screen.dart';
import '../features/cards/presentation/card_limits_screen.dart';
import '../features/cards/presentation/card_settings_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/welcome',
  redirect: (context, state) async {
    final path = state.uri.path;
    if (path == '/preview/cards' && cardUiPreviewEnabled) return null;
    if (path == '/demo' && demoLoginEnabled) return null;
    if (path == '/demo/screens' && demoLoginEnabled) return null;
    if (path == '/demo/limits' && demoLoginEnabled) return null;
    if (path == '/demo/legal' && demoLoginEnabled) return null;
    if (path == '/demo/locator' && demoLoginEnabled) return null;
    if (path == '/demo/help' && demoLoginEnabled) return null;
    if (path == '/demo/close-account' && demoLoginEnabled) return null;
    if (path == '/demo/offline' && demoLoginEnabled) return null;
    if (path == '/demo/maintenance' && demoLoginEnabled) return null;
    if (path == '/demo/update' && demoLoginEnabled) return null;
    if (path == '/demo/lock' && demoLoginEnabled) return null;
    if (path == '/demo/account-locked' && demoLoginEnabled) return null;
    if (path == '/demo/security' && demoLoginEnabled) return null;
    if (path == '/demo/devices' && demoLoginEnabled) return null;
    if (path == '/demo/account-details' && demoLoginEnabled) return null;
    if (path == '/demo/profile' && demoLoginEnabled) return null;
    if (path == '/demo/add-money' && demoLoginEnabled) return null;
    if (path == '/demo/report-problem' && demoLoginEnabled) return null;
    if (path == '/demo/payments' && demoLoginEnabled) return null;
    if (path == '/demo/scheduled' && demoLoginEnabled) return null;
    if (path.startsWith('/demo/bills') && demoLoginEnabled) return null;
    if (path == '/demo/payment-unavailable' && demoLoginEnabled) return null;
    if ({
      '/signup/details',
      '/signup/consent',
      '/signup/bvn',
      '/signup/nin',
      '/signup/selfie',
      '/signup/passcode',
      '/signup/pin',
      '/signup/biometrics',
      '/signup/status',
    }.contains(path)) {
      if (draftLegalPreviewEnabled) return null;
      final onboardingToken = await const FlutterSecureStorage().read(
        key: 'onboarding.session_token',
      );
      if (onboardingToken == null || onboardingToken.isEmpty) return '/welcome';
      return null;
    }
    const publicPaths = {
      '/welcome',
      '/signup/phone',
      '/signup/otp',
      '/login',
      '/login/reset',
      '/login/new-device',
      '/account-locked',
      '/maintenance',
      '/update',
    };
    if (publicPaths.contains(path)) return null;
    final token = await const FlutterSecureStorage().read(
      key: 'session.access_token',
    );
    if (token == null || token.isEmpty) return '/welcome';
    return null;
  },
  routes: [
    GoRoute(
      path: '/demo',
      builder: (context, state) => const DemoExperienceScreen(),
    ),
    GoRoute(
      path: '/demo/screens',
      builder: (context, state) => const DemoPreviewCatalogScreen(),
    ),
    GoRoute(
      path: '/demo/profile',
      builder: (context, state) => ProviderScope(
        overrides: [
          homeAccountProvider.overrideWith(
            (ref) async => HomeResource(
              data: const AccountSummary(
                accountNumber: '0123456789',
                accountName: 'Ada Nwosu',
                status: 'SAMPLE',
                currency: 'NGN',
                tier: 2,
                perTxnLimitKobo: null,
                dailyOutLimitKobo: null,
                dailyUsedKobo: null,
                ledgerBalanceKobo: null,
                availableBalanceKobo: null,
                balanceCapKobo: null,
              ),
              updatedAt: DateTime.now(),
            ),
          ),
        ],
        child: const ProfileScreen(demo: true),
      ),
    ),
    GoRoute(
      path: '/demo/legal',
      builder: (context, state) => const LegalConsentScreen(),
    ),
    GoRoute(
      path: '/demo/locator',
      builder: (context, state) => const LocatorScreen(),
    ),
    GoRoute(
      path: '/demo/help',
      builder: (context, state) => const HelpCentreScreen(),
    ),
    GoRoute(
      path: '/demo/limits',
      builder: (context, state) => ProviderScope(
        overrides: [
          homeAccountProvider.overrideWith(
            (ref) async => HomeResource(
              data: const AccountSummary(
                accountNumber: '0123456789',
                accountName: 'Ada Nwosu',
                status: 'SAMPLE',
                currency: 'NGN',
                tier: 2,
                perTxnLimitKobo: 20000000,
                dailyOutLimitKobo: 50000000,
                dailyUsedKobo: 2500000,
                ledgerBalanceKobo: 42865000,
                availableBalanceKobo: 42865000,
                balanceCapKobo: 100000000,
              ),
              updatedAt: DateTime.now(),
            ),
          ),
        ],
        child: const AccountLimitsScreen(),
      ),
    ),
    GoRoute(
      path: '/demo/close-account',
      builder: (context, state) => ProviderScope(
        overrides: [
          closureEligibilityProvider
              .overrideWith((ref) async => ClosureEligibility(
                    eligible: false,
                    checkedAt: DateTime.now(),
                    blockers: const [
                      ClosureBlocker(
                        code: 'SAMPLE_NON_ZERO_BALANCE',
                        title: 'Sample blocker: transfer remaining balance',
                        detail:
                            'Demo eligibility fixture only; no customer data is used.',
                      ),
                    ],
                  )),
        ],
        child: const AccountClosureScreen(previewOnly: true),
      ),
    ),
    GoRoute(
      path: '/demo/offline',
      builder: (context, state) => const OfflineScreen(previewOnly: true),
    ),
    GoRoute(
      path: '/demo/maintenance',
      builder: (context, state) => const MaintenanceScreen(previewOnly: true),
    ),
    GoRoute(
      path: '/maintenance',
      builder: (context, state) => const MaintenanceScreen(),
    ),
    GoRoute(
      path: '/demo/update',
      builder: (context, state) => const ForceUpdateScreen(previewOnly: true),
    ),
    GoRoute(
      path: '/demo/lock',
      builder: (context, state) => const SessionLockedScreen(previewOnly: true),
    ),
    GoRoute(
      path: '/lock',
      builder: (context, state) => const SessionLockedScreen(),
    ),
    GoRoute(
      path: '/demo/account-locked',
      builder: (context, state) => AccountLockedScreen(
        previewOnly: true,
        restriction: const AccountRestrictionContext(
          reason: AccountRestrictionReason.selfLock,
        ),
      ),
    ),
    GoRoute(
      path: '/demo/security',
      builder: (context, state) => const SecurityHubScreen(previewOnly: true),
    ),
    GoRoute(
      path: '/demo/devices',
      builder: (context, state) =>
          const SecurityDevicesScreen(previewOnly: true),
    ),
    GoRoute(
      path: '/account-locked',
      builder: (context, state) => AccountLockedScreen(
        restriction: state.extra is AccountRestrictionContext
            ? state.extra as AccountRestrictionContext
            : const AccountRestrictionContext(),
      ),
    ),
    GoRoute(
      path: '/update',
      builder: (context, state) => ForceUpdateScreen(
        policy:
            state.extra is UpdatePolicy ? state.extra as UpdatePolicy : null,
      ),
    ),
    GoRoute(
      path: '/demo/account-details',
      builder: (context, state) => ProviderScope(
        overrides: [
          homeAccountProvider.overrideWith(
            (ref) async => HomeResource(
              data: const AccountSummary(
                accountNumber: '0123456789',
                accountName: 'Ada Nwosu',
                status: 'ACTIVE',
                currency: 'NGN',
                tier: 2,
                perTxnLimitKobo: 20000000,
                dailyOutLimitKobo: 50000000,
                dailyUsedKobo: 2500000,
                ledgerBalanceKobo: 42865000,
                availableBalanceKobo: 42865000,
                balanceCapKobo: 100000000,
              ),
              updatedAt: DateTime.now(),
            ),
          ),
        ],
        child: const AccountDetailsScreen(demo: true),
      ),
    ),
    GoRoute(
      path: '/demo/add-money',
      builder: (context, state) => ProviderScope(
        overrides: [
          homeAccountProvider.overrideWith(
            (ref) async => HomeResource(
              data: const AccountSummary(
                accountNumber: '0123456789',
                accountName: 'Ada Nwosu',
                status: 'SAMPLE',
                currency: 'NGN',
                tier: 2,
                ledgerBalanceKobo: 42865000,
                availableBalanceKobo: 42865000,
                balanceCapKobo: 100000000,
              ),
              updatedAt: DateTime.now(),
            ),
          ),
        ],
        child: const AddMoneyScreen(demo: true),
      ),
    ),
    GoRoute(
      path: '/demo/report-problem',
      builder: (context, state) => const ReportTransactionProblemScreen(
        transactionId: 'demo-transaction-report',
        previewOnly: true,
      ),
    ),
    GoRoute(
      path: '/demo/payments',
      builder: (context, state) => ProviderScope(
        overrides: [
          beneficiariesProvider.overrideWith(
            (ref) async => const [
              BeneficiarySummary(
                id: 'demo-beneficiary-1',
                accountName: 'Chidinma Example',
                nickname: 'Chidinma E.',
                bankCode: 'DEMO',
                accountNumber: '0000000057',
                favourite: true,
              ),
              BeneficiarySummary(
                id: 'demo-beneficiary-2',
                accountName: 'Ibrahim Example',
                nickname: 'Ibrahim B.',
                bankCode: 'DEMO',
                accountNumber: '0000000011',
              ),
            ],
          ),
          recentTransactionsProvider.overrideWith(
            (ref) async => HomeResource(
              data: [
                TransactionSummary(
                  id: 'demo-transfer-1',
                  type: 'TRANSFER',
                  direction: 'D',
                  amountKobo: 12500000,
                  feeKobo: 0,
                  reference: 'DEMO-1',
                  balanceAfterKobo: 42865000,
                  status: 'SUCCESSFUL',
                  failureCode: null,
                  counterpartyName: 'Tunde Example',
                  counterpartyBank: 'Sample bank',
                  narration: 'Demo transfer',
                  createdAt: DateTime(2026, 11, 20, 10),
                ),
              ],
              updatedAt: DateTime(2026, 11, 20, 10),
            ),
          ),
        ],
        child: const PaymentsHubScreen(demo: true),
      ),
    ),
    GoRoute(
      path: '/demo/scheduled',
      builder: (context, state) => const ScheduledPaymentsScreen(demo: true),
    ),
    GoRoute(
      path: '/demo/bills',
      builder: (context, state) => const DemoBillCategoryScreen(),
    ),
    GoRoute(
      path: '/demo/bills/billers',
      builder: (context, state) => DemoBillersScreen(
        categoryCode: state.uri.queryParameters['category'] ?? '',
      ),
    ),
    GoRoute(
      path: '/demo/bills/pay',
      builder: (context, state) => DemoBillPayScreen(
        biller: state.uri.queryParameters['biller'] ?? 'Demo biller',
      ),
    ),
    GoRoute(
      path: '/demo/payment-unavailable',
      builder: (context, state) => PaymentFlowUnavailableScreen(
        title: AppLocalizations.of(context)!.paymentsDuesLevies,
      ),
    ),
    GoRoute(
      path: '/bills',
      builder: (context, state) => const BillCategoriesScreen(),
    ),
    GoRoute(
      path: '/bills/billers/:categoryCode',
      builder: (context, state) => BillersScreen(
        categoryCode: state.pathParameters['categoryCode']!,
      ),
    ),
    GoRoute(
      path: '/bills/pay',
      builder: (context, state) => BillPaymentScreen(
        billerCode: state.uri.queryParameters['biller'] ?? '',
        productCode: state.uri.queryParameters['product'] ?? '',
        savedBillerId: state.uri.queryParameters['saved'],
      ),
    ),
    GoRoute(
      path: '/preview/cards',
      builder: (context, state) => ProviderScope(
        overrides: [
          homeCardsProvider.overrideWith(
            (ref) async => HomeResource(
              data: _cardPreviewFixtures,
              updatedAt: DateTime.now(),
            ),
          ),
        ],
        child: const CardsHomeScreen(preview: true),
      ),
    ),
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/signup/phone',
      builder: (context, state) => const PhoneNumberScreen(),
    ),
    GoRoute(
      path: '/signup/otp',
      builder: (context, state) => const VerifyOtpScreen(),
    ),
    GoRoute(
      path: '/signup/details',
      builder: (context, state) => const PersonalDetailsScreen(),
    ),
    GoRoute(
      path: '/signup/consent',
      builder: (context, state) => const ConsentPendingScreen(),
    ),
    GoRoute(
      path: '/signup/bvn',
      builder: (context, state) => const IdentityNumberScreen(isBvn: true),
    ),
    GoRoute(
      path: '/signup/nin',
      builder: (context, state) => const IdentityNumberScreen(isBvn: false),
    ),
    GoRoute(
      path: '/signup/selfie',
      builder: (context, state) => const LivenessCaptureScreen(),
    ),
    GoRoute(
      path: '/signup/passcode',
      builder: (context, state) => const CredentialSetupScreen(isPin: false),
    ),
    GoRoute(
      path: '/signup/pin',
      builder: (context, state) => const CredentialSetupScreen(isPin: true),
    ),
    GoRoute(
      path: '/signup/biometrics',
      builder: (context, state) => const BiometricsSetupScreen(),
    ),
    GoRoute(
      path: '/signup/status',
      builder: (context, state) => const OnboardingStatusScreen(),
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),
    GoRoute(
      path: '/account-details',
      builder: (context, state) => const AccountDetailsScreen(),
    ),
    GoRoute(
      path: '/more/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/more/limits',
      builder: (context, state) => const AccountLimitsScreen(),
    ),
    GoRoute(
      path: '/more/security',
      builder: (context, state) => const SecurityHubScreen(),
    ),
    GoRoute(
      path: '/more/devices',
      builder: (context, state) => const SecurityDevicesScreen(),
    ),
    GoRoute(
      path: '/more/legal',
      builder: (context, state) => const LegalConsentScreen(),
    ),
    GoRoute(
      path: '/locator',
      builder: (context, state) => const LocatorScreen(),
    ),
    GoRoute(
      path: '/more/close-account',
      builder: (context, state) => const AccountClosureScreen(),
    ),
    GoRoute(
      path: '/add-money',
      builder: (context, state) => const AddMoneyScreen(),
    ),
    GoRoute(
      path: '/history',
      builder: (context, state) => const TransactionHistoryScreen(),
    ),
    GoRoute(
      path: '/more/statements',
      builder: (context, state) => const StatementsScreen(),
    ),
    GoRoute(
      path: '/statements',
      redirect: (context, state) => '/more/statements',
    ),
    GoRoute(
      path: '/help',
      builder: (context, state) => const HelpCentreScreen(),
    ),
    GoRoute(
      path: '/help/chat',
      builder: (context, state) => NewSupportTicketScreen(
        chatMode: true,
        transactionId: state.uri.queryParameters['transactionId'],
      ),
    ),
    GoRoute(
      path: '/help/chat/:id',
      builder: (context, state) => SupportTicketDetailScreen(
        ticketId: state.pathParameters['id']!,
        chatMode: true,
      ),
    ),
    GoRoute(
      path: '/help/tickets',
      builder: (context, state) => const SupportTicketsScreen(),
    ),
    GoRoute(
      path: '/help/new-ticket',
      builder: (context, state) => NewSupportTicketScreen(
        transactionId: state.uri.queryParameters['transactionId'],
      ),
    ),
    GoRoute(
      path: '/help/tickets/:id',
      builder: (context, state) => SupportTicketDetailScreen(
        ticketId: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: '/cards/new',
      builder: (context, state) => const CardCreateScreen(),
    ),
    GoRoute(
      path: '/cards/:id/details',
      builder: (context, state) => CardDetailsScreen(
        cardId: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: '/cards/:id/limits',
      builder: (context, state) => CardLimitsScreen(
        cardId: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: '/cards/:id/settings',
      builder: (context, state) => CardSettingsScreen(
        cardId: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: '/cards/:id',
      builder: (context, state) => CardDetailScreen(
        cardId: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: '/transactions/:id/report',
      builder: (context, state) => ReportTransactionProblemScreen(
        transactionId: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: '/transactions/:id',
      builder: (context, state) => TransactionDetailScreen(
        transactionId: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: '/transactions/:id/receipt',
      builder: (context, state) => _FeatureNotReadyScreen(
        title: AppLocalizations.of(context)!.transactionReceipt,
      ),
    ),
    GoRoute(
      path: '/support',
      builder: (context, state) => _FeatureNotReadyScreen(
        title: AppLocalizations.of(context)!.transactionReportProblem,
      ),
    ),
    GoRoute(
      path: '/beneficiaries',
      builder: (context, state) => const BeneficiariesScreen(),
    ),
    GoRoute(
      path: '/send/recipient',
      builder: (context, state) => PaymentFlowUnavailableScreen(
        title: AppLocalizations.of(context)!.paymentsSendBank,
        bankCatalogBlock: true,
      ),
    ),
    GoRoute(
      path: '/payment-unavailable',
      builder: (context, state) => PaymentFlowUnavailableScreen(
        title: state.uri.queryParameters['title'] ??
            AppLocalizations.of(context)!.paymentsFeatureUnavailableTitle,
      ),
    ),
    GoRoute(
      path: '/scheduled',
      builder: (context, state) => const ScheduledPaymentsScreen(),
    ),
    for (final path in ['/request', '/qr', '/airtime'])
      GoRoute(
        path: path,
        builder: (context, state) => PaymentFlowUnavailableScreen(
          title: AppLocalizations.of(context)!.paymentsFeatureUnavailableTitle,
        ),
      ),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/login/reset',
      builder: (context, state) =>
          const FlowPendingScreen(isPasscodeReset: true),
    ),
    GoRoute(
      path: '/login/new-device',
      builder: (context, state) => const NewDeviceVerificationScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          _AppShell(navigationShell: navigationShell),
      branches: [
        _branch('/home', 'home', screen: const HomeDashboardScreen()),
        _branch('/payments', 'payments', screen: const PaymentsHubScreen()),
        _branch('/cards', 'cards', screen: const CardsHomeScreen()),
        _branch('/save-borrow', 'saveBorrow'),
        _branch('/more', 'more', screen: const MoreScreen()),
      ],
    ),
  ],
);

const _cardPreviewFixtures = <CardSummary>[
  CardSummary(
    id: 'preview-shopping-card',
    label: 'Shopping & Subscriptions',
    theme: 'BERRY',
    last4: '6194',
    status: 'ACTIVE',
    perTxnLimitKobo: 10000000,
    dailyLimitKobo: 10000000,
  ),
  CardSummary(
    id: 'preview-frozen-card',
    label: 'Travel',
    theme: 'MIDNIGHT',
    last4: '2841',
    status: 'FROZEN',
    perTxnLimitKobo: 5000000,
    dailyLimitKobo: 15000000,
  ),
];

StatefulShellBranch _branch(String path, String labelKey, {Widget? screen}) =>
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: path,
          builder: (context, state) =>
              screen ?? _FeaturePlaceholder(labelKey: labelKey),
        ),
      ],
    );

class _AppShell extends StatelessWidget {
  const _AppShell({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    final labels = [
      text.navHome,
      text.navPayments,
      text.navCards,
      text.navSaveBorrow,
      text.navMore,
    ];
    final icons = [
      Icons.home_outlined,
      Icons.swap_horiz,
      Icons.credit_card_outlined,
      Icons.savings_outlined,
      Icons.grid_view_outlined,
    ];
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => navigationShell.goBranch(index),
        destinations: List.generate(
          labels.length,
          (index) => NavigationDestination(
            icon: Icon(icons[index]),
            label: labels[index],
          ),
        ),
      ),
    );
  }
}

class _FeaturePlaceholder extends StatelessWidget {
  const _FeaturePlaceholder({required this.labelKey});

  final String labelKey;

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    final title = switch (labelKey) {
      'home' => text.navHome,
      'payments' => text.navPayments,
      'cards' => text.navCards,
      'saveBorrow' => text.navSaveBorrow,
      _ => text.navMore,
    };
    return Scaffold(
      appBar: AppBar(title: Text(text.appTitle)),
      body: Center(
        child: Text(title, style: Theme.of(context).textTheme.headlineSmall),
      ),
    );
  }
}

class _FeatureNotReadyScreen extends StatelessWidget {
  const _FeatureNotReadyScreen({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: text.commonBack,
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(title),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              text.homeFeatureNotReady,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
