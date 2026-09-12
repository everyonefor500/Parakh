import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state_provider.dart';
import '../../router/app_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/empty_state.dart';
import '../../models/report.dart';

class ReportsListScreen extends StatefulWidget {
  const ReportsListScreen({super.key});

  @override
  State<ReportsListScreen> createState() => _ReportsListScreenState();
}

class _ReportsListScreenState extends State<ReportsListScreen> {
  List<Report> _reports = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchReports();
  }

  Future<void> _fetchReports() async {
    final user = context.read<AppStateProvider>().currentUser;
    if (user == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final response = await Supabase.instance.client
          .from('reports')
          .select()
          .eq('generated_by', user.id)
          .order('created_at', ascending: false);

      setState(() {
        _reports = (response as List).map((r) => Report.fromJson(r)).toList();
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching reports: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Text('Reports', style: AppTextStyles.headlineLarge),
            ),
            SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _reports.isEmpty
                      ? EmptyState(
                          icon: Symbols.description_rounded,
                          title: 'No reports yet',
                          message: 'Generated reports will appear here.',
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
                          itemCount: _reports.length,
                          itemBuilder: (context, index) {
                            final report = _reports[index];
                            final isGenerated = report.status == 'generated';
                            final statusColor = isGenerated
                                ? context.appColors.statusCompliantGreen
                                : context.appColors.statusReviewAmber;
                                
                            // Try to get the scan product name from app state if it matches a verdict we know
                            final appState = context.read<AppStateProvider>();
                            final verdict = appState.allVerdicts.where((v) => v.id == report.verdictId).firstOrNull;
                            final scan = verdict != null ? appState.allScans.where((s) => s.id == verdict.scanId).firstOrNull : null;
                            final productLabel = scan?.productId ?? 'Product Report';

                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: context.appColors.cardBackground,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: context.appColors.cardBorder, width: 1),
                                boxShadow: context.appColors.cardShadow,
                              ),
                              child: Material(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(20),
                                  splashColor:
                                      context.appColors.accentBlue.withValues(alpha: 0.08),
                                  onTap: () {
                                    // Go to the report generation screen again, it should regenerate/show it
                                    context.push(AppRoutes.reportGeneration.replaceAll(':verdictId', report.verdictId));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        // Icon container
                                        Container(
                                          width: 48,
                                          height: 48,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                context.appColors.accentBlue
                                                    .withValues(alpha: 0.15),
                                                context.appColors.accentBlue
                                                    .withValues(alpha: 0.06),
                                              ],
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Icon(
                                            Symbols.description_rounded,
                                            color: context.appColors.accentBlue,
                                            size: 22,
                                            fill: 1,
                                          ),
                                        ),
                                        SizedBox(width: 14),
                                        // Info
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(productLabel,
                                                  style:
                                                      AppTextStyles.titleMedium),
                                              SizedBox(height: 2),
                                              Text('Inspection Report',
                                                  style:
                                                      AppTextStyles.bodyMedium),
                                              SizedBox(height: 2),
                                              Text('Date: ${DateFormat('dd-MMM-yyyy').format(report.createdAt)}',
                                                  style:
                                                      AppTextStyles.labelSmall),
                                            ],
                                          ),
                                        ),
                                        // Status badge
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          decoration: BoxDecoration(
                                            color: statusColor
                                                .withValues(alpha: 0.12),
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            border: Border.all(
                                              color: statusColor
                                                  .withValues(alpha: 0.3),
                                              width: 1,
                                            ),
                                            boxShadow:
                                                context.appColors.statusGlow(statusColor),
                                          ),
                                          child: Text(
                                            report.status.toUpperCase(),
                                            style: AppTextStyles.overline
                                                .copyWith(
                                              color: statusColor,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
