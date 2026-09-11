import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../router/app_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/section_header.dart';
import '../../widgets/empty_state.dart';

class ConsumerHomeScreen extends StatelessWidget {
  const ConsumerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                    AppColors.statusReviewAmber.withValues(alpha: 0.05),
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
                  // ── Header ─────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Hello,', style: AppTextStyles.bodyMedium),
                          const SizedBox(height: 2),
                          Text('Consumer',
                              style: AppTextStyles.headlineLarge),
                        ],
                      ),
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              AppColors.statusReviewAmber
                                  .withValues(alpha: 0.3),
                              AppColors.statusReviewAmber
                                  .withValues(alpha: 0.1),
                            ],
                          ),
                          border: Border.all(
                            color: AppColors.statusReviewAmber
                                .withValues(alpha: 0.4),
                            width: 1.5,
                          ),
                        ),
                        child: const Icon(
                          Symbols.person_rounded,
                          color: AppColors.statusReviewAmber,
                          size: 24,
                          fill: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // ── Hero CTA ────────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.accentBlue,
                          AppColors.accentBlueDark,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accentBlue.withValues(alpha: 0.35),
                          blurRadius: 28,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Verify Your Purchases',
                          style: AppTextStyles.titleLarge.copyWith(
                              color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Scan any product label to instantly check compliance with Legal Metrology standards.',
                          style: AppTextStyles.bodyMedium.copyWith(
                              color: Colors.white.withValues(alpha: 0.75)),
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () => context.push(AppRoutes.scan),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.15),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Symbols.qr_code_scanner_rounded,
                                    color: AppColors.accentBlue, size: 20, fill: 1),
                                const SizedBox(width: 8),
                                Text(
                                  'Scan Now',
                                  style: AppTextStyles.labelLarge.copyWith(
                                    color: AppColors.accentBlue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // ── Stats ──────────────────────────────────
                  const Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          title: 'My Scans',
                          value: '12',
                          icon: Symbols.history_rounded,
                          iconColor: AppColors.accentBlue,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: StatCard(
                          title: 'Grievances',
                          value: '1',
                          icon: Symbols.report_problem_rounded,
                          iconColor: AppColors.statusReviewAmber,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // ── Recent Activity ─────────────────────────
                  SectionHeader(
                    title: 'Recent Activity',
                    actionText: 'View All',
                    onActionTap: () => context.go(AppRoutes.history),
                  ),
                  EmptyState(
                    icon: Symbols.receipt_long_rounded,
                    title: 'No recent activity',
                    message: 'Products you scan will appear here.',
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.statusViolationRed.withValues(alpha: 0.35),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          heroTag: 'consumer_grievance_fab',
          onPressed: () => context.push(AppRoutes.consumerGrievance),
          backgroundColor: AppColors.statusViolationRed,
          elevation: 0,
          icon: const Icon(Symbols.report_rounded,
              color: Colors.white, size: 20, fill: 1),
          label: Text('File Grievance',
              style: AppTextStyles.labelLarge.copyWith(color: Colors.white)),
        ),
      ),
    );
  }
}
