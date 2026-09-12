import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../router/app_router.dart';
import '../../providers/scan_flow_provider.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_colors.dart';
import '../../widgets/primary_button.dart';
import '../../models/extracted_field.dart';

class ExtractedInfoScreen extends StatelessWidget {
  const ExtractedInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final extractedFields = context.watch<ScanFlowProvider>().extractedFields;
    
    // Group fields
    final pricingQuantityFields = ['MRP', 'Net Quantity'];
    final dateFields = ['Mfg Date', 'Expiry'];
    final manufacturerFields = ['Manufacturer', 'FSSAI', 'Consumer Care', 'Country of Origin'];
    
    List<ExtractedField> getFields(List<String> names) {
      return names.map((name) {
        return extractedFields.firstWhere(
          (f) => f.fieldName == name,
          orElse: () => ExtractedField(
            id: '', scanId: '', fieldName: name, confidence: 0, isDetected: false, createdAt: DateTime.now()
          )
        );
      }).toList();
    }

    return Scaffold(
      appBar: AppBar(title: Text('Extracted Info')),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: context.appColors.accentBlue.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: context.appColors.accentBlue.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            color: context.appColors.accentBlue,
                            size: 18,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Please verify the details extracted from the package before proceeding.',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: context.appColors.accentBlue
                                    .withValues(alpha: 0.85),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 32),

                    _buildCategoryCard(context, 'Pricing & Quantity', getFields(pricingQuantityFields)),
                    SizedBox(height: 24),
                    _buildCategoryCard(context, 'Dates', getFields(dateFields)),
                    SizedBox(height: 24),
                    _buildCategoryCard(context, 'Manufacturer Details', getFields(manufacturerFields)),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // CTA
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: PrimaryButton(
                text: 'Confirm & Analyze',
                onPressed: () =>
                    context.pushReplacement(AppRoutes.scanCompliance),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, String title, List<ExtractedField> fields) {
    return Container(
      decoration: BoxDecoration(
        color: context.appColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.appColors.cardBorder, width: 1),
        boxShadow: context.appColors.cardShadow,
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.titleMedium.copyWith(color: context.appColors.textPrimary, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          ...fields.asMap().entries.map((entry) {
            final field = entry.value;
            final isLast = entry.key == fields.length - 1;
            final bool isDetected = field.isDetected && field.fieldValue != null;
            final int confidence = (field.confidence * 100).toInt();
            final String displayValue = isDetected ? field.fieldValue! : 'Not detected';
            
            Color statusColor;
            if (confidence >= 90) {
              statusColor = context.appColors.statusCompliantGreen;
            } else if (confidence >= 60) {
              statusColor = context.appColors.statusReviewAmber;
            } else {
              statusColor = context.appColors.statusViolationRed;
            }

            return Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    field.fieldName,
                    style: AppTextStyles.overline.copyWith(color: context.appColors.textSecondary),
                  ),
                  SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          displayValue,
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: isDetected ? context.appColors.textPrimary : context.appColors.textSecondary.withValues(alpha: 0.6),
                            fontStyle: isDetected ? FontStyle.normal : FontStyle.italic,
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      if (isDetected)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: statusColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 4),
                            Text(
                              '$confidence%',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: context.appColors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )
                      else
                         Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.warning_amber_rounded, size: 14, color: context.appColors.textSecondary.withValues(alpha: 0.5)),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
