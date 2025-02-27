import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/di/service_locator.dart' as di;
import '../../core/di/controller_factory.dart';
import '../providers/product_provider.dart';
import '../providers/review_provider.dart';
import '../providers/banner_provider.dart';
import '../providers/splash_provider.dart';
import '../providers/locale_provider.dart';
import '../controllers/product_detail_controller.dart';
import '../controllers/home_controller.dart';

class ProviderRegistry {
  static List<ChangeNotifierProvider> get globalProviders => [
    ChangeNotifierProvider(create: (_) => di.sl<ProductProvider>()),
    ChangeNotifierProvider(create: (_) => di.sl<ReviewProvider>()),
    ChangeNotifierProvider(create: (_) => di.sl<BannerProvider>()),
    ChangeNotifierProvider(create: (_) => di.sl<SplashProvider>()),
    ChangeNotifierProvider(create: (_) => di.sl<LocaleProvider>()),
  ];

  static ChangeNotifierProvider<ProductDetailController>
  productDetailControllerProvider(String productId) {
    return ChangeNotifierProvider<ProductDetailController>(
      create: (context) {
        final controller = ControllerFactory.createProductDetailController(
          context,
        );
        WidgetsBinding.instance.addPostFrameCallback((_) {
          controller.loadData(productId);
        });
        return controller;
      },
    );
  }

  static ChangeNotifierProvider<HomeController> homeControllerProvider() {
    return ChangeNotifierProvider<HomeController>(
      create: (context) {
        final controller = di.sl<HomeController>();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          controller.initializeData();
        });
        return controller;
      },
    );
  }

  static Widget wrapWithProviders({
    required Widget child,
    required BuildContext context,
    required ScreenType screenType,
    String? productId,
  }) {
    switch (screenType) {
      case ScreenType.productDetail:
        if (productId == null) {
          throw ArgumentError(
            'productId must be provided for ProductDetailScreen',
          );
        }
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => di.sl<ProductProvider>()),
            ChangeNotifierProvider(create: (_) => di.sl<ReviewProvider>()),

            productDetailControllerProvider(productId),
          ],
          builder: (context, _) => child,
        );
      case ScreenType.home:
        return MultiProvider(
          providers: [
            homeControllerProvider(),
            ChangeNotifierProvider(create: (_) => di.sl<ReviewProvider>()),
          ],
          builder: (context, _) => child,
        );
      case ScreenType.profile:
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => di.sl<ReviewProvider>()),
          ],
          builder: (context, _) => child,
        );
      case ScreenType.search:
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => di.sl<ProductProvider>()),
          ],
          builder: (context, _) => child,
        );
      case ScreenType.category:
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => di.sl<ProductProvider>()),
          ],
          builder: (context, _) => child,
        );
      case ScreenType.banner:
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => di.sl<BannerProvider>()),
          ],
          builder: (context, _) => child,
        );
      case ScreenType.community:
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => di.sl<ReviewProvider>()),
          ],
          builder: (context, _) => child,
        );
    }
  }
}

enum ScreenType {
  home,
  productDetail,
  profile,
  search,
  category,
  banner,
  community,
}
