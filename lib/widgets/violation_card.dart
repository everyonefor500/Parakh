import 'package:flutter/material.dart';
import '../models/violation.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

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
    return Card(
      color: AppColors.cardBackgroundElevated,
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
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
                      style: AppTextStyles.titleMedium.copyWith(color: AppColors.statusViolationRed),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.divider,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      violation.ruleId,
                      style: AppTextStyles.labelSmall.copyWith(color: AppColors.textPrimary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Missing: ${violation.requiredValue}',
                style: AppTextStyles.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
