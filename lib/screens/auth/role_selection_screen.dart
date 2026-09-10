import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../models/profile.dart';
import '../../providers/role_provider.dart';
import '../../router/app_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Profile'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          Text(
            'Who is using the app?',
            style: AppTextStyles.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Choose your role to customize your experience.',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 32),
          _buildRoleCard(
            context,
            role: UserRole.officer,
            title: 'LMO Officer',
            description: 'Scan products, generate notices, and manage compliance.',
            icon: Icons.admin_panel_settings_rounded,
          ),
          const SizedBox(height: 16),
          _buildRoleCard(
            context,
            role: UserRole.seller,
            title: 'Seller / Marketplace',
            description: 'Pre-verify products in bulk before listing them online.',
            icon: Icons.storefront_rounded,
          ),
          const SizedBox(height: 16),
          _buildRoleCard(
            context,
            role: UserRole.consumer,
            title: 'Consumer',
            description: 'Scan products to verify compliance and file grievances.',
            icon: Icons.person_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildRoleCard(
    BuildContext context, {
    required UserRole role,
    required String title,
    required String description,
    required IconData icon,
  }) {
    return InkWell(
      onTap: () {
        context.read<RoleProvider>().setRole(role);
        context.go(AppRoutes.home);
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.cardBackgroundElevated,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.bgSecondary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, size: 32, color: AppColors.accentBlue),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.titleLarge),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textTertiary, size: 16),
          ],
        ),
      ),
    );
  }
}
