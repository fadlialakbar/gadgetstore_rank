import '../../domain/entities/review.dart';

class ReviewModel extends Review {
  const ReviewModel({
    required super.id,
    required super.productId,
    required super.userId,
    required super.userName,
    required super.userImageUrl,
    required super.rating,
    required super.title,
    required super.content,
    required super.pros,
    required super.cons,
    required super.datePosted,
    required super.helpfulCount,
    required super.productName,
    required super.productImageUrl,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] as String,
      productId: json['productId'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userImageUrl: json['userImageUrl'] as String,
      rating: (json['rating'] as num).toDouble(),
      title: json['title'] as String,
      content: json['content'] as String,
      pros: json['pros'] != null ? List<String>.from(json['pros']) : const [],
      cons: json['cons'] != null ? List<String>.from(json['cons']) : const [],
      datePosted: DateTime.parse(json['datePosted'] as String),
      helpfulCount: json['helpfulCount'] as int? ?? 0,
      productName: json['productName'] as String,
      productImageUrl: json['productImageUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'userId': userId,
      'userName': userName,
      'userImageUrl': userImageUrl,
      'rating': rating,
      'title': title,
      'content': content,
      'pros': pros,
      'cons': cons,
      'datePosted': datePosted.toIso8601String(),
      'helpfulCount': helpfulCount,
      'productName': productName,
      'productImageUrl': productImageUrl,
    };
  }
}
