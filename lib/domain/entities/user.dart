import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String imageUrl;
  final String? status;
  final String? statusMessage;
  final int reviewCount;
  final DateTime joinDate;
  final int rank;

  const User({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.status,
    this.statusMessage,
    this.reviewCount = 0,
    required this.joinDate,
    required this.rank,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    imageUrl,
    status,
    statusMessage,
    reviewCount,
    joinDate,
    rank,
  ];
}
