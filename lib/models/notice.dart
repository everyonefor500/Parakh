enum NoticeStatus { draft, pendingApproval, sent, closed }

extension NoticeStatusExtension on NoticeStatus {
  String get label {
    switch (this) {
      case NoticeStatus.draft: return "Draft";
      case NoticeStatus.pendingApproval: return "Pending Approval";
      case NoticeStatus.sent: return "Sent";
      case NoticeStatus.closed: return "Closed";
    }
  }
}

class Notice {
  final String id;
  final String verdictId;
  final String issuedBy;
  final String sellerName;
  final String sellerAddress;
  final String content;
  final NoticeStatus status;
  final String? pdfUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  Notice({
    required this.id,
    required this.verdictId,
    required this.issuedBy,
    required this.sellerName,
    required this.sellerAddress,
    required this.content,
    required this.status,
    this.pdfUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Notice.fromJson(Map<String, dynamic> json) {
    return Notice(
      id: json['id'],
      verdictId: json['verdictId'],
      issuedBy: json['issuedBy'],
      sellerName: json['sellerName'],
      sellerAddress: json['sellerAddress'],
      content: json['content'],
      status: NoticeStatus.values.firstWhere((e) => e.name == json['status']),
      pdfUrl: json['pdfUrl'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'verdictId': verdictId,
      'issuedBy': issuedBy,
      'sellerName': sellerName,
      'sellerAddress': sellerAddress,
      'content': content,
      'status': status.name,
      'pdfUrl': pdfUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
