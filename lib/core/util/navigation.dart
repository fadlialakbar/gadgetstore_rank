import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppNavigation {
  static void navigateTo(BuildContext context, String path) {
    context.go(path);
  }

  static void toProductDetail(BuildContext context, String productId) {
    context.go('/product/$productId');
  }

  static void toReviewerProfile(BuildContext context, String userId) {
    context.go('/reviewer/$userId');
  }

  static void toSearch(BuildContext context) {
    context.go('/search');
  }

  static void toCategories(BuildContext context) {
    context.go('/categories');
  }

  static void toFavorites(BuildContext context) {
    context.go('/favorites');
  }

  static void toProfile(BuildContext context) {
    context.go('/profile');
  }

  static void toMain(BuildContext context) {
    context.go('/home');
  }

  static void toHome(BuildContext context) {
    context.go('/home');
  }
}
