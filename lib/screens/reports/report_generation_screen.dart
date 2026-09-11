import 'dart:io';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:intl/intl.dart';
import '../../theme/app_colors.dart';
import '../../widgets/primary_button.dart';

class ReportGenerationScreen extends StatelessWidget {
  final String? verdictId;

  const ReportGenerationScreen({super.key, this.verdictId});

  Future<void> _generateAndSavePdf(BuildContext context) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
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
              
              // Metadata Table
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 24),
                child: pw.Table.fromTextArray(
                  context: context,
                  data: <List<String>>[
                    ['Inspection Date', DateFormat('dd-MMM-yyyy').format(DateTime.now())],
                    ['Inspector Name', 'Officer Parag Singh'],
                    ['Product Name', 'Haldiram\'s Aloo Bhujia Sev'],
                    ['Net Quantity', '200 g'],
                    ['Batch No', 'HAFH13'],
                    ['Barcode', '8904004400731'],
                    ['Result', 'COMPLIANT'],
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
                child: pw.Text('DECLARATION VERIFICATION CHECKLIST', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.grey700)),
              ),
              pw.SizedBox(height: 10),
              
              // Checklist Table
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 24),
                child: pw.Table.fromTextArray(
                  context: context,
                  data: <List<String>>[
                    ['Rule', 'Declaration', 'Status'],
                    ['Rule 6(1)(a)', 'Manufacturer & Packer details', 'PASS'],
                    ['Rule 6(1)(c)', 'Net Quantity declared (200 g)', 'PASS'],
                    ['Rule 6(1)(da)', 'Mandatory USP (Rs. 0.30 per g)', 'PASS'],
                    ['Rule 6(1)(e)', 'MRP inclusive of taxes (Rs. 60.00)', 'PASS'],
                    ['Rule 6(1)(f)', 'Consumer grievance details', 'PASS'],
                    ['Rule 10', 'Country of origin (India)', 'PASS'],
                  ],
                  border: pw.TableBorder.all(color: PdfColors.grey300),
                  headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
                  headerDecoration: const pw.BoxDecoration(color: PdfColors.blue800),
                  cellAlignment: pw.Alignment.centerLeft,
                  cellPadding: const pw.EdgeInsets.all(6),
                ),
              ),
              
              pw.Spacer(),
              
              // Footer / Watermark Text
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

    try {
      Directory? directory;
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      } else {
        directory = await getDownloadsDirectory();
      }

      if (directory != null) {
        final filePath = "${directory.path}/Parakh_Report_Haldiram_AlooBhujia.pdf";
        final file = File(filePath);
        await file.writeAsBytes(await pdf.save());

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Report saved to Downloads: Parakh_Report_Haldiram_AlooBhujia.pdf'),
              action: SnackBarAction(
                label: 'Open',
                onPressed: () {
                  OpenFilex.open(filePath);
                },
              ),
              duration: const Duration(seconds: 5),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint("Error saving PDF: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save report: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        title: const Text('Generate Report'),
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
                            color: AppColors.accentBlue.withValues(alpha: 0.06),
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
                                    color: AppColors.accentBlue.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Symbols.description_rounded,
                                    color: AppColors.accentBlue,
                                    size: 20,
                                    fill: 1,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'LEGAL METROLOGY COMPLIANCE REPORT',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.black87,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      const Text(
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
                                _docRow('Date', DateFormat('dd-MMM-yyyy').format(DateTime.now())),
                                _docDivider(),
                                _docRow('Officer', 'Officer Parag Singh'),
                                _docDivider(),
                                _docRow('Product', 'Haldiram\'s Aloo Bhujia Sev (200 g)'),
                                _docDivider(),
                                _docRow('Result', 'COMPLIANT', valueColor: Colors.green.shade700, valueBold: true),
                                const SizedBox(height: 24),
                                const Text(
                                  'COMPLIANCE VERIFICATION SUMMARY',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black45,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                _summaryItem('PASS', 'Rule 6(1)(a) — Manufacturer & Packer details complete'),
                                const SizedBox(height: 8),
                                _summaryItem('PASS', 'Rule 6(1)(c) — Net Quantity declared in metric units (200 g)'),
                                const SizedBox(height: 8),
                                _summaryItem('PASS', 'Rule 6(1)(da) — Mandatory USP declared (Rs. 0.30 per g)'),
                                const SizedBox(height: 8),
                                _summaryItem('PASS', 'Rule 6(1)(e) — MRP declared inclusive of all taxes (Rs. 60.00)'),
                                const SizedBox(height: 8),
                                _summaryItem('PASS', 'Rule 6(1)(f) — Consumer grievance email and phone verified'),
                                const SizedBox(height: 8),
                                _summaryItem('PASS', 'Rule 10 — Country of origin explicitly declared (India)'),
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
                                const Icon(Symbols.verified_rounded, size: 14, color: Colors.black26),
                                const SizedBox(width: 6),
                                const Expanded(
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
              child: PrimaryButton(
                text: 'Save Report to Downloads',
                icon: Symbols.download_rounded,
                onPressed: () async {
                  await _generateAndSavePdf(context);
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

  Widget _docDivider() => const Divider(height: 1, thickness: 1, color: Color(0xFFEEF1F8));

  Widget _summaryItem(String status, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.green.shade200),
          ),
          child: Text(
            status,
            style: TextStyle(fontSize: 10, color: Colors.green.shade700, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 8),
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
