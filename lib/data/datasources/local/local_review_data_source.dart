import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../../models/review_model.dart';
import '../../models/product_model.dart';
import '../../models/user_model.dart';
import '../../../core/util/logger.dart';

abstract class LocalReviewDataSource {
  Future<List<ReviewModel>> getReviewsForProduct(String productId);
  Future<ReviewModel?> getReviewById(String id);
  Future<List<ReviewModel>> getUserReviews(String userId);
  Future<bool> addReview(ReviewModel review);
  Future<bool> updateReview(ReviewModel review);
  Future<bool> deleteReview(String id);
  Future<void> initializeData();
}

class LocalReviewDataSourceImpl implements LocalReviewDataSource {
  List<ReviewModel> _reviews = [];
  bool _isInitialized = false;

  LocalReviewDataSourceImpl([LocalReviewDataSourceDependencies? dependencies]);

  @override
  Future<void> initializeData() async {
    if (_isInitialized) return;

    try {
      final String jsonString = await rootBundle.loadString(
        'assets/data/reviews.json',
      );
      final List<dynamic> jsonData = json.decode(jsonString);
      _reviews = jsonData.map((json) => ReviewModel.fromJson(json)).toList();
      _isInitialized = true;
      AppLogger.debug(
        'LocalReviewDataSource: Successfully loaded ${_reviews.length} reviews from JSON',
      );
    } catch (e) {
      AppLogger.error(
        'LocalReviewDataSource: Error loading reviews from JSON',
        e,
      );
      _reviews = [];
      _isInitialized = true;
    }
  }

  @override
  Future<List<ReviewModel>> getReviewsForProduct(String productId) async {
    await _ensureInitialized();
    AppLogger.debug(
      'LocalReviewDataSource: Fetching reviews for product: $productId',
    );
    return Future.delayed(
      const Duration(milliseconds: 700),
      () => _reviews.where((review) => review.productId == productId).toList(),
    );
  }

  @override
  Future<ReviewModel?> getReviewById(String id) async {
    await _ensureInitialized();
    AppLogger.debug('LocalReviewDataSource: Fetching review with id: $id');
    return Future.delayed(const Duration(milliseconds: 500), () {
      try {
        return _reviews.firstWhere((review) => review.id == id);
      } catch (e) {
        AppLogger.warning(
          'LocalReviewDataSource: Review with id $id not found',
        );
        return null;
      }
    });
  }

  @override
  Future<List<ReviewModel>> getUserReviews(String userId) async {
    await _ensureInitialized();
    AppLogger.debug('LocalReviewDataSource: Fetching reviews by user: $userId');
    return Future.delayed(
      const Duration(milliseconds: 600),
      () => _reviews.where((review) => review.userId == userId).toList(),
    );
  }

  @override
  Future<bool> addReview(ReviewModel review) async {
    await _ensureInitialized();
    AppLogger.debug('LocalReviewDataSource: Adding new review');
    return Future.delayed(const Duration(milliseconds: 800), () {
      try {
        final reviewWithId = ReviewModel(
          id:
              'review${(int.parse(_reviews.isNotEmpty ? _reviews.last.id.replaceAll('review', '') : '0') + 1).toString().padLeft(3, '0')}',
          productId: review.productId,
          userId: review.userId,
          userName: review.userName,
          userImageUrl: review.userImageUrl,
          rating: review.rating,
          title: review.title,
          content: review.content,
          pros: review.pros,
          cons: review.cons,
          datePosted: DateTime.now(),
          helpfulCount: 0,
          productName: review.productName,
          productImageUrl: review.productImageUrl,
        );
        _reviews.add(reviewWithId);
        AppLogger.debug(
          'LocalReviewDataSource: Successfully added review with id: ${reviewWithId.id}',
        );
        return true;
      } catch (e) {
        AppLogger.error('LocalReviewDataSource: Error adding review', e);
        return false;
      }
    });
  }

  @override
  Future<bool> updateReview(ReviewModel review) async {
    await _ensureInitialized();
    AppLogger.debug(
      'LocalReviewDataSource: Updating review with id: ${review.id}',
    );
    return Future.delayed(const Duration(milliseconds: 700), () {
      try {
        final index = _reviews.indexWhere((r) => r.id == review.id);
        if (index != -1) {
          _reviews[index] = review;
          AppLogger.debug(
            'LocalReviewDataSource: Successfully updated review with id: ${review.id}',
          );
          return true;
        }
        AppLogger.warning(
          'LocalReviewDataSource: Review with id ${review.id} not found for update',
        );
        return false;
      } catch (e) {
        AppLogger.error('LocalReviewDataSource: Error updating review', e);
        return false;
      }
    });
  }

  @override
  Future<bool> deleteReview(String id) async {
    await _ensureInitialized();
    AppLogger.debug('LocalReviewDataSource: Deleting review with id: $id');
    return Future.delayed(const Duration(milliseconds: 600), () {
      try {
        final index = _reviews.indexWhere((r) => r.id == id);
        if (index != -1) {
          _reviews.removeAt(index);
          AppLogger.debug(
            'LocalReviewDataSource: Successfully deleted review with id: $id',
          );
          return true;
        }
        AppLogger.warning(
          'LocalReviewDataSource: Review with id $id not found for deletion',
        );
        return false;
      } catch (e) {
        AppLogger.error('LocalReviewDataSource: Error deleting review', e);
        return false;
      }
    });
  }

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initializeData();
    }
  }
}

class LocalReviewDataSourceDependencies {
  final List<ProductModel> products;
  final List<UserModel> users;

  LocalReviewDataSourceDependencies({
    required this.products,
    required this.users,
  });
}
