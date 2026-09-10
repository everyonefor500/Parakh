import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Report Non-Compliant Product',
                style: AppTextStyles.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Provide details about the issue. This will be securely sent to the Legal Metrology department.',
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 24),
              
              _buildTextField('Product Name / Brand'),
              const SizedBox(height: 16),
              _buildTextField('Shop / Seller Name'),
              const SizedBox(height: 16),
              _buildTextField('Issue Description', maxLines: 4),
              const SizedBox(height: 24),
              
              Text('Attach Evidence (Photos)', style: AppTextStyles.titleMedium),
              const SizedBox(height: 12),
              Container(
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.bgSecondary,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.divider, style: BorderStyle.solid),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo, color: AppColors.textSecondary, size: 32),
                      SizedBox(height: 8),
                      Text('Upload Images'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              
              PrimaryButton(
                text: 'Submit Grievance',
                onPressed: () {
                  context.go(AppRoutes.home);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Grievance submitted successfully.')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, {int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      style: AppTextStyles.bodyMedium,
      decoration: InputDecoration(
        labelText: maxLines == 1 ? label : null,
        hintText: maxLines > 1 ? label : null,
        filled: true,
        fillColor: AppColors.bgSecondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
