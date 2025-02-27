import 'package:dartz/dartz.dart';
import '../../core/error/failure.dart';
import '../../domain/entities/review.dart';
import '../../domain/repositories/review_repository.dart';
import '../datasources/local/local_review_data_source.dart';
import '../models/review_model.dart';
import '../../core/util/logger.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final LocalReviewDataSource _localDataSource;

  ReviewRepositoryImpl({required LocalReviewDataSource localDataSource})
    : _localDataSource = localDataSource;

  @override
  Future<Either<Failure, List<Review>>> getReviewsByProduct(String productId) {
    return getReviewsForProduct(productId);
  }

  @override
  Future<Either<Failure, List<Review>>> getReviewsForProduct(
    String productId,
  ) async {
    try {
      AppLogger.debug(
        'ReviewRepository: Getting reviews for product $productId',
      );
      final reviews = await _localDataSource.getReviewsForProduct(productId);
      AppLogger.debug(
        'ReviewRepository: Retrieved ${reviews.length} reviews for product $productId',
      );
      return Right(reviews);
    } catch (e) {
      AppLogger.error(
        'ReviewRepository: Error getting reviews for product $productId',
        e,
      );
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Review>> getReviewById(String id) async {
    try {
      AppLogger.debug('ReviewRepository: Getting review by id $id');
      final review = await _localDataSource.getReviewById(id);
      if (review != null) {
        AppLogger.debug('ReviewRepository: Successfully retrieved review $id');
        return Right(review);
      } else {
        AppLogger.warning('ReviewRepository: Review with id $id not found');
        return Left(NotFoundFailure('Review not found'));
      }
    } catch (e) {
      AppLogger.error('ReviewRepository: Error getting review by id $id', e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Review>>> getUserReviews(String userId) async {
    try {
      AppLogger.debug('ReviewRepository: Getting reviews for user $userId');
      final reviews = await _localDataSource.getUserReviews(userId);
      AppLogger.debug(
        'ReviewRepository: Retrieved ${reviews.length} reviews for user $userId',
      );
      return Right(reviews);
    } catch (e) {
      AppLogger.error(
        'ReviewRepository: Error getting reviews for user $userId',
        e,
      );
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> addReview(Review review) async {
    try {
      AppLogger.debug(
        'ReviewRepository: Adding new review for product ${review.productId}',
      );
      if (review is ReviewModel) {
        final result = await _localDataSource.addReview(review);
        if (result) {
          AppLogger.debug('ReviewRepository: Successfully added review');
        } else {
          AppLogger.warning('ReviewRepository: Failed to add review');
        }
        return Right(result);
      } else {
        AppLogger.warning(
          'ReviewRepository: Attempted to add non-ReviewModel object',
        );
        return Left(ValidationFailure('Review must be a ReviewModel'));
      }
    } catch (e) {
      AppLogger.error('ReviewRepository: Error adding review', e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateReview(Review review) async {
    try {
      AppLogger.debug('ReviewRepository: Updating review ${review.id}');
      if (review is ReviewModel) {
        final result = await _localDataSource.updateReview(review);
        if (result) {
          AppLogger.debug(
            'ReviewRepository: Successfully updated review ${review.id}',
          );
        } else {
          AppLogger.warning(
            'ReviewRepository: Failed to update review ${review.id}',
          );
        }
        return Right(result);
      } else {
        AppLogger.warning(
          'ReviewRepository: Attempted to update non-ReviewModel object',
        );
        return Left(ValidationFailure('Review must be a ReviewModel'));
      }
    } catch (e) {
      AppLogger.error('ReviewRepository: Error updating review', e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteReview(String id) async {
    try {
      AppLogger.debug('ReviewRepository: Deleting review $id');
      final result = await _localDataSource.deleteReview(id);
      if (result) {
        AppLogger.debug('ReviewRepository: Successfully deleted review $id');
      } else {
        AppLogger.warning('ReviewRepository: Failed to delete review $id');
      }
      return Right(result);
    } catch (e) {
      AppLogger.error('ReviewRepository: Error deleting review $id', e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Review>>> getFilteredReviews(
    Map<String, dynamic> filters,
  ) async {
    try {
      AppLogger.debug(
        'ReviewRepository: Getting filtered reviews with filters: $filters',
      );

      // In a real implementation, we would pass the filters to the data source
      // For now, we'll just retrieve all reviews for the product ID in the filters
      if (filters.containsKey('productId')) {
        final reviews = await _localDataSource.getReviewsForProduct(
          filters['productId'],
        );
        AppLogger.debug(
          'ReviewRepository: Retrieved ${reviews.length} filtered reviews',
        );
        return Right(reviews);
      } else {
        AppLogger.warning(
          'ReviewRepository: No productId filter provided, returning empty list',
        );
        return const Right([]);
      }
    } catch (e) {
      AppLogger.error('ReviewRepository: Error getting filtered reviews', e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> markReviewAsHelpful(String reviewId) async {
    try {
      AppLogger.debug('ReviewRepository: Marking review $reviewId as helpful');
      // In a real implementation, this would update the review in the data source
      // For now, we'll just return success
      AppLogger.debug(
        'ReviewRepository: Successfully marked review $reviewId as helpful',
      );
      return const Right(true);
    } catch (e) {
      AppLogger.error(
        'ReviewRepository: Error marking review $reviewId as helpful',
        e,
      );
      return Left(ServerFailure(e.toString()));
    }
  }
}
