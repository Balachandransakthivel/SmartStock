import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings.freezed.dart';
part 'settings.g.dart';

@freezed
class AppSettings with _$AppSettings {
  const factory AppSettings({
    required String businessName,
    required String businessAddress,
    required String businessPhone,
    required String businessEmail,
    required String gstNumber,
    required String currencyCode,
    required String currencySymbol,
    required String dateFormat,
    required String timeFormat,
    required int defaultPageSize,
    required bool enableLowStockAlerts,
    required bool enableOutOfStockAlerts,
    required bool enableReorderAlerts,
    required bool enableExpiryAlerts,
    required int lowStockThresholdDays,
    required int deadStockThresholdDays,
    required int defaultLeadTimeDays,
    required int defaultSafetyStockDays,
    required bool autoBackupEnabled,
    required String backupFrequency,
    required bool biometricEnabled,
    required bool darkModeEnabled,
    required String language,
    DateTime? updatedAt,
  }) = _AppSettings;

  factory AppSettings.fromJson(Map<String, dynamic> json) => _$AppSettingsFromJson(json);
}

@freezed
class AppSettingsUpdateRequest with _$AppSettingsUpdateRequest {
  const factory AppSettingsUpdateRequest({
    String? businessName,
    String? businessAddress,
    String? businessPhone,
    String? businessEmail,
    String? gstNumber,
    String? currencyCode,
    String? currencySymbol,
    String? dateFormat,
    String? timeFormat,
    int? defaultPageSize,
    bool? enableLowStockAlerts,
    bool? enableOutOfStockAlerts,
    bool? enableReorderAlerts,
    bool? enableExpiryAlerts,
    int? lowStockThresholdDays,
    int? deadStockThresholdDays,
    int? defaultLeadTimeDays,
    int? defaultSafetyStockDays,
    bool? autoBackupEnabled,
    String? backupFrequency,
    bool? biometricEnabled,
    bool? darkModeEnabled,
    String? language,
  }) = _AppSettingsUpdateRequest;

  factory AppSettingsUpdateRequest.fromJson(Map<String, dynamic> json) => _$AppSettingsUpdateRequestFromJson(json);
}

@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    required String name,
    required String email,
    required String phone,
    String? avatarUrl,
    required UserRole role,
    required String businessName,
    bool? emailNotifications,
    bool? pushNotifications,
    bool? biometricEnabled,
    String? language,
    bool? darkMode,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) => _$UserProfileFromJson(json);
}

@freezed
class UserProfileUpdateRequest with _$UserProfileUpdateRequest {
  const factory UserProfileUpdateRequest({
    String? name,
    String? phone,
    String? avatarBase64,
    bool? emailNotifications,
    bool? pushNotifications,
    bool? biometricEnabled,
    String? language,
    bool? darkMode,
  }) = _UserProfileUpdateRequest;

  factory UserProfileUpdateRequest.fromJson(Map<String, dynamic> json) => _$UserProfileUpdateRequestFromJson(json);
}

@freezed
class ChangePasswordRequest with _$ChangePasswordRequest {
  const factory ChangePasswordRequest({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) = _ChangePasswordRequest;

  factory ChangePasswordRequest.fromJson(Map<String, dynamic> json) => _$ChangePasswordRequestFromJson(json);
}