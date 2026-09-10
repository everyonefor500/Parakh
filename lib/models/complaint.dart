enum ComplaintCategory { mrp, quantity, missingInfo, expiry, other }

extension ComplaintCategoryExtension on ComplaintCategory {
  String get label {
    switch (this) {
      case ComplaintCategory.mrp: return "MRP Issue";
      case ComplaintCategory.quantity: return "Quantity Mismatch";
      case ComplaintCategory.missingInfo: return "Missing Information";
      case ComplaintCategory.expiry: return "Expiry Date Issue";
      case ComplaintCategory.other: return "Other";
    }
  }
}

enum ComplaintStatus { submitted, inReview, resolved, rejected }

extension ComplaintStatusExtension on ComplaintStatus {
  String get label {
    switch (this) {
      case ComplaintStatus.submitted: return "Submitted";
      case ComplaintStatus.inReview: return "In Review";
      case ComplaintStatus.resolved: return "Resolved";
      case ComplaintStatus.rejected: return "Rejected";
    }
  }
}

class Complaint {
  final String id;
  final String submittedBy;
  final String productId;
  final String scanId;
  final ComplaintCategory category;
  final String description;
  final String? evidenceUrl;
  final ComplaintStatus status;
  final String complaintCode;
  final DateTime createdAt;

  Complaint({
    required this.id,
    required this.submittedBy,
    required this.productId,
    required this.scanId,
    required this.category,
    required this.description,
    this.evidenceUrl,
    required this.status,
    required this.complaintCode,
    required this.createdAt,
  });

  factory Complaint.fromJson(Map<String, dynamic> json) {
    return Complaint(
      id: json['id'],
      submittedBy: json['submittedBy'],
      productId: json['productId'],
      scanId: json['scanId'],
      category: ComplaintCategory.values.firstWhere((e) => e.name == json['category']),
      description: json['description'],
      evidenceUrl: json['evidenceUrl'],
      status: ComplaintStatus.values.firstWhere((e) => e.name == json['status']),
      complaintCode: json['complaintCode'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'submittedBy': submittedBy,
      'productId': productId,
      'scanId': scanId,
      'category': category.name,
      'description': description,
      'evidenceUrl': evidenceUrl,
      'status': status.name,
      'complaintCode': complaintCode,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
