import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/scan_flow_provider.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../router/app_router.dart';
import '../../models/violation.dart';
import '../../widgets/violation_card.dart';
import '../../widgets/primary_button.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class ViolationDetailsScreen extends StatelessWidget {
  const ViolationDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ScanFlowProvider>();
    final violations = provider.violations.isNotEmpty
        ? provider.violations
        : [
            Violation(
              id: 'v1',
              verdictId: provider.mockVerdict?.id ?? 'verdict-1',
              ruleId: 'Rule 6(1)(e)',
              fieldName: 'Expiry Date',
              issueTitle: 'Missing Expiry Date',
              description:
                  'The product does not have a clearly printed expiry date.',
              requiredValue: 'Use by Date / Best Before',
              severity: SeverityLevel.high,
              createdAt: DateTime.now(),
            ),
            Violation(
              id: 'v2',
              verdictId: provider.mockVerdict?.id ?? 'verdict-1',
              ruleId: 'Rule 6(1)(c)',
              fieldName: 'MRP',
              issueTitle: 'Improper MRP Format',
              description:
                  'The MRP is not printed in the required format with taxes included.',
              requiredValue: 'MRP Rs. XX.XX (incl. of all taxes)',
              detectedValue: '120',
              severity: SeverityLevel.medium,
              createdAt: DateTime.now(),
            ),
          ];

    final verdictId = provider.mockVerdict?.id ?? 'verdict-1';

    return Scaffold(
      appBar: AppBar(title: const Text('Violations Found')),
      body: SafeArea(
        child: Column(
          children: [
            // Count banner
            Container(
              margin: const EdgeInsets.fromLTRB(24, 8, 24, 0),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.statusViolationRed.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color:
                      AppColors.statusViolationRed.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Symbols.warning_rounded,
                    color: AppColors.statusViolationRed,
                    size: 20,
                    fill: 1,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '${violations.length} violation${violations.length != 1 ? 's' : ''} found that require immediate attention.',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.statusViolationRed
                            .withValues(alpha: 0.85),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Violations list
            Expanded(
              child: ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                itemCount: violations.length,
                itemBuilder: (context, index) {
                  return ViolationCard(violation: violations[index]);
                },
              ),
            ),

            // CTA
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: PrimaryButton(
                text: 'Generate Notice / Report',
                icon: Symbols.description_rounded,
                onPressed: () {
                  context.push(AppRoutes.reportGeneration
                      .replaceAll(':verdictId', verdictId), extra: violations);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
