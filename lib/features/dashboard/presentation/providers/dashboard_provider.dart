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
      errorMessage = e.statusCode == 401
          ? "Tu sesión expiró. Inicia sesión de nuevo."
          : "No se pudo conectar. Intenta de nuevo";
    } catch (e, stack) {
      // TODO: quitar este print de diagnóstico una vez confirmada la causa.
      // Cualquier error que no sea ApiException (típicamente un fallo al
      // parsear el JSON de la respuesta) no debe dejar la pantalla en
      // blanco silenciosamente.
      debugPrint('DashboardProvider.loadDashboard -> error inesperado: $e');
      debugPrint('$stack');
      errorMessage = "Ocurrió un error al cargar el dashboard.";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
