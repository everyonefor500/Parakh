import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../router/app_router.dart';
import '../../theme/app_colors.dart';
import '../../widgets/primary_button.dart';

import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/app_state_provider.dart';

class ShowCauseNoticeScreen extends StatelessWidget {
  final String? verdictId;
  const ShowCauseNoticeScreen({super.key, this.verdictId});

  @override
  Widget build(BuildContext context) {
    if (verdictId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Verdict ID missing.')),
      );
    }

    final appState = context.watch<AppStateProvider>();
    final verdict = appState.allVerdicts.where((v) => v.id == verdictId).firstOrNull;
    final scan = verdict != null ? appState.allScans.where((s) => s.id == verdict.scanId).firstOrNull : null;

    if (verdict == null || scan == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Data not found.')),
      );
    }

    final productLabel = scan.productId ?? 'Unknown Product';
    final scanDate = DateFormat('dd-MMM-yyyy').format(scan.createdAt);
    final dueDate = DateFormat('dd-MMM-yyyy').format(DateTime.now().add(const Duration(days: 15)));
    
    final violations = appState.violationsForVerdict(verdict.id);
    final violationsText = violations.isEmpty 
        ? 'No specific violations recorded.'
        : violations.map((v) => 'Rule ${v.ruleId} (${v.issueTitle})').join(' and ');

    return Scaffold(
      backgroundColor: context.appColors.bgPrimary,
      appBar: AppBar(
        title: const Text('Show Cause Notice'),
        leading: const BackButton(),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.18),
                        blurRadius: 28,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Official header
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 24, horizontal: 24),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF5F7FC),
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(16)),
                          border: Border(
                            bottom: BorderSide(
                                color: Color(0xFFE0E6F0), width: 1),
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFFEEF2FC),
                                border: Border.all(
                                    color: const Color(0xFFCDD5E8),
                                    width: 1),
                              ),
                              child: const Icon(
                                Symbols.account_balance_rounded,
                                color: Color(0xFF3A4D7A),
                                size: 28,
                                fill: 1,
                              ),
                            ),
                            const SizedBox(height: 14),
                            const Text(
                              'GOVERNMENT OF INDIA',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF3A4D7A),
                                letterSpacing: 0.8,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'DEPARTMENT OF LEGAL METROLOGY',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF6B7A99),
                                letterSpacing: 0.4,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 6),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: const Color(0xFF3A4D7A),
                                    width: 1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'SHOW CAUSE NOTICE',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF3A4D7A),
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Notice body
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'To,',
                              style: TextStyle(
                                  fontSize: 13, color: Colors.black54),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'The Manufacturer,',
                              style: TextStyle(
                                  fontSize: 13, color: Colors.black54),
                            ),
                            Text(
                              productLabel,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Subject: Non-compliance under Legal Metrology (Packaged Commodities) Rules, 2011',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'During an inspection on $scanDate, it was observed that your product "$productLabel" is in violation of $violationsText.',
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black87,
                                  height: 1.6),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'You are hereby directed to show cause within 15 days as to why action should not be initiated against you under the relevant provisions.',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black87,
                                  height: 1.6),
                            ),
                            const SizedBox(height: 24),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF3F3),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: const Color(0xFFFFCCCC),
                                    width: 1),
                              ),
                              child: Row(
                                children: [
                                  Icon(Symbols.schedule_rounded,
                                      color: Colors.red.shade400,
                                      size: 16),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Response due by: $dueDate',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.red.shade700,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Footer
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF5F7FC),
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(16)),
                          border: Border(
                              top: BorderSide(
                                  color: Color(0xFFE0E6F0), width: 1)),
                        ),
                        child: const Text(
                          'This is a computer-generated notice issued by the Parakh AI Compliance System.',
                          style: TextStyle(
                              fontSize: 10, color: Colors.black38),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Issue button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: PrimaryButton(
                text: 'Issue Notice',
                icon: Symbols.send_rounded,
                onPressed: () => context.go(AppRoutes.reports),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
