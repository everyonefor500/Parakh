import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/scan.dart';
import '../models/compliance_verdict.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'status_badge.dart';

/// A premium inspection card with floating shadow and accentBlue ripple.
class InspectionCard extends StatelessWidget {
  final Scan scan;
  final ComplianceVerdict? verdict;
  final String productName;
  final VoidCallback onTap;

  const InspectionCard({
    super.key,
    required this.scan,
    required this.verdict,
    required this.productName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: context.appColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.appColors.cardBorder, width: 1),
        boxShadow: context.appColors.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          splashColor: context.appColors.accentBlue.withValues(alpha: 0.08),
          highlightColor: context.appColors.accentBlue.withValues(alpha: 0.04),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Product image thumbnail
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: context.appColors.bgSecondary,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: context.appColors.cardBorder, width: 1),
                    image: scan.imageUrl.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(scan.imageUrl),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: scan.imageUrl.isEmpty
                      ? Icon(Icons.inventory_2_outlined,
                          color: context.appColors.textTertiary, size: 24)
                      : null,
                ),
                SizedBox(width: 16),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productName,
                        style: AppTextStyles.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        DateFormat('MMM d, y • h:mm a').format(scan.createdAt),
                        style: AppTextStyles.labelSmall,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12),
                // Status badge or pending icon
                if (verdict != null)
                  StatusBadge(status: verdict!.status)
                else
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: context.appColors.bgTertiary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'PENDING',
                      style: AppTextStyles.overline.copyWith(
                        color: context.appColors.textTertiary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
