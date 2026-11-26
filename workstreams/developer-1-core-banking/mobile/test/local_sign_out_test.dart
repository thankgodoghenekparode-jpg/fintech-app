import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yourapp_mobile/core/security/local_session_cleanup.dart';
import 'package:yourapp_mobile/features/home/data/home_repository.dart';
import 'package:yourapp_mobile/features/home/presentation/more_screen.dart';
import 'package:yourapp_mobile/l10n/app_localizations.dart';

void main() {
  test('local sign-out clears session and biometric opt-in but keeps device ID',
      () async {
    final deleted = <String>[];
    final cleanup = LocalSessionCleanup((key) async => deleted.add(key));

    await cleanup.clearCurrentDeviceSession();

    expect(deleted, LocalSessionCleanup.keysClearedOnSignOut);
    expect(deleted, isNot(contains('security.device_id')));
  });

  test('cleanup attempts every credential deletion when one key fails',
      () async {
    final deleted = <String>[];
    final cleanup = LocalSessionCleanup((key) async {
      deleted.add(key);
      if (key == 'session.refresh_token') throw StateError('storage failure');
    });

    await expectLater(
      cleanup.clearCurrentDeviceSession(),
      throwsA(isA<LocalSessionCleanupException>()),
    );
    expect(deleted, LocalSessionCleanup.keysClearedOnSignOut);
  });

  testWidgets('cancel keeps the current device session', (tester) async {
    final deleted = <String>[];
    final router = await _pumpMore(tester, deleted);
    addTearDown(router.dispose);

    await tester.tap(find.text('Sign out'));
    await tester.pumpAndSettle();
    expect(find.text('Sign out of this device?'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(deleted, isEmpty);
    expect(find.text('Sign out'), findsOneWidget);
  });

  testWidgets(
      'confirmed sign-out clears local credentials and returns to welcome',
      (tester) async {
    final deleted = <String>[];
    final router = await _pumpMore(tester, deleted);
    addTearDown(router.dispose);

    await tester.tap(find.text('Sign out'));
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text('Sign out'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Welcome screen'), findsOneWidget);
    expect(deleted, LocalSessionCleanup.keysClearedOnSignOut);
  });
}

Future<GoRouter> _pumpMore(WidgetTester tester, List<String> deleted) async {
  final router = GoRouter(
    initialLocation: '/more',
    routes: [
      GoRoute(path: '/more', builder: (context, state) => const MoreScreen()),
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Welcome screen')),
        ),
      ),
    ],
  );
  await tester.pumpWidget(ProviderScope(
    overrides: [
      homeAccountProvider.overrideWith(
        (ref) async => HomeResource(
          data: const AccountSummary(
            accountNumber: '0123456789',
            accountName: 'Ada Example',
            status: 'ACTIVE',
            currency: 'NGN',
            tier: 1,
            ledgerBalanceKobo: 10000,
            availableBalanceKobo: 10000,
            balanceCapKobo: 100000,
          ),
          updatedAt: DateTime.utc(2026, 11, 26),
        ),
      ),
      localSessionCleanupProvider.overrideWith(
        (ref) => LocalSessionCleanup((key) async => deleted.add(key)),
      ),
    ],
    child: MaterialApp.router(
      routerConfig: router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    ),
  ));
  await tester.pumpAndSettle();
  await tester.scrollUntilVisible(
    find.text('Sign out'),
    350,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.pumpAndSettle();
  return router;
}
