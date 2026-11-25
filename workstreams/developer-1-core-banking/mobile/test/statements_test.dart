import 'package:material_ui/material_ui.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yourapp_mobile/core/network/api_client.dart';
import 'package:yourapp_mobile/features/home/data/statements_repository.dart';
import 'package:yourapp_mobile/features/home/presentation/statements_screen.dart';
import 'package:yourapp_mobile/l10n/app_localizations.dart';

void main() {
  test('statement archive and request use the proposed typed API contract',
      () async {
    final requests = <RequestOptions>[];
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test/api/v1/'))
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            requests.add(options);
            if (options.path.endsWith('/download')) {
              handler.resolve(
                Response<List<int>>(
                  requestOptions: options,
                  data: [37, 80, 68, 70],
                ),
              );
              return;
            }
            if (options.method == 'GET' &&
                options.path.endsWith('/statements')) {
              handler.resolve(
                Response<Map<String, dynamic>>(
                  requestOptions: options,
                  data: {
                    'items': <dynamic>[],
                    'maximumRangeDays': 180,
                    'emailDeliveryAvailable': true,
                    'registeredEmailMasked': 'a***@example.test',
                  },
                ),
              );
              return;
            }
            handler.resolve(
              Response<Map<String, dynamic>>(
                requestOptions: options,
                statusCode: 202,
                data: _requestJson(),
              ),
            );
          },
        ),
      );
    final repository = StatementsRepository(ApiClient(dio));

    final archive = await repository.getArchive();
    expect(archive.maximumRangeDays, 180);
    expect(archive.emailDeliveryAvailable, isTrue);
    expect(archive.registeredEmailMasked, 'a***@example.test');

    final request = await repository.requestStatement(
      fromDate: DateTime(2026, 1, 1),
      toDate: DateTime(2026, 1, 30),
      deliveryMethod: StatementDeliveryMethod.email,
      idempotencyKey: '00000000-0000-4000-8000-000000000001',
    );
    expect(request.status, StatementStatus.queued);
    expect(request.deliveryMethod, StatementDeliveryMethod.email);
    expect(requests.last.data, {
      'fromDate': '2026-01-01',
      'toDate': '2026-01-30',
      'format': 'PDF',
      'deliveryMethod': 'EMAIL',
    });
    expect(
      requests.last.headers['Idempotency-Key'],
      '00000000-0000-4000-8000-000000000001',
    );
    final pdfBytes = await repository.downloadStatement(request.requestId);
    expect(pdfBytes, [37, 80, 68, 70]);
    expect(requests.last.path, endsWith('/download'));
  });

  testWidgets('statements screen shows live archive and submits PDF request', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    RequestOptions? submitted;
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test/api/v1/'))
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            submitted = options;
            handler.resolve(
              Response<Map<String, dynamic>>(
                requestOptions: options,
                statusCode: 202,
                data: _requestJson(),
              ),
            );
          },
        ),
      );
    final archive = StatementArchive(
      items: const [],
      maximumRangeDays: 365,
      emailDeliveryAvailable: false,
      registeredEmailMasked: null,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          statementArchiveProvider.overrideWith((ref) async => archive),
          statementsRepositoryProvider.overrideWithValue(
            StatementsRepository(ApiClient(dio)),
          ),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: StatementsScreen(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    await tester.drag(find.byType(ListView), const Offset(0, -700));
    await tester.pump();
    expect(find.text('Past statement requests'), findsOneWidget);
    expect(find.text('You have no past statement requests.'), findsOneWidget);
    expect(find.text('PDF statement'), findsOneWidget);
    final emailButton = tester.widget<OutlinedButton>(
      find.widgetWithText(OutlinedButton, 'Generate and email PDF'),
    );
    expect(emailButton.onPressed, isNull);

    final downloadButton = find.widgetWithText(
      FilledButton,
      'Generate and download PDF',
    );
    await tester.tap(downloadButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(submitted?.method, 'POST');
    expect(submitted?.path, 'accounts/me/statements');
    expect((submitted?.data as Map)['format'], 'PDF');
    expect((submitted?.data as Map)['deliveryMethod'], 'DOWNLOAD');
    expect(find.text('Queued'), findsOneWidget);
  });
}

Map<String, dynamic> _requestJson() => {
      'requestId': '00000000-0000-4000-8000-000000000010',
      'fromDate': '2026-01-01',
      'toDate': '2026-01-30',
      'format': 'PDF',
      'deliveryMethod': 'EMAIL',
      'status': 'QUEUED',
      'deliveryStatus': 'PENDING',
      'createdAt': '2026-01-30T12:00:00Z',
      'completedAt': null,
      'failureCode': null,
    };
