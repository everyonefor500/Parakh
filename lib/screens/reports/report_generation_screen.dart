import 'dart:io';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:printing/printing.dart';
import '../../theme/app_colors.dart';
import '../../widgets/primary_button.dart';
import '../../providers/app_state_provider.dart';
import '../../models/scan.dart';
import '../../models/compliance_verdict.dart';
import '../../models/violation.dart';

class ReportGenerationScreen extends StatefulWidget {
  final String? verdictId;

  const ReportGenerationScreen({super.key, this.verdictId});

  @override
  State<ReportGenerationScreen> createState() => _ReportGenerationScreenState();
}

class _ReportGenerationScreenState extends State<ReportGenerationScreen> {
  bool _isGenerating = false;
  bool _isLoading = true;
  Scan? _scan;
  ComplianceVerdict? _verdict;
  List<Violation> _violations = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    debugPrint('[NAV_LOG] ReportGenerationScreen _loadData started. Passed verdictId: ${widget.verdictId}');
    if (widget.verdictId == null) {
      debugPrint('[NAV_LOG] widget.verdictId is null, stopping _loadData.');
      setState(() => _isLoading = false);
      return;
    }
    
    final appState = context.read<AppStateProvider>();
    _verdict = appState.allVerdicts.where((v) => v.id == widget.verdictId).firstOrNull;
    
    if (_verdict != null) {
      debugPrint('[NAV_LOG] Verdict found in AppStateProvider. id=${_verdict!.id}');
      _scan = appState.allScans.where((s) => s.id == _verdict!.scanId).firstOrNull;
      _violations = appState.violationsForVerdict(_verdict!.id);
      if (_scan != null) {
         debugPrint('[NAV_LOG] Scan found in AppStateProvider. scanId=${_scan!.id}');
         setState(() => _isLoading = false);
         return;
      }
    } else {
      debugPrint('[NAV_LOG] Verdict NOT found in AppStateProvider. Proceeding to fetch from Supabase...');
    }
    
    try {
      final supabase = Supabase.instance.client;
      debugPrint('[NAV_LOG] Querying Supabase compliance_verdicts with id = ${widget.verdictId!}');
      final verdictRes = await supabase.from('compliance_verdicts').select().eq('id', widget.verdictId!).maybeSingle();
      if (verdictRes != null) {
        debugPrint('[NAV_LOG] Supabase query returned row: $verdictRes');
        _verdict = ComplianceVerdict.fromJson(verdictRes);
        final scanRes = await supabase.from('scans').select().eq('id', _verdict!.scanId).maybeSingle();
        if (scanRes != null) {
          _scan = Scan.fromJson(scanRes);
        }
        final vioRes = await supabase.from('violations').select().eq('verdict_id', _verdict!.id);
        _violations = (vioRes as List).map((v) => Violation.fromJson(v)).toList();
      } else {
        debugPrint('[NAV_LOG] Supabase query returned EMPTY (no row found for id ${widget.verdictId!})');
      }
    } catch (e) {
      debugPrint('[NAV_LOG] Error fetching report data from Supabase: $e');
    }
    
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _generateAndSavePdf(BuildContext context, Scan scan, ComplianceVerdict verdict, List<Violation> violations) async {
    setState(() => _isGenerating = true);
    
    try {
      final font = await PdfGoogleFonts.robotoRegular();
      final boldFont = await PdfGoogleFonts.robotoBold();
      
      final pdf = pw.Document(
        theme: pw.ThemeData.withFont(
          base: font,
          bold: boldFont,
        ),
      );
      
      final isCompliant = verdict.status == VerdictStatus.compliant;
      final statusText = isCompliant ? 'COMPLIANT' : 'NON-COMPLIANT';
      final productLabel = scan.productId ?? 'Unknown Product';
      
      if (!context.mounted) return;
      final appState = context.read<AppStateProvider>();
      final currentUser = appState.currentUser;
      final officerName = currentUser?.fullName ?? 'Officer';
      final officerId = currentUser?.id ?? 'unknown_officer';

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  padding: const pw.EdgeInsets.all(20),
                  decoration: const pw.BoxDecoration(
                    color: PdfColor.fromInt(0xFFF8FAFF),
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: [
                          pw.Text('LEGAL METROLOGY ENFORCEMENT DIVISION', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                          pw.Text('PARAKH VERIFICATION REPORT', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800)),
                        ],
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 24),
                  child: pw.TableHelper.fromTextArray(
                    context: context,
                    data: <List<String>>[
                      ['Inspection Date', DateFormat('dd-MMM-yyyy').format(scan.createdAt)],
                      ['Inspector Name', officerName],
                      ['Product Name', productLabel],
                      ['Scan ID', scan.id.substring(0, 8)],
                      ['Compliance Score', '${verdict.complianceScore.toStringAsFixed(0)}%'],
                      ['Result', statusText],
                    ],
                    border: pw.TableBorder.all(color: PdfColors.grey300),
                    headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    cellAlignment: pw.Alignment.centerLeft,
                    cellPadding: const pw.EdgeInsets.all(6),
                  ),
                ),
                pw.SizedBox(height: 24),
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 24),
                  child: pw.Text('VIOLATIONS SUMMARY', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.grey700)),
                ),
                pw.SizedBox(height: 10),
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 24),
                  child: violations.isEmpty 
                  ? pw.Text('No violations detected.', style: pw.TextStyle(fontSize: 12))
                  : pw.TableHelper.fromTextArray(
                    context: context,
                    data: <List<String>>[
                      ['Rule', 'Issue', 'Value Found'],
                      ...violations.map((v) => [v.ruleId, v.issueTitle, v.detectedValue ?? 'N/A']),
                    ],
                    border: pw.TableBorder.all(color: PdfColors.grey300),
                    headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
                    headerDecoration: const pw.BoxDecoration(color: PdfColors.blue800),
                    cellAlignment: pw.Alignment.centerLeft,
                    cellPadding: const pw.EdgeInsets.all(6),
                  ),
                ),
                pw.Spacer(),
                pw.Center(
                  child: pw.Text('DIGITALLY VERIFIED STAMP', style: pw.TextStyle(fontSize: 12, color: PdfColors.grey400, fontWeight: pw.FontWeight.bold)),
                ),
                pw.SizedBox(height: 16),
                pw.Container(
                  padding: const pw.EdgeInsets.all(16),
                  decoration: const pw.BoxDecoration(
                    color: PdfColor.fromInt(0xFFF8FAFF),
                  ),
                  child: pw.Center(
                    child: pw.Text('Certified under Legal Metrology (Packaged Commodities) Rules, 2011 | Parakh Inspection System', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey)),
                  ),
                ),
              ],
            );
          },
        ),
      );

      final pdfBytes = await pdf.save();
      final fileName = "Parakh_Report_${scan.id.substring(0,6)}.pdf";
      
      final supabase = Supabase.instance.client;
      final storagePath = '$officerId/${const Uuid().v4()}.pdf';
      
      try {
        await supabase.storage.from('reports').uploadBinary(storagePath, pdfBytes);
        final reportUrl = supabase.storage.from('reports').getPublicUrl(storagePath);
        
        await supabase.from('reports').insert({
          'id': const Uuid().v4(),
          'verdict_id': verdict.id,
          'generated_by': officerId,
          'report_url': reportUrl,
          'status': 'generated',
          'created_at': DateTime.now().toIso8601String(),
        });
      } catch (storageErr) {
        debugPrint('Could not upload to storage or insert to DB: $storageErr');
        // We continue despite storage errors so the user can still get the local PDF
      }

      if (context.mounted) {
        final dir = await getApplicationDocumentsDirectory();
        final file = File('${dir.path}/$fileName');
        await file.writeAsBytes(pdfBytes);
        
        if (!context.mounted) return;
        setState(() => _isGenerating = false);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Report generated successfully!'),
            backgroundColor: context.appColors.statusCompliantGreen,
            duration: const Duration(seconds: 3),
          ),
        );
        
        // Share via printing package natively
        await Printing.sharePdf(bytes: pdfBytes, filename: fileName);
      }
    } catch (e, stackTrace) {
      debugPrint("Error saving PDF: $e\n$stackTrace");
      if (context.mounted) {
        setState(() => _isGenerating = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to generate report. Check your internet connection for fonts. Error: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.verdictId == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Report Generation Error')),
        body: Center(child: Text('Verdict ID is required')),
      );
    }
    
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Generate Report')),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    
    if (_verdict == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Generate Report')),
        body: Center(child: Text('Verdict not found.')),
      );
    }
    
    if (_scan == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Generate Report')),
        body: Center(child: Text('Scan not found.')),
      );
    }
    
    final appState = context.watch<AppStateProvider>();
    final officerName = appState.currentUser?.fullName ?? 'Officer';
    final productLabel = _scan!.productId ?? 'Unknown Product';
    final isCompliant = _verdict!.status == VerdictStatus.compliant;
    
    // Bug 5 requirement: Show score prominently on report screen
    final score = _verdict!.complianceScore;
    Color scoreColor;
    if (score >= 90) {
      scoreColor = context.appColors.statusCompliantGreen;
    } else if (score >= 70) {
      scoreColor = context.appColors.statusReviewAmber;
    } else {
      scoreColor = context.appColors.statusViolationRed;
    }

    return Scaffold(
      backgroundColor: context.appColors.bgPrimary,
      appBar: AppBar(
        title: Text('Generate Report'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Paper document container
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.18),
                            blurRadius: 28,
                            spreadRadius: 0,
                            offset: const Offset(0, 8),
                          ),
                          BoxShadow(
                            color: context.appColors.accentBlue.withValues(alpha: 0.06),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Document header bar
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                            decoration: const BoxDecoration(
                              color: Color(0xFFF8FAFF),
                              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                              border: Border(bottom: BorderSide(color: Color(0xFFE5EAF3), width: 1)),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: context.appColors.accentBlue.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    Symbols.description_rounded,
                                    color: context.appColors.accentBlue,
                                    size: 20,
                                    fill: 1,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'LEGAL METROLOGY COMPLIANCE REPORT',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.black87,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        'Parakh Verification Report',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.black38,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Document body
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _docRow('Date', DateFormat('dd-MMM-yyyy').format(_scan!.createdAt)),
                                _docDivider(),
                                _docRow('Officer', officerName),
                                _docDivider(),
                                _docRow('Product', productLabel),
                                _docDivider(),
                                _docRow('Score', '${score.toStringAsFixed(0)}%', valueColor: scoreColor, valueBold: true),
                                _docDivider(),
                                _docRow('Result', isCompliant ? 'COMPLIANT' : 'NON-COMPLIANT', valueColor: isCompliant ? Colors.green.shade700 : Colors.red.shade700, valueBold: true),
                                SizedBox(height: 24),
                                Text(
                                  'COMPLIANCE VERIFICATION SUMMARY',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black45,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                SizedBox(height: 10),
                                if (_violations.isEmpty)
                                  Text('No violations detected.', style: TextStyle(fontSize: 13, color: Colors.black87))
                                else
                                  ..._violations.map((v) => Column(
                                    children: [
                                      _summaryItem('FAIL', '${v.ruleId} — ${v.issueTitle}'),
                                      SizedBox(height: 8),
                                    ],
                                  )),
                              ],
                            ),
                          ),

                          // Document footer
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              color: Color(0xFFF8FAFF),
                              borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
                              border: Border(top: BorderSide(color: Color(0xFFE5EAF3), width: 1)),
                            ),
                            child: Row(
                              children: [
                                Icon(Symbols.verified_rounded, size: 14, color: Colors.black26),
                                SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'Certified under Legal Metrology (Packaged Commodities) Rules, 2011 | Parakh Inspection System',
                                    style: TextStyle(fontSize: 10, color: Colors.black38),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Save button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: _isGenerating 
                ? Center(child: CircularProgressIndicator())
                : PrimaryButton(
                text: 'Save Report to Downloads',
                icon: Symbols.download_rounded,
                onPressed: () async {
                  await _generateAndSavePdf(context, _scan!, _verdict!, _violations);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _docRow(String label, String value, {Color? valueColor, bool valueBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black38,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: valueColor ?? Colors.black87,
                fontWeight: valueBold ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _docDivider() => Divider(height: 1, thickness: 1, color: Color(0xFFEEF1F8));

  Widget _summaryItem(String status, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.red.shade200),
          ),
          child: Text(
            status,
            style: TextStyle(fontSize: 10, color: Colors.red.shade700, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            description,
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          ),
        ),
      ],
    );
  }
}
