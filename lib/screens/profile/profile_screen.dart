import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../providers/role_provider.dart';
import '../../providers/app_state_provider.dart';
import '../../router/app_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final roleProvider = context.watch<RoleProvider>();
    final roleName =
        roleProvider.selectedRole?.name.toUpperCase() ?? 'USER';

    final appState = context.watch<AppStateProvider>();
    final profile = appState.currentUser;
    final userName = profile?.fullName ?? 'User';

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ── Profile Header ──────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.accentBlue.withValues(alpha: 0.08),
                      Colors.transparent,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  children: [
                    // Avatar with gradient ring
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [
                            AppColors.accentBlueGlow,
                            AppColors.accentBlue,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.accentBlue
                                .withValues(alpha: 0.35),
                            blurRadius: 24,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Symbols.person_rounded,
                        size: 48,
                        color: Colors.white,
                        fill: 1,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(userName, style: AppTextStyles.headlineLarge),
                    const SizedBox(height: 8),
                    // Role badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color:
                            AppColors.accentBlue.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color:
                              AppColors.accentBlue.withValues(alpha: 0.3),
                          width: 1,
                        ),
                        boxShadow:
                            AppColors.statusGlow(AppColors.accentBlue),
                      ),
                      child: Text(
                        roleName,
                        style: AppTextStyles.overline.copyWith(
                          color: AppColors.accentBlue,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // ── Settings Groups ─────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Account group
                    _buildGroupLabel('Account'),
                    const SizedBox(height: 8),
                    _buildSettingsGroup([
                      _SettingsTile(
                        icon: Symbols.manage_accounts_rounded,
                        label: 'Account Settings',
                        onTap: () => context.push(AppRoutes.accountSettings),
                      ),
                      _SettingsTile(
                        icon: Symbols.notifications_rounded,
                        label: 'Notifications',
                        onTap: () => context.push(AppRoutes.notifications),
                      ),
                      _SettingsTile(
                        icon: Symbols.lock_rounded,
                        label: 'Privacy & Security',
                        onTap: () => context.push(AppRoutes.privacySecurity),
                        isLast: true,
                      ),
                    ]),
                    const SizedBox(height: 24),

                    // Support group
                    _buildGroupLabel('Support'),
                    const SizedBox(height: 8),
                    _buildSettingsGroup([
                      _SettingsTile(
                        icon: Symbols.help_rounded,
                        label: 'Help & Support',
                        onTap: () => context.push(AppRoutes.helpSupport),
                        isLast: true,
                      ),
                    ]),
                    const SizedBox(height: 24),

                    // Danger group
                    _buildGroupLabel('Session'),
                    const SizedBox(height: 8),
                    _buildSettingsGroup([
                      _SettingsTile(
                        icon: Symbols.logout_rounded,
                        label: 'Log Out',
                        accentColor: AppColors.statusViolationRed,
                        showArrow: false,
                        onTap: () async {
                          await Supabase.instance.client.auth.signOut();
                          if (context.mounted) {
                            context.read<AppStateProvider>().logout();
                            roleProvider.clearRole();
                            context.go(AppRoutes.roleSelection);
                          }
                        },
                        isLast: true,
                      ),
                    ]),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGroupLabel(String label) {
    return Text(
      label.toUpperCase(),
      style: AppTextStyles.overline.copyWith(
        color: AppColors.textTertiary,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildSettingsGroup(List<_SettingsTile> tiles) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder, width: 1),
        boxShadow: AppColors.cardShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(children: tiles),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? accentColor;
  final bool showArrow;
  final bool isLast;

  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.accentColor,
    this.showArrow = true,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = accentColor ?? AppColors.textPrimary;
    final iconBg = accentColor ?? AppColors.accentBlue;

    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            splashColor: AppColors.accentBlue.withValues(alpha: 0.08),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 14),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          iconBg.withValues(alpha: 0.18),
                          iconBg.withValues(alpha: 0.07),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child:
                        Icon(icon, color: iconBg, size: 20, fill: 1),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      label,
                      style: AppTextStyles.titleMedium
                          .copyWith(color: color),
                    ),
                  ),
                  if (showArrow)
                    Icon(
                      Symbols.chevron_right_rounded,
                      color: AppColors.textTertiary,
                      size: 18,
                    ),
                ],
              ),
            ),
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            thickness: 1,
            indent: 74,
            color: AppColors.dividerSubtle,
          ),
      ],
    );
  }
}
