import 'package:dartz/dartz.dart';
import '../../core/error/failure.dart';
import '../entities/review.dart';

abstract class ReviewRepository {
  /// Get all reviews for a specific product
  Future<Either<Failure, List<Review>>> getReviewsByProduct(String productId);

  /// Add a new review
  Future<Either<Failure, bool>> addReview(Review review);

  /// Get reviews by specific filters (rating, date, etc.)
  Future<Either<Failure, List<Review>>> getFilteredReviews(
    Map<String, dynamic> filters,
  );

  /// Mark a review as helpful
  Future<Either<Failure, bool>> markReviewAsHelpful(String reviewId);

  /// Get reviews for a specific product (alias for getReviewsByProduct)
  Future<Either<Failure, List<Review>>> getReviewsForProduct(String productId);

  /// Get a single review by its ID
  Future<Either<Failure, Review>> getReviewById(String id);

  /// Get all reviews by a specific user
  Future<Either<Failure, List<Review>>> getUserReviews(String userId);

  /// Update an existing review
  Future<Either<Failure, bool>> updateReview(Review review);

  /// Delete a review by its ID
  Future<Either<Failure, bool>> deleteReview(String id);
}
