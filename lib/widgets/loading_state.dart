import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// A premium branded loading state with pulsing animation.
class LoadingState extends StatefulWidget {
  final String? message;
  final String? subMessage;

  const LoadingState({super.key, this.message, this.subMessage});

  @override
  State<LoadingState> createState() => _LoadingStateState();
}

class _LoadingStateState extends State<LoadingState>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulse;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _pulse, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Branded pulsing logo
          AnimatedBuilder(
            animation: _pulseAnim,
            builder: (context, child) => Transform.scale(
              scale: _pulseAnim.value,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.accentBlue.withValues(alpha: 0.25),
                      AppColors.accentBlue.withValues(alpha: 0.05),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accentBlue
                          .withValues(alpha: 0.3 * _pulseAnim.value),
                      blurRadius: 32,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.shield_rounded,
                  color: AppColors.accentBlue,
                  size: 36,
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          // Thin progress indicator
          SizedBox(
            width: 180,
            child: LinearProgressIndicator(
              backgroundColor: AppColors.bgTertiary,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.accentBlue),
              borderRadius: BorderRadius.circular(4),
              minHeight: 3,
            ),
          ),
          if (widget.message != null) ...[
            const SizedBox(height: 24),
            Text(
              widget.message!,
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          if (widget.subMessage != null) ...[
            const SizedBox(height: 8),
            Text(
              widget.subMessage!,
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
