import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:supabase_flutter/supabase_flutter.dart';
import 'theme/app_theme.dart';

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

  runApp(const ParakhApp());
}

class ParakhApp extends StatelessWidget {
  const ParakhApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parakh',
      theme: AppTheme.darkTheme,
      home: Scaffold(
        body: Center(
          child: Text(
            'Parakh Initialization Successful',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
      ),
    );
  }
}
