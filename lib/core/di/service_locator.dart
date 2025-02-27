import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/datasources/local/local_banner_data_source.dart';
import '../../data/datasources/local/local_product_data_source.dart';
import '../../data/datasources/local/local_review_data_source.dart';
import '../../data/repositories/banner_repository_impl.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../data/repositories/review_repository_impl.dart';
import '../../domain/repositories/banner_repository.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/repositories/review_repository.dart';
import '../../domain/usecases/product/get_products_usecase.dart';
import '../../domain/usecases/product/get_top_products_usecase.dart';
import '../../domain/usecases/product/get_product_by_id_usecase.dart';
import '../../domain/usecases/review/get_reviews_for_product_usecase.dart';
import '../../domain/usecases/review/add_review_usecase.dart';
import '../../domain/usecases/review/get_reviews_by_product_usecase.dart';
import '../../domain/usecases/user/login_usecase.dart';
import '../../domain/usecases/user/get_current_user_usecase.dart';
import '../../domain/usecases/favorites/get_favorites_usecase.dart';
import '../../domain/usecases/favorites/toggle_favorite_usecase.dart';
import '../../domain/usecases/favorites/is_favorite_usecase.dart';
import '../../presentation/providers/product_provider.dart';
import '../../presentation/providers/review_provider.dart';
import '../../domain/usecases/banner/get_active_banners_usecase.dart';
import '../../domain/usecases/banner/get_banners_usecase.dart';
import '../../presentation/providers/banner_provider.dart';
import '../../presentation/providers/splash_provider.dart';
import '../../presentation/providers/locale_provider.dart';
import '../../presentation/controllers/home_controller.dart';

final GetIt sl = GetIt.instance;

class ServiceLocator {
  static Future<void> init() async {
    await _registerCoreComponents();

    _registerDataSources();

    _registerRepositories();

    _registerUseCases();

    _registerProviders();
  }

  static Future<void> _registerCoreComponents() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sl.registerLazySingleton(() => sharedPreferences);
  }

  static void _registerDataSources() {
    // Product data source
    sl.registerLazySingleton<LocalProductDataSource>(() {
      return LocalProductDataSourceImpl();
    });

    // Review data source
    sl.registerLazySingleton<LocalReviewDataSource>(() {
      return LocalReviewDataSourceImpl();
    });

    // Banner data source
    sl.registerLazySingleton<LocalBannerDataSource>(() {
      return LocalBannerDataSourceImpl();
    });
  }

  static void _registerRepositories() {
    // Product repository
    sl.registerLazySingleton<ProductRepository>(
      () => ProductRepositoryImpl(localDataSource: sl()),
    );

    // Review repository
    sl.registerLazySingleton<ReviewRepository>(
      () => ReviewRepositoryImpl(localDataSource: sl()),
    );

    // Banner repository
    sl.registerLazySingleton<BannerRepository>(
      () => BannerRepositoryImpl(localDataSource: sl()),
    );
  }

  static void _registerUseCases() {
    // Product use cases
    sl.registerLazySingleton(() => GetProductsUseCase(sl()));
    sl.registerLazySingleton(() => GetTopProductsUseCase(sl()));
    sl.registerLazySingleton(() => GetProductByIdUseCase(sl()));

    // Review use cases
    sl.registerLazySingleton(() => GetReviewsForProductUseCase(sl()));
    sl.registerLazySingleton(() => AddReviewUseCase(sl()));
    sl.registerLazySingleton(() => GetReviewsByProductUseCase(sl()));

    // User use cases
    sl.registerLazySingleton(() => LoginUseCase(sl()));
    sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));

    // Banner use cases
    sl.registerLazySingleton(() => GetBannersUseCase(sl()));
    sl.registerLazySingleton(() => GetActiveBannersUseCase(sl()));

    // Favorites use cases
    sl.registerLazySingleton(() => GetFavoritesUseCase(sl()));
    sl.registerLazySingleton(() => ToggleFavoriteUseCase(sl()));
    sl.registerLazySingleton(() => IsFavoriteUseCase(sl()));
  }

  static void _registerProviders() {
    sl.registerFactory(
      () => ProductProvider(
        getProductsUseCase: sl(),
        getTopProductsUseCase: sl(),
        getProductByIdUseCase: sl(),
      ),
    );

    sl.registerFactory(
      () => ReviewProvider(
        getReviewsForProductUseCase: sl(),
        addReviewUseCase: sl(),
        getReviewsByProductUseCase: sl(),
      ),
    );

    sl.registerFactory(
      () => BannerProvider(
        getBannersUseCase: sl(),
        getActiveBannersUseCase: sl(),
      ),
    );

    sl.registerFactory(() => SplashProvider());

    // Register LocaleProvider
    sl.registerFactory(() => LocaleProvider());

    // Register HomeController with its dependencies
    sl.registerFactory(
      () => HomeController(
        productProvider: sl<ProductProvider>(),
        bannerProvider: sl<BannerProvider>(),
      ),
    );
  }
}
