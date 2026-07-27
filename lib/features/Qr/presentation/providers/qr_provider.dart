import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../lots/domain/usecases/reclamar_lote_usecase.dart';

part 'qr_provider.g.dart';

class QrState {
  /// Estado del flash
  final bool flash;

  /// Evita múltiples lecturas del mismo QR y pausa la cámara mientras
  /// se resuelve PUT /lotes/reclamar.
  final bool procesando;

  /// Último código leído
  final String? ultimoCodigo;

  const QrState({
    this.flash = false,
    this.procesando = false,
    this.ultimoCodigo,
  });

  QrState copyWith({
    bool? flash,
    bool? procesando,
    String? ultimoCodigo,
    bool clearUltimoCodigo = false,
  }) {
    return QrState(
      flash: flash ?? this.flash,
      procesando: procesando ?? this.procesando,
      ultimoCodigo:
          clearUltimoCodigo ? null : (ultimoCodigo ?? this.ultimoCodigo),
    );
  }
}

@riverpod
class QrController extends _$QrController {
  @override
  QrState build() => const QrState();

  /// Activa o desactiva el flash
  void toggleFlash() {
    state = state.copyWith(flash: !state.flash);
  }

  /// Reinicia el escaneo (permite reintentar tras un error, ej. 409)
  void reiniciarEscaneo() {
    state = state.copyWith(procesando: false, clearUltimoCodigo: true);
  }

  /// Procesa el código QR detectado: lo envía tal cual (texto plano, no
  /// JSON) a PUT /lotes/reclamar para asignar el lote pre-creado al
  /// productor que escanea.
  Future<void> detectarCodigo(
    BuildContext context,
    String codigo,
  ) async {
    if (state.procesando) return;

    state = state.copyWith(procesando: true, ultimoCodigo: codigo);

    try {
      final lote = await getIt<ReclamarLoteUseCase>()(codigo);

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Lote '${lote.nombreLote}' asignado correctamente"),
          backgroundColor: Colors.green,
        ),
      );

      await Navigator.pushNamed(
        context,
        AppRoutes.lotDetail,
        arguments: lote.idLote,
      );

      // Si el usuario vuelve a esta pantalla (botón atrás), reactiva el
      // escaneo en vez de dejarlo congelado en "procesando".
      reiniciarEscaneo();
    } on ApiException catch (e) {
      state = state.copyWith(procesando: false, clearUltimoCodigo: true);

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
          backgroundColor: Colors.red,
        ),
      );
    } catch (_) {
      state = state.copyWith(procesando: false, clearUltimoCodigo: true);

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Ocurrió un error inesperado."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
