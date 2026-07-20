//libs/features/realtime/presentation/screens/realtime_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../shared/widgets/app_drawer.dart';

import '../providers/realtime_provider.dart';

import '../widgets/realtime_header.dart';
import '../widgets/sensor_grid.dart';
import '../widgets/environment_card.dart';
import '../widgets/chart_card.dart';

class RealtimePage extends StatefulWidget {
  const RealtimePage({super.key});

  @override
  State<RealtimePage> createState() => _RealtimePageState();
}

class _RealtimePageState extends State<RealtimePage>
    with WidgetsBindingObserver {
  int? _loteId;
  bool _inicializado = false;

  // Referencia al provider guardada mientras el context todavía está
  // activo (ver didChangeDependencies), para poder usarla de forma segura
  // en dispose(). Llamar context.read<T>() DENTRO de dispose() puede
  // lanzar "Looking up a deactivated widget's ancestor is unsafe": para
  // ese momento el árbol de widgets ya puede estar desactivado (ej. al
  // salir de la pantalla), y context.read internamente hace una búsqueda
  // en el árbol de ancestros que ya no es válida.
  RealtimeProvider? _provider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _provider = context.read<RealtimeProvider>();

    if (_inicializado) return;
    _inicializado = true;

    final arguments = ModalRoute.of(context)?.settings.arguments;
    _loteId = arguments is int ? arguments : null;

    final loteId = _loteId;
    if (loteId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _provider?.iniciarTiempoReal(loteId);
      });
    }
  }

  // El sistema operativo mata el WebSocket cuando la app pasa a segundo
  // plano (ahorro de batería / doze mode en Android, suspensión en iOS).
  // Sin esto, al volver a abrir la app la pantalla se quedaba con el
  // último estado ("no hay conexión") para siempre, porque nada disparaba
  // una reconexión — solo initState/didChangeDependencies, que no
  // vuelven a correr al pasar de background a foreground.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      final loteId = _loteId;
      if (loteId != null) {
        _provider?.iniciarTiempoReal(loteId);
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // El provider vive a nivel de app (registrado una sola vez en
    // main.dart), así que si no se detiene aquí el WebSocket y el
    // refresco de estadísticas seguirían corriendo en segundo plano tras
    // salir de la pantalla. Se usa la referencia guardada en
    // didChangeDependencies, no un context.read nuevo (ver comentario del
    // campo _provider).
    _provider?.detenerTiempoReal();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loteId = _loteId;

    return Scaffold(
      drawer: const AppDrawer(),

      appBar: AppBar(
        title: const Text("Tiempo Real"),
        centerTitle: true,
      ),

      body: loteId == null
          ? const _MensajeCentrado(
              icono: Icons.error_outline,
              mensaje: "No se especificó el lote a mostrar.",
            )
          : Consumer<RealtimeProvider>(
              builder: (context, provider, child) {
                // El WebSocket de ws-gateway (histórico + lecturas en vivo)
                // no depende de /lotes/{id}/estadisticas: son dos fuentes
                // distintas. Antes, si /estadisticas fallaba (ej. la API
                // de api-mobile caída o su consulta rota), la pantalla
                // completa se quedaba bloqueada en un error aunque el
                // WebSocket sí estuviera entregando datos con normalidad.
                // Ahora solo se bloquea si NO hay nada que mostrar todavía
                // (ni estadísticas ni datos en vivo).
                final hayAlgoQueMostrar = provider.estadisticas != null ||
                    provider.serieTiempoReal.isNotEmpty;

                if (provider.isLoading && !hayAlgoQueMostrar) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.errorMessage != null && !hayAlgoQueMostrar) {
                  return _MensajeCentrado(
                    icono: Icons.cloud_off,
                    mensaje: provider.errorMessage!,
                    onReintentar: () => provider.iniciarTiempoReal(loteId),
                  );
                }

                final ultimaLectura = provider.serieTiempoReal.isNotEmpty
                    ? provider.serieTiempoReal.last
                    : null;

                // Pull-to-refresh: si el WebSocket se cae (ej. el ESP32 se
                // desconectó, o la red falló un momento), antes la única
                // forma de reconectar era salir de la pantalla y volver a
                // entrar. Deslizar hacia abajo desde arriba del todo ahora
                // reinicia la conexión sin salir de la vista.
                return RefreshIndicator(
                  onRefresh: () => provider.iniciarTiempoReal(loteId),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [

                        RealtimeHeader(
                          loteId: loteId,
                          ultimaLectura: ultimaLectura?.timestamp,
                        ),

                        const SizedBox(height: 8),

                        _EstadoConexion(conectado: provider.wsConectado),

                        const SizedBox(height: 12),

                        SensorGrid(ultimaLectura: ultimaLectura),

                        const SizedBox(height: 20),

                        ChartCard(lecturas: provider.serieTiempoReal),

                        const SizedBox(height: 20),

                        EnvironmentCard(estadisticas: provider.estadisticas),

                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class _EstadoConexion extends StatelessWidget {
  final bool conectado;

  const _EstadoConexion({required this.conectado});

  @override
  Widget build(BuildContext context) {
    final color = conectado ? Colors.green : Colors.grey;
    final texto = conectado ? "En vivo" : "Conectando...";

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.circle, size: 10, color: color),
        const SizedBox(width: 6),
        Text(texto, style: TextStyle(color: color, fontSize: 12)),
      ],
    );
  }
}

class _MensajeCentrado extends StatelessWidget {
  final IconData icono;
  final String mensaje;
  final VoidCallback? onReintentar;

  const _MensajeCentrado({
    required this.icono,
    required this.mensaje,
    this.onReintentar,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icono, size: 48, color: Colors.grey),
            const SizedBox(height: 12),
            Text(mensaje, textAlign: TextAlign.center),
            if (onReintentar != null) ...[
              const SizedBox(height: 16),
              FilledButton(
                onPressed: onReintentar,
                child: const Text("Reintentar"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
