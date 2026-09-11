import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(title: const Text('Help & Support')),
      body: const Center(child: Text('Support options coming soon')),
    );
  }
}
