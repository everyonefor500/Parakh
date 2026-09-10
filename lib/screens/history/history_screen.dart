import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state_provider.dart';
import '../../router/app_router.dart';
import '../../widgets/filter_chip_row.dart';
import '../../widgets/inspection_card.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Compliant', 'Non-Compliant', 'Review'];

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateProvider>();
    final scans = appState.allScans;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inspection History'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          FilterChipRow(
            filters: _filters,
            selectedFilter: _selectedFilter,
            onSelected: (filter) {
              setState(() {
                _selectedFilter = filter;
              });
            },
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: scans.length,
              itemBuilder: (context, index) {
                final scan = scans[index];
                final verdict = appState.verdictForScan(scan.id);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: InspectionCard(
                    scan: scan,
                    verdict: verdict,
                    productName: scan.productId != null ? 'Product ${scan.productId}' : 'Unknown Product',
                    onTap: () {
                      if (verdict != null) {
                        context.push(AppRoutes.scanVerdict);
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
