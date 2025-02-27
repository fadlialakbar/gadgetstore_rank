import 'package:dartz/dartz.dart';
import '../../../core/error/failure.dart';
import '../../entities/review.dart';
import '../../repositories/review_repository.dart';

class GetReviewsByProductUseCase {
  final ReviewRepository _reviewRepository;

  GetReviewsByProductUseCase(this._reviewRepository);

  Future<Either<Failure, List<Review>>> execute(String productId) async {
    return await _reviewRepository.getReviewsByProduct(productId);
  }
}
