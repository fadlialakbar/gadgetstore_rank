import 'package:dartz/dartz.dart';
import '../entities/product.dart';

abstract class ProductRepository {
  Future<Either<Exception, List<Product>>> getProducts();
  Future<Either<Exception, List<Product>>> getTopProducts(int limit);
  Future<Either<Exception, Product>> getProductById(String id);
  Future<Either<Exception, List<Product>>> getProductsByCategory(
    String category,
  );
  Future<Either<Exception, List<Product>>> searchProducts(String query);
}
