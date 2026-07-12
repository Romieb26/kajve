import 'package:flutter/material.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../lots/data/datasources/lote_reclamo_remote_datasource.dart';
import '../../../lots/data/repositories/lote_reclamo_repository_impl.dart';
import '../../../lots/domain/usecases/reclamar_lote_usecase.dart';

class QrProvider extends ChangeNotifier {
  late final ReclamarLoteUseCase _reclamarLoteUseCase = ReclamarLoteUseCase(
    LoteReclamoRepositoryImpl(
      LoteReclamoRemoteDataSourceImpl(ApiClient(), SecureStorage()),
    ),
  );

  /// Estado del flash
  bool flash = false;

  /// Evita múltiples lecturas del mismo QR y pausa la cámara mientras
  /// se resuelve PUT /lotes/reclamar.
  bool procesando = false;

  /// Último código leído
  String? ultimoCodigo;

  /// Activa o desactiva el flash
  void toggleFlash() {
    flash = !flash;
    notifyListeners();
  }

  /// Reinicia el escaneo (permite reintentar tras un error, ej. 409)
  void reiniciarEscaneo() {
    procesando = false;
    ultimoCodigo = null;
    notifyListeners();
  }

  /// Procesa el código QR detectado: lo envía tal cual (texto plano, no
  /// JSON) a PUT /lotes/reclamar para asignar el lote pre-creado al
  /// productor que escanea.
  Future<void> detectarCodigo(
    BuildContext context,
    String codigo,
  ) async {
    if (procesando) return;

    procesando = true;
    ultimoCodigo = codigo;
    notifyListeners();

    try {
      final lote = await _reclamarLoteUseCase(codigo);

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
      procesando = false;
      ultimoCodigo = null;
      notifyListeners();

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
          backgroundColor: Colors.red,
        ),
      );
    } catch (_) {
      procesando = false;
      ultimoCodigo = null;
      notifyListeners();

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
