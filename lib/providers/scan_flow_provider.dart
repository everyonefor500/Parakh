import 'package:flutter/material.dart';
import '../models/compliance_verdict.dart';

class ScanFlowProvider extends ChangeNotifier {
  String? _placeholderImageUrl;
  int _currentStepIndex = 0;
  ComplianceVerdict? _mockVerdict;

  String? get placeholderImageUrl => _placeholderImageUrl;
  int get currentStepIndex => _currentStepIndex;
  ComplianceVerdict? get mockVerdict => _mockVerdict;

  void startScan(String imageUrl) {
    _placeholderImageUrl = imageUrl;
    _currentStepIndex = 0;
    _mockVerdict = null;
    notifyListeners();
  }

  void advanceStep() {
    _currentStepIndex++;
    notifyListeners();
  }

  void setVerdict(ComplianceVerdict verdict) {
    _mockVerdict = verdict;
    notifyListeners();
  }

  void clearScan() {
    _placeholderImageUrl = null;
    _currentStepIndex = 0;
    _mockVerdict = null;
    notifyListeners();
  }
}
