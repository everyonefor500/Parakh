import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../router/app_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class ReportsListScreen extends StatelessWidget {
  const ReportsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock reports
    final mockReports = [
      {'id': 'RPT-2026-001', 'date': '2026-09-10', 'type': 'Show Cause Notice', 'status': 'Issued'},
      {'id': 'RPT-2026-002', 'date': '2026-09-08', 'type': 'Inspection Report', 'status': 'Draft'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports & Notices'),
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: mockReports.length,
        itemBuilder: (context, index) {
          final report = mockReports[index];
          return Card(
            color: AppColors.cardBackgroundElevated,
            margin: const EdgeInsets.only(bottom: 12.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: AppColors.divider),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16.0),
              leading: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.bgSecondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.picture_as_pdf, color: AppColors.accentBlue),
              ),
              title: Text(report['id']!, style: AppTextStyles.titleMedium),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(report['type']!, style: AppTextStyles.bodyMedium),
                  const SizedBox(height: 4),
                  Text('Date: ${report['date']}', style: AppTextStyles.labelSmall),
                ],
              ),
              trailing: Chip(
                label: Text(report['status']!),
                backgroundColor: report['status'] == 'Issued' 
                    ? AppColors.statusCompliantGreen.withValues(alpha: 0.15)
                    : AppColors.statusReviewAmber.withValues(alpha: 0.15),
                labelStyle: AppTextStyles.labelSmall.copyWith(
                  color: report['status'] == 'Issued' 
                      ? AppColors.statusCompliantGreen
                      : AppColors.statusReviewAmber,
                ),
                side: BorderSide.none,
              ),
              onTap: () {
                if (report['type'] == 'Show Cause Notice') {
                  context.push(AppRoutes.showCauseNotice.replaceAll(':noticeId', report['id']!));
                }
              },
            ),
          );
        },
      ),
    );
  }
}
