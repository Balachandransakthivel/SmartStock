import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_spacing.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          primaryContainer: AppColors.primaryContainer,
          secondary: AppColors.secondary,
          secondaryContainer: AppColors.secondaryContainer,
          tertiary: AppColors.tertiary,
          tertiaryContainer: AppColors.tertiaryContainer,
          error: AppColors.error,
          errorContainer: AppColors.errorContainer,
          surface: AppColors.surface,
          surfaceContainerHighest: AppColors.surfaceContainerHigh,
          onSurface: AppColors.onSurface,
          onSurfaceVariant: AppColors.onSurfaceVariant,
          outline: AppColors.outline,
          outlineVariant: AppColors.outlineVariant,
          shadow: AppColors.shadow,
          scrim: AppColors.scrim,
          inverseSurface: AppColors.inverseSurface,
          onInverseSurface: AppColors.inverseOnSurface,
          inversePrimary: AppColors.inversePrimary,
        ),
        textTheme: AppTypography.textTheme,
        scaffoldBackgroundColor: AppColors.background,
        cardColor: AppColors.surface,
        dividerColor: AppColors.outlineVariant,
        shadowColor: AppColors.shadow,
        fontFamily: 'Inter',
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
            TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
          },
        ),
        appBarTheme: AppBarTheme(
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: AppColors.surface,
          surfaceTintColor: Colors.transparent,
          foregroundColor: AppColors.onSurface,
          centerTitle: false,
          titleTextStyle: AppTypography.titleLarge,
          toolbarHeight: AppSpacing.appBarHeight,
          shape: const Border(
            bottom: BorderSide(color: AppColors.outlineVariant, width: 0.5),
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          elevation: 8,
          backgroundColor: AppColors.surface,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.onSurfaceVariant,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: AppTypography.labelSmall,
          unselectedLabelStyle: AppTypography.labelSmall,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
        ),
        navigationBarTheme: NavigationBarThemeData(
          height: AppSpacing.bottomNavHeight,
          backgroundColor: AppColors.surface,
          elevation: 8,
          indicatorColor: AppColors.primaryContainer,
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppTypography.labelSmall.copyWith(color: AppColors.primary);
            }
            return AppTypography.labelSmall.copyWith(color: AppColors.onSurfaceVariant);
          }),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return IconThemeData(color: AppColors.primary, size: AppSpacing.iconSizeMd);
            }
            return IconThemeData(color: AppColors.onSurfaceVariant, size: AppSpacing.iconSizeMd);
          }),
        ),
        tabBarTheme: TabBarThemeData(
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.onSurfaceVariant,
          indicatorColor: AppColors.primary,
          indicatorSize: TabBarIndicatorSize.label,
          labelStyle: AppTypography.titleSmall,
          unselectedLabelStyle: AppTypography.titleSmall,
          dividerColor: AppColors.outlineVariant,
          overlayColor: WidgetStateProperty.all(Colors.transparent),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          color: AppColors.surface,
          surfaceTintColor: Colors.transparent,
          shadowColor: AppColors.shadow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
            side: BorderSide(color: AppColors.outlineVariant, width: 0.5),
          ),
          margin: EdgeInsets.zero,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onPrimary,
            disabledBackgroundColor: AppColors.outline,
            disabledForegroundColor: AppColors.onSurfaceVariant,
            padding: AppSpacing.buttonPadding,
            minimumSize: Size(double.infinity, AppSpacing.buttonHeight),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
            ),
            textStyle: AppTypography.labelLarge,
            shadowColor: Colors.transparent,
            side: BorderSide.none,
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onPrimary,
            disabledBackgroundColor: AppColors.outline,
            disabledForegroundColor: AppColors.onSurfaceVariant,
            padding: AppSpacing.buttonPadding,
            minimumSize: Size(double.infinity, AppSpacing.buttonHeight),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
            ),
            textStyle: AppTypography.labelLarge,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            disabledForegroundColor: AppColors.onSurfaceVariant,
            padding: AppSpacing.buttonPadding,
            minimumSize: Size(double.infinity, AppSpacing.buttonHeight),
            side: BorderSide(color: AppColors.primary, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
            ),
            textStyle: AppTypography.labelLarge,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            disabledForegroundColor: AppColors.onSurfaceVariant,
            padding: AppSpacing.buttonPaddingSm,
            minimumSize: Size(0, AppSpacing.buttonHeightSm),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
            ),
            textStyle: AppTypography.labelLarge,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surface,
          contentPadding: AppSpacing.inputPadding,
          hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.onSurfaceVariant.withAlphaValue(0.6)),
          labelStyle: AppTypography.bodyMedium,
          floatingLabelStyle: AppTypography.bodySmall.copyWith(color: AppColors.primary),
          errorStyle: AppTypography.bodySmall.copyWith(color: AppColors.error),
          helperStyle: AppTypography.bodySmall.copyWith(color: AppColors.onSurfaceVariant),
          counterStyle: AppTypography.bodySmall.copyWith(color: AppColors.onSurfaceVariant),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
            borderSide: BorderSide(color: AppColors.outline, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
            borderSide: BorderSide(color: AppColors.outline, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
            borderSide: BorderSide(color: AppColors.primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
            borderSide: BorderSide(color: AppColors.error, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
            borderSide: BorderSide(color: AppColors.error, width: 2),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
            borderSide: BorderSide(color: AppColors.outlineVariant, width: 1),
          ),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return AppColors.primary;
            return Colors.transparent;
          }),
          checkColor: WidgetStateProperty.all(AppColors.onPrimary),
          side: BorderSide(color: AppColors.outline, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm)),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        radioTheme: RadioThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return AppColors.primary;
            return AppColors.outline;
          }),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return AppColors.primary;
            return AppColors.outline;
          }),
          trackColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return AppColors.primaryContainer;
            return AppColors.surfaceContainerHigh;
          }),
        ),
        sliderTheme: SliderThemeData(
          activeTrackColor: AppColors.primary,
          inactiveTrackColor: AppColors.primaryContainer,
          thumbColor: AppColors.primary,
          overlayColor: AppColors.primaryContainer,
          valueIndicatorColor: AppColors.primary,
          valueIndicatorTextStyle: AppTypography.labelSmall.copyWith(color: AppColors.onPrimary),
        ),
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: AppColors.primary,
          linearTrackColor: AppColors.primaryContainer,
          circularTrackColor: AppColors.primaryContainer,
        ),
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.surfaceContainer,
          disabledColor: AppColors.surfaceContainerHigh,
          selectedColor: AppColors.primaryContainer,
          secondarySelectedColor: AppColors.secondaryContainer,
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
          labelStyle: AppTypography.labelMedium,
          secondaryLabelStyle: AppTypography.labelMedium.copyWith(color: AppColors.secondary),
          brightness: Brightness.light,
          elevation: 0,
          pressElevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusFull),
            side: BorderSide(color: AppColors.outlineVariant, width: 0.5),
          ),
          selectedShadowColor: Colors.transparent,
        ),
        dialogTheme: DialogThemeData(
          elevation: 0,
          backgroundColor: AppColors.surface,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusXl),
          ),
          titleTextStyle: AppTypography.titleLarge,
          contentTextStyle: AppTypography.bodyMedium,
        ),
        bottomSheetTheme: BottomSheetThemeData(
          elevation: 0,
          backgroundColor: AppColors.surface,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.borderRadiusXl)),
          ),
          modalElevation: 8,
          dragHandleColor: AppColors.outline,
          showDragHandle: true,
        ),
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.inverseSurface,
          contentTextStyle: AppTypography.bodyMedium.copyWith(color: AppColors.inverseOnSurface),
          actionTextColor: AppColors.primaryLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
          ),
          elevation: 4,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          elevation: 2,
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          focusElevation: 4,
          hoverElevation: 4,
          highlightElevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusFull),
          ),
        ),
        dividerTheme: DividerThemeData(
          color: AppColors.outlineVariant,
          thickness: 0.5,
          space: AppSpacing.md,
        ),
        listTileTheme: ListTileThemeData(
          contentPadding: AppSpacing.listItemPadding,
          dense: false,
          titleTextStyle: AppTypography.bodyLarge,
          subtitleTextStyle: AppTypography.bodySmall,
          leadingAndTrailingTextStyle: AppTypography.bodyMedium,
          iconColor: AppColors.onSurfaceVariant,
          textColor: AppColors.onSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
          ),
        ),
        menuTheme: MenuThemeData(
          style: MenuStyle(
            backgroundColor: WidgetStateProperty.all(AppColors.surface),
            surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
            elevation: WidgetStateProperty.all(8),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
                side: BorderSide(color: AppColors.outlineVariant, width: 0.5),
              ),
            ),
          ),
        ),
        popupMenuTheme: PopupMenuThemeData(
          elevation: 8,
          color: AppColors.surface,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
            side: BorderSide(color: AppColors.outlineVariant, width: 0.5),
          ),
          textStyle: AppTypography.bodyMedium,
        ),
        tooltipTheme: TooltipThemeData(
          decoration: BoxDecoration(
            color: AppColors.inverseSurface,
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
          ),
          textStyle: AppTypography.labelSmall.copyWith(color: AppColors.inverseOnSurface),
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
          preferBelow: true,
          verticalOffset: 8,
        ),
        timePickerTheme: TimePickerThemeData(
          backgroundColor: AppColors.surface,
          hourMinuteTextColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return AppColors.onPrimary;
            return AppColors.onSurface;
          }),
          hourMinuteColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return AppColors.primary;
            return AppColors.surfaceContainer;
          }),
          dialHandColor: AppColors.primary,
          dialBackgroundColor: AppColors.primaryContainer,
          entryModeIconColor: AppColors.primary,
        ),
        datePickerTheme: DatePickerThemeData(
          backgroundColor: AppColors.surface,
          surfaceTintColor: Colors.transparent,
          headerBackgroundColor: AppColors.primaryContainer,
          headerForegroundColor: AppColors.onPrimaryContainer,
          dayForegroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return AppColors.onPrimary;
            if (states.contains(WidgetState.disabled)) return AppColors.onSurfaceVariant.withAlphaValue(0.38);
            return AppColors.onSurface;
          }),
          dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return AppColors.primary;
            return Colors.transparent;
          }),
          todayForegroundColor: WidgetStateProperty.all(AppColors.primary),
          todayBackgroundColor: WidgetStateProperty.all(AppColors.primaryContainer),
          yearForegroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return AppColors.onPrimary;
            return AppColors.onSurface;
          }),
          yearBackgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return AppColors.primary;
            return Colors.transparent;
          }),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
          ),
        ),
        extensions: <ThemeExtension<dynamic>>[
          AppCustomTheme(
            successColor: AppColors.success,
            successContainer: AppColors.successContainer,
            onSuccessContainer: AppColors.onSuccessContainer,
            warningColor: AppColors.warning,
            warningContainer: AppColors.warningContainer,
            onWarningContainer: AppColors.onWarningContainer,
            criticalColor: AppColors.error,
            criticalContainer: AppColors.errorContainer,
            onCriticalContainer: AppColors.onErrorContainer,
            cardShadow: AppShadows.sm,
            cardShadowHover: AppShadows.md,
            dividerColor: AppColors.outlineVariant,
            skeletonColor: AppColors.surfaceContainerHigh,
            skeletonHighlightColor: AppColors.surfaceContainer,
          ),
        ],
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF60A5FA),
          primaryContainer: Color(0xFF1E3A8A),
          secondary: Color(0xFF34D399),
          secondaryContainer: Color(0xFF064E3B),
          tertiary: Color(0xFFFBBF24),
          tertiaryContainer: Color(0xFF92400E),
          error: Color(0xFFF87171),
          errorContainer: Color(0xFF7F1D1D),
          surface: Color(0xFF0F172A),
          surfaceContainerHighest: Color(0xFF1E293B),
          onSurface: Color(0xFFF8FAFC),
          onSurfaceVariant: Color(0xFF94A3B8),
          outline: Color(0xFF334155),
          outlineVariant: Color(0xFF1E293B),
          shadow: Color(0xFF000000),
          scrim: Color(0xFF000000),
          inverseSurface: Color(0xFFF8FAFC),
          onInverseSurface: Color(0xFF0F172A),
          inversePrimary: Color(0xFF1D4ED8),
        ),
        textTheme: AppTypography.textTheme.apply(
          bodyColor: AppColors.inverseOnSurface,
          displayColor: AppColors.inverseOnSurface,
        ),
        scaffoldBackgroundColor: AppColors.inverseSurface,
        cardColor: Color(0xFF1E293B),
        dividerColor: Color(0xFF334155),
        shadowColor: Colors.black,
        fontFamily: 'Inter',
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
            TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
          },
        ),
        appBarTheme: AppBarTheme(
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: Color(0xFF0F172A),
          surfaceTintColor: Colors.transparent,
          foregroundColor: AppColors.inverseOnSurface,
          centerTitle: false,
          titleTextStyle: AppTypography.titleLarge.copyWith(color: AppColors.inverseOnSurface),
          toolbarHeight: AppSpacing.appBarHeight,
          shape: Border(
            bottom: BorderSide(color: Color(0xFF1E293B), width: 0.5),
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          elevation: 8,
          backgroundColor: Color(0xFF0F172A),
          selectedItemColor: Color(0xFF60A5FA),
          unselectedItemColor: AppColors.onSurfaceVariant,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: AppTypography.labelSmall,
          unselectedLabelStyle: AppTypography.labelSmall,
          showSelectedLabels: true,
          showUnselectedLabels: true,
        ),
        navigationBarTheme: NavigationBarThemeData(
          height: AppSpacing.bottomNavHeight,
          backgroundColor: Color(0xFF0F172A),
          elevation: 8,
          indicatorColor: Color(0xFF1E3A8A),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppTypography.labelSmall.copyWith(color: Color(0xFF60A5FA));
            }
            return AppTypography.labelSmall.copyWith(color: AppColors.onSurfaceVariant);
          }),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return IconThemeData(color: Color(0xFF60A5FA), size: AppSpacing.iconSizeMd);
            }
            return IconThemeData(color: AppColors.onSurfaceVariant, size: AppSpacing.iconSizeMd);
          }),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          color: Color(0xFF1E293B),
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
            side: BorderSide(color: Color(0xFF334155), width: 0.5),
          ),
          margin: EdgeInsets.zero,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFF1E293B),
          contentPadding: AppSpacing.inputPadding,
          hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.onSurfaceVariant.withAlphaValue(0.6)),
          labelStyle: AppTypography.bodyMedium.copyWith(color: AppColors.onSurfaceVariant),
          floatingLabelStyle: AppTypography.bodySmall.copyWith(color: Color(0xFF60A5FA)),
          errorStyle: AppTypography.bodySmall.copyWith(color: Color(0xFFF87171)),
          helperStyle: AppTypography.bodySmall.copyWith(color: AppColors.onSurfaceVariant),
          counterStyle: AppTypography.bodySmall.copyWith(color: AppColors.onSurfaceVariant),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
            borderSide: BorderSide(color: Color(0xFF334155), width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
            borderSide: BorderSide(color: Color(0xFF334155), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
            borderSide: BorderSide(color: Color(0xFF60A5FA), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
            borderSide: BorderSide(color: Color(0xFFF87171), width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
            borderSide: BorderSide(color: Color(0xFFF87171), width: 2),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
            borderSide: BorderSide(color: Color(0xFF1E293B), width: 1),
          ),
        ),
        extensions: <ThemeExtension<dynamic>>[
          AppCustomTheme(
            successColor: Color(0xFF22C55E),
            successContainer: Color(0xFF14532D),
            onSuccessContainer: Color(0xFFDCFCE7),
            warningColor: Color(0xFFFBBF24),
            warningContainer: Color(0xFF92400E),
            onWarningContainer: Color(0xFFFFFBE6),
            criticalColor: Color(0xFFF87171),
            criticalContainer: Color(0xFF7F1D1D),
            onCriticalContainer: Color(0xFFFEF2F2),
            cardShadow: AppShadows.sm,
            cardShadowHover: AppShadows.md,
            dividerColor: Color(0xFF334155),
            skeletonColor: Color(0xFF1E293B),
            skeletonHighlightColor: Color(0xFF334155),
          ),
        ],
      );
}

class AppCustomTheme extends ThemeExtension<AppCustomTheme> {
  final Color successColor;
  final Color successContainer;
  final Color onSuccessContainer;
  final Color warningColor;
  final Color warningContainer;
  final Color onWarningContainer;
  final Color criticalColor;
  final Color criticalContainer;
  final Color onCriticalContainer;
  final List<BoxShadow> cardShadow;
  final List<BoxShadow> cardShadowHover;
  final Color dividerColor;
  final Color skeletonColor;
  final Color skeletonHighlightColor;

  const AppCustomTheme({
    required this.successColor,
    required this.successContainer,
    required this.onSuccessContainer,
    required this.warningColor,
    required this.warningContainer,
    required this.onWarningContainer,
    required this.criticalColor,
    required this.criticalContainer,
    required this.onCriticalContainer,
    required this.cardShadow,
    required this.cardShadowHover,
    required this.dividerColor,
    required this.skeletonColor,
    required this.skeletonHighlightColor,
  });

  @override
  AppCustomTheme copyWith({
    Color? successColor,
    Color? successContainer,
    Color? onSuccessContainer,
    Color? warningColor,
    Color? warningContainer,
    Color? onWarningContainer,
    Color? criticalColor,
    Color? criticalContainer,
    Color? onCriticalContainer,
    List<BoxShadow>? cardShadow,
    List<BoxShadow>? cardShadowHover,
    Color? dividerColor,
    Color? skeletonColor,
    Color? skeletonHighlightColor,
  }) {
    return AppCustomTheme(
      successColor: successColor ?? this.successColor,
      successContainer: successContainer ?? this.successContainer,
      onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
      warningColor: warningColor ?? this.warningColor,
      warningContainer: warningContainer ?? this.warningContainer,
      onWarningContainer: onWarningContainer ?? this.onWarningContainer,
      criticalColor: criticalColor ?? this.criticalColor,
      criticalContainer: criticalContainer ?? this.criticalContainer,
      onCriticalContainer: onCriticalContainer ?? this.onCriticalContainer,
      cardShadow: cardShadow ?? this.cardShadow,
      cardShadowHover: cardShadowHover ?? this.cardShadowHover,
      dividerColor: dividerColor ?? this.dividerColor,
      skeletonColor: skeletonColor ?? this.skeletonColor,
      skeletonHighlightColor: skeletonHighlightColor ?? this.skeletonHighlightColor,
    );
  }

  @override
  AppCustomTheme lerp(ThemeExtension<AppCustomTheme>? other, double t) {
    if (other is! AppCustomTheme) return this;
    return AppCustomTheme(
      successColor: Color.lerp(successColor, other.successColor, t)!,
      successContainer: Color.lerp(successContainer, other.successContainer, t)!,
      onSuccessContainer: Color.lerp(onSuccessContainer, other.onSuccessContainer, t)!,
      warningColor: Color.lerp(warningColor, other.warningColor, t)!,
      warningContainer: Color.lerp(warningContainer, other.warningContainer, t)!,
      onWarningContainer: Color.lerp(onWarningContainer, other.onWarningContainer, t)!,
      criticalColor: Color.lerp(criticalColor, other.criticalColor, t)!,
      criticalContainer: Color.lerp(criticalContainer, other.criticalContainer, t)!,
      onCriticalContainer: Color.lerp(onCriticalContainer, other.onCriticalContainer, t)!,
      cardShadow: BoxShadow.lerpList(cardShadow, other.cardShadow, t)!,
      cardShadowHover: BoxShadow.lerpList(cardShadowHover, other.cardShadowHover, t)!,
      dividerColor: Color.lerp(dividerColor, other.dividerColor, t)!,
      skeletonColor: Color.lerp(skeletonColor, other.skeletonColor, t)!,
      skeletonHighlightColor: Color.lerp(skeletonHighlightColor, other.skeletonHighlightColor, t)!,
    );
  }
}

extension CustomThemeExtension on BuildContext {
  AppCustomTheme get customTheme => Theme.of(this).extension<AppCustomTheme>()!;
}