import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:parakh/main.dart';
import 'package:parakh/providers/app_state_provider.dart';
import 'package:parakh/providers/role_provider.dart';
import 'package:parakh/providers/scan_flow_provider.dart';

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

    // Should be on Splash initially
    expect(find.text('Splash Screen / Debug Menu'), findsOneWidget);
    
    // Tap Login on the splash debug menu to go to real Login screen
    final loginFinder = find.text('Login');
    await tester.ensureVisible(loginFinder);
    await tester.tap(loginFinder);
    await tester.pumpAndSettle();
    
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
    
    // Should be on Officer Home (which has OfficerDashboardScreen text)
    expect(find.text('OfficerDashboardScreen'), findsWidgets);
  });
}
