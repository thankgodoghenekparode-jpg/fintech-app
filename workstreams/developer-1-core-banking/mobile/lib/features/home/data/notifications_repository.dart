import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';

final notificationsRepositoryProvider =
    Provider.autoDispose<NotificationsRepository>(
  (ref) => NotificationsRepository(ref.watch(apiClientProvider)),
);

class NotificationsRepository {
  const NotificationsRepository(this._api);

  final ApiClient _api;

  Future<NotificationPage> getNotifications({
    String? cursor,
    List<String>? categories,
  }) async {
    final response = await _api.dio.get<Map<String, dynamic>>(
      'notifications',
      queryParameters: {
        'limit': 20,
        if (cursor != null) 'cursor': cursor,
        if (categories != null && categories.isNotEmpty) 'category': categories,
      },
    );
    final json = response.data;
    if (json == null || json['items'] is! List || json['unreadCount'] is! int) {
      throw const MalformedNotificationDataException();
    }
    final items = (json['items'] as List).map((item) {
      if (item is! Map<String, dynamic>) {
        throw const MalformedNotificationDataException();
      }
      return BankNotification.fromJson(item);
    }).toList(growable: false);
    return NotificationPage(
      items: items,
      unreadCount: json['unreadCount'] as int,
      nextCursor: json['nextCursor'] as String?,
    );
  }

  Future<void> markRead(String id) async {
    await _api.dio.post<void>(
      'notifications/${Uri.encodeComponent(id)}/read',
    );
  }

  Future<void> markAllRead() async {
    await _api.dio.post<void>('notifications/read-all');
  }
}

class NotificationPage {
  const NotificationPage({
    required this.items,
    required this.unreadCount,
    required this.nextCursor,
  });

  final List<BankNotification> items;
  final int unreadCount;
  final String? nextCursor;
}

class BankNotification {
  const BankNotification({
    required this.id,
    required this.category,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.isRead,
    required this.destinationType,
    required this.resourceId,
  });

  final String id;
  final String category;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool isRead;
  final String destinationType;
  final String? resourceId;

  factory BankNotification.fromJson(Map<String, dynamic> json) {
    final destination = json['destination'];
    final createdAt = DateTime.tryParse(json['createdAt'] as String? ?? '');
    if (json['id'] is! String ||
        json['category'] is! String ||
        json['title'] is! String ||
        json['body'] is! String ||
        createdAt == null ||
        json['isRead'] is! bool ||
        destination is! Map<String, dynamic> ||
        destination['type'] is! String) {
      throw const MalformedNotificationDataException();
    }
    return BankNotification(
      id: json['id'] as String,
      category: json['category'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      createdAt: createdAt,
      isRead: json['isRead'] as bool,
      destinationType: destination['type'] as String,
      resourceId: destination['resourceId'] as String?,
    );
  }
}

class MalformedNotificationDataException implements Exception {
  const MalformedNotificationDataException();
}
