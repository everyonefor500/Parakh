import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../router/app_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/primary_button.dart';

class ConsumerGrievanceScreen extends StatelessWidget {
  const ConsumerGrievanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('File a Grievance')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    Text(
                      'Report a Non-Compliant Product',
                      style: AppTextStyles.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your report will be securely sent to the Legal Metrology department for action.',
                      style: AppTextStyles.bodyMedium,
                    ),
                    const SizedBox(height: 32),

                    // Form fields
                    _buildField(
                      label: 'Product Name / Brand',
                      icon: Symbols.inventory_2_rounded,
                    ),
                    const SizedBox(height: 16),
                    _buildField(
                      label: 'Shop / Seller Name',
                      icon: Symbols.storefront_rounded,
                    ),
                    const SizedBox(height: 16),
                    _buildField(
                      label: 'Issue Description',
                      icon: Symbols.description_rounded,
                      maxLines: 4,
                    ),
                    const SizedBox(height: 24),

                    // Photo upload zone
                    Text(
                      'Attach Evidence',
                      style: AppTextStyles.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppColors.bgSecondary,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.accentBlue.withValues(alpha: 0.3),
                          width: 1.5,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: DashedBorderContainer(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.accentBlue
                                          .withValues(alpha: 0.15),
                                      AppColors.accentBlue
                                          .withValues(alpha: 0.06),
                                    ],
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Symbols.add_a_photo_rounded,
                                  color: AppColors.accentBlue,
                                  size: 24,
                                  fill: 1,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Tap to upload photos',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.accentBlue
                                      .withValues(alpha: 0.75),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // Submit button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: PrimaryButton(
                text: 'Submit Grievance',
                icon: Symbols.send_rounded,
                onPressed: () {
                  context.go(AppRoutes.home);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Symbols.check_circle_rounded,
                              color: Colors.white, size: 18, fill: 1),
                          const SizedBox(width: 8),
                          Text('Grievance submitted successfully.',
                              style: AppTextStyles.bodyMedium
                                  .copyWith(color: Colors.white)),
                        ],
                      ),
                      backgroundColor: AppColors.statusCompliantGreen,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(
      {required String label,
      required IconData icon,
      int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: maxLines == 1 ? label : null,
        hintText: maxLines > 1 ? label : null,
        prefixIcon: maxLines == 1
            ? Icon(icon, color: AppColors.textSecondary, size: 20, fill: 1)
            : null,
        filled: true,
        fillColor: AppColors.bgSecondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.cardBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              const BorderSide(color: AppColors.accentBlue, width: 1.5),
        ),
      ),
    );
  }
}

/// Simple wrapper that allows the inner child — used for the photo zone styling.
class DashedBorderContainer extends StatelessWidget {
  final Widget child;
  const DashedBorderContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) => child;
}
