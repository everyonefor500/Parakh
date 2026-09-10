import 'package:flutter/material.dart';
import '../models/profile.dart';
import '../models/scan.dart';
import '../models/compliance_verdict.dart';
import '../models/violation.dart';
import '../data/mock_data.dart';

class AppStateProvider extends ChangeNotifier {
  Profile? _currentUser;
  
  // Expose mock data
  List<Scan> get allScans => MockData.scans;
  List<ComplianceVerdict> get allVerdicts => MockData.verdicts;

  Profile? get currentUser => _currentUser;

  void login(Profile profile) {
    _currentUser = profile;
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  List<Scan> scansForCurrentUser() {
    if (_currentUser == null) return [];
    if (_currentUser!.role == UserRole.officer) {
      return allScans.where((s) => s.scannedBy == _currentUser!.id).toList();
    }
    // For other roles, implement specific filtering logic as needed
    return allScans;
  }

  ComplianceVerdict? verdictForScan(String scanId) {
    try {
      return MockData.verdicts.firstWhere((v) => v.scanId == scanId);
    } catch (e) {
      return null;
    }
  }

  List<Violation> violationsForVerdict(String verdictId) {
    return MockData.violations.where((v) => v.verdictId == verdictId).toList();
  }
}
