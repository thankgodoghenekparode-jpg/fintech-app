import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yourapp_mobile/features/system/presentation/account_locked_screen.dart';

void main() {
  test('423 AUTH_LOCKED maps to a safe support reference', () {
    final error = DioException(
      requestOptions: RequestOptions(path: 'auth/login'),
      response: Response<Map<String, dynamic>>(
        requestOptions: RequestOptions(path: 'auth/login'),
        statusCode: 423,
        data: {'code': 'AUTH_LOCKED', 'requestId': 'req_2026-abc'},
      ),
    );

    expect(AccountRestrictionContext.isLockoutError(error), isTrue);
    expect(
      AccountRestrictionContext.fromApiError(error).requestId,
      'req_2026-abc',
    );
  });

  test('untrusted reference text is not rendered', () {
    final error = DioException(
      requestOptions: RequestOptions(path: 'auth/login'),
      response: Response<Map<String, dynamic>>(
        requestOptions: RequestOptions(path: 'auth/login'),
        statusCode: 423,
        data: {'code': 'AUTH_LOCKED', 'requestId': '<script>alert(1)</script>'},
      ),
    );

    expect(
      AccountRestrictionContext.fromApiError(error).requestId,
      isNull,
    );
  });

  testWidgets('restricted account preview avoids unsupported claims',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const MaterialApp(
      home: AccountLockedScreen(
        previewOnly: true,
        restriction: AccountRestrictionContext(
          reason: AccountRestrictionReason.selfLock,
        ),
      ),
    ));

    expect(find.text('Screen preview only'), findsOneWidget);
    expect(find.text('Account access is restricted'), findsOneWidget);
    expect(find.text('You asked us to lock your account'), findsOneWidget);
    expect(find.text('142,850'), findsNothing);
    expect(find.textContaining('NDIC'), findsNothing);
    expect(find.textContaining('Central Bank of Nigeria'), findsNothing);
    expect(find.textContaining('Inbound transfers are still received'),
        findsNothing);

    await tester.scrollUntilVisible(
      find.text('Unlock steps'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Unlock steps'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Review unlock options'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Review unlock options'));
    await tester.pumpAndSettle();

    expect(find.text('Identity verification is required'), findsOneWidget);
    expect(find.textContaining('not available for account recovery yet'),
        findsOneWidget);
  });
}
