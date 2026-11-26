import 'package:material_ui/material_ui.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:yourapp_mobile/app.dart';
import 'package:yourapp_mobile/features/onboarding/data/onboarding_repository.dart';
import 'package:yourapp_mobile/features/onboarding/presentation/onboarding_screens.dart';
import 'package:yourapp_mobile/features/onboarding/presentation/liveness_capture_screen.dart';
import 'package:yourapp_mobile/core/security/biometric_service.dart';
import 'package:yourapp_mobile/core/network/api_client.dart';
import 'package:yourapp_mobile/features/home/data/home_repository.dart';
import 'package:yourapp_mobile/features/home/presentation/home_dashboard_screen.dart';
import 'package:yourapp_mobile/features/home/presentation/account_details_screen.dart';
import 'package:yourapp_mobile/features/home/presentation/add_money_screen.dart';
import 'package:yourapp_mobile/features/home/presentation/notifications_screen.dart';
import 'package:yourapp_mobile/features/home/presentation/more_screen.dart';
import 'package:yourapp_mobile/features/support/data/support_repository.dart';
import 'package:yourapp_mobile/features/support/presentation/support_screens.dart';
import 'package:yourapp_mobile/features/home/data/notifications_repository.dart';
import 'package:yourapp_mobile/features/home/presentation/transaction_detail_screen.dart';
import 'package:yourapp_mobile/features/home/presentation/cards_home_screen.dart';
import 'package:yourapp_mobile/features/payments/data/payments_repository.dart';
import 'package:yourapp_mobile/features/payments/presentation/payments_hub_screen.dart';
import 'package:yourapp_mobile/features/payments/presentation/scheduled_payments_screen.dart';
import 'package:yourapp_mobile/features/payments/presentation/bills_demo_screens.dart';
import 'package:yourapp_mobile/features/cards/presentation/card_create_screen.dart';
import 'package:yourapp_mobile/features/cards/security/card_privacy_service.dart';
import 'package:yourapp_mobile/l10n/app_localizations.dart';

void main() {
  test('signup nextStep accepts only documented app routes', () {
    expect(onboardingRouteForNextStep(null), '/signup/details');
    expect(onboardingRouteForNextStep('/signup/nin'), '/signup/nin');
    expect(
      onboardingRouteForNextStep('/signup/biometrics'),
      '/signup/biometrics',
    );
    expect(onboardingRouteForNextStep('NIN_VERIFICATION'), isNull);
    expect(onboardingRouteForResumeStep(null), isNull);
    expect(onboardingRouteForResumeStep('NIN_VERIFICATION'), isNull);
  });

  test('transaction history sends documented search and filter fields',
      () async {
    late Map<String, dynamic> query;
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test/'))
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            query = options.queryParameters;
            handler.resolve(
              Response<Map<String, dynamic>>(
                requestOptions: options,
                data: {'items': <dynamic>[], 'nextCursor': 'next-page'},
              ),
            );
          },
        ),
      );
    final repository = HomeRepository(ApiClient(dio));

    final page = await repository.getTransactionPage(
      cursor: 'previous-page',
      type: 'TRANSFER',
      status: 'FAILED',
      from: '2026-01-01',
      to: '2026-01-31',
      query: 'rent',
    );

    expect(query, {
      'limit': 20,
      'cursor': 'previous-page',
      'type': 'TRANSFER',
      'status': 'FAILED',
      'from': '2026-01-01',
      'to': '2026-01-31',
      'q': 'rent',
    });
    expect(page.items, isEmpty);
    expect(page.nextCursor, 'next-page');
  });

  test('saved recipients use the documented beneficiaries endpoint', () async {
    late String path;
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test/'))
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            path = options.path;
            handler.resolve(
              Response<List<dynamic>>(
                requestOptions: options,
                data: const [
                  {
                    'id': 'beneficiary-1',
                    'accountName': 'Chidinma Example',
                    'nickname': 'Chidinma',
                    'bankCode': '001',
                    'accountNumber': '1234567057',
                    'favourite': true,
                  },
                ],
              ),
            );
          },
        ),
      );

    final items = await PaymentsRepository(ApiClient(dio)).getBeneficiaries();

    expect(path, 'beneficiaries');
    expect(items.single.displayName, 'Chidinma');
    expect(items.single.maskedAccountSuffix, '*** 057');
    expect(items.single.favourite, isTrue);
  });

  test('saved recipient deletion uses the documented beneficiary id route',
      () async {
    late String method;
    late String path;
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test/'))
      ..interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) {
          method = options.method;
          path = options.path;
          handler.resolve(
              Response<void>(requestOptions: options, statusCode: 204));
        },
      ));

    await PaymentsRepository(ApiClient(dio)).deleteBeneficiary('beneficiary-1');

    expect(method, 'DELETE');
    expect(path, 'beneficiaries/beneficiary-1');
  });

  test('notifications list and read actions use documented contract routes',
      () async {
    final requests = <String>[];
    late Map<String, dynamic> query;
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test/'))
      ..interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) {
          requests.add('${options.method} ${options.path}');
          if (options.method == 'GET') {
            query = options.queryParameters;
            handler.resolve(Response<Map<String, dynamic>>(
              requestOptions: options,
              data: {
                'items': [
                  {
                    'id': 'notification-1',
                    'category': 'TRANSACTION',
                    'title': 'Transfer complete',
                    'body': 'Your transfer was completed.',
                    'createdAt': '2026-11-20T10:00:00Z',
                    'isRead': false,
                    'destination': {
                      'type': 'TRANSACTION',
                      'resourceId': 'txn-1',
                    },
                  },
                ],
                'unreadCount': 1,
                'nextCursor': 'page-2',
              },
            ));
          } else {
            handler.resolve(Response<void>(
              requestOptions: options,
              statusCode: 204,
            ));
          }
        },
      ));
    final repository = NotificationsRepository(ApiClient(dio));

    final page = await repository.getNotifications(
      categories: const ['SECURITY', 'SYSTEM'],
    );
    await repository.markRead('notification-1');
    await repository.markAllRead();

    expect(query, {
      'limit': 20,
      'category': ['SECURITY', 'SYSTEM']
    });
    expect(page.items.single.destinationType, 'TRANSACTION');
    expect(page.unreadCount, 1);
    expect(page.nextCursor, 'page-2');
    expect(requests, [
      'GET notifications',
      'POST notifications/notification-1/read',
      'POST notifications/read-all',
    ]);
  });

  testWidgets('notification centre groups, filters and marks items read', (
    tester,
  ) async {
    final requests = <String>[];
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test/'))
      ..interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) {
          requests.add('${options.method} ${options.path}');
          if (options.method == 'GET') {
            handler.resolve(Response<Map<String, dynamic>>(
              requestOptions: options,
              data: {
                'items': [
                  {
                    'id': 'notification-1',
                    'category': 'TRANSACTION',
                    'title': 'Transfer complete',
                    'body': 'Your transfer was completed.',
                    'createdAt': DateTime.now().toUtc().toIso8601String(),
                    'isRead': false,
                    'destination': {'type': 'NONE'},
                  },
                  {
                    'id': 'notification-2',
                    'category': 'SECURITY',
                    'title': 'Security notice',
                    'body': 'Review this security update.',
                    'createdAt': DateTime.now()
                        .subtract(const Duration(days: 1))
                        .toUtc()
                        .toIso8601String(),
                    'isRead': true,
                    'destination': {'type': 'NONE'},
                  },
                ],
                'unreadCount': 1,
                'nextCursor': null,
              },
            ));
          } else {
            handler.resolve(Response<void>(
              requestOptions: options,
              statusCode: 204,
            ));
          }
        },
      ));

    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(ProviderScope(
      overrides: [
        notificationsRepositoryProvider.overrideWithValue(
          NotificationsRepository(ApiClient(dio)),
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const NotificationsScreen(),
      ),
    ));
    await tester.pumpAndSettle();

    expect(find.text('Transfer complete'), findsOneWidget);
    expect(find.text('TODAY'), findsOneWidget);
    expect(find.text('EARLIER'), findsOneWidget);
    await tester.tap(find.text('Security & System'));
    await tester.pumpAndSettle();
    expect(requests.last, 'GET notifications');
    expect(
      requests.length,
      greaterThanOrEqualTo(2),
    );
    await tester.tap(find.text('All'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mark all as read'));
    await tester.pumpAndSettle();

    expect(requests, contains('POST notifications/read-all'));
    expect(tester.takeException(), isNull);
  });

  test('bill catalog and validation use the typed bill API', () async {
    final requests = <RequestOptions>[];
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test/'))
      ..interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
        requests.add(options);
        if (options.path == 'bills/categories') {
          handler.resolve(Response<List<dynamic>>(
            requestOptions: options,
            data: [
              {
                'code': 'ELECTRICITY',
                'name': 'Electricity',
                'description': 'Power',
                'displayOrder': 1,
                'billers': [
                  {
                    'code': 'IKEDC',
                    'name': 'Ikeja Electric',
                    'categoryCode': 'ELECTRICITY',
                    'customerReferenceLabel': 'Meter number',
                    'customerReferencePattern': r'^[0-9]{11}$',
                    'products': [
                      {
                        'code': 'PREPAID',
                        'name': 'Prepaid',
                        'requiresCustomerReference': true,
                        'minimumAmountKobo': 100000,
                      }
                    ],
                  }
                ],
              }
            ],
          ));
        } else {
          expect(options.path, 'bills/validate');
          expect(options.data, {
            'billerCode': 'IKEDC',
            'productCode': 'PREPAID',
            'customerRef': '12345678901',
          });
          handler.resolve(Response<Map<String, dynamic>>(
            requestOptions: options,
            data: {
              'validationId': 'validation-1',
              'customerName': 'Ada Customer',
              'billerName': 'Ikeja Electric',
              'productName': 'Prepaid',
              'validatedAt': '2026-11-20T10:00:00Z',
              'expiresAt': '2026-11-20T10:05:00Z',
            },
          ));
        }
      }));
    final repository = PaymentsRepository(ApiClient(dio));

    final categories = await repository.getBillCatalog();
    final validation = await repository.validateBillReference(
      billerCode: 'IKEDC',
      productCode: 'PREPAID',
      customerRef: '12345678901',
    );

    expect(categories.single.billers.single.products.single.name, 'Prepaid');
    expect(validation.validationId, 'validation-1');
    expect(validation.customerName, 'Ada Customer');
    expect(requests.map((request) => request.path), [
      'bills/categories',
      'bills/validate',
    ]);
  });

  test('bill payment sends PIN token and idempotency key', () async {
    late RequestOptions request;
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test/'))
      ..interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
        request = options;
        handler.resolve(Response<Map<String, dynamic>>(
          requestOptions: options,
          statusCode: 202,
          data: {
            'transaction': {
              'id': 'txn-bill-1',
              'status': 'PENDING',
              'reference': 'REF-BILL-1',
            },
            'vendStatus': 'PENDING',
            'tokenDeliveryStatus': 'PENDING',
            'refundStatus': 'NOT_REQUIRED',
          },
        ));
      }));

    final result = await PaymentsRepository(ApiClient(dio)).payBill(
      validationId: 'validation-1',
      amountKobo: 2500000,
      pinToken: 'pin-token',
      idempotencyKey: 'idem-bill-1',
      saveBiller: true,
    );

    expect(request.method, 'POST');
    expect(request.path, 'bills/pay');
    expect(request.headers['X-Pin-Token'], 'pin-token');
    expect(request.headers['Idempotency-Key'], 'idem-bill-1');
    expect(request.data, {
      'validationId': 'validation-1',
      'amountKobo': 2500000,
      'saveBiller': true,
    });
    expect(result.vendStatus, 'PENDING');
    expect(result.transactionId, 'txn-bill-1');
  });

  test('bill catalog and customer validation use typed bill endpoints',
      () async {
    final requests = <RequestOptions>[];
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test/'))
      ..interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
        requests.add(options);
        if (options.path == 'bills/categories') {
          handler.resolve(Response<List<dynamic>>(
            requestOptions: options,
            data: [
              {
                'code': 'ELECTRICITY',
                'name': 'Electricity',
                'description': 'Power',
                'displayOrder': 1,
                'billers': [
                  {
                    'code': 'IKEDC',
                    'name': 'Ikeja Electric',
                    'categoryCode': 'ELECTRICITY',
                    'customerReferenceLabel': 'Meter number',
                    'customerReferencePattern': r'^[0-9]{11}$',
                    'products': [
                      {
                        'code': 'PREPAID',
                        'name': 'Prepaid',
                        'requiresCustomerReference': true,
                        'minimumAmountKobo': 100000,
                      }
                    ],
                  }
                ],
              }
            ],
          ));
        } else {
          expect(options.path, 'bills/validate');
          expect(options.data, {
            'billerCode': 'IKEDC',
            'productCode': 'PREPAID',
            'customerRef': '12345678901',
          });
          handler.resolve(Response<Map<String, dynamic>>(
            requestOptions: options,
            data: {
              'validationId': 'validation-1',
              'customerName': 'Ada Customer',
              'billerName': 'Ikeja Electric',
              'productName': 'Prepaid',
              'validatedAt': '2026-11-20T10:00:00Z',
              'expiresAt': '2026-11-20T10:05:00Z',
            },
          ));
        }
      }));
    final repository = PaymentsRepository(ApiClient(dio));

    final categories = await repository.getBillCatalog();
    final validation = await repository.validateBillReference(
      billerCode: 'IKEDC',
      productCode: 'PREPAID',
      customerRef: '12345678901',
    );

    expect(categories.single.billers.single.products.single.name, 'Prepaid');
    expect(validation.validationId, 'validation-1');
    expect(validation.customerName, 'Ada Customer');
    expect(requests.map((request) => request.path), [
      'bills/categories',
      'bills/validate',
    ]);
  });

  test('bill payment includes validation, PIN token and idempotency key',
      () async {
    late RequestOptions request;
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test/'))
      ..interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
        request = options;
        handler.resolve(Response<Map<String, dynamic>>(
          requestOptions: options,
          statusCode: 202,
          data: {
            'transaction': {
              'id': 'txn-bill-1',
              'status': 'PENDING',
              'reference': 'REF-BILL-1',
            },
            'vendStatus': 'PENDING',
            'tokenDeliveryStatus': 'PENDING',
            'refundStatus': 'NOT_REQUIRED',
          },
        ));
      }));

    final result = await PaymentsRepository(ApiClient(dio)).payBill(
      validationId: 'validation-1',
      amountKobo: 2500000,
      pinToken: 'pin-token',
      idempotencyKey: 'idem-bill-1',
      saveBiller: true,
    );

    expect(request.method, 'POST');
    expect(request.path, 'bills/pay');
    expect(request.headers['X-Pin-Token'], 'pin-token');
    expect(request.headers['Idempotency-Key'], 'idem-bill-1');
    expect(request.data, {
      'validationId': 'validation-1',
      'amountKobo': 2500000,
      'saveBiller': true,
    });
    expect(result.vendStatus, 'PENDING');
    expect(result.transactionId, 'txn-bill-1');
  });

  testWidgets('payments hub renders documented actions and saved recipients', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          beneficiariesProvider.overrideWith(
            (ref) async => const [
              BeneficiarySummary(
                id: 'beneficiary-1',
                accountName: 'Chidinma Example',
                nickname: 'Chidinma E.',
                bankCode: '001',
                accountNumber: '1234567057',
                favourite: true,
              ),
            ],
          ),
          recentTransactionsProvider.overrideWith(
            (ref) async => HomeResource(
              data: [
                TransactionSummary(
                  id: 'transfer-1',
                  type: 'TRANSFER',
                  direction: 'D',
                  amountKobo: 1250000,
                  feeKobo: 0,
                  reference: 'REF-1',
                  balanceAfterKobo: 1000000,
                  status: 'SUCCESSFUL',
                  failureCode: null,
                  counterpartyName: 'Tunde Example',
                  counterpartyBank: 'Bank code 001',
                  narration: 'Test transfer',
                  createdAt: DateTime(2026, 11, 20),
                ),
              ],
              updatedAt: DateTime(2026, 11, 20),
            ),
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const PaymentsHubScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Payments'), findsOneWidget);
    expect(find.text('To bank account'), findsOneWidget);
    expect(find.text('Scan and pay QR'), findsOneWidget);
    expect(find.text('Saved recipients'), findsOneWidget);
    expect(find.text('Chidinma E.'), findsOneWidget);
    await tester.drag(find.byType(ListView).first, const Offset(0, -1600));
    await tester.pumpAndSettle();
    expect(find.text('Recent transfers').first, findsOneWidget);
    expect(find.text('Tunde Example'), findsOneWidget);
  });

  test('PIN verification is authenticated while login stays public', () async {
    final requests = <RequestOptions>[];
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test/'));
    final client = ApiClient.withTokenReader(
      dio,
      (key) async => key == 'session.access_token' ? 'session-token' : null,
    );
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          requests.add(options);
          handler.resolve(
            Response<Map<String, dynamic>>(
              requestOptions: options,
              data: const <String, dynamic>{},
            ),
          );
        },
      ),
    );

    await client.dio.post<Map<String, dynamic>>('auth/pin/verify');
    await client.dio.post<Map<String, dynamic>>('auth/login');

    expect(requests[0].headers['Authorization'], 'Bearer session-token');
    expect(requests[1].headers.containsKey('Authorization'), isFalse);
  });

  test('card freeze sends only the documented frozen flag', () async {
    late String path;
    late Object? body;
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test/'))
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            path = options.path;
            body = options.data;
            handler.resolve(Response<void>(requestOptions: options));
          },
        ),
      );
    final repository = HomeRepository(ApiClient(dio));

    await repository.setCardFrozen('card-123', frozen: true);

    expect(path, 'cards/card-123/freeze');
    expect(body, {'frozen': true});
  });

  test('card creation verifies PIN and sends the token plus idempotency key',
      () async {
    final requests = <RequestOptions>[];
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test/'))
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            requests.add(options);
            final data = options.path == 'auth/pin/verify'
                ? {'pinToken': 'one-action-token', 'expiresInSeconds': 45}
                : {
                    'id': 'card-1',
                    'label': 'Subscriptions',
                    'theme': 'BERRY',
                    'last4': '1234',
                    'status': 'ACTIVE',
                  };
            handler.resolve(
              Response<Map<String, dynamic>>(
                requestOptions: options,
                data: data,
              ),
            );
          },
        ),
      );
    final repository = HomeRepository(ApiClient(dio));

    final pinToken = await repository.verifyTransactionPin('1234');
    final card = await repository.createCard(
      label: 'Subscriptions',
      theme: 'BERRY',
      pinToken: pinToken,
      idempotencyKey: 'd0c954c2-4022-4d8b-9e94-439ed04c2890',
      dailyLimitKobo: 5000000,
    );

    expect(requests[0].path, 'auth/pin/verify');
    expect(requests[0].data, {'pin': '1234'});
    expect(requests[1].path, 'cards');
    expect(requests[1].data, {
      'label': 'Subscriptions',
      'theme': 'BERRY',
      'dailyLimitKobo': 5000000,
    });
    expect(requests[1].headers['X-Pin-Token'], 'one-action-token');
    expect(
      requests[1].headers['Idempotency-Key'],
      'd0c954c2-4022-4d8b-9e94-439ed04c2890',
    );
    expect(card.last4, '1234');
  });

  test('card reveal sends the one-action PIN token in the documented header',
      () async {
    late RequestOptions request;
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test/'))
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            request = options;
            handler.resolve(
              Response<Map<String, dynamic>>(
                requestOptions: options,
                data: {
                  'number': '4111111111111111',
                  'expiry': '12/29',
                  'cvv': '123',
                },
              ),
            );
          },
        ),
      );
    final repository = HomeRepository(ApiClient(dio));

    final details = await repository.revealCardDetails(
      id: 'card-1',
      pinToken: 'one-action-token',
    );

    expect(request.method, 'POST');
    expect(request.path, 'cards/card-1/details');
    expect(request.headers['X-Pin-Token'], 'one-action-token');
    expect(details.number, '4111111111111111');
    expect(details.expiry, '12/29');
    expect(details.cvv, '123');
  });

  test('card limits require token and include both limits', () async {
    late RequestOptions request;
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test/'))
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            request = options;
            handler.resolve(
              Response<Map<String, dynamic>>(
                requestOptions: options,
                data: {
                  'id': 'card-1',
                  'label': 'Daily',
                  'theme': 'BERRY',
                  'last4': '1234',
                  'status': 'ACTIVE',
                  'perTxnLimitKobo': 100000,
                  'dailyLimitKobo': 500000,
                },
              ),
            );
          },
        ),
      );
    final repository = HomeRepository(ApiClient(dio));

    final card = await repository.updateCardLimits(
      id: 'card-1',
      pinToken: 'one-action-token',
      perTxnLimitKobo: 100000,
      dailyLimitKobo: 500000,
    );

    expect(request.method, 'PUT');
    expect(request.path, 'cards/card-1/limits');
    expect(request.headers['X-Pin-Token'], 'one-action-token');
    expect(request.data, {
      'perTxnLimitKobo': 100000,
      'dailyLimitKobo': 500000,
    });
    expect(card.dailyLimitKobo, 500000);
  });

  test('card settings read and update use documented setting fields', () async {
    final requests = <RequestOptions>[];
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test/'))
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            requests.add(options);
            handler.resolve(
              Response<Map<String, dynamic>>(
                requestOptions: options,
                data: {
                  'pushAlerts': true,
                  'smsAlerts': false,
                  'onlinePurchases': true,
                  'internationalPurchases': false,
                },
              ),
            );
          },
        ),
      );
    final repository = HomeRepository(ApiClient(dio));
    await repository.getCardSettings('card-1');
    await repository.updateCardSettings(
      id: 'card-1',
      settings: const CardSettings(
        pushAlerts: true,
        smsAlerts: false,
        onlinePurchases: true,
        internationalPurchases: false,
      ),
    );

    expect(requests[0].method, 'GET');
    expect(requests[0].path, 'cards/card-1/settings');
    expect(requests[1].method, 'PUT');
    expect(requests[1].data, {
      'pushAlerts': true,
      'smsAlerts': false,
      'onlinePurchases': true,
      'internationalPurchases': false,
    });
  });

  test('card rename and theme use partial card update operation', () async {
    late RequestOptions request;
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test/'))
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            request = options;
            handler.resolve(
              Response<Map<String, dynamic>>(
                requestOptions: options,
                data: {
                  'id': 'card-1',
                  'label': 'Travel',
                  'theme': 'FOREST',
                  'last4': '1234',
                  'status': 'ACTIVE',
                },
              ),
            );
          },
        ),
      );
    final repository = HomeRepository(ApiClient(dio));

    await repository.updateCard(id: 'card-1', label: 'Travel', theme: 'FOREST');

    expect(request.method, 'PATCH');
    expect(request.path, 'cards/card-1');
    expect(request.data, {'label': 'Travel', 'theme': 'FOREST'});
  });

  test('card delete requires the one-action PIN token', () async {
    late RequestOptions request;
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test/'))
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            request = options;
            handler.resolve(Response<void>(requestOptions: options));
          },
        ),
      );
    final repository = HomeRepository(ApiClient(dio));

    await repository.deleteCard(id: 'card-1', pinToken: 'one-action-token');

    expect(request.method, 'DELETE');
    expect(request.path, 'cards/card-1');
    expect(request.headers['X-Pin-Token'], 'one-action-token');
  });

  test('card transaction history uses the card-scoped cursor endpoint',
      () async {
    late RequestOptions request;
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test/'))
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            request = options;
            handler.resolve(
              Response<Map<String, dynamic>>(
                requestOptions: options,
                data: {'items': <dynamic>[], 'nextCursor': null},
              ),
            );
          },
        ),
      );
    final repository = HomeRepository(ApiClient(dio));

    final page = await repository.getCardTransactions(
      'card-1',
      limit: 10,
      cursor: 'page-2',
    );

    expect(request.method, 'GET');
    expect(request.path, 'cards/card-1/transactions');
    expect(request.queryParameters, {'limit': 10, 'cursor': 'page-2'});
    expect(page.items, isEmpty);
    expect(page.nextCursor, isNull);
  });

  testWidgets('card create requires a label before opening PIN confirmation', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const CardCreateScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView), const Offset(0, -900));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Review and create'));
    await tester.pumpAndSettle();

    expect(find.text('Enter a name for this card.'), findsOneWidget);
    expect(find.text('Confirm with transaction PIN'), findsNothing);
  });

  testWidgets('card creation can request an obscured PIN without screen lock', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const CardCreateScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, 'Travel');
    await tester.drag(find.byType(ListView), const Offset(0, -900));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Review and create'));
    await tester.pumpAndSettle();

    expect(find.text('Confirm with transaction PIN'), findsOneWidget);
    final pinField = tester.widget<TextField>(find.byType(TextField).last);
    expect(pinField.obscureText, isTrue);
  });

  testWidgets('cards UI preview labels its local sample cards', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          homeCardsProvider.overrideWith(
            (ref) async => HomeResource(
              data: const [
                CardSummary(
                  id: 'sample-card',
                  label: 'Preview card',
                  theme: 'BERRY',
                  last4: '6194',
                  status: 'ACTIVE',
                ),
              ],
              updatedAt: DateTime(2026),
            ),
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: CardsHomeScreen(preview: true),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('UI preview only.'), findsOneWidget);
    expect(find.text('Preview card'), findsOneWidget);
    expect(find.textContaining('6194'), findsOneWidget);
    expect(find.text('Create virtual card'), findsNothing);
  });

  test('card privacy protection fails closed without a native implementation',
      () async {
    expect(await CardPrivacyService.enable(), isFalse);
  });

  testWidgets('sign-up opens phone entry and validates a Nigerian number', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const ProviderScope(child: YourApp()));
    await tester.pumpAndSettle();

    expect(find.text('Create account'), findsOneWidget);
    await tester.tap(find.text('Create account'));
    await tester.pumpAndSettle();

    expect(find.text('What is your phone number?'), findsOneWidget);
    final continueButton = find.widgetWithText(FilledButton, 'Continue');
    expect(tester.widget<FilledButton>(continueButton).onPressed, isNull);

    await tester.enterText(find.byType(TextField), '08012345678');
    await tester.pump();

    expect(tester.widget<FilledButton>(continueButton).onPressed, isNotNull);
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
  });

  testWidgets('preview links are only visible in draft preview builds', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          onboardingStatusProvider.overrideWith(
            (ref) async => const OnboardingStatusSnapshot(
              state: OnboardingAccountState.pendingAccount,
              step: null,
              accountNumber: null,
            ),
          ),
        ],
        child: const YourApp(),
      ),
    );
    await tester.pumpAndSettle();

    if (!draftLegalPreviewEnabled) {
      expect(find.text('Preview Terms and Privacy'), findsNothing);
      expect(find.text('Preview selfie capture'), findsNothing);
      expect(find.text('Preview biometrics'), findsNothing);
      expect(
        find.text('Preview cards UI'),
        cardUiPreviewEnabled ? findsOneWidget : findsNothing,
      );
      return;
    }
    expect(
      find.text('Preview cards UI'),
      cardUiPreviewEnabled ? findsOneWidget : findsNothing,
    );

    await tester.tap(find.text('Preview Terms and Privacy'));
    await tester.pumpAndSettle();
    expect(find.text('Before we continue'), findsOneWidget);
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Preview selfie capture'));
    await tester.pumpAndSettle();
    expect(find.text('Start camera'), findsOneWidget);
    expect(find.text('During the recording'), findsOneWidget);
    expect(find.text('Blink slowly once.'), findsOneWidget);
    expect(
      find.text('Turn your head slowly to the left, then to the right.'),
      findsOneWidget,
    );
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Preview biometrics'));
    await tester.pumpAndSettle();
    expect(find.text('Unlock faster'), findsOneWidget);
    expect(find.text('Enable biometrics'), findsOneWidget);
    expect(find.text('Not now'), findsOneWidget);
    await tester.tap(find.text('Not now'));
    await tester.pumpAndSettle();
    expect(
        find.text(
            'Your account is being set up. Check your status again later.'),
        findsOneWidget);
  });

  testWidgets('card preview flag opens labelled local sample cards', (
    tester,
  ) async {
    if (!cardUiPreviewEnabled) return;
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const ProviderScope(child: YourApp()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Preview cards UI'));
    await tester.pumpAndSettle();

    expect(find.textContaining('UI preview only.'), findsOneWidget);
    expect(find.text('Shopping & Subscriptions'), findsOneWidget);
    expect(find.text('Travel'), findsOneWidget);
    expect(find.textContaining('6194'), findsOneWidget);
    expect(find.textContaining('2841'), findsOneWidget);
  });

  testWidgets('CB-ONB-003 rejects BVNs shorter than 11 digits', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const IdentityNumberScreen(isBvn: true),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), '1234567890');
    await tester.tap(find.text('Verify BVN'));
    await tester.pump();

    expect(find.text('Enter a valid 11-digit number.'), findsOneWidget);
  });

  testWidgets('home renders API balances and supports hiding them', (
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
                ledgerBalanceKobo: 12345678,
                availableBalanceKobo: 12000000,
                balanceCapKobo: 50000000,
              ),
              updatedAt: DateTime(2026, 11, 19, 10),
            ),
          ),
          recentTransactionsProvider.overrideWith(
            (ref) async => HomeResource(
              data: [
                TransactionSummary(
                  id: 'txn-1',
                  type: 'TRANSFER',
                  direction: 'C',
                  amountKobo: 250000,
                  feeKobo: 0,
                  reference: 'REF-1',
                  balanceAfterKobo: 12000000,
                  status: 'SUCCESSFUL',
                  failureCode: null,
                  counterpartyName: 'Chioma Okonjo',
                  counterpartyBank: 'Example Bank',
                  narration: 'Refund',
                  createdAt: DateTime(2026, 11, 18, 9),
                ),
              ],
              updatedAt: DateTime(2026, 11, 19, 10),
            ),
          ),
          homeCardsProvider.overrideWith(
            (ref) async => HomeResource(
              data: const [],
              updatedAt: DateTime(2026, 11, 19, 10),
            ),
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const HomeDashboardScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Welcome back, Tunde'), findsOneWidget);
    expect(find.textContaining('120,000.00'), findsOneWidget);
    await tester.tap(find.byTooltip('Hide balance'));
    await tester.pumpAndSettle();
    expect(find.text('••••••'), findsWidgets);
    expect(find.byTooltip('Show balance'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('account details follows the API fields and Stitch card layout', (
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
              updatedAt: DateTime(2026, 11, 20),
            ),
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const AccountDetailsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Tunde Adeyemi'), findsOneWidget);
    expect(find.text('0123456789'), findsOneWidget);
    expect(find.text('Bank name unavailable'), findsOneWidget);
    expect(find.textContaining('Tier 2 limits'), findsOneWidget);
    expect(find.text('Daily transfer limit'), findsOneWidget);
    expect(find.text('Share as text'), findsOneWidget);
    expect(find.text('Share as image'), findsOneWidget);
    expect(find.text('Zenith Bank Partner'), findsNothing);
  });

  testWidgets('add money shows live account transfer details only', (
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
                ledgerBalanceKobo: 12345678,
                availableBalanceKobo: 12000000,
                balanceCapKobo: 50000000,
              ),
              updatedAt: DateTime(2026, 11, 20),
            ),
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const AddMoneyScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Bank transfer'), findsOneWidget);
    expect(find.text('0123456789'), findsOneWidget);
    expect(find.text('Tunde Adeyemi'), findsOneWidget);
    expect(find.text('Real time'), findsOneWidget);
    expect(find.text('Zenith Bank Partner'), findsNothing);
    expect(find.text('Cash deposit at Agent'), findsNothing);
    expect(find.text('Direct debit / USSD'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('More hub uses live account data and labels incomplete settings',
      (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(ProviderScope(
      overrides: [
        homeAccountProvider.overrideWith(
          (ref) async => HomeResource(
            data: const AccountSummary(
              accountNumber: '0123456789',
              accountName: 'Chika Okafor',
              status: 'ACTIVE',
              currency: 'NGN',
              tier: 2,
              perTxnLimitKobo: 100000000,
              dailyOutLimitKobo: 500000000,
              ledgerBalanceKobo: 12345678,
              availableBalanceKobo: 12000000,
              balanceCapKobo: 1000000000,
            ),
            updatedAt: DateTime(2026, 11, 23),
          ),
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const MoreScreen(),
      ),
    ));
    await tester.pumpAndSettle();

    expect(find.text('Chika Okafor'), findsOneWidget);
    expect(find.textContaining('0123456789'), findsOneWidget);
    expect(find.text('Daily ₦5000000 • Per transfer ₦1000000'), findsOneWidget);
    expect(find.text('Statements & reports'), findsOneWidget);
    await tester.dragUntilVisible(
      find.text('Legal, terms & privacy'),
      find.byType(ListView),
      const Offset(0, -420),
    );
    expect(find.text('Legal, terms & privacy'), findsOneWidget);
    expect(find.text('Logout'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  test('support tickets use documented list, create, detail and reply paths',
      () async {
    final requests = <String>[];
    late Map<String, dynamic> createPayload;
    final now = DateTime(2026, 11, 23, 10).toUtc().toIso8601String();
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test/'))
      ..interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
        requests.add('${options.method} ${options.path}');
        if (options.method == 'GET' && options.path == 'tickets') {
          handler.resolve(Response<Map<String, dynamic>>(
            requestOptions: options,
            data: {'items': <dynamic>[], 'nextCursor': null},
          ));
          return;
        }
        if (options.method == 'POST' && options.path == 'tickets') {
          createPayload = options.data as Map<String, dynamic>;
          handler.resolve(Response<Map<String, dynamic>>(
            requestOptions: options,
            statusCode: 201,
            data: {
              'id': 'ticket-1',
              'category': 'TRANSFER',
              'subject': 'Transfer issue',
              'status': 'OPEN',
              'transactionId': 'txn-1',
              'createdAt': now,
              'updatedAt': now,
            },
          ));
          return;
        }
        if (options.method == 'GET' && options.path == 'tickets/ticket-1') {
          handler.resolve(Response<Map<String, dynamic>>(
            requestOptions: options,
            data: {
              'id': 'ticket-1',
              'category': 'TRANSFER',
              'subject': 'Transfer issue',
              'status': 'OPEN',
              'transactionId': 'txn-1',
              'createdAt': now,
              'updatedAt': now,
              'messages': [
                {
                  'id': 'message-1',
                  'authorType': 'SUPPORT',
                  'body': 'We received your ticket.',
                  'createdAt': now,
                },
              ],
            },
          ));
          return;
        }
        handler.resolve(Response<Map<String, dynamic>>(
          requestOptions: options,
          statusCode: 201,
          data: {
            'id': 'message-2',
            'authorType': 'CUSTOMER',
            'body': 'Please check this transfer.',
            'createdAt': now,
          },
        ));
      }));
    final repository = SupportRepository(ApiClient(dio));

    final page = await repository.getTickets();
    final created = await repository.createTicket(
      category: 'TRANSFER',
      issueType: 'CHARGED_BUT_FAILED',
      description: 'Please review my transfer.',
      transactionId: 'txn-1',
    );
    final detail = await repository.getTicket(created.id);
    final reply = await repository.reply(
      ticketId: created.id,
      body: 'Please check this transfer.',
    );

    expect(page.items, isEmpty);
    expect(createPayload, {
      'category': 'TRANSFER',
      'issueType': 'CHARGED_BUT_FAILED',
      'description': 'Please review my transfer.',
      'transactionId': 'txn-1',
    });
    expect(detail.messages.single.body, 'We received your ticket.');
    expect(reply.authorType, 'CUSTOMER');
    expect(requests, [
      'GET tickets',
      'POST tickets',
      'GET tickets/ticket-1',
      'POST tickets/ticket-1/messages',
    ]);
  });

  testWidgets('Help Centre searches app guidance and shows safe fallback', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const HelpCentreScreen(),
    ));
    await tester.pumpAndSettle();

    expect(find.text('How can we help you today?'), findsOneWidget);
    expect(find.text('Frequently asked questions'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'freeze or manage a card');
    await tester.pumpAndSettle();
    expect(find.text('Freeze or manage a card'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'unlisted question');
    await tester.pumpAndSettle();
    expect(find.textContaining('No matching help articles'), findsOneWidget);
    expect(find.text('File a support ticket'), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'transaction problem report requires reason and shows linked data', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(ProviderScope(
      overrides: [
        transactionDetailsProvider.overrideWith((ref, id) async => HomeResource(
              data: TransactionSummary(
                id: 'txn-report-1',
                type: 'TRANSFER',
                direction: 'D',
                amountKobo: 2500000,
                feeKobo: 0,
                reference: 'REF-REPORT-1',
                balanceAfterKobo: 10000000,
                status: 'PENDING',
                failureCode: null,
                counterpartyName: 'Amina Example',
                counterpartyBank: 'Example Bank',
                narration: 'Rent',
                createdAt: DateTime(2026, 11, 23, 10),
              ),
              updatedAt: DateTime(2026, 11, 23),
            )),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const ReportTransactionProblemScreen(
          transactionId: 'txn-report-1',
        ),
      ),
    ));
    await tester.pumpAndSettle();

    expect(find.text('Amina Example'), findsOneWidget);
    expect(find.textContaining('REF-REPORT-1'), findsOneWidget);
    expect(find.textContaining('₦25,000.00'), findsOneWidget);
    expect(find.text('Not received'), findsOneWidget);
    await tester.dragUntilVisible(
      find.textContaining('Attachments are not supported'),
      find.byType(ListView),
      const Offset(0, -400),
    );
    expect(
        find.textContaining('Attachments are not supported'), findsOneWidget);
    await tester.dragUntilVisible(
      find.text('Submit dispute ticket'),
      find.byType(ListView),
      const Offset(0, -400),
    );
    await tester.tap(find.text('Submit dispute ticket'));
    await tester.pumpAndSettle();
    expect(find.text('Select an issue category to continue.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('report problem demo preview uses sample data without API setup',
      (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const ProviderScope(
        child: ReportTransactionProblemScreen(
          transactionId: 'demo-transaction-report',
          previewOnly: true,
        ),
      ),
    ));
    await tester.pumpAndSettle();

    expect(find.textContaining('DEMO PREVIEW'), findsOneWidget);
    expect(find.text('Amina Example'), findsOneWidget);
    expect(find.textContaining('DEMO-REF-8042'), findsOneWidget);
    expect(find.text('Not received'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('demo login can open the labelled account details fixture', (
    tester,
  ) async {
    if (!demoLoginEnabled) return;
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const ProviderScope(child: YourApp()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Demo login'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Account details'));
    await tester.pumpAndSettle();

    expect(find.textContaining('DEMO DATA ONLY'), findsOneWidget);
    expect(find.text('Ada Nwosu'), findsOneWidget);
    expect(find.text('Demo account'), findsOneWidget);
    expect(find.text('Share as text'), findsOneWidget);
  });

  testWidgets('demo login can open the labelled profile preview', (
    tester,
  ) async {
    if (!demoLoginEnabled) return;
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const ProviderScope(child: YourApp()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Demo login'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Profile preview'));
    await tester.pumpAndSettle();

    expect(find.textContaining('DEMO DATA ONLY'), findsOneWidget);
    expect(find.text('Ada Nwosu'), findsNWidgets(2));
    expect(find.text('Tier 2'), findsOneWidget);
    expect(find.text('Not available from account service'), findsNWidgets(3));
    expect(find.textContaining('example.com'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('demo login opens the labelled Add money preview', (
    tester,
  ) async {
    if (!demoLoginEnabled) return;
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const ProviderScope(child: YourApp()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Demo login'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add money'));
    await tester.pumpAndSettle();

    expect(find.textContaining('DEMO PREVIEW'), findsOneWidget);
    expect(find.text('0123456789'), findsOneWidget);
    expect(find.text('Ada Nwosu'), findsOneWidget);
    expect(find.textContaining('No funds will be received.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('demo login can open the read-only Payments hub fixture', (
    tester,
  ) async {
    if (!demoLoginEnabled) return;
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const ProviderScope(child: YourApp()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Demo login'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Payments').last);
    await tester.pumpAndSettle();

    expect(find.textContaining('DEMO DATA ONLY'), findsOneWidget);
    expect(find.text('To bank account'), findsOneWidget);
    expect(find.text('Chidinma E.'), findsOneWidget);
    expect(find.text('Recent transfers'), findsNothing);
  });

  testWidgets(
      'scheduled payment demo follows Stitch structure and labels fixtures',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const ScheduledPaymentsScreen(demo: true),
    ));
    await tester.pumpAndSettle();

    expect(find.text('Scheduled payments'), findsOneWidget);
    expect(find.text('Ikeja Electric Mandate'), findsOneWidget);
    expect(find.text('Upcoming this month'), findsOneWidget);
    await tester.drag(find.byType(ListView), const Offset(0, -1800));
    await tester.pumpAndSettle();
    expect(find.textContaining('DEMO DATA ONLY'), findsOneWidget);
    expect(find.text('Create new scheduled payment'), findsOneWidget);
  });

  testWidgets('scheduled demo can create and pause a local sample schedule', (
    tester,
  ) async {
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const ScheduledPaymentsScreen(demo: true),
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Calendar'));
    await tester.pumpAndSettle();
    expect(find.text('Ikeja Electric Mandate'), findsWidgets);
    await tester.tap(find.widgetWithText(TextButton, 'Cancel').last);
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Create new scheduled payment'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextField, 'Payment name'),
      'Demo rent',
    );
    await tester.enterText(find.widgetWithText(TextField, 'Amount'), '2500');
    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await tester.pumpAndSettle();

    expect(find.text('Demo rent'), findsOneWidget);
    await tester.tap(find.byType(Switch).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Paused (2)'));
    await tester.pumpAndSettle();
    expect(find.text('Demo rent'), findsOneWidget);
    expect(find.text('Paused').first, findsOneWidget);
    expect(find.textContaining('No payment was made'), findsOneWidget);
  });

  testWidgets('bill category screen searches the Stitch category set', (
    tester,
  ) async {
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const DemoBillCategoryScreen(),
    ));
    await tester.pumpAndSettle();

    expect(find.text('Electricity'), findsOneWidget);
    expect(find.text('Cable & Internet'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'education');
    await tester.pumpAndSettle();
    expect(find.text('Education & Exams'), findsOneWidget);
    expect(find.text('Electricity'), findsNothing);
  });

  testWidgets('Payments hub bill icons open category and biller screens', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final router = GoRouter(
      initialLocation: '/payments',
      routes: [
        GoRoute(
          path: '/payments',
          builder: (context, state) => ProviderScope(
            overrides: [
              beneficiariesProvider.overrideWith((ref) async => const []),
              recentTransactionsProvider.overrideWith(
                (ref) async => HomeResource(
                  data: const [],
                  updatedAt: DateTime.now(),
                ),
              ),
            ],
            child: const PaymentsHubScreen(demo: true),
          ),
        ),
        GoRoute(
          path: '/demo/bills',
          builder: (context, state) => const DemoBillCategoryScreen(),
        ),
        GoRoute(
          path: '/demo/bills/billers',
          builder: (context, state) => DemoBillersScreen(
            categoryCode: state.uri.queryParameters['category'] ?? '',
          ),
        ),
        GoRoute(
          path: '/demo/bills/pay',
          builder: (context, state) => DemoBillPayScreen(
            biller: state.uri.queryParameters['biller'] ?? 'Demo biller',
          ),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(MaterialApp.router(
      routerConfig: router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    ));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Electricity'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Electricity').last);
    await tester.pumpAndSettle();
    expect(find.text('Categories'), findsOneWidget);

    await tester.tap(find.text('Electricity').last);
    await tester.pumpAndSettle();
    expect(find.text('Ikeja Electric'), findsOneWidget);
    await tester.tap(find.text('Ikeja Electric'));
    await tester.pumpAndSettle();
    expect(find.text('Meter number'), findsOneWidget);
  });

  testWidgets('bill demo validates and confirms without making a payment', (
    tester,
  ) async {
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const DemoBillPayScreen(biller: 'Ikeja Electric'),
    ));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).first, '01234567891');
    await tester.tap(find.text('Validate reference'));
    await tester.pumpAndSettle();
    expect(find.text('DEMO REFERENCE VALIDATED'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).last, '10000');
    await tester.drag(find.byType(ListView), const Offset(0, -1600));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue to payment'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Complete demo'));
    await tester.pumpAndSettle();
    expect(find.text('Demo complete'), findsOneWidget);
    expect(find.textContaining('no money moved'), findsOneWidget);
  });

  testWidgets('transaction detail renders the API transaction fields', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          transactionDetailsProvider('txn-1').overrideWith(
            (ref) async => HomeResource(
              data: TransactionSummary(
                id: 'txn-1',
                type: 'TRANSFER',
                direction: 'D',
                amountKobo: 250000,
                feeKobo: 100,
                reference: 'REF-1',
                balanceAfterKobo: 12000000,
                status: 'SUCCESSFUL',
                failureCode: null,
                counterpartyName: 'Chioma Okonjo',
                counterpartyBank: 'Example Bank',
                narration: 'Lunch repayment',
                createdAt: DateTime(2026, 11, 18, 9),
              ),
              updatedAt: DateTime(2026, 11, 19, 10),
            ),
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const TransactionDetailScreen(transactionId: 'txn-1'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('−₦2,500.00'), findsOneWidget);
    expect(find.text('Chioma Okonjo'), findsOneWidget);
    expect(find.text('REF-1'), findsOneWidget);
    expect(find.text('Successful'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('login offers biometrics only when a saved session is available',
      (
    tester,
  ) async {
    Future<void> showLogin(bool biometricAvailable) async {
      await tester.pumpWidget(
        ProviderScope(
          key: ValueKey(biometricAvailable),
          overrides: [
            biometricLoginAvailableProvider.overrideWith(
              (ref) async => biometricAvailable,
            ),
          ],
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const LoginScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    await showLogin(true);
    expect(find.text('Use biometrics'), findsOneWidget);
    await showLogin(false);
    expect(find.text('Use biometrics'), findsNothing);
  });

  testWidgets('CB-ONB-006 rejects repeated passcodes', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const CredentialSetupScreen(isPin: false),
        ),
      ),
    );

    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), '111111');
    await tester.enterText(fields.at(1), '111111');
    await tester.tap(find.text('Continue'));
    await tester.pump();

    expect(
      find.text('Choose a passcode that is not repeated or sequential.'),
      findsOneWidget,
    );
  });

  testWidgets('CB-ONB-006 rejects mismatched credentials', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const CredentialSetupScreen(isPin: true),
        ),
      ),
    );

    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), '2580');
    await tester.enterText(fields.at(1), '2581');
    await tester.tap(find.text('Continue'));
    await tester.pump();

    expect(find.text('The entries do not match. Try again.'), findsOneWidget);
  });

  testWidgets('CB-ONB-002 shows draft legal copy without enabling consent', (
    tester,
  ) async {
    Future<void> scrollIntoView(Finder finder) async {
      for (var attempt = 0; attempt < 8; attempt++) {
        final rect = tester.getRect(finder);
        final height =
            tester.view.physicalSize.height / tester.view.devicePixelRatio;
        if (rect.top >= 0 && rect.bottom <= height) return;
        await tester.drag(
          find.byType(ListView).first,
          Offset(0, rect.bottom > height ? -320 : 320),
        );
        await tester.pumpAndSettle();
      }
    }

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const ConsentPendingScreen(),
        ),
      ),
    );

    expect(find.textContaining('Draft preview only.'), findsOneWidget);
    await tester.tap(find.byType(ExpansionTile).first);
    await tester.pumpAndSettle();
    expect(
        find.textContaining('CUSTOMER TERMS AND CONDITIONS'), findsOneWidget);
    final continueButton = find.byType(FilledButton).last;
    if (draftLegalPreviewEnabled) {
      await scrollIntoView(find.byType(CheckboxListTile).first);
      await tester.tap(find.byType(CheckboxListTile).first);
      await tester.pumpAndSettle();
      await scrollIntoView(find.byType(ExpansionTile).at(1));
      await tester.tap(find.byType(ExpansionTile).at(1));
      await tester.pumpAndSettle();
      final privacyCheckbox = find.widgetWithText(
        CheckboxListTile,
        'I acknowledge the Privacy Notice',
      );
      await scrollIntoView(privacyCheckbox);
      await tester.tap(privacyCheckbox);
      await tester.pumpAndSettle();
      expect(tester.widget<FilledButton>(continueButton).onPressed, isNotNull);
    } else {
      expect(tester.widget<FilledButton>(continueButton).onPressed, isNull);
    }
  });

  testWidgets('CB-ONB-005 capture screen does not claim verification', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const LivenessCaptureScreen(),
        ),
      ),
    );

    expect(find.text('Start camera'), findsOneWidget);
    expect(
      find.textContaining('session and secure upload API'),
      findsOneWidget,
    );
    expect(find.textContaining('verified'), findsNothing);
  });
}
