import 'package:flutter/foundation.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/product/get_products_usecase.dart';
import '../../domain/usecases/product/get_top_products_usecase.dart';
import '../../domain/usecases/product/get_product_by_id_usecase.dart';

enum ProductLoadingStatus { initial, loading, loaded, error }

class ProductProvider extends ChangeNotifier {
  final GetProductsUseCase _getProductsUseCase;
  final GetTopProductsUseCase _getTopProductsUseCase;
  final GetProductByIdUseCase _getProductByIdUseCase;

  List<Product> _products = [];
  List<Product> _topProducts = [];
  List<Product> _searchResults = [];
  Product? _selectedProduct;
  ProductLoadingStatus _status = ProductLoadingStatus.initial;
  String? _errorMessage;
  bool _isLoading = false;

  List<Product> get products => _products;
  List<Product> get topProducts => _topProducts;
  List<Product> get searchResults => _searchResults;
  Product? get selectedProduct => _selectedProduct;
  ProductLoadingStatus get status => _status;
  bool get isLoading => _isLoading;
  bool get hasError => _errorMessage != null;
  String? get errorMessage => _errorMessage;

  ProductProvider({
    required GetProductsUseCase getProductsUseCase,
    required GetTopProductsUseCase getTopProductsUseCase,
    required GetProductByIdUseCase getProductByIdUseCase,
  }) : _getProductsUseCase = getProductsUseCase,
       _getTopProductsUseCase = getTopProductsUseCase,
       _getProductByIdUseCase = getProductByIdUseCase;

  Future<void> getAllProducts() async {
    _status = ProductLoadingStatus.loading;
    notifyListeners();

    final result = await _getProductsUseCase.execute();

    result.fold(
      (exception) {
        _status = ProductLoadingStatus.error;
        _errorMessage = exception.toString();
      },
      (products) {
        _products = products;
        _status = ProductLoadingStatus.loaded;
      },
    );

    notifyListeners();
  }

  Future<void> getTopProducts({int limit = 5}) async {
    if (_topProducts.isNotEmpty && _status == ProductLoadingStatus.loaded) {
      return;
    }

    _status = ProductLoadingStatus.loading;
    notifyListeners();

    final result = await _getTopProductsUseCase.execute(limit);

    result.fold(
      (exception) {
        _status = ProductLoadingStatus.error;
        _errorMessage = exception.toString();
      },
      (topProducts) {
        _topProducts = topProducts;
        _status = ProductLoadingStatus.loaded;
      },
    );

    notifyListeners();
  }

  Future<void> getProductById(String id) async {
    _status = ProductLoadingStatus.loading;
    _selectedProduct = null;
    notifyListeners();

    try {
      final result = await _getProductByIdUseCase.execute(id);

      result.fold(
        (exception) {
          _status = ProductLoadingStatus.error;
          _errorMessage = exception.toString();
        },
        (product) {
          _selectedProduct = product;
          _status = ProductLoadingStatus.loaded;
        },
      );
    } catch (e) {
      _status = ProductLoadingStatus.error;
      _errorMessage = e.toString();
    }

    notifyListeners();
  }

  Future<void> searchProducts(String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (_products.isEmpty) {
        await getAllProducts();
      }

      final lowercaseQuery = query.toLowerCase();
      _searchResults =
          _products.where((product) {
            return product.name.toLowerCase().contains(lowercaseQuery) ||
                product.brand.toLowerCase().contains(lowercaseQuery) ||
                product.description.toLowerCase().contains(lowercaseQuery) ||
                product.category.toLowerCase().contains(lowercaseQuery) ||
                (product.tags?.any(
                      (tag) => tag.toLowerCase().contains(lowercaseQuery),
                    ) ??
                    false);
          }).toList();

      _searchResults.sort((a, b) {
        final aNameMatch = a.name.toLowerCase().contains(lowercaseQuery);
        final bNameMatch = b.name.toLowerCase().contains(lowercaseQuery);
        if (aNameMatch && !bNameMatch) return -1;
        if (!aNameMatch && bNameMatch) return 1;
        return 0;
      });

      _isLoading = false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error searching products: $e';
    }

    notifyListeners();
  }

  void resetSelectedProduct() {
    _selectedProduct = null;
    notifyListeners();
  }

  void resetError() {
    _status = ProductLoadingStatus.initial;
    _errorMessage = null;
    notifyListeners();
  }

  List<Product> getProductsByCategory(String category) {
    return _products
        .where(
          (product) => product.category.toLowerCase() == category.toLowerCase(),
        )
        .toList();
  }
}
