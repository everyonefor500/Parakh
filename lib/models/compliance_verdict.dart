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
      scanId: json['scanId'] ?? json['scan_id'],
      status: VerdictStatus.values.firstWhere(
        (e) => e.name == (json['status'] ?? VerdictStatus.review.name),
        orElse: () => VerdictStatus.review,
      ),
      complianceScore: (json['complianceScore'] ?? json['compliance_score'])?.toDouble() ?? 0.0,
      checksPassed: json['checksPassed'] ?? json['checks_passed'] ?? 0,
      checksTotal: json['checksTotal'] ?? json['checks_total'] ?? 0,
      summary: json['summary'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : (json['created_at'] != null
              ? DateTime.parse(json['created_at'])
              : DateTime.now()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'scan_id': scanId,
      'status': status.name,
      'compliance_score': complianceScore,
      'summary': summary,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
