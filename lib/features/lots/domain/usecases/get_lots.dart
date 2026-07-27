import 'package:injectable/injectable.dart';

import '../entities/lot.dart';
import '../repositories/lot_repository.dart';

@injectable
class GetLotsUseCase {
  final LotRepository repository;

  GetLotsUseCase(this.repository);

  Future<List<LotEntity>> call() {
    return repository.getLotes();
  }
}
