import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';

final securityDevicesRepositoryProvider =
    Provider.autoDispose<SecurityDevicesRepository>(
  (ref) => SecurityDevicesRepository(ref.watch(apiClientProvider)),
);

final securityDevicesProvider =
    FutureProvider.autoDispose<List<SecurityDevice>>(
  (ref) => ref.watch(securityDevicesRepositoryProvider).listDevices(),
);

class SecurityDevicesRepository {
  const SecurityDevicesRepository(this._client);

  final ApiClient _client;

  Future<List<SecurityDevice>> listDevices() async {
    final response = await _client.dio.get<Map<String, dynamic>>(
      'security/devices',
    );
    final items = response.data?['items'];
    if (items is! List || items.any((item) => item is! Map<String, dynamic>)) {
      throw const FormatException('Device list response is malformed.');
    }
    final devices = items
        .cast<Map<String, dynamic>>()
        .map(SecurityDevice.fromJson)
        .toList(growable: false);
    final ids = devices.map((device) => device.id).toSet();
    final currentCount = devices.where((device) => device.isCurrent).length;
    if (ids.length != devices.length ||
        (devices.isNotEmpty && currentCount != 1)) {
      throw const FormatException('Device list response is inconsistent.');
    }
    return devices;
  }

  Future<void> removeDevice({
    required String id,
    required String pinToken,
  }) async {
    await _client.dio.delete<void>(
      'security/devices/${Uri.encodeComponent(id)}',
      options: Options(headers: {'X-Pin-Token': pinToken}),
    );
  }
}

class SecurityDevice {
  const SecurityDevice({
    required this.id,
    required this.name,
    required this.isCurrent,
    this.platform,
    this.appVersion,
    this.lastUsedAt,
    this.approximateLocation,
  });

  final String id;
  final String name;
  final bool isCurrent;
  final String? platform;
  final String? appVersion;
  final DateTime? lastUsedAt;
  final String? approximateLocation;

  factory SecurityDevice.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final name = _safeLabel(json['name'], maxLength: 80);
    final current = json['isCurrent'];
    final platform = _optionalLabel(json['platform'], maxLength: 40);
    final appVersion = _optionalLabel(json['appVersion'], maxLength: 30);
    final location = _optionalLabel(
      json['approximateLocation'],
      maxLength: 120,
    );
    final lastUsedRaw = json['lastUsedAt'];
    final lastUsed =
        lastUsedRaw is String ? DateTime.tryParse(lastUsedRaw)?.toUtc() : null;
    if (id is! String ||
        !_uuid.hasMatch(id) ||
        name == null ||
        current is! bool ||
        (json['platform'] != null && platform == null) ||
        (json['appVersion'] != null && appVersion == null) ||
        (json['approximateLocation'] != null && location == null) ||
        (lastUsedRaw != null && lastUsed == null)) {
      throw const FormatException('Device entry is malformed.');
    }
    return SecurityDevice(
      id: id,
      name: name,
      isCurrent: current,
      platform: platform,
      appVersion: appVersion,
      lastUsedAt: lastUsed,
      approximateLocation: location,
    );
  }

  static final _uuid = RegExp(
    r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-8][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$',
  );

  static String? _safeLabel(Object? value, {required int maxLength}) {
    final text = _optionalLabel(value, maxLength: maxLength);
    return text?.isNotEmpty == true ? text : null;
  }

  static String? _optionalLabel(Object? value, {required int maxLength}) {
    if (value == null) return null;
    if (value is! String || value.length > maxLength) return null;
    final sanitized =
        value.replaceAll(RegExp(r'[\u0000-\u001F\u007F]'), ' ').trim();
    return sanitized.isEmpty ? null : sanitized;
  }
}
