import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';

final locatorRepositoryProvider = Provider.autoDispose<LocatorRepository>(
  (ref) => LocatorRepository(ref.watch(apiClientProvider)),
);

class LocatorRepository {
  LocatorRepository(this._client);

  final ApiClient _client;

  Future<NearbyAgents> findAgents({
    double? latitude,
    double? longitude,
    required int radiusMeters,
    String? query,
  }) async {
    final normalizedQuery = query?.trim();
    if ((latitude == null) != (longitude == null) ||
        (latitude == null &&
            (normalizedQuery == null || normalizedQuery.isEmpty))) {
      throw const LocatorInputException();
    }
    final parameters = <String, Object>{'radius': radiusMeters};
    if (latitude != null && longitude != null) {
      parameters['lat'] = latitude.toString();
      parameters['lng'] = longitude.toString();
    }
    if (normalizedQuery != null && normalizedQuery.isNotEmpty) {
      parameters['q'] = normalizedQuery;
    }
    try {
      final response = await _client.dio.get<Map<String, dynamic>>(
        'agents/nearby',
        queryParameters: parameters,
      );
      return NearbyAgents.fromJson(response.data);
    } on DioException {
      rethrow;
    } on FormatException {
      rethrow;
    } catch (error) {
      throw LocatorResponseException(error);
    }
  }
}

class NearbyAgents {
  const NearbyAgents({
    required this.items,
    this.searchArea,
    required this.radiusMeters,
  });

  final List<LocatorAgent> items;
  final String? searchArea;
  final int radiusMeters;

  factory NearbyAgents.fromJson(Map<String, dynamic>? json) {
    final items = json?['items'];
    final radius = json?['radiusMeters'];
    if (json == null || items is! List || radius is! num) {
      throw const FormatException('Nearby agent response is malformed.');
    }
    final area = json['searchArea'];
    return NearbyAgents(
      items: items.map((item) {
        if (item is! Map<String, dynamic>) {
          throw const FormatException('Nearby agent item is malformed.');
        }
        return LocatorAgent.fromJson(item);
      }).toList(growable: false),
      searchArea: area is String && area.isNotEmpty ? area : null,
      radiusMeters: radius.toInt(),
    );
  }
}

class LocatorAgent {
  const LocatorAgent({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.distanceMeters,
    required this.verified,
    required this.services,
    required this.openingHours,
    this.openNow,
  });

  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final int distanceMeters;
  final bool verified;
  final List<String> services;
  final String? openingHours;
  final bool? openNow;

  factory LocatorAgent.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final name = json['name'];
    final address = json['address'];
    final latitude = json['latitude'];
    final longitude = json['longitude'];
    final distance = json['distanceMeters'];
    final verified = json['verified'];
    final services = json['services'];
    final hours = json['openingHours'];
    final openNow = json['openNow'];
    if (id is! String ||
        id.isEmpty ||
        name is! String ||
        name.isEmpty ||
        address is! String ||
        address.isEmpty ||
        latitude is! num ||
        longitude is! num ||
        latitude < -90 ||
        latitude > 90 ||
        longitude < -180 ||
        longitude > 180 ||
        distance is! num ||
        distance < 0 ||
        verified is! bool ||
        services is! List ||
        services.any((service) => service is! String) ||
        (hours != null && hours is! String) ||
        (openNow != null && openNow is! bool)) {
      throw const FormatException('Nearby agent item is malformed.');
    }
    return LocatorAgent(
      id: id,
      name: name,
      address: address,
      latitude: latitude.toDouble(),
      longitude: longitude.toDouble(),
      distanceMeters: distance.toInt(),
      verified: verified,
      services: services.cast<String>(),
      openingHours: hours as String?,
      openNow: openNow as bool?,
    );
  }
}

class LocatorInputException implements Exception {
  const LocatorInputException();
}

class LocatorResponseException implements Exception {
  const LocatorResponseException(this.cause);
  final Object cause;
}
