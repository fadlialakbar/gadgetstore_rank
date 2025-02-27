import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/review.dart';
import '../providers/product_provider.dart';
import '../providers/review_provider.dart';

/// Controller class for the ProductDetailScreen that handles business logic
/// This separates UI from business logic according to clean architecture principles
class ProductDetailController with ChangeNotifier {
  final ProductProvider _productProvider;
  final ReviewProvider _reviewProvider;

  bool _isFavorite = false;
  int _selectedImageIndex = 0;
  bool _isExpanded = false;

  // Getters
  bool get isFavorite => _isFavorite;
  int get selectedImageIndex => _selectedImageIndex;
  bool get isExpanded => _isExpanded;
  Product? get product => _productProvider.selectedProduct;
  bool get isLoading => _productProvider.isLoading;
  String? get errorMessage => _productProvider.errorMessage;
  List<Review> get reviews => _reviewProvider.reviews;
  bool get isReviewsLoading => _reviewProvider.isLoading;

  ProductDetailController({
    required ProductProvider productProvider,
    required ReviewProvider reviewProvider,
  }) : _productProvider = productProvider,
       _reviewProvider = reviewProvider;

  /// Load all data for the product detail screen
  Future<void> loadData(String productId) async {
    await _loadProduct(productId);
    await _loadReviews(productId);
    await _checkFavoriteStatus(productId);
  }

  /// Load product details
  Future<void> _loadProduct(String productId) async {
    await _productProvider.getProductById(productId);
  }

  /// Load reviews for the product
  Future<void> _loadReviews(String productId) async {
    await _reviewProvider.fetchReviewsForProduct(productId);
  }

  /// Check if the product is in favorites
  Future<void> _checkFavoriteStatus(String productId) async {
    // This would typically call a use case via the provider
    // For now we'll just set a default value
    _isFavorite = false;
    notifyListeners();
  }

  /// Toggle favorite status for the product
  void toggleFavorite() {
    _isFavorite = !_isFavorite;
    // Here you would call the appropriate use case via the provider
    // _productProvider.toggleFavorite(product.id);
    notifyListeners();
  }

  /// Set the selected image index
  void setSelectedImageIndex(int index) {
    _selectedImageIndex = index;
    notifyListeners();
  }

  /// Toggle description expanded state
  void toggleExpanded() {
    _isExpanded = !_isExpanded;
    notifyListeners();
  }

  /// Reset controller state
  void resetState() {
    _isFavorite = false;
    _selectedImageIndex = 0;
    _isExpanded = false;
    notifyListeners();
  }

  @override
  void dispose() {
    // Clean up resources if needed
    super.dispose();
  }
}
