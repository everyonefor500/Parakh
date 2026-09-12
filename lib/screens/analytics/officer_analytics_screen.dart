import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/stat_card.dart';

class OfficerAnalyticsScreen extends StatefulWidget {
  const OfficerAnalyticsScreen({super.key});

  @override
  State<OfficerAnalyticsScreen> createState() =>
      _OfficerAnalyticsScreenState();
}

class _OfficerAnalyticsScreenState extends State<OfficerAnalyticsScreen> {
  int _touchedBarIndex = -1;

  // Mock weekly scan data
  final List<double> _weeklyScanData = [24, 38, 31, 52, 47, 60, 44];
  final List<String> _weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  // Mock compliance rate (last 6 months)
  final List<FlSpot> _complianceSpots = [
    FlSpot(0, 72),
    FlSpot(1, 68),
    FlSpot(2, 75),
    FlSpot(3, 71),
    FlSpot(4, 78),
    FlSpot(5, 82),
  ];
  final List<String> _months = ['Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Analytics'),
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top Stats Row ─────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: 'This Month',
                    value: '296',
                    icon: Symbols.qr_code_scanner_rounded,
                    iconColor: context.appColors.accentBlue,
                    trend: '↑ 14%',
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    title: 'Compliant',
                    value: '82%',
                    icon: Symbols.check_circle_rounded,
                    iconColor: context.appColors.statusCompliantGreen,
                    trend: '↑ 4%',
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    title: 'Notices',
                    value: '12',
                    icon: Symbols.assignment_late_rounded,
                    iconColor: context.appColors.statusViolationRed,
                  ),
                ),
              ],
            ),
            SizedBox(height: 32),

            // ── Weekly Scans Bar Chart ────────────────────────────
            Text('Scans This Week', style: AppTextStyles.titleLarge),
            SizedBox(height: 4),
            Text('Daily scan volume', style: AppTextStyles.bodyMedium),
            SizedBox(height: 20),
            _buildBarChart(),
            SizedBox(height: 32),

            // ── Compliance Rate Line Chart ────────────────────────
            Text('Compliance Rate', style: AppTextStyles.titleLarge),
            SizedBox(height: 4),
            Text('6-month trend', style: AppTextStyles.bodyMedium),
            SizedBox(height: 20),
            _buildLineChart(),
            SizedBox(height: 32),

            // ── Violation Breakdown ───────────────────────────────
            Text('Top Violations', style: AppTextStyles.titleLarge),
            SizedBox(height: 16),
            _buildViolationBreakdown(),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart() {
    return Container(
      height: 200,
      padding: const EdgeInsets.fromLTRB(0, 16, 16, 0),
      decoration: BoxDecoration(
        color: context.appColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.appColors.cardBorder, width: 1),
        boxShadow: context.appColors.cardShadow,
      ),
      child: BarChart(
        BarChartData(
          barTouchData: BarTouchData(
            touchCallback: (event, response) {
              setState(() {
                if (response == null || response.spot == null) {
                  _touchedBarIndex = -1;
                } else {
                  _touchedBarIndex =
                      response.spot!.touchedBarGroupIndex;
                }
              });
            },
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) => context.appColors.cardBackgroundElevated,
              tooltipRoundedRadius: 8,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '${rod.toY.toInt()} scans',
                  AppTextStyles.labelSmall.copyWith(
                    color: context.appColors.accentBlue,
                    fontWeight: FontWeight.w700,
                  ),
                );
              },
            ),
          ),
          alignment: BarChartAlignment.spaceAround,
          maxY: 80,
          barGroups: _weeklyScanData.asMap().entries.map((entry) {
            final isTouched = entry.key == _touchedBarIndex;
            final isHighest = entry.value ==
                _weeklyScanData.reduce((a, b) => a > b ? a : b);
            return BarChartGroupData(
              x: entry.key,
              barRods: [
                BarChartRodData(
                  toY: entry.value,
                  width: 18,
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(6)),
                  gradient: LinearGradient(
                    colors: isTouched || isHighest
                        ? [
                            context.appColors.accentBlueGlow,
                            context.appColors.accentBlue,
                          ]
                        : [
                            context.appColors.bgTertiary,
                            context.appColors.bgSecondary,
                          ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: 80,
                    color: context.appColors.bgSecondary,
                  ),
                ),
              ],
            );
          }).toList(),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final idx = value.toInt();
                  if (idx < 0 || idx >= _weekDays.length) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _weekDays[idx],
                      style: AppTextStyles.overline,
                    ),
                  );
                },
                reservedSize: 28,
              ),
            ),
            leftTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 20,
            getDrawingHorizontalLine: (value) => FlLine(
              color: context.appColors.dividerSubtle,
              strokeWidth: 1,
              dashArray: [4, 6],
            ),
          ),
        ),
        swapAnimationDuration: const Duration(milliseconds: 300),
        swapAnimationCurve: Curves.easeOut,
      ),
    );
  }

  Widget _buildLineChart() {
    return Container(
      height: 180,
      padding: const EdgeInsets.fromLTRB(0, 16, 16, 8),
      decoration: BoxDecoration(
        color: context.appColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.appColors.cardBorder, width: 1),
        boxShadow: context.appColors.cardShadow,
      ),
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: 5,
          minY: 60,
          maxY: 90,
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => context.appColors.cardBackgroundElevated,
              tooltipRoundedRadius: 8,
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  return LineTooltipItem(
                    '${spot.y.toInt()}%',
                    AppTextStyles.labelSmall.copyWith(
                      color: context.appColors.statusCompliantGreen,
                      fontWeight: FontWeight.w700,
                    ),
                  );
                }).toList();
              },
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: _complianceSpots,
              isCurved: true,
              curveSmoothness: 0.35,
              color: context.appColors.statusCompliantGreen,
              barWidth: 2.5,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, bar, index) =>
                    FlDotCirclePainter(
                  radius: 4,
                  color: context.appColors.statusCompliantGreen,
                  strokeColor: context.appColors.cardBackground,
                  strokeWidth: 2,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    context.appColors.statusCompliantGreen.withValues(alpha: 0.2),
                    context.appColors.statusCompliantGreen.withValues(alpha: 0.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final idx = value.toInt();
                  if (idx < 0 || idx >= _months.length) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(_months[idx], style: AppTextStyles.overline),
                  );
                },
                reservedSize: 28,
              ),
            ),
            leftTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 10,
            getDrawingHorizontalLine: (value) => FlLine(
              color: context.appColors.dividerSubtle,
              strokeWidth: 1,
              dashArray: [4, 6],
            ),
          ),
        ),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      ),
    );
  }

  Widget _buildViolationBreakdown() {
    final items = [
      ('Missing Expiry Date', 0.42, context.appColors.statusViolationRed),
      ('Improper MRP Format', 0.28, context.appColors.statusReviewAmber),
      ('No Mfg Date', 0.18, context.appColors.accentBlue),
      ('Missing Net Qty', 0.12, context.appColors.textTertiary),
    ];

    return Column(
      children: items.map((item) {
        final (label, ratio, color) = item;
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(label, style: AppTextStyles.bodyMedium),
                  Text('${(ratio * 100).toInt()}%',
                      style: AppTextStyles.labelMedium
                          .copyWith(color: color)),
                ],
              ),
              SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: ratio,
                  minHeight: 6,
                  backgroundColor: context.appColors.bgTertiary,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
