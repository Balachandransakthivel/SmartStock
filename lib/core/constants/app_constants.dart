class AppConstants {
  static const String appName = 'SmartStock';
  static const String appTagline = 'Smart Inventory & Reorder Management';
  
  static const String baseUrl = 'https://api.smartstock.yuvilabs.com';
  static const String apiVersion = 'v1';
  static const String apiBaseUrl = '$baseUrl/api/$apiVersion';
  
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  static const int cacheExpiryMinutes = 30;
  
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  static const int minTouchTarget = 48;
  
  static const String dateFormat = 'MMM dd, yyyy';
  static const String dateTimeFormat = 'MMM dd, yyyy hh:mm a';
  static const String timeFormat = 'hh:mm a';
  
  static const String currencySymbol = '₹';
  static const String currencyCode = 'INR';
  
  static const List<String> stockStatuses = ['In Stock', 'Low Stock', 'Out of Stock'];
  static const List<String> purchaseStatuses = ['Pending', 'Ordered', 'Received', 'Cancelled'];
  static const List<String> stockMovementTypes = ['STOCK_IN', 'STOCK_OUT'];
  static const List<String> stockOutReasons = ['Sale', 'Damaged', 'Expired', 'Lost', 'Other'];
  static const List<String> paymentMethods = ['Cash', 'UPI', 'Card', 'Other'];
  static const List<String> userRoles = ['Admin', 'Manager', 'Staff'];
  
  static const int defaultLeadTimeDays = 7;
  static const int defaultSafetyStockDays = 5;
  static const int lowStockThresholdDays = 30;
  static const int deadStockThresholdDays = 60;
  
  static const String storageTokenKey = 'auth_token';
  static const String storageRefreshTokenKey = 'refresh_token';
  static const String storageUserKey = 'user_data';
  static const String storageThemeKey = 'theme_mode';
  static const String storageLanguageKey = 'language';
  static const String storageBiometricKey = 'biometric_enabled';
  static const String storageRememberMeKey = 'remember_me';
}

enum UserRole { admin, manager, staff }

enum StockStatus { inStock, lowStock, outOfStock }

enum PurchaseStatus { pending, ordered, received, cancelled }

enum StockMovementType { stockIn, stockOut }

enum StockOutReason { sale, damaged, expired, lost, other }

enum PaymentMethod { cash, upi, card, other }

extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.admin:
        return 'Admin';
      case UserRole.manager:
        return 'Manager';
      case UserRole.staff:
        return 'Staff';
    }
  }
  
  bool get canManageProducts => this == UserRole.admin;
  bool get canManageSuppliers => this == UserRole.admin;
  bool get canManageEmployees => this == UserRole.admin;
  bool get canViewAnalytics => this != UserRole.staff;
  bool get canApproveReorders => this == UserRole.admin || this == UserRole.manager;
  bool get canCreatePurchases => this == UserRole.admin || this == UserRole.manager;
  bool get canRecordStock => this != UserRole.staff || this == UserRole.staff;
}

extension StockStatusExtension on StockStatus {
  String get displayName {
    switch (this) {
      case StockStatus.inStock:
        return 'In Stock';
      case StockStatus.lowStock:
        return 'Low Stock';
      case StockStatus.outOfStock:
        return 'Out of Stock';
    }
  }
  
  Color get color {
    switch (this) {
      case StockStatus.inStock:
        return const Color(0xFF059669);
      case StockStatus.lowStock:
        return const Color(0xFFD97706);
      case StockStatus.outOfStock:
        return const Color(0xFFDC2626);
    }
  }
  
  IconData get icon {
    switch (this) {
      case StockStatus.inStock:
        return Icons.check_circle;
      case StockStatus.lowStock:
        return Icons.warning_amber;
      case StockStatus.outOfStock:
        return Icons.cancel;
    }
  }
}

extension PurchaseStatusExtension on PurchaseStatus {
  String get displayName {
    switch (this) {
      case PurchaseStatus.pending:
        return 'Pending';
      case PurchaseStatus.ordered:
        return 'Ordered';
      case PurchaseStatus.received:
        return 'Received';
      case PurchaseStatus.cancelled:
        return 'Cancelled';
    }
  }
  
  Color get color {
    switch (this) {
      case PurchaseStatus.pending:
        return const Color(0xFFD97706);
      case PurchaseStatus.ordered:
        return const Color(0xFF2563EB);
      case PurchaseStatus.received:
        return const Color(0xFF059669);
      case PurchaseStatus.cancelled:
        return const Color(0xFF94A3B8);
    }
  }
}