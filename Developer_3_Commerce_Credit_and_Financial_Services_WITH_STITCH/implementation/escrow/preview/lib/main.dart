import 'dart:async';

// ignore: deprecated_member_use // The SDK replacement package is not shipped here.
import 'package:flutter/material.dart';
import 'package:sixth_escrow/escrow.dart';

void main() => runApp(const EscrowPreviewApp());

class EscrowPreviewApp extends StatefulWidget {
  const EscrowPreviewApp({super.key});

  @override
  State<EscrowPreviewApp> createState() => _EscrowPreviewAppState();
}

class _EscrowPreviewAppState extends State<EscrowPreviewApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  final _messengerKey = GlobalKey<ScaffoldMessengerState>();
  final _homeAdapter = const _SyntheticEscrowHomeAdapter();
  final _termsAdapter = const _UnavailableEscrowTermsAdapter();

  ThemeData _theme() {
    const scheme = ColorScheme.light(
      primary: Color(0xFF8E1B4A),
      onPrimary: Colors.white,
      secondary: Color(0xFFFF6B57),
      onSecondary: Color(0xFF2B0A12),
      surface: Colors.white,
      error: Color(0xFFC62828),
      onError: Colors.white,
      onSurface: Color(0xFF1E1A1B),
      onSurfaceVariant: Color(0xFF5E5557),
      outline: Color(0xFFE4DEDC),
      primaryContainer: Color(0xFFF8E8EE),
      onPrimaryContainer: Color(0xFF731540),
      surfaceContainerLowest: Color(0xFFFAF8F7),
      surfaceContainer: Color(0xFFF1EDEB),
      surfaceContainerHighest: Color(0xFFF1EDEB),
    );
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: 'Inter',
      scaffoldBackgroundColor: const Color(0xFFFAF8F7),
    );
    return base.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFFAF8F7),
        foregroundColor: Color(0xFF1E1A1B),
        centerTitle: false,
      ),
      textTheme: base.textTheme.copyWith(
        headlineSmall: base.textTheme.headlineSmall?.copyWith(
          fontSize: 24,
          height: 32 / 24,
          fontWeight: FontWeight.w700,
        ),
        titleLarge: base.textTheme.titleLarge?.copyWith(
          fontSize: 20,
          height: 28 / 20,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: base.textTheme.titleMedium?.copyWith(
          fontSize: 16,
          height: 24 / 16,
          fontWeight: FontWeight.w600,
        ),
        bodyMedium:
            base.textTheme.bodyMedium?.copyWith(fontSize: 16, height: 24 / 16),
        bodySmall:
            base.textTheme.bodySmall?.copyWith(fontSize: 13, height: 18 / 13),
        labelLarge: base.textTheme.labelLarge?.copyWith(
          fontSize: 14,
          height: 20 / 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: scheme.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFE4DEDC)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE4DEDC)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 52),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Route<void> _route(RouteSettings settings) {
    final name = settings.name ?? '/escrow';
    late final Widget page;
    if (name == '/escrow/new') {
      page = EscrowCreateDealPage(
        onContinue: (draft) async {
          unawaited(_navigatorKey.currentState!.pushNamed<void>(
            '/escrow/new/terms',
            arguments: _TermsRouteArguments(draft: draft),
          ));
        },
      );
    } else if (name == '/escrow/new/terms') {
      final args = settings.arguments is _TermsRouteArguments
          ? settings.arguments! as _TermsRouteArguments
          : const _TermsRouteArguments(draft: _previewDraft);
      page = EscrowFeeTermsPage(
        adapter: _termsAdapter,
        draft: args.draft,
        dealId: null,
        onContinue: (_) async {
          _messengerKey.currentState?.showSnackBar(
            const SnackBar(content: Text('Invite flow is outside Batch 1.')),
          );
        },
      );
    } else if (name.startsWith('/escrow/deals/')) {
      page = const _UnavailableDealDetailPage();
    } else {
      page = EscrowHomePage(
        adapter: _homeAdapter,
        onNewDeal: () =>
            _navigatorKey.currentState?.pushNamed<void>('/escrow/new'),
        onOpenDeal: (deal) => _messengerKey.currentState?.showSnackBar(
          SnackBar(
              content:
                  Text('S-ESC-007 is not included in Batch 1: ${deal.title}')),
        ),
      );
    }
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (_) => _PreviewShell(
        child: page,
        onOutsidePreview: () => _messengerKey.currentState?.showSnackBar(
          SnackBar(content: Text(const EscrowCopy().navOutsidePreview)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Escrow · Non-production preview',
        navigatorKey: _navigatorKey,
        scaffoldMessengerKey: _messengerKey,
        theme: _theme(),
        initialRoute: '/escrow',
        onGenerateRoute: _route,
        builder: (context, child) => child ?? const SizedBox.shrink(),
      );
}

class _PreviewShell extends StatelessWidget {
  const _PreviewShell({required this.child, required this.onOutsidePreview});

  final Widget child;
  final VoidCallback onOutsidePreview;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          children: [
            const _NonProductionNotice(),
            Expanded(child: child),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: 4,
          onDestinationSelected: (_) => onOutsidePreview(),
          destinations: const [
            NavigationDestination(
                icon: Icon(Icons.home_outlined), label: 'Home'),
            NavigationDestination(
                icon: Icon(Icons.payments_outlined), label: 'Payments'),
            NavigationDestination(
                icon: Icon(Icons.credit_card_outlined), label: 'Cards'),
            NavigationDestination(
                icon: Icon(Icons.savings_outlined), label: 'Save & Borrow'),
            NavigationDestination(icon: Icon(Icons.more_horiz), label: 'More'),
          ],
        ),
      );
}

class _TermsRouteArguments {
  const _TermsRouteArguments({required this.draft});
  final EscrowCreateDealDraft draft;
}

const _previewDraft = EscrowCreateDealDraft(
  type: EscrowDealType.goods,
  role: EscrowPartyRole.buyer,
  title: 'Synthetic preview draft',
  description: '',
  amount: '',
  timelineDescription: '',
  milestones: [],
);

class _SyntheticEscrowHomeAdapter implements EscrowHomeAdapter {
  const _SyntheticEscrowHomeAdapter();

  @override
  Future<List<EscrowDealCardData>> loadDeals() async => const [
        EscrowDealCardData(
          id: 'synthetic-active',
          title: 'Synthetic goods deal',
          group: EscrowDealGroup.active,
          role: EscrowPartyRole.buyer,
          statusLabel: 'Active · synthetic',
        ),
        EscrowDealCardData(
          id: 'synthetic-waiting',
          title: 'Synthetic service deal',
          group: EscrowDealGroup.waitingForMe,
          role: EscrowPartyRole.seller,
          statusLabel: 'Waiting · synthetic',
        ),
        EscrowDealCardData(
          id: 'synthetic-completed',
          title: 'Synthetic completed deal',
          group: EscrowDealGroup.completed,
          role: EscrowPartyRole.buyer,
          statusLabel: 'Completed · synthetic',
        ),
        EscrowDealCardData(
          id: 'synthetic-dispute',
          title: 'Synthetic dispute example',
          group: EscrowDealGroup.disputes,
          role: EscrowPartyRole.seller,
          statusLabel: 'Dispute · synthetic',
        ),
      ];
}

class _UnavailableEscrowTermsAdapter implements EscrowFeeTermsAdapter {
  const _UnavailableEscrowTermsAdapter();

  @override
  Future<EscrowFeeTermsPresentation?> loadTerms({
    required String? dealId,
    required EscrowCreateDealDraft draft,
  }) async =>
      null;

  @override
  Future<void> saveTerms({
    required String dealId,
    required EscrowFeeTermsSelection selection,
  }) async {
    throw UnsupportedError('No Escrow backend is connected to this preview.');
  }
}

class _NonProductionNotice extends StatelessWidget {
  const _NonProductionNotice();

  @override
  Widget build(BuildContext context) => Semantics(
        liveRegion: true,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          color: const Color(0xFFF8E8EE),
          child: Text(
            const EscrowCopy().nonProduction,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: const Color(0xFF731540),
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      );
}

class _UnavailableDealDetailPage extends StatelessWidget {
  const _UnavailableDealDetailPage();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Deal detail')),
        body: Center(child: Text(const EscrowCopy().detailUnavailable)),
      );
}
