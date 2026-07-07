import '../entities/lot.dart';

abstract class LotRepository {
  Future<List<LotEntity>> getLotes();
}
