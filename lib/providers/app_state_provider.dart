import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/profile.dart';
import '../models/scan.dart';
import '../models/compliance_verdict.dart';
import '../models/violation.dart';

class AppStateProvider extends ChangeNotifier {
  Profile? _currentUser;
  
  List<Scan> _scans = [];
  List<ComplianceVerdict> _verdicts = [];
  List<Violation> _violations = [];

  List<Scan> get allScans => _scans;
  List<ComplianceVerdict> get allVerdicts => _verdicts;
  List<Violation> get allViolations => _violations;

  Profile? get currentUser => _currentUser;

  Future<void> login(Profile profile) async {
    _currentUser = profile;
    notifyListeners();
    await fetchHistory();
  }

  void logout() {
    _currentUser = null;
    _scans = [];
    _verdicts = [];
    _violations = [];
    notifyListeners();
  }

  Future<void> fetchHistory() async {
    if (_currentUser == null) return;
    _scans = [];
    _verdicts = [];
    _violations = [];
    notifyListeners();
    // Intentionally left empty for the mock flow to start with 0 scans.
  }

  void addMockScan(Scan scan, ComplianceVerdict verdict, List<Violation> violations) {
    _scans.insert(0, scan);
    _verdicts.insert(0, verdict);
    _violations.addAll(violations);
    notifyListeners();
  }

  Future<void> deleteScan(String scanId) async {
    try {
      await Supabase.instance.client.from('scans').delete().eq('id', scanId);
      
      // Update local state
      _scans.removeWhere((s) => s.id == scanId);
      final verdict = _verdicts.where((v) => v.scanId == scanId).firstOrNull;
      if (verdict != null) {
        _verdicts.removeWhere((v) => v.scanId == scanId);
        _violations.removeWhere((v) => v.verdictId == verdict.id);
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint("Error deleting scan: $e");
      rethrow;
    }
  }

  List<Scan> scansForCurrentUser() {
    return _scans;
  }

  ComplianceVerdict? verdictForScan(String scanId) {
    try {
      return _verdicts.firstWhere((v) => v.scanId == scanId);
    } catch (e) {
      return null;
    }
  }

  List<Violation> violationsForVerdict(String verdictId) {
    return _violations.where((v) => v.verdictId == verdictId).toList();
  }
}
