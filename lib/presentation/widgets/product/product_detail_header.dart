import 'package:flutter/material.dart';
import '../../../core/util/constants.dart';
import '../../../domain/entities/product.dart';

class ProductDetailHeader extends StatelessWidget {
  final Product product;
  final Animation<double> fadeAnimation;
  final VoidCallback onBackPressed;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const ProductDetailHeader({
    super.key,
    required this.product,
    required this.fadeAnimation,
    required this.onBackPressed,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FadeTransition(
          opacity: fadeAnimation,
          child: Hero(
            tag: 'product_image_${product.id}',
            child: Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Image.asset(
                product.imageUrls.isNotEmpty ? product.imageUrls.first : '',
                fit: BoxFit.contain,
                errorBuilder:
                    (ctx, error, _) => const Center(
                      child: Icon(Icons.image_not_supported, size: 50),
                    ),
              ),
            ),
          ),
        ),

        Positioned(
          top: MediaQuery.of(context).padding.top + AppConstants.smallPadding,
          left: AppConstants.defaultPadding,
          child: GestureDetector(
            onTap: onBackPressed,
            child: Container(
              padding: EdgeInsets.all(AppConstants.smallPadding),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.arrow_back, color: Colors.black87),
            ),
          ),
        ),

        Positioned(
          top: MediaQuery.of(context).padding.top + AppConstants.smallPadding,
          right: AppConstants.defaultPadding,
          child: GestureDetector(
            onTap: onFavoriteToggle,
            child: Container(
              padding: EdgeInsets.all(AppConstants.smallPadding),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
