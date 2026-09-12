import 'package:flutter/material.dart';
import '../models/compliance_verdict.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// A premium status badge with colored glow shadow and tinted border.
class StatusBadge extends StatelessWidget {
  final VerdictStatus status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    Color glowColor;

    switch (status) {
      case VerdictStatus.compliant:
        bgColor = context.appColors.statusCompliantGreen.withValues(alpha: 0.12);
        textColor = context.appColors.statusCompliantGreen;
        glowColor = context.appColors.statusCompliantGlow;
        break;
      case VerdictStatus.review:
        bgColor = context.appColors.statusReviewAmber.withValues(alpha: 0.12);
        textColor = context.appColors.statusReviewAmber;
        glowColor = context.appColors.statusReviewGlow;
        break;
      case VerdictStatus.nonCompliant:
        bgColor = context.appColors.statusViolationRed.withValues(alpha: 0.12);
        textColor = context.appColors.statusViolationRed;
        glowColor = context.appColors.statusViolationGlow;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: textColor.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: context.appColors.statusGlow(glowColor),
      ),
      child: Text(
        status.label.toUpperCase(),
        style: AppTextStyles.overline.copyWith(
          color: textColor,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
