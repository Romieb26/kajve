import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../lots/presentation/providers/lot_provider.dart';
import '../../data/datasources/reports_remote_datasource.dart';
import '../../data/repositories/reports_repository_impl.dart';
import '../../domain/entities/reporte_entity.dart';
import '../../domain/usecases/descargar_reporte_usecase.dart';
import '../../domain/usecases/get_reportes_usecase.dart';
import '../../domain/usecases/solicitar_reporte_usecase.dart';

class ReportProvider extends ChangeNotifier {
  /// Listado (GET /reportes)
  bool isLoading = false;
  String? errorMessage;
  List<ReporteEntity> reportes = [];

  /// Lote elegido para la solicitud (POST /reportes)
  int? loteIdSeleccionado;
  String? loteNombreSeleccionado;

  /// Tipos de reporte. tipo_reporte es texto libre en el backend
  /// (validate:"required", sin oneof), así que estos 4 valores no son
  /// un enum cerrado — son simplemente las opciones que ofrece la UI.
  final List<String> tipos = [
    "Producción",
    "Temperatura",
    "Humedad",
    "Predicción",
  ];
  String? tipoReporte;

  /// Formato: los únicos dos valores que acepta el backend.
  String formato = "pdf";

  bool solicitando = false;

  /// Id del reporte cuyo archivo se está descargando ahora mismo (null si
  /// no hay ninguna descarga en curso).
  int? idDescargando;

  /// El backend genera el archivo en background: mientras haya reportes
  /// con url_archivo null, se refresca la lista cada pocos segundos hasta
  /// que aparezca o se agoten los intentos.
  Timer? _pollTimer;
  int _pollIntentos = 0;
  static const _pollIntervalo = Duration(seconds: 3);
  static const _pollMaxIntentos = 40; // ~2 minutos

  late final ReportsRepositoryImpl _repository = ReportsRepositoryImpl(
    ReportsRemoteDataSourceImpl(ApiClient(), SecureStorage()),
  );

  late final GetReportesUseCase _getReportesUseCase = GetReportesUseCase(
    _repository,
  );

  late final SolicitarReporteUseCase _solicitarReporteUseCase =
      SolicitarReporteUseCase(_repository);

  late final DescargarReporteUseCase _descargarReporteUseCase =
      DescargarReporteUseCase(_repository);

  Future<void> cargarReportes() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      reportes = await _getReportesUseCase();
      _pollIntentos = 0;
      _gestionarPolling();
    } on ApiException catch (e) {
      errorMessage = e.statusCode == 401
          ? "Tu sesión expiró. Inicia sesión de nuevo."
          : "No se pudo conectar. Intenta de nuevo";
    } catch (_) {
      errorMessage = "Ocurrió un error al cargar los reportes.";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _gestionarPolling() {
    final hayPendientes = reportes.any((r) => r.urlArchivo == null);

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
      reportes = await _getReportesUseCase();
      notifyListeners();
    } catch (_) {
      // Se reintenta en el próximo tick; no se sobreescribe errorMessage
      // para no romper una lista que ya se había mostrado bien.
    }

    _gestionarPolling();
  }

  void seleccionarLote(Lote lote) {
    if (lote.id == null) return;

    loteIdSeleccionado = lote.id;
    loteNombreSeleccionado = lote.nombre;
    notifyListeners();
  }

  void seleccionarTipo(String? tipo) {
    tipoReporte = tipo;
    notifyListeners();
  }

  void seleccionarFormato(String value) {
    formato = value;
    notifyListeners();
  }

  Future<void> generarReporte(BuildContext context) async {
    final loteId = loteIdSeleccionado;
    final tipo = tipoReporte;

    if (loteId == null) {
      _mostrarSnackBar(context, "Selecciona un lote.", Colors.orange);
      return;
    }

    if (tipo == null) {
      _mostrarSnackBar(context, "Selecciona un tipo de reporte.", Colors.orange);
      return;
    }

    solicitando = true;
    notifyListeners();

    try {
      final nuevo = await _solicitarReporteUseCase(
        idLote: loteId,
        tipoReporte: tipo,
        formato: formato,
      );

      reportes = [nuevo, ...reportes];
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
      solicitando = false;
      notifyListeners();
    }
  }

  Future<void> descargarReporte(BuildContext context, ReporteEntity reporte) async {
    final url = reporte.urlArchivo;
    if (url == null) return;

    idDescargando = reporte.id;
    notifyListeners();

    try {
      final archivo = await _descargarReporteUseCase(url);

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
      idDescargando = null;
      notifyListeners();
    }
  }

  void _mostrarSnackBar(BuildContext context, String mensaje, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: color),
    );
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }
}
