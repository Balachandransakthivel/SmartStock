import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/network/api_client.dart';
import '../../../shared/models/models.dart';

part 'dashboard_provider.g.dart';

@riverpod
class DashboardNotifier extends _$DashboardNotifier {
  final ApiClient _apiClient = ApiClient();

  @override
  FutureOr<DashboardStats> build() {
    _apiClient.initialize();
    return _fetchDashboardStats();
  }

  Future<DashboardStats> _fetchDashboardStats() async {
    try {
      final response = await _apiClient.dio.get('/dashboard/stats');
      
      if (response.statusCode == 200) {
        return DashboardStats.fromJson(response.data);
      } else {
        throw Exception('Failed to load dashboard stats');
      }
    } catch (e) {
      throw Exception('Failed to load dashboard: $e');
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchDashboardStats);
  }
}

@riverpod
class ManagerDashboardNotifier extends _$ManagerDashboardNotifier {
  final ApiClient _apiClient = ApiClient();

  @override
  FutureOr<ManagerDashboardStats> build() {
    _apiClient.initialize();
    return _fetchManagerDashboardStats();
  }

  Future<ManagerDashboardStats> _fetchManagerDashboardStats() async {
    try {
      final response = await _apiClient.dio.get('/dashboard/manager');
      
      if (response.statusCode == 200) {
        return ManagerDashboardStats.fromJson(response.data);
      } else {
        throw Exception('Failed to load manager dashboard stats');
      }
    } catch (e) {
      throw Exception('Failed to load manager dashboard: $e');
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchManagerDashboardStats);
  }
}

@riverpod
class StaffDashboardNotifier extends _$StaffDashboardNotifier {
  final ApiClient _apiClient = ApiClient();

  @override
  FutureOr<StaffDashboardStats> build() {
    _apiClient.initialize();
    return _fetchStaffDashboardStats();
  }

  Future<StaffDashboardStats> _fetchStaffDashboardStats() async {
    try {
      final response = await _apiClient.dio.get('/dashboard/staff');
      
      if (response.statusCode == 200) {
        return StaffDashboardStats.fromJson(response.data);
      } else {
        throw Exception('Failed to load staff dashboard stats');
      }
    } catch (e) {
      throw Exception('Failed to load staff dashboard: $e');
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchStaffDashboardStats);
  }
}

@riverpod
FutureOr<DashboardStats> adminDashboardStats(Ref ref) {
  return ref.watch(dashboardNotifierProvider.future);
}

@riverpod
FutureOr<ManagerDashboardStats> managerDashboardStats(Ref ref) {
  return ref.watch(managerDashboardNotifierProvider.future);
}

@riverpod
FutureOr<StaffDashboardStats> staffDashboardStats(Ref ref) {
  return ref.watch(staffDashboardNotifierProvider.future);
}