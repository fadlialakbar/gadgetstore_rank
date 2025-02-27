import 'package:dartz/dartz.dart';
import '../../entities/product.dart';
import '../../repositories/product_repository.dart';

class GetProductByIdUseCase {
  final ProductRepository repository;

  GetProductByIdUseCase(this.repository);

  Future<Either<Exception, Product>> execute(String id) {
    return repository.getProductById(id);
  }
}
