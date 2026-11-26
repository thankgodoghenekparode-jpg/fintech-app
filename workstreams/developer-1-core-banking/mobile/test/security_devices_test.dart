import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yourapp_mobile/core/network/api_client.dart';
import 'package:yourapp_mobile/features/home/data/home_repository.dart';
import 'package:yourapp_mobile/features/security/data/security_devices_repository.dart';
import 'package:yourapp_mobile/features/security/presentation/security_devices_screen.dart';

void main() {
  test('device list maps the proposed privacy-limited response fields',
      () async {
    RequestOptions? request;
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test/api/v1/'));
    final client = ApiClient.withTokenReader(
      dio,
      (key) async => key == 'session.access_token' ? 'access-token' : null,
    );
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      request = options;
      handler.resolve(Response<Map<String, dynamic>>(
        requestOptions: options,
        data: {
          'items': [
            _deviceJson(id: _currentId, name: 'This phone', isCurrent: true),
            _deviceJson(id: _otherId, name: 'Web browser', isCurrent: false),
          ],
        },
      ));
    }));

    final devices = await SecurityDevicesRepository(client).listDevices();

    expect(request!.method, 'GET');
    expect(request!.path, 'security/devices');
    expect(request!.headers['Authorization'], 'Bearer access-token');
    expect(devices, hasLength(2));
    expect(devices.first.isCurrent, isTrue);
    expect(devices.last.approximateLocation, 'Lagos area');
    expect(devices.last.lastUsedAt, DateTime.utc(2026, 11, 25, 16));
  });

  test('device removal uses the documented ID path and proposed PIN header',
      () async {
    RequestOptions? request;
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test/api/v1/'));
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      request = options;
      handler.resolve(Response<void>(
        requestOptions: options,
        statusCode: 204,
      ));
    }));

    await SecurityDevicesRepository(ApiClient(dio)).removeDevice(
      id: _otherId,
      pinToken: 'one-use-token',
    );

    expect(request!.method, 'DELETE');
    expect(request!.path, 'security/devices/$_otherId');
    expect(request!.headers['X-Pin-Token'], 'one-use-token');
    expect(request!.data, isNull);
  });

  test('malformed device identifiers and unsafe display fields are rejected',
      () {
    expect(
      () => SecurityDevice.fromJson(_deviceJson(
        id: 'not-a-uuid',
        name: 'Phone',
        isCurrent: false,
      )),
      throwsFormatException,
    );
    expect(
      () => SecurityDevice.fromJson(_deviceJson(
        id: _otherId,
        name: List.filled(81, 'x').join(),
        isCurrent: false,
      )),
      throwsFormatException,
    );
  });

  testWidgets('device removal confirms and verifies PIN before DELETE',
      (tester) async {
    final devices = _FakeSecurityDevicesRepository();
    final home = _FakeHomeRepository();
    await tester.pumpWidget(ProviderScope(
      overrides: [
        securityDevicesProvider.overrideWith((ref) async => [
              SecurityDevice.fromJson(_deviceJson(
                id: _currentId,
                name: 'Current phone',
                isCurrent: true,
              )),
              SecurityDevice.fromJson(_deviceJson(
                id: _otherId,
                name: 'Old browser',
                isCurrent: false,
              )),
            ]),
        securityDevicesRepositoryProvider.overrideWith((ref) => devices),
        homeRepositoryProvider.overrideWith((ref) => home),
      ],
      child: const MaterialApp(home: SecurityDevicesScreen()),
    ));
    await tester.pumpAndSettle();

    expect(find.text('Current phone'), findsOneWidget);
    expect(find.text('This device cannot be removed here.'), findsOneWidget);
    final removeButton = find.text('Remove device');
    await tester.ensureVisible(removeButton);
    await tester.pumpAndSettle();
    await tester.tap(removeButton);
    await tester.pumpAndSettle();
    expect(find.text('Remove this device?'), findsOneWidget);
    expect(devices.removedId, isNull);

    await tester.tap(find.text('Continue to PIN'));
    await tester.pumpAndSettle();
    for (final digit in ['1', '2', '3', '4']) {
      await tester.tap(find.text(digit).last);
    }
    await tester.pumpAndSettle();
    await tester.tap(find.text('Remove device').last);
    await tester.pumpAndSettle();

    expect(home.verifiedPin, '1234');
    expect(devices.removedId, _otherId);
    expect(devices.pinToken, 'verified-one-use-token');
  });

  testWidgets('demo devices are labeled samples and cannot be removed',
      (tester) async {
    await tester.pumpWidget(const ProviderScope(
      child: MaterialApp(
        home: SecurityDevicesScreen(previewOnly: true),
      ),
    ));
    await tester.pumpAndSettle();

    expect(find.text('Demo preview — sample devices'), findsOneWidget);
    expect(find.text('This phone (sample)'), findsOneWidget);
    expect(find.text('Preview only').last, findsOneWidget);
    expect(
      tester
          .widget<TextButton>(find.widgetWithText(TextButton, 'Preview only'))
          .onPressed,
      isNull,
    );
  });
}

const _currentId = '20000000-0000-4000-8000-000000000001';
const _otherId = '20000000-0000-4000-8000-000000000002';

Map<String, dynamic> _deviceJson({
  required String id,
  required String name,
  required bool isCurrent,
}) =>
    {
      'id': id,
      'name': name,
      'isCurrent': isCurrent,
      'platform': 'Android',
      'appVersion': '1.0.0',
      'lastUsedAt': '2026-11-25T16:00:00Z',
      'approximateLocation': 'Lagos area',
    };

class _FakeSecurityDevicesRepository extends SecurityDevicesRepository {
  _FakeSecurityDevicesRepository() : super(ApiClient(Dio()));

  String? removedId;
  String? pinToken;

  @override
  Future<void> removeDevice(
      {required String id, required String pinToken}) async {
    removedId = id;
    this.pinToken = pinToken;
  }
}

class _FakeHomeRepository extends HomeRepository {
  _FakeHomeRepository() : super(ApiClient(Dio()));

  String? verifiedPin;

  @override
  Future<String> verifyTransactionPin(String pin) async {
    verifiedPin = pin;
    return 'verified-one-use-token';
  }
}
