import 'package:material_ui/material_ui.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:yourapp_mobile/core/network/api_client.dart';
import 'package:yourapp_mobile/features/support/data/support_repository.dart';
import 'package:yourapp_mobile/features/support/presentation/support_screens.dart';
import 'package:yourapp_mobile/l10n/app_localizations.dart';

void main() {
  testWidgets('support chat creates a ticket and sends through its thread', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final calls = <String>[];
    final messages = <Map<String, dynamic>>[];
    final now = DateTime(2026, 11, 24, 10).toUtc().toIso8601String();
    Map<String, dynamic> ticketDetail() => {
          'id': 'ticket-chat-1',
          'category': 'OTHER',
          'subject': 'Other support request',
          'status': 'OPEN',
          'createdAt': now,
          'updatedAt': now,
          'messages': messages,
        };

    final dio = Dio(BaseOptions(baseUrl: 'https://example.test/api/v1/'))
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            calls.add('${options.method} ${options.path}');
            if (options.method == 'POST' && options.path == 'tickets') {
              final description = (options.data
                  as Map<String, dynamic>)['description'] as String;
              messages.add({
                'id': 'message-1',
                'authorType': 'CUSTOMER',
                'body': description,
                'createdAt': now,
              });
              handler.resolve(
                Response<Map<String, dynamic>>(
                  requestOptions: options,
                  statusCode: 201,
                  data: {
                    'id': 'ticket-chat-1',
                    'category': 'OTHER',
                    'subject': 'Other support request',
                    'status': 'OPEN',
                    'createdAt': now,
                    'updatedAt': now,
                  },
                ),
              );
              return;
            }
            if (options.method == 'GET' &&
                options.path == 'tickets/ticket-chat-1') {
              handler.resolve(
                Response<Map<String, dynamic>>(
                  requestOptions: options,
                  data: ticketDetail(),
                ),
              );
              return;
            }
            if (options.method == 'POST' &&
                options.path == 'tickets/ticket-chat-1/messages') {
              final body =
                  (options.data as Map<String, dynamic>)['body'] as String;
              final message = {
                'id': 'message-${messages.length + 1}',
                'authorType': 'CUSTOMER',
                'body': body,
                'createdAt': now,
              };
              messages.add(message);
              handler.resolve(
                Response<Map<String, dynamic>>(
                  requestOptions: options,
                  statusCode: 201,
                  data: message,
                ),
              );
              return;
            }
            handler.reject(
              DioException(
                requestOptions: options,
                message: 'Unexpected support operation',
              ),
            );
          },
        ),
      );
    final repository = SupportRepository(ApiClient(dio));
    final router = GoRouter(
      initialLocation: '/help',
      routes: [
        GoRoute(
          path: '/help',
          builder: (context, state) => const HelpCentreScreen(),
        ),
        GoRoute(
          path: '/help/chat',
          builder: (context, state) =>
              const NewSupportTicketScreen(chatMode: true),
        ),
        GoRoute(
          path: '/help/chat/:id',
          builder: (context, state) => SupportTicketDetailScreen(
            ticketId: state.pathParameters['id']!,
            chatMode: true,
          ),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          supportRepositoryProvider.overrideWithValue(repository),
        ],
        child: MaterialApp.router(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.drag(find.byType(ListView), const Offset(0, -700));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Start a support conversation'));
    await tester.pumpAndSettle();

    expect(
        find.text(
            'Replies use the support ticket service and are handled asynchronously. Agent availability and response times are not provided.'),
        findsOneWidget);
    expect(
        find.text('Attachments are not supported by the current ticket API.'),
        findsOneWidget);
    await tester.enterText(
      find.byType(TextField),
      'I need help with a transaction.',
    );
    await tester.tap(find.text('Start conversation'));
    await tester.pumpAndSettle();

    expect(find.text('Support team'), findsOneWidget);
    expect(find.text('I need help with a transaction.'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Please review this issue.');
    await tester.tap(find.byTooltip('Send reply'));
    await tester.pumpAndSettle();

    expect(find.text('Please review this issue.'), findsOneWidget);
    expect(calls, [
      'POST tickets',
      'GET tickets/ticket-chat-1',
      'POST tickets/ticket-chat-1/messages',
      'GET tickets/ticket-chat-1',
    ]);
    expect(tester.takeException(), isNull);
  });
}
