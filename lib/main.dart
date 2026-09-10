import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ignore: unused_import
import 'package:supabase_flutter/supabase_flutter.dart';
import 'theme/app_theme.dart';
import 'providers/app_state_provider.dart';
import 'providers/role_provider.dart';
import 'providers/scan_flow_provider.dart';
import 'router/app_router.dart';

// Placeholder Supabase keys
const supabaseUrl = 'PLACEHOLDER';
const supabaseAnonKey = 'PLACEHOLDER';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase (commented out for now until real backend is connected)
  // await Supabase.initialize(
  //   url: supabaseUrl,
  //   anonKey: supabaseAnonKey,
  // );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppStateProvider()),
        ChangeNotifierProvider(create: (_) => RoleProvider()),
        ChangeNotifierProvider(create: (_) => ScanFlowProvider()),
      ],
      child: const ParakhApp(),
    ),
  );
}

class ParakhApp extends StatelessWidget {
  const ParakhApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Parakh',
      theme: AppTheme.darkTheme,
      routerConfig: appRouter,
    );
  }
}
