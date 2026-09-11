enum ScanSource { camera, upload, barcode, bulk }

class Scan {
  final String id;
  final String? productId;
  final String scannedBy;
  final String imageUrl;
  final ScanSource source;
  final String ocrLanguage;
  final double? locationLat;
  final double? locationLng;
  final String? locationLabel;
  final String? rawOcrText;
  final DateTime createdAt;

  Scan({
    required this.id,
    this.productId,
    required this.scannedBy,
    required this.imageUrl,
    required this.source,
    required this.ocrLanguage,
    this.locationLat,
    this.locationLng,
    this.locationLabel,
    this.rawOcrText,
    required this.createdAt,
  });

  factory Scan.fromJson(Map<String, dynamic> json) {
    return Scan(
      id: json['id'],
      productId: json['productId'] ?? json['product_id'],
      scannedBy: json['scannedBy'] ?? json['scanned_by'],
      imageUrl: json['imageUrl'] ?? json['image_url'] ?? '',
      source: ScanSource.values.firstWhere(
        (e) => e.name == (json['source'] ?? ScanSource.camera.name),
        orElse: () => ScanSource.camera,
      ),
      ocrLanguage: json['ocrLanguage'] ?? json['ocr_language'] ?? 'en',
      locationLat: (json['locationLat'] ?? json['location_lat'])?.toDouble(),
      locationLng: (json['locationLng'] ?? json['location_lng'])?.toDouble(),
      locationLabel: json['locationLabel'] ?? json['location_label'],
      rawOcrText: json['rawOcrText'] ?? json['raw_ocr_text'],
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
      'productId': productId,
      'scannedBy': scannedBy,
      'imageUrl': imageUrl,
      'source': source.name,
      'ocrLanguage': ocrLanguage,
      'locationLat': locationLat,
      'locationLng': locationLng,
      'locationLabel': locationLabel,
      'rawOcrText': rawOcrText,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
