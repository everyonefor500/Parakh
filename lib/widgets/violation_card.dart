import 'package:flutter/material.dart';
import '../models/violation.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// A premium violation card with red left-accent border and tinted rule badge.
class ViolationCard extends StatelessWidget {
  final Violation violation;
  final VoidCallback? onTap;

  const ViolationCard({
    super.key,
    required this.violation,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBackgroundElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.statusViolationRed.withValues(alpha: 0.08),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: IntrinsicHeight(
          child: Row(
            children: [
              // Red left-accent bar
              Container(
                width: 4,
                color: AppColors.statusViolationRed.withValues(alpha: 0.8),
              ),
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onTap,
                    splashColor: AppColors.statusViolationRed.withValues(alpha: 0.06),
                    highlightColor: AppColors.statusViolationRed.withValues(alpha: 0.03),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  violation.issueTitle,
                                  style: AppTextStyles.titleMedium.copyWith(
                                    color: AppColors.statusViolationRed,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Rule ID badge — red-tinted
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.statusViolationRed
                                      .withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: AppColors.statusViolationRed
                                        .withValues(alpha: 0.25),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  violation.ruleId,
                                  style: AppTextStyles.overline.copyWith(
                                    color: AppColors.statusViolationRed,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Required: ${violation.requiredValue}',
                            style: AppTextStyles.bodyMedium,
                          ),
                          if (violation.detectedValue != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              'Found: ${violation.detectedValue}',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textTertiary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
