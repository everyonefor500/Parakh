import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../router/app_router.dart';
import '../../widgets/loading_state.dart';
import '../../providers/app_state_provider.dart';
import '../../data/mock_data.dart';

class ComplianceAnalysisScreen extends StatefulWidget {
  const ComplianceAnalysisScreen({super.key});

  @override
  State<ComplianceAnalysisScreen> createState() =>
      _ComplianceAnalysisScreenState();
}

class _ComplianceAnalysisScreenState extends State<ComplianceAnalysisScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        // Add the mock scan to the state
        context.read<AppStateProvider>().addMockScan(
              MockData.haldiramScan,
              MockData.haldiramVerdict,
              [],
            );
        context.pushReplacement(AppRoutes.scanVerdict);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: LoadingState(
        message: 'Analyzing compliance…',
        subMessage: 'Checking Legal Metrology rules',
      ),
    );
  }
}
