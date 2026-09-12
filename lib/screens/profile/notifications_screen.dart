import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.bgPrimary,
      appBar: AppBar(title: const Text('Notifications')),
      body: const Center(child: Text('Notifications settings coming soon')),
    );
  }
}
