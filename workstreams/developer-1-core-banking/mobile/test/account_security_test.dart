import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yourapp_mobile/core/network/api_client.dart';
import 'package:yourapp_mobile/features/security/data/account_security_repository.dart';
import 'package:yourapp_mobile/features/security/presentation/security_hub_screen.dart';

void main() {
  test('account lock sends only the documented one-use PIN token header',
      () async {
    RequestOptions? request;
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test/api/v1/'));
    final client =
        ApiClient.withTokenReader(dio, (key) async => 'access-token');
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
        request = options;
        handler.resolve(Response<void>(requestOptions: options));
      }));

    await AccountSecurityRepository(client)
        .lockOwnAccount(pinToken: 'one-use-pin-token');

    expect(request!.method, 'POST');
    expect(request!.path, 'security/lock');
    expect(request!.data, isNull);
    expect(request!.headers['X-Pin-Token'], 'one-use-pin-token');
    expect(request!.headers['Authorization'], 'Bearer access-token');
  });

  testWidgets('security preview does not request a PIN or lock an account',
      (tester) async {
    await tester.pumpWidget(const ProviderScope(
      child: MaterialApp(home: SecurityHubScreen(previewOnly: true)),
    ));

    expect(find.text('Lock my account'), findsOneWidget);
    await tester.tap(find.text('Lock my account'));
    await tester.pumpAndSettle();

    expect(find.text('Preview only'), findsOneWidget);
    expect(find.text('Enter transaction PIN'), findsNothing);
  });
}
