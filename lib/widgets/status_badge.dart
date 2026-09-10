import 'package:flutter/material.dart';
import '../models/compliance_verdict.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class StatusBadge extends StatelessWidget {
  final VerdictStatus status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    
    switch (status) {
      case VerdictStatus.compliant:
        bgColor = AppColors.statusCompliantGreen.withValues(alpha: 0.15);
        textColor = AppColors.statusCompliantGreen;
        break;
      case VerdictStatus.review:
        bgColor = AppColors.statusReviewAmber.withValues(alpha: 0.15);
        textColor = AppColors.statusReviewAmber;
        break;
      case VerdictStatus.nonCompliant:
        bgColor = AppColors.statusViolationRed.withValues(alpha: 0.15);
        textColor = AppColors.statusViolationRed;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        status.label.toUpperCase(),
        style: AppTextStyles.labelSmall.copyWith(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
