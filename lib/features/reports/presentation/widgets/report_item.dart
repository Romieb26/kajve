import 'package:flutter/material.dart';

import '../../data/models/report_model.dart';
import '../../../../core/services/pdf_service.dart';
import '../../../../core/services/excel_service.dart';

class ReportItem extends StatelessWidget {
  final ReportModel reporte;

  const ReportItem({
    super.key,
    required this.reporte,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(

      margin: const EdgeInsets.only(bottom: 12),

      child: ListTile(

        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primary.withValues(alpha: .15),
          child: Icon(Icons.picture_as_pdf, color: theme.colorScheme.primary),
        ),

        title: Text(reporte.nombre, style: theme.textTheme.titleSmall),

        subtitle: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Text("Tipo: ${reporte.tipo}", style: theme.textTheme.bodySmall),

            Text("Fecha: ${reporte.fecha}", style: theme.textTheme.bodySmall),

          ],
        ),

        trailing: PopupMenuButton(

          itemBuilder: (_) => [

            const PopupMenuItem(
              value: 1,
              child: Text("Descargar PDF"),
            ),

            const PopupMenuItem(
              value: 2,
              child: Text("Exportar Excel"),
            ),

          ],

          onSelected: (value) async {

            if (value == 1) {
              await PdfService.generarReportePdf(reporte);
            } else if (value == 2) {
              await ExcelService.exportarReportes([reporte]);
            }

          },

        ),

      ),

    );
  }
}