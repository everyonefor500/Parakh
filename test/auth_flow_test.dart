import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:parakh/main.dart';
import 'package:parakh/providers/app_state_provider.dart';
import 'package:parakh/providers/role_provider.dart';
import 'package:parakh/providers/scan_flow_provider.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('Auth flow navigation test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppStateProvider()),
          ChangeNotifierProvider(create: (_) => RoleProvider()),
          ChangeNotifierProvider(create: (_) => ScanFlowProvider()),
        ],
        child: const ParakhApp(),
      ),
    );

    // Initial Splash
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    
    // Wait for the Future.delayed redirect to /login
    await tester.pumpAndSettle(const Duration(seconds: 3));
    
    // Should be on Login Screen
    expect(find.text('Welcome to Parakh'), findsOneWidget);
    
    // Tap "Sign In"
    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();
    
    // Should be on Role Selection Screen
    expect(find.text('Select Profile'), findsOneWidget);
    
    // Tap "LMO Officer"
    await tester.tap(find.text('LMO Officer'));
    await tester.pumpAndSettle();
    
    // Should be on Officer Home (which has OfficerDashboardScreen text or 'Total Scans')
    expect(find.text('Total Scans'), findsWidgets);
  });
}
