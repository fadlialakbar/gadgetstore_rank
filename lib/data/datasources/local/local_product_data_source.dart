import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:gadget_rank/core/util/logger.dart';
import '../../models/product_model.dart';

abstract class LocalProductDataSource {
  Future<List<ProductModel>> getProducts();
  Future<List<ProductModel>> getTopProducts(int limit);
  Future<ProductModel?> getProductById(String id);
  Future<List<ProductModel>> getProductsByCategory(String category);
  Future<List<ProductModel>> searchProducts(String query);
  Future<void> initializeData();
}

class LocalProductDataSourceImpl implements LocalProductDataSource {
  List<ProductModel> _products = [];
  bool _isInitialized = false;

  @override
  Future<void> initializeData() async {
    if (_isInitialized) return;

    try {
      final String jsonString = await rootBundle.loadString(
        'assets/data/products.json',
      );
      final List<dynamic> jsonData = json.decode(jsonString);
      _products = jsonData.map((json) => ProductModel.fromJson(json)).toList();
      _isInitialized = true;
      AppLogger.debug(
        'LocalProductDataSource: Successfully loaded ${_products.length} products from JSON',
      );
    } catch (e) {
      AppLogger.error(
        'LocalProductDataSource: Error loading products from JSON: $e',
      );
      // Fallback to mock data if JSON loading fails
      _products = [];
      _isInitialized = true;
    }
  }

  @override
  Future<List<ProductModel>> getProducts() async {
    await _ensureInitialized();
    AppLogger.debug('LocalProductDataSource: Fetching all products');
    return Future.delayed(const Duration(milliseconds: 800), () => _products);
  }

  @override
  Future<List<ProductModel>> getTopProducts(int limit) async {
    await _ensureInitialized();
    AppLogger.debug('LocalProductDataSource: Fetching top $limit products');
    return Future.delayed(
      const Duration(milliseconds: 600),
      () => _products.sublist(
        0,
        limit > _products.length ? _products.length : limit,
      ),
    );
  }

  @override
  Future<ProductModel?> getProductById(String id) async {
    await _ensureInitialized();
    AppLogger.debug('LocalProductDataSource: Fetching product with id: $id');
    return Future.delayed(
      const Duration(milliseconds: 500),
      () => _products.firstWhere(
        (product) => product.id == id,
        orElse: () => throw Exception('Product not found'),
      ),
    );
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(String category) async {
    await _ensureInitialized();
    AppLogger.debug(
      'LocalProductDataSource: Fetching products by category: $category',
    );
    return Future.delayed(
      const Duration(milliseconds: 700),
      () =>
          _products
              .where(
                (product) =>
                    product.category.toLowerCase() == category.toLowerCase(),
              )
              .toList(),
    );
  }

  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    await _ensureInitialized();
    AppLogger.debug(
      'LocalProductDataSource: Searching products with query: $query',
    );
    final lowercaseQuery = query.toLowerCase();
    return Future.delayed(
      const Duration(milliseconds: 600),
      () =>
          _products
              .where(
                (product) =>
                    product.name.toLowerCase().contains(lowercaseQuery) ||
                    product.description.toLowerCase().contains(
                      lowercaseQuery,
                    ) ||
                    product.brand.toLowerCase().contains(lowercaseQuery) ||
                    product.category.toLowerCase().contains(lowercaseQuery),
              )
              .toList(),
    );
  }

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initializeData();
    }
  }
}
