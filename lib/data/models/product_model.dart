import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required String id,
    required String name,
    required String description,
    required String category,
    required String brand,
    required double price,
    required double rating,
    required int reviewCount,
    required List<String> imageUrls,
    required List<String> features,
    required bool isAvailable,
    required int rank,
  }) : super(
         id: id,
         name: name,
         description: description,
         category: category,
         brand: brand,
         price: price,
         rating: rating,
         reviewCount: reviewCount,
         imageUrls: imageUrls,
         features: features,
         isAvailable: isAvailable,
         rank: rank,
       );

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      brand: json['brand'] as String,
      price: (json['price'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      imageUrls: List<String>.from(json['imageUrls']),
      features: List<String>.from(json['features']),
      isAvailable: json['isAvailable'] as bool,
      rank: json['rank'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'brand': brand,
      'price': price,
      'rating': rating,
      'reviewCount': reviewCount,
      'imageUrls': imageUrls,
      'features': features,
      'isAvailable': isAvailable,
      'rank': rank,
    };
  }
}
