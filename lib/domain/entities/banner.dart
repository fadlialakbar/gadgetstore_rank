class Banner {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String targetProductId;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;

  const Banner({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.targetProductId,
    required this.startDate,
    required this.endDate,
    required this.isActive,
  });

  bool get isCurrentlyActive {
    final now = DateTime.now();
    return isActive && startDate.isBefore(now) && endDate.isAfter(now);
  }
}
