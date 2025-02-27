import 'package:flutter/foundation.dart';
import '../../core/util/logger.dart';
import '../../domain/entities/banner.dart';
import '../../domain/usecases/banner/get_active_banners_usecase.dart';
import '../../domain/usecases/banner/get_banners_usecase.dart';

class BannerProvider with ChangeNotifier {
  final GetBannersUseCase getBannersUseCase;
  final GetActiveBannersUseCase getActiveBannersUseCase;

  List<Banner> _banners = [];
  List<Banner> _activeBanners = [];
  bool _isLoading = false;
  String? _error;

  BannerProvider({
    required this.getBannersUseCase,
    required this.getActiveBannersUseCase,
  });

  List<Banner> get banners => _banners;
  List<Banner> get activeBanners => _activeBanners;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadBanners() async {
    if (_banners.isNotEmpty && !_isLoading) {
      AppLogger.debug('BannerProvider: Banners already loaded, skipping fetch');
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _banners = await getBannersUseCase();
      _error = null;
      AppLogger.debug(
        'BannerProvider: Successfully loaded ${_banners.length} banners',
      );
    } catch (e) {
      _error = e.toString();
      AppLogger.error('BannerProvider: Error loading banners', e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadActiveBanners() async {
    if (_activeBanners.isNotEmpty && !_isLoading) {
      AppLogger.debug(
        'BannerProvider: Active banners already loaded, skipping fetch',
      );
      return;
    }

    if (_isLoading) {
      AppLogger.debug('BannerProvider: Already loading data, skipping request');
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _activeBanners = await getActiveBannersUseCase();
      _error = null;
      AppLogger.debug(
        'BannerProvider: Successfully loaded ${_activeBanners.length} active banners',
      );
    } catch (e) {
      _error = e.toString();
      AppLogger.error('BannerProvider: Error loading active banners', e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
