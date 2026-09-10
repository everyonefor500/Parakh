// ignore_for_file: dead_code
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../router/app_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/secondary_button.dart';

class ConsumerResultScreen extends StatelessWidget {
  const ConsumerResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                isCompliant ? Icons.check_circle_rounded : Icons.warning_rounded,
                color: isCompliant ? AppColors.statusCompliantGreen : AppColors.statusViolationRed,
                size: 120,
              ),
              const SizedBox(height: 24),
              Text(
                isCompliant ? 'Looks Good!' : 'Warning',
                style: AppTextStyles.displayLarge.copyWith(
                  color: isCompliant ? AppColors.statusCompliantGreen : AppColors.statusViolationRed,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                isCompliant 
                    ? 'This product appears to be compliant with Legal Metrology standards.'
                    : 'This product may be non-compliant or missing mandatory declarations.',
                style: AppTextStyles.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              if (!isCompliant)
                PrimaryButton(
                  text: 'Report to Authorities',
                  onPressed: () {
                    context.push(AppRoutes.consumerGrievance);
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
