enum JobStatus { queued, processing, completed, failed }

extension JobStatusExtension on JobStatus {
  String get label {
    switch (this) {
      case JobStatus.queued: return "Queued";
      case JobStatus.processing: return "Processing";
      case JobStatus.completed: return "Completed";
      case JobStatus.failed: return "Failed";
    }
  }
}

class BulkJob {
  final String id;
  final String createdBy;
  final String sourceFileUrl;
  final int totalSkus;
  final int checkedSkus;
  final int compliantCount;
  final int reviewCount;
  final int violationCount;
  final JobStatus status;
  final DateTime createdAt;
  final DateTime? completedAt;

  BulkJob({
    required this.id,
    required this.createdBy,
    required this.sourceFileUrl,
    required this.totalSkus,
    required this.checkedSkus,
    required this.compliantCount,
    required this.reviewCount,
    required this.violationCount,
    required this.status,
    required this.createdAt,
    this.completedAt,
  });

  factory BulkJob.fromJson(Map<String, dynamic> json) {
    return BulkJob(
      id: json['id'],
      createdBy: json['createdBy'],
      sourceFileUrl: json['sourceFileUrl'],
      totalSkus: json['totalSkus'] ?? 0,
      checkedSkus: json['checkedSkus'] ?? 0,
      compliantCount: json['compliantCount'] ?? 0,
      reviewCount: json['reviewCount'] ?? 0,
      violationCount: json['violationCount'] ?? 0,
      status: JobStatus.values.firstWhere((e) => e.name == json['status']),
      createdAt: DateTime.parse(json['createdAt']),
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdBy': createdBy,
      'sourceFileUrl': sourceFileUrl,
      'totalSkus': totalSkus,
      'checkedSkus': checkedSkus,
      'compliantCount': compliantCount,
      'reviewCount': reviewCount,
      'violationCount': violationCount,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }
}
