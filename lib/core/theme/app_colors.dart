import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF2563EB);
  static const Color primaryLight = Color(0xFF3B82F6);
  static const Color primaryDark = Color(0xFF1D4ED8);
  static const Color primaryContainer = Color(0xFFDBEAFE);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFF1E3A8A);

  static const Color secondary = Color(0xFF059669);
  static const Color secondaryLight = Color(0xFF10B981);
  static const Color secondaryContainer = Color(0xFFD1FAE5);
  static const Color onSecondary = Color(0xFFFFFFFF);

  static const Color tertiary = Color(0xFFD97706);
  static const Color tertiaryContainer = Color(0xFFFEF3C7);
  static const Color onTertiaryContainer = Color(0xFF92400E);

  static const Color error = Color(0xFFDC2626);
  static const Color errorLight = Color(0xFFEF4444);
  static const Color errorContainer = Color(0xFFFEF2F2);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color onErrorContainer = Color(0xFF991B1B);

  static const Color success = Color(0xFF059669);
  static const Color successContainer = Color(0xFFD1FAE5);
  static const Color onSuccessContainer = Color(0xFF064E3B);

  static const Color warning = Color(0xFFD97706);
  static const Color warningContainer = Color(0xFFFEF3C7);
  static const Color onWarningContainer = Color(0xFF92400E);

  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF8FAFC);
  static const Color surfaceContainer = Color(0xFFF1F5F9);
  static const Color surfaceContainerHigh = Color(0xFFE2E8F0);
  static const Color onSurface = Color(0xFF0F172A);
  static const Color onSurfaceVariant = Color(0xFF475569);

  static const Color outline = Color(0xFFCBD5E1);
  static const Color outlineVariant = Color(0xFFE2E8F0);

  static const Color shadow = Color(0xFF0F172A);
  static const Color scrim = Color(0xFF0F172A);

  static const Color inverseSurface = Color(0xFF0F172A);
  static const Color inverseOnSurface = Color(0xFFF8FAFC);
  static const Color inversePrimary = Color(0xFF93C5FD);

  static const Color background = Color(0xFFF8FAFC);
  static const Color onBackground = Color(0xFF0F172A);

  static const Map<int, Color> primarySwatch = {
    50: Color(0xFFEFF6FF),
    100: Color(0xFFDBEAFE),
    200: Color(0xFFBFDBFE),
    300: Color(0xFF93C5FD),
    400: Color(0xFF60A5FA),
    500: Color(0xFF3B82F6),
    600: Color(0xFF2563EB),
    700: Color(0xFF1D4ED8),
    800: Color(0xFF1E40AF),
    900: Color(0xFF1E3A8A),
    950: Color(0xFF172554),
  };

  static const Map<int, Color> neutralSwatch = {
    50: Color(0xFFF8FAFC),
    100: Color(0xFFF1F5F9),
    200: Color(0xFFE2E8F0),
    300: Color(0xFFCBD5E1),
    400: Color(0xFF94A3B8),
    500: Color(0xFF64748B),
    600: Color(0xFF475569),
    700: Color(0xFF334155),
    800: Color(0xFF1E293B),
    900: Color(0xFF0F172A),
    950: Color(0xFF020617),
  };

  static const Map<int, Color> successSwatch = {
    50: Color(0xFFF0FDF4),
    100: Color(0xFFDCFCE7),
    200: Color(0xFFBBF7D0),
    300: Color(0xFF86EFAC),
    400: Color(0xFF4ADE80),
    500: Color(0xFF22C55E),
    600: Color(0xFF16A34A),
    700: Color(0xFF15803D),
    800: Color(0xFF166534),
    900: Color(0xFF14532D),
  };

  static const Map<int, Color> warningSwatch = {
    50: Color(0xFFFFFBE6),
    100: Color(0xFFFEF3C7),
    200: Color(0xFFFDE68A),
    300: Color(0xFFFCD34D),
    400: Color(0xFFFBBF24),
    500: Color(0xFFF59E0B),
    600: Color(0xFFD97706),
    700: Color(0xFFB45309),
    800: Color(0xFF92400E),
    900: Color(0xFF78350F),
  };

  static const Map<int, Color> errorSwatch = {
    50: Color(0xFFFEF2F2),
    100: Color(0xFFFEE2E2),
    200: Color(0xFFFECDD3),
    300: Color(0xFFFCA5A5),
    400: Color(0xFFF87171),
    500: Color(0xFFEF4444),
    600: Color(0xFFDC2626),
    700: Color(0xFFB91C1C),
    800: Color(0xFF991B1B),
    900: Color(0xFF7F1D1D),
  };
}

extension ColorExtension on Color {
  Color withAlphaValue(double alpha) => withOpacity(alpha.clamp(0.0, 1.0));
}