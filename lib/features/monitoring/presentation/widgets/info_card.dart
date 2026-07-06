import 'package:flutter/material.dart';

import '../../domain/entities/estadisticas_entity.dart';
import '../widgets/sensor_status_card.dart';

class InfoCard extends StatelessWidget {
  final EstadisticasEntity estadisticas;

  const InfoCard({
    super.key,
    required this.estadisticas,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),

      child: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Información del lote",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Divider(height: 30),

            _fila("Días de secado", "${estadisticas.diasSecado}"),
            _fila("Total de lecturas", "${estadisticas.totalLecturas}"),
            _fila("Alertas totales", "${estadisticas.totalAlertas}"),
            _fila("Alertas críticas", "${estadisticas.alertasCriticas}"),

            const SizedBox(height: 20),

            SensorStatusCard(
              titulo: "Humedad promedio",
              valor: "${estadisticas.humedadPromedio.toStringAsFixed(1)} %",
              icono: Icons.water_drop,
            ),

            const SizedBox(height: 12),

            SensorStatusCard(
              titulo: "Temperatura promedio",
              valor:
                  "${estadisticas.temperaturaPromedio.toStringAsFixed(1)} °C",
              icono: Icons.thermostat,
            ),
          ],
        ),
      ),
    );
  }

  Widget _fila(String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(titulo),
          Text(
            valor,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
