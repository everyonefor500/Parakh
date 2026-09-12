import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../providers/app_state_provider.dart';
import '../../router/app_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/inspection_card.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/section_header.dart';
import '../../widgets/empty_state.dart';

class OfficerDashboardScreen extends StatelessWidget {
  const OfficerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateProvider>();
    final recentScans = appState.allScans.take(3).toList();
    
    final totalScans = appState.allScans.length;
    final violationsCount = appState.allViolations.length;
    // Mock logic for notices issued (e.g. 1 notice per non-compliant verdict)
    // final noticesIssued = appState.allVerdicts.where((v) => v.status != VerdictStatus.compliant).length;

    return Scaffold(
      body: Stack(
        children: [
          // Subtle top glow
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 280,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    context.appColors.accentBlue.withValues(alpha: 0.07),
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                  horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header ────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Welcome back,',
                              style: AppTextStyles.bodyMedium),
                          SizedBox(height: 2),
                          Text('Officer', style: AppTextStyles.headlineLarge),
                        ],
                      ),
                      // Avatar with glow ring
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              context.appColors.accentBlue.withValues(alpha: 0.3),
                              context.appColors.accentBlue.withValues(alpha: 0.1),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  context.appColors.accentBlue.withValues(alpha: 0.25),
                              blurRadius: 16,
                              spreadRadius: 2,
                            ),
                          ],
                          border: Border.all(
                            color:
                                context.appColors.accentBlue.withValues(alpha: 0.4),
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          Symbols.person_rounded,
                          color: context.appColors.accentBlue,
                          size: 24,
                          fill: 1,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32),

                  // ── Stats ─────────────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          title: 'Total Scans',
                          value: totalScans.toString(),
                          icon: Symbols.qr_code_scanner_rounded,
                          iconColor: context.appColors.accentBlue,
                          trend: totalScans > 0 ? '↑ 100% this week' : null,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: StatCard(
                          title: 'Violations',
                          value: violationsCount.toString(),
                          icon: Symbols.assignment_late_rounded,
                          iconColor: context.appColors.statusViolationRed,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32),

                  // ── Quick Actions ─────────────────────────────
                  _buildQuickActions(context),
                  SizedBox(height: 32),

                  // ── Recent Inspections ────────────────────────
                  SectionHeader(
                    title: 'Recent Inspections',
                    actionText: 'View All',
                    onActionTap: () => context.go(AppRoutes.history),
                  ),

                  if (recentScans.isEmpty)
                    EmptyState(
                      icon: Symbols.inventory_2_rounded,
                      title: 'No inspections yet',
                      message: 'Tap the scan button to begin.',
                    )
                  else
                    ...recentScans.map((scan) {
                      final verdict = appState.verdictForScan(scan.id);
                      return InspectionCard(
                        scan: scan,
                        verdict: verdict,
                        productName: scan.productId == 'prod-haldiram'
                            ? "Haldiram's Aloo Bhujia Sev"
                            : scan.productId != null
                                ? 'Product ${scan.productId}'
                                : 'Unknown Product',
                        onTap: () {
                          if (verdict != null) {
                            context.push(AppRoutes.scanVerdict);
                          } else {
                            context.push(AppRoutes.scanExtracted);
                          }
                        },
                      );
                    }),

                  SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Actions', style: AppTextStyles.titleLarge),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _QuickActionTile(
                icon: Symbols.analytics_rounded,
                label: 'Analytics',
                color: context.appColors.statusReviewAmber,
                onTap: () => context.push(AppRoutes.analytics),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _QuickActionTile(
                icon: Symbols.history_rounded,
                label: 'History',
                color: context.appColors.statusCompliantGreen,
                onTap: () => context.go(AppRoutes.history),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _QuickActionTile(
                icon: Symbols.description_rounded,
                label: 'Reports',
                color: context.appColors.accentBlue,
                onTap: () => context.go(AppRoutes.reports),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _QuickActionTile(
                icon: Symbols.report_rounded,
                label: 'Grievances',
                color: context.appColors.statusViolationRed,
                onTap: () => context.push(AppRoutes.officerGrievances),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: context.appColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.appColors.cardBorder, width: 1),
          boxShadow: context.appColors.cardShadow,
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color.withValues(alpha: 0.18),
                    color.withValues(alpha: 0.07),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 20, fill: 1),
            ),
            SizedBox(height: 8),
            Text(label,
                style: AppTextStyles.overline
                    .copyWith(color: context.appColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
