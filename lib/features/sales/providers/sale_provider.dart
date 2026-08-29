import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/network/api_client.dart';
import '../../../shared/models/models.dart';

part 'sale_provider.g.dart';

@riverpod
class SaleNotifier extends _$SaleNotifier {
  final ApiClient _apiClient = ApiClient();

  @override
  FutureOr<SaleListResponse> build(SaleListParams params) {
    _apiClient.initialize();
    return _fetchSales(params);
  }

  Future<SaleListResponse> _fetchSales(SaleListParams params) async {
    try {
      final queryParams = <String, dynamic>{
        if (params.page != null) 'page': params.page,
        if (params.limit != null) 'limit': params.limit,
        if (params.search != null && params.search!.isNotEmpty) 'search': params.search,
        if (params.customerId != null && params.customerId!.isNotEmpty) 'customer': params.customerId,
        if (params.paymentMethod != null) 'paymentMethod': params.paymentMethod!.name,
        if (params.fromDate != null) 'from': params.fromDate!.toIso8601String(),
        if (params.toDate != null) 'to': params.toDate!.toIso8601String(),
        if (params.sortBy != null) 'sortBy': params.sortBy,
        if (params.sortDesc != null) 'sortDesc': params.sortDesc,
      };

      final response = await _apiClient.dio.get('/sales', queryParameters: queryParams);
      
      if (response.statusCode == 200) {
        return SaleListResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load sales');
      }
    } catch (e) {
      throw Exception('Failed to load sales: $e');
    }
  }

  Future<Sale> createSale(SaleCreateRequest request) async {
    state = const AsyncLoading();
    try {
      final response = await _apiClient.dio.post('/sales', data: request.toJson());
      if (response.statusCode == 201) {
        final sale = Sale.fromJson(response.data['sale']);
        ref.invalidateSelf();
        return sale;
      } else {
        throw Exception(response.data['message'] ?? 'Failed to create sale');
      }
    } catch (e) {
      throw Exception('Failed to create sale: $e');
    }
  }

  Future<Sale> getSale(String id) async {
    try {
      final response = await _apiClient.dio.get('/sales/$id');
      if (response.statusCode == 200) {
        return Sale.fromJson(response.data);
      } else {
        throw Exception('Failed to load sale');
      }
    } catch (e) {
      throw Exception('Failed to load sale: $e');
    }
  }
}

@riverpod
class SaleFiltersNotifier extends _$SaleFiltersNotifier {
  @override
  SaleListParams build() {
    return const SaleListParams(page: 1, limit: 20);
  }

  void updateSearch(String search) {
    state = state.copyWith(search: search, page: 1);
  }

  void updatePaymentMethod(PaymentMethod? method) {
    state = state.copyWith(paymentMethod: method, page: 1);
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
    state = const SaleListParams(page: 1, limit: 20);
  }
}

@riverpod
FutureOr<SaleListResponse> filteredSales(Ref ref) {
  final params = ref.watch(saleFiltersNotifierProvider);
  return ref.watch(saleNotifierProvider(params).future);
}

@riverpod
FutureOr<Sale> saleDetail(Ref ref, String saleId) {
  final notifier = ref.watch(saleNotifierProvider.notifier);
  return notifier.getSale(saleId);
}

@riverpod
FutureOr<SaleStats> saleStats(Ref ref) {
  final apiClient = ApiClient();
  apiClient.initialize();
  
  return _fetchSaleStats(apiClient);
}

Future<SaleStats> _fetchSaleStats(ApiClient apiClient) async {
  try {
    final response = await apiClient.dio.get('/sales/stats');
    if (response.statusCode == 200) {
      return SaleStats.fromJson(response.data);
    } else {
      throw Exception('Failed to load sale stats');
    }
  } catch (e) {
    throw Exception('Failed to load sale stats: $e');
  }
}