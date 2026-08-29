import 'package:freezed_annotation/freezed_annotation.dart';
import '../constants/app_constants.dart';

part 'employee.freezed.dart';
part 'employee.g.dart';

@freezed
class Employee with _$Employee {
  const factory Employee({
    required String id,
    required String name,
    required String email,
    required String phone,
    required UserRole role,
    required bool isActive,
    String? avatarUrl,
    DateTime? lastLoginAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Employee;

  factory Employee.fromJson(Map<String, dynamic> json) => _$EmployeeFromJson(json);
}

@freezed
class EmployeeCreateRequest with _$EmployeeCreateRequest {
  const factory EmployeeCreateRequest({
    required String name,
    required String email,
    required String phone,
    required UserRole role,
    required String password,
  }) = _EmployeeCreateRequest;

  factory EmployeeCreateRequest.fromJson(Map<String, dynamic> json) => _$EmployeeCreateRequestFromJson(json);
}

@freezed
class EmployeeUpdateRequest with _$EmployeeUpdateRequest {
  const factory EmployeeUpdateRequest({
    String? name,
    String? email,
    String? phone,
    UserRole? role,
    bool? isActive,
    String? avatarBase64,
  }) = _EmployeeUpdateRequest;

  factory EmployeeUpdateRequest.fromJson(Map<String, dynamic> json) => _$EmployeeUpdateRequestFromJson(json);
}

@freezed
class EmployeeListParams with _$EmployeeListParams {
  const factory EmployeeListParams({
    int? page,
    int? limit,
    String? search,
    UserRole? role,
    bool? isActive,
    String? sortBy,
    bool? sortDesc,
  }) = _EmployeeListParams;

  factory EmployeeListParams.fromJson(Map<String, dynamic> json) => _$EmployeeListParamsFromJson(json);
}

@freezed
class EmployeeListResponse with _$EmployeeListResponse {
  const factory EmployeeListResponse({
    required List<Employee> employees,
    required int total,
    required int page,
    required int limit,
    required int totalPages,
  }) = _EmployeeListResponse;

  factory EmployeeListResponse.fromJson(Map<String, dynamic> json) => _$EmployeeListResponseFromJson(json);
}