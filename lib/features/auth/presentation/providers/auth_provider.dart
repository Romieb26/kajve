import 'package:flutter/material.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/usuario_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';

class AuthProvider extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool ocultarPassword = true;
  bool cargando = false;

  UsuarioEntity? usuario;

  final SecureStorage _secureStorage = SecureStorage();

  late final LoginUseCase _loginUseCase = LoginUseCase(
    AuthRepositoryImpl(
      AuthRemoteDataSourceImpl(ApiClient()),
      _secureStorage,
    ),
  );

  void cambiarVisibilidad() {
    ocultarPassword = !ocultarPassword;
    notifyListeners();
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

    cargando = true;
    notifyListeners();

    try {
      final AuthSession session = await _loginUseCase(
        email: email,
        password: password,
      );

      await _secureStorage.saveSession(
        accessToken: session.accessToken,
        refreshToken: session.refreshToken,
        idUsuario: session.usuario.id,
      );

      usuario = session.usuario;

      if (context.mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
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
      cargando = false;
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
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
