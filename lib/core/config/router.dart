import 'package:flutter/material.dart';
import 'package:gadget_rank/core/animation/route_transitions.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/screens/home_screen.dart';
import '../../presentation/screens/product_detail_screen.dart';
import '../../presentation/screens/search_screen.dart';
import '../../presentation/screens/profile_screen.dart';
import '../../presentation/screens/splash_screen.dart';
import '../../presentation/screens/banner_detail_screen.dart';
import '../../presentation/screens/product_list_screen.dart';
import '../../presentation/screens/category_screen.dart';
import '../../presentation/screens/community_screen.dart';
import '../../presentation/screens/reviewer_profile_screen.dart';
import '../../presentation/widgets/scaffold_with_nav_bar.dart';
import '../../presentation/core/provider_registry.dart';

class AppRoutes {
  static const String splash = '/splash';

  static const String main = '/';
  static const String home = '/home';
  static const String categories = '/categories';
  static const String community = '/community';
  static const String profile = '/profile';

  static const String productDetail = '/product';
  static const String reviewerProfile = '/reviewer/:id';
  static const String search = '/search';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String favorites = '/favorites';
  static const String banner = '/banner/:id';
  static const String productList = '/product-list';
}

final goRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) {
        return ScaffoldWithNavBar(child: child);
      },
      routes: [
        GoRoute(
          path: AppRoutes.home,
          pageBuilder:
              (context, state) => NoTransitionPage(
                child: ProviderRegistry.wrapWithProviders(
                  context: context,
                  screenType: ScreenType.home,
                  child: const HomeScreen(),
                ),
              ),
        ),
        GoRoute(
          path: AppRoutes.categories,
          pageBuilder:
              (context, state) => NoTransitionPage(
                child: ProviderRegistry.wrapWithProviders(
                  context: context,
                  screenType: ScreenType.category,
                  child: const CategoryScreen(),
                ),
              ),
        ),
        GoRoute(
          path: AppRoutes.community,
          pageBuilder:
              (context, state) => NoTransitionPage(
                child: ProviderRegistry.wrapWithProviders(
                  context: context,
                  screenType: ScreenType.community,
                  child: const CommunityScreen(),
                ),
              ),
        ),
        GoRoute(
          path: AppRoutes.profile,
          pageBuilder:
              (context, state) => NoTransitionPage(
                child: ProviderRegistry.wrapWithProviders(
                  context: context,
                  screenType: ScreenType.profile,
                  child: const ProfileScreen(),
                ),
              ),
        ),
      ],
    ),

    GoRoute(path: AppRoutes.main, redirect: (_, __) => AppRoutes.home),

    GoRoute(
      path: '${AppRoutes.productDetail}/:id',
      builder: (context, state) {
        final productId = state.pathParameters['id']!;
        return ProviderRegistry.wrapWithProviders(
          context: context,
          screenType: ScreenType.productDetail,
          productId: productId,
          child: ProductDetailScreen(productId: productId),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.search,
      builder:
          (context, state) => ProviderRegistry.wrapWithProviders(
            context: context,
            screenType: ScreenType.search,
            child: const SearchScreen(),
          ),
    ),
    GoRoute(
      path: AppRoutes.banner,
      name: 'banner',
      pageBuilder:
          (context, state) => FadeUpwardsPageTransition(
            key: state.pageKey,
            child: ProviderRegistry.wrapWithProviders(
              context: context,
              screenType: ScreenType.banner,
              child: BannerDetailScreen(
                bannerId: state.pathParameters['id'] ?? '',
              ),
            ),
          ),
    ),
    GoRoute(
      path: AppRoutes.productList,
      builder:
          (context, state) => ProviderRegistry.wrapWithProviders(
            context: context,
            screenType: ScreenType.category,
            child: const ProductListScreen(),
          ),
    ),
    GoRoute(
      path: AppRoutes.reviewerProfile,
      builder: (context, state) {
        final reviewerId = state.pathParameters['id']!;
        return ProviderRegistry.wrapWithProviders(
          context: context,
          screenType: ScreenType.profile,
          child: ReviewerProfileScreen(userId: reviewerId),
        );
      },
    ),
  ],
  errorBuilder:
      (context, state) => Scaffold(
        body: Center(child: Text('No route defined for ${state.uri.path}')),
      ),
);
