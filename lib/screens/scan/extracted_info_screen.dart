import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../router/app_router.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_colors.dart';
import '../../widgets/primary_button.dart';

class ExtractedInfoScreen extends StatelessWidget {
  const ExtractedInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Extracted Info')),
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
                        color: AppColors.accentBlue.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: AppColors.accentBlue.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.info_outline_rounded,
                            color: AppColors.accentBlue,
                            size: 18,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Please verify the details extracted from the package before proceeding.',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.accentBlue
                                    .withValues(alpha: 0.85),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Pricing & Quantity Card
                    _buildCategoryCard('Pricing & Quantity', [
                      ('Net Quantity', '200 g', 99),
                      ('MRP', 'Rs. 60.00 (Incl. of all taxes)', 99),
                      ('Unit Sale Price (USP)', 'Rs. 0.30 per g', 98),
                    ]),
                    const SizedBox(height: 16),

                    // Mandatory Declarations Card
                    _buildCategoryCard('Mandatory Declarations', [
                      ('Product / Commodity', 'Aloo Bhujia Sev', 99),
                      ('Brand', "Haldiram's", 98),
                      ('Category', 'Packaged Snacks / Namkeen', 98),
                      ('Batch No.', 'HAFH13', 97),
                      ('Date of Packing / Mfg', '14.08.26 (21:10)', 99),
                      ('Expiry / Use By Date', '10.02.27', 98),
                      ('Country of Origin', 'Product of India', 99),
                      ('Barcode (EAN-13)', '8904004400731', 99),
                    ]),
                    const SizedBox(height: 16),

                    // Manufacturer & Consumer Care Card
                    _buildCategoryCard('Manufacturer & Consumer Care', [
                      ('Marketed By', 'Haldiram Snacks Food Pvt. Ltd., Gurugram - 122001', 98),
                      ('Marketed By FSSAI Lic. No.', '10014011001919', 99),
                      ('Manufactured By', 'Haldiram Snacks Food Pvt. Ltd. (Unit - Hariomkar), Nagpur - 441104', 98),
                      ('Mfg FSSAI Lic. No.', '10015022004173', 99),
                      ('Consumer Care', '0120-2400266 | customercare@haldiram.com', 97),
                    ]),
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

  Widget _buildCategoryCard(String title, List<(String, String, int)> fields) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder, width: 1),
        boxShadow: AppColors.cardShadow,
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.titleMedium.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...fields.asMap().entries.map((entry) {
            final (label, value, confidence) = entry.value;
            final isLast = entry.key == fields.length - 1;
            return Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.overline.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          value,
                          style: AppTextStyles.bodyLarge,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.statusCompliantGreen.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.statusCompliantGreen.withValues(alpha: 0.3)),
                        ),
                        child: Text(
                          '$confidence%',
                          style: AppTextStyles.overline.copyWith(
                            color: AppColors.statusCompliantGreen,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
