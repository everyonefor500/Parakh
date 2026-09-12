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
    
    try {
      final supabase = Supabase.instance.client;
      
      // Fetch scans for the current user
      final scansResponse = await supabase
          .from('scans')
          .select()
          .eq('scanned_by', _currentUser!.id)
          .order('created_at', ascending: false);
          
      _scans = (scansResponse as List).map((s) => Scan.fromJson(s)).toList();

      if (_scans.isNotEmpty) {
        final scanIds = _scans.map((s) => s.id).toList();
        
        // Fetch verdicts for these scans
        final verdictsResponse = await supabase
            .from('compliance_verdicts')
            .select()
            .inFilter('scan_id', scanIds);
            
        _verdicts = (verdictsResponse as List).map((v) => ComplianceVerdict.fromJson(v)).toList();
        
        if (_verdicts.isNotEmpty) {
          final verdictIds = _verdicts.map((v) => v.id).toList();
          
          // Fetch violations for these verdicts
          final violationsResponse = await supabase
              .from('violations')
              .select()
              .inFilter('verdict_id', verdictIds);
              
          _violations = (violationsResponse as List).map((v) => Violation.fromJson(v)).toList();
        } else {
          _violations = [];
        }
      } else {
        _verdicts = [];
        _violations = [];
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching history: $e');
      _scans = [];
      _verdicts = [];
      _violations = [];
      notifyListeners();
    }
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
