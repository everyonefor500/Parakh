import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state_provider.dart';
import '../../router/app_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/inspection_card.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/section_header.dart';

class OfficerDashboardScreen extends StatelessWidget {
  const OfficerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateProvider>();
    final recentScans = appState.allScans.take(3).toList(); 

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome back,', style: AppTextStyles.bodyMedium),
                      const SizedBox(height: 4),
                      Text('Officer', style: AppTextStyles.headlineLarge),
                    ],
                  ),
                  CircleAvatar(
                    backgroundColor: AppColors.accentBlue.withValues(alpha: 0.2),
                    radius: 24,
                    child: const Icon(Icons.person, color: AppColors.accentBlue),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              
              // Stats
              const Row(
                children: [
                  Expanded(
                    child: StatCard(
                      title: 'Total Scans',
                      value: '1,284',
                      icon: Icons.qr_code_scanner,
                      iconColor: AppColors.accentBlue,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: StatCard(
                      title: 'Notices Issued',
                      value: '42',
                      icon: Icons.assignment_late_rounded,
                      iconColor: AppColors.statusViolationRed,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Recent Inspections
              SectionHeader(
                title: 'Recent Inspections',
                actionText: 'View All',
                onActionTap: () => context.go(AppRoutes.history),
              ),
              
              if (recentScans.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32.0),
                  child: Center(child: Text('No recent inspections')),
                )
              else
                ...recentScans.map((scan) {
                  final verdict = appState.verdictForScan(scan.id);
                  return InspectionCard(
                    scan: scan,
                    verdict: verdict,
                    productName: scan.productId != null ? 'Product ${scan.productId}' : 'Unknown Product',
                    onTap: () {
                      if (verdict != null) {
                        context.push(AppRoutes.scanVerdict);
                      } else {
                        context.push(AppRoutes.scanExtracted);
                      }
                    },
                  );
                }),
                
              const SizedBox(height: 100), // spacing for bottom nav & FAB
            ],
          ),
        ),
      ),
    );
  }
}
