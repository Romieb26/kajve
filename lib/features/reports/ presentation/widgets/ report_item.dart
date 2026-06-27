import 'package:flutter/material.dart';

import '../providers/ report_provider.dart';

class ReportItem extends StatelessWidget {
  final ReportModel reporte;

  const ReportItem({
    super.key,
    required this.reporte,
  });

  @override
  Widget build(BuildContext context) {

    return Card(

      margin: const EdgeInsets.only(bottom: 12),

      child: ListTile(

        leading: const CircleAvatar(
          child: Icon(Icons.picture_as_pdf),
        ),

        title: Text(reporte.nombre),

        subtitle: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Text("Tipo: ${reporte.tipo}"),

            Text("Fecha: ${reporte.fecha}"),

          ],
        ),

        trailing: PopupMenuButton(

          itemBuilder: (_) => [

            const PopupMenuItem(
              value: 1,
              child: Text("Descargar"),
            ),

            const PopupMenuItem(
              value: 2,
              child: Text("Compartir"),
            ),

          ],

          onSelected: (value) {

            ScaffoldMessenger.of(context).showSnackBar(

              SnackBar(
                content: Text(
                  value == 1
                      ? "Descargando..."
                      : "Compartiendo...",
                ),
              ),

            );

          },

        ),

      ),

    );
  }
}