import 'package:flutter/material.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../auth/data/datasources/auth_remote_datasource.dart';
import '../../../auth/data/repositories/auth_repository_impl.dart';
import '../../../auth/domain/usecases/refresh_token_usecase.dart';
import '../../../../core/messaging/fcm_service.dart';

class SplashProvider extends ChangeNotifier {
  final SecureStorage _secureStorage = SecureStorage();

  late final RefreshTokenUseCase _refreshTokenUseCase = RefreshTokenUseCase(
    AuthRepositoryImpl(
      AuthRemoteDataSourceImpl(ApiClient()),
      _secureStorage,
    ),
  );

  Future<void> iniciar(BuildContext context) async {
    final tiempoMinimo = Future.delayed(const Duration(seconds: 3));
    final destino = await _resolverDestino();

    await tiempoMinimo;
    if (!context.mounted) return;

    if (destino == AppRoutes.dashboard) {
      final loteIdPendiente = FcmService().consumirLotePendienteAlertas();
      if (loteIdPendiente != null) {
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.alerts,
          arguments: loteIdPendiente,
        );
        return;
      }
    }

    Navigator.pushReplacementNamed(context, destino);
  }

  /// Los tokens viven solo en memoria (ver [SecureStorage]): si la app
  /// fue matada, el proceso reinició y no hay refresh token en memoria,
  /// por lo que este es un arranque en frío y se va directo a login sin
  /// intentar leer nada persistido. Si el proceso sigue vivo (la app
  /// solo estuvo en segundo plano), sí hay refresh token y se intenta
  /// renovar el access token para saltar el login. Solo se fuerza login
  /// si el refresh token fue rechazado (401): un error de red/servidor
  /// no confirma que la sesión sea inválida, así que no debe cerrarla
  /// por un problema transitorio.
  Future<String> _resolverDestino() async {
    final refreshToken = await _secureStorage.getRefreshToken();
    if (refreshToken == null) return AppRoutes.login;

    try {
      final nuevoAccessToken = await _refreshTokenUseCase(refreshToken);
      await _secureStorage.saveAccessToken(nuevoAccessToken);
      return AppRoutes.dashboard;
    } on ApiException catch (e) {
      if (e.statusCode == 401) {
        await _secureStorage.clear();
        return AppRoutes.login;
      }
      return AppRoutes.dashboard;
    } catch (_) {
      return AppRoutes.dashboard;
    }
  }
}
