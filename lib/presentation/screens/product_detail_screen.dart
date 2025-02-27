import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../core/base_screen.dart';
import '../core/provider_registry.dart';
import '../controllers/product_detail_controller.dart';
import '../widgets/product/product_detail_header.dart';
import '../widgets/product/product_info_section.dart';
import '../widgets/product/product_reviews_section.dart';
import '../../core/util/constants.dart';

class ProductDetailScreen extends BaseScreen {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends BaseScreenState<ProductDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  ScreenType get screenType => ScreenType.productDetail;

  @override
  Map<String, dynamic> get providerData => {'productId': widget.productId};

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: Duration(milliseconds: AppConstants.longAnimationDuration),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget buildScreen(BuildContext context) {
    return Consumer<ProductDetailController>(
      builder: (context, controller, _) {
        if (controller.isLoading || controller.product == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final product = controller.product!;

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProductDetailHeader(
                    product: product,
                    fadeAnimation: _fadeAnimation,
                    onBackPressed: () => context.pop(),
                    isFavorite: controller.isFavorite,
                    onFavoriteToggle: controller.toggleFavorite,
                  ),

                  // Ranking Section
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppConstants.defaultPadding,
                          vertical: AppConstants.smallPadding,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildRankingItem(
                              'Rank',
                              '#${product.rank}',
                              Colors.purple.shade700,
                              Icons.leaderboard,
                            ),
                            const SizedBox(width: 16),
                            _buildRankingItem(
                              'Rating',
                              product.rating.toString(),
                              Colors.blue.shade700,
                              Icons.star,
                            ),
                            const SizedBox(width: 16),
                            _buildRankingItem(
                              'Reviews',
                              product.reviewCount.toString(),
                              Colors.orange.shade700,
                              Icons.rate_review,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  ProductInfoSection(
                    product: product,
                    fadeAnimation: _fadeAnimation,
                    slideAnimation: _slideAnimation,
                  ),

                  // Key Features Section
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Padding(
                        padding: EdgeInsets.all(AppConstants.defaultPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Key Features',
                              style: TextStyle(
                                fontSize: AppConstants.mediumFontSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildFeaturesList(product.features),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Description Section
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Padding(
                        padding: EdgeInsets.all(AppConstants.defaultPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Description',
                              style: TextStyle(
                                fontSize: AppConstants.mediumFontSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              product.description,
                              maxLines: controller.isExpanded ? null : 3,
                              overflow:
                                  controller.isExpanded
                                      ? null
                                      : TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: AppConstants.defaultFontSize,
                                color: Colors.grey[800],
                                height: 1.5,
                              ),
                            ),
                            TextButton(
                              onPressed: controller.toggleExpanded,
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(50, 30),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                alignment: Alignment.centerLeft,
                              ),
                              child: Text(
                                controller.isExpanded
                                    ? 'Show Less'
                                    : 'Read More',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Specifications Section
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Padding(
                        padding: EdgeInsets.all(AppConstants.defaultPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Specifications',
                              style: TextStyle(
                                fontSize: AppConstants.mediumFontSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(
                                  AppConstants.defaultBorderRadius,
                                ),
                              ),
                              child: ListView(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                children: [
                                  _buildSpecRow('Brand', product.brand),
                                  _buildDivider(),
                                  _buildSpecRow('Category', product.category),
                                  _buildDivider(),
                                  _buildSpecRow(
                                    'Availability',
                                    product.isAvailable
                                        ? 'In Stock'
                                        : 'Out of Stock',
                                  ),
                                  // Add more specs as needed
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  ProductReviewsSection(
                    reviews: controller.reviews,
                    fadeAnimation: _fadeAnimation,
                    slideAnimation: _slideAnimation,
                    onViewAllReviewsPressed: _showAllReviews,
                  ),

                  const SizedBox(height: 80), // Space for bottom actions
                ],
              ),
            ),
          ),
          bottomSheet: _buildBottomActionBar(context, product),
        );
      },
    );
  }

  Widget _buildRankingItem(
    String label,
    String score,
    Color color,
    IconData icon,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 16),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: AppConstants.smallFontSize,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              score,
              style: TextStyle(
                color: color,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesList(List<String> features) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: features.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  features[index],
                  style: const TextStyle(height: 1.4),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, thickness: 1, color: Colors.grey.shade200);
  }

  Widget _buildBottomActionBar(BuildContext context, dynamic product) {
    return Container(
      padding: EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Price',
                  style: TextStyle(
                    fontSize: AppConstants.smallFontSize,
                    color: Colors.grey[600],
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
          ),
          Expanded(
            flex: 3,
            child: ElevatedButton(
              onPressed: () {
                // Add to cart functionality would go here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    AppConstants.defaultBorderRadius,
                  ),
                ),
              ),
              child: const Text(
                'Add to Cart',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAllReviews() {
    // Logic to navigate to all reviews screen
    if (mounted && context.mounted) {
      final product = context.read<ProductDetailController>().product;
      if (product != null) {
        context.push('/product/${product.id}/reviews');
      }
    }
  }
}
