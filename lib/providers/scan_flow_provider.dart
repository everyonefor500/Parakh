import 'package:flutter/material.dart';
import '../models/compliance_verdict.dart';
import '../models/violation.dart';

class ScanFlowProvider extends ChangeNotifier {
  String? _placeholderImageUrl;
  int _currentStepIndex = 0;
  ComplianceVerdict? _mockVerdict;
  List<Violation> _violations = [];

  String? get placeholderImageUrl => _placeholderImageUrl;
  int get currentStepIndex => _currentStepIndex;
  ComplianceVerdict? get mockVerdict => _mockVerdict;
  List<Violation> get violations => _violations;

  void startScan(String imageUrl) {
    _placeholderImageUrl = imageUrl;
    _currentStepIndex = 0;
    _mockVerdict = null;
    _violations = [];
    notifyListeners();
  }

  void advanceStep() {
    _currentStepIndex++;
    notifyListeners();
  }

  void setVerdict(ComplianceVerdict verdict, {List<Violation>? violations}) {
    _mockVerdict = verdict;
    if (violations != null) {
      _violations = violations;
    }
    notifyListeners();
  }

  void clearScan() {
    _placeholderImageUrl = null;
    _currentStepIndex = 0;
    _mockVerdict = null;
    _violations = [];
    notifyListeners();
  }
}
