class CatalogProduct {
  final String id;
  final String code;
  final String description;
  final String weight;
  final String imageUrl;

  CatalogProduct({
    required this.id,
    required this.code,
    required this.description,
    required this.weight,
    required this.imageUrl,
  });

  factory CatalogProduct.fromJson(Map<String, dynamic> json) {
    return CatalogProduct(
      id: json['id'] as String,
      code: json['code'] as String,
      description: json['description'] as String,
      weight: json['weight'] as String,
      imageUrl: json['imageUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'description': description,
      'weight': weight,
      'imageUrl': imageUrl,
    };
  }
}
