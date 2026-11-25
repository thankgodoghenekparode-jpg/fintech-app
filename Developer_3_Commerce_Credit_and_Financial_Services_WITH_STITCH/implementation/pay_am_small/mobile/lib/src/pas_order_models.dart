import 'package:flutter/widgets.dart';

enum PasOrderTimelineState { complete, current, upcoming }

class PasOrderTimelineEntry {
  const PasOrderTimelineEntry({
    required this.title,
    required this.state,
    this.detail,
    this.dateLabel,
  });

  final String title;
  final String? detail;
  final String? dateLabel;
  final PasOrderTimelineState state;
}

/// Host-mapped display data for GET `/pas/orders/{orderId}`.
/// Optional fields are omitted when the host cannot map a confirmed API value.
class PasOrderTrackingData {
  const PasOrderTrackingData({
    required this.orderId,
    required this.timeline,
    this.statusLabel,
    this.statusDetail,
    this.estimatedDeliveryLabel,
    this.delayedNotice,
    this.deliveryCode,
    this.deliveryCodeInstruction,
    this.productTitle,
    this.productPriceLabel,
    this.productImage,
    this.vendorName,
    this.vendorContactLabel,
    this.deliveryAddress,
    this.planId,
  });

  final String orderId;
  final String? statusLabel;
  final String? statusDetail;
  final String? estimatedDeliveryLabel;
  final String? delayedNotice;
  final String? deliveryCode;
  final String? deliveryCodeInstruction;
  final String? productTitle;
  final String? productPriceLabel;
  final ImageProvider? productImage;
  final String? vendorName;
  final String? vendorContactLabel;
  final String? deliveryAddress;
  final String? planId;
  final List<PasOrderTimelineEntry> timeline;
}

abstract interface class PayAmSmallOrderTrackingAdapter {
  /// Host maps GET `/pas/orders/{orderId}` to display data. The API does not
  /// define its 200 response schema.
  Future<PasOrderTrackingData?> loadOrder(String orderId);
}
