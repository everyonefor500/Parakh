import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../providers/role_provider.dart';
import '../models/profile.dart';

// Import all screens
import '../screens/splash/splash_screen.dart';
import '../screens/auth/auth_screen.dart';
import '../screens/auth/role_selection_screen.dart';
import '../screens/home/officer_dashboard_screen.dart';
import '../screens/home/consumer_home_screen.dart';
import '../screens/scan/scanner_screen.dart';
import '../screens/scan/ai_processing_screen.dart';
import '../screens/scan/extracted_info_screen.dart';
import '../screens/scan/compliance_analysis_screen.dart';
import '../screens/scan/verdict_screen.dart';
import '../screens/scan/violation_details_screen.dart';
// FIX: Use the real HistoryScreen instead of the stub InspectionHistoryScreen
import '../screens/history/history_screen.dart';
import '../screens/reports/reports_list_screen.dart';
import '../screens/reports/report_generation_screen.dart';
import '../screens/reports/show_cause_notice_screen.dart';
import '../screens/consumer/consumer_result_screen.dart';
import '../screens/consumer/consumer_grievance_screen.dart';
import '../screens/consumer/consumer_grievances_list_screen.dart';
import '../screens/officer/officer_grievances_screen.dart';
import '../screens/analytics/officer_analytics_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/profile/account_settings_screen.dart';
import '../screens/profile/notifications_screen.dart';
import '../screens/profile/privacy_security_screen.dart';
import '../screens/profile/help_support_screen.dart';

import '../widgets/bottom_nav_bar.dart';
import '../widgets/floating_scan_button.dart';

class AppRoutes {
  static const splash = '/splash';
  static const auth = '/auth';
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
  static const consumerGrievancesList = '/consumer/grievances';

  static const officerGrievances = '/officer/grievances';

  static const analytics = '/analytics';

  static const accountSettings = '/profile/account';
  static const notifications = '/profile/notifications';
  static const privacySecurity = '/profile/privacy';
  static const helpSupport = '/profile/help';
}

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>();

/// Shared fade + slide-up transition applied to all routes.
CustomTransitionPage<T> _fadeSlideTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 280),
    reverseTransitionDuration: const Duration(milliseconds: 220),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final fadeTween = Tween<double>(begin: 0.0, end: 1.0).chain(
        CurveTween(curve: Curves.easeOut),
      );
      final slideTween = Tween<Offset>(
        begin: const Offset(0.0, 0.04),
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeOut));

      return FadeTransition(
        opacity: animation.drive(fadeTween),
        child: SlideTransition(
          position: animation.drive(slideTween),
          child: child,
        ),
      );
    },
  );
}

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      pageBuilder: (context, state) => _fadeSlideTransition(
        context: context,
        state: state,
        child: const SplashScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.auth,
      pageBuilder: (context, state) {
        final redirectUrl = state.uri.queryParameters['redirect'];
        return _fadeSlideTransition(
          context: context,
          state: state,
          child: AuthScreen(redirectUrl: redirectUrl),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.roleSelection,
      pageBuilder: (context, state) => _fadeSlideTransition(
        context: context,
        state: state,
        child: const RoleSelectionScreen(),
      ),
    ),

    // Scan Flow (Outside ShellRoute — fullscreen)
    GoRoute(
      path: AppRoutes.scan,
      pageBuilder: (context, state) => _fadeSlideTransition(
        context: context,
        state: state,
        child: const ScannerScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.scanProcessing,
      pageBuilder: (context, state) => _fadeSlideTransition(
        context: context,
        state: state,
        child: const AiProcessingScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.scanExtracted,
      pageBuilder: (context, state) => _fadeSlideTransition(
        context: context,
        state: state,
        child: const ExtractedInfoScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.scanCompliance,
      pageBuilder: (context, state) => _fadeSlideTransition(
        context: context,
        state: state,
        child: const ComplianceAnalysisScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.scanVerdict,
      pageBuilder: (context, state) => _fadeSlideTransition(
        context: context,
        state: state,
        child: const VerdictScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.violationDetails,
      pageBuilder: (context, state) => _fadeSlideTransition(
        context: context,
        state: state,
        child: const ViolationDetailsScreen(),
      ),
    ),

    // Consumer specific full-screen flows
    GoRoute(
      path: AppRoutes.consumerResult,
      pageBuilder: (context, state) => _fadeSlideTransition(
        context: context,
        state: state,
        child: const ConsumerResultScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.consumerGrievance,
      pageBuilder: (context, state) => _fadeSlideTransition(
        context: context,
        state: state,
        child: const ConsumerGrievanceScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.consumerGrievancesList,
      pageBuilder: (context, state) => _fadeSlideTransition(
        context: context,
        state: state,
        child: const ConsumerGrievancesListScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.officerGrievances,
      pageBuilder: (context, state) => _fadeSlideTransition(
        context: context,
        state: state,
        child: const OfficerGrievancesScreen(),
      ),
    ),



    // Analytics
    GoRoute(
      path: AppRoutes.analytics,
      pageBuilder: (context, state) => _fadeSlideTransition(
        context: context,
        state: state,
        child: const OfficerAnalyticsScreen(),
      ),
    ),

    // Notice & Report (Outside ShellRoute for fullscreen)
    GoRoute(
      path: AppRoutes.reportGeneration,
      pageBuilder: (context, state) {
        final verdictId = state.pathParameters['verdictId'];
        debugPrint('[NAV_LOG] app_router matched ReportGeneration route. Parsed verdictId parameter: $verdictId');
        return _fadeSlideTransition(
          context: context,
          state: state,
          child: ReportGenerationScreen(verdictId: verdictId),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.showCauseNotice,
      pageBuilder: (context, state) {
        final verdictId = state.pathParameters['verdictId'];
        return _fadeSlideTransition(
          context: context,
          state: state,
          child: ShowCauseNoticeScreen(verdictId: verdictId),
        );
      },
    ),

    // Profile Sub-screens (Fullscreen)
    GoRoute(
      path: AppRoutes.accountSettings,
      pageBuilder: (context, state) => _fadeSlideTransition(
        context: context,
        state: state,
        child: const AccountSettingsScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.notifications,
      pageBuilder: (context, state) => _fadeSlideTransition(
        context: context,
        state: state,
        child: const NotificationsScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.privacySecurity,
      pageBuilder: (context, state) => _fadeSlideTransition(
        context: context,
        state: state,
        child: const PrivacySecurityScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.helpSupport,
      pageBuilder: (context, state) => _fadeSlideTransition(
        context: context,
        state: state,
        child: const HelpSupportScreen(),
      ),
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
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        );
      },
      routes: [
        GoRoute(
          path: AppRoutes.home,
          pageBuilder: (context, state) {
            final role = context.watch<RoleProvider>().selectedRole;
            Widget screen;
            if (role == UserRole.officer) {
              screen = const OfficerDashboardScreen();
            } else {
              // Default to consumer for all other roles including legacy seller/marketplace
              screen = const ConsumerHomeScreen();
            }
            return _fadeSlideTransition(
              context: context,
              state: state,
              child: screen,
            );
          },
        ),
        GoRoute(
          path: AppRoutes.history,
          pageBuilder: (context, state) => _fadeSlideTransition(
            context: context,
            state: state,
            child: const HistoryScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.reports,
          pageBuilder: (context, state) => _fadeSlideTransition(
            context: context,
            state: state,
            child: const ReportsListScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.profile,
          pageBuilder: (context, state) => _fadeSlideTransition(
            context: context,
            state: state,
            child: const ProfileScreen(),
          ),
        ),
      ],
    ),
  ],
  redirect: (context, state) {
    final path = state.uri.path;

    final isProtectedRoute = path == AppRoutes.home ||
        path == AppRoutes.scan ||
        path.startsWith(AppRoutes.history) ||
        path.startsWith(AppRoutes.reports) ||
        path.startsWith(AppRoutes.profile) ||
        path.startsWith(AppRoutes.consumerGrievance) ||
        path.startsWith(AppRoutes.officerGrievances);

    if (isProtectedRoute) {
      final session = Supabase.instance.client.auth.currentSession;
      if (session == null) {
        return '${AppRoutes.roleSelection}?redirect=${Uri.encodeComponent(path)}';
      }
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
