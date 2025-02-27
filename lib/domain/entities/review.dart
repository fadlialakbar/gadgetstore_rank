import 'package:equatable/equatable.dart';

class Review extends Equatable {
  final String id;
  final String productId;
  final String userId;
  final String userName;
  final String userImageUrl;
  final double rating;
  final String title;
  final String content;
  final List<String> pros;
  final List<String> cons;
  final DateTime datePosted;
  final int helpfulCount;
  final String productName;
  final String productImageUrl;

  const Review({
    required this.id,
    required this.productId,
    required this.userId,
    required this.userName,
    required this.userImageUrl,
    required this.rating,
    required this.title,
    required this.content,
    required this.pros,
    required this.cons,
    required this.datePosted,
    required this.helpfulCount,
    required this.productName,
    required this.productImageUrl,
  });

  @override
  List<Object?> get props => [
    id,
    productId,
    userId,
    userName,
    userImageUrl,
    rating,
    title,
    content,
    pros,
    cons,
    datePosted,
    helpfulCount,
    productName,
    productImageUrl,
  ];

  Review copyWith({
    String? id,
    String? productId,
    String? userId,
    String? userName,
    String? userImageUrl,
    double? rating,
    String? title,
    String? content,
    List<String>? pros,
    List<String>? cons,
    DateTime? datePosted,
    int? helpfulCount,
    String? productName,
    String? productImageUrl,
  }) {
    return Review(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userImageUrl: userImageUrl ?? this.userImageUrl,
      rating: rating ?? this.rating,
      title: title ?? this.title,
      content: content ?? this.content,
      pros: pros ?? this.pros,
      cons: cons ?? this.cons,
      datePosted: datePosted ?? this.datePosted,
      helpfulCount: helpfulCount ?? this.helpfulCount,
      productName: productName ?? this.productName,
      productImageUrl: productImageUrl ?? this.productImageUrl,
    );
  }
}
