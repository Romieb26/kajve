import 'package:flutter/material.dart';

class HistoryFilters extends StatelessWidget {
  const HistoryFilters({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [

            Row(
              children: [

                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "Fecha inicio",
                      prefixIcon: const Icon(Icons.calendar_today),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "Fecha fin",
                      prefixIcon: const Icon(Icons.calendar_today),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

              ],
            ),

            const SizedBox(height: 15),

            Row(
              children: [

                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text("PDF"),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.table_chart),
                    label: const Text("Excel"),
                  ),
                ),

              ],
            )

          ],
        ),
      ),
    );
  }
}