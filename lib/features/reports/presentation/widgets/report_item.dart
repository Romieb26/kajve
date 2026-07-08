import 'package:flutter/material.dart';

import '../../domain/entities/reporte_entity.dart';
import '../providers/report_provider.dart';

class ReportItem extends StatelessWidget {
  final ReporteEntity reporte;
  final ReportProvider provider;

  const ReportItem({
    super.key,
    required this.reporte,
    required this.provider,
  });

  /// El backend solo llena url_archivo una vez que el archivo existe,
  /// así que su presencia es la señal real de "listo".
  bool get _listo => reporte.urlArchivo != null && reporte.urlArchivo!.isNotEmpty;

  IconData get _formatoIcon =>
      reporte.formato.toLowerCase() == 'excel' ? Icons.table_chart : Icons.picture_as_pdf;

  String _formatearFecha(String iso) {
    final fecha = DateTime.tryParse(iso);
    if (fecha == null) return iso;

    final dia = fecha.day.toString().padLeft(2, '0');
    final mes = fecha.month.toString().padLeft(2, '0');
    return "$dia/$mes/${fecha.year}";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final descargando = provider.idDescargando == reporte.id;

    return Card(

      margin: const EdgeInsets.only(bottom: 12),

      child: ListTile(

        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primary.withValues(alpha: .15),
          child: Icon(_formatoIcon, color: theme.colorScheme.primary),
        ),

        title: Text(reporte.tipoReporte, style: theme.textTheme.titleSmall),

        subtitle: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Text(
              "Formato: ${reporte.formato.toUpperCase()}",
              style: theme.textTheme.bodySmall,
            ),

            Text(
              "Fecha: ${_formatearFecha(reporte.fechaGeneracion)}",
              style: theme.textTheme.bodySmall,
            ),

          ],
        ),

        trailing: !_listo
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: theme.textTheme.bodySmall?.color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text("Generando...", style: theme.textTheme.bodySmall),
                ],
              )
            : descargando
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : IconButton(
                    icon: Icon(Icons.download, color: theme.colorScheme.primary),
                    tooltip: "Descargar",
                    onPressed: () => provider.descargarReporte(context, reporte),
                  ),

      ),

    );
  }
}
