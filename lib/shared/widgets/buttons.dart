import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final bool isLoading;
  final bool isFullWidth;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final BorderSide? side;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.md,
    this.leadingIcon,
    this.trailingIcon,
    this.isLoading = false,
    this.isFullWidth = true,
    this.backgroundColor,
    this.foregroundColor,
    this.side,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customTheme = context.customTheme;
    
    final (bgColor, fgColor, borderSide, padding, height, textStyle) = _getButtonStyles(theme, customTheme);
    
    final effectiveBgColor = backgroundColor ?? bgColor;
    final effectiveFgColor = foregroundColor ?? fgColor;
    final effectiveSide = side ?? borderSide;
    
    Widget child = isLoading
        ? SizedBox(
            width: _getLoaderSize(height),
            height: _getLoaderSize(height),
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(effectiveFgColor),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (leadingIcon != null) ...[
                Icon(leadingIcon, size: _getIconSize(height), color: effectiveFgColor),
                SizedBox(width: AppSpacing.xs),
              ],
              Text(label, style: textStyle.copyWith(color: effectiveFgColor)),
              if (trailingIcon != null) ...[
                SizedBox(width: AppSpacing.xs),
                Icon(trailingIcon, size: _getIconSize(height), color: effectiveFgColor),
              ],
            ],
          );

    final button = switch (variant) {
      AppButtonVariant.primary => FilledButton(
          onPressed: isLoading ? null : onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: effectiveBgColor,
            foregroundColor: effectiveFgColor,
            padding: padding,
            minimumSize: Size(isFullWidth ? double.infinity : 0, height),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
            ),
            textStyle: textStyle,
          ),
          child: child,
        ),
      AppButtonVariant.secondary => OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: effectiveFgColor,
            side: effectiveSide ?? BorderSide(color: effectiveBgColor, width: 1.5),
            padding: padding,
            minimumSize: Size(isFullWidth ? double.infinity : 0, height),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
            ),
            textStyle: textStyle,
          ),
          child: child,
        ),
      AppButtonVariant.tertiary => TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: effectiveFgColor,
            padding: padding,
            minimumSize: Size(isFullWidth ? double.infinity : 0, height),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
            ),
            textStyle: textStyle,
          ),
          child: child,
        ),
      AppButtonVariant.destructive => FilledButton(
          onPressed: isLoading ? null : onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: customTheme.criticalColor,
            foregroundColor: customTheme.onCriticalContainer,
            padding: padding,
            minimumSize: Size(isFullWidth ? double.infinity : 0, height),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
            ),
            textStyle: textStyle,
          ),
          child: child,
        ),
      AppButtonVariant.outlineDestructive => OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: customTheme.criticalColor,
            side: BorderSide(color: customTheme.criticalColor, width: 1.5),
            padding: padding,
            minimumSize: Size(isFullWidth ? double.infinity : 0, height),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
            ),
            textStyle: textStyle,
          ),
          child: child,
        ),
    };

    return button;
  }

  (Color, Color, BorderSide?, EdgeInsets, double, TextStyle) _getButtonStyles(
    ThemeData theme,
    AppCustomTheme customTheme,
  ) {
    switch (size) {
      case AppButtonSize.xs:
        return (
          theme.colorScheme.primary,
          theme.colorScheme.onPrimary,
          BorderSide(color: theme.colorScheme.primary, width: 1),
          AppSpacing.buttonPaddingSm,
          AppSpacing.buttonHeightSm,
          AppTypography.labelSmall,
        );
      case AppButtonSize.sm:
        return (
          theme.colorScheme.primary,
          theme.colorScheme.onPrimary,
          BorderSide(color: theme.colorScheme.primary, width: 1.5),
          EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          40,
          AppTypography.labelMedium,
        );
      case AppButtonSize.md:
        return (
          theme.colorScheme.primary,
          theme.colorScheme.onPrimary,
          BorderSide(color: theme.colorScheme.primary, width: 1.5),
          AppSpacing.buttonPadding,
          AppSpacing.buttonHeight,
          AppTypography.labelLarge,
        );
      case AppButtonSize.lg:
        return (
          theme.colorScheme.primary,
          theme.colorScheme.onPrimary,
          BorderSide(color: theme.colorScheme.primary, width: 2),
          AppSpacing.buttonPaddingLg,
          AppSpacing.buttonHeightLg,
          AppTypography.titleMedium,
        );
    }
  }

  double _getIconSize(double height) {
    return switch (size) {
      AppButtonSize.xs => 14,
      AppButtonSize.sm => 16,
      AppButtonSize.md => 20,
      AppButtonSize.lg => 24,
    };
  }

  double _getLoaderSize(double height) {
    return height * 0.6;
  }
}

enum AppButtonVariant {
  primary,
  secondary,
  tertiary,
  destructive,
  outlineDestructive,
}

enum AppButtonSize {
  xs,
  sm,
  md,
  lg,
}

class AppIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String? tooltip;
  final Color? color;
  final Color? backgroundColor;
  final double? size;
  final double iconSize;

  const AppIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.tooltip,
    this.color,
    this.backgroundColor,
    this.size,
    this.iconSize = AppSpacing.iconSizeMd,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.colorScheme.onSurfaceVariant;
    final effectiveBgColor = backgroundColor ?? theme.colorScheme.surfaceContainer;
    final effectiveSize = size ?? 40.0;

    return Material(
      color: effectiveBgColor,
      borderRadius: BorderRadius.circular(AppSpacing.borderRadiusFull),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusFull),
        child: SizedBox(
          width: effectiveSize,
          height: effectiveSize,
          child: Icon(icon, color: effectiveColor, size: iconSize),
        ),
      ),
    );
  }
}

class AppFloatingActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String? tooltip;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool mini;

  const AppFloatingActionButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.tooltip,
    this.backgroundColor,
    this.foregroundColor,
    this.mini = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: tooltip,
      backgroundColor: backgroundColor ?? theme.colorScheme.primary,
      foregroundColor: foregroundColor ?? theme.colorScheme.onPrimary,
      mini: mini,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusFull),
      ),
      child: Icon(icon, size: mini ? AppSpacing.iconSizeSm : AppSpacing.iconSizeMd),
    );
  }
}