//libs/features/realtime/presentation/widgets/chart_card.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/lectura_tiempo_real_entity.dart';
import 'variable_config.dart';

/// Una gráfica de línea por cada variable del ESP32 (temperatura,
/// temperatura y humedad del grano, presión, altitud, luz y lluvia),
/// alimentadas por la serie en vivo del WebSocket de ws-gateway.
/// Se usa una gráfica por variable (en vez de una sola combinada) porque
/// mezclar escalas tan distintas (°C, hPa, lux, valores crudos 0-4095,
/// etc.) en un solo eje Y sería ilegible.
class ChartCard extends StatelessWidget {
  final List<LecturaTiempoRealEntity> lecturas;

  const ChartCard({
    super.key,
    required this.lecturas,
  });

  @override
  Widget build(BuildContext context) {
    if (lecturas.isEmpty) {
      return const _MensajeVacio(mensaje: "Sin lecturas en tiempo real aún");
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final variable in variablesEsp32) ...[
          _VariableChart(lecturas: lecturas, variable: variable),
          const SizedBox(height: 20),
        ],
      ],
    );
  }
}

class _VariableChart extends StatelessWidget {
  final List<LecturaTiempoRealEntity> lecturas;
  final VariableConfig variable;

  const _VariableChart({
    required this.lecturas,
    required this.variable,
  });

  @override
  Widget build(BuildContext context) {
    final spots = <FlSpot>[];
    for (var i = 0; i < lecturas.length; i++) {
      final valor = variable.valor(lecturas[i]);
      if (valor != null) {
        spots.add(FlSpot(i.toDouble(), valor));
      }
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(variable.icono, color: variable.color),
                const SizedBox(width: 10),
                Text(
                  variable.titulo,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            if (spots.length < 2)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Center(
                  child: Column(
                    children: [
                      const Text(
                        "Esperando más lecturas para graficar...",
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      // Ayuda a distinguir "no ha llegado nada todavía" de
                      // "ya llegó 1 lectura, falta al menos una más" — una
                      // sola lectura no alcanza para trazar una línea.
                      Text(
                        spots.isEmpty
                            ? "0 lecturas recibidas de esta variable"
                            : "1 lectura recibida (${variable.formatear(spots.first.y)}) — esperando la siguiente",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              SizedBox(
                height: 160,
                child: LineChart(
                  LineChartData(
                    // Sin minY/maxY explícitos, fl_chart calcula el rango
                    // a partir de los propios valores. Cuando una variable
                    // se mantiene igual (ej. "Luz" en 0 de noche, o
                    // cualquier lectura constante) ese rango colapsa a
                    // minY == maxY, y sin alto que recorrer la línea no se
                    // ve (o queda pegada al borde). Se agrega un margen
                    // mínimo para que siempre haya un eje Y dibujable.
                    minY: _minY(spots),
                    maxY: _maxY(spots),
                    gridData: const FlGridData(
                      show: true,
                      drawVerticalLine: false,
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(
                        color: Colors.grey.withValues(alpha: 0.3),
                      ),
                    ),
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) => Text(
                            value.toStringAsFixed(0),
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        color: variable.color,
                        barWidth: 3,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: variable.color.withValues(alpha: 0.15),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 8),

            Text(
              spots.isEmpty
                  ? "--"
                  : "Último: ${variable.formatear(spots.last.y)}",
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  double _minY(List<FlSpot> spots) {
    final valorMin = spots.map((s) => s.y).reduce((a, b) => a < b ? a : b);
    final valorMax = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    if (valorMin == valorMax) return valorMin - _margenPlano(valorMin);
    return valorMin - (valorMax - valorMin) * 0.15;
  }

  double _maxY(List<FlSpot> spots) {
    final valorMin = spots.map((s) => s.y).reduce((a, b) => a < b ? a : b);
    final valorMax = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    if (valorMin == valorMax) return valorMax + _margenPlano(valorMax);
    return valorMax + (valorMax - valorMin) * 0.15;
  }

  // Cuando todas las lecturas son iguales, se usa un margen proporcional
  // al valor (10%) con un mínimo de 1, para que el eje Y nunca colapse a
  // un solo punto (minY == maxY revienta el layout del LineChart).
  double _margenPlano(double valor) {
    final margen = valor.abs() * 0.1;
    return margen < 1 ? 1 : margen;
  }
}

class _MensajeVacio extends StatelessWidget {
  final String mensaje;

  const _MensajeVacio({required this.mensaje});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Text(mensaje, style: const TextStyle(color: Colors.grey)),
        ),
      ),
    );
  }
}
