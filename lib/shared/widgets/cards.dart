import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_constants.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? color;
  final List<BoxShadow>? shadows;
  final BorderRadius? borderRadius;
  final Border? border;
  final VoidCallback? onTap;
  final bool isHoverable;
  final bool isSelected;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.shadows,
    this.borderRadius,
    this.border,
    this.onTap,
    this.isHoverable = false,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customTheme = context.customTheme;
    
    final effectiveColor = color ?? theme.cardColor;
    final effectiveShadows = isSelected 
        ? customTheme.cardShadowHover 
        : (shadows ?? customTheme.cardShadow);
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(AppSpacing.borderRadiusLg);
    final effectiveBorder = isSelected
        ? Border.all(color: theme.colorScheme.primary, width: 2)
        : (border ?? Border.all(color: theme.dividerColor, width: 0.5));

    Widget card = Container(
      margin: margin,
      padding: padding ?? AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: effectiveColor,
        borderRadius: effectiveBorderRadius,
        border: effectiveBorder,
        boxShadow: effectiveShadows,
      ),
      child: child,
    );

    if (onTap != null) {
      card = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: effectiveBorderRadius,
          child: card,
        ),
      );
    }

    if (isHoverable) {
      card = MouseRegion(
        cursor: SystemMouseCursors.click,
        child: card,
      );
    }

    return card;
  }
}

class AppCardHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? action;
  final Widget? leading;

  const AppCardHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.action,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        if (leading != null) ...[
          leading!,
          SizedBox(width: AppSpacing.sm),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: AppTypography.titleMedium),
              if (subtitle != null) ...[
                SizedBox(height: AppSpacing.xs),
                Text(subtitle!, style: AppTypography.bodySmall),
              ],
            ],
          ),
        ),
        if (action != null) action!,
      ],
    );
  }
}

class AppCardSection extends StatelessWidget {
  final String title;
  final Widget child;
  final EdgeInsets? padding;

  const AppCardSection({
    super.key,
    required this.title,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: padding ?? EdgeInsets.zero,
          child: Text(title, style: AppTypography.labelMedium.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          )),
        ),
        SizedBox(height: AppSpacing.xs),
        child,
      ],
    );
  }
}

class AppStatCard extends StatelessWidget {
  final String label;
  final String value;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final Widget? trend;

  const AppStatCard({
    super.key,
    required this.label,
    required this.value,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.backgroundColor,
    this.onTap,
    this.trend,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      onTap: onTap,
      padding: AppSpacing.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Container(
                  padding: EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: (iconColor ?? theme.colorScheme.primary).withAlphaValue(0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor ?? theme.colorScheme.primary,
                    size: AppSpacing.iconSizeMd,
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: AppTypography.labelMedium.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    )),
                    SizedBox(height: 2),
                    Text(value, style: AppTypography.headlineSmall.copyWith(
                      fontWeight: FontWeight.w700,
                    )),
                  ],
                ),
              ),
              if (trend != null) trend!,
            ],
          ),
          if (subtitle != null) ...[
            SizedBox(height: AppSpacing.sm),
            Text(subtitle!, style: AppTypography.bodySmall),
          ],
        ],
      ),
    );
  }
}

class AppEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const AppEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(AppSpacing.borderRadiusFull),
              ),
              child: Icon(
                icon,
                size: AppSpacing.iconSizeXl,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: AppSpacing.lg),
            Text(title, style: AppTypography.titleLarge, textAlign: TextAlign.center),
            if (message != null) ...[
              SizedBox(height: AppSpacing.sm),
              Text(message!, style: AppTypography.bodyMedium, textAlign: TextAlign.center),
            ],
            if (actionLabel != null && onAction != null) ...[
              SizedBox(height: AppSpacing.lg),
              AppButton(
                label: actionLabel!,
                onPressed: onAction,
                variant: AppButtonVariant.primary,
                isFullWidth: false,
                size: AppButtonSize.md,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class AppLoadingState extends StatelessWidget {
  final String? message;
  final double? size;

  const AppLoadingState({super.key, this.message, this.size});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: size ?? 48,
              height: size ?? 48,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
              ),
            ),
            if (message != null) ...[
              SizedBox(height: AppSpacing.lg),
              Text(message!, style: AppTypography.bodyMedium),
            ],
          ],
        ),
      ),
    );
  }
}

class AppErrorState extends StatelessWidget {
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final IconData? icon;

  const AppErrorState({
    super.key,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customTheme = context.customTheme;
    return Center(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: customTheme.criticalContainer,
                borderRadius: BorderRadius.circular(AppSpacing.borderRadiusFull),
              ),
              child: Icon(
                icon ?? Icons.error_outline_rounded,
                size: AppSpacing.iconSizeXl,
                color: customTheme.criticalColor,
              ),
            ),
            SizedBox(height: AppSpacing.lg),
            Text(title, style: AppTypography.titleLarge, textAlign: TextAlign.center),
            if (message != null) ...[
              SizedBox(height: AppSpacing.sm),
              Text(message!, style: AppTypography.bodyMedium, textAlign: TextAlign.center),
            ],
            if (actionLabel != null && onAction != null) ...[
              SizedBox(height: AppSpacing.lg),
              AppButton(
                label: actionLabel!,
                onPressed: onAction,
                variant: AppButtonVariant.primary,
                isFullWidth: false,
                size: AppButtonSize.md,
              ),
            ],
          ],
        ),
      ),
    );
  }
}