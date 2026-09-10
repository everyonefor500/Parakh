import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:parakh/main.dart';
import 'package:parakh/providers/app_state_provider.dart';
import 'package:parakh/providers/role_provider.dart';
import 'package:parakh/providers/scan_flow_provider.dart';
import 'package:parakh/models/profile.dart';

void main() {
  testWidgets('Scan flow navigation test', (WidgetTester tester) async {
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

    await tester.pumpAndSettle();
    
    final scannerFinder = find.text('Scanner');
    await tester.ensureVisible(scannerFinder);
    await tester.tap(scannerFinder);
    await tester.pumpAndSettle();

    expect(find.text('Camera Preview\n(Mock)'), findsOneWidget);
    
    await tester.tap(find.byKey(const Key('capture_button')));
    await tester.pump();
    
    expect(find.text('Extracting product information...'), findsOneWidget);
    
    await tester.pumpAndSettle(const Duration(seconds: 3));
    
    expect(find.text('Confirm & Analyze'), findsOneWidget);
    
    await tester.tap(find.text('Confirm & Analyze'));
    await tester.pump();
    
    expect(find.text('Analyzing Legal Metrology compliance...'), findsOneWidget);
    
    await tester.pumpAndSettle(const Duration(seconds: 3));
    
    expect(find.text('Non-Compliant'), findsWidgets);
    
    await tester.tap(find.text('View Violations'));
    await tester.pumpAndSettle();
    
    expect(find.text('Violations Found'), findsWidgets);
    expect(find.text('Missing Expiry Date'), findsWidgets);
  });
}
