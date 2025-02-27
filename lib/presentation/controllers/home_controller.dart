import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/banner.dart' as app_banner;
import '../providers/product_provider.dart';
import '../providers/banner_provider.dart';

class HomeController with ChangeNotifier {
  final ProductProvider _productProvider;
  final BannerProvider _bannerProvider;

  bool _isLoading = false;
  String? _errorMessage;

  List<Product> get topProducts => _productProvider.topProducts;
  List<app_banner.Banner> get activeBanners => _bannerProvider.activeBanners;
  bool get isLoading =>
      _isLoading || _productProvider.isLoading || _bannerProvider.isLoading;
  bool get hasError => _errorMessage != null;
  String? get errorMessage => _errorMessage;

  HomeController({
    required ProductProvider productProvider,
    required BannerProvider bannerProvider,
  }) : _productProvider = productProvider,
       _bannerProvider = bannerProvider;

  Future<void> initializeData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await Future.wait([_loadTopProducts(), _loadActiveBanners()]);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to load home screen data: $e';
      notifyListeners();
    }
  }

  Future<void> _loadTopProducts() async {
    if (_productProvider.topProducts.isEmpty) {
      await _productProvider.getTopProducts();
    }
  }

  Future<void> _loadActiveBanners() async {
    if (_bannerProvider.activeBanners.isEmpty) {
      await _bannerProvider.loadActiveBanners();
    }
  }

  Future<void> refreshData() async {
    await initializeData();
  }
}
