import '../../entities/banner.dart';
import '../../repositories/banner_repository.dart';

class GetBannersUseCase {
  final BannerRepository repository;

  GetBannersUseCase(this.repository);

  Future<List<Banner>> call() async {
    return await repository.getBanners();
  }
}
