class Report {
  final String id;
  final String verdictId;
  final String generatedBy;
  final String reportUrl;
  final String status;
  final DateTime createdAt;

  Report({
    required this.id,
    required this.verdictId,
    required this.generatedBy,
    required this.reportUrl,
    required this.status,
    required this.createdAt,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'],
      verdictId: json['verdictId'],
      generatedBy: json['generatedBy'],
      reportUrl: json['reportUrl'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'verdictId': verdictId,
      'generatedBy': generatedBy,
      'reportUrl': reportUrl,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
