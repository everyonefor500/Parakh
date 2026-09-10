import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/scan.dart';
import '../models/compliance_verdict.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'status_badge.dart';

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
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.bgSecondary,
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(scan.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
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
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('MMM d, y • h:mm a').format(scan.createdAt),
                      style: AppTextStyles.labelSmall,
                    ),
                  ],
                ),
              ),
              if (verdict != null) StatusBadge(status: verdict!.status),
            ],
          ),
        ),
      ),
    );
  }
}
