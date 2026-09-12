import 'package:flutter/material.dart';
import '../models/violation.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'package:material_symbols_icons/symbols.dart';

/// A premium violation card with red left-accent border and tinted rule badge.
class ViolationCard extends StatelessWidget {
  final Violation violation;
  final VoidCallback? onTap;

  const ViolationCard({
    super.key,
    required this.violation,
    this.onTap,
  });

  String _getHumanReadableLabel(String ruleId) {
    switch (ruleId) {
      case 'RULE_MANDATORY_FIELD':
        return 'Mandatory Field Missing';
      case 'RULE_MRP_FORMAT':
        return 'Price Format Issue';
      case 'RULE_BANNED_QUALIFIER':
        return 'Banned Qualifier';
      case 'RULE_EXPIRY':
        return 'Missing Expiry Date';
      default:
        return 'Compliance Issue';
    }
  }

  String _getCitation(String ruleId) {
    switch (ruleId) {
      case 'RULE_MANDATORY_FIELD':
        return 'Rule 6(1)';
      case 'RULE_MRP_FORMAT':
        return 'Rule 6(1)(e)';
      case 'RULE_BANNED_QUALIFIER':
        return 'Rule 4(1)';
      case 'RULE_EXPIRY':
        return 'Rule 6(1)(c)';
      default:
        return 'Rule TBA';
    }
  }

  @override
  Widget build(BuildContext context) {
    final severityColor = violation.severity == SeverityLevel.possible 
        ? context.appColors.statusReviewAmber 
        : context.appColors.statusViolationRed;
        
    final severityText = violation.severity == SeverityLevel.possible 
        ? 'Possible' 
        : 'Confirmed';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: context.appColors.cardBackgroundElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.appColors.cardBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: context.appColors.statusViolationRed.withValues(alpha: 0.08),
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
                color: context.appColors.statusViolationRed.withValues(alpha: 0.8),
              ),
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onTap,
                    splashColor: context.appColors.statusViolationRed.withValues(alpha: 0.06),
                    highlightColor: context.appColors.statusViolationRed.withValues(alpha: 0.03),
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
                                    color: context.appColors.statusViolationRed,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Human Readable Rule Category Badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: context.appColors.statusViolationRed
                                      .withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: context.appColors.statusViolationRed
                                        .withValues(alpha: 0.25),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  _getHumanReadableLabel(violation.ruleId),
                                  style: AppTextStyles.overline.copyWith(
                                    color: context.appColors.statusViolationRed,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          
                          // Severity & Citation Row
                          Row(
                            children: [
                              Icon(
                                violation.severity == SeverityLevel.possible ? Symbols.warning_amber_rounded : Symbols.error_rounded,
                                size: 14,
                                color: severityColor,
                                fill: 1,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                severityText,
                                style: AppTextStyles.labelSmall.copyWith(color: severityColor, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                width: 4,
                                height: 4,
                                decoration: BoxDecoration(shape: BoxShape.circle, color: context.appColors.textSecondary.withValues(alpha: 0.3)),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                _getCitation(violation.ruleId),
                                style: AppTextStyles.labelSmall.copyWith(color: context.appColors.textSecondary),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 12),
                          const Divider(height: 1),
                          const SizedBox(height: 12),

                          // Description
                          Text(
                            violation.description,
                            style: AppTextStyles.bodyMedium.copyWith(color: context.appColors.textPrimary),
                          ),
                          const SizedBox(height: 16),
                          
                          // Required vs Found Comparison Layout
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: context.appColors.bgPrimary,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: context.appColors.cardBorder),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Required', style: AppTextStyles.overline.copyWith(color: context.appColors.textSecondary)),
                                      const SizedBox(height: 4),
                                      Text(
                                        (violation.requiredValue == null || violation.requiredValue == 'null') 
                                            ? 'Present on label' 
                                            : violation.requiredValue!,
                                        style: AppTextStyles.bodyMedium.copyWith(color: context.appColors.statusCompliantGreen, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  height: 30,
                                  color: context.appColors.cardBorder,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Found', style: AppTextStyles.overline.copyWith(color: context.appColors.textSecondary)),
                                      const SizedBox(height: 4),
                                      Text(
                                        (violation.detectedValue == null || violation.detectedValue == 'null') 
                                            ? 'Not detected' 
                                            : violation.detectedValue!,
                                        style: AppTextStyles.bodyMedium.copyWith(color: context.appColors.statusViolationRed, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
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
