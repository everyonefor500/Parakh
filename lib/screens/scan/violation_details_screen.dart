import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../router/app_router.dart';
import '../../models/violation.dart';
import '../../widgets/violation_card.dart';
import '../../widgets/primary_button.dart';

class ViolationDetailsScreen extends StatelessWidget {
  const ViolationDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock violations
    final mockViolations = [
      Violation(
        id: 'v1',
        verdictId: 'verdict-1',
        ruleId: 'Rule 6(1)(e)',
        fieldName: 'Expiry Date',
        issueTitle: 'Missing Expiry Date',
        description: 'The product does not have a clearly printed expiry date.',
        requiredValue: 'Use by Date / Best Before',
        severity: SeverityLevel.high,
        createdAt: DateTime.now(),
      ),
      Violation(
        id: 'v2',
        verdictId: 'verdict-1',
        ruleId: 'Rule 6(1)(c)',
        fieldName: 'MRP',
        issueTitle: 'Improper MRP Format',
        description: 'The MRP is not printed in the required format with taxes included.',
        requiredValue: 'MRP Rs. XX.XX (incl. of all taxes)',
        detectedValue: '120',
        severity: SeverityLevel.medium,
        createdAt: DateTime.now(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Violations Found')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: mockViolations.length,
                  itemBuilder: (context, index) {
                    return ViolationCard(violation: mockViolations[index]);
                  },
                ),
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                text: 'Generate Notice / Report',
                onPressed: () {
                  context.push(AppRoutes.reportGeneration.replaceAll(':verdictId', 'verdict-1'));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
