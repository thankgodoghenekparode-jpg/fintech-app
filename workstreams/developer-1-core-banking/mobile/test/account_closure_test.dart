import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:dio/dio.dart';
import 'package:yourapp_mobile/core/network/api_client.dart';
import 'package:yourapp_mobile/features/account_closure/data/account_closure_repository.dart';
import 'package:yourapp_mobile/features/account_closure/presentation/account_closure_screen.dart';
import 'package:yourapp_mobile/features/home/data/home_repository.dart';
import 'package:yourapp_mobile/l10n/app_localizations.dart';

void main() {
  test('closure eligibility decodes server blockers', () {
    final result = ClosureEligibility.fromJson({
      'eligible': false,
      'checkedAt': '2026-11-25T09:00:00Z',
      'blockers': [
        {
          'code': 'NON_ZERO_BALANCE',
          'title': 'Transfer your balance',
          'detail': 'A zero balance is required.',
          'actionLabel': 'Review balance',
          'actionRoute': '/account-details',
        },
      ],
    });

    expect(result.eligible, isFalse);
    expect(result.blockers.single.code, 'NON_ZERO_BALANCE');
    expect(result.blockers.single.actionRoute, '/account-details');
  });

  testWidgets('server blockers prevent a closure request', (tester) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [
        closureEligibilityProvider
            .overrideWith((ref) async => ClosureEligibility(
                  eligible: false,
                  checkedAt: DateTime.utc(2026, 11, 25),
                  blockers: const [
                    ClosureBlocker(
                      code: 'NON_ZERO_BALANCE',
                      title: 'Transfer your remaining balance',
                      detail: 'The available balance must be zero.',
                    ),
                  ],
                )),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const AccountClosureScreen(),
      ),
    ));
    await tester.pumpAndSettle();

    expect(find.text('Transfer your remaining balance'), findsOneWidget);
    await tester.tap(find.text('I found another banking service'));
    await tester.pump();
    await tester.scrollUntilVisible(
      find.text('Submit closure request'),
      400,
      scrollable: find.byType(Scrollable).first,
    );
    final submit = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Submit closure request'),
    );
    expect(submit.onPressed, isNull);
  });

  testWidgets('eligible closure confirms PIN and submits an idempotent request',
      (tester) async {
    final closureRepository = _FakeClosureRepository();
    final homeRepository = _FakeHomeRepository();
    await tester.pumpWidget(ProviderScope(
      overrides: [
        closureEligibilityProvider
            .overrideWith((ref) async => ClosureEligibility(
                  eligible: true,
                  checkedAt: DateTime.utc(2026, 11, 25),
                  blockers: const [],
                )),
        accountClosureRepositoryProvider
            .overrideWith((ref) => closureRepository),
        homeRepositoryProvider.overrideWith((ref) => homeRepository),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const AccountClosureScreen(),
      ),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.text('I found another banking service'));
    await tester.pump();
    await tester.scrollUntilVisible(
      find.text('Submit closure request'),
      400,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Submit closure request'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, '1234');
    await tester.pump();
    await tester.tap(find.text('Verify PIN'));
    await tester.pumpAndSettle();

    expect(homeRepository.verifiedPin, '1234');
    expect(closureRepository.reason, 'OTHER_BANKING_SERVICE');
    expect(closureRepository.pinToken, 'single-action-token');
    expect(closureRepository.idempotencyKey, startsWith('closure-'));
    expect(find.text('Closure request submitted'), findsOneWidget);
  });
}

class _FakeHomeRepository extends HomeRepository {
  _FakeHomeRepository() : super(ApiClient(Dio()));

  String? verifiedPin;

  @override
  Future<String> verifyTransactionPin(String pin) async {
    verifiedPin = pin;
    return 'single-action-token';
  }
}

class _FakeClosureRepository extends AccountClosureRepository {
  _FakeClosureRepository() : super(ApiClient(Dio()));

  String? reason;
  String? pinToken;
  String? idempotencyKey;

  @override
  Future<ClosureRequest> submitRequest({
    required String reason,
    String? feedback,
    required String pinToken,
    required String idempotencyKey,
  }) async {
    this.reason = reason;
    this.pinToken = pinToken;
    this.idempotencyKey = idempotencyKey;
    return ClosureRequest(
      requestId: 'closure-request-1',
      status: 'PENDING_REVIEW',
      createdAt: DateTime.utc(2026, 11, 25),
      blockers: const [],
    );
  }
}
