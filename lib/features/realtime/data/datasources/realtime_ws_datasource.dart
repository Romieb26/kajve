//lib/features/realtime/data/datasources/realtime_ws_datasource.dart
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

import '../../domain/entities/lectura_tiempo_real_entity.dart';
import '../models/lectura_tiempo_real_model.dart';

/// Mensaje recibido del WebSocket de ws-gateway. Puede ser el histórico
/// inicial (una sola vez, al conectar) o una lectura individual en vivo
/// (una por cada evento que ingesta-iot publica en Redis).
class RealtimeWsMessage {
  final bool esHistorial;
  final List<LecturaTiempoRealEntity> historial;
  final LecturaTiempoRealEntity? lectura;

  RealtimeWsMessage.historial(this.historial)
      : esHistorial = true,
        lectura = null;

  RealtimeWsMessage.lectura(LecturaTiempoRealEntity lectura)
      : esHistorial = false,
        historial = const [],
        lectura = lectura;
}

/// Cliente del endpoint `GET /ws/lotes/{id}?token=` de ws-gateway.
///
/// A diferencia del resto de las llamadas de la app (que van por
/// ApiClient/REST contra el dominio de api-mobile), esto habla
/// directamente con el WebSocket Gateway.
class RealtimeWsDataSource {
  // TODO: mientras ws-gateway no esté desplegado detrás de un dominio
  // público, apunta esto a la IP local de la PC donde corre `go run .`
  // (revisa con `ipconfig` en Windows, algo como 192.168.1.XX) — el
  // celular debe estar en la misma red Wi-Fi que la PC. Cuando ya esté
  // desplegado en producción, cambia _host/_port/_useTls por el dominio
  // real (ej. wss://tu-dominio/ws) y pon _useTls en true.
  static const String _host = '192.168.1.90';
  static const int _port = 8002;
  static const bool _useTls = false;

  WebSocketChannel? _channel;

  Stream<RealtimeWsMessage> connect(int loteId, String token) {
    final scheme = _useTls ? 'wss' : 'ws';
    final uri = Uri.parse(
      '$scheme://$_host:$_port/ws/lotes/$loteId?token=$token',
    );

    final channel = WebSocketChannel.connect(uri);
    _channel = channel;

    return channel.stream.map((raw) {
      final json = jsonDecode(raw as String) as Map<String, dynamic>;

      if (json['tipo'] == 'historial') {
        final puntos = (json['puntos'] as List<dynamic>? ?? [])
            .map(
              (p) => LecturaTiempoRealModel.fromJson(p as Map<String, dynamic>),
            )
            .toList();
        return RealtimeWsMessage.historial(puntos);
      }

      return RealtimeWsMessage.lectura(
        LecturaTiempoRealModel.fromJson(json),
      );
    });
  }

  void disconnect() {
    _channel?.sink.close();
    _channel = null;
  }
}
