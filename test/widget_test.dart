import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:parakh/main.dart';
import 'package:parakh/providers/app_state_provider.dart';
import 'package:parakh/providers/role_provider.dart';
import 'package:parakh/providers/scan_flow_provider.dart';
import 'package:parakh/models/profile.dart';

void main() {
  testWidgets('App routing and shell route test', (WidgetTester tester) async {
    final roleProvider = RoleProvider();
    roleProvider.setRole(UserRole.officer);
    
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppStateProvider()),
          ChangeNotifierProvider.value(value: roleProvider),
          ChangeNotifierProvider(create: (_) => ScanFlowProvider()),
        ],
        child: const ParakhApp(),
      ),
    );

    // We should be on Splash screen initially
    expect(find.text('Splash Screen / Debug Menu'), findsOneWidget);

    // Ensure debug menu is scrollable, scroll to find "Officer Home"
    final finder = find.text('Officer Home');
    await tester.ensureVisible(finder);
    
    // Tap on Officer Home in debug menu
    await tester.tap(finder);
    await tester.pumpAndSettle();

    // Now we should be on Officer Dashboard and see the BottomNavigationBar
    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(find.text('OfficerDashboardScreen'), findsWidgets);

    // Tap on History tab
    await tester.tap(find.text('History').last);
    await tester.pumpAndSettle();

    // Verify we are on History screen
    expect(find.text('InspectionHistoryScreen'), findsWidgets);

    // Tap on the FAB
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // Verify we are on Scanner screen (no bottom nav)
    expect(find.byType(BottomNavigationBar), findsNothing);
    expect(find.text('ScannerScreen'), findsWidgets);
  });
}
