import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/compliance_verdict.dart';
import '../models/violation.dart';
import '../models/extracted_field.dart';
import '../services/ocr_service.dart';
import '../services/field_extractor_service.dart';
import '../services/rule_engine_service.dart';

class ScanFlowProvider extends ChangeNotifier {
  String? _placeholderImageUrl;
  int _currentStepIndex = 0;
  ComplianceVerdict? _mockVerdict;
  List<Violation> _violations = [];
  List<ExtractedField> _extractedFields = [];

  String? get placeholderImageUrl => _placeholderImageUrl;
  int get currentStepIndex => _currentStepIndex;
  ComplianceVerdict? get mockVerdict => _mockVerdict;
  List<Violation> get violations => _violations;
  List<ExtractedField> get extractedFields => _extractedFields;

  List<Map<String, dynamic>> _evaluatedRules = [];
  List<Map<String, dynamic>> get evaluatedRules => _evaluatedRules;

  String? _rawOcrText;
  String? get rawOcrText => _rawOcrText;
  String? _currentScanId;
  String? get currentScanId => _currentScanId;

  void startScan(String imageUrl) {
    _placeholderImageUrl = imageUrl;
    _currentStepIndex = 0;
    _mockVerdict = null;
    _violations = [];
    _evaluatedRules = [];
    _rawOcrText = null;
    _currentScanId = const Uuid().v4();
    notifyListeners();
  }

  Future<void> runPipeline(String scannedByUserId) async {
    // 1. Image Captured (Already done in startScan, index 0)
    
    // 2. Label region detected
    _currentStepIndex = 1;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 300));
    
    // 3. OCR text extracted
    _currentStepIndex = 2;
    notifyListeners();
    if (_placeholderImageUrl != null) {
      _rawOcrText = await OCRService.extractTextFromImage(_placeholderImageUrl!);
      
      final supabase = Supabase.instance.client;
      final scanData = {
        'id': _currentScanId,
        'scanned_by': scannedByUserId,
        'image_url': '', 
        'source': 'camera',
        'raw_ocr_text': _rawOcrText,
        'created_at': DateTime.now().toIso8601String(),
      };
      
      try {
        await supabase.from('scans').insert(scanData);
      } catch (e) {
        debugPrint('Error inserting scan: $e');
      }
    }
    
    // 4. Extracting product fields
    _currentStepIndex = 3;
    notifyListeners();
    
    if (_rawOcrText != null && _currentScanId != null) {
      _extractedFields = await FieldExtractorService.extractFields(_currentScanId!, _rawOcrText!);
      
      // Store in Supabase
      final supabase = Supabase.instance.client;
      for (final field in _extractedFields) {
        try {
          await supabase.from('extracted_fields').insert({
            'id': field.id,
            'scan_id': field.scanId,
            'field_name': field.fieldName,
            'field_value': field.fieldValue,
            'confidence': field.confidence,
            'is_detected': field.isDetected,
            'created_at': field.createdAt.toIso8601String(),
          });
        } catch (e) {
          debugPrint('Error inserting extracted field: $e');
        }
      }
    }
    
    // 5. Checking rules / Generating verdict
    _currentStepIndex = 4;
    notifyListeners();
    
    if (_currentScanId != null) {
      final (verdict, ruleViolations, evalRules) = await RuleEngineService.evaluateScan(_currentScanId!, _extractedFields);
      setVerdict(verdict, violations: ruleViolations, evaluatedRules: evalRules);

      final supabase = Supabase.instance.client;
      try {
        await supabase.from('compliance_verdicts').insert(verdict.toJson());
        
        for (final v in ruleViolations) {
          await supabase.from('violations').insert(v.toJson());
        }
      } catch (e) {
        debugPrint('Error inserting verdict/violations: $e');
      }
    }
    
    await Future.delayed(const Duration(milliseconds: 500));
    
    _currentStepIndex = 5; // Done
    notifyListeners();
  }

  void advanceStep() {
    _currentStepIndex++;
    notifyListeners();
  }

  void setVerdict(ComplianceVerdict verdict, {List<Violation>? violations, List<Map<String, dynamic>>? evaluatedRules}) {
    _mockVerdict = verdict;
    if (violations != null) {
      _violations = violations;
    }
    if (evaluatedRules != null) {
      _evaluatedRules = evaluatedRules;
    }
    notifyListeners();
  }

  void clearScan() {
    _placeholderImageUrl = null;
    _currentStepIndex = 0;
    _mockVerdict = null;
    _violations = [];
    _rawOcrText = null;
    _currentScanId = null;
    notifyListeners();
  }
}
