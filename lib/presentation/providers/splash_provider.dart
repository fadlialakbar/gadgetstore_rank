import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/util/logger.dart';
import '../../data/datasources/local/local_banner_data_source.dart';
import '../../data/datasources/local/local_product_data_source.dart';
import '../../data/datasources/local/local_review_data_source.dart';
import '../../core/di/service_locator.dart' as di;
import 'banner_provider.dart';
import 'product_provider.dart';
import 'review_provider.dart';

enum SplashState { initializing, success, error }

class SplashProvider extends ChangeNotifier {
  SplashState _state = SplashState.initializing;
  String? _errorMessage;

  SplashState get state => _state;
  String? get errorMessage => _errorMessage;

  Future<void> initializeData(BuildContext context) async {
    _state = SplashState.initializing;
    _errorMessage = null;
    notifyListeners();

    try {
      // Get providers in a safer way
      final providers = _getProviders(context);
      final productProvider = providers['product'] as ProductProvider;
      final reviewProvider = providers['review'] as ReviewProvider;
      final bannerProvider = providers['banner'] as BannerProvider;

      AppLogger.info('Starting data initialization process...');

      AppLogger.info('Initializing all data sources...');
      await Future.wait([
        di.sl<LocalProductDataSource>().initializeData(),
        di.sl<LocalReviewDataSource>().initializeData(),
        di.sl<LocalBannerDataSource>().initializeData(),
      ]);
      AppLogger.info('All data sources initialized successfully');

      AppLogger.info('Preloading data into providers...');
      await Future.wait([
        productProvider.getAllProducts(),
        productProvider.getTopProducts(),
        reviewProvider.getTopReviewers(),
        bannerProvider.loadBanners(),
        bannerProvider.loadActiveBanners(),
      ]);
      AppLogger.info('Providers preloaded successfully');

      await Future.delayed(const Duration(milliseconds: 800));
      _state = SplashState.success;
      notifyListeners();
    } catch (e) {
      AppLogger.error('Error initializing application data', e);
      _state = SplashState.error;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  void retry(BuildContext context) {
    initializeData(context);
  }

  // Helper method to get providers safely
  Map<String, dynamic> _getProviders(BuildContext context) {
    try {
      return {
        'product': Provider.of<ProductProvider>(context, listen: false),
        'review': Provider.of<ReviewProvider>(context, listen: false),
        'banner': Provider.of<BannerProvider>(context, listen: false),
      };
    } catch (e) {
      // If this fails, we're probably in the wrong context - try getting from service locator
      return {
        'product': di.sl<ProductProvider>(),
        'review': di.sl<ReviewProvider>(),
        'banner': di.sl<BannerProvider>(),
      };
    }
  }
}
