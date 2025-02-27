import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final String brand;
  final String category;
  final String description;
  final String? shortDescription;
  final double price;
  final double rating;
  final int reviewCount;
  final List<String> imageUrls;
  final List<String> features;
  final List<String>? tags;
  final bool isAvailable;
  final int rank;

  const Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    required this.description,
    this.shortDescription,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.imageUrls,
    required this.features,
    this.tags,
    required this.isAvailable,
    required this.rank,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      brand: json['brand'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
      shortDescription: json['shortDescription'] as String?,
      price: (json['price'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      imageUrls: List<String>.from(json['imageUrls'] as List),
      features: List<String>.from(json['features'] as List),
      tags:
          json['tags'] != null ? List<String>.from(json['tags'] as List) : null,
      isAvailable: json['isAvailable'] as bool,
      rank: json['rank'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'category': category,
      'description': description,
      'shortDescription': shortDescription,
      'price': price,
      'rating': rating,
      'reviewCount': reviewCount,
      'imageUrls': imageUrls,
      'features': features,
      'tags': tags,
      'isAvailable': isAvailable,
      'rank': rank,
    };
  }

  @override
  List<Object?> get props => [
    id,
    name,
    brand,
    category,
    description,
    shortDescription,
    price,
    rating,
    reviewCount,
    imageUrls,
    features,
    tags,
    isAvailable,
    rank,
  ];
}
