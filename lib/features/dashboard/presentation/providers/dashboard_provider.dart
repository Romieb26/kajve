import 'package:flutter/material.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../data/datasources/dashboard_remote_datasource.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../domain/entities/dashboard_entity.dart';
import '../../domain/get_dashboard_usecase.dart';

class DashboardProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  DashboardEntity? data;

  late final GetDashboardUseCase _getDashboardUseCase = GetDashboardUseCase(
    DashboardRepositoryImpl(
      DashboardRemoteDataSourceImpl(ApiClient(), SecureStorage()),
    ),
  );

  Future<void> loadDashboard() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      data = await _getDashboardUseCase();
    } on ApiException catch (e) {
      // TODO: quitar este print de diagnóstico una vez confirmada la causa.
      debugPrint(
        'DashboardProvider.loadDashboard -> ApiException '
        '(statusCode=${e.statusCode}): ${e.message}',
      );
      errorMessage = e.statusCode == 401
          ? "Tu sesión expiró. Inicia sesión de nuevo."
          : "No se pudo conectar. Intenta de nuevo";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
