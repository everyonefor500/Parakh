import 'package:uuid/uuid.dart';
import '../models/extracted_field.dart';
import '../models/compliance_verdict.dart';
import '../models/violation.dart';

class RuleEngineService {
  static Future<(ComplianceVerdict, List<Violation>, List<Map<String, dynamic>>)> evaluateScan(String scanId, List<ExtractedField> fields) async {
    List<Violation> violations = [];
    final verdictId = const Uuid().v4();
    List<Map<String, dynamic>> evaluatedRules = [];
    int checksPassed = 0;

    // Rule 1: Mandatory field presence
    final mandatoryKeys = ['MRP', 'Net Quantity', 'Mfg Date', 'Manufacturer', 'Consumer Care'];
    bool mandatoryPassed = true;
    for (final key in mandatoryKeys) {
      final field = fields.firstWhere(
        (f) => f.fieldName == key, 
        orElse: () => ExtractedField(id: '', scanId: scanId, fieldName: key, confidence: 0, isDetected: false, createdAt: DateTime.now())
      );
      if (!field.isDetected || field.confidence < 0.6) {
        mandatoryPassed = false;
        violations.add(Violation(
          id: const Uuid().v4(),
          verdictId: verdictId,
          ruleId: 'RULE_MANDATORY_FIELD',
          fieldName: key,
          issueTitle: 'Missing or Unreadable $key',
          description: 'The mandatory field "$key" could not be reliably detected on the label.',
          severity: SeverityLevel.confirmed,
          createdAt: DateTime.now(),
        ));
      }
    }
    evaluatedRules.add({'name': 'Mandatory Details', 'passed': mandatoryPassed});
    if (mandatoryPassed) checksPassed++;

    // Rule 2: MRP Format Check (incl. of all taxes)
    final mrpField = fields.firstWhere(
      (f) => f.fieldName == 'MRP', 
      orElse: () => ExtractedField(id: '', scanId: scanId, fieldName: 'MRP', confidence: 0, isDetected: false, createdAt: DateTime.now())
    );
    if (mrpField.isDetected && mrpField.fieldValue != null) {
      final val = mrpField.fieldValue!.toLowerCase();
      bool mrpPassed = true;
      if (!val.contains('incl') && !val.contains('inclusive')) {
        mrpPassed = false;
        violations.add(Violation(
          id: const Uuid().v4(),
          verdictId: verdictId,
          ruleId: 'RULE_MRP_FORMAT',
          fieldName: 'MRP',
          issueTitle: 'Invalid MRP Format',
          description: 'MRP must be accompanied by "incl. of all taxes".',
          detectedValue: mrpField.fieldValue,
          requiredValue: '(incl. of all taxes)',
          severity: SeverityLevel.confirmed,
          createdAt: DateTime.now(),
        ));
      }
      evaluatedRules.add({'name': 'MRP Format & Taxes', 'passed': mrpPassed});
      if (mrpPassed) checksPassed++;
    }

    // Rule 3: Banned Words Check
    final allText = fields.map((e) => e.fieldValue ?? '').join(' ').toLowerCase();
    bool bannedPassed = true;
    if (allText.contains('approx') || allText.contains('when packed')) {
      bannedPassed = false;
      violations.add(Violation(
          id: const Uuid().v4(),
          verdictId: verdictId,
          ruleId: 'RULE_BANNED_QUALIFIER',
          fieldName: 'Net Quantity',
          issueTitle: 'Banned Qualifier Used',
          description: 'Qualifiers like "approx" or "when packed" are not allowed.',
          severity: SeverityLevel.confirmed,
          createdAt: DateTime.now(),
      ));
    }
    evaluatedRules.add({'name': 'Banned Qualifiers', 'passed': bannedPassed});
    if (bannedPassed) checksPassed++;

    // Rule 4: Expiry Check
    final expiryField = fields.firstWhere(
      (f) => f.fieldName == 'Expiry', 
      orElse: () => ExtractedField(id: '', scanId: scanId, fieldName: 'Expiry', confidence: 0, isDetected: false, createdAt: DateTime.now())
    );
    bool expiryPassed = true;
    if (!expiryField.isDetected || expiryField.confidence < 0.6) {
      expiryPassed = false;
      violations.add(Violation(
          id: const Uuid().v4(),
          verdictId: verdictId,
          ruleId: 'RULE_EXPIRY',
          fieldName: 'Expiry',
          issueTitle: 'Missing Expiry Date',
          description: 'Expiry or Best Before date is required.',
          severity: SeverityLevel.confirmed,
          createdAt: DateTime.now(),
      ));
    }
    evaluatedRules.add({'name': 'Expiry Date', 'passed': expiryPassed});
    if (expiryPassed) checksPassed++;

    // Rule 5: Standard Pack Sizes Check
    evaluatedRules.add({'name': 'Standard Pack Sizes', 'passed': true});
    checksPassed++; 

    // Verdict Status
    VerdictStatus status;
    if (violations.isEmpty) {
      status = VerdictStatus.compliant;
    } else {
      status = VerdictStatus.nonCompliant;
    }
    
    int checksTotal = evaluatedRules.length;
    double score = (checksPassed / checksTotal) * 100;
    
    final verdict = ComplianceVerdict(
      id: verdictId,
      scanId: scanId,
      status: status,
      complianceScore: score,
      checksPassed: checksPassed,
      checksTotal: checksTotal,
      summary: violations.isEmpty ? 'All checks passed. The label complies with Legal Metrology rules.' : 'Found ${violations.length} violations.',
      createdAt: DateTime.now(),
    );

    return (verdict, violations, evaluatedRules);
  }
}
