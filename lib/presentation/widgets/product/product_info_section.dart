import 'package:flutter/material.dart';
import '../../../core/util/constants.dart';
import '../../../domain/entities/product.dart';

class ProductInfoSection extends StatelessWidget {
  final Product product;
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;

  const ProductInfoSection({
    super.key,
    required this.product,
    required this.fadeAnimation,
    required this.slideAnimation,
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
                    product.brand,
                    style: TextStyle(
                      fontSize: AppConstants.smallFontSize,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: AppConstants.mediumFontSize,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),

              SizedBox(height: AppConstants.smallPadding),

              // Product Name
              Text(
                product.name,
                style: TextStyle(
                  fontSize: AppConstants.extraLargeFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: AppConstants.defaultPadding),

              // Rating
              Row(
                children: [
                  _buildRatingStars(product.rating),
                  SizedBox(width: AppConstants.smallPadding),
                  Text(
                    '(${product.reviewCount} reviews)',
                    style: TextStyle(
                      fontSize: AppConstants.smallFontSize,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),

              SizedBox(height: AppConstants.defaultPadding),

              // Tags
              if (product.tags != null && product.tags!.isNotEmpty)
                _buildTags(product.tags!),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRatingStars(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < rating.floor()) {
          return const Icon(Icons.star, color: Colors.amber, size: 18);
        } else if (index == rating.floor() && rating % 1 > 0) {
          return const Icon(Icons.star_half, color: Colors.amber, size: 18);
        } else {
          return const Icon(Icons.star_border, color: Colors.amber, size: 18);
        }
      }),
    );
  }

  Widget _buildTags(List<String> tags) {
    return Wrap(
      spacing: AppConstants.smallPadding,
      runSpacing: AppConstants.smallPadding / 2,
      children:
          tags.map((tag) {
            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppConstants.smallPadding,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(
                  AppConstants.defaultBorderRadius,
                ),
              ),
              child: Text(
                tag,
                style: const TextStyle(fontSize: 12, color: Colors.black87),
              ),
            );
          }).toList(),
    );
  }
}
