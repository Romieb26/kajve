import '../entities/lot.dart';
import '../repositories/lot_repository.dart';

class GetLotsUseCase {
  final LotRepository repository;

  GetLotsUseCase(this.repository);

  Future<List<LotEntity>> call() {
    return repository.getLotes();
  }
}
