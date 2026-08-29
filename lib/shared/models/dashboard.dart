import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard.freezed.dart';
part 'dashboard.g.dart';

@freezed
class DashboardStats with _$DashboardStats {
  const factory DashboardStats({
    required int totalProducts,
    required int lowStockCount,
    required int outOfStockCount,
    required double totalStockValue,
    required double totalCostValue,
    required int totalSuppliers,
    required int pendingPurchases,
    required int todaySales,
    required double todayRevenue,
    required int thisMonthSales,
    required double thisMonthRevenue,
    required List<DailySalesData> salesLast7Days,
    required List<DailyPurchaseData> purchasesLast7Days,
    required List<TopProductData> topProducts,
    required List<StockMovementSummary> recentActivity,
  }) = _DashboardStats;

  factory DashboardStats.fromJson(Map<String, dynamic> json) => _$DashboardStatsFromJson(json);
}

@freezed
class DailySalesData with _$DailySalesData {
  const factory DailySalesData({
    required String date,
    required double revenue,
    required int count,
  }) = _DailySalesData;

  factory DailySalesData.fromJson(Map<String, dynamic> json) => _$DailySalesDataFromJson(json);
}

@freezed
class DailyPurchaseData with _$DailyPurchaseData {
  const factory DailyPurchaseData({
    required String date,
    required double amount,
    required int count,
  }) = _DailyPurchaseData;

  factory DailyPurchaseData.fromJson(Map<String, dynamic> json) => _$DailyPurchaseDataFromJson(json);
}

@freezed
class TopProductData with _$TopProductData {
  const factory TopProductData({
    required String productId,
    required String productName,
    required String sku,
    required int quantitySold,
    required double revenue,
    required int currentStock,
  }) = _TopProductData;

  factory TopProductData.fromJson(Map<String, dynamic> json) => _$TopProductDataFromJson(json);
}

@freezed
class StockMovementSummary with _$StockMovementSummary {
  const factory StockMovementSummary({
    required String id,
    required String productName,
    required String sku,
    required String action,
    required int quantity,
    required String userName,
    required DateTime timestamp,
  }) = _StockMovementSummary;

  factory StockMovementSummary.fromJson(Map<String, dynamic> json) => _$StockMovementSummaryFromJson(json);
}

@freezed
class ManagerDashboardStats with _$ManagerDashboardStats {
  const factory ManagerDashboardStats({
    required int totalProducts,
    required int lowStockCount,
    required int outOfStockCount,
    required double totalStockValue,
    required int pendingPurchases,
    required int todaySales,
    required double todayRevenue,
    required List<DailySalesData> salesLast7Days,
    required List<ReorderSummary> reorderSummary,
    required List<StockMovementSummary> recentActivity,
  }) = _ManagerDashboardStats;

  factory ManagerDashboardStats.fromJson(Map<String, dynamic> json) => _$ManagerDashboardStatsFromJson(json);
}

@freezed
class StaffDashboardStats with _$StaffDashboardStats {
  const factory StaffDashboardStats({
    required int assignedProducts,
    required int lowStockProducts,
    required int tasksCount,
    required List<StockMovementSummary> recentActivity,
    required List<QuickAction> quickActions,
  }) = _StaffDashboardStats;

  factory StaffDashboardStats.fromJson(Map<String, dynamic> json) => _$StaffDashboardStatsFromJson(json);
}

@freezed
class ReorderSummary with _$ReorderSummary {
  const factory ReorderSummary({
    required int totalNeedingAttention,
    required int critical,
    required int soon,
    required int normal,
  }) = _ReorderSummary;

  factory ReorderSummary.fromJson(Map<String, dynamic> json) => _$ReorderSummaryFromJson(json);
}

@freezed
class QuickAction with _$QuickAction {
  const factory QuickAction({
    required String id,
    required String label,
    required IconData icon,
    required String route,
    required bool isEnabled,
  }) = _QuickAction;

  factory QuickAction.fromJson(Map<String, dynamic> json) => _$QuickActionFromJson(json);
}