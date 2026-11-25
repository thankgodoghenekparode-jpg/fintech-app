import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yourapp_mobile/core/network/api_client.dart';
import 'package:yourapp_mobile/features/locator/data/locator_repository.dart';
import 'package:yourapp_mobile/features/locator/presentation/locator_screen.dart';

void main() {
  test('nearby search maps documented coordinates and proposed text query',
      () async {
    RequestOptions? request;
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test/api/v1/'))
      ..interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) {
          request = options;
          handler.resolve(Response<Map<String, dynamic>>(
            requestOptions: options,
            data: _agentResponse,
          ));
        },
      ));

    final result = await LocatorRepository(ApiClient(dio)).findAgents(
      latitude: 6.45,
      longitude: 3.42,
      query: 'Lekki Phase 1',
      radiusMeters: 2500,
    );

    expect(request!.path, 'agents/nearby');
    expect(request!.queryParameters, {
      'lat': '6.45',
      'lng': '3.42',
      'q': 'Lekki Phase 1',
      'radius': 2500,
    });
    expect(result.items.single.name, 'Sample Agent');
    expect(result.items.single.verified, isTrue);
  });

  test('rejects malformed agent coordinates', () {
    expect(
      () => LocatorAgent.fromJson({
        ..._agentResponse['items']!.first as Map<String, dynamic>,
        'latitude': 110,
      }),
      throwsFormatException,
    );
  });

  testWidgets('locator searches an area and displays returned agent data', (
    tester,
  ) async {
    final fake = _FakeLocatorRepository();
    await tester.pumpWidget(ProviderScope(
      overrides: [locatorRepositoryProvider.overrideWith((ref) => fake)],
      child: const MaterialApp(home: LocatorScreen()),
    ));

    await tester.enterText(find.byType(TextField), 'Lekki');
    await tester.tap(find.byTooltip('Search this area'));
    await tester.pumpAndSettle();

    expect(fake.lastQuery, 'Lekki');
    expect(find.text('Sample Agent'), findsOneWidget);
    expect(find.text('Sample Street, Lagos'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Branches are not listed yet'),
      350,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Branches are not listed yet'), findsOneWidget);
  });
}

const _agentResponse = <String, dynamic>{
  'searchArea': 'Lekki Phase 1',
  'radiusMeters': 2500,
  'items': [
    {
      'id': 'agent-1',
      'name': 'Sample Agent',
      'address': 'Sample Street, Lagos',
      'latitude': 6.45,
      'longitude': 3.42,
      'distanceMeters': 350,
      'verified': true,
      'services': ['CASH_IN', 'CASH_OUT'],
      'openingHours': 'Mon-Fri, 8am-5pm',
      'openNow': null,
    },
  ],
};

class _FakeLocatorRepository extends LocatorRepository {
  _FakeLocatorRepository() : super(ApiClient(Dio()));

  String? lastQuery;

  @override
  Future<NearbyAgents> findAgents({
    double? latitude,
    double? longitude,
    required int radiusMeters,
    String? query,
  }) async {
    lastQuery = query;
    return NearbyAgents.fromJson(_agentResponse);
  }
}
