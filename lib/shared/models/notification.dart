import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification.freezed.dart';
part 'notification.g.dart';

@freezed
class AppNotification with _$AppNotification {
  const factory AppNotification({
    required String id,
    required NotificationType type,
    required String title,
    required String message,
    String? referenceId,
    String? referenceType,
    required bool isRead,
    required DateTime createdAt,
    DateTime? readAt,
  }) = _AppNotification;

  factory AppNotification.fromJson(Map<String, dynamic> json) => _$AppNotificationFromJson(json);
}

enum NotificationType {
  lowStock,
  outOfStock,
  reorderRecommended,
  purchaseOrderReceived,
  purchaseOrderDelayed,
  saleCompleted,
  stockAdjusted,
  productExpiring,
  productExpired,
  systemAlert,
}

extension NotificationTypeExtension on NotificationType {
  String get displayName {
    switch (this) {
      case NotificationType.lowStock:
        return 'Low Stock';
      case NotificationType.outOfStock:
        return 'Out of Stock';
      case NotificationType.reorderRecommended:
        return 'Reorder Recommended';
      case NotificationType.purchaseOrderReceived:
        return 'Purchase Received';
      case NotificationType.purchaseOrderDelayed:
        return 'Purchase Delayed';
      case NotificationType.saleCompleted:
        return 'Sale Completed';
      case NotificationType.stockAdjusted:
        return 'Stock Adjusted';
      case NotificationType.productExpiring:
        return 'Expiring Soon';
      case NotificationType.productExpired:
        return 'Expired';
      case NotificationType.systemAlert:
        return 'System Alert';
    }
  }
  
  IconData get icon {
    switch (this) {
      case NotificationType.lowStock:
        return Icons.warning_amber_rounded;
      case NotificationType.outOfStock:
        return Icons.cancel_rounded;
      case NotificationType.reorderRecommended:
        return Icons.notification_important_rounded;
      case NotificationType.purchaseOrderReceived:
        return Icons.local_shipping_rounded;
      case NotificationType.purchaseOrderDelayed:
        return Icons.schedule_rounded;
      case NotificationType.saleCompleted:
        return Icons.point_of_sale_rounded;
      case NotificationType.stockAdjusted:
        return Icons.inventory_2_rounded;
      case NotificationType.productExpiring:
        return Icons.event_available_rounded;
      case NotificationType.productExpired:
        return Icons.event_busy_rounded;
      case NotificationType.systemAlert:
        return Icons.info_rounded;
    }
  }
  
  Color get color {
    switch (this) {
      case NotificationType.lowStock:
      case NotificationType.reorderRecommended:
      case NotificationType.productExpiring:
        return const Color(0xFFD97706);
      case NotificationType.outOfStock:
      case NotificationType.productExpired:
        return const Color(0xFFDC2626);
      case NotificationType.purchaseOrderReceived:
      case NotificationType.saleCompleted:
        return const Color(0xFF059669);
      case NotificationType.purchaseOrderDelayed:
        return const Color(0xFF2563EB);
      case NotificationType.stockAdjusted:
        return const Color(0xFF6366F1);
      case NotificationType.systemAlert:
        return const Color(0xFF64748B);
    }
  }
}

@freezed
class NotificationListParams with _$NotificationListParams {
  const factory NotificationListParams({
    int? page,
    int? limit,
    bool? unreadOnly,
    NotificationType? type,
    DateTime? fromDate,
    DateTime? toDate,
  }) = _NotificationListParams;

  factory NotificationListParams.fromJson(Map<String, dynamic> json) => _$NotificationListParamsFromJson(json);
}

@freezed
class NotificationListResponse with _$NotificationListResponse {
  const factory NotificationListResponse({
    required List<AppNotification> notifications,
    required int total,
    required int unreadCount,
    required int page,
    required int limit,
    required int totalPages,
  }) = _NotificationListResponse;

  factory NotificationListResponse.fromJson(Map<String, dynamic> json) => _$NotificationListResponseFromJson(json);
}