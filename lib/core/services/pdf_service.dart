import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../features/reports/data/models/report_model.dart';

class PdfService {
  /// Genera un PDF a partir de un [ReportModel] del módulo de reportes.
  static Future<void> generarReportePdf(
      ReportModel reporte, {
        String logoAssetPath = 'assets/images/logo.png',
      }) async {
    final pdf = pw.Document();

    pw.ImageProvider? logoImage;
    try {
      final logoBytes = await rootBundle.load(logoAssetPath);
      logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());
    } catch (_) {
      logoImage = null;
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'REPORTE DE ${reporte.tipo.toUpperCase()}',
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  if (logoImage != null)
                    pw.Container(
                      width: 60,
                      height: 60,
                      child: pw.Image(logoImage),
                    ),
                ],
              ),
              pw.SizedBox(height: 8),
              pw.Divider(thickness: 1.5),
              pw.SizedBox(height: 20),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey400),
                columnWidths: const {
                  0: pw.FlexColumnWidth(1.2),
                  1: pw.FlexColumnWidth(2),
                },
                children: [
                  _buildRow('Nombre / Lote', reporte.nombre),
                  _buildRow('Tipo', reporte.tipo),
                  _buildRow('Fecha', reporte.fecha),
                ],
              ),
              pw.SizedBox(height: 30),
              pw.Text(
                'Generado por KAJVE',
                style: pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.grey600,
                ),
              ),
            ],
          );
        },
      ),
    );

    final Uint8List bytes = await pdf.save();

    await Printing.sharePdf(
      bytes: bytes,
      filename: 'reporte_${reporte.nombre.replaceAll(' ', '_')}.pdf',
    );
  }

  /// Genera y abre el diálogo de impresión/compartir con el reporte
  /// de secado para un lote (versión con campos sueltos).
  static Future<void> generarReporteSecado({
    required String lote,
    required String temperatura,
    required String humedad,
    required String estado,
    required String fecha,
    String logoAssetPath = 'assets/images/logo.png',
  }) async {
    final pdf = pw.Document();

    pw.ImageProvider? logoImage;
    try {
      final logoBytes = await rootBundle.load(logoAssetPath);
      logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());
    } catch (_) {
      logoImage = null;
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'REPORTE DE SECADO',
                    style: pw.TextStyle(
                      fontSize: 22,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  if (logoImage != null)
                    pw.Container(
                      width: 60,
                      height: 60,
                      child: pw.Image(logoImage),
                    ),
                ],
              ),
              pw.SizedBox(height: 8),
              pw.Divider(thickness: 1.5),
              pw.SizedBox(height: 20),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey400),
                columnWidths: const {
                  0: pw.FlexColumnWidth(1.2),
                  1: pw.FlexColumnWidth(2),
                },
                children: [
                  _buildRow('Lote', lote),
                  _buildRow('Temperatura', temperatura),
                  _buildRow('Humedad', humedad),
                  _buildRow('Estado', estado),
                  _buildRow('Fecha', fecha),
                ],
              ),
              pw.SizedBox(height: 30),
              pw.Text(
                'Generado por KAJVE',
                style: pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.grey600,
                ),
              ),
            ],
          );
        },
      ),
    );

    final Uint8List bytes = await pdf.save();

    await Printing.sharePdf(
      bytes: bytes,
      filename: 'reporte_secado_${lote.replaceAll(' ', '_')}.pdf',
    );
  }

  static pw.TableRow _buildRow(String label, String value) {
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(
            label,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(value),
        ),
      ],
    );
  }
}