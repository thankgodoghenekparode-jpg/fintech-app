import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yourapp_mobile/core/network/api_client.dart';
import 'package:yourapp_mobile/features/onboarding/data/onboarding_repository.dart';
import 'package:yourapp_mobile/features/onboarding/presentation/passcode_reset_screen.dart';
import 'package:yourapp_mobile/l10n/app_localizations.dart';

void main() {
  testWidgets('reset flow verifies PASSCODE_RESET OTP and stops before reset',
      (tester) async {
    final repository = _SuccessfulResetOtpRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [onboardingRepositoryProvider.overrideWithValue(repository)],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: PasscodeResetScreen(),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField).first, '+2348012345678');
    await tester.pump();
    await tester.tap(find.text('Send verification code'));
    await tester.pumpAndSettle();
    expect(repository.requestedPhone, '+2348012345678');

    await tester.enterText(find.byType(TextField).last, '654321');
    await tester.pump();
    await tester.tap(find.text('Verify code'));
    await tester.pumpAndSettle();

    expect(repository.verifiedCode, '654321');
    expect(find.text('Confirm your identity'), findsOneWidget);
    expect(
        find.textContaining('has not changed your passcode'), findsOneWidget);
    expect(find.textContaining('No 24-hour hold is claimed'), findsOneWidget);
    expect(find.text('Create a new passcode'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('reset flow validates phone before requesting a recovery code',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          onboardingRepositoryProvider.overrideWithValue(
            _SuccessfulResetOtpRepository(),
          ),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: PasscodeResetScreen(),
        ),
      ),
    );
    await tester.enterText(find.byType(TextField).first, '123');
    await tester.pump();
    expect(tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull);
  });
}

class _SuccessfulResetOtpRepository extends OnboardingRepository {
  _SuccessfulResetOtpRepository()
      : super(ApiClient(Dio()), const FlutterSecureStorage());

  String? requestedPhone;
  String? verifiedCode;

  @override
  Future<void> requestPasscodeResetOtp(String phone) async {
    requestedPhone = phone;
  }

  @override
  Future<String> verifyPasscodeResetOtp({
    required String phone,
    required String code,
  }) async {
    verifiedCode = code;
    return 'restricted-recovery-token';
  }
}
