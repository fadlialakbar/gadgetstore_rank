import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../../../core/util/logger.dart';
import '../../models/banner_model.dart';

abstract class LocalBannerDataSource {
  Future<List<BannerModel>> getBanners();
  Future<List<BannerModel>> getActiveBanners();
  Future<BannerModel?> getBannerById(String id);
  Future<void> initializeData();
}

class LocalBannerDataSourceImpl implements LocalBannerDataSource {
  List<BannerModel> _banners = [];
  bool _isInitialized = false;

  @override
  Future<void> initializeData() async {
    if (_isInitialized) return;

    try {
      final String jsonString = await rootBundle.loadString(
        'assets/data/banners.json',
      );
      final List<dynamic> jsonData = json.decode(jsonString);
      _banners = jsonData.map((json) => BannerModel.fromJson(json)).toList();
      _isInitialized = true;
      AppLogger.info(
        'LocalBannerDataSource: Successfully loaded ${_banners.length} banners from JSON',
      );
    } catch (e) {
      AppLogger.error(
        'LocalBannerDataSource: Error loading banners from JSON',
        e,
      );
      _banners = [];
      _isInitialized = true;
    }
  }

  @override
  Future<List<BannerModel>> getBanners() async {
    await _ensureInitialized();
    AppLogger.debug('LocalBannerDataSource: Fetching all banners');
    return Future.delayed(const Duration(milliseconds: 500), () => _banners);
  }

  @override
  Future<List<BannerModel>> getActiveBanners() async {
    await _ensureInitialized();
    AppLogger.debug('LocalBannerDataSource: Fetching active banners');
    return Future.delayed(
      const Duration(milliseconds: 500),
      () => _banners.where((banner) => banner.isActive).toList(),
    );
  }

  @override
  Future<BannerModel?> getBannerById(String id) async {
    await _ensureInitialized();
    AppLogger.debug('LocalBannerDataSource: Fetching banner with id: $id');
    return Future.delayed(const Duration(milliseconds: 300), () {
      try {
        return _banners.firstWhere((banner) => banner.id == id);
      } catch (e) {
        return null;
      }
    });
  }

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initializeData();
    }
  }
}
