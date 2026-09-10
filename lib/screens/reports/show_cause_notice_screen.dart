import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../router/app_router.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/primary_button.dart';

class ShowCauseNoticeScreen extends StatelessWidget {
  const ShowCauseNoticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Show Cause Notice')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32.0),
                  decoration: BoxDecoration(
                    color: Colors.white, // Light theme exception
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            const Icon(Icons.account_balance, color: Colors.black, size: 48),
                            const SizedBox(height: 16),
                            Text(
                              'GOVERNMENT OF INDIA',
                              style: AppTextStyles.titleMedium.copyWith(color: Colors.black),
                            ),
                            Text(
                              'DEPARTMENT OF LEGAL METROLOGY',
                              style: AppTextStyles.titleMedium.copyWith(color: Colors.black),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'SHOW CAUSE NOTICE',
                              style: AppTextStyles.headlineMedium.copyWith(
                                color: Colors.black,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text('To,', style: AppTextStyles.bodyMedium.copyWith(color: Colors.black87)),
                      Text('The Manufacturer,', style: AppTextStyles.bodyMedium.copyWith(color: Colors.black87)),
                      Text('Fresh Foods Ltd', style: AppTextStyles.bodyMedium.copyWith(color: Colors.black87, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 24),
                      Text(
                        'Subject: Notice for non-compliance under Legal Metrology (Packaged Commodities) Rules, 2011.',
                        style: AppTextStyles.bodyMedium.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'During an inspection on 10-Sep-2026, it was observed that your product "Fresh Apple Juice" is in violation of Rule 6(1)(e) (Missing Expiry Date).',
                        style: AppTextStyles.bodyMedium.copyWith(color: Colors.black87),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'You are hereby directed to show cause within 15 days as to why action should not be initiated against you.',
                        style: AppTextStyles.bodyMedium.copyWith(color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: PrimaryButton(
                text: 'Issue Notice',
                onPressed: () {
                  context.go(AppRoutes.reports);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
