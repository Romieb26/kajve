//libs/features/realtime/presentation/widgets/sensor_grid.dart
import 'package:flutter/material.dart';

import '../../domain/entities/lectura_tiempo_real_entity.dart';
import 'sensor_card.dart';
import 'variable_config.dart';

class SensorGrid extends StatelessWidget {
  final LecturaTiempoRealEntity? ultimaLectura;

  const SensorGrid({
    super.key,
    required this.ultimaLectura,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        // Alto fijo en vez de childAspectRatio: el contenido de SensorCard
        // (avatar + 2 líneas de texto) mide prácticamente lo mismo sin
        // importar el ancho de pantalla, así que un aspect ratio (que
        // depende del ancho) provocaba RenderFlex overflow en pantallas
        // más angostas o con texto de sistema más grande. mainAxisExtent
        // fija el alto directamente y evita ese problema.
        mainAxisExtent: 140,
      ),
      itemCount: variablesEsp32.length,
      itemBuilder: (context, index) {
        final variable = variablesEsp32[index];
        return SensorCard(
          titulo: variable.titulo,
          valor: _formatear(variable),
          icono: variable.icono,
        );
      },
    );
  }

  String _formatear(VariableConfig variable) {
    final lectura = ultimaLectura;
    if (lectura == null) return "--";

    final valor = variable.valor(lectura);
    if (valor == null) return "--";

    return variable.formatear(valor);
  }
}
