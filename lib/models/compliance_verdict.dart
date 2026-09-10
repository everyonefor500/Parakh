enum VerdictStatus { compliant, review, nonCompliant }

extension VerdictStatusExtension on VerdictStatus {
  String get label {
    switch (this) {
      case VerdictStatus.compliant: return "Compliant";
      case VerdictStatus.review: return "Under Review";
      case VerdictStatus.nonCompliant: return "Non-Compliant";
    }
  }
}

class ComplianceVerdict {
  final String id;
  final String scanId;
  final VerdictStatus status;
  final double complianceScore;
  final int checksPassed;
  final int checksTotal;
  final String summary;
  final DateTime createdAt;

  ComplianceVerdict({
    required this.id,
    required this.scanId,
    required this.status,
    required this.complianceScore,
    required this.checksPassed,
    required this.checksTotal,
    required this.summary,
    required this.createdAt,
  });

  factory ComplianceVerdict.fromJson(Map<String, dynamic> json) {
    return ComplianceVerdict(
      id: json['id'],
      scanId: json['scanId'],
      status: VerdictStatus.values.firstWhere((e) => e.name == json['status']),
      complianceScore: json['complianceScore']?.toDouble() ?? 0.0,
      checksPassed: json['checksPassed'] ?? 0,
      checksTotal: json['checksTotal'] ?? 0,
      summary: json['summary'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'scanId': scanId,
      'status': status.name,
      'complianceScore': complianceScore,
      'checksPassed': checksPassed,
      'checksTotal': checksTotal,
      'summary': summary,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
