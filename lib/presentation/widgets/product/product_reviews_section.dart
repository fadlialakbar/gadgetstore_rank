import 'package:flutter/material.dart';
import '../../../core/util/constants.dart';
import '../../../domain/entities/review.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ProductReviewsSection extends StatelessWidget {
  final List<Review> reviews;
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;
  final VoidCallback onViewAllReviewsPressed;

  const ProductReviewsSection({
    super.key,
    required this.reviews,
    required this.fadeAnimation,
    required this.slideAnimation,
    required this.onViewAllReviewsPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnimation,
      child: SlideTransition(
        position: slideAnimation,
        child: Padding(
          padding: EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Reviews',
                    style: TextStyle(
                      fontSize: AppConstants.largeFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: onViewAllReviewsPressed,
                    child: const Text('View All'),
                  ),
                ],
              ),

              SizedBox(height: AppConstants.smallPadding),

              if (reviews.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text('No reviews yet'),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: reviews.length > 3 ? 3 : reviews.length,
                  itemBuilder: (context, index) {
                    final review = reviews[index];
                    return _buildReviewItem(context, review);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReviewItem(BuildContext context, Review review) {
    final dateFormat = DateFormat('MMM d, yyyy');
    final formattedDate = dateFormat.format(review.datePosted);

    return Card(
      color: Theme.of(context).colorScheme.background,
      margin: EdgeInsets.only(bottom: AppConstants.smallPadding),
      elevation: AppConstants.defaultElevation / 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Reviewer Info
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage:
                      review.userImageUrl.isNotEmpty
                          ? AssetImage(review.userImageUrl)
                          : null,
                  child:
                      review.userImageUrl.isEmpty
                          ? const Icon(Icons.person)
                          : null,
                ),
                SizedBox(width: AppConstants.smallPadding),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Navigate to reviewer profile
                        context.push('/reviewer/${review.userId}');
                      },
                      child: Text(
                        review.userName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      formattedDate,
                      style: TextStyle(
                        fontSize: AppConstants.smallFontSize,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                _buildRatingStars(review.rating),
              ],
            ),

            SizedBox(height: AppConstants.smallPadding),

            // Review Text
            if (review.title.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(bottom: AppConstants.smallPadding / 2),
                child: Text(
                  review.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),

            Text(
              review.content,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: AppConstants.defaultFontSize,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingStars(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < rating.floor()) {
          return const Icon(Icons.star, color: Colors.amber, size: 16);
        } else if (index == rating.floor() && rating % 1 > 0) {
          return const Icon(Icons.star_half, color: Colors.amber, size: 16);
        } else {
          return const Icon(Icons.star_border, color: Colors.amber, size: 16);
        }
      }),
    );
  }
}
