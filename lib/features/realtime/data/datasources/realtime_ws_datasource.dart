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
  // ws-gateway desplegado en el servidor, detrás de TLS — ya no apunta a
  // la IP local de una PC en la misma red Wi-Fi.
  static const String _host = 'ws.dnc-ed-denz.shop';
  static const bool _useTls = true;

  WebSocketChannel? _channel;

  Stream<RealtimeWsMessage> connect(int loteId, String token) {
    final scheme = _useTls ? 'wss' : 'ws';
    final uri = Uri.parse(
      '$scheme://$_host/ws/lotes/$loteId?token=$token',
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
