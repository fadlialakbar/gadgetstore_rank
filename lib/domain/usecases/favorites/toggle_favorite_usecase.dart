import 'package:dartz/dartz.dart';
import '../../../core/error/failure.dart';
import '../../entities/product.dart';
import '../../repositories/favorites_repository.dart';

class ToggleFavoriteUseCase {
  final FavoritesRepository _repository;

  ToggleFavoriteUseCase(this._repository);

  Future<Either<Failure, bool>> execute(Product product) async {
    try {
      final result = await _repository.toggleFavorite(product);
      return Right(result);
    } catch (e) {
      return Left(GenericFailure(e.toString()));
    }
  }
}
