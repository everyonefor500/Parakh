class ExtractedField {
  final String id;
  final String scanId;
  final String fieldName;
  final String? fieldValue;
  final double confidence;
  final bool isDetected;
  final Map<String, double>? boundingBox;
  final DateTime createdAt;

  ExtractedField({
    required this.id,
    required this.scanId,
    required this.fieldName,
    this.fieldValue,
    required this.confidence,
    required this.isDetected,
    this.boundingBox,
    required this.createdAt,
  });

  factory ExtractedField.fromJson(Map<String, dynamic> json) {
    return ExtractedField(
      id: json['id'],
      scanId: json['scanId'],
      fieldName: json['fieldName'],
      fieldValue: json['fieldValue'],
      confidence: json['confidence']?.toDouble() ?? 0.0,
      isDetected: json['isDetected'] ?? false,
      boundingBox: json['boundingBox'] != null ? Map<String, double>.from(json['boundingBox']) : null,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'scanId': scanId,
      'fieldName': fieldName,
      'fieldValue': fieldValue,
      'confidence': confidence,
      'isDetected': isDetected,
      'boundingBox': boundingBox,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
