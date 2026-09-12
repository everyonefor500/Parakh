import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../providers/role_provider.dart';
import '../../providers/app_state_provider.dart';
import '../../providers/theme_provider.dart';
import '../../router/app_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
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
                      context.appColors.accentBlue.withValues(alpha: 0.08),
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
                        gradient: LinearGradient(
                          colors: [
                            context.appColors.accentBlueGlow,
                            context.appColors.accentBlue,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: context.appColors.accentBlue
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
                            context.appColors.accentBlue.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color:
                              context.appColors.accentBlue.withValues(alpha: 0.3),
                          width: 1,
                        ),
                        boxShadow:
                            context.appColors.statusGlow(context.appColors.accentBlue),
                      ),
                      child: Text(
                        roleName,
                        style: AppTextStyles.overline.copyWith(
                          color: context.appColors.accentBlue,
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
                    // Appearance group
                    _buildGroupLabel('Appearance', context),
                    const SizedBox(height: 8),
                    _buildSettingsGroup([
                      _SettingsToggleTile(
                        icon: Symbols.dark_mode_rounded,
                        label: 'Dark Mode',
                        value: themeProvider.isDarkMode,
                        onChanged: (val) => themeProvider.toggleTheme(),
                        isLast: true,
                      ),
                    ], context),
                    const SizedBox(height: 24),

                    // Account group
                    _buildGroupLabel('Account', context),
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
                    ], context),
                    const SizedBox(height: 24),

                    // Support group
                    _buildGroupLabel('Support', context),
                    const SizedBox(height: 8),
                    _buildSettingsGroup([
                      _SettingsTile(
                        icon: Symbols.help_rounded,
                        label: 'Help & Support',
                        onTap: () => context.push(AppRoutes.helpSupport),
                        isLast: true,
                      ),
                    ], context),
                    const SizedBox(height: 24),

                    // Danger group
                    _buildGroupLabel('Session', context),
                    const SizedBox(height: 8),
                    _buildSettingsGroup([
                      _SettingsTile(
                        icon: Symbols.logout_rounded,
                        label: 'Log Out',
                        accentColor: context.appColors.statusViolationRed,
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
                    ], context),
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

  Widget _buildGroupLabel(String label, BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: AppTextStyles.overline.copyWith(
        color: context.appColors.textTertiary,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildSettingsGroup(List<Widget> tiles, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.appColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.appColors.cardBorder, width: 1),
        boxShadow: context.appColors.cardShadow,
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
    final color = accentColor ?? context.appColors.textPrimary;
    final iconBg = accentColor ?? context.appColors.accentBlue;

    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            splashColor: context.appColors.accentBlue.withValues(alpha: 0.08),
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
                      color: context.appColors.textTertiary,
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
            color: context.appColors.dividerSubtle,
          ),
      ],
    );
  }
}

class _SettingsToggleTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool isLast;

  const _SettingsToggleTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = context.appColors.textPrimary;
    final iconBg = context.appColors.accentBlue;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                child: Icon(icon, color: iconBg, size: 20, fill: 1),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.titleMedium.copyWith(color: color),
                ),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                activeThumbColor: context.appColors.accentBlue,
                activeTrackColor: context.appColors.accentBlue.withValues(alpha: 0.2),
                inactiveThumbColor: context.appColors.textSecondary,
                inactiveTrackColor: context.appColors.bgSecondary,
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            thickness: 1,
            indent: 74,
            color: context.appColors.dividerSubtle,
          ),
      ],
    );
  }
}
