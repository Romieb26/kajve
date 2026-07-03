import 'package:flutter/material.dart';

import '../providers/report_provider.dart';
import '../widgets/report_item.dart';

class ReportHistory extends StatelessWidget {
  final ReportProvider provider;

  const ReportHistory({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Reportes generados",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: provider.reportes.length,
          itemBuilder: (context, index) {
            return ReportItem(
              reporte: provider.reportes[index],
            );
          },
        ),
      ],
    );
  }
}