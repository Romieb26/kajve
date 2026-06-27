import 'package:flutter/material.dart';

import '../providers/ history_provider.dart';

class HistoryTable extends StatelessWidget {
  final HistoryProvider provider;

  const HistoryTable({
    super.key,
    required this.provider,
  });

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
          rows: provider.resultados.map((item) {
            return DataRow(
              cells: [

                DataCell(Text(item.lote)),

                DataCell(Text(item.fecha)),

                DataCell(Text(item.temperatura)),

                DataCell(Text(item.humedad)),

                DataCell(
                  Chip(
                    label: Text(item.estado),
                    backgroundColor: item.estado == "Finalizado"
                        ? Colors.green.shade100
                        : Colors.orange.shade100,
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