enum SeverityLevel { low, medium, high, confirmed, possible }

extension SeverityLevelExtension on SeverityLevel {
  String get label {
    switch (this) {
      case SeverityLevel.low: return "Low";
      case SeverityLevel.medium: return "Medium";
      case SeverityLevel.high: return "High";
      case SeverityLevel.confirmed: return "Confirmed";
      case SeverityLevel.possible: return "Possible";
    }
  }
}

class Violation {
  final String id;
  final String verdictId;
  final String ruleId;
  final String fieldName;
  final String issueTitle;
  final String description;
  final String? detectedValue;
  final String? requiredValue;
  final SeverityLevel severity;
  final String? evidenceImageUrl;
  final String? officerNote;
  final bool isIncludedInReport;
  final DateTime createdAt;

  Violation({
    required this.id,
    required this.verdictId,
    required this.ruleId,
    required this.fieldName,
    required this.issueTitle,
    required this.description,
    this.detectedValue,
    this.requiredValue,
    required this.severity,
    this.evidenceImageUrl,
    this.officerNote,
    this.isIncludedInReport = false,
    required this.createdAt,
  });

  factory Violation.fromJson(Map<String, dynamic> json) {
    return Violation(
      id: json['id'],
      verdictId: json['verdictId'] ?? json['verdict_id'],
      ruleId: json['ruleId'] ?? json['rule_id'],
      fieldName: json['fieldName'] ?? json['field_name'],
      issueTitle: json['issueTitle'] ?? json['issue_title'],
      description: json['description'],
      detectedValue: json['detectedValue'] ?? json['detected_value'],
      requiredValue: json['requiredValue'] ?? json['required_value'],
      severity: SeverityLevel.values.firstWhere(
        (e) => e.name == (json['severity'] ?? SeverityLevel.medium.name),
        orElse: () => SeverityLevel.medium,
      ),
      evidenceImageUrl: json['evidenceImageUrl'] ?? json['evidence_image_url'],
      officerNote: json['officerNote'] ?? json['officer_note'],
      isIncludedInReport: json['isIncludedInReport'] ?? json['is_included_in_report'] ?? false,
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
      'verdictId': verdictId,
      'ruleId': ruleId,
      'fieldName': fieldName,
      'issueTitle': issueTitle,
      'description': description,
      'detectedValue': detectedValue,
      'requiredValue': requiredValue,
      'severity': severity.name,
      'evidenceImageUrl': evidenceImageUrl,
      'officerNote': officerNote,
      'isIncludedInReport': isIncludedInReport,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
