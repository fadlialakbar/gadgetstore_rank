import 'package:dartz/dartz.dart';
import '../../entities/product.dart';
import '../../repositories/product_repository.dart';

class GetTopProductsUseCase {
  final ProductRepository repository;

  GetTopProductsUseCase(this.repository);

  Future<Either<Exception, List<Product>>> execute(int limit) {
    return repository.getTopProducts(limit);
  }
}
