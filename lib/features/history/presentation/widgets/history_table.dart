import 'package:flutter/material.dart';

import '../providers/history_provider.dart';

class HistoryTable extends StatelessWidget {
  final HistoryProvider provider;

  const HistoryTable({
    super.key,
    required this.provider,
  });

  Color _estadoColor(String estado) {
    switch (estado) {
      case "Óptimo":
        return Colors.green.shade100;

      case "Bueno":
        return Colors.blue.shade100;

      case "Alerta":
        return Colors.orange.shade100;

      default:
        return Colors.grey.shade200;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,

      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,

        child: DataTable(
          columns: const [

            DataColumn(
              label: Text(
                "Lote",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            DataColumn(
              label: Text(
                "Fecha",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            DataColumn(
              label: Text(
                "Temperatura",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            DataColumn(
              label: Text(
                "Humedad",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            DataColumn(
              label: Text(
                "Estado",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],

          rows: provider.historial.map((item) {
            return DataRow(
              cells: [

                DataCell(Text(item.lote)),

                DataCell(Text(item.fecha)),

                DataCell(Text("${item.temperatura} °C")),

                DataCell(Text("${item.humedad} %")),

                DataCell(
                  Chip(
                    label: Text(item.estado),
                    backgroundColor: _estadoColor(item.estado),
                  ),
                ),

              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}