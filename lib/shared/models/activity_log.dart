import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity_log.freezed.dart';
part 'activity_log.g.dart';

@freezed
class ActivityLog with _$ActivityLog {
  const factory ActivityLog({
    required String id,
    required String userId,
    required String userName,
    required ActivityAction action,
    required String entityType,
    required String entityId,
    String? entityName,
    Map<String, dynamic>? oldValues,
    Map<String, dynamic>? newValues,
    String? description,
    String? ipAddress,
    String? userAgent,
    required DateTime createdAt,
  }) = _ActivityLog;

  factory ActivityLog.fromJson(Map<String, dynamic> json) => _$ActivityLogFromJson(json);
}

enum ActivityAction {
  created,
  updated,
  deleted,
  stockIn,
  stockOut,
  purchaseCreated,
  purchaseReceived,
  purchaseCancelled,
  saleCompleted,
  saleCancelled,
  reorderCreated,
  settingsChanged,
  userCreated,
  userUpdated,
  login,
  logout,
}

extension ActivityActionExtension on ActivityAction {
  String get displayName {
    switch (this) {
      case ActivityAction.created:
        return 'Created';
      case ActivityAction.updated:
        return 'Updated';
      case ActivityAction.deleted:
        return 'Deleted';
      case ActivityAction.stockIn:
        return 'Stock In';
      case ActivityAction.stockOut:
        return 'Stock Out';
      case ActivityAction.purchaseCreated:
        return 'Purchase Created';
      case ActivityAction.purchaseReceived:
        return 'Purchase Received';
      case ActivityAction.purchaseCancelled:
        return 'Purchase Cancelled';
      case ActivityAction.saleCompleted:
        return 'Sale Completed';
      case ActivityAction.saleCancelled:
        return 'Sale Cancelled';
      case ActivityAction.reorderCreated:
        return 'Reorder Created';
      case ActivityAction.settingsChanged:
        return 'Settings Changed';
      case ActivityAction.userCreated:
        return 'User Created';
      case ActivityAction.userUpdated:
        return 'User Updated';
      case ActivityAction.login:
        return 'Login';
      case ActivityAction.logout:
        return 'Logout';
    }
  }
  
  IconData get icon {
    switch (this) {
      case ActivityAction.created:
      case ActivityAction.userCreated:
        return Icons.add_circle_rounded;
      case ActivityAction.updated:
      case ActivityAction.userUpdated:
      case ActivityAction.settingsChanged:
        return Icons.edit_rounded;
      case ActivityAction.deleted:
        return Icons.delete_rounded;
      case ActivityAction.stockIn:
        return Icons.add_circle_outline_rounded;
      case ActivityAction.stockOut:
        return Icons.remove_circle_outline_rounded;
      case ActivityAction.purchaseCreated:
        return Icons.shopping_cart_rounded;
      case ActivityAction.purchaseReceived:
        return Icons.local_shipping_rounded;
      case ActivityAction.purchaseCancelled:
        return Icons.cancel_rounded;
      case ActivityAction.saleCompleted:
        return Icons.point_of_sale_rounded;
      case ActivityAction.saleCancelled:
        return Icons.cancel_outlined;
      case ActivityAction.reorderCreated:
        return Icons.notification_important_rounded;
      case ActivityAction.login:
        return Icons.login_rounded;
      case ActivityAction.logout:
        return Icons.logout_rounded;
    }
  }
  
  Color get color {
    switch (this) {
      case ActivityAction.created:
      case ActivityAction.userCreated:
      case ActivityAction.stockIn:
      case ActivityAction.purchaseReceived:
      case ActivityAction.saleCompleted:
        return const Color(0xFF059669);
      case ActivityAction.updated:
      case ActivityAction.userUpdated:
      case ActivityAction.settingsChanged:
      case ActivityAction.purchaseCreated:
        return const Color(0xFF2563EB);
      case ActivityAction.deleted:
      case ActivityAction.purchaseCancelled:
      case ActivityAction.saleCancelled:
        return const Color(0xFFDC2626);
      case ActivityAction.stockOut:
        return const Color(0xFFD97706);
      case ActivityAction.reorderCreated:
        return const Color(0xFF6366F1);
      case ActivityAction.login:
        return const Color(0xFF059669);
      case ActivityAction.logout:
        return const Color(0xFF64748B);
    }
  }
}

@freezed
class ActivityLogListParams with _$ActivityLogListParams {
  const factory ActivityLogListParams({
    int? page,
    int? limit,
    String? userId,
    ActivityAction? action,
    String? entityType,
    DateTime? fromDate,
    DateTime? toDate,
  }) = _ActivityLogListParams;

  factory ActivityLogListParams.fromJson(Map<String, dynamic> json) => _$ActivityLogListParamsFromJson(json);
}

@freezed
class ActivityLogListResponse with _$ActivityLogListResponse {
  const factory ActivityLogListResponse({
    required List<ActivityLog> logs,
    required int total,
    required int page,
    required int limit,
    required int totalPages,
  }) = _ActivityLogListResponse;

  factory ActivityLogListResponse.fromJson(Map<String, dynamic> json) => _$ActivityLogListResponseFromJson(json);
}