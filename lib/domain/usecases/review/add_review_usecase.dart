import 'package:dartz/dartz.dart';
import '../../entities/review.dart';
import '../../repositories/review_repository.dart';
import '../../../core/error/failure.dart';

class AddReviewUseCase {
  final ReviewRepository repository;

  AddReviewUseCase(this.repository);

  Future<Either<Failure, bool>> execute(Review review) {
    return repository.addReview(review);
  }
}
