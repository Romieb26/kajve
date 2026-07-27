import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/network/api_client.dart';
import '../../../lots/presentation/providers/lot_provider.dart';
import '../../../reports/domain/usecases/solicitar_reporte_usecase.dart';
import '../../domain/entities/historial_evento_entity.dart';
import '../../domain/usecases/get_historial_usecase.dart';

part 'history_provider.g.dart';

class HistoryState {
  /// Todos los eventos del lote seleccionado, sin filtrar por texto.
  final List<HistorialEventoEntity> todos;
  final List<HistorialEventoEntity> historial;

  final bool cargando;
  final String? errorMessage;

  ///=========================
  /// Reporte PDF (POST /reportes)
  ///=========================

  /// Lote elegido. Como GET /lotes/{id}/historial ya está escopado por
  /// lote, elegir uno aquí sirve doble propósito: carga la lista de
  /// eventos de ese lote Y es el id_lote que viaja en la solicitud de
  /// PDF, con el mismo selector compartido que usa Reportes.
  final int? loteIdSeleccionado;
  final String? loteNombreSeleccionado;

  final bool solicitandoPdf;

  final DateTime? fechaInicioSeleccionada;
  final DateTime? fechaFinSeleccionada;

  const HistoryState({
    this.todos = const [],
    this.historial = const [],
    this.cargando = false,
    this.errorMessage,
    this.loteIdSeleccionado,
    this.loteNombreSeleccionado,
    this.solicitandoPdf = false,
    this.fechaInicioSeleccionada,
    this.fechaFinSeleccionada,
  });

  HistoryState copyWith({
    List<HistorialEventoEntity>? todos,
    List<HistorialEventoEntity>? historial,
    bool? cargando,
    String? errorMessage,
    bool clearError = false,
    int? loteIdSeleccionado,
    String? loteNombreSeleccionado,
    bool? solicitandoPdf,
    DateTime? fechaInicioSeleccionada,
    DateTime? fechaFinSeleccionada,
  }) {
    return HistoryState(
      todos: todos ?? this.todos,
      historial: historial ?? this.historial,
      cargando: cargando ?? this.cargando,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      loteIdSeleccionado: loteIdSeleccionado ?? this.loteIdSeleccionado,
      loteNombreSeleccionado:
          loteNombreSeleccionado ?? this.loteNombreSeleccionado,
      solicitandoPdf: solicitandoPdf ?? this.solicitandoPdf,
      fechaInicioSeleccionada:
          fechaInicioSeleccionada ?? this.fechaInicioSeleccionada,
      fechaFinSeleccionada: fechaFinSeleccionada ?? this.fechaFinSeleccionada,
    );
  }
}

@riverpod
class HistoryController extends _$HistoryController {
  final searchController = TextEditingController();

  @override
  HistoryState build() {
    ref.onDispose(() {
      searchController.dispose();
    });
    return const HistoryState();
  }

  Future<void> cargarHistorial(int loteId) async {
    state = state.copyWith(cargando: true, clearError: true);

    try {
      final todos = await getIt<GetHistorialUseCase>()(loteId);
      state = state.copyWith(todos: todos);
      buscar(searchController.text);
    } on ApiException catch (e) {
      debugPrint('Error real historial: $e (statusCode: ${e.statusCode})');
      state = state.copyWith(
        errorMessage: e.statusCode == 401
            ? "Tu sesión expiró. Inicia sesión de nuevo."
            : "No se pudo conectar. Intenta de nuevo",
      );
    } catch (e) {
      debugPrint('Error real historial: $e');
      state = state.copyWith(
        errorMessage: "Ocurrió un error al cargar el historial.",
      );
    } finally {
      state = state.copyWith(cargando: false);
    }
  }

  void buscar(String texto) {
    if (texto.isEmpty) {
      state = state.copyWith(historial: List.from(state.todos));
    } else {
      final busqueda = texto.toLowerCase();
      state = state.copyWith(
        historial: state.todos.where((evento) {
          return evento.tipoEvento.toLowerCase().contains(busqueda) ||
              evento.descripcion.toLowerCase().contains(busqueda);
        }).toList(),
      );
    }
  }

  void seleccionarLote(Lote lote) {
    if (lote.id == null) return;

    state = state.copyWith(
      loteIdSeleccionado: lote.id,
      loteNombreSeleccionado: lote.nombre,
    );

    cargarHistorial(lote.id!);
  }

  /// Preselecciona un lote por id sin necesitar el objeto Lote completo
  /// (ej. al llegar desde "Ver historial" en el detalle de un lote,
  /// donde solo se conoce el id). Si ya es el lote seleccionado, no
  /// repite la carga.
  void seleccionarLotePorId(int loteId, {String? nombre}) {
    if (state.loteIdSeleccionado == loteId) return;

    state = state.copyWith(
      loteIdSeleccionado: loteId,
      loteNombreSeleccionado: nombre ?? "Lote #$loteId",
    );

    cargarHistorial(loteId);
  }

  void seleccionarFechaInicio(DateTime fecha) {
    state = state.copyWith(fechaInicioSeleccionada: fecha);
  }

  void seleccionarFechaFin(DateTime fecha) {
    state = state.copyWith(fechaFinSeleccionada: fecha);
  }

  Future<void> solicitarPdf(BuildContext context) async {
    final loteId = state.loteIdSeleccionado;

    if (loteId == null) {
      _mostrarSnackBar(context, "Selecciona un lote para generar el PDF.", Colors.orange);
      return;
    }

    state = state.copyWith(solicitandoPdf: true);

    try {
      await getIt<SolicitarReporteUseCase>()(
        idLote: loteId,
        tipoReporte: "historial",
        formato: "pdf",
      );

      if (context.mounted) {
        _mostrarSnackBar(
          context,
          "Reporte solicitado. Podrás descargarlo desde la pantalla de Reportes cuando esté listo.",
          Colors.green,
        );
      }
    } on ApiException catch (e) {
      if (context.mounted) {
        _mostrarSnackBar(context, e.message, Colors.red);
      }
    } catch (_) {
      if (context.mounted) {
        _mostrarSnackBar(context, "Ocurrió un error al solicitar el reporte.", Colors.red);
      }
    } finally {
      state = state.copyWith(solicitandoPdf: false);
    }
  }

  void _mostrarSnackBar(BuildContext context, String mensaje, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: color),
    );
  }
}
