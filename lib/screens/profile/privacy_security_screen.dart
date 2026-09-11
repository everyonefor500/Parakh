import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class PrivacySecurityScreen extends StatelessWidget {
  const PrivacySecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(title: const Text('Privacy & Security')),
      body: const Center(child: Text('Privacy settings coming soon')),
    );
  }
}
