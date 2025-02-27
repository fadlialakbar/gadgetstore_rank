import 'package:dartz/dartz.dart';
import '../../entities/review.dart';
import '../../repositories/review_repository.dart';
import '../../../core/error/failure.dart';

class GetReviewsForProductUseCase {
  final ReviewRepository repository;

  GetReviewsForProductUseCase(this.repository);

  Future<Either<Failure, List<Review>>> execute(String productId) {
    return repository.getReviewsForProduct(productId);
  }
}
