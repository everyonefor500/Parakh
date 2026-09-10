import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/role_provider.dart';
import '../models/profile.dart';

// Import all screens
import '../screens/splash/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/role_selection_screen.dart';
import '../screens/home/officer_dashboard_screen.dart';
import '../screens/home/consumer_home_screen.dart';
import '../screens/home/seller_dashboard_screen.dart';
import '../screens/scan/scanner_screen.dart';
import '../screens/scan/ai_processing_screen.dart';
import '../screens/scan/extracted_info_screen.dart';
import '../screens/scan/compliance_analysis_screen.dart';
import '../screens/scan/verdict_screen.dart';
import '../screens/scan/violation_details_screen.dart';
import '../screens/history/inspection_history_screen.dart';
import '../screens/reports/report_generation_screen.dart';
import '../screens/reports/show_cause_notice_screen.dart';
import '../screens/consumer/consumer_result_screen.dart';
import '../screens/consumer/consumer_grievance_screen.dart';
import '../screens/marketplace/bulk_scanner_screen.dart';
import '../screens/analytics/officer_analytics_screen.dart';
import '../screens/profile/profile_screen.dart';

import '../widgets/bottom_nav_bar.dart';
import '../widgets/floating_scan_button.dart';

class AppRoutes {
  static const splash = '/splash';
  static const login = '/login';
  static const roleSelection = '/role-selection';
  
  static const home = '/home';
  static const history = '/history';
  static const reports = '/reports';
  static const profile = '/profile';
  
  static const scan = '/scan';
  static const scanProcessing = '/scan/processing';
  static const scanExtracted = '/scan/extracted';
  static const scanCompliance = '/scan/compliance';
  static const scanVerdict = '/scan/verdict';
  static const violationDetails = '/scan/violation/:id';
  
  static const reportGeneration = '/reports/:verdictId';
  static const showCauseNotice = '/reports/:verdictId/notice';
  
  static const consumerResult = '/consumer/result/:scanId';
  static const consumerGrievance = '/consumer/grievance';
  
  static const bulkScanner = '/marketplace/bulk-scan';
  static const analytics = '/analytics';
}

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.roleSelection,
      builder: (context, state) => const RoleSelectionScreen(),
    ),
    
    // Scan Flow (Outside ShellRoute to be fullscreen)
    GoRoute(
      path: AppRoutes.scan,
      builder: (context, state) => const ScannerScreen(),
    ),
    GoRoute(
      path: AppRoutes.scanProcessing,
      builder: (context, state) => const AiProcessingScreen(),
    ),
    GoRoute(
      path: AppRoutes.scanExtracted,
      builder: (context, state) => const ExtractedInfoScreen(),
    ),
    GoRoute(
      path: AppRoutes.scanCompliance,
      builder: (context, state) => const ComplianceAnalysisScreen(),
    ),
    GoRoute(
      path: AppRoutes.scanVerdict,
      builder: (context, state) => const VerdictScreen(),
    ),
    GoRoute(
      path: AppRoutes.violationDetails,
      builder: (context, state) => const ViolationDetailsScreen(),
    ),

    // Consumer specific full-screen flows
    GoRoute(
      path: AppRoutes.consumerResult,
      builder: (context, state) => const ConsumerResultScreen(),
    ),
    GoRoute(
      path: AppRoutes.consumerGrievance,
      builder: (context, state) => const ConsumerGrievanceScreen(),
    ),
    
    // Marketplace
    GoRoute(
      path: AppRoutes.bulkScanner,
      builder: (context, state) => const BulkScannerScreen(),
    ),

    // Analytics
    GoRoute(
      path: AppRoutes.analytics,
      builder: (context, state) => const OfficerAnalyticsScreen(),
    ),
    
    // Notice (Outside ShellRoute for fullscreen)
    GoRoute(
      path: AppRoutes.showCauseNotice,
      builder: (context, state) => const ShowCauseNoticeScreen(),
    ),

    // ShellRoute for Bottom Navigation
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return Scaffold(
          body: child,
          bottomNavigationBar: AppBottomNavBar(
            currentIndex: _calculateSelectedIndex(state.uri.path),
            onTap: (int idx) => _onItemTapped(idx, context),
          ),
          floatingActionButton: FloatingScanButton(
            onPressed: () => context.push(AppRoutes.scan),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        );
      },
      routes: [
        GoRoute(
          path: AppRoutes.home,
          builder: (context, state) {
            final role = context.watch<RoleProvider>().selectedRole;
            if (role == UserRole.consumer) return const ConsumerHomeScreen();
            if (role == UserRole.seller) return const SellerDashboardScreen();
            return const OfficerDashboardScreen(); // Default to officer
          },
        ),
        GoRoute(
          path: AppRoutes.history,
          builder: (context, state) => const InspectionHistoryScreen(),
        ),
        GoRoute(
          path: AppRoutes.reports,
          builder: (context, state) => const ReportGenerationScreen(),
        ),
        GoRoute(
          path: AppRoutes.profile,
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
  ],
  redirect: (context, state) {
    final roleProvider = context.read<RoleProvider>();
    final isGoingToAuth = state.uri.path == AppRoutes.login || 
                          state.uri.path == AppRoutes.roleSelection || 
                          state.uri.path == AppRoutes.splash;

    if (!isGoingToAuth && roleProvider.selectedRole == null) {
      return AppRoutes.roleSelection;
    }
    return null;
  },
);

int _calculateSelectedIndex(String location) {
  if (location.startsWith(AppRoutes.history)) return 1;
  if (location.startsWith(AppRoutes.reports)) return 2;
  if (location.startsWith(AppRoutes.profile)) return 3;
  return 0; // default to Home
}

void _onItemTapped(int index, BuildContext context) {
  switch (index) {
    case 0:
      context.go(AppRoutes.home);
      break;
    case 1:
      context.go(AppRoutes.history);
      break;
    case 2:
      context.go(AppRoutes.reports);
      break;
    case 3:
      context.go(AppRoutes.profile);
      break;
  }
}
