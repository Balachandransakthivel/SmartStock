import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/network/api_client.dart';
import '../../../shared/models/models.dart';

part 'purchase_provider.g.dart';

@riverpod
class PurchaseNotifier extends _$PurchaseNotifier {
  final ApiClient _apiClient = ApiClient();

  @override
  FutureOr<PurchaseListResponse> build(PurchaseListParams params) {
    _apiClient.initialize();
    return _fetchPurchases(params);
  }

  Future<PurchaseListResponse> _fetchPurchases(PurchaseListParams params) async {
    try {
      final queryParams = <String, dynamic>{
        if (params.page != null) 'page': params.page,
        if (params.limit != null) 'limit': params.limit,
        if (params.search != null && params.search!.isNotEmpty) 'search': params.search,
        if (params.supplierId != null && params.supplierId!.isNotEmpty) 'supplier': params.supplierId,
        if (params.status != null) 'status': params.status!.name,
        if (params.fromDate != null) 'from': params.fromDate!.toIso8601String(),
        if (params.toDate != null) 'to': params.toDate!.toIso8601String(),
        if (params.sortBy != null) 'sortBy': params.sortBy,
        if (params.sortDesc != null) 'sortDesc': params.sortDesc,
      };

      final response = await _apiClient.dio.get('/purchases', queryParameters: queryParams);
      
      if (response.statusCode == 200) {
        return PurchaseListResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load purchases');
      }
    } catch (e) {
      throw Exception('Failed to load purchases: $e');
    }
  }

  Future<Purchase> createPurchase(PurchaseCreateRequest request) async {
    state = const AsyncLoading();
    try {
      final response = await _apiClient.dio.post('/purchases', data: request.toJson());
      if (response.statusCode == 201) {
        final purchase = Purchase.fromJson(response.data['purchase']);
        ref.invalidateSelf();
        return purchase;
      } else {
        throw Exception(response.data['message'] ?? 'Failed to create purchase');
      }
    } catch (e) {
      throw Exception('Failed to create purchase: $e');
    }
  }

  Future<Purchase> updatePurchase(String id, PurchaseUpdateRequest request) async {
    state = const AsyncLoading();
    try {
      final response = await _apiClient.dio.put('/purchases/$id', data: request.toJson());
      if (response.statusCode == 200) {
        final purchase = Purchase.fromJson(response.data['purchase']);
        ref.invalidateSelf();
        return purchase;
      } else {
        throw Exception(response.data['message'] ?? 'Failed to update purchase');
      }
    } catch (e) {
      throw Exception('Failed to update purchase: $e');
    }
  }

  Future<void> deletePurchase(String id) async {
    state = const AsyncLoading();
    try {
      final response = await _apiClient.dio.delete('/purchases/$id');
      if (response.statusCode == 200) {
        ref.invalidateSelf();
      } else {
        throw Exception(response.data['message'] ?? 'Failed to delete purchase');
      }
    } catch (e) {
      throw Exception('Failed to delete purchase: $e');
    }
  }

  Future<Purchase> getPurchase(String id) async {
    try {
      final response = await _apiClient.dio.get('/purchases/$id');
      if (response.statusCode == 200) {
        return Purchase.fromJson(response.data);
      } else {
        throw Exception('Failed to load purchase');
      }
    } catch (e) {
      throw Exception('Failed to load purchase: $e');
    }
  }

  Future<Purchase> receivePurchase(String id) async {
    state = const AsyncLoading();
    try {
      final response = await _apiClient.dio.post('/purchases/$id/receive');
      if (response.statusCode == 200) {
        final purchase = Purchase.fromJson(response.data['purchase']);
        ref.invalidateSelf();
        return purchase;
      } else {
        throw Exception(response.data['message'] ?? 'Failed to receive purchase');
      }
    } catch (e) {
      throw Exception('Failed to receive purchase: $e');
    }
  }
}

@riverpod
class PurchaseFiltersNotifier extends _$PurchaseFiltersNotifier {
  @override
  PurchaseListParams build() {
    return const PurchaseListParams(page: 1, limit: 20);
  }

  void updateSearch(String search) {
    state = state.copyWith(search: search, page: 1);
  }

  void updateSupplier(String? supplierId) {
    state = state.copyWith(supplierId: supplierId, page: 1);
  }

  void updateStatus(PurchaseStatus? status) {
    state = state.copyWith(status: status, page: 1);
  }

  void updateDateRange(DateTime? from, DateTime? to) {
    state = state.copyWith(fromDate: from, toDate: to, page: 1);
  }

  void updateSort(String? sortBy, bool? sortDesc) {
    state = state.copyWith(sortBy: sortBy, sortDesc: sortDesc);
  }

  void nextPage() {
    state = state.copyWith(page: (state.page ?? 1) + 1);
  }

  void reset() {
    state = const PurchaseListParams(page: 1, limit: 20);
  }
}

@riverpod
FutureOr<PurchaseListResponse> filteredPurchases(Ref ref) {
  final params = ref.watch(purchaseFiltersNotifierProvider);
  return ref.watch(purchaseNotifierProvider(params).future);
}

@riverpod
FutureOr<Purchase> purchaseDetail(Ref ref, String purchaseId) {
  final notifier = ref.watch(purchaseNotifierProvider.notifier);
  return notifier.getPurchase(purchaseId);
}

@riverpod
FutureOr<PurchaseStats> purchaseStats(Ref ref) {
  final apiClient = ApiClient();
  apiClient.initialize();
  
  return _fetchPurchaseStats(apiClient);
}

Future<PurchaseStats> _fetchPurchaseStats(ApiClient apiClient) async {
  try {
    final response = await apiClient.dio.get('/purchases/stats');
    if (response.statusCode == 200) {
      return PurchaseStats.fromJson(response.data);
    } else {
      throw Exception('Failed to load purchase stats');
    }
  } catch (e) {
    throw Exception('Failed to load purchase stats: $e');
  }
}