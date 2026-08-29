import 'package:freezed_annotation/freezed_annotation.dart';
import '../constants/app_constants.dart';

part 'reorder.freezed.dart';
part 'reorder.g.dart';

@freezed
class ReorderRecommendation with _$ReorderRecommendation {
  const factory ReorderRecommendation({
    required String productId,
    required String productName,
    required String sku,
    required int currentStock,
    required int minimumStock,
    required int maximumStock,
    required int reorderPoint,
    required int suggestedOrderQuantity,
    required double averageDailySales,
    required int estimatedDaysRemaining,
    required int supplierLeadTimeDays,
    required int safetyStock,
    required ReorderUrgency urgency,
    String? supplierId,
    String? supplierName,
    double? estimatedCost,
  }) = _ReorderRecommendation;

  factory ReorderRecommendation.fromJson(Map<String, dynamic> json) => _$ReorderRecommendationFromJson(json);
}

@freezed
class ReorderSettings with _$ReorderSettings {
  const factory ReorderSettings({
    int? defaultLeadTimeDays,
    int? defaultSafetyStockDays,
    int? lowStockAlertDays,
    int? deadStockAlertDays,
    bool? autoCalculateReorderPoint,
    bool? enableNotifications,
  }) = _ReorderSettings;

  factory ReorderSettings.fromJson(Map<String, dynamic> json) => _$ReorderSettingsFromJson(json);
}

@freezed
class ReorderSettingsUpdateRequest with _$ReorderSettingsUpdateRequest {
  const factory ReorderSettingsUpdateRequest({
    int? defaultLeadTimeDays,
    int? defaultSafetyStockDays,
    int? lowStockAlertDays,
    int? deadStockAlertDays,
    bool? autoCalculateReorderPoint,
    bool? enableNotifications,
  }) = _ReorderSettingsUpdateRequest;

  factory ReorderSettingsUpdateRequest.fromJson(Map<String, dynamic> json) => _$ReorderSettingsUpdateRequestFromJson(json);
}

enum ReorderUrgency { normal, soon, critical }

extension ReorderUrgencyExtension on ReorderUrgency {
  String get displayName {
    switch (this) {
      case ReorderUrgency.normal:
        return 'Normal';
      case ReorderUrgency.soon:
        return 'Soon';
      case ReorderUrgency.critical:
        return 'Critical';
    }
  }
  
  Color get color {
    switch (this) {
      case ReorderUrgency.normal:
        return const Color(0xFF059669);
      case ReorderUrgency.soon:
        return const Color(0xFFD97706);
      case ReorderUrgency.critical:
        return const Color(0xFFDC2626);
    }
  }
  
  IconData get icon {
    switch (this) {
      case ReorderUrgency.normal:
        return Icons.check_circle;
      case ReorderUrgency.soon:
        return Icons.schedule;
      case ReorderUrgency.critical:
        return Icons.warning;
    }
  }
}

@freezed
class ReorderListResponse with _$ReorderListResponse {
  const factory ReorderListResponse({
    required List<ReorderRecommendation> recommendations,
    required int totalProductsNeedingAttention,
    required int criticalCount,
    required int soonCount,
    required int normalCount,
  }) = _ReorderListResponse;

  factory ReorderListResponse.fromJson(Map<String, dynamic> json) => _$ReorderListResponseFromJson(json);
}

@freezed
class ProductSalesAnalytics with _$ProductSalesAnalytics {
  const factory ProductSalesAnalytics({
    required String productId,
    required String productName,
    required String sku,
    required int totalSoldLast30Days,
    required int totalSoldLast7Days,
    required double averageDailySales,
    required double averageDailySales7Days,
    required double averageDailySales30Days,
    required int currentStock,
    required int minimumStock,
    required int maximumStock,
    required int reorderPoint,
    required int estimatedDaysRemaining,
    required ReorderUrgency urgency,
    required List<DailySalesPoint> dailySales,
  }) = _ProductSalesAnalytics;

  factory ProductSalesAnalytics.fromJson(Map<String, dynamic> json) => _$ProductSalesAnalyticsFromJson(json);
}

@freezed
class DailySalesPoint with _$DailySalesPoint {
  const factory DailySalesPoint({
    required String date,
    required int quantity,
    required double revenue,
  }) = _DailySalesPoint;

  factory DailySalesPoint.fromJson(Map<String, dynamic> json) => _$DailySalesPointFromJson(json);
}

@freezed
class InventoryAnalytics with _$InventoryAnalytics {
  const factory InventoryAnalytics({
    required int totalProducts,
    required int totalStockValue,
    required int lowStockCount,
    required int outOfStockCount,
    required int healthyStockCount,
    required double totalCostValue,
    required double totalSellValue,
    required List<CategoryStockData> categoryBreakdown,
    required List<StockMovementSummary> recentMovements,
  }) = _InventoryAnalytics;

  factory InventoryAnalytics.fromJson(Map<String, dynamic> json) => _$InventoryAnalyticsFromJson(json);
}

@freezed
class CategoryStockData with _$CategoryStockData {
  const factory CategoryStockData({
    required String categoryId,
    required String categoryName,
    required int productCount,
    required int totalStock,
    required double stockValue,
    required int lowStockCount,
    required int outOfStockCount,
  }) = _CategoryStockData;

  factory CategoryStockData.fromJson(Map<String, dynamic> json) => _$CategoryStockDataFromJson(json);
}

@freezed
class StockMovementSummary with _$StockMovementSummary {
  const factory StockMovementSummary({
    required String date,
    required int stockIn,
    required int stockOut,
    required int netChange,
  }) = _StockMovementSummary;

  factory StockMovementSummary.fromJson(Map<String, dynamic> json) => _$StockMovementSummaryFromJson(json);
}

@freezed
class DeadStockProduct with _$DeadStockProduct {
  const factory DeadStockProduct({
    required String productId,
    required String productName,
    required String sku,
    required int currentStock,
    required double stockValue,
    required int daysSinceLastSale,
    required DateTime? lastSaleDate,
    required double sellingPrice,
  }) = _DeadStockProduct;

  factory DeadStockProduct.fromJson(Map<String, dynamic> json) => _$DeadStockProductFromJson(json);
}

@freezed
class FastMovingProduct with _$FastMovingProduct {
  const factory FastMovingProduct({
    required String productId,
    required String productName,
    required String sku,
    required int quantitySold,
    required double revenue,
    required int currentStock,
    required int daysOfStockRemaining,
  }) = _FastMovingProduct;

  factory FastMovingProduct.fromJson(Map<String, dynamic> json) => _$FastMovingProductFromJson(json);
}