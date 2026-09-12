import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../router/app_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/secondary_button.dart';
import '../../providers/scan_flow_provider.dart';
import 'package:provider/provider.dart';
import '../../models/compliance_verdict.dart';

class VerdictScreen extends StatefulWidget {
  const VerdictScreen({super.key});

  @override
  State<VerdictScreen> createState() => _VerdictScreenState();
}

class _VerdictScreenState extends State<VerdictScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _entryController;
  late Animation<double> _iconScale;
  late Animation<double> _iconFade;
  late Animation<double> _glowOpacity;
  late Animation<Offset> _contentSlide;
  late Animation<double> _contentFade;

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _iconFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _entryController,
          curve: const Interval(0.0, 0.5, curve: Curves.easeOut)),
    );
    _iconScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
          parent: _entryController,
          curve: const Interval(0.0, 0.6, curve: Curves.elasticOut)),
    );
    _glowOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _entryController,
          curve: const Interval(0.3, 0.9, curve: Curves.easeOut)),
    );
    _contentSlide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOut)));
    _contentFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _entryController,
          curve: const Interval(0.4, 0.9, curve: Curves.easeOut)),
    );

    _entryController.forward();
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final verdict = context.watch<ScanFlowProvider>().mockVerdict;

    
    if (verdict == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final isCompliant = verdict.status == VerdictStatus.compliant;
    final score = verdict.complianceScore;
    
    Color scoreColor;
    if (score >= 90) {
      scoreColor = context.appColors.statusCompliantGreen;
    } else if (score >= 70) {
      scoreColor = context.appColors.statusReviewAmber;
    } else {
      scoreColor = context.appColors.statusViolationRed;
    }

    final verdictColor = isCompliant
        ? context.appColors.statusCompliantGreen
        : context.appColors.statusViolationRed;
    final verdictGlow = isCompliant
        ? context.appColors.statusCompliantGlow
        : context.appColors.statusViolationGlow;
    final verdictIcon =
        isCompliant ? Symbols.check_circle_rounded : Symbols.cancel_rounded;
    final verdictLabel = isCompliant ? 'Compliant' : 'Non-Compliant';
    final verdictMessage = verdict.summary;
    
    // Build Checklist logic dynamically from evaluated rules
    final checklist = context.watch<ScanFlowProvider>().evaluatedRules;

    return Scaffold(
      body: Stack(
        children: [
          // Background tint matching verdict
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  verdictColor.withValues(alpha: 0.07),
                  context.appColors.bgPrimary,
                ],
                radius: 1.0,
                center: const Alignment(0, -0.4),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                children: [
                  // Scrollable content
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 16),
                          // Animated icon with glow
                          Center(
                            child: AnimatedBuilder(
                              animation: _entryController,
                              builder: (context, child) => Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Glow halo
                                  Opacity(
                                    opacity: _glowOpacity.value,
                                    child: Container(
                                      width: 140,
                                      height: 140,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: RadialGradient(
                                          colors: [
                                            verdictGlow.withValues(alpha: 0.18),
                                            verdictGlow.withValues(alpha: 0.0),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Icon
                                  FadeTransition(
                                    opacity: _iconFade,
                                    child: ScaleTransition(
                                      scale: _iconScale,
                                      child: Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: verdictColor.withValues(alpha: 0.1),
                                          border: Border.all(
                                            color: verdictColor.withValues(alpha: 0.25),
                                            width: 1.5,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: verdictGlow.withValues(alpha: 0.3),
                                              blurRadius: 32,
                                              spreadRadius: 4,
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          verdictIcon,
                                          color: verdictColor,
                                          size: 40,
                                          fill: 1,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Label + description
                          AnimatedBuilder(
                            animation: _entryController,
                            builder: (context, child) => FadeTransition(
                              opacity: _contentFade,
                              child: SlideTransition(
                                position: _contentSlide,
                                child: child,
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  verdictLabel,
                                  style: AppTextStyles.displayLarge.copyWith(
                                    color: verdictColor,
                                    letterSpacing: -0.8,
                                    fontSize: 28,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  verdictMessage,
                                  style: AppTextStyles.bodyMedium,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 24),
                                
                                // Circular Progress & Donut Chart Row
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Circular Score Widget
                                    Container(
                                      width: 140,
                                      height: 140,
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: scoreColor.withValues(alpha: 0.05),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          SizedBox(
                                            width: 100,
                                            height: 100,
                                            child: CircularProgressIndicator(
                                              value: score / 100,
                                              strokeWidth: 8,
                                              color: scoreColor,
                                              backgroundColor: scoreColor.withValues(alpha: 0.15),
                                              strokeCap: StrokeCap.round,
                                            ),
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                '${score.toStringAsFixed(0)}%',
                                                style: AppTextStyles.titleLarge.copyWith(
                                                  color: scoreColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 24,
                                                ),
                                              ),
                                              Text(
                                                'Score',
                                                style: AppTextStyles.labelSmall.copyWith(
                                                  color: scoreColor.withValues(alpha: 0.8),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 24),
                                    // Visual Breakdown Chart (fl_chart)
                                    SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: PieChart(
                                        PieChartData(
                                          sectionsSpace: 4,
                                          centerSpaceRadius: 30,
                                          sections: [
                                            PieChartSectionData(
                                              value: verdict.checksPassed.toDouble(),
                                              color: context.appColors.statusCompliantGreen,
                                              title: '${verdict.checksPassed}',
                                              radius: 12,
                                              titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                                            ),
                                            PieChartSectionData(
                                              value: (verdict.checksTotal - verdict.checksPassed).toDouble(),
                                              color: context.appColors.statusViolationRed,
                                              title: '${verdict.checksTotal - verdict.checksPassed}',
                                              radius: 12,
                                              titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  '${verdict.checksPassed} Passed, ${verdict.checksTotal - verdict.checksPassed} Failed',
                                  style: AppTextStyles.labelSmall.copyWith(color: Colors.grey.shade600),
                                ),
                                const SizedBox(height: 24),
                                
                                // Checklist section
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: context.appColors.cardBorder),
                                    boxShadow: context.appColors.cardShadow,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Evaluation Checklist', style: AppTextStyles.titleMedium),
                                      const SizedBox(height: 12),
                                      ...checklist.map((item) {
                                        final bool passed = item['passed'] as bool;
                                        return Padding(
                                          padding: const EdgeInsets.only(bottom: 8.0),
                                          child: Row(
                                            children: [
                                              Icon(
                                                passed ? Symbols.check_circle_rounded : Symbols.cancel_rounded,
                                                color: passed ? context.appColors.statusCompliantGreen : context.appColors.statusViolationRed,
                                                size: 20,
                                                fill: 1,
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Text(
                                                  item['name'] as String,
                                                  style: AppTextStyles.bodyMedium.copyWith(
                                                    color: passed ? Colors.black87 : context.appColors.statusViolationRed,
                                                    fontWeight: passed ? FontWeight.normal : FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),

                  // Actions at bottom
                  AnimatedBuilder(
                    animation: _contentFade,
                    builder: (context, child) =>
                        Opacity(opacity: _contentFade.value, child: child),
                    child: Row(
                      children: [
                        Expanded(
                          child: SecondaryButton(
                            text: 'Home',
                            onPressed: () => context.go(AppRoutes.home),
                          ),
                        ),
                        const SizedBox(width: 12),
                        if (!isCompliant)
                          Expanded(
                            flex: 2,
                            child: PrimaryButton(
                              text: 'View Violations',
                              icon: Symbols.warning_rounded,
                              onPressed: () => context.push(
                                AppRoutes.violationDetails
                                    .replaceAll(':id', verdict.scanId),
                              ),
                            ),
                          )
                        else
                          Expanded(
                            flex: 2,
                            child: PrimaryButton(
                              text: 'Generate Report',
                              icon: Symbols.description_rounded,
                              onPressed: () {
                                final route = AppRoutes.reportGeneration.replaceAll(':verdictId', verdict.id);
                                debugPrint('[NAV_LOG] Tapping Generate Report in VerdictScreen. Verdict ID: ${verdict.id}');
                                debugPrint('[NAV_LOG] Pushing route: $route');
                                context.push(route);
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
