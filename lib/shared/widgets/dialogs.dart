import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import 'buttons.dart';

Future<T?> showAppDialog<T>({
  required BuildContext context,
  required String title,
  String? message,
  Widget? content,
  List<Widget>? actions,
  bool barrierDismissible = true,
  String? confirmLabel,
  String? cancelLabel,
  VoidCallback? onConfirm,
  VoidCallback? onCancel,
  AppButtonVariant confirmVariant = AppButtonVariant.primary,
  IconData? icon,
  Color? iconColor,
}) {
  final theme = Theme.of(context);
  
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) => AlertDialog(
      title: Row(
        children: [
          if (icon != null) ...[
            Container(
              padding: EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: (iconColor ?? theme.colorScheme.primary).withAlphaValue(0.1),
                borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
              ),
              child: Icon(icon, color: iconColor ?? theme.colorScheme.primary, size: AppSpacing.iconSizeMd),
            ),
            SizedBox(width: AppSpacing.sm),
          ],
          Expanded(child: Text(title, style: AppTypography.titleLarge)),
        ],
      ),
      content: content ?? (message != null ? Text(message, style: AppTypography.bodyMedium) : null),
      actions: actions ??
          [
            if (cancelLabel != null)
              AppButton(
                label: cancelLabel,
                onPressed: () {
                  Navigator.of(context).pop();
                  onCancel?.call();
                },
                variant: AppButtonVariant.tertiary,
                isFullWidth: false,
                size: AppButtonSize.sm,
              ),
            if (confirmLabel != null)
              AppButton(
                label: confirmLabel,
                onPressed: () {
                  Navigator.of(context).pop(true);
                  onConfirm?.call();
                },
                variant: confirmVariant,
                isFullWidth: false,
                size: AppButtonSize.sm,
              ),
          ],
      actionsPadding: EdgeInsets.only(
        right: AppSpacing.md,
        bottom: AppSpacing.md,
        left: AppSpacing.md,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusXl),
      ),
    ),
  );
}

Future<bool?> showConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  String confirmLabel = 'Confirm',
  String cancelLabel = 'Cancel',
  AppButtonVariant confirmVariant = AppButtonVariant.destructive,
  IconData? icon,
  Color? iconColor,
}) {
  return showAppDialog<bool>(
    context: context,
    title: title,
    message: message,
    confirmLabel: confirmLabel,
    cancelLabel: cancelLabel,
    confirmVariant: confirmVariant,
    icon: icon,
    iconColor: iconColor,
  );
}

Future<T?> showAppBottomSheet<T>({
  required BuildContext context,
  required Widget child,
  String? title,
  Widget? titleAction,
  bool isScrollControlled = true,
  bool showDragHandle = true,
}) {
  final theme = Theme.of(context);
  
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    showDragHandle: showDragHandle,
    backgroundColor: theme.colorScheme.surface,
    surfaceTintColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.borderRadiusXl)),
    ),
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null)
            Padding(
              padding: EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.sm),
              child: Row(
                children: [
                  Text(title, style: AppTypography.titleLarge),
                  Spacer(),
                  if (titleAction != null) titleAction,
                ],
              ),
            ),
          Flexible(child: child),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    ),
  );
}

void showAppSnackBar({
  required BuildContext context,
  required String message,
  AppSnackBarType type = AppSnackBarType.info,
  String? actionLabel,
  VoidCallback? onAction,
  Duration duration = const Duration(seconds: 4),
}) {
  final theme = Theme.of(context);
  final customTheme = context.customTheme;
  
  Color backgroundColor;
  Color textColor;
  IconData icon;
  
  switch (type) {
    case AppSnackBarType.success:
      backgroundColor = customTheme.successColor;
      textColor = customTheme.onSuccessContainer;
      icon = Icons.check_circle_rounded;
      break;
    case AppSnackBarType.warning:
      backgroundColor = customTheme.warningColor;
      textColor = customTheme.onWarningContainer;
      icon = Icons.warning_amber_rounded;
      break;
    case AppSnackBarType.error:
      backgroundColor = customTheme.criticalColor;
      textColor = customTheme.onCriticalContainer;
      icon = Icons.error_rounded;
      break;
    case AppSnackBarType.info:
    default:
      backgroundColor = theme.colorScheme.inverseSurface;
      textColor = theme.colorScheme.inverseOnSurface;
      icon = Icons.info_rounded;
  }
  
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(icon, color: textColor, size: AppSpacing.iconSizeMd),
          SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(message, style: AppTypography.bodyMedium.copyWith(color: textColor))),
        ],
      ),
      action: actionLabel != null && onAction != null
          ? SnackBarAction(
              label: actionLabel,
              textColor: textColor,
              onPressed: onAction,
            )
          : null,
      backgroundColor: backgroundColor,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
      ),
      margin: EdgeInsets.all(AppSpacing.md),
    ),
  );
}

enum AppSnackBarType { success, warning, error, info }

class AppLoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? message;

  const AppLoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black.withAlphaValue(0.3),
            child: Center(
              child: Container(
                padding: EdgeInsets.all(AppSpacing.xl),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
                    ),
                    if (message != null) ...[
                      SizedBox(height: AppSpacing.lg),
                      Text(message!, style: AppTypography.bodyMedium),
                    ],
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}