import 'package:flutter/material.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../auth/data/datasources/auth_remote_datasource.dart';
import '../../../auth/data/repositories/auth_repository_impl.dart';
import '../../../auth/domain/usecases/logout_usecase.dart';
import '../../../../core/messaging/fcm_service.dart';
import '../../data/datasources/profile_remote_datasource.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/entities/perfil_entity.dart';
import '../../domain/usecases/change_password_usecase.dart';
import '../../domain/usecases/get_perfil_usecase.dart';
import '../../domain/usecases/update_perfil_usecase.dart';

class ProfileProvider extends ChangeNotifier {
  /// Controladores — información personal
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController correoController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();

  /// Controladores — cambio de contraseña
  final TextEditingController passwordActualController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  late final ProfileRepositoryImpl _repository = ProfileRepositoryImpl(
    ProfileRemoteDataSourceImpl(ApiClient(), SecureStorage()),
  );

  late final GetPerfilUseCase _getPerfilUseCase = GetPerfilUseCase(_repository);
  late final UpdatePerfilUseCase _updatePerfilUseCase = UpdatePerfilUseCase(_repository);
  late final ChangePasswordUseCase _changePasswordUseCase = ChangePasswordUseCase(_repository);

  late final LogoutUseCase _logoutUseCase = LogoutUseCase(
    AuthRepositoryImpl(AuthRemoteDataSourceImpl(ApiClient()), SecureStorage()),
  );

  /// Perfil (GET /perfil)
  PerfilEntity? perfil;
  bool cargando = false;
  String? errorMessage;

  /// Guardar información personal (PUT /perfil)
  bool guardando = false;

  /// Cambiar contraseña (PUT /perfil/password)
  bool cambiandoPassword = false;

  /// Visibilidad de los 3 campos de contraseña
  bool ocultarPasswordActual = true;
  bool ocultarPassword = true;
  bool ocultarConfirmacion = true;

  void cambiarVisibilidadPasswordActual() {
    ocultarPasswordActual = !ocultarPasswordActual;
    notifyListeners();
  }

  void cambiarVisibilidadPassword() {
    ocultarPassword = !ocultarPassword;
    notifyListeners();
  }

  void cambiarVisibilidadConfirmacion() {
    ocultarConfirmacion = !ocultarConfirmacion;
    notifyListeners();
  }

  Future<void> cargarPerfil() async {
    cargando = true;
    errorMessage = null;
    notifyListeners();

    try {
      perfil = await _getPerfilUseCase();
      _llenarControladores(perfil!);
    } on ApiException catch (e) {
      errorMessage = e.statusCode == 401
          ? "Tu sesión expiró. Inicia sesión de nuevo."
          : "No se pudo conectar. Intenta de nuevo";
    } catch (_) {
      errorMessage = "Ocurrió un error al cargar tu perfil.";
    } finally {
      cargando = false;
      notifyListeners();
    }
  }

  void _llenarControladores(PerfilEntity perfil) {
    nombreController.text = perfil.nombre;
    correoController.text = perfil.email;
    telefonoController.text = perfil.telefono ?? '';
  }

  /// Guardar cambios de nombre/teléfono. El backend no permite
  /// actualización parcial: ambos campos viajan siempre juntos, y el
  /// email no se puede editar desde aquí.
  Future<void> guardarCambios(BuildContext context) async {
    final nombre = nombreController.text.trim();
    final telefono = telefonoController.text.trim();

    if (nombre.isEmpty || telefono.isEmpty) {
      _mostrarSnackBar(context, "Completa nombre y teléfono.", Colors.orange);
      return;
    }

    guardando = true;
    notifyListeners();

    try {
      perfil = await _updatePerfilUseCase(nombre: nombre, telefono: telefono);
      _llenarControladores(perfil!);

      if (context.mounted) {
        _mostrarSnackBar(context, "Perfil actualizado correctamente.", Colors.green);
      }
    } on ApiException catch (e) {
      if (context.mounted) {
        _mostrarSnackBar(context, e.message, Colors.red);
      }
    } catch (_) {
      if (context.mounted) {
        _mostrarSnackBar(context, "Ocurrió un error al actualizar tu perfil.", Colors.red);
      }
    } finally {
      guardando = false;
      notifyListeners();
    }
  }

  Future<void> cambiarPassword(BuildContext context) async {
    final actual = passwordActualController.text;
    final nueva = passwordController.text;
    final confirmacion = confirmPasswordController.text;

    if (actual.isEmpty || nueva.isEmpty || confirmacion.isEmpty) {
      _mostrarSnackBar(context, "Completa los 3 campos de contraseña.", Colors.orange);
      return;
    }

    if (nueva.length < 8) {
      _mostrarSnackBar(context, "La nueva contraseña debe tener al menos 8 caracteres.", Colors.orange);
      return;
    }

    if (nueva != confirmacion) {
      _mostrarSnackBar(context, "Las contraseñas no coinciden.", Colors.orange);
      return;
    }

    cambiandoPassword = true;
    notifyListeners();

    try {
      await _changePasswordUseCase(passwordActual: actual, passwordNueva: nueva);

      passwordActualController.clear();
      passwordController.clear();
      confirmPasswordController.clear();

      if (context.mounted) {
        _mostrarSnackBar(context, "Contraseña actualizada correctamente.", Colors.green);
      }
    } on ApiException catch (e) {
      if (context.mounted) {
        _mostrarSnackBar(context, e.message, Colors.red);
      }
    } catch (_) {
      if (context.mounted) {
        _mostrarSnackBar(context, "Ocurrió un error al cambiar tu contraseña.", Colors.red);
      }
    } finally {
      cambiandoPassword = false;
      notifyListeners();
    }
  }

  /// Cerrar sesión
  Future<void> cerrarSesion(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Sesión cerrada"),
      ),
    );

    await FcmService().desactivarDispositivoActual();
    await _logoutUseCase();

    if (context.mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  void _mostrarSnackBar(BuildContext context, String mensaje, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: color),
    );
  }

  @override
  void dispose() {
    nombreController.dispose();
    correoController.dispose();
    telefonoController.dispose();
    passwordActualController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
