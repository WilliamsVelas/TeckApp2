import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../theme/colors.dart';
import '../../../common/custom_snakcbar.dart';
import '../../../database/database_helper.dart';
import '../../../database/models/reports.dart';

import 'package:path_provider/path_provider.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ReportController extends GetxController {
  final dbHelper = DatabaseHelper();

  Future<List<SalesReport>> fetchSalesReport(int startDate, int endDate) async {
    final data = await dbHelper.getSalesReport(startDate, endDate);

    print("data = ${data}");
    return data.map((row) {
      return SalesReport(
        documentNo: row['documentNo'],
        invoiceDate: row['invoiceDate'],
        productName: row['productName'],
        productPrice: row['productPrice'],
        qty: row['qty'],
        productSerial: row['productSerial'] ?? 'N/A',
        lineTotal: row['lineTotal'],
      );
    }).toList();
  }

  Future<void> generateSalesReportPdf(List<SalesReport> salesReports) async {
    final pdf = pw.Document();

    final headerColor = PdfColor.fromInt(AppColors.header.value);
    final totalRowColor = PdfColor.fromInt(AppColors.subHeader.value);

    final totalGeneral =
        salesReports.fold(0.0, (sum, report) => sum + report.lineTotal);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Header(level: 0, child: pw.Text('Reporte de Ventas')),
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    decoration: pw.BoxDecoration(color: headerColor),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Producto',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Precio (USD)',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Cantidad',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Serial',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Total Línea (USD)',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                    ],
                  ),
                  ...salesReports.map((report) => pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(report.productName),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child:
                                pw.Text(report.productPrice.toStringAsFixed(2)),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(report.qty.toString()),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(report.productSerial),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(report.lineTotal.toStringAsFixed(2)),
                          ),
                        ],
                      )),
                  pw.TableRow(
                    decoration: pw.BoxDecoration(color: totalRowColor),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Total General',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text('')),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text('')),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text('')),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(totalGeneral.toStringAsFixed(2),
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );

    CustomSnackbar.show(
      title: "¡Aprobado!",
      message: "PDF generado correctamente",
      icon: Icons.check_circle,
      backgroundColor: AppColors.principalGreen,
    );
  }

  Future<void> generateAndShareSalesReportPdf(
      List<SalesReport> salesReports) async {
    final pdf = pw.Document();

    final headerColor = PdfColor.fromInt(AppColors.header.value);
    final totalRowColor = PdfColor.fromInt(AppColors.subHeader.value);

    final totalGeneral =
        salesReports.fold(0.0, (sum, report) => sum + report.lineTotal);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Header(level: 0, child: pw.Text('Reporte de Ventas')),
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    decoration: pw.BoxDecoration(color: headerColor),
                    children: [
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text('Producto',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold))),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text('Precio (USD)',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold))),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text('Cantidad',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold))),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text('Serial',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold))),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text('Total Línea (USD)',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold))),
                    ],
                  ),
                  ...salesReports.map((report) => pw.TableRow(
                        children: [
                          pw.Padding(
                              padding: const pw.EdgeInsets.all(8),
                              child: pw.Text(report.productName)),
                          pw.Padding(
                              padding: const pw.EdgeInsets.all(8),
                              child: pw.Text(
                                  report.productPrice.toStringAsFixed(2))),
                          pw.Padding(
                              padding: const pw.EdgeInsets.all(8),
                              child: pw.Text(report.qty.toString())),
                          pw.Padding(
                              padding: const pw.EdgeInsets.all(8),
                              child: pw.Text(report.productSerial)),
                          pw.Padding(
                              padding: const pw.EdgeInsets.all(8),
                              child:
                                  pw.Text(report.lineTotal.toStringAsFixed(2))),
                        ],
                      )),
                  pw.TableRow(
                    decoration: pw.BoxDecoration(color: totalRowColor),
                    children: [
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text('Total General',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold))),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text('')),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text('')),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text('')),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(totalGeneral.toStringAsFixed(2),
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold))),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    try {
      final output = await getTemporaryDirectory();
      final filePath = "${output.path}/Reporte_Ventas.pdf";
      final file = File(filePath);

      await file.writeAsBytes(await pdf.save());

      await Share.shareXFiles([XFile(filePath)],
          text: "Aquí tienes el reporte de ventas en PDF.");

      CustomSnackbar.show(
        title: "¡Compartido!",
        message: "El reporte de ventas se compartió correctamente",
        icon: Icons.check_circle,
        backgroundColor: AppColors.principalGreen,
      );
    } catch (e) {
      CustomSnackbar.show(
        title: "¡Error!",
        message: "No se pudo compartir el reporte",
        icon: Icons.cancel,
        backgroundColor: AppColors.invalid,
      );
      print('Error al compartir PDF: $e');
    }
  }
}
