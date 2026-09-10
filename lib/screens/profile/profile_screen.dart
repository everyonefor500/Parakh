import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/role_provider.dart';
import '../../router/app_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final roleProvider = context.watch<RoleProvider>();
    final roleName = roleProvider.selectedRole?.name.toUpperCase() ?? 'USER';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          // Profile Header
          Center(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.accentBlue,
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 16),
                Text('John Doe', style: AppTextStyles.headlineLarge),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.accentBlue.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    roleName,
                    style: AppTextStyles.labelSmall.copyWith(color: AppColors.accentBlue),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),

          // Settings Options
          _buildSettingsTile(
            icon: Icons.person_outline,
            title: 'Account Settings',
            onTap: () {},
          ),
          _buildSettingsTile(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            onTap: () {},
          ),
          _buildSettingsTile(
            icon: Icons.security,
            title: 'Privacy & Security',
            onTap: () {},
          ),
          _buildSettingsTile(
            icon: Icons.help_outline,
            title: 'Help & Support',
            onTap: () {},
          ),
          const SizedBox(height: 32),
          
          // Switch Role / Logout
          _buildSettingsTile(
            icon: Icons.swap_horiz,
            title: 'Switch Role (Debug)',
            color: AppColors.accentBlue,
            onTap: () {
              roleProvider.clearRole();
              context.go(AppRoutes.roleSelection);
            },
          ),
          _buildSettingsTile(
            icon: Icons.logout,
            title: 'Log Out',
            color: AppColors.statusViolationRed,
            hideArrow: true,
            onTap: () {
              roleProvider.clearRole();
              context.go(AppRoutes.login);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = AppColors.textPrimary,
    bool hideArrow = false,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.bgSecondary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(
        title,
        style: AppTextStyles.titleMedium.copyWith(color: color),
      ),
      trailing: hideArrow
          ? null
          : const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textTertiary, size: 16),
      onTap: onTap,
    );
  }
}
