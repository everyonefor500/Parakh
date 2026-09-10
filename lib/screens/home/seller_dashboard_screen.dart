import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../router/app_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/section_header.dart';
import '../../widgets/primary_button.dart';

class SellerDashboardScreen extends StatelessWidget {
  const SellerDashboardScreen({super.key});

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
                      Text('Seller Portal,', style: AppTextStyles.bodyMedium),
                      const SizedBox(height: 4),
                      Text('Fresh Foods Ltd', style: AppTextStyles.headlineLarge),
                    ],
                  ),
                  CircleAvatar(
                    backgroundColor: AppColors.accentBlue.withValues(alpha: 0.2),
                    radius: 24,
                    child: const Icon(Icons.storefront, color: AppColors.accentBlue),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              
              // Bulk Scan Call to Action
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2E3A59), Color(0xFF1E2640)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pre-Verification Scanner',
                      style: AppTextStyles.titleLarge.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Scan multiple products at once before listing them on marketplace platforms.',
                      style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70),
                    ),
                    const SizedBox(height: 16),
                    PrimaryButton(
                      text: 'Start Bulk Scan',
                      onPressed: () => context.push(AppRoutes.bulkScanner),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              const Row(
                children: [
                  Expanded(
                    child: StatCard(
                      title: 'Verified Listings',
                      value: '240',
                      icon: Icons.check_circle_outline,
                      iconColor: AppColors.statusCompliantGreen,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: StatCard(
                      title: 'Flagged',
                      value: '3',
                      icon: Icons.error_outline,
                      iconColor: AppColors.statusViolationRed,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              SectionHeader(
                title: 'Recent Batches',
                actionText: 'View All',
                onActionTap: () {},
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24.0),
                child: Center(
                  child: Text('No recent bulk scans.'),
                ),
              ),
              const SizedBox(height: 100), // padding for bottom nav
            ],
          ),
        ),
      ),
    );
  }
}
