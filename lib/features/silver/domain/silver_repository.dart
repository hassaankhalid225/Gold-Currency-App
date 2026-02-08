
import 'silver_model.dart';

abstract class SilverRepository {
  Future<SilverModel> getSilverPrice(String country, String currency);
}
