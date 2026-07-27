import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/network/api_client.dart';
import '../../../lots/presentation/providers/lot_provider.dart';
import '../../domain/entities/reporte_entity.dart';
import '../../domain/entities/reporte_narrativo_entity.dart';
import '../../domain/usecases/descargar_reporte_usecase.dart';
import '../../domain/usecases/get_reportes_usecase.dart';
import '../../domain/usecases/obtener_reporte_narrativo_usecase.dart';
import '../../domain/usecases/solicitar_reporte_usecase.dart';

part 'report_provider.g.dart';

class ReportState {
  /// Listado (GET /reportes)
  final bool isLoading;
  final String? errorMessage;
  final List<ReporteEntity> reportes;

  /// Lote elegido para la solicitud (POST /reportes)
  final int? loteIdSeleccionado;
  final String? loteNombreSeleccionado;

  /// Tipo de reporte elegido. tipo_reporte es texto libre en el backend
  /// (validate:"required", sin oneof), así que no es un enum cerrado.
  final String? tipoReporte;

  /// Formato: los únicos dos valores que acepta el backend.
  final String formato;

  final bool solicitando;

  /// Id del reporte cuyo archivo se está descargando ahora mismo (null si
  /// no hay ninguna descarga en curso).
  final int? idDescargando;

  /// Reporte NLG (texto en lenguaje natural, generado al momento) del lote
  /// seleccionado en el formulario -- distinto del PDF/Excel de arriba.
  final bool cargandoNarrativo;
  final String? errorNarrativo;
  final ReporteNarrativoEntity? reporteNarrativo;

  const ReportState({
    this.isLoading = false,
    this.errorMessage,
    this.reportes = const [],
    this.loteIdSeleccionado,
    this.loteNombreSeleccionado,
    this.tipoReporte,
    this.formato = "pdf",
    this.solicitando = false,
    this.idDescargando,
    this.cargandoNarrativo = false,
    this.errorNarrativo,
    this.reporteNarrativo,
  });

  ReportState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    List<ReporteEntity>? reportes,
    int? loteIdSeleccionado,
    String? loteNombreSeleccionado,
    String? tipoReporte,
    String? formato,
    bool? solicitando,
    int? idDescargando,
    bool clearIdDescargando = false,
    bool? cargandoNarrativo,
    String? errorNarrativo,
    bool clearErrorNarrativo = false,
    ReporteNarrativoEntity? reporteNarrativo,
    bool clearReporteNarrativo = false,
  }) {
    return ReportState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      reportes: reportes ?? this.reportes,
      loteIdSeleccionado: loteIdSeleccionado ?? this.loteIdSeleccionado,
      loteNombreSeleccionado:
          loteNombreSeleccionado ?? this.loteNombreSeleccionado,
      tipoReporte: tipoReporte ?? this.tipoReporte,
      formato: formato ?? this.formato,
      solicitando: solicitando ?? this.solicitando,
      idDescargando:
          clearIdDescargando ? null : (idDescargando ?? this.idDescargando),
      cargandoNarrativo: cargandoNarrativo ?? this.cargandoNarrativo,
      errorNarrativo: clearErrorNarrativo
          ? null
          : (errorNarrativo ?? this.errorNarrativo),
      reporteNarrativo: clearReporteNarrativo
          ? null
          : (reporteNarrativo ?? this.reporteNarrativo),
    );
  }
}

/// Tipos de reporte que ofrece la UI (no un enum del backend, ver
/// [ReportState.tipoReporte]).
const List<String> tiposReporte = [
  "Producción",
  "Temperatura",
  "Humedad",
  "Predicción",
];

@riverpod
class ReportController extends _$ReportController {
  /// El backend genera el archivo en background: mientras haya reportes
  /// con url_archivo null, se refresca la lista cada pocos segundos hasta
  /// que aparezca o se agoten los intentos.
  Timer? _pollTimer;
  int _pollIntentos = 0;
  static const _pollIntervalo = Duration(seconds: 3);
  static const _pollMaxIntentos = 40; // ~2 minutos

  @override
  ReportState build() {
    ref.onDispose(() {
      _pollTimer?.cancel();
    });
    return const ReportState();
  }

  Future<void> cargarReporteNarrativo(BuildContext context) async {
    final loteId = state.loteIdSeleccionado;
    if (loteId == null) {
      _mostrarSnackBar(context, "Selecciona un lote.", Colors.orange);
      return;
    }

    state = state.copyWith(
      cargandoNarrativo: true,
      clearErrorNarrativo: true,
      clearReporteNarrativo: true,
    );

    try {
      final reporte = await getIt<ObtenerReporteNarrativoUseCase>()(loteId);
      state = state.copyWith(reporteNarrativo: reporte);
    } on ApiException catch (e) {
      state = state.copyWith(
        errorNarrativo: e.statusCode == 401
            ? "Tu sesión expiró. Inicia sesión de nuevo."
            : e.message,
      );
    } catch (_) {
      state = state.copyWith(
        errorNarrativo: "Ocurrió un error al generar el reporte narrativo.",
      );
    } finally {
      state = state.copyWith(cargandoNarrativo: false);
    }
  }

  Future<void> cargarReportes() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final reportes = await getIt<GetReportesUseCase>()();
      state = state.copyWith(reportes: reportes);
      _pollIntentos = 0;
      _gestionarPolling();
    } on ApiException catch (e) {
      state = state.copyWith(
        errorMessage: e.statusCode == 401
            ? "Tu sesión expiró. Inicia sesión de nuevo."
            : "No se pudo conectar. Intenta de nuevo",
      );
    } catch (_) {
      state = state.copyWith(
        errorMessage: "Ocurrió un error al cargar los reportes.",
      );
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void _gestionarPolling() {
    final hayPendientes = state.reportes.any((r) => r.urlArchivo == null);

    if (!hayPendientes || _pollIntentos >= _pollMaxIntentos) {
      _pollTimer?.cancel();
      _pollTimer = null;
      return;
    }

    _pollTimer ??= Timer.periodic(_pollIntervalo, (_) => _refrescarSilencioso());
  }

  Future<void> _refrescarSilencioso() async {
    _pollIntentos++;

    try {
      final reportes = await getIt<GetReportesUseCase>()();
      state = state.copyWith(reportes: reportes);
    } catch (_) {
      // Se reintenta en el próximo tick; no se sobreescribe errorMessage
      // para no romper una lista que ya se había mostrado bien.
    }

    _gestionarPolling();
  }

  void seleccionarLote(Lote lote) {
    if (lote.id == null) return;

    state = state.copyWith(
      loteIdSeleccionado: lote.id,
      loteNombreSeleccionado: lote.nombre,
    );
  }

  void seleccionarTipo(String? tipo) {
    state = state.copyWith(tipoReporte: tipo);
  }

  void seleccionarFormato(String value) {
    state = state.copyWith(formato: value);
  }

  Future<void> generarReporte(BuildContext context) async {
    final loteId = state.loteIdSeleccionado;
    final tipo = state.tipoReporte;

    if (loteId == null) {
      _mostrarSnackBar(context, "Selecciona un lote.", Colors.orange);
      return;
    }

    if (tipo == null) {
      _mostrarSnackBar(context, "Selecciona un tipo de reporte.", Colors.orange);
      return;
    }

    state = state.copyWith(solicitando: true);

    try {
      final nuevo = await getIt<SolicitarReporteUseCase>()(
        idLote: loteId,
        tipoReporte: tipo,
        formato: state.formato,
      );

      state = state.copyWith(reportes: [nuevo, ...state.reportes]);
      _pollIntentos = 0;
      _gestionarPolling();

      if (context.mounted) {
        _mostrarSnackBar(context, "Reporte solicitado correctamente.", Colors.green);
      }
    } on ApiException catch (e) {
      if (context.mounted) {
        _mostrarSnackBar(context, e.message, Colors.red);
      }
    } catch (_) {
      if (context.mounted) {
        _mostrarSnackBar(
          context,
          "Ocurrió un error al solicitar el reporte.",
          Colors.red,
        );
      }
    } finally {
      state = state.copyWith(solicitando: false);
    }
  }

  Future<void> descargarReporte(BuildContext context, ReporteEntity reporte) async {
    final url = reporte.urlArchivo;
    if (url == null) return;

    state = state.copyWith(idDescargando: reporte.id);

    try {
      final archivo = await getIt<DescargarReporteUseCase>()(url);

      final directorio = await getTemporaryDirectory();
      final extension = reporte.formato.toLowerCase() == 'excel' ? 'xlsx' : 'pdf';
      final nombreArchivo = archivo.fileName ?? 'reporte_${reporte.id}.$extension';

      final archivoLocal = File('${directorio.path}/$nombreArchivo');
      await archivoLocal.writeAsBytes(archivo.bytes);

      await Share.shareXFiles([XFile(archivoLocal.path)]);
    } on ApiException catch (e) {
      if (context.mounted) {
        final mensaje = e.statusCode == 409
            ? "El archivo aún no está disponible. Intenta de nuevo en unos segundos."
            : e.message;
        _mostrarSnackBar(context, mensaje, Colors.red);
      }
    } catch (_) {
      if (context.mounted) {
        _mostrarSnackBar(context, "No se pudo descargar el archivo.", Colors.red);
      }
    } finally {
      state = state.copyWith(clearIdDescargando: true);
    }
  }

  void _mostrarSnackBar(BuildContext context, String mensaje, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: color),
    );
  }
}
