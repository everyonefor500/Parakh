// ignore_for_file: dead_code
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../router/app_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/secondary_button.dart';

class VerdictScreen extends StatelessWidget {
  const VerdictScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Hardcoded to show a violation flow for prototyping
    bool isCompliant = false; 

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Icon(
                isCompliant ? Icons.check_circle_rounded : Icons.cancel_rounded,
                color: isCompliant ? AppColors.statusCompliantGreen : AppColors.statusViolationRed,
                size: 120,
              ),
              const SizedBox(height: 24),
              Text(
                isCompliant ? 'Compliant' : 'Non-Compliant',
                style: AppTextStyles.displayLarge.copyWith(
                  color: isCompliant ? AppColors.statusCompliantGreen : AppColors.statusViolationRed,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                isCompliant 
                    ? 'This product meets all Legal Metrology requirements.'
                    : 'This product violates one or more Legal Metrology rules.',
                style: AppTextStyles.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              if (!isCompliant)
                PrimaryButton(
                  text: 'View Violations',
                  onPressed: () {
                    context.push(AppRoutes.violationDetails.replaceAll(':id', 'scan-123'));
                  },
                ),
              const SizedBox(height: 16),
              SecondaryButton(
                text: 'Back to Home',
                onPressed: () {
                  context.go(AppRoutes.home);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
