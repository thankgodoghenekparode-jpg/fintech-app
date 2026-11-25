import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yourapp_mobile/features/home/data/home_repository.dart';
import 'package:yourapp_mobile/features/home/presentation/account_limits_screen.dart';
import 'package:yourapp_mobile/l10n/app_localizations.dart';

void main() {
  testWidgets('account limits show API values and explain the upgrade gap', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          homeAccountProvider.overrideWith(
            (ref) async => HomeResource(
              data: const AccountSummary(
                accountNumber: '0123456789',
                accountName: 'Tunde Adeyemi',
                status: 'ACTIVE',
                currency: 'NGN',
                tier: 2,
                perTxnLimitKobo: 20000000,
                dailyOutLimitKobo: 50000000,
                dailyUsedKobo: 2500000,
                ledgerBalanceKobo: 12345678,
                availableBalanceKobo: 12000000,
                balanceCapKobo: 100000000,
              ),
              updatedAt: DateTime(2026, 11, 23),
            ),
          ),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: AccountLimitsScreen(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Tier 2'), findsOneWidget);
    expect(find.text('₦500,000.00'), findsOneWidget);
    expect(find.text('₦200,000.00'), findsOneWidget);
    expect(find.text('₦1,000,000.00'), findsOneWidget);
    expect(find.textContaining('₦25,000.00 used'), findsOneWidget);
    expect(find.textContaining('₦123,456.78'), findsOneWidget);

    await tester.drag(find.byType(ListView), const Offset(0, -700));
    await tester.pump();
    await tester.tap(find.text('Check upgrade options'));
    await tester.pump();
    expect(find.textContaining('does not define the KYC requirements'),
        findsOneWidget);
  });
}
