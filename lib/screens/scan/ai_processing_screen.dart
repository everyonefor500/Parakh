import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../router/app_router.dart';
import '../../widgets/loading_state.dart';

class AiProcessingScreen extends StatefulWidget {
  const AiProcessingScreen({super.key});

  @override
  State<AiProcessingScreen> createState() => _AiProcessingScreenState();
}

class _AiProcessingScreenState extends State<AiProcessingScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        context.pushReplacement(AppRoutes.scanExtracted);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: LoadingState(message: 'Extracting product information...'),
    );
  }
}
