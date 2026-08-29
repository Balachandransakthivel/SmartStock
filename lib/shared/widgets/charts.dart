import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_constants.dart';

class AppLineChart extends StatelessWidget {
  final List<FlSpot> spots;
  final List<String> xLabels;
  final Color? lineColor;
  final Color? gradientStart;
  final Color? gradientEnd;
  final double? minY;
  final double? maxY;
  final double height;
  final bool showDots;
  final bool showGrid;
  final String? yAxisLabel;
  final ValueChanged<FlSpot>? onSpotTouched;

  const AppLineChart({
    super.key,
    required this.spots,
    required this.xLabels,
    this.lineColor,
    this.gradientStart,
    this.gradientEnd,
    this.minY,
    this.maxY,
    this.height = AppSpacing.chartHeightMd,
    this.showDots = false,
    this.showGrid = true,
    this.yAxisLabel,
    this.onSpotTouched,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveLineColor = lineColor ?? theme.colorScheme.primary;
    final effectiveGradientStart = gradientStart ?? effectiveLineColor.withAlphaValue(0.3);
    final effectiveGradientEnd = gradientEnd ?? effectiveLineColor.withAlphaValue(0.0);

    return SizedBox(
      height: height,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: (spots.length - 1).toDouble(),
          minY: minY,
          maxY: maxY,
          gridData: FlGridData(
            show: showGrid,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) => FlLine(
              color: theme.dividerColor,
              strokeWidth: 0.5,
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 50,
                interval: _calculateInterval(minY, maxY),
                getTitlesWidget: (value, meta) => _buildYAxisLabel(value, theme),
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 1,
                getTitlesWidget: (value, meta) => _buildXAxisLabel(value, theme),
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              gradient: LinearGradient(
                colors: [effectiveGradientStart, effectiveGradientEnd],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: showDots,
                getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                  radius: 4,
                  color: effectiveLineColor,
                  strokeWidth: 2,
                  strokeColor: theme.colorScheme.surface,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    effectiveLineColor.withAlphaValue(0.15),
                    effectiveLineColor.withAlphaValue(0.02),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            enabled: onSpotTouched != null,
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: theme.colorScheme.inverseSurface,
              tooltipRoundedRadius: AppSpacing.borderRadiusMd,
              getTooltipItems: (touchedSpots) => touchedSpots.map((spot) {
                final index = spot.x.toInt();
                final label = index < xLabels.length ? xLabels[index] : '';
                return LineTooltipItem(
                  '$label\n${AppConstants.currencySymbol}${spot.y.toStringAsFixed(0)}',
                  AppTypography.bodySmall.copyWith(color: theme.colorScheme.inverseOnSurface),
                );
              }).toList(),
            ),
            handleBuiltInTouches: true,
            getTouchedSpotIndicator: (barData, spotIndexes) => spotIndexes.map((index) {
              return TouchedSpotIndicatorData(
                FlLine(color: effectiveLineColor, strokeWidth: 2),
                FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                    radius: 6,
                    color: effectiveLineColor,
                    strokeWidth: 3,
                    strokeColor: theme.colorScheme.surface,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  double _calculateInterval(double? minY, double? maxY) {
    if (minY == null || maxY == null) return 1;
    final range = maxY - minY;
    if (range <= 10) return 1;
    if (range <= 50) return 5;
    if (range <= 100) return 10;
    if (range <= 500) return 50;
    return 100;
  }

  Widget _buildYAxisLabel(double value, ThemeData theme) {
    return SideTitleWidget(
      axisSide: AxisSide.left,
      child: Text(
        _formatNumber(value),
        style: AppTypography.bodySmall.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _buildXAxisLabel(double value, ThemeData theme) {
    final index = value.toInt();
    if (index < 0 || index >= xLabels.length) return const SizedBox.shrink();
    
    return SideTitleWidget(
      axisSide: AxisSide.bottom,
      child: Padding(
        padding: EdgeInsets.only(top: AppSpacing.xs),
        child: Text(
          xLabels[index],
          style: AppTypography.bodySmall.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  String _formatNumber(double value) {
    if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)}M';
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
    return value.toStringAsFixed(0);
  }
}

class AppBarChart extends StatelessWidget {
  final List<BarChartGroupData> barGroups;
  final List<String> xLabels;
  final Color? barColor;
  final double height;
  final double? maxY;
  final ValueChanged<BarChartGroupData>? onBarTouched;

  const AppBarChart({
    super.key,
    required this.barGroups,
    required this.xLabels,
    this.barColor,
    this.height = AppSpacing.chartHeightMd,
    this.maxY,
    this.onBarTouched,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBarColor = barColor ?? theme.colorScheme.primary;

    return SizedBox(
      height: height,
      child: BarChart(
        BarChartData(
          maxY: maxY,
          barGroups: barGroups,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) => FlLine(
              color: theme.dividerColor,
              strokeWidth: 0.5,
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 50,
                getTitlesWidget: (value, meta) => SideTitleWidget(
                  axisSide: AxisSide.left,
                  child: Text(
                    _formatNumber(value),
                    style: AppTypography.bodySmall.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= xLabels.length) return const SizedBox.shrink();
                  return SideTitleWidget(
                    axisSide: AxisSide.bottom,
                    child: Padding(
                      padding: EdgeInsets.only(top: AppSpacing.xs),
                      child: Text(
                        xLabels[index],
                        style: AppTypography.bodySmall.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          barTouchData: BarTouchData(
            enabled: onBarTouched != null,
            touchTooltipData: BarTouchTooltipData(
              tooltipBgColor: theme.colorScheme.inverseSurface,
              tooltipRoundedRadius: AppSpacing.borderRadiusMd,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '${xLabels[groupIndex]}\n${AppConstants.currencySymbol}${rod.toY.toStringAsFixed(0)}',
                  AppTypography.bodySmall.copyWith(color: theme.colorScheme.inverseOnSurface),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  String _formatNumber(double value) {
    if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)}M';
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
    return value.toStringAsFixed(0);
  }
}

class AppPieChart extends StatelessWidget {
  final List<PieChartSectionData> sections;
  final double height;
  final double radius;
  final ValueChanged<PieChartSectionData>? onSectionTouched;

  const AppPieChart({
    super.key,
    required this.sections,
    this.height = AppSpacing.chartHeightMd,
    this.radius = 80,
    this.onSectionTouched,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: height,
      child: PieChart(
        PieChartData(
          sections: sections,
          centerSpaceRadius: radius * 0.6,
          sectionsSpace: 2,
          pieTouchData: PieTouchData(
            enabled: onSectionTouched != null,
            touchCallback: (event, response) {
              if (response != null && response.touchedSection != null) {
                onSectionTouched?.call(response.touchedSection!);
              }
            },
          ),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }
}

class AppChartLegend extends StatelessWidget {
  final List<ChartLegendItem> items;
  final int maxColumns;

  const AppChartLegend({
    super.key,
    required this.items,
    this.maxColumns = 3,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.sm,
      children: items.map((item) => _buildLegendItem(theme, item)).toList(),
    );
  }

  Widget _buildLegendItem(ThemeData theme, ChartLegendItem item) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: item.color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: AppSpacing.xs),
        Text(item.label, style: AppTypography.bodySmall),
        if (item.value != null) ...[
          SizedBox(width: AppSpacing.xs),
          Text(
            item.value!,
            style: AppTypography.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ],
    );
  }
}

class ChartLegendItem {
  final String label;
  final Color color;
  final String? value;

  const ChartLegendItem({
    required this.label,
    required this.color,
    this.value,
  });
}

List<BarChartGroupData> createBarGroups({
  required List<double> values,
  required Color color,
  double width = 16,
  double spacing = 4,
}) {
  return values.asMap().entries.map((entry) {
    return BarChartGroupData(
      x: entry.key,
      barRods: [
        BarChartRodData(
          toY: entry.value,
          color: color,
          width: width,
          borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
        ),
      ],
    );
  }).toList();
}

List<FlSpot> createFlSpots(List<double> values) {
  return values.asMap().entries.map((entry) {
    return FlSpot(entry.key.toDouble(), entry.value);
  }).toList();
}

List<PieChartSectionData> createPieSections({
  required List<double> values,
  required List<Color> colors,
  required List<String> labels,
  double radius = 80,
}) {
  final total = values.reduce((a, b) => a + b);
  return values.asMap().entries.map((entry) {
    final percentage = total > 0 ? (entry.value / total) * 100 : 0;
    return PieChartSectionData(
      value: entry.value,
      color: colors[entry.key % colors.length],
      title: '${percentage.toStringAsFixed(1)}%',
      radius: radius,
      titleStyle: AppTypography.labelSmall.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      badgeWidget: percentage > 10 ? Text(
        labels[entry.key % labels.length],
        style: AppTypography.bodySmall.copyWith(color: Colors.white),
      ) : null,
      badgePositionPercentageOffset: 1.3,
    );
  }).toList();
}