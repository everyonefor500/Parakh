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
      productId: json['productId'],
      scannedBy: json['scannedBy'],
      imageUrl: json['imageUrl'],
      source: ScanSource.values.firstWhere((e) => e.name == json['source']),
      ocrLanguage: json['ocrLanguage'],
      locationLat: json['locationLat']?.toDouble(),
      locationLng: json['locationLng']?.toDouble(),
      locationLabel: json['locationLabel'],
      rawOcrText: json['rawOcrText'],
      createdAt: DateTime.parse(json['createdAt']),
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
