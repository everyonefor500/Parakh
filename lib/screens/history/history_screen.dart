import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../providers/app_state_provider.dart';
import '../../router/app_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/filter_chip_row.dart';
import '../../widgets/inspection_card.dart';
import '../../widgets/empty_state.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = [
    'All',
    'Compliant',
    'Non-Compliant',
    'Review',
  ];

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateProvider>();
    final scans = appState.allScans;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('History', style: AppTextStyles.headlineLarge),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.accentBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.accentBlue.withValues(alpha: 0.25),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      '${scans.length} scans',
                      style: AppTextStyles.labelMedium
                          .copyWith(color: AppColors.accentBlue),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // ── Filter Chips ─────────────────────────────────
            FilterChipRow(
              filters: _filters,
              selectedFilter: _selectedFilter,
              onSelected: (filter) =>
                  setState(() => _selectedFilter = filter),
            ),

            // ── List ─────────────────────────────────────────
            Expanded(
              child: scans.isEmpty
                  ? EmptyState(
                      icon: Symbols.history_rounded,
                      title: 'No inspections yet',
                      message:
                          'Completed scans will appear here for review.',
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                      itemCount: scans.length,
                      itemBuilder: (context, index) {
                        final scan = scans[index];
                        final verdict =
                            appState.verdictForScan(scan.id);
                        return Dismissible(
                          key: Key(scan.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 24.0),
                            margin: const EdgeInsets.only(bottom: 12.0),
                            decoration: BoxDecoration(
                              color: AppColors.statusViolationRed,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Symbols.delete_rounded,
                              color: Colors.white,
                              size: 28,
                              fill: 1,
                            ),
                          ),
                          confirmDismiss: (direction) async {
                            return await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: AppColors.cardBackground,
                                  title: Text("Confirm Delete", style: AppTextStyles.titleLarge),
                                  content: Text("Are you sure you want to delete this scan? This action cannot be undone.", style: AppTextStyles.bodyMedium),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(false),
                                      child: Text("CANCEL", style: AppTextStyles.labelMedium.copyWith(color: AppColors.textSecondary)),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(true),
                                      child: Text("DELETE", style: AppTextStyles.labelMedium.copyWith(color: AppColors.statusViolationRed)),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          onDismissed: (direction) async {
                            try {
                              await context.read<AppStateProvider>().deleteScan(scan.id);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Scan deleted successfully'),
                                    backgroundColor: AppColors.statusCompliantGreen,
                                  ),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Failed to delete scan'),
                                    backgroundColor: AppColors.statusViolationRed,
                                  ),
                                );
                                // Refresh to restore item
                                context.read<AppStateProvider>().fetchHistory();
                              }
                            }
                          },
                          child: InspectionCard(
                            scan: scan,
                            verdict: verdict,
                            productName: scan.productId != null
                                ? 'Product ${scan.productId}'
                                : 'Unknown Product',
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
      ),
    );
  }
}
