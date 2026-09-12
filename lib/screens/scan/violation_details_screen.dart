import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/scan_flow_provider.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../router/app_router.dart';
import '../../widgets/violation_card.dart';
import '../../widgets/primary_button.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class ViolationDetailsScreen extends StatelessWidget {
  const ViolationDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ScanFlowProvider>();
    final violations = provider.violations;

    final verdictId = provider.mockVerdict?.id;
    debugPrint('[NAV_LOG] ViolationDetailsScreen built. verdictId from provider: $verdictId');

    return Scaffold(
      appBar: AppBar(title: Text('Violations Found')),
      body: SafeArea(
        child: Column(
          children: [
            // Count banner
            Container(
              margin: const EdgeInsets.fromLTRB(24, 8, 24, 0),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.appColors.statusViolationRed.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color:
                      context.appColors.statusViolationRed.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Symbols.warning_rounded,
                    color: context.appColors.statusViolationRed,
                    size: 20,
                    fill: 1,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '${violations.length} violation${violations.length != 1 ? 's' : ''} found that require immediate attention.',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: context.appColors.statusViolationRed
                            .withValues(alpha: 0.85),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),

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
              child: verdictId == null
                  ? Center(child: CircularProgressIndicator())
                  : PrimaryButton(
                      text: 'Generate Notice / Report',
                      icon: Symbols.description_rounded,
                      onPressed: () {
                        final route = AppRoutes.reportGeneration.replaceAll(':verdictId', verdictId);
                        debugPrint('[NAV_LOG] Tapping Generate Notice / Report in ViolationDetailsScreen. Verdict ID: $verdictId');
                        debugPrint('[NAV_LOG] Pushing route: $route');
                        context.push(route, extra: violations);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
