import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/empty_state.dart';
import '../../models/complaint.dart';

class ConsumerGrievancesListScreen extends StatefulWidget {
  const ConsumerGrievancesListScreen({super.key});

  @override
  State<ConsumerGrievancesListScreen> createState() => _ConsumerGrievancesListScreenState();
}

class _ConsumerGrievancesListScreenState extends State<ConsumerGrievancesListScreen> {
  List<Complaint> _grievances = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchGrievances();
  }

  Future<void> _fetchGrievances() async {
    final user = context.read<AppStateProvider>().currentUser;
    if (user == null) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    try {
      final response = await Supabase.instance.client
          .from('complaints')
          .select()
          .eq('submitted_by', user.id)
          .order('created_at', ascending: false);

      if (mounted) {
        setState(() {
          _grievances = (response as List).map((c) => Complaint.fromJson(c)).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching grievances: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Color _getStatusColor(ComplaintStatus status) {
    switch (status) {
      case ComplaintStatus.submitted:
        return context.appColors.accentBlue;
      case ComplaintStatus.inReview:
        return context.appColors.statusReviewAmber;
      case ComplaintStatus.resolved:
        return context.appColors.statusCompliantGreen;
      case ComplaintStatus.rejected:
        return context.appColors.statusViolationRed;
    }
  }

  String _getStatusText(ComplaintStatus status) {
    switch (status) {
      case ComplaintStatus.submitted:
        return 'PENDING';
      case ComplaintStatus.inReview:
        return 'UNDER REVIEW';
      case ComplaintStatus.resolved:
        return 'RESOLVED';
      case ComplaintStatus.rejected:
        return 'REJECTED';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Grievances'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _grievances.isEmpty
                      ? EmptyState(
                          icon: Symbols.report_rounded,
                          title: 'No grievances filed',
                          message: 'When you file a grievance, it will appear here.',
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(24),
                          itemCount: _grievances.length,
                          itemBuilder: (context, index) {
                            final grievance = _grievances[index];
                            final statusColor = _getStatusColor(grievance.status);

                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: context.appColors.cardBackground,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: context.appColors.cardBorder, width: 1),
                                boxShadow: context.appColors.cardShadow,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            statusColor.withValues(alpha: 0.15),
                                            statusColor.withValues(alpha: 0.06),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        Symbols.report_rounded,
                                        color: statusColor,
                                        size: 22,
                                        fill: 1,
                                      ),
                                    ),
                                    SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(grievance.productName ?? grievance.productId ?? 'Unknown Product',
                                              style: AppTextStyles.titleMedium),
                                          if (grievance.shopSellerName != null && grievance.shopSellerName!.isNotEmpty) ...[
                                            SizedBox(height: 2),
                                            Text(grievance.shopSellerName!,
                                                style: AppTextStyles.bodyMedium),
                                          ],
                                          SizedBox(height: 2),
                                          Text('Date: ${DateFormat('dd-MMM-yyyy').format(grievance.createdAt)}',
                                              style: AppTextStyles.labelSmall),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: statusColor.withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: statusColor.withValues(alpha: 0.3),
                                          width: 1,
                                        ),
                                        boxShadow: context.appColors.statusGlow(statusColor),
                                      ),
                                      child: Text(
                                        _getStatusText(grievance.status),
                                        style: AppTextStyles.overline.copyWith(
                                          color: statusColor,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
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
