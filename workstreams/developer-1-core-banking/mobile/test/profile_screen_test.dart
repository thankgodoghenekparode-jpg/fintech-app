import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yourapp_mobile/features/home/data/home_repository.dart';
import 'package:yourapp_mobile/features/home/presentation/profile_screen.dart';
import 'package:yourapp_mobile/l10n/app_localizations.dart';

void main() {
  testWidgets('profile uses account contract values and flags missing fields',
      (tester) async {
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
                accountName: 'Ada Nwosu',
                status: 'ACTIVE',
                currency: 'NGN',
                tier: 2,
                perTxnLimitKobo: null,
                dailyOutLimitKobo: null,
                dailyUsedKobo: null,
                ledgerBalanceKobo: null,
                availableBalanceKobo: null,
                balanceCapKobo: null,
              ),
              updatedAt: DateTime(2026, 11, 26),
            ),
          ),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ProfileScreen(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Ada Nwosu'), findsNWidgets(2));
    expect(find.text('Tier 2'), findsOneWidget);
    expect(find.text('Phone number'), findsOneWidget);
    expect(find.text('Email address'), findsOneWidget);
    expect(find.text('Residential address'), findsOneWidget);
    expect(find.text('Not available from account service'), findsNWidgets(3));
    await tester.tap(find.byIcon(Icons.edit_outlined));
    await tester.pumpAndSettle();
    expect(find.textContaining('OTP'), findsNWidgets(2));
    expect(find.textContaining('Tunde Olumide'), findsNothing);
    expect(find.textContaining('example.com'), findsNothing);
  });
}
