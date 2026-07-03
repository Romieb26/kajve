import '../../../../core/network/api_client.dart';
import '../../../../core/storage/secure_storage.dart';
import '../models/dashboard_response_model.dart';

/// Llamada HTTP pura a GET /dashboard. No maneja estado de UI.
abstract class DashboardRemoteDataSource {
  Future<DashboardResponseModel> getDashboard();
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final ApiClient apiClient;
  final SecureStorage secureStorage;

  DashboardRemoteDataSourceImpl(this.apiClient, this.secureStorage);

  @override
  Future<DashboardResponseModel> getDashboard() async {
    final token = await secureStorage.getAccessToken();

    if (token == null) {
      throw const ApiException(
        'Sesión expirada. Inicia sesión de nuevo.',
        statusCode: 401,
      );
    }

    final json = await apiClient.get('/dashboard', token: token);

    return DashboardResponseModel.fromJson(json);
  }
}
