import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../router/app_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/primary_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2),
              // App Logo placeholder
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.accentBlue.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.accentBlue.withValues(alpha: 0.5), width: 2),
                  ),
                  child: const Icon(Icons.shield_rounded, size: 40, color: AppColors.accentBlue),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Welcome to Parakh',
                style: AppTextStyles.headlineLarge.copyWith(fontSize: 32),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'AI-Powered Legal Metrology Compliance',
                style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 3),
              _buildTextField(label: 'Email', icon: Icons.email_outlined),
              const SizedBox(height: 16),
              _buildTextField(label: 'Password', icon: Icons.lock_outline, obscureText: true),
              const SizedBox(height: 24),
              PrimaryButton(
                text: 'Sign In',
                onPressed: () {
                  context.go(AppRoutes.roleSelection);
                },
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {},
                child: Text('Forgot Password?', style: AppTextStyles.labelLarge.copyWith(color: AppColors.accentBlue)),
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required String label, required IconData icon, bool obscureText = false}) {
    return TextField(
      obscureText: obscureText,
      style: AppTextStyles.bodyMedium,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
        prefixIcon: Icon(icon, color: AppColors.textSecondary),
        filled: true,
        fillColor: AppColors.bgSecondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.accentBlue),
        ),
      ),
    );
  }
}
