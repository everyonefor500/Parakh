import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class ConfidenceBadge extends StatelessWidget {
  final double confidence;

  const ConfidenceBadge({super.key, required this.confidence});

  @override
  Widget build(BuildContext context) {
    Color color;
    if (confidence > 85) {
      color = AppColors.statusCompliantGreen;
    } else if (confidence >= 60) {
      color = AppColors.statusReviewAmber;
    } else {
      color = AppColors.statusViolationRed;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '${confidence.toStringAsFixed(0)}%',
        style: AppTextStyles.labelSmall.copyWith(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}
