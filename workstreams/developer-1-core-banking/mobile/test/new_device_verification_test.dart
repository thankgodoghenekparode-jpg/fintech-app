import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yourapp_mobile/core/network/api_client.dart';
import 'package:yourapp_mobile/features/onboarding/data/onboarding_repository.dart';
import 'package:yourapp_mobile/features/onboarding/presentation/new_device_verification_screen.dart';
import 'package:yourapp_mobile/l10n/app_localizations.dart';

void main() {
  testWidgets('new device OTP proceeds only to explicit liveness contract gap',
      (tester) async {
    final repository = _SuccessfulOtpRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [onboardingRepositoryProvider.overrideWithValue(repository)],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: NewDeviceVerificationScreen(),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField).first, '+2348012345678');
    await tester.pump();
    await tester.tap(find.text('Send verification code'));
    await tester.pumpAndSettle();
    expect(repository.requestedPhone, '+2348012345678');

    await tester.enterText(find.byType(TextField).last, '123456');
    await tester.pump();
    await tester.tap(find.text('Verify code'));
    await tester.pumpAndSettle();

    expect(repository.verifiedCode, '123456');
    expect(find.text('Complete selfie liveness check'), findsOneWidget);
    expect(find.textContaining('No device has been approved'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('new device screen validates phone before requesting OTP',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          onboardingRepositoryProvider.overrideWithValue(
            _SuccessfulOtpRepository(),
          ),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: NewDeviceVerificationScreen(),
        ),
      ),
    );
    await tester.enterText(find.byType(TextField).first, '123');
    await tester.pump();
    expect(tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull);
  });
}

class _SuccessfulOtpRepository extends OnboardingRepository {
  _SuccessfulOtpRepository()
      : super(ApiClient(Dio()), const FlutterSecureStorage());

  String? requestedPhone;
  String? verifiedCode;

  @override
  Future<void> requestNewDeviceOtp(String phone) async {
    requestedPhone = phone;
  }

  @override
  Future<String> verifyNewDeviceOtp({
    required String phone,
    required String code,
  }) async {
    verifiedCode = code;
    return 'restricted-session-token';
  }
}
