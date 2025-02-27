import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../presentation/controllers/product_detail_controller.dart';
import '../../presentation/controllers/home_controller.dart';
import '../../presentation/providers/product_provider.dart';
import '../../presentation/providers/review_provider.dart';
import '../../presentation/providers/banner_provider.dart';

class ControllerFactory {
  static ProductDetailController createProductDetailController(
    BuildContext context,
  ) {
    final productProvider = Provider.of<ProductProvider>(
      context,
      listen: false,
    );
    final reviewProvider = Provider.of<ReviewProvider>(context, listen: false);

    return ProductDetailController(
      productProvider: productProvider,
      reviewProvider: reviewProvider,
    );
  }

  static HomeController createHomeController(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(
      context,
      listen: false,
    );
    final bannerProvider = Provider.of<BannerProvider>(context, listen: false);
    return HomeController(
      productProvider: productProvider,
      bannerProvider: bannerProvider,
    );
  }
}
