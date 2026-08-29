import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

class AppAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final double size;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final VoidCallback? onTap;
  final bool showBorder;
  final BorderRadius? borderRadius;

  const AppAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.size = AppSpacing.avatarSizeMd,
    this.backgroundColor,
    this.foregroundColor,
    this.onTap,
    this.showBorder = false,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBgColor = backgroundColor ?? _getColorFromName(name);
    final effectiveFgColor = foregroundColor ?? theme.colorScheme.onPrimary;
    final effectiveRadius = borderRadius ?? BorderRadius.circular(size / 2);

    Widget avatar = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: effectiveBgColor,
        borderRadius: effectiveRadius,
        border: showBorder
            ? Border.all(color: theme.colorScheme.outline, width: 1.5)
            : null,
        image: imageUrl != null
            ? DecorationImage(
                image: NetworkImage(imageUrl!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: imageUrl == null
          ? Center(
              child: Text(
                _getInitials(name),
                style: TextStyle(
                  fontSize: size * 0.4,
                  fontWeight: FontWeight.w600,
                  color: effectiveFgColor,
                ),
              ),
            )
          : null,
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: avatar);
    }
    return avatar;
  }

  Color _getColorFromName(String? name) {
    if (name == null || name.isEmpty) {
      return const Color(0xFF64748B);
    }
    
    final colors = [
      const Color(0xFF2563EB),
      const Color(0xFF059669),
      const Color(0xFFD97706),
      const Color(0xFFDC2626),
      const Color(0xFF7C3AED),
      const Color(0xFFEC4899),
      const Color(0xFF0891B2),
      const Color(0xFF65A30D),
    ];
    
    final hash = name.codeUnits.fold(0, (a, b) => a + b);
    return colors[hash % colors.length];
  }

  String _getInitials(String? name) {
    if (name == null || name.isEmpty) return '?';
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }
}

class AppAvatarStack extends StatelessWidget {
  final List<String?> imageUrls;
  final List<String?> names;
  final double size;
  final int maxVisible;
  final double overlap;

  const AppAvatarStack({
    super.key,
    required this.imageUrls,
    required this.names,
    this.size = AppSpacing.avatarSizeMd,
    this.maxVisible = 4,
    this.overlap = 0.3,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final visibleUrls = imageUrls.take(maxVisible).toList();
    final visibleNames = names.take(maxVisible).toList();
    final remaining = imageUrls.length - maxVisible;

    return Stack(
      children: [
        ...visibleUrls.asMap().entries.map((entry) {
          final index = entry.key;
          final url = entry.value;
          final name = visibleNames[index];
          return Positioned(
            left: index * (size * (1 - overlap)),
            child: AppAvatar(
              imageUrl: url,
              name: name,
              size: size,
              showBorder: true,
            ),
          );
        }),
        if (remaining > 0)
          Positioned(
            left: maxVisible * (size * (1 - overlap)),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(size / 2),
                border: Border.all(color: theme.colorScheme.surface, width: 2),
              ),
              child: Center(
                child: Text(
                  '+$remaining',
                  style: AppTypography.labelMedium.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class AppBadge extends StatelessWidget {
  final String label;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final IconData? icon;
  final double fontSize;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final bool isDot;

  const AppBadge({
    super.key,
    required this.label,
    this.backgroundColor,
    this.foregroundColor,
    this.icon,
    this.fontSize = 11,
    this.padding,
    this.borderRadius,
    this.isDot = false,
  });

  const AppBadge.dot({
    super.key,
    required this.label,
    this.backgroundColor,
    this.foregroundColor,
    this.fontSize = 11,
    this.padding,
    this.borderRadius,
  }) : icon = null, isDot = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBgColor = backgroundColor ?? theme.colorScheme.primaryContainer;
    final effectiveFgColor = foregroundColor ?? theme.colorScheme.onPrimaryContainer;
    final effectiveRadius = borderRadius ?? BorderRadius.circular(AppSpacing.borderRadiusFull);

    return Container(
      padding: padding ?? EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
      decoration: BoxDecoration(
        color: effectiveBgColor,
        borderRadius: effectiveRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isDot) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: effectiveFgColor,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            SizedBox(width: AppSpacing.xs),
          ] else if (icon != null) ...[
            Icon(icon, size: fontSize + 2, color: effectiveFgColor),
            SizedBox(width: AppSpacing.xs),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: effectiveFgColor,
            ),
          ),
        ],
      ),
    );
  }
}

class AppStatusBadge extends StatelessWidget {
  final StockStatus? stockStatus;
  final PurchaseStatus? purchaseStatus;
  final ReorderUrgency? reorderUrgency;
  final PaymentMethod? paymentMethod;
  final bool showIcon;

  const AppStatusBadge({
    super.key,
    this.stockStatus,
    this.purchaseStatus,
    this.reorderUrgency,
    this.paymentMethod,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    if (stockStatus != null) {
      return AppBadge(
        label: stockStatus!.displayName,
        backgroundColor: stockStatus!.color.withAlphaValue(0.1),
        foregroundColor: stockStatus!.color,
        icon: showIcon ? stockStatus!.icon : null,
      );
    }
    
    if (purchaseStatus != null) {
      return AppBadge(
        label: purchaseStatus!.displayName,
        backgroundColor: purchaseStatus!.color.withAlphaValue(0.1),
        foregroundColor: purchaseStatus!.color,
        icon: showIcon ? _getPurchaseStatusIcon(purchaseStatus!) : null,
      );
    }
    
    if (reorderUrgency != null) {
      return AppBadge(
        label: reorderUrgency!.displayName,
        backgroundColor: reorderUrgency!.color.withAlphaValue(0.1),
        foregroundColor: reorderUrgency!.color,
        icon: showIcon ? reorderUrgency!.icon : null,
      );
    }
    
    if (paymentMethod != null) {
      return AppBadge(
        label: paymentMethod.toString().split('.').last,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        icon: showIcon ? _getPaymentMethodIcon(paymentMethod!) : null,
      );
    }
    
    return const SizedBox.shrink();
  }

  IconData _getPurchaseStatusIcon(PurchaseStatus status) {
    switch (status) {
      case PurchaseStatus.pending:
        return Icons.schedule_rounded;
      case PurchaseStatus.ordered:
        return Icons.shopping_cart_rounded;
      case PurchaseStatus.received:
        return Icons.check_circle_rounded;
      case PurchaseStatus.cancelled:
        return Icons.cancel_rounded;
    }
  }

  IconData _getPaymentMethodIcon(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cash:
        return Icons.payments_rounded;
      case PaymentMethod.upi:
        return Icons.phone_android_rounded;
      case PaymentMethod.card:
        return Icons.credit_card_rounded;
      case PaymentMethod.other:
        return Icons.more_horiz_rounded;
    }
  }
}