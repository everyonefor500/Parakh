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
  final String? productId; // Making this nullable as they might type productName instead
  final String? scanId;
  final ComplaintCategory category;
  final String description;
  final String? evidenceUrl;
  final ComplaintStatus status;
  final String complaintCode;
  final DateTime createdAt;

  final String? productName;
  final String? shopSellerName;
  final String? reviewedBy;
  final DateTime? reviewedAt;
  final String? officerNotes;

  Complaint({
    required this.id,
    required this.submittedBy,
    this.productId,
    this.scanId,
    required this.category,
    required this.description,
    this.evidenceUrl,
    required this.status,
    required this.complaintCode,
    required this.createdAt,
    this.productName,
    this.shopSellerName,
    this.reviewedBy,
    this.reviewedAt,
    this.officerNotes,
  });

  factory Complaint.fromJson(Map<String, dynamic> json) {
    ComplaintStatus parsedStatus;
    switch (json['status']) {
      case 'submitted':
        parsedStatus = ComplaintStatus.submitted;
        break;
      case 'in_review':
        parsedStatus = ComplaintStatus.inReview;
        break;
      case 'resolved':
        parsedStatus = ComplaintStatus.resolved;
        break;
      case 'rejected':
        parsedStatus = ComplaintStatus.rejected;
        break;
      default:
        parsedStatus = ComplaintStatus.submitted;
    }

    return Complaint(
      id: json['id'],
      submittedBy: json['submitted_by'] ?? json['submittedBy'],
      productId: json['product_id'] ?? json['productId'],
      scanId: json['scan_id'] ?? json['scanId'],
      category: ComplaintCategory.values.firstWhere(
          (e) => e.name == json['category'],
          orElse: () => ComplaintCategory.other),
      description: json['description'],
      evidenceUrl: json['evidence_url'] ?? json['evidenceUrl'],
      status: parsedStatus,
      complaintCode: json['complaint_code'] ?? json['complaintCode'] ?? '',
      createdAt: DateTime.parse(json['created_at'] ?? json['createdAt']),
      productName: json['product_name'] ?? json['productName'],
      shopSellerName: json['shop_seller_name'] ?? json['shopSellerName'],
      reviewedBy: json['reviewed_by'] ?? json['reviewedBy'],
      reviewedAt: json['reviewed_at'] != null || json['reviewedAt'] != null
          ? DateTime.parse(json['reviewed_at'] ?? json['reviewedAt'])
          : null,
      officerNotes: json['officer_notes'] ?? json['officerNotes'],
    );
  }

  Map<String, dynamic> toJson() {
    String statusStr;
    switch (status) {
      case ComplaintStatus.submitted:
        statusStr = 'submitted';
        break;
      case ComplaintStatus.inReview:
        statusStr = 'in_review';
        break;
      case ComplaintStatus.resolved:
        statusStr = 'resolved';
        break;
      case ComplaintStatus.rejected:
        statusStr = 'rejected';
        break;
    }

    return {
      'id': id,
      'submitted_by': submittedBy,
      'product_id': productId,
      'scan_id': scanId,
      'category': category.name,
      'description': description,
      'evidence_url': evidenceUrl,
      'status': statusStr,
      'complaint_code': complaintCode,
      'created_at': createdAt.toIso8601String(),
      'product_name': productName,
      'shop_seller_name': shopSellerName,
      'reviewed_by': reviewedBy,
      'reviewed_at': reviewedAt?.toIso8601String(),
      'officer_notes': officerNotes,
    };
  }
}
