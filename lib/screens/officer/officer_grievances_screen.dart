import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

import '../../providers/app_state_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/filter_chip_row.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/primary_button.dart';
import '../../models/complaint.dart';

class OfficerGrievancesScreen extends StatefulWidget {
  const OfficerGrievancesScreen({super.key});

  @override
  State<OfficerGrievancesScreen> createState() => _OfficerGrievancesScreenState();
}

class _OfficerGrievancesScreenState extends State<OfficerGrievancesScreen> {
  String _selectedFilter = 'Pending';
  final List<String> _filters = ['Pending', 'Reviewing', 'Resolved', 'Rejected', 'All'];
  
  List<Complaint> _grievances = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchGrievances();
  }

  Future<void> _fetchGrievances() async {
    setState(() => _isLoading = true);
    try {
      final response = await Supabase.instance.client
          .from('complaints')
          .select()
          .order('created_at', ascending: false);

      if (mounted) {
        setState(() {
          _grievances = (response as List).map((c) => Complaint.fromJson(c)).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching officer grievances: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  List<Complaint> get _filteredGrievances {
    if (_selectedFilter == 'All') return _grievances;
    
    final statusMap = {
      'Pending': ComplaintStatus.submitted,
      'Reviewing': ComplaintStatus.inReview,
      'Resolved': ComplaintStatus.resolved,
      'Rejected': ComplaintStatus.rejected,
    };
    
    final targetStatus = statusMap[_selectedFilter];
    return _grievances.where((g) => g.status == targetStatus).toList();
  }

  Color _getStatusColor(ComplaintStatus status) {
    switch (status) {
      case ComplaintStatus.submitted: return context.appColors.accentBlue;
      case ComplaintStatus.inReview: return context.appColors.statusReviewAmber;
      case ComplaintStatus.resolved: return context.appColors.statusCompliantGreen;
      case ComplaintStatus.rejected: return context.appColors.statusViolationRed;
    }
  }

  String _getStatusText(ComplaintStatus status) {
    switch (status) {
      case ComplaintStatus.submitted: return 'PENDING';
      case ComplaintStatus.inReview: return 'REVIEWING';
      case ComplaintStatus.resolved: return 'RESOLVED';
      case ComplaintStatus.rejected: return 'REJECTED';
    }
  }

  void _showGrievanceDetail(Complaint grievance) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _GrievanceDetailSheet(
        grievance: grievance,
        onStatusChanged: () {
          Navigator.pop(ctx);
          _fetchGrievances();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = _filteredGrievances;

    return Scaffold(
      appBar: AppBar(
        title: Text('Consumer Grievances'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchGrievances,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 16),
            FilterChipRow(
              filters: _filters,
              selectedFilter: _selectedFilter,
              onSelected: (filter) {
                setState(() => _selectedFilter = filter);
              },
            ),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : list.isEmpty
                      ? EmptyState(
                          icon: Symbols.report_rounded,
                          title: 'No grievances',
                          message: 'There are no grievances in this category.',
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(24),
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            final g = list[index];
                            final statusColor = _getStatusColor(g.status);
                            
                            return GestureDetector(
                              onTap: () => _showGrievanceDetail(g),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: context.appColors.cardBackground,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: context.appColors.cardBorder, width: 1),
                                  boxShadow: context.appColors.cardShadow,
                                ),
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
                                          Text(
                                            g.productName ?? g.productId ?? 'Unknown Product',
                                            style: AppTextStyles.titleMedium,
                                          ),
                                          SizedBox(height: 2),
                                          Text(
                                            g.complaintCode,
                                            style: AppTextStyles.bodyMedium.copyWith(color: context.appColors.textSecondary),
                                          ),
                                          SizedBox(height: 2),
                                          Text(
                                            DateFormat('dd-MMM-yyyy').format(g.createdAt),
                                            style: AppTextStyles.labelSmall,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: statusColor.withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(color: statusColor.withValues(alpha: 0.3), width: 1),
                                      ),
                                      child: Text(
                                        _getStatusText(g.status),
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

class _GrievanceDetailSheet extends StatefulWidget {
  final Complaint grievance;
  final VoidCallback onStatusChanged;

  const _GrievanceDetailSheet({required this.grievance, required this.onStatusChanged});

  @override
  State<_GrievanceDetailSheet> createState() => _GrievanceDetailSheetState();
}

class _GrievanceDetailSheetState extends State<_GrievanceDetailSheet> {
  bool _isProcessing = false;
  String? _resolvedEvidenceUrl;

  @override
  void initState() {
    super.initState();
    _resolveEvidenceUrl();
  }

  Future<void> _resolveEvidenceUrl() async {
    final urlOrPath = widget.grievance.evidenceUrl;
    if (urlOrPath == null || urlOrPath.isEmpty) return;
    
    try {
      String path = urlOrPath;
      if (path.contains('/object/public/grievance-evidence/')) {
        path = path.split('/object/public/grievance-evidence/').last;
      } else if (path.startsWith('http')) {
        setState(() => _resolvedEvidenceUrl = path);
        return;
      }
      
      final signed = await Supabase.instance.client.storage
          .from('grievance-evidence')
          .createSignedUrl(path, 60 * 60);
      
      if (mounted) {
        setState(() => _resolvedEvidenceUrl = signed);
      }
    } catch (e) {
      debugPrint('Error resolving evidence URL: $e');
      if (mounted) setState(() => _resolvedEvidenceUrl = urlOrPath);
    }
  }

  Future<void> _downloadImage() async {
    if (_resolvedEvidenceUrl == null) return;
    setState(() => _isProcessing = true);
    try {
      final response = await http.get(Uri.parse(_resolvedEvidenceUrl!));
      if (response.statusCode == 200) {
        final dir = await getApplicationDocumentsDirectory();
        final file = File('${dir.path}/Evidence_${widget.grievance.complaintCode}.jpg');
        await file.writeAsBytes(response.bodyBytes);
        
        await Share.shareXFiles([XFile(file.path)], text: 'Evidence for ${widget.grievance.complaintCode}');
      } else {
        throw Exception('Failed to download image from URL');
      }
    } catch (e) {
      debugPrint('Error downloading image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to download image'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _updateStatus(String newStatus, {String? notes}) async {
    setState(() => _isProcessing = true);
    try {
      final user = context.read<AppStateProvider>().currentUser;
      await Supabase.instance.client.from('complaints').update({
        'status': newStatus,
        'reviewed_by': user?.id,
        'reviewed_at': DateTime.now().toIso8601String(),
        if (notes != null) 'officer_notes': notes,
      }).eq('id', widget.grievance.id);
      
      widget.onStatusChanged();
    } catch (e) {
      debugPrint('Error updating grievance status: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update status'), backgroundColor: Colors.red),
        );
        setState(() => _isProcessing = false);
      }
    }
  }

  void _showRejectDialog() {
    final notesController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Reject Grievance'),
        content: TextField(
          controller: notesController,
          decoration: InputDecoration(
            hintText: 'Reason for rejection',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              if (notesController.text.trim().isNotEmpty) {
                _updateStatus('rejected', notes: notesController.text.trim());
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Reason is required to reject'), backgroundColor: Colors.red),
                );
              }
            },
            child: Text('Reject', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _generateAndDownloadPdf() async {
    setState(() => _isProcessing = true);
    try {
      final font = await PdfGoogleFonts.robotoRegular();
      final boldFont = await PdfGoogleFonts.robotoBold();
      
      final pdf = pw.Document(
        theme: pw.ThemeData.withFont(base: font, bold: boldFont),
      );
      
      final g = widget.grievance;
      final officerName = context.read<AppStateProvider>().currentUser?.fullName ?? 'Officer';
      final officerId = context.read<AppStateProvider>().currentUser?.id ?? 'unknown_officer';
      
      pw.MemoryImage? evidenceImagePdf;
      if (_resolvedEvidenceUrl != null) {
        try {
          final response = await http.get(Uri.parse(_resolvedEvidenceUrl!));
          if (response.statusCode == 200) {
            evidenceImagePdf = pw.MemoryImage(response.bodyBytes);
          }
        } catch (e) {
          debugPrint('Error loading evidence image for PDF: $e');
        }
      }

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  padding: const pw.EdgeInsets.all(20),
                  decoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFFF8FAFF)),
                  child: pw.Center(
                    child: pw.Column(
                      children: [
                        pw.Text('LEGAL METROLOGY ENFORCEMENT DIVISION', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                        pw.Text('GRIEVANCE REPORT', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800)),
                      ],
                    ),
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 24),
                  child: pw.TableHelper.fromTextArray(
                    context: context,
                    data: <List<String>>[
                      ['Complaint Code', g.complaintCode],
                      ['Submitted Date', DateFormat('dd-MMM-yyyy HH:mm').format(g.createdAt)],
                      ['Product Name', g.productName ?? g.productId ?? 'N/A'],
                      ['Shop/Seller', g.shopSellerName ?? 'N/A'],
                      ['Status', g.status.name.toUpperCase()],
                      ['Reviewing Officer', officerName],
                    ],
                    border: pw.TableBorder.all(color: PdfColors.grey300),
                    headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    cellAlignment: pw.Alignment.centerLeft,
                    cellPadding: const pw.EdgeInsets.all(6),
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 24),
                  child: pw.Text('Issue Description:', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 24),
                  child: pw.Text(g.description, style: pw.TextStyle(fontSize: 12)),
                ),
                if (g.officerNotes != null && g.officerNotes!.isNotEmpty) ...[
                  pw.SizedBox(height: 16),
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 24),
                    child: pw.Text('Officer Notes:', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.red800)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 24),
                    child: pw.Text(g.officerNotes!, style: pw.TextStyle(fontSize: 12, color: PdfColors.red800)),
                  ),
                ],
                if (evidenceImagePdf != null) ...[
                  pw.SizedBox(height: 16),
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 24),
                    child: pw.Text('Evidence:', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.SizedBox(height: 8),
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 24),
                    child: pw.Image(evidenceImagePdf, height: 200),
                  ),
                ],
                pw.Spacer(),
                pw.Container(
                  padding: const pw.EdgeInsets.all(16),
                  decoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFFF8FAFF)),
                  child: pw.Center(
                    child: pw.Text('Generated by Parakh Inspection System', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey)),
                  ),
                ),
              ],
            );
          },
        ),
      );

      final pdfBytes = await pdf.save();
      final fileName = "Parakh_Grievance_${g.complaintCode}.pdf";
      
      final supabase = Supabase.instance.client;
      final storagePath = '$officerId/${const Uuid().v4()}.pdf';
      
      try {
        await supabase.storage.from('reports').uploadBinary(storagePath, pdfBytes);
        final reportUrl = supabase.storage.from('reports').getPublicUrl(storagePath);
        
        // Optionally insert into reports table if we want it to show in the Reports list.
        await supabase.from('reports').insert({
          'id': const Uuid().v4(),
          'verdict_id': g.id, // Using grievance ID as verdict_id to link it
          'generated_by': officerId,
          'report_url': reportUrl,
          'status': 'generated',
          'created_at': DateTime.now().toIso8601String(),
        });
      } catch (err) {
        debugPrint('Failed to save to Supabase Storage: $err');
      }

      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$fileName');
      await file.writeAsBytes(pdfBytes);
      
      if (mounted) {
        setState(() => _isProcessing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('PDF generated successfully!'), backgroundColor: Colors.green),
        );
        await Printing.sharePdf(bytes: pdfBytes, filename: fileName);
      }
    } catch (e) {
      debugPrint('Error generating PDF: $e');
      if (mounted) {
        setState(() => _isProcessing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to generate PDF'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final g = widget.grievance;
    
    return Container(
      decoration: BoxDecoration(
        color: context.appColors.bgPrimary,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 6,
                  decoration: BoxDecoration(
                    color: context.appColors.cardBorder,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Grievance ${g.complaintCode}',
                      style: AppTextStyles.headlineMedium,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: context.appColors.cardBorder,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      g.status.name.toUpperCase(),
                      style: AppTextStyles.overline,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              
              _detailRow('Product', g.productName ?? g.productId ?? 'N/A'),
              _detailRow('Shop', g.shopSellerName ?? 'N/A'),
              _detailRow('Date', DateFormat('dd-MMM-yyyy HH:mm').format(g.createdAt)),
              
              SizedBox(height: 16),
              Text('Description', style: AppTextStyles.titleMedium),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.appColors.bgSecondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(g.description, style: AppTextStyles.bodyMedium),
              ),
              
              if (g.officerNotes != null && g.officerNotes!.isNotEmpty) ...[
                SizedBox(height: 16),
                Text('Officer Notes', style: AppTextStyles.titleMedium.copyWith(color: context.appColors.statusViolationRed)),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: context.appColors.statusViolationRed.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: context.appColors.statusViolationRed.withValues(alpha: 0.2)),
                  ),
                  child: Text(g.officerNotes!, style: AppTextStyles.bodyMedium.copyWith(color: context.appColors.statusViolationRed)),
                ),
              ],
              
              if (g.evidenceUrl != null) ...[
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Evidence', style: AppTextStyles.titleMedium),
                    if (_resolvedEvidenceUrl != null)
                      TextButton.icon(
                        onPressed: _isProcessing ? null : _downloadImage,
                        icon: Icon(Symbols.download_rounded, size: 18),
                        label: Text('Download Image'),
                        style: TextButton.styleFrom(
                          foregroundColor: context.appColors.accentBlue,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 8),
                if (_resolvedEvidenceUrl == null)
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: context.appColors.bgSecondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      _resolvedEvidenceUrl!,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, stack) => Container(
                        height: 200,
                        color: context.appColors.bgSecondary,
                        child: Center(child: Icon(Symbols.broken_image_rounded)),
                      ),
                    ),
                  ),
              ],
              
              SizedBox(height: 32),
              
              if (_isProcessing)
                Center(child: CircularProgressIndicator())
              else ...[
                if (g.status == ComplaintStatus.submitted) ...[
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _showRejectDialog,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: context.appColors.statusViolationRed,
                            side: BorderSide(color: context.appColors.statusViolationRed),
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: Text('Reject', style: AppTextStyles.labelLarge),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _updateStatus('in_review'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.appColors.accentBlue,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: Text('Accept for Review', style: AppTextStyles.labelLarge.copyWith(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  PrimaryButton(
                    text: 'Download PDF Summary',
                    icon: Symbols.download_rounded,
                    onPressed: _generateAndDownloadPdf,
                  ),
                  if (g.status == ComplaintStatus.inReview) ...[
                    SizedBox(height: 16),
                    PrimaryButton(
                      text: 'Mark as Resolved',
                      icon: Symbols.check_circle_rounded,
                      onPressed: () => _updateStatus('resolved'),
                    ),
                  ],
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey)),
          ),
          Expanded(
            child: Text(value, style: AppTextStyles.bodyMedium),
          ),
        ],
      ),
    );
  }
}
