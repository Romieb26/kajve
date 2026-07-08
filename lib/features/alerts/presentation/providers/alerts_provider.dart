import 'package:flutter/material.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../data/datasources/alerts_remote_datasource.dart';
import '../../data/repositories/alerts_repository_impl.dart';
import '../../domain/entities/alerta_entity.dart';
import '../../domain/usecases/atender_alerta_usecase.dart';
import '../../domain/usecases/get_alertas_usecase.dart';

class AlertsProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;

  List<AlertaEntity> _alertas = [];
  List<AlertaEntity> alertas = [];

  String filtro = "Todas";

  int? _loteId;

  late final AlertsRepositoryImpl _repository = AlertsRepositoryImpl(
    AlertsRemoteDataSourceImpl(ApiClient(), SecureStorage()),
  );

  late final GetAlertasUseCase _getAlertasUseCase = GetAlertasUseCase(
    _repository,
  );

  late final AtenderAlertaUseCase _atenderAlertaUseCase = AtenderAlertaUseCase(
    _repository,
  );

  Future<void> cargarDatos(int loteId) async {
    _loteId = loteId;
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      _alertas = await _getAlertasUseCase(loteId);
      _aplicarFiltro();
    } on ApiException catch (e) {
      errorMessage = e.statusCode == 401
          ? "Tu sesión expiró. Inicia sesión de nuevo."
          : "No se pudo conectar. Intenta de nuevo";
    } catch (_) {
      errorMessage = "Ocurrió un error al cargar las alertas.";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void filtrar(String nivel) {
    filtro = nivel;
    _aplicarFiltro();
    notifyListeners();
  }

  void _aplicarFiltro() {
    if (filtro == "Todas") {
      alertas = List.from(_alertas);
    } else {
      alertas = _alertas.where((a) => a.nivelSeveridad == filtro).toList();
    }
  }

  Future<void> atenderAlerta(int alertaId) async {
    final loteId = _loteId;
    if (loteId == null) return;

    try {
      await _atenderAlertaUseCase(alertaId);
      await cargarDatos(loteId);
    } on ApiException catch (e) {
      if (e.statusCode == 404) {
        errorMessage = "Esta alerta ya no existe.";
      } else if (e.statusCode == 403) {
        errorMessage = "No tienes permiso sobre este lote.";
      } else {
        errorMessage = "No se pudo atender la alerta. Intenta de nuevo.";
      }
      notifyListeners();
    } catch (_) {
      errorMessage = "Ocurrió un error al atender la alerta.";
      notifyListeners();
    }
  }
}
