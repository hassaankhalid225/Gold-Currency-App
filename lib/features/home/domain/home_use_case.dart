import 'home_model.dart';
import 'home_repository.dart';

class GetDashboardDataUseCase {
  final HomeRepository repository;

  GetDashboardDataUseCase(this.repository);

  Future<HomeModel> call(String country, String currency) {
    return repository.getDashboardData(country, currency);
  }
}
