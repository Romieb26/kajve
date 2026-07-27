import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/alerta_entity.dart';
import '../../domain/usecases/atender_alerta_usecase.dart';
import '../../domain/usecases/get_alertas_usecase.dart';

part 'alerts_provider.g.dart';

class AlertsState {
  final bool isLoading;
  final String? errorMessage;
  final List<AlertaEntity> alertasSinFiltrar;
  final List<AlertaEntity> alertas;
  final String filtro;

  const AlertsState({
    this.isLoading = false,
    this.errorMessage,
    this.alertasSinFiltrar = const [],
    this.alertas = const [],
    this.filtro = "Todas",
  });

  AlertsState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    List<AlertaEntity>? alertasSinFiltrar,
    List<AlertaEntity>? alertas,
    String? filtro,
  }) {
    return AlertsState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      alertasSinFiltrar: alertasSinFiltrar ?? this.alertasSinFiltrar,
      alertas: alertas ?? this.alertas,
      filtro: filtro ?? this.filtro,
    );
  }
}

@riverpod
class AlertsController extends _$AlertsController {
  int? _loteId;

  @override
  AlertsState build() => const AlertsState();

  Future<void> cargarDatos(int loteId) async {
    _loteId = loteId;
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final alertasSinFiltrar = await getIt<GetAlertasUseCase>()(loteId);
      state = state.copyWith(alertasSinFiltrar: alertasSinFiltrar);
      _aplicarFiltro();
    } on ApiException catch (e) {
      state = state.copyWith(
        errorMessage: e.statusCode == 401
            ? "Tu sesión expiró. Inicia sesión de nuevo."
            : "No se pudo conectar. Intenta de nuevo",
      );
    } catch (_) {
      state = state.copyWith(
        errorMessage: "Ocurrió un error al cargar las alertas.",
      );
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void filtrar(String nivel) {
    state = state.copyWith(filtro: nivel);
    _aplicarFiltro();
  }

  void _aplicarFiltro() {
    if (state.filtro == "Todas") {
      state = state.copyWith(alertas: List.from(state.alertasSinFiltrar));
    } else {
      state = state.copyWith(
        alertas: state.alertasSinFiltrar
            .where((a) => a.nivelSeveridad == state.filtro)
            .toList(),
      );
    }
  }

  Future<void> atenderAlerta(int alertaId) async {
    final loteId = _loteId;
    if (loteId == null) return;

    try {
      await getIt<AtenderAlertaUseCase>()(alertaId);
      await cargarDatos(loteId);
    } on ApiException catch (e) {
      if (e.statusCode == 404) {
        state = state.copyWith(errorMessage: "Esta alerta ya no existe.");
      } else if (e.statusCode == 403) {
        state = state.copyWith(
          errorMessage: "No tienes permiso sobre este lote.",
        );
      } else {
        state = state.copyWith(
          errorMessage: "No se pudo atender la alerta. Intenta de nuevo.",
        );
      }
    } catch (_) {
      state = state.copyWith(
        errorMessage: "Ocurrió un error al atender la alerta.",
      );
    }
  }
}
