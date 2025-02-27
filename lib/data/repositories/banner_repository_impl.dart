import 'package:gadget_rank/domain/entities/banner.dart';
import '../../domain/repositories/banner_repository.dart';
import '../datasources/local/local_banner_data_source.dart';

class BannerRepositoryImpl implements BannerRepository {
  final LocalBannerDataSource localDataSource;

  BannerRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Banner>> getBanners() async {
    await localDataSource.initializeData();
    return localDataSource.getBanners();
  }

  @override
  Future<List<Banner>> getActiveBanners() async {
    await localDataSource.initializeData();
    return localDataSource.getActiveBanners();
  }

  @override
  Future<Banner?> getBannerById(String id) async {
    await localDataSource.initializeData();
    return localDataSource.getBannerById(id);
  }
}
