import '../../domain/entities/banner.dart';

class BannerModel extends Banner {
  const BannerModel({
    required String id,
    required String title,
    required String description,
    required String imageUrl,
    required String targetProductId,
    required DateTime startDate,
    required DateTime endDate,
    required bool isActive,
  }) : super(
         id: id,
         title: title,
         description: description,
         imageUrl: imageUrl,
         targetProductId: targetProductId,
         startDate: startDate,
         endDate: endDate,
         isActive: isActive,
       );

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      targetProductId: json['targetProductId'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      isActive: json['isActive'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'targetProductId': targetProductId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'isActive': isActive,
    };
  }
}
