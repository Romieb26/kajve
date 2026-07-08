import '../entities/alerta_entity.dart';

abstract class AlertsRepository {
  Future<List<AlertaEntity>> getAlertas(int loteId);
  Future<void> atenderAlerta(int alertaId);
}
