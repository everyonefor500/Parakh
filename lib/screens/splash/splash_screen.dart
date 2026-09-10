import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../router/app_router.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Splash Screen / Debug Menu')),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Debug Menu: Jump to Screen'),
          ),
          ListTile(title: const Text('Login'), onTap: () => context.go(AppRoutes.login)),
          ListTile(title: const Text('Role Selection'), onTap: () => context.go(AppRoutes.roleSelection)),
          ListTile(title: const Text('Home Dashboard'), onTap: () => context.go(AppRoutes.home)),
          ListTile(title: const Text('Inspection History'), onTap: () => context.go(AppRoutes.history)),
          ListTile(title: const Text('Report Generation'), onTap: () => context.go(AppRoutes.reports)),
          ListTile(title: const Text('Profile'), onTap: () => context.go(AppRoutes.profile)),
          ListTile(title: const Text('Scanner'), onTap: () => context.push(AppRoutes.scan)),
          ListTile(title: const Text('AI Processing'), onTap: () => context.push(AppRoutes.scanProcessing)),
          ListTile(title: const Text('Extracted Info'), onTap: () => context.push(AppRoutes.scanExtracted)),
          ListTile(title: const Text('Compliance Analysis'), onTap: () => context.push(AppRoutes.scanCompliance)),
          ListTile(title: const Text('Verdict Screen'), onTap: () => context.push(AppRoutes.scanVerdict)),
          ListTile(title: const Text('Violation Details'), onTap: () => context.push(AppRoutes.violationDetails.replaceAll(':id', 'mock-id'))),
          ListTile(title: const Text('Show Cause Notice'), onTap: () => context.push(AppRoutes.showCauseNotice.replaceAll(':verdictId', 'mock-verdict'))),
          ListTile(title: const Text('Consumer Result'), onTap: () => context.push(AppRoutes.consumerResult.replaceAll(':scanId', 'mock-scan'))),
          ListTile(title: const Text('Consumer Grievance'), onTap: () => context.push(AppRoutes.consumerGrievance)),
          ListTile(title: const Text('Bulk Scanner'), onTap: () => context.push(AppRoutes.bulkScanner)),
          ListTile(title: const Text('Analytics'), onTap: () => context.push(AppRoutes.analytics)),
        ],
      ),
    );
  }
}
