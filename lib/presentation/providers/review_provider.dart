import 'package:flutter/foundation.dart';
import '../../../domain/entities/review.dart';
import '../../../domain/usecases/review/get_reviews_for_product_usecase.dart';
import '../../../domain/usecases/review/add_review_usecase.dart';
import '../../../domain/usecases/review/get_reviews_by_product_usecase.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import '../../../core/util/logger.dart';

enum ReviewLoadingStatus { initial, loading, loaded, error }

class ReviewProvider extends ChangeNotifier {
  final GetReviewsForProductUseCase _getReviewsForProductUseCase;
  final AddReviewUseCase _addReviewUseCase;
  final GetReviewsByProductUseCase _getReviewsByProductUseCase;

  List<Review> _reviews = [];
  List<Review> _reviewsByUser = [];
  ReviewLoadingStatus _status = ReviewLoadingStatus.initial;
  String _errorMessage = '';
  String _currentProductId = '';
  bool _isLoading = false;
  bool _hasError = false;

  List<Review> get reviews => _reviews;
  List<Review> get reviewsByUser => _reviewsByUser;
  ReviewLoadingStatus get status => _status;
  bool get isLoading => _status == ReviewLoadingStatus.loading || _isLoading;
  bool get hasError => _hasError || _status == ReviewLoadingStatus.error;
  String get errorMessage => _errorMessage;
  String get currentProductId => _currentProductId;

  ReviewProvider({
    required GetReviewsForProductUseCase getReviewsForProductUseCase,
    required AddReviewUseCase addReviewUseCase,
    required GetReviewsByProductUseCase getReviewsByProductUseCase,
  }) : _getReviewsForProductUseCase = getReviewsForProductUseCase,
       _addReviewUseCase = addReviewUseCase,
       _getReviewsByProductUseCase = getReviewsByProductUseCase;

  Future<void> fetchReviewsForProduct(String productId) async {
    if (_currentProductId == productId &&
        _status == ReviewLoadingStatus.loaded) {
      return;
    }

    _status = ReviewLoadingStatus.loading;
    _currentProductId = productId;
    notifyListeners();

    final result = await _getReviewsForProductUseCase.execute(productId);

    result.fold(
      (error) {
        _status = ReviewLoadingStatus.error;
        _errorMessage = error.toString();
      },
      (reviews) {
        _status = ReviewLoadingStatus.loaded;
        _reviews = reviews;
      },
    );

    notifyListeners();
  }

  Future<void> loadReviewsByProduct(String productId) async {
    _isLoading = true;
    _hasError = false;
    _errorMessage = '';
    notifyListeners();

    try {
      final result = await _getReviewsByProductUseCase.execute(productId);

      result.fold(
        (failure) {
          _hasError = true;
          _errorMessage = failure.message;
        },
        (reviews) {
          _reviews = reviews;
        },
      );
    } catch (e) {
      _hasError = true;
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadReviewsByUserId(String userId) async {
    _isLoading = true;
    _hasError = false;
    _errorMessage = '';
    notifyListeners();

    try {
      final String jsonData = await rootBundle.loadString(
        'assets/data/reviews.json',
      );
      final List<dynamic> reviewsData = json.decode(jsonData);

      final List<Review> userReviews = [];

      for (final reviewData in reviewsData) {
        if (reviewData['userId'] == userId) {
          userReviews.add(
            Review(
              id: reviewData['id'],
              productId: reviewData['productId'],
              userId: reviewData['userId'],
              userName: reviewData['userName'],
              userImageUrl: reviewData['userImageUrl'],
              rating: reviewData['rating'].toDouble(),
              title: reviewData['title'],
              content: reviewData['content'],
              pros: List<String>.from(reviewData['pros']),
              cons: List<String>.from(reviewData['cons']),
              datePosted: DateTime.parse(reviewData['datePosted']),
              helpfulCount: reviewData['helpfulCount'],
              productName: reviewData['productName'],
              productImageUrl: reviewData['productImageUrl'],
            ),
          );
        }
      }

      _reviewsByUser = userReviews;
    } catch (e) {
      _hasError = true;
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchReviewsByUser(String userId) async {
    await loadReviewsByUserId(userId);
  }

  Future<bool> addReview(Review review) async {
    _status = ReviewLoadingStatus.loading;
    notifyListeners();

    final result = await _addReviewUseCase.execute(review);

    return result.fold(
      (error) {
        _status = ReviewLoadingStatus.error;
        _errorMessage = error.toString();
        notifyListeners();
        return false;
      },
      (success) {
        if (success) {
          if (review.productId == _currentProductId) {
            _reviews.add(review);
          }
          _status = ReviewLoadingStatus.loaded;
          notifyListeners();
        }
        return success;
      },
    );
  }

  Future<bool> markReviewAsHelpful(String reviewId) async {
    try {
      final reviewIndex = _reviews.indexWhere((r) => r.id == reviewId);
      final userReviewIndex = _reviewsByUser.indexWhere(
        (r) => r.id == reviewId,
      );

      if (reviewIndex >= 0) {
        final updatedReview = _reviews[reviewIndex].copyWith(
          helpfulCount: _reviews[reviewIndex].helpfulCount + 1,
        );
        _reviews[reviewIndex] = updatedReview;
      }

      if (userReviewIndex >= 0) {
        final updatedReview = _reviewsByUser[userReviewIndex].copyWith(
          helpfulCount: _reviewsByUser[userReviewIndex].helpfulCount + 1,
        );
        _reviewsByUser[userReviewIndex] = updatedReview;
      }

      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  void resetState() {
    _isLoading = false;
    _hasError = false;
    _errorMessage = '';
    _reviews = [];
    _status = ReviewLoadingStatus.initial;
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> getTopReviewers() async {
    try {
      final String jsonData = await rootBundle.loadString(
        'assets/data/users.json',
      );
      final List<dynamic> usersData = json.decode(jsonData);

      final List<Map<String, dynamic>> reviewers =
          usersData.map<Map<String, dynamic>>((user) {
            return {
              'id': user['id'],
              'name': user['name'],
              'imageUrl': user['imageUrl'],
              'reviewCount': user['reviewCount'],
              'helpfulCount': 0,
              'statusMessage': user['statusMessage'],
              'rank': user['rank'],
            };
          }).toList();

      reviewers.sort((a, b) => b['reviewCount'].compareTo(a['reviewCount']));

      if (reviewers.isNotEmpty) {
        reviewers.first['isGold'] = true;
      }

      return reviewers.take(10).toList();
    } catch (e) {
      AppLogger.error('Error loading reviewers from JSON: $e');
      return [];
    }
  }

  // Load all reviews for community screen
  Future<List<Review>> loadAllReviews() async {
    _isLoading = true;
    _hasError = false;
    _errorMessage = '';
    notifyListeners();

    try {
      final String jsonData = await rootBundle.loadString(
        'assets/data/reviews.json',
      );
      final List<dynamic> reviewsData = json.decode(jsonData);

      final List<Review> allReviews =
          reviewsData.map((reviewData) {
            return Review(
              id: reviewData['id'],
              productId: reviewData['productId'],
              userId: reviewData['userId'],
              userName: reviewData['userName'],
              userImageUrl: reviewData['userImageUrl'],
              rating: reviewData['rating'].toDouble(),
              title: reviewData['title'],
              content: reviewData['content'],
              pros: List<String>.from(reviewData['pros']),
              cons: List<String>.from(reviewData['cons']),
              datePosted: DateTime.parse(reviewData['datePosted']),
              helpfulCount: reviewData['helpfulCount'],
              productName: reviewData['productName'],
              productImageUrl: reviewData['productImageUrl'],
            );
          }).toList();

      // Sort reviews by date posted (newest first)
      allReviews.sort((a, b) => b.datePosted.compareTo(a.datePosted));

      _isLoading = false;
      notifyListeners();
      return allReviews;
    } catch (e) {
      _hasError = true;
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return [];
    }
  }
}
