import 'home_model.dart';

abstract class HomeRepository {
  Future<HomeModel> getDashboardData(String country, String currency);
}
