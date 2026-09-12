import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../providers/app_state_provider.dart';
import '../../router/app_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/section_header.dart';
import '../../widgets/empty_state.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class ConsumerHomeScreen extends StatefulWidget {
  const ConsumerHomeScreen({super.key});

  @override
  State<ConsumerHomeScreen> createState() => _ConsumerHomeScreenState();
}

class _ConsumerHomeScreenState extends State<ConsumerHomeScreen> {
  int _grievancesCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchGrievancesCount();
  }

  Future<void> _fetchGrievancesCount() async {
    final user = context.read<AppStateProvider>().currentUser;
    if (user != null) {
      try {
        final response = await Supabase.instance.client
            .from('complaints')
            .select('id')
            .eq('submitted_by', user.id);
        if (mounted) {
          setState(() {
            _grievancesCount = (response as List).length;
          });
        }
      } catch (e) {
        debugPrint('Error fetching grievances count: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateProvider>();
    final scansCount = appState.allScans.length;
    final recentScans = appState.allScans.take(3).toList();
    
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
                    context.appColors.statusReviewAmber.withValues(alpha: 0.05),
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
                          SizedBox(height: 2),
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
                              context.appColors.statusReviewAmber
                                  .withValues(alpha: 0.3),
                              context.appColors.statusReviewAmber
                                  .withValues(alpha: 0.1),
                            ],
                          ),
                          border: Border.all(
                            color: context.appColors.statusReviewAmber
                                .withValues(alpha: 0.4),
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          Symbols.person_rounded,
                          color: context.appColors.statusReviewAmber,
                          size: 24,
                          fill: 1,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32),

                  // ── Hero CTA ────────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          context.appColors.accentBlue,
                          context.appColors.accentBlueDark,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: context.appColors.accentBlue.withValues(alpha: 0.35),
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
                        SizedBox(height: 8),
                        Text(
                          'Scan any product label to instantly check compliance with Legal Metrology standards.',
                          style: AppTextStyles.bodyMedium.copyWith(
                              color: Colors.white.withValues(alpha: 0.75)),
                        ),
                        SizedBox(height: 20),
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
                                Icon(Symbols.qr_code_scanner_rounded,
                                    color: context.appColors.accentBlue, size: 20, fill: 1),
                                SizedBox(width: 8),
                                Text(
                                  'Scan Now',
                                  style: AppTextStyles.labelLarge.copyWith(
                                    color: context.appColors.accentBlue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32),

                  // ── Stats ──────────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          title: 'My Scans',
                          value: scansCount.toString(),
                          icon: Symbols.history_rounded,
                          iconColor: context.appColors.accentBlue,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => context.push(AppRoutes.consumerGrievancesList),
                          child: StatCard(
                            title: 'Grievances',
                            value: _grievancesCount.toString(),
                            icon: Symbols.report_problem_rounded,
                            iconColor: context.appColors.statusReviewAmber,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32),

                  // ── Recent Activity ─────────────────────────
                  SectionHeader(
                    title: 'Recent Activity',
                    actionText: 'View All',
                    onActionTap: () => context.go(AppRoutes.history),
                  ),
                  if (recentScans.isEmpty)
                    EmptyState(
                      icon: Symbols.receipt_long_rounded,
                      title: 'No recent activity',
                      message: 'Products you scan will appear here.',
                    )
                  else
                    ...recentScans.map((scan) {
                      final verdict = appState.verdictForScan(scan.id);
                      return ListTile(
                        title: Text(scan.productId ?? 'Unknown Product', style: AppTextStyles.bodyLarge),
                        subtitle: Text(scan.createdAt.toLocal().toString().split('.')[0]),
                        trailing: Icon(Symbols.chevron_right_rounded, color: context.appColors.textSecondary),
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
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: context.appColors.statusViolationRed.withValues(alpha: 0.35),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          heroTag: 'consumer_grievance_fab',
          onPressed: () => context.push(AppRoutes.consumerGrievance),
          backgroundColor: context.appColors.statusViolationRed,
          elevation: 0,
          icon: Icon(Symbols.report_rounded,
              color: Colors.white, size: 20, fill: 1),
          label: Text('File Grievance',
              style: AppTextStyles.labelLarge.copyWith(color: Colors.white)),
        ),
      ),
    );
  }
}
