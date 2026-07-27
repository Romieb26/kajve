import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/dashboard_entity.dart';
import '../../domain/get_dashboard_usecase.dart';

part 'dashboard_provider.g.dart';

class DashboardState {
  final bool isLoading;
  final String? errorMessage;
  final DashboardEntity? data;

  const DashboardState({
    this.isLoading = false,
    this.errorMessage,
    this.data,
  });

  DashboardState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    DashboardEntity? data,
  }) {
    return DashboardState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      data: data ?? this.data,
    );
  }
}

@riverpod
class DashboardController extends _$DashboardController {
  @override
  DashboardState build() => const DashboardState();

  Future<void> loadDashboard() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final data = await getIt<GetDashboardUseCase>()();
      state = state.copyWith(data: data);
    } on ApiException catch (e) {
      state = state.copyWith(
        errorMessage: e.statusCode == 401
            ? "Tu sesión expiró. Inicia sesión de nuevo."
            : "No se pudo conectar. Intenta de nuevo",
      );
    } catch (_) {
      // Cualquier error que no sea ApiException (típicamente un fallo al
      // parsear el JSON de la respuesta) no debe dejar la pantalla en
      // blanco silenciosamente.
      state = state.copyWith(
        errorMessage: "Ocurrió un error al cargar el dashboard.",
      );
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}
