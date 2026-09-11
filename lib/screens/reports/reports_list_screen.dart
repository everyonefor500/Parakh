import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../router/app_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/empty_state.dart';

class ReportsListScreen extends StatelessWidget {
  const ReportsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock reports
    final mockReports = [
      {
        'id': 'RPT-2026-001',
        'date': '2026-09-10',
        'type': 'Show Cause Notice',
        'status': 'Issued'
      },
      {
        'id': 'RPT-2026-002',
        'date': '2026-09-08',
        'type': 'Inspection Report',
        'status': 'Draft'
      },
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Text('Reports', style: AppTextStyles.headlineLarge),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: mockReports.isEmpty
                  ? EmptyState(
                      icon: Symbols.description_rounded,
                      title: 'No reports yet',
                      message: 'Generated reports will appear here.',
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
                      itemCount: mockReports.length,
                      itemBuilder: (context, index) {
                        final report = mockReports[index];
                        final isIssued = report['status'] == 'Issued';
                        final statusColor = isIssued
                            ? AppColors.statusCompliantGreen
                            : AppColors.statusReviewAmber;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: AppColors.cardBackground,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: AppColors.cardBorder, width: 1),
                            boxShadow: AppColors.cardShadow,
                          ),
                          child: Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              splashColor:
                                  AppColors.accentBlue.withValues(alpha: 0.08),
                              onTap: () {
                                if (report['type'] == 'Show Cause Notice') {
                                  context.push(AppRoutes.showCauseNotice
                                      .replaceAll(
                                          ':verdictId', report['id']!));
                                }
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
                                            AppColors.accentBlue
                                                .withValues(alpha: 0.15),
                                            AppColors.accentBlue
                                                .withValues(alpha: 0.06),
                                          ],
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12),
                                      ),
                                      child: const Icon(
                                        Symbols.description_rounded,
                                        color: AppColors.accentBlue,
                                        size: 22,
                                        fill: 1,
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    // Info
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(report['id']!,
                                              style:
                                                  AppTextStyles.titleMedium),
                                          const SizedBox(height: 2),
                                          Text(report['type']!,
                                              style:
                                                  AppTextStyles.bodyMedium),
                                          const SizedBox(height: 2),
                                          Text('Date: ${report['date']}',
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
                                            AppColors.statusGlow(statusColor),
                                      ),
                                      child: Text(
                                        report['status']!.toUpperCase(),
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
