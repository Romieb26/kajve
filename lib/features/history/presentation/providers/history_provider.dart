import 'package:flutter/material.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../lots/presentation/providers/lot_provider.dart';
import '../../../reports/data/datasources/reports_remote_datasource.dart';
import '../../../reports/data/repositories/reports_repository_impl.dart';
import '../../../reports/domain/usecases/solicitar_reporte_usecase.dart';
import '../../data/datasources/history_remote_datasource.dart';
import '../../data/repositories/history_repository_impl.dart';
import '../../domain/entities/historial_evento_entity.dart';
import '../../domain/usecases/get_historial_usecase.dart';

class HistoryProvider extends ChangeNotifier {

  final TextEditingController searchController =
  TextEditingController();

  late final GetHistorialUseCase _getHistorialUseCase = GetHistorialUseCase(
    HistoryRepositoryImpl(
      HistoryRemoteDataSourceImpl(ApiClient(), SecureStorage()),
    ),
  );

  /// Todos los eventos del lote seleccionado, sin filtrar por texto.
  List<HistorialEventoEntity> _todos = [];

  List<HistorialEventoEntity> historial = [];

  bool cargando = false;
  String? errorMessage;

  Future<void> cargarHistorial(int loteId) async {
    cargando = true;
    errorMessage = null;
    notifyListeners();

    try {
      _todos = await _getHistorialUseCase(loteId);
      buscar(searchController.text);
    } on ApiException catch (e) {
      debugPrint('Error real historial: $e (statusCode: ${e.statusCode})');
      errorMessage = e.statusCode == 401
          ? "Tu sesión expiró. Inicia sesión de nuevo."
          : "No se pudo conectar. Intenta de nuevo";
    } catch (e) {
      debugPrint('Error real historial: $e');
      errorMessage = "Ocurrió un error al cargar el historial.";
    } finally {
      cargando = false;
      notifyListeners();
    }
  }

  void buscar(String texto) {

    if (texto.isEmpty) {
      historial = List.from(_todos);
    } else {
      historial = _todos.where((evento) {
        final busqueda = texto.toLowerCase();

        return evento.tipoEvento.toLowerCase().contains(busqueda) ||
            evento.descripcion.toLowerCase().contains(busqueda);
      }).toList();
    }

    notifyListeners();
  }

  ///=========================
  /// Reporte PDF (POST /reportes)
  ///=========================

  /// Lote elegido. Como GET /lotes/{id}/historial ya está escopado por
  /// lote, elegir uno aquí sirve doble propósito: carga la lista de
  /// eventos de ese lote Y es el id_lote que viaja en la solicitud de
  /// PDF, con el mismo selector compartido que usa Reportes.
  int? loteIdSeleccionado;
  String? loteNombreSeleccionado;

  bool solicitandoPdf = false;

  late final SolicitarReporteUseCase _solicitarReporteUseCase =
      SolicitarReporteUseCase(
    ReportsRepositoryImpl(
      ReportsRemoteDataSourceImpl(ApiClient(), SecureStorage()),
    ),
  );

  void seleccionarLote(Lote lote) {
    if (lote.id == null) return;

    loteIdSeleccionado = lote.id;
    loteNombreSeleccionado = lote.nombre;
    notifyListeners();

    cargarHistorial(lote.id!);
  }

  /// Preselecciona un lote por id sin necesitar el objeto Lote completo
  /// (ej. al llegar desde "Ver historial" en el detalle de un lote,
  /// donde solo se conoce el id). Si ya es el lote seleccionado, no
  /// repite la carga.
  void seleccionarLotePorId(int loteId, {String? nombre}) {
    if (loteIdSeleccionado == loteId) return;

    loteIdSeleccionado = loteId;
    loteNombreSeleccionado = nombre ?? "Lote #$loteId";
    notifyListeners();

    cargarHistorial(loteId);
  }

  DateTime? fechaInicioSeleccionada;
  DateTime? fechaFinSeleccionada;

  void seleccionarFechaInicio(DateTime fecha) {
    fechaInicioSeleccionada = fecha;
    notifyListeners();
  }

  void seleccionarFechaFin(DateTime fecha) {
    fechaFinSeleccionada = fecha;
    notifyListeners();
  }

  Future<void> solicitarPdf(BuildContext context) async {
    final loteId = loteIdSeleccionado;

    if (loteId == null) {
      _mostrarSnackBar(context, "Selecciona un lote para generar el PDF.", Colors.orange);
      return;
    }

    solicitandoPdf = true;
    notifyListeners();

    try {
      await _solicitarReporteUseCase(
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
      solicitandoPdf = false;
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

    searchController.dispose();

    super.dispose();

  }
}
