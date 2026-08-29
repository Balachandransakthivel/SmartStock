import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/network/api_client.dart';
import '../../../shared/models/models.dart';

part 'reorder_provider.g.dart';

@riverpod
class ReorderNotifier extends _$ReorderNotifier {
  final ApiClient _apiClient = ApiClient();

  @override
  FutureOr<ReorderListResponse> build() {
    _apiClient.initialize();
    return _fetchReorderRecommendations();
  }

  Future<ReorderListResponse> _fetchReorderRecommendations() async {
    try {
      final response = await _apiClient.dio.get('/reorder/recommendations');
      if (response.statusCode == 200) {
        return ReorderListResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load reorder recommendations');
      }
    } catch (e) {
      throw Exception('Failed to load reorder recommendations: $e');
    }
  }

  Future<ReorderSettings> getSettings() async {
    try {
      final response = await _apiClient.dio.get('/reorder/settings');
      if (response.statusCode == 200) {
        return ReorderSettings.fromJson(response.data);
      } else {
        throw Exception('Failed to load reorder settings');
      }
    } catch (e) {
      throw Exception('Failed to load reorder settings: $e');
    }
  }

  Future<void> updateSettings(ReorderSettingsUpdateRequest request) async {
    state = const AsyncLoading();
    try {
      final response = await _apiClient.dio.put('/reorder/settings', data: request.toJson());
      if (response.statusCode == 200) {
        ref.invalidateSelf();
      } else {
        throw Exception(response.data['message'] ?? 'Failed to update settings');
      }
    } catch (e) {
      throw Exception('Failed to update settings: $e');
    }
  }

  Future<ReorderRecommendation> createPurchaseFromReorder(String productId) async {
    state = const AsyncLoading();
    try {
      final response = await _apiClient.dio.post('/reorder/create-purchase', data: {'productId': productId});
      if (response.statusCode == 201) {
        ref.invalidateSelf();
        return ReorderRecommendation.fromJson(response.data['recommendation']);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to create purchase');
      }
    } catch (e) {
      throw Exception('Failed to create purchase: $e');
    }
  }
}

@riverpod
FutureOr<ReorderSettings> reorderSettings(Ref ref) {
  final notifier = ref.watch(reorderNotifierProvider.notifier);
  return notifier.getSettings();
}

@riverpod
FutureOr<ReorderListResponse> reorderRecommendations(Ref ref) {
  return ref.watch(reorderNotifierProvider.future);
}

@riverpod
class ProductSalesAnalyticsNotifier extends _$ProductSalesAnalyticsNotifier {
  final ApiClient _apiClient = ApiClient();

  @override
  FutureOr<ProductSalesAnalytics> build(String productId) {
    _apiClient.initialize();
    return _fetchProductAnalytics(productId);
  }

  Future<ProductSalesAnalytics> _fetchProductAnalytics(String productId) async {
    try {
      final response = await _apiClient.dio.get('/reorder/analytics/$productId');
      if (response.statusCode == 200) {
        return ProductSalesAnalytics.fromJson(response.data);
      } else {
        throw Exception('Failed to load product analytics');
      }
    } catch (e) {
      throw Exception('Failed to load product analytics: $e');
    }
  }
}

@riverpod
FutureOr<InventoryAnalytics> inventoryAnalytics(Ref ref) {
  final apiClient = ApiClient();
  apiClient.initialize();
  return _fetchInventoryAnalytics(apiClient);
}

Future<InventoryAnalytics> _fetchInventoryAnalytics(ApiClient apiClient) async {
  try {
    final response = await apiClient.dio.get('/analytics/inventory');
    if (response.statusCode == 200) {
      return InventoryAnalytics.fromJson(response.data);
    } else {
      throw Exception('Failed to load inventory analytics');
    }
  } catch (e) {
    throw Exception('Failed to load inventory analytics: $e');
  }
}

@riverpod
FutureOr<List<DeadStockProduct>> deadStockProducts(Ref ref) {
  final apiClient = ApiClient();
  apiClient.initialize();
  return _fetchDeadStockProducts(apiClient);
}

Future<List<DeadStockProduct>> _fetchDeadStockProducts(ApiClient apiClient) async {
  try {
    final response = await apiClient.dio.get('/analytics/dead-stock');
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data['products'] ?? response.data;
      return data.map((json) => DeadStockProduct.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load dead stock products');
    }
  } catch (e) {
    throw Exception('Failed to load dead stock products: $e');
  }
}

@riverpod
FutureOr<List<FastMovingProduct>> fastMovingProducts(Ref ref) {
  final apiClient = ApiClient();
  apiClient.initialize();
  return _fetchFastMovingProducts(apiClient);
}

Future<List<FastMovingProduct>> _fetchFastMovingProducts(ApiClient apiClient) async {
  try {
    final response = await apiClient.dio.get('/analytics/fast-moving');
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data['products'] ?? response.data;
      return data.map((json) => FastMovingProduct.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load fast moving products');
    }
  } catch (e) {
    throw Exception('Failed to load fast moving products: $e');
  }
}