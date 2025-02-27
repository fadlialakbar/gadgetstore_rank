import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/review.dart';
import '../providers/review_provider.dart';

class ReviewerProfileScreen extends StatefulWidget {
  final String userId;

  const ReviewerProfileScreen({super.key, required this.userId});

  @override
  State<ReviewerProfileScreen> createState() => _ReviewerProfileScreenState();
}

class _ReviewerProfileScreenState extends State<ReviewerProfileScreen> {
  bool _isLoading = true;
  String _errorMessage = '';
  List<Review> _userReviews = [];

  final Map<String, dynamic> _reviewerStats = {
    'rank': '골드',
    'rankPosition': 1,
    'totalReviews': 35,
    'helpfulCount': 186,
    'joinDate': DateTime(2022, 01, 15),
    'bio': '조립컴 전문가입니다. CPU, 그래픽카드 리뷰를 주로 작성합니다.',
    'expertise': ['CPU', '그래픽카드', '메인보드'],
    'badges': ['전문가', '인증된 구매자', '베스트 리뷰어'],
  };

  final List<String> _reviewImages = [
    'assets/images/product_reviews/raizen_review_1.png',
    'assets/images/product_reviews/raizen_review_2.png',
    'assets/images/product_reviews/raizen_review_3.png',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
    });
  }

  Future<void> _loadUserData() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final reviewProvider = Provider.of<ReviewProvider>(
        context,
        listen: false,
      );
      await reviewProvider.loadReviewsByUserId(widget.userId);

      if (!mounted) return;

      setState(() {
        _userReviews = reviewProvider.reviewsByUser;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load user profile: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.reviewerProfile)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.reviewerProfile)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(l10n.error, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(_errorMessage),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: _loadUserData, child: Text(l10n.retry)),
            ],
          ),
        ),
      );
    }

    if (_userReviews.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.reviewerProfile)),
        body: Center(child: Text(l10n.noReviewsFound)),
      );
    }

    final userInfo = _userReviews.first;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        foregroundColor: Theme.of(context).colorScheme.onBackground,
        elevation: 0,
        centerTitle: true,
        title: Column(
          children: [
            Text(
              l10n.ranking,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.bestReviewer,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Hero(
                    tag: 'reviewer_profile_${userInfo.userId}',
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: AssetImage(userInfo.userImageUrl),
                    ),
                  ),
                ),
                Text(
                  userInfo.userName,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.emoji_events,
                        color: Colors.amber,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _reviewerStats['rank'],
                        style: const TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    l10n.reviewerBio,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[700],
                      height: 1.4,
                      fontSize: 12,
                    ),
                  ),
                ),

                const SizedBox(height: 24),
                Divider(height: 10, color: Colors.grey[100], thickness: 10),
              ],
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                color: Theme.of(context).colorScheme.background,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildStatItem(
                            l10n.rank,
                            _reviewerStats['rank'],
                            Icons.emoji_events,
                            Colors.amber,
                          ),
                          _buildStatItem(
                            l10n.reviewCount,
                            _reviewerStats['totalReviews'].toString(),
                            Icons.rate_review,
                            Colors.blue,
                          ),
                          _buildStatItem(
                            l10n.helpfulCount,
                            _reviewerStats['helpfulCount'].toString(),
                            Icons.thumb_up,
                            Colors.green,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: Colors.grey[600],
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${l10n.joinDate}: ${DateFormat(l10n.dateFormat).format(_reviewerStats['joinDate'])}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Bio
                      Text(
                        l10n.bio,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _reviewerStats['bio'],
                        style: TextStyle(fontSize: 14, height: 1.4),
                      ),
                      const SizedBox(height: 16),

                      Text(
                        l10n.expertise,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children:
                            (_reviewerStats['expertise'] as List<String>)
                                .map(
                                  (expertise) => Chip(
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.primary.withOpacity(0.1),
                                    label: Text(expertise),
                                    labelStyle: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
                      const SizedBox(height: 16),

                      // Badges
                      Text(
                        l10n.badges,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children:
                            (_reviewerStats['badges'] as List<String>)
                                .map(
                                  (badge) => Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Colors.grey[300]!,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          _getBadgeIcon(badge),
                                          size: 14,
                                          color: _getBadgeColor(badge),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          badge,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '${l10n.writtenReviews} (${_userReviews.length})',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final review = _userReviews[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Card(
                  color: Theme.of(context).colorScheme.background,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap:
                              () =>
                                  context.push('/product/${review.productId}'),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  review.productImageUrl,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      review.productName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        ...List.generate(5, (i) {
                                          return Icon(
                                            i < review.rating.floor()
                                                ? Icons.star
                                                : i < review.rating
                                                ? Icons.star_half
                                                : Icons.star_border,
                                            color: Colors.amber,
                                            size: 16,
                                          );
                                        }),
                                        const SizedBox(width: 4),
                                        Text(
                                          review.rating.toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Divider(),
                        const SizedBox(height: 12),

                        Text(
                          review.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),

                        Text(
                          DateFormat(l10n.dateFormat).format(review.datePosted),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 12),

                        Text(
                          review.content,
                          style: const TextStyle(height: 1.4),
                        ),
                        const SizedBox(height: 16),

                        if (review.pros.isNotEmpty ||
                            review.cons.isNotEmpty) ...[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (review.pros.isNotEmpty)
                                Expanded(
                                  child: _buildProsConsSection(
                                    l10n.pros,
                                    review.pros,
                                    Colors.green,
                                    Icons.thumb_up,
                                  ),
                                ),
                              const SizedBox(width: 16),
                              if (review.cons.isNotEmpty)
                                Expanded(
                                  child: _buildProsConsSection(
                                    l10n.cons,
                                    review.cons,
                                    Colors.red,
                                    Icons.thumb_down,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 16),
                        ],

                        if (index == 0) ...[
                          const Divider(),
                          const SizedBox(height: 12),
                          Text(
                            l10n.reviewImages,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 100,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _reviewImages.length,
                              itemBuilder: (context, imgIndex) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: GestureDetector(
                                    onTap: () {
                                      _showFullScreenImage(
                                        context,
                                        _reviewImages[imgIndex],
                                        imgIndex,
                                      );
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.asset(
                                        _reviewImages[imgIndex],
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],

                        const SizedBox(height: 12),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.thumb_up_alt_outlined,
                                  size: 14,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  l10n.helpfulCountText(review.helpfulCount),
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(l10n.helpful),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }, childCount: _userReviews.length),
          ),
        ],
      ),
    );
  }

  void _showFullScreenImage(BuildContext context, String imagePath, int index) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            insetPadding: EdgeInsets.zero,
            backgroundColor: Colors.black87,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Image viewer with page view
                PageView.builder(
                  controller: PageController(initialPage: index),
                  itemCount: _reviewImages.length,
                  itemBuilder: (context, i) {
                    return InteractiveViewer(
                      minScale: 0.5,
                      maxScale: 3.0,
                      child: Center(
                        child: Image.asset(
                          _reviewImages[i],
                          fit: BoxFit.contain,
                        ),
                      ),
                    );
                  },
                ),
                // Close button
                Positioned(
                  top: 20,
                  right: 20,
                  child: CircleAvatar(
                    backgroundColor: Colors.black54,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      ],
    );
  }

  Widget _buildProsConsSection(
    String title,
    List<String> items,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 4),
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, color: color),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('• ', style: TextStyle(color: color)),
                  Expanded(
                    child: Text(item, style: const TextStyle(fontSize: 13)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getBadgeIcon(String badge) {
    switch (badge) {
      case '전문가':
        return Icons.verified;
      case '인증된 구매자':
        return Icons.shopping_bag;
      case '베스트 리뷰어':
        return Icons.star;
      default:
        return Icons.check_circle;
    }
  }

  Color _getBadgeColor(String badge) {
    switch (badge) {
      case '전문가':
        return Colors.blue;
      case '인증된 구매자':
        return Colors.green;
      case '베스트 리뷰어':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
