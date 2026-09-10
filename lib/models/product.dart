enum ProductCategory { food, cosmetics, electronics, household, other }

extension ProductCategoryExtension on ProductCategory {
  String get label {
    switch (this) {
      case ProductCategory.food: return "Food & Beverages";
      case ProductCategory.cosmetics: return "Cosmetics";
      case ProductCategory.electronics: return "Electronics";
      case ProductCategory.household: return "Household";
      case ProductCategory.other: return "Other";
    }
  }
}

class Product {
  final String id;
  final String name;
  final String brand;
  final ProductCategory category;
  final String barcode;
  final String imageUrl;
  final String createdBy;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    required this.barcode,
    required this.imageUrl,
    required this.createdBy,
    required this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      brand: json['brand'],
      category: ProductCategory.values.firstWhere((e) => e.name == json['category']),
      barcode: json['barcode'],
      imageUrl: json['imageUrl'],
      createdBy: json['createdBy'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'category': category.name,
      'barcode': barcode,
      'imageUrl': imageUrl,
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
