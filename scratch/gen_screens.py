import os

files = {
    'lib/screens/home/officer_dashboard_screen.dart': 'OfficerDashboardScreen',
    'lib/screens/home/consumer_home_screen.dart': 'ConsumerHomeScreen',
    'lib/screens/home/seller_dashboard_screen.dart': 'SellerDashboardScreen',
    'lib/screens/scan/scanner_screen.dart': 'ScannerScreen',
    'lib/screens/scan/ai_processing_screen.dart': 'AiProcessingScreen',
    'lib/screens/scan/extracted_info_screen.dart': 'ExtractedInfoScreen',
    'lib/screens/scan/compliance_analysis_screen.dart': 'ComplianceAnalysisScreen',
    'lib/screens/scan/verdict_screen.dart': 'VerdictScreen',
    'lib/screens/scan/violation_details_screen.dart': 'ViolationDetailsScreen',
    'lib/screens/history/inspection_history_screen.dart': 'InspectionHistoryScreen',
    'lib/screens/reports/report_generation_screen.dart': 'ReportGenerationScreen',
    'lib/screens/reports/show_cause_notice_screen.dart': 'ShowCauseNoticeScreen',
    'lib/screens/consumer/consumer_result_screen.dart': 'ConsumerResultScreen',
    'lib/screens/consumer/consumer_grievance_screen.dart': 'ConsumerGrievanceScreen',
    'lib/screens/marketplace/bulk_scanner_screen.dart': 'BulkScannerScreen',
    'lib/screens/analytics/officer_analytics_screen.dart': 'OfficerAnalyticsScreen',
    'lib/screens/profile/profile_screen.dart': 'ProfileScreen'
}

for path, class_name in files.items():
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, 'w') as f:
        f.write(f'''import 'package:flutter/material.dart';

class {class_name} extends StatelessWidget {{
  const {class_name}({{super.key}});

  @override
  Widget build(BuildContext context) {{
    return Scaffold(
      appBar: AppBar(title: const Text('{class_name}')),
      body: Center(child: const Text('{class_name}')),
    );
  }}
}}
''')
