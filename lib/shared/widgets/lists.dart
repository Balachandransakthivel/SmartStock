import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

class AppListTile extends StatelessWidget {
  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final EdgeInsets? contentPadding;
  final Color? tileColor;
  final Color? selectedTileColor;
  final bool selected;
  final bool enabled;
  final ShapeBorder? shape;

  const AppListTile({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.contentPadding,
    this.tileColor,
    this.selectedTileColor,
    this.selected = false,
    this.enabled = true,
    this.shape,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: leading,
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      onTap: enabled ? onTap : null,
      onLongPress: enabled ? onLongPress : null,
      contentPadding: contentPadding ?? AppSpacing.listItemPadding,
      tileColor: selected ? (selectedTileColor ?? theme.colorScheme.primaryContainer) : tileColor,
      selected: selected,
      enabled: enabled,
      shape: shape ?? RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
      ),
      minLeadingWidth: AppSpacing.iconSizeLg,
      horizontalTitleGap: AppSpacing.md,
      minVerticalPadding: AppSpacing.sm,
    );
  }
}

class AppProductTile extends StatelessWidget {
  final String name;
  final String sku;
  final String? category;
  final int currentStock;
  final int minimumStock;
  final double sellingPrice;
  final String? imageUrl;
  final StockStatus status;
  final VoidCallback? onTap;
  final VoidCallback? onStockIn;
  final VoidCallback? onStockOut;
  final VoidCallback? onEdit;
  final bool showActions;

  const AppProductTile({
    super.key,
    required this.name,
    required this.sku,
    this.category,
    required this.currentStock,
    required this.minimumStock,
    required this.sellingPrice,
    this.imageUrl,
    required this.status,
    this.onTap,
    this.onStockIn,
    this.onStockOut,
    this.onEdit,
    this.showActions = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customTheme = context.customTheme;
    final isLowStock = status == StockStatus.lowStock;
    final isOutOfStock = status == StockStatus.outOfStock;

    return AppCard(
      onTap: onTap,
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      padding: AppSpacing.cardPadding,
      child: Row(
        children: [
          _buildImage(theme),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: AppTypography.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    _buildStatusChip(theme, customTheme),
                  ],
                ),
                SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Text('SKU: $sku', style: AppTypography.bodySmall),
                    if (category != null) ...[
                      SizedBox(width: AppSpacing.md),
                      Text(category!, style: AppTypography.bodySmall),
                    ],
                  ],
                ),
                SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    _buildStockInfo(theme, customTheme),
                    SizedBox(width: AppSpacing.lg),
                    Text(
                      '${AppConstants.currencySymbol}${sellingPrice.toStringAsFixed(2)}',
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (showActions) _buildActions(theme),
        ],
      ),
    );
  }

  Widget _buildImage(ThemeData theme) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
      ),
      child: imageUrl != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
              child: Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.inventory_2_rounded,
                  color: theme.colorScheme.onSurfaceVariant,
                  size: AppSpacing.iconSizeLg,
                ),
              ),
            )
          : Icon(
              Icons.inventory_2_rounded,
              color: theme.colorScheme.onSurfaceVariant,
              size: AppSpacing.iconSizeLg,
            ),
    );
  }

  Widget _buildStatusChip(ThemeData theme, AppCustomTheme customTheme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
      decoration: BoxDecoration(
        color: status.color.withAlphaValue(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: 10, color: status.color),
          SizedBox(width: 4),
          Text(
            status.displayName,
            style: AppTypography.labelSmall.copyWith(color: status.color),
          ),
        ],
      ),
    );
  }

  Widget _buildStockInfo(ThemeData theme, AppCustomTheme customTheme) {
    final isLowStock = status == StockStatus.lowStock;
    final isOutOfStock = status == StockStatus.outOfStock;
    
    return Row(
      children: [
        Icon(
          isOutOfStock 
              ? Icons.cancel 
              : (isLowStock ? Icons.warning_amber_rounded : Icons.check_circle),
          size: 14,
          color: isOutOfStock 
              ? customTheme.criticalColor 
              : (isLowStock ? customTheme.warningColor : customTheme.successColor),
        ),
        SizedBox(width: 4),
        Text(
          '$currentStock',
          style: AppTypography.titleSmall.copyWith(
            fontWeight: FontWeight.w600,
            color: isOutOfStock 
                ? customTheme.criticalColor 
                : (isLowStock ? customTheme.warningColor : theme.colorScheme.onSurface),
          ),
        ),
        Text(
          isOutOfStock ? ' Out of Stock' : (isLowStock ? ' Low' : ' In Stock'),
          style: AppTypography.bodySmall.copyWith(
            color: isOutOfStock 
                ? customTheme.criticalColor 
                : (isLowStock ? customTheme.warningColor : theme.colorScheme.onSurfaceVariant),
          ),
        ),
      ],
    );
  }

  Widget _buildActions(ThemeData theme) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert_rounded, color: theme.colorScheme.onSurfaceVariant),
      itemBuilder: (context) => [
        if (onStockIn != null)
          PopupMenuItem(
            value: 'stock_in',
            child: Row(
              children: [
                Icon(Icons.add_circle_outline_rounded, size: 18, color: theme.colorScheme.onSurface),
                SizedBox(width: AppSpacing.sm),
                Text('Stock In', style: AppTypography.bodyMedium),
              ],
            ),
          ),
        if (onStockOut != null)
          PopupMenuItem(
            value: 'stock_out',
            child: Row(
              children: [
                Icon(Icons.remove_circle_outline_rounded, size: 18, color: theme.colorScheme.onSurface),
                SizedBox(width: AppSpacing.sm),
                Text('Stock Out', style: AppTypography.bodyMedium),
              ],
            ),
          ),
        if (onEdit != null)
          PopupMenuItem(
            value: 'edit',
            child: Row(
              children: [
                Icon(Icons.edit_rounded, size: 18, color: theme.colorScheme.onSurface),
                SizedBox(width: AppSpacing.sm),
                Text('Edit', style: AppTypography.bodyMedium),
              ],
            ),
          ),
      ],
      onSelected: (value) {
        switch (value) {
          case 'stock_in': onStockIn?.call(); break;
          case 'stock_out': onStockOut?.call(); break;
          case 'edit': onEdit?.call(); break;
        }
      },
    );
  }
}

class AppSupplierTile extends StatelessWidget {
  final String companyName;
  final String contactPerson;
  final String phone;
  final String email;
  final double? totalPurchases;
  final double? pendingPayments;
  final int? productsSupplied;
  final VoidCallback? onTap;

  const AppSupplierTile({
    super.key,
    required this.companyName,
    required this.contactPerson,
    required this.phone,
    required this.email,
    this.totalPurchases,
    this.pendingPayments,
    this.productsSupplied,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      onTap: onTap,
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      padding: AppSpacing.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Text(
                  companyName.isNotEmpty ? companyName[0].toUpperCase() : 'S',
                  style: AppTypography.titleMedium.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(companyName, style: AppTypography.titleMedium),
                    Text(contactPerson, style: AppTypography.bodySmall),
                  ],
                ),
              ),
              if (pendingPayments != null && pendingPayments! > 0)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(AppSpacing.borderRadiusFull),
                  ),
                  child: Text(
                    '₹${pendingPayments!.toStringAsFixed(0)} pending',
                    style: AppTypography.labelSmall.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Icon(Icons.phone_rounded, size: 16, color: theme.colorScheme.onSurfaceVariant),
              SizedBox(width: AppSpacing.xs),
              Text(phone, style: AppTypography.bodySmall),
              SizedBox(width: AppSpacing.md),
              Icon(Icons.email_rounded, size: 16, color: theme.colorScheme.onSurfaceVariant),
              SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  email,
                  style: AppTypography.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (totalPurchases != null || productsSupplied != null) ...[
            SizedBox(height: AppSpacing.md),
            Row(
              children: [
                if (totalPurchases != null) ...[
                  _buildStat(theme, 'Purchases', '${AppConstants.currencySymbol}${totalPurchases!.toStringAsFixed(0)}'),
                ],
                if (productsSupplied != null) ...[
                  SizedBox(width: AppSpacing.lg),
                  _buildStat(theme, 'Products', productsSupplied.toString()),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStat(ThemeData theme, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.labelSmall.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        Text(value, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class AppSeparator extends StatelessWidget {
  final double height;
  final Color? color;
  final double indent;
  final double endIndent;

  const AppSeparator({
    super.key,
    this.height = 0.5,
    this.color,
    this.indent = 0,
    this.endIndent = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: height,
      thickness: height,
      color: color ?? Theme.of(context).dividerColor,
      indent: indent,
      endIndent: endIndent,
    );
  }
}

class AppSectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? action;
  final bool showDivider;

  const AppSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.action,
    this.showDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.titleLarge),
                  if (subtitle != null)
                    Text(subtitle!, style: AppTypography.bodyMedium),
                ],
              ),
            ),
            if (action != null) action!,
          ],
        ),
        if (showDivider) ...[
          SizedBox(height: AppSpacing.sm),
          AppSeparator(),
        ],
      ],
    );
  }
}