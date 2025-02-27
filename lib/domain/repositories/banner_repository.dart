import '../entities/banner.dart';

abstract class BannerRepository {
  Future<List<Banner>> getBanners();
  Future<List<Banner>> getActiveBanners();
  Future<Banner?> getBannerById(String id);
}
