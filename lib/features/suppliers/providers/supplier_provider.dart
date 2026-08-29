import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/network/api_client.dart';
import '../../../shared/models/models.dart';

part 'supplier_provider.g.dart';

@riverpod
class SupplierNotifier extends _$SupplierNotifier {
  final ApiClient _apiClient = ApiClient();

  @override
  FutureOr<SupplierListResponse> build(SupplierListParams params) {
    _apiClient.initialize();
    return _fetchSuppliers(params);
  }

  Future<SupplierListResponse> _fetchSuppliers(SupplierListParams params) async {
    try {
      final queryParams = <String, dynamic>{
        if (params.page != null) 'page': params.page,
        if (params.limit != null) 'limit': params.limit,
        if (params.search != null && params.search!.isNotEmpty) 'search': params.search,
        if (params.sortBy != null) 'sortBy': params.sortBy,
        if (params.sortDesc != null) 'sortDesc': params.sortDesc,
      };

      final response = await _apiClient.dio.get('/suppliers', queryParameters: queryParams);
      
      if (response.statusCode == 200) {
        return SupplierListResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load suppliers');
      }
    } catch (e) {
      throw Exception('Failed to load suppliers: $e');
    }
  }

  Future<Supplier> createSupplier(SupplierCreateRequest request) async {
    state = const AsyncLoading();
    try {
      final response = await _apiClient.dio.post('/suppliers', data: request.toJson());
      if (response.statusCode == 201) {
        final supplier = Supplier.fromJson(response.data['supplier']);
        ref.invalidateSelf();
        return supplier;
      } else {
        throw Exception(response.data['message'] ?? 'Failed to create supplier');
      }
    } catch (e) {
      throw Exception('Failed to create supplier: $e');
    }
  }

  Future<Supplier> updateSupplier(String id, SupplierUpdateRequest request) async {
    state = const AsyncLoading();
    try {
      final response = await _apiClient.dio.put('/suppliers/$id', data: request.toJson());
      if (response.statusCode == 200) {
        final supplier = Supplier.fromJson(response.data['supplier']);
        ref.invalidateSelf();
        return supplier;
      } else {
        throw Exception(response.data['message'] ?? 'Failed to update supplier');
      }
    } catch (e) {
      throw Exception('Failed to update supplier: $e');
    }
  }

  Future<void> deleteSupplier(String id) async {
    state = const AsyncLoading();
    try {
      final response = await _apiClient.dio.delete('/suppliers/$id');
      if (response.statusCode == 200) {
        ref.invalidateSelf();
      } else {
        throw Exception(response.data['message'] ?? 'Failed to delete supplier');
      }
    } catch (e) {
      throw Exception('Failed to delete supplier: $e');
    }
  }

  Future<SupplierDetail> getSupplierDetail(String id) async {
    try {
      final response = await _apiClient.dio.get('/suppliers/$id');
      if (response.statusCode == 200) {
        return SupplierDetail.fromJson(response.data);
      } else {
        throw Exception('Failed to load supplier detail');
      }
    } catch (e) {
      throw Exception('Failed to load supplier detail: $e');
    }
  }
}

@riverpod
class SupplierFiltersNotifier extends _$SupplierFiltersNotifier {
  @override
  SupplierListParams build() {
    return const SupplierListParams(page: 1, limit: 20);
  }

  void updateSearch(String search) {
    state = state.copyWith(search: search, page: 1);
  }

  void updateSort(String? sortBy, bool? sortDesc) {
    state = state.copyWith(sortBy: sortBy, sortDesc: sortDesc);
  }

  void nextPage() {
    state = state.copyWith(page: (state.page ?? 1) + 1);
  }

  void reset() {
    state = const SupplierListParams(page: 1, limit: 20);
  }
}

@riverpod
FutureOr<SupplierListResponse> filteredSuppliers(Ref ref) {
  final params = ref.watch(supplierFiltersNotifierProvider);
  return ref.watch(supplierNotifierProvider(params).future);
}

@riverpod
FutureOr<SupplierDetail> supplierDetail(Ref ref, String supplierId) {
  final notifier = ref.watch(supplierNotifierProvider.notifier);
  return notifier.getSupplierDetail(supplierId);
}