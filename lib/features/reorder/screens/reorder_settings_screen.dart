import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/widgets.dart';
import '../providers/reorder_provider.dart';

class ReorderSettingsScreen extends ConsumerWidget {
  const ReorderSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final settingsAsync = ref.watch(reorderSettingsProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Reorder Settings')),
      body: settingsAsync.when(
        data: (settings) => _buildSettingsForm(context, theme, settings, ref),
        loading: () => Center(child: AppLoadingState(message: 'Loading settings...')),
        error: (error, stack) => AppErrorState(
          title: 'Failed to Load Settings',
          message: error.toString(),
          actionLabel: 'Retry',
          onAction: () => ref.invalidate(reorderSettingsProvider),
        ),
      ),
    );
  }

  Widget _buildSettingsForm(BuildContext context, ThemeData theme, ReorderSettings settings, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    int leadTime = settings.defaultLeadTimeDays ?? 7;
    int safetyStock = settings.defaultSafetyStockDays ?? 5;
    int lowStockDays = settings.lowStockAlertDays ?? 30;
    int deadStockDays = settings.deadStockAlertDays ?? 60;
    bool autoCalculate = settings.autoCalculateReorderPoint ?? true;
    bool enableNotifications = settings.enableNotifications ?? true;

    return SingleChildScrollView(
      padding: AppSpacing.screenPadding,
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(theme, 'Default Supplier Lead Time', 'Average days for supplier to deliver after order placed'),
            AppNumberField(
              initialValue: leadTime.toString(),
              label: 'Lead Time (days)',
              hint: '7',
              keyboardType: TextInputType.number,
              onChangedValue: (value) => leadTime = value.toInt(),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Required';
                if (int.tryParse(value) == null || int.parse(value) < 1) return 'Must be ≥ 1';
                return null;
              },
            ),
            SizedBox(height: AppSpacing.lg),
            
            _buildSectionHeader(theme, 'Default Safety Stock', 'Extra days of stock to keep as buffer'),
            AppNumberField(
              initialValue: safetyStock.toString(),
              label: 'Safety Stock (days)',
              hint: '5',
              keyboardType: TextInputType.number,
              onChangedValue: (value) => safetyStock = value.toInt(),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Required';
                if (int.tryParse(value) == null || int.parse(value) < 0) return 'Must be ≥ 0';
                return null;
              },
            ),
            SizedBox(height: AppSpacing.lg),

            _buildSectionHeader(theme, 'Low Stock Alert Threshold', 'Alert when stock will run out within this many days'),
            AppNumberField(
              initialValue: lowStockDays.toString(),
              label: 'Low Stock Alert (days)',
              hint: '30',
              keyboardType: TextInputType.number,
              onChangedValue: (value) => lowStockDays = value.toInt(),
            ),
            SizedBox(height: AppSpacing.lg),

            _buildSectionHeader(theme, 'Dead Stock Alert Threshold', 'Alert when product has not sold for this many days'),
            AppNumberField(
              initialValue: deadStockDays.toString(),
              label: 'Dead Stock Alert (days)',
              hint: '60',
              keyboardType: TextInputType.number,
              onChangedValue: (value) => deadStockDays = value.toInt(),
            ),
            SizedBox(height: AppSpacing.lg),

            _buildSectionHeader(theme, 'Automation', 'Automated reorder calculations'),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('Auto-calculate reorder points', style: AppTypography.bodyLarge),
              subtitle: Text('Automatically calculate reorder points based on sales history', style: AppTypography.bodySmall),
              value: autoCalculate,
              onChanged: (value) => autoCalculate = value,
              activeColor: theme.colorScheme.primary,
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('Enable reorder notifications', style: AppTypography.bodyLarge),
              subtitle: Text('Receive push notifications when reorder is recommended', style: AppTypography.bodySmall),
              value: enableNotifications,
              onChanged: (value) => enableNotifications = value,
              activeColor: theme.colorScheme.primary,
            ),
            SizedBox(height: AppSpacing.xl),

            _buildSectionHeader(theme, 'How Reorder Calculation Works', 'Understanding the smart reorder algorithm'),
            AppCard(
              padding: AppSpacing.cardPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFormulaRow(theme, 'Reorder Point', '= Average Daily Sales × Lead Time + Safety Stock'),
                  SizedBox(height: AppSpacing.md),
                  _buildFormulaRow(theme, 'Average Daily Sales', '= Total Sales (last 30 days) ÷ 30'),
                  SizedBox(height: AppSpacing.md),
                  _buildFormulaRow(theme, 'Days Remaining', '= Current Stock ÷ Average Daily Sales'),
                  SizedBox(height: AppSpacing.md),
                  _buildFormulaRow(theme, 'Suggested Order', '= Maximum Stock - Current Stock'),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.xl),

            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'Cancel',
                    onPressed: () => context.pop(),
                    variant: AppButtonVariant.tertiary,
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: AppButton(
                    label: 'Save Settings',
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        ref.read(reorderNotifierProvider.notifier).updateSettings(ReorderSettingsUpdateRequest(
                          defaultLeadTimeDays: leadTime,
                          defaultSafetyStockDays: safetyStock,
                          lowStockAlertDays: lowStockDays,
                          deadStockAlertDays: deadStockDays,
                          autoCalculateReorderPoint: autoCalculate,
                          enableNotifications: enableNotifications,
                        )).then((_) {
                          context.pop();
                          showAppSnackBar(
                            context: context,
                            message: 'Settings saved successfully',
                            type: AppSnackBarType.success,
                          );
                        }).catchError((error) {
                          showAppSnackBar(
                            context: context,
                            message: error.toString(),
                            type: AppSnackBarType.error,
                          );
                        });
                      }
                    },
                    variant: AppButtonVariant.primary,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTypography.titleLarge),
        SizedBox(height: AppSpacing.xs),
        Text(subtitle, style: AppTypography.bodyMedium),
        SizedBox(height: AppSpacing.md),
      ],
    );
  }

  Widget _buildFormulaRow(ThemeData theme, String label, String formula) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140,
          child: Text(label, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w500)),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
            ),
            child: Text(formula, style: AppTypography.bodyMedium.copyWith(fontFamily: 'monospace')),
          ),
        ),
      ],
    );
  }
}