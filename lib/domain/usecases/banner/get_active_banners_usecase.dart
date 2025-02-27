import '../../entities/banner.dart';
import '../../repositories/banner_repository.dart';

class GetActiveBannersUseCase {
  final BannerRepository repository;

  GetActiveBannersUseCase(this.repository);

  Future<List<Banner>> call() async {
    return await repository.getActiveBanners();
  }
}
