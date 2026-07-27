import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/messaging/fcm_service.dart';
import '../../../auth/domain/usecases/logout_usecase.dart';
import '../../domain/entities/perfil_entity.dart';
import '../../domain/usecases/change_password_usecase.dart';
import '../../domain/usecases/get_perfil_usecase.dart';
import '../../domain/usecases/update_perfil_usecase.dart';

part 'profile_provider.g.dart';

class ProfileState {
  /// Perfil (GET /perfil)
  final PerfilEntity? perfil;
  final bool cargando;
  final String? errorMessage;

  /// Guardar información personal (PUT /perfil)
  final bool guardando;

  /// Cambiar contraseña (PUT /perfil/password)
  final bool cambiandoPassword;

  /// Visibilidad de los 3 campos de contraseña
  final bool ocultarPasswordActual;
  final bool ocultarPassword;
  final bool ocultarConfirmacion;

  const ProfileState({
    this.perfil,
    this.cargando = false,
    this.errorMessage,
    this.guardando = false,
    this.cambiandoPassword = false,
    this.ocultarPasswordActual = true,
    this.ocultarPassword = true,
    this.ocultarConfirmacion = true,
  });

  ProfileState copyWith({
    PerfilEntity? perfil,
    bool? cargando,
    String? errorMessage,
    bool? guardando,
    bool? cambiandoPassword,
    bool? ocultarPasswordActual,
    bool? ocultarPassword,
    bool? ocultarConfirmacion,
  }) {
    return ProfileState(
      perfil: perfil ?? this.perfil,
      cargando: cargando ?? this.cargando,
      errorMessage: errorMessage,
      guardando: guardando ?? this.guardando,
      cambiandoPassword: cambiandoPassword ?? this.cambiandoPassword,
      ocultarPasswordActual:
          ocultarPasswordActual ?? this.ocultarPasswordActual,
      ocultarPassword: ocultarPassword ?? this.ocultarPassword,
      ocultarConfirmacion: ocultarConfirmacion ?? this.ocultarConfirmacion,
    );
  }
}

@riverpod
class ProfileController extends _$ProfileController {
  /// Controladores — información personal
  final nombreController = TextEditingController();
  final correoController = TextEditingController();
  final telefonoController = TextEditingController();

  /// Controladores — cambio de contraseña
  final passwordActualController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  ProfileState build() {
    ref.onDispose(() {
      nombreController.dispose();
      correoController.dispose();
      telefonoController.dispose();
      passwordActualController.dispose();
      passwordController.dispose();
      confirmPasswordController.dispose();
    });
    return const ProfileState();
  }

  void cambiarVisibilidadPasswordActual() {
    state = state.copyWith(
      ocultarPasswordActual: !state.ocultarPasswordActual,
    );
  }

  void cambiarVisibilidadPassword() {
    state = state.copyWith(ocultarPassword: !state.ocultarPassword);
  }

  void cambiarVisibilidadConfirmacion() {
    state = state.copyWith(ocultarConfirmacion: !state.ocultarConfirmacion);
  }

  Future<void> cargarPerfil() async {
    state = state.copyWith(cargando: true, errorMessage: null);

    try {
      final perfil = await getIt<GetPerfilUseCase>()();
      _llenarControladores(perfil);
      state = state.copyWith(perfil: perfil);
    } on ApiException catch (e) {
      state = state.copyWith(
        errorMessage: e.statusCode == 401
            ? "Tu sesión expiró. Inicia sesión de nuevo."
            : "No se pudo conectar. Intenta de nuevo",
      );
    } catch (_) {
      state = state.copyWith(
        errorMessage: "Ocurrió un error al cargar tu perfil.",
      );
    } finally {
      state = state.copyWith(cargando: false);
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

    state = state.copyWith(guardando: true);

    try {
      final perfil = await getIt<UpdatePerfilUseCase>()(
        nombre: nombre,
        telefono: telefono,
      );
      _llenarControladores(perfil);
      state = state.copyWith(perfil: perfil);

      if (context.mounted) {
        _mostrarSnackBar(
          context,
          "Perfil actualizado correctamente.",
          Colors.green,
        );
      }
    } on ApiException catch (e) {
      if (context.mounted) {
        _mostrarSnackBar(context, e.message, Colors.red);
      }
    } catch (_) {
      if (context.mounted) {
        _mostrarSnackBar(
          context,
          "Ocurrió un error al actualizar tu perfil.",
          Colors.red,
        );
      }
    } finally {
      state = state.copyWith(guardando: false);
    }
  }

  Future<void> cambiarPassword(BuildContext context) async {
    final actual = passwordActualController.text;
    final nueva = passwordController.text;
    final confirmacion = confirmPasswordController.text;

    if (actual.isEmpty || nueva.isEmpty || confirmacion.isEmpty) {
      _mostrarSnackBar(
        context,
        "Completa los 3 campos de contraseña.",
        Colors.orange,
      );
      return;
    }

    if (nueva.length < 8) {
      _mostrarSnackBar(
        context,
        "La nueva contraseña debe tener al menos 8 caracteres.",
        Colors.orange,
      );
      return;
    }

    if (nueva != confirmacion) {
      _mostrarSnackBar(context, "Las contraseñas no coinciden.", Colors.orange);
      return;
    }

    state = state.copyWith(cambiandoPassword: true);

    try {
      await getIt<ChangePasswordUseCase>()(
        passwordActual: actual,
        passwordNueva: nueva,
      );

      passwordActualController.clear();
      passwordController.clear();
      confirmPasswordController.clear();

      if (context.mounted) {
        _mostrarSnackBar(
          context,
          "Contraseña actualizada correctamente.",
          Colors.green,
        );
      }
    } on ApiException catch (e) {
      if (context.mounted) {
        _mostrarSnackBar(context, e.message, Colors.red);
      }
    } catch (_) {
      if (context.mounted) {
        _mostrarSnackBar(
          context,
          "Ocurrió un error al cambiar tu contraseña.",
          Colors.red,
        );
      }
    } finally {
      state = state.copyWith(cambiandoPassword: false);
    }
  }

  /// Cerrar sesión
  Future<void> cerrarSesion(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Sesión cerrada"),
      ),
    );

    await getIt<FcmService>().desactivarDispositivoActual();
    await getIt<LogoutUseCase>()();

    if (context.mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  void _mostrarSnackBar(BuildContext context, String mensaje, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: color),
    );
  }
}
