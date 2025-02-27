import 'package:dartz/dartz.dart';
import '../../entities/product.dart';
import '../../repositories/product_repository.dart';

class GetProductsUseCase {
  final ProductRepository repository;

  GetProductsUseCase(this.repository);

  Future<Either<Exception, List<Product>>> execute() {
    return repository.getProducts();
  }
}
