import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../router/app_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import '../../providers/role_provider.dart';
import '../../providers/app_state_provider.dart';
import '../../models/profile.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _fade;
  late Animation<double> _glow;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _scale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.0, 0.7, curve: Curves.elasticOut)),
    );
    _fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.0, 0.5, curve: Curves.easeOut)),
    );
    _glow = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.4, 1.0, curve: Curves.easeOut)),
    );

    _controller.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 600), () async {
        if (!mounted) return;

        final session = Supabase.instance.client.auth.currentSession;
        if (session == null) {
          context.go(AppRoutes.roleSelection);
          return;
        }

        try {
          var profileData = await Supabase.instance.client
              .from('profiles')
              .select()
              .eq('id', session.user.id)
              .maybeSingle();

          if (profileData == null) {
            // Edge case: user exists but no profile.
            final userMeta = session.user.userMetadata ?? {};
            final fullName = userMeta['full_name'] as String? ?? 'User';
            final roleString = userMeta['role'] as String? ?? 'consumer';

            profileData = await Supabase.instance.client
                .from('profiles')
                .insert({
                  'id': session.user.id,
                  'full_name': fullName,
                  'role': roleString,
                })
                .select()
                .single();
          }

          final profile = Profile.fromJson(profileData);
          
          if (mounted) {
            context.read<AppStateProvider>().login(profile);
            context.read<RoleProvider>().setRole(profile.role);
            context.go(AppRoutes.home);
          }
        } catch (e) {
          // If fetching profile fails, still route to home and let it handle/fallback
          // or route to login
          debugPrint('Error restoring session in splash: $e');
          if (mounted) context.go(AppRoutes.roleSelection);
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.bgPrimary,
      body: Stack(
        children: [
          // Radial bg glow
          AnimatedBuilder(
            animation: _glow,
            builder: (context, child) => Center(
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      context.appColors.accentBlue.withValues(alpha: 0.12 * _glow.value),
                      Colors.transparent,
                    ],
                    radius: 0.8,
                  ),
                ),
              ),
            ),
          ),

          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated logo
                  FadeTransition(
                    opacity: _fade,
                    child: ScaleTransition(
                      scale: _scale,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              context.appColors.accentBlue.withValues(alpha: 0.22),
                              context.appColors.accentBlue.withValues(alpha: 0.05),
                            ],
                          ),
                          border: Border.all(
                            color:
                                context.appColors.accentBlue.withValues(alpha: 0.4),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: context.appColors.accentBlue
                                  .withValues(alpha: 0.35 * _glow.value),
                              blurRadius: 48,
                              spreadRadius: 8,
                            ),
                          ],
                        ),
                        child: Icon(
                          Symbols.shield_rounded,
                          size: 56,
                          color: context.appColors.accentBlue,
                          fill: 1,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 32),
                  FadeTransition(
                    opacity: _glow,
                    child: Column(
                      children: [
                        Text(
                          'Parakh',
                          style: AppTextStyles.headlineLarge,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'AI Compliance Platform',
                          style: AppTextStyles.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
