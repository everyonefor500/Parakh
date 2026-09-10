import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../router/app_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/section_header.dart';

class ConsumerHomeScreen extends StatelessWidget {
  const ConsumerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                      Text('Hello,', style: AppTextStyles.bodyMedium),
                      const SizedBox(height: 4),
                      Text('Consumer', style: AppTextStyles.headlineLarge),
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
              
              // Call to Action
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.accentBlue, Color(0xFF3868D9)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Verify Your Purchases',
                      style: AppTextStyles.titleLarge.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Scan product labels to check compliance instantly.',
                      style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => context.push(AppRoutes.scan),
                      icon: const Icon(Icons.qr_code_scanner, color: AppColors.accentBlue),
                      label: const Text('Scan Now'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.accentBlue,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              const Row(
                children: [
                  Expanded(
                    child: StatCard(
                      title: 'My Scans',
                      value: '12',
                      icon: Icons.history,
                      iconColor: AppColors.accentBlue,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: StatCard(
                      title: 'Grievances',
                      value: '1',
                      icon: Icons.report_problem,
                      iconColor: AppColors.statusReviewAmber,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              SectionHeader(
                title: 'Recent Activity',
                actionText: 'View All',
                onActionTap: () => context.go(AppRoutes.history),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24.0),
                child: Center(
                  child: Text('No recent activity to show.'),
                ),
              ),
              const SizedBox(height: 100), // padding for bottom nav
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.consumerGrievance),
        backgroundColor: AppColors.statusViolationRed,
        icon: const Icon(Icons.warning_amber_rounded, color: Colors.white),
        label: const Text('File Grievance', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
