import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// A confidence badge with colored glow shadow and tinted border.
class ConfidenceBadge extends StatelessWidget {
  final double confidence;

  const ConfidenceBadge({super.key, required this.confidence});

  @override
  Widget build(BuildContext context) {
    Color color;
    Color glowColor;

    if (confidence > 85) {
      color = AppColors.statusCompliantGreen;
      glowColor = AppColors.statusCompliantGlow;
    } else if (confidence >= 60) {
      color = AppColors.statusReviewAmber;
      glowColor = AppColors.statusReviewGlow;
    } else {
      color = AppColors.statusViolationRed;
      glowColor = AppColors.statusViolationGlow;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: AppColors.statusGlow(glowColor),
      ),
      child: Text(
        '${confidence.toStringAsFixed(0)}%',
        style: AppTextStyles.labelSmall.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
