import 'package:dartz/dartz.dart';
import '../../../core/error/failure.dart';
import '../../repositories/favorites_repository.dart';

class IsFavoriteUseCase {
  final FavoritesRepository _repository;

  IsFavoriteUseCase(this._repository);

  Future<Either<Failure, bool>> execute(String productId) async {
    try {
      final result = await _repository.isFavorite(productId);
      return Right(result);
    } catch (e) {
      return Left(GenericFailure(e.toString()));
    }
  }
}
