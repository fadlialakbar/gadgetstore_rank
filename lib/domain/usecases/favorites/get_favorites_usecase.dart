import 'package:dartz/dartz.dart';
import '../../../core/error/failure.dart';
import '../../entities/product.dart';
import '../../repositories/favorites_repository.dart';

class GetFavoritesUseCase {
  final FavoritesRepository _repository;

  GetFavoritesUseCase(this._repository);

  Future<Either<Failure, List<Product>>> execute() async {
    try {
      final favorites = await _repository.getFavorites();
      return Right(favorites);
    } catch (e) {
      return Left(GenericFailure(e.toString()));
    }
  }
}
