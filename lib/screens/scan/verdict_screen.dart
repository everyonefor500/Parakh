// ignore_for_file: dead_code
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../router/app_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/secondary_button.dart';

class VerdictScreen extends StatefulWidget {
  const VerdictScreen({super.key});

  @override
  State<VerdictScreen> createState() => _VerdictScreenState();
}

class _VerdictScreenState extends State<VerdictScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _entryController;
  late Animation<double> _iconScale;
  late Animation<double> _iconFade;
  late Animation<double> _glowOpacity;
  late Animation<Offset> _contentSlide;
  late Animation<double> _contentFade;

  // Hardcoded for prototyping — true = compliant
  static const bool isCompliant = true;

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _iconFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _entryController,
          curve: const Interval(0.0, 0.5, curve: Curves.easeOut)),
    );
    _iconScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
          parent: _entryController,
          curve: const Interval(0.0, 0.6, curve: Curves.elasticOut)),
    );
    _glowOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _entryController,
          curve: const Interval(0.3, 0.9, curve: Curves.easeOut)),
    );
    _contentSlide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOut)));
    _contentFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _entryController,
          curve: const Interval(0.4, 0.9, curve: Curves.easeOut)),
    );

    _entryController.forward();
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final verdictColor = isCompliant
        ? AppColors.statusCompliantGreen
        : AppColors.statusViolationRed;
    final verdictGlow = isCompliant
        ? AppColors.statusCompliantGlow
        : AppColors.statusViolationGlow;
    final verdictIcon =
        isCompliant ? Symbols.check_circle_rounded : Symbols.cancel_rounded;
    final verdictLabel = isCompliant ? 'Compliant' : 'Non-Compliant';
    final verdictMessage = isCompliant
        ? 'All 8 Legal Metrology mandatory declarations verified and approved.'
        : 'This product violates one or more Legal Metrology rules.';

    return Scaffold(
      body: Stack(
        children: [
          // Background tint matching verdict
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  verdictColor.withValues(alpha: 0.07),
                  AppColors.bgPrimary,
                ],
                radius: 1.0,
                center: const Alignment(0, -0.4),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(),

                  // Animated icon with glow
                  Center(
                    child: AnimatedBuilder(
                      animation: _entryController,
                      builder: (context, child) => Stack(
                        alignment: Alignment.center,
                        children: [
                          // Glow halo
                          Opacity(
                            opacity: _glowOpacity.value,
                            child: Container(
                              width: 180,
                              height: 180,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    verdictGlow.withValues(alpha: 0.18),
                                    verdictGlow.withValues(alpha: 0.0),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Icon
                          FadeTransition(
                            opacity: _iconFade,
                            child: ScaleTransition(
                              scale: _iconScale,
                              child: Container(
                                width: 112,
                                height: 112,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: verdictColor.withValues(alpha: 0.1),
                                  border: Border.all(
                                    color: verdictColor.withValues(alpha: 0.25),
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          verdictGlow.withValues(alpha: 0.3),
                                      blurRadius: 32,
                                      spreadRadius: 4,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  verdictIcon,
                                  color: verdictColor,
                                  size: 56,
                                  fill: 1,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Label + description
                  AnimatedBuilder(
                    animation: _entryController,
                    builder: (context, child) => FadeTransition(
                      opacity: _contentFade,
                      child: SlideTransition(
                        position: _contentSlide,
                        child: child,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          verdictLabel,
                          style: AppTextStyles.displayLarge.copyWith(
                            color: verdictColor,
                            letterSpacing: -0.8,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          verdictMessage,
                          style: AppTextStyles.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                        if (isCompliant) ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.statusCompliantGreen.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.statusCompliantGreen.withValues(alpha: 0.3)),
                            ),
                            child: Text(
                              'Compliance Score: 100% (8 / 8 Checks Passed)',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.statusCompliantGreen,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Actions
                  AnimatedBuilder(
                    animation: _contentFade,
                    builder: (context, child) =>
                        Opacity(opacity: _contentFade.value, child: child),
                    child: Column(
                      children: [
                        if (!isCompliant) ...[
                          PrimaryButton(
                            text: 'View Violations',
                            icon: Symbols.warning_rounded,
                            onPressed: () => context.push(
                              AppRoutes.violationDetails
                                  .replaceAll(':id', 'scan-123'),
                            ),
                          ),
                          const SizedBox(height: 12),
                        ] else ...[
                          PrimaryButton(
                            text: 'Generate Compliance Certificate / Report',
                            icon: Symbols.description_rounded,
                            onPressed: () => context.push(AppRoutes.reportGeneration),
                          ),
                          const SizedBox(height: 12),
                        ],
                        SecondaryButton(
                          text: 'Back to Home',
                          onPressed: () => context.go(AppRoutes.home),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
