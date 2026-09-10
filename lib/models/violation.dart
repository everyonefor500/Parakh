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
      verdictId: json['verdictId'],
      ruleId: json['ruleId'],
      fieldName: json['fieldName'],
      issueTitle: json['issueTitle'],
      description: json['description'],
      detectedValue: json['detectedValue'],
      requiredValue: json['requiredValue'],
      severity: SeverityLevel.values.firstWhere((e) => e.name == json['severity']),
      evidenceImageUrl: json['evidenceImageUrl'],
      officerNote: json['officerNote'],
      isIncludedInReport: json['isIncludedInReport'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
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
