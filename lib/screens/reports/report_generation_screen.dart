import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../router/app_router.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/primary_button.dart';

class ReportGenerationScreen extends StatelessWidget {
  const ReportGenerationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Generate Report')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32.0),
                  decoration: BoxDecoration(
                    color: Colors.white, // Light theme exception
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'INSPECTION REPORT',
                          style: AppTextStyles.headlineMedium.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text('Date: 10-Sep-2026', style: AppTextStyles.bodyMedium.copyWith(color: Colors.black87)),
                      const SizedBox(height: 8),
                      Text('Officer: John Doe', style: AppTextStyles.bodyMedium.copyWith(color: Colors.black87)),
                      const SizedBox(height: 24),
                      Text('Product: Fresh Apple Juice', style: AppTextStyles.bodyMedium.copyWith(color: Colors.black87)),
                      Text('Result: NON-COMPLIANT', style: AppTextStyles.bodyMedium.copyWith(color: Colors.red.shade700, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 24),
                      Text('Violations Found:', style: AppTextStyles.titleMedium.copyWith(color: Colors.black)),
                      const SizedBox(height: 8),
                      Text('1. Missing Expiry Date - Rule 6(1)(e)', style: AppTextStyles.bodyMedium.copyWith(color: Colors.black87)),
                      Text('2. Improper MRP Format - Rule 6(1)(c)', style: AppTextStyles.bodyMedium.copyWith(color: Colors.black87)),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: PrimaryButton(
                text: 'Save Report',
                onPressed: () {
                  context.go(AppRoutes.reports);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
