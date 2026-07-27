import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/messaging/fcm_service.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../domain/entities/usuario_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';

part 'auth_provider.g.dart';

class AuthFormState {
  final bool ocultarPassword;
  final bool cargando;
  final UsuarioEntity? usuario;

  const AuthFormState({
    this.ocultarPassword = true,
    this.cargando = false,
    this.usuario,
  });

  AuthFormState copyWith({
    bool? ocultarPassword,
    bool? cargando,
    UsuarioEntity? usuario,
  }) {
    return AuthFormState(
      ocultarPassword: ocultarPassword ?? this.ocultarPassword,
      cargando: cargando ?? this.cargando,
      usuario: usuario ?? this.usuario,
    );
  }
}

@riverpod
class AuthController extends _$AuthController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  AuthFormState build() {
    ref.onDispose(() {
      emailController.dispose();
      passwordController.dispose();
    });
    return const AuthFormState();
  }

  void cambiarVisibilidad() {
    state = state.copyWith(ocultarPassword: !state.ocultarPassword);
  }

  bool _esEmailValido(String email) =>
      email.contains('@') && email.contains('.');

  Future<void> iniciarSesion(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _mostrarSnackBar(context, "Completa todos los campos.", Colors.orange);
      return;
    }

    if (!_esEmailValido(email)) {
      _mostrarSnackBar(
        context,
        "Ingresa un correo electrónico válido.",
        Colors.orange,
      );
      return;
    }

    state = state.copyWith(cargando: true);

    try {
      final AuthSession session = await getIt<LoginUseCase>()(
        email: email,
        password: password,
      );

      final secureStorage = getIt<SecureStorage>();
      await secureStorage.saveSession(
        accessToken: session.accessToken,
        refreshToken: session.refreshToken,
        idUsuario: session.usuario.id,
      );

      await getIt<FcmService>().registrarTokenPendienteSiExiste();

      state = state.copyWith(usuario: session.usuario);

      final loteIdPendiente =
          getIt<FcmService>().consumirLotePendienteAlertas();

      if (context.mounted) {
        if (loteIdPendiente != null) {
          Navigator.pushReplacementNamed(
            context,
            AppRoutes.alerts,
            arguments: loteIdPendiente,
          );
        } else {
          Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
        }
      }
    } on ApiException catch (e) {
      if (context.mounted) {
        final mensaje = e.statusCode == 401
            ? "Correo o contraseña incorrectos"
            : "No se pudo conectar. Intenta de nuevo";
        _mostrarSnackBar(context, mensaje, Colors.red);
      }
    } catch (e, st) {
      // TODO(debug): quitar una vez identificado el origen del crash.
      debugPrint('LOGIN UNCAUGHT ERROR: $e');
      debugPrint('$st');
      if (context.mounted) {
        _mostrarSnackBar(
          context,
          "Ocurrió un error inesperado. Revisa los logs.",
          Colors.red,
        );
      }
    } finally {
      state = state.copyWith(cargando: false);
    }
  }

  void _mostrarSnackBar(BuildContext context, String mensaje, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: color),
    );
  }
}
