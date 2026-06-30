import 'dart:io';

import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../features/reports/data/models/report_model.dart';

class ExcelService {
  /// Genera un archivo Excel con el historial de reportes y abre
  /// el diálogo nativo para compartirlo.
  static Future<void> exportarReportes(List<ReportModel> reportes) async {
    final excel = Excel.createExcel();

    // Renombra la hoja por defecto
    final String sheetName = 'Reportes';
    excel.rename(excel.getDefaultSheet()!, sheetName);
    final Sheet sheet = excel[sheetName];

    // Encabezados
    final headers = ['Lote', 'Tipo', 'Fecha'];
    sheet.appendRow(headers.map((h) => TextCellValue(h)).toList());

    // Filas de datos
    for (final reporte in reportes) {
      sheet.appendRow([
        TextCellValue(reporte.nombre),
        TextCellValue(reporte.tipo),
        TextCellValue(reporte.fecha),
      ]);
    }

    // Ancho de columnas
    sheet.setColumnWidth(0, 25);
    sheet.setColumnWidth(1, 20);
    sheet.setColumnWidth(2, 15);

    final bytes = excel.encode();
    if (bytes == null) return;

    final dir = await getTemporaryDirectory();
    final filePath =
        '${dir.path}/reportes_kajve_${DateTime.now().millisecondsSinceEpoch}.xlsx';
    final file = File(filePath);
    await file.writeAsBytes(bytes);

    await Share.shareXFiles(
      [XFile(filePath)],
      text: 'Reportes KAJVE',
    );
  }
}