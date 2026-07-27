import 'package:injectable/injectable.dart';

import '../../domain/entities/lot.dart';
import '../../domain/repositories/lot_repository.dart';
import '../datasources/lot_remote_datasource.dart';

@LazySingleton(as: LotRepository)
class LotRepositoryImpl implements LotRepository {
  final LotRemoteDataSource remoteDataSource;

  LotRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<LotEntity>> getLotes() {
    return remoteDataSource.getLotes();
  }
}
