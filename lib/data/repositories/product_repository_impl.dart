import 'package:dartz/dartz.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/local/local_product_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final LocalProductDataSource localDataSource;

  ProductRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Exception, List<Product>>> getProducts() async {
    try {
      final products = await localDataSource.getProducts();
      return Right(products);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, List<Product>>> getTopProducts(int limit) async {
    try {
      final products = await localDataSource.getTopProducts(limit);
      return Right(products);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, Product>> getProductById(String id) async {
    try {
      final product = await localDataSource.getProductById(id);
      if (product != null) {
        return Right(product);
      } else {
        return Left(Exception('Product not found'));
      }
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, List<Product>>> getProductsByCategory(
    String category,
  ) async {
    try {
      final products = await localDataSource.getProductsByCategory(category);
      return Right(products);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, List<Product>>> searchProducts(String query) async {
    try {
      final products = await localDataSource.searchProducts(query);
      return Right(products);
    } on Exception catch (e) {
      return Left(e);
    }
  }
}
