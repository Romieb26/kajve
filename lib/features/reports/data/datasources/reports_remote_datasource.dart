import '../../../../core/network/api_client.dart';
import '../../../../core/storage/secure_storage.dart';
import '../models/reporte_model.dart';

/// Llamadas HTTP puras a /reportes (global, no va dentro de /lotes).
/// No maneja estado de UI.
abstract class ReportsRemoteDataSource {
  Future<List<ReporteModel>> getReportes();

  Future<ReporteModel> solicitarReporte({
    required int idLote,
    required String tipoReporte,
    required String formato,
  });

  /// [urlArchivo] es la ruta relativa que devuelve el backend en
  /// `url_archivo` (ej. "/reportes/45/descargar"), ya lista para
  /// concatenar con la base de la API.
  Future<ApiFileResponse> descargarArchivo(String urlArchivo);
}

class ReportsRemoteDataSourceImpl implements ReportsRemoteDataSource {
  final ApiClient apiClient;
  final SecureStorage secureStorage;

  ReportsRemoteDataSourceImpl(this.apiClient, this.secureStorage);

  @override
  Future<List<ReporteModel>> getReportes() async {
    final token = await secureStorage.getAccessToken();

    if (token == null) {
      throw const ApiException(
        'Sesión expirada. Inicia sesión de nuevo.',
        statusCode: 401,
      );
    }

    final response = await apiClient.getList('/reportes', token: token);

    return response
        .map((e) => ReporteModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ReporteModel> solicitarReporte({
    required int idLote,
    required String tipoReporte,
    required String formato,
  }) async {
    final token = await secureStorage.getAccessToken();

    if (token == null) {
      throw const ApiException(
        'Sesión expirada. Inicia sesión de nuevo.',
        statusCode: 401,
      );
    }

    final response = await apiClient.post(
      '/reportes',
      body: {
        'id_lote': idLote,
        'tipo_reporte': tipoReporte,
        'formato': formato,
      },
      token: token,
    );

    return ReporteModel.fromJson(response);
  }

  @override
  Future<ApiFileResponse> descargarArchivo(String urlArchivo) async {
    final token = await secureStorage.getAccessToken();

    if (token == null) {
      throw const ApiException(
        'Sesión expirada. Inicia sesión de nuevo.',
        statusCode: 401,
      );
    }

    return apiClient.getBytes(urlArchivo, token: token);
  }
}
