import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.imageUrl,
    String super.status = '',
    String super.statusMessage = '',
    super.reviewCount,
    required super.joinDate,
    required super.rank,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      status: json['status'] as String? ?? '',
      statusMessage: json['statusMessage'] as String? ?? '',
      reviewCount: json['reviewCount'] as int? ?? 0,
      joinDate: DateTime.parse(json['joinDate'] as String),
      rank: json['rank'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'status': status,
      'statusMessage': statusMessage,
      'reviewCount': reviewCount,
      'joinDate': joinDate.toIso8601String(),
      'rank': rank,
    };
  }
}
