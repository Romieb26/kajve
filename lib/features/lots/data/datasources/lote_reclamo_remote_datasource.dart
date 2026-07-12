import '../../../../core/network/api_client.dart';
import '../../../../core/storage/secure_storage.dart';
import '../models/lote_reclamado_model.dart';

/// Llamada HTTP pura a PUT /lotes/reclamar. No maneja estado de UI.
abstract class LoteReclamoRemoteDataSource {
  Future<LoteReclamadoModel> reclamarLote(String codigoQr);
}

class LoteReclamoRemoteDataSourceImpl implements LoteReclamoRemoteDataSource {
  final ApiClient apiClient;
  final SecureStorage secureStorage;

  LoteReclamoRemoteDataSourceImpl(this.apiClient, this.secureStorage);

  @override
  Future<LoteReclamadoModel> reclamarLote(String codigoQr) async {
    final token = await secureStorage.getAccessToken();

    if (token == null) {
      throw const ApiException(
        'Sesión expirada. Inicia sesión de nuevo.',
        statusCode: 401,
      );
    }

    try {
      final json = await apiClient.put(
        '/lotes/reclamar',
        body: {'codigo_qr': codigoQr},
        token: token,
      );

      return LoteReclamadoModel.fromJson(json);
    } on ApiException catch (e) {
      if (e.statusCode == 409) {
        throw const ApiException(
          'Este código QR no es válido o ya fue utilizado',
          statusCode: 409,
        );
      }
      rethrow;
    }
  }
}
