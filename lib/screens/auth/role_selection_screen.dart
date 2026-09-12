import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:material_symbols_icons/symbols.dart';
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
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0D1526), context.appColors.bgPrimary],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 24),
                  Text(
                    'Choose your role',
                    style: AppTextStyles.headlineLarge,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Personalized experience based on who you are.',
                    style: AppTextStyles.bodyMedium,
                  ),
                  SizedBox(height: 24),
                  _buildRoleCard(
                    context,
                    role: UserRole.officer,
                    title: 'LMO Officer',
                    description:
                        'Scan products, generate notices, and manage compliance.',
                    icon: Symbols.admin_panel_settings_rounded,
                    accentColor: context.appColors.accentBlue,
                    index: 0,
                  ),

                  SizedBox(height: 16),
                  _buildRoleCard(
                    context,
                    role: UserRole.consumer,
                    title: 'Consumer',
                    description:
                        'Scan products to verify compliance and file grievances.',
                    icon: Symbols.person_rounded,
                    accentColor: context.appColors.statusReviewAmber,
                    index: 2,
                  ),
                ],
              ),
            ),
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
    required Color accentColor,
    required int index,
  }) {
    return _AnimatedRoleCard(
      role: role,
      title: title,
      description: description,
      icon: icon,
      accentColor: accentColor,
      delayMs: index * 80,
      onTap: () {
        context.read<RoleProvider>().setRole(role);
        context.push(AppRoutes.auth);
      },
    );
  }
}

class _AnimatedRoleCard extends StatefulWidget {
  final UserRole role;
  final String title;
  final String description;
  final IconData icon;
  final Color accentColor;
  final int delayMs;
  final VoidCallback onTap;

  const _AnimatedRoleCard({
    required this.role,
    required this.title,
    required this.description,
    required this.icon,
    required this.accentColor,
    required this.delayMs,
    required this.onTap,
  });

  @override
  State<_AnimatedRoleCard> createState() => _AnimatedRoleCardState();
}

class _AnimatedRoleCardState extends State<_AnimatedRoleCard>
    with TickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _scale;

  late AnimationController _entranceController;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  bool _hovering = false;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeInOut),
    );

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: Curves.easeOut),
    );
    _slide = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _entranceController, curve: Curves.easeOutQuart),
    );

    Future.delayed(Duration(milliseconds: widget.delayMs), () {
      if (mounted) _entranceController.forward();
    });
  }

  @override
  void dispose() {
    _pressController.dispose();
    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: GestureDetector(
          onTapDown: (_) {
            setState(() => _hovering = true);
            _pressController.forward();
          },
          onTap: () {
            setState(() => _hovering = false);
            _pressController.reverse();
            widget.onTap();
          },
          onTapCancel: () {
            setState(() => _hovering = false);
            _pressController.reverse();
          },
          child: AnimatedBuilder(
            animation: _scale,
            builder: (context, child) => Transform.scale(
              scale: _scale.value,
              child: child,
            ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _hovering
                    ? context.appColors.cardBackgroundElevated
                    : context.appColors.cardBackground,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _hovering
                      ? widget.accentColor.withValues(alpha: 0.6)
                      : widget.accentColor.withValues(alpha: 0.2),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.accentColor.withValues(alpha: _hovering ? 0.2 : 0.05),
                    blurRadius: _hovering ? 24 : 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Icon container with per-role accent gradient
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          widget.accentColor.withValues(alpha: 0.18),
                          widget.accentColor.withValues(alpha: 0.07),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: widget.accentColor.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Icon(widget.icon,
                        size: 28, color: widget.accentColor, fill: 1),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.title, style: AppTextStyles.titleLarge),
                        SizedBox(height: 4),
                        Text(widget.description,
                            style: AppTextStyles.bodyMedium),
                      ],
                    ),
                  ),
                  Icon(
                    Symbols.arrow_forward_ios_rounded,
                    color: widget.accentColor.withValues(alpha: _hovering ? 0.8 : 0.4),
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
