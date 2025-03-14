import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../theme/colors.dart';
import '../../../common/custom_snakcbar.dart';
import '../../../database/database_helper.dart';
import '../../../database/models/reports.dart';
import '../../../database/models/user_model.dart';

class ReportController extends GetxController {
  final dbHelper = DatabaseHelper();

  final Rx<UserApp?> userLogged = Rx<UserApp?>(null);

  Future<List<SalesReport>> fetchSalesReport(int startDate, int endDate) async {
    final data = await dbHelper.getSalesReport(startDate, endDate);

    final List<UserApp> users = await dbHelper.getUsers();
    final user = users.isNotEmpty ? users.first : null;

    userLogged.value = user;

    print("data = $data");
    return data.map((row) {
      return SalesReport(
        documentNo: row['documentNo'] as String,
        invoiceDate: row['invoiceDate'] as int,
        productName: row['productName'] as String,
        productPrice: row['productPrice'] as double,
        qty: row['qty'] as int,
        productSerial: row['productSerial'] as String? ?? 'N/A',
        lineTotal: row['lineTotal'] as double,
      );
    }).toList();
  }

  Future<void> generateSalesReportPdf2(List<SalesReport> salesReports) async {
    try {
      final pdf = pw.Document();
      final headerColor = PdfColor.fromInt(AppColors.header.value);
      final totalRowColor = PdfColor.fromInt(AppColors.subHeader.value);

      final totalGeneral = salesReports.fold(
          0.0, (sum, report) => sum + (report.lineTotal ?? 0));

      final emissionDate = DateTime.now();
      final formattedEmissionDate =
          DateFormat('dd/MM/yyyy HH:mm').format(emissionDate);

      final userFullName = userLogged != null && userLogged.value != null
          ? '${userLogged.value!.name} ${userLogged.value!.lastName}'
          : 'Usuario Desconocido';

      pw.Widget buildHeader() {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(
                      'Fecha de Emisión: $formattedEmissionDate',
                      style: pw.TextStyle(fontSize: 12),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'Usuario: ',
                      style: pw.TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 16),
            pw.Center(
              child: pw.Text(
                'Reporte de Ventas',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 16),
          ],
        );
      }

      pw.TableRow buildTotalRow() {
        return pw.TableRow(
          decoration: pw.BoxDecoration(color: totalRowColor),
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text('Total General',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ),
            pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text('')),
            pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text('')),
            pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text('')),
            pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text('')),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(totalGeneral.toStringAsFixed(2),
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ),
          ],
        );
      }

      const int rowsPerPage = 20;
      final List<List<SalesReport>> chunks = [];
      for (var i = 0; i < salesReports.length; i += rowsPerPage) {
        chunks.add(salesReports.sublist(
            i,
            i + rowsPerPage > salesReports.length
                ? salesReports.length
                : i + rowsPerPage));
      }

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4.landscape,
          header: (context) => buildHeader(),
          footer: (context) => pw.Align(
            alignment: pw.Alignment.center,
            child: pw.Text(
              'Página ${context.pageNumber} de ${context.pagesCount}',
              style: pw.TextStyle(fontSize: 10),
            ),
          ),
          build: (pw.Context context) {
            if (salesReports.isEmpty) {
              return [
                pw.Text(
                  'No hay datos para mostrar',
                  style: pw.TextStyle(fontSize: 12),
                ),
              ];
            }

            final currentChunk = chunks[context.pageNumber - 1];
            return [
              pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: pw.FlexColumnWidth(3), // Producto
                  1: pw.FlexColumnWidth(1.5), // Fecha Venta
                  2: pw.FlexColumnWidth(1), // Precio
                  3: pw.FlexColumnWidth(0.8), // Cantidad
                  4: pw.FlexColumnWidth(2.5), // Serial
                  5: pw.FlexColumnWidth(1.5), // Total Línea
                },
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
                        child: pw.Text('Fecha Venta',
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
                  ...currentChunk.map(
                    (report) {
                      final formattedDate = report.invoiceDate != null
                          ? DateFormat('dd/MM/yyyy').format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  report.invoiceDate!),
                            )
                          : 'Fecha no disponible';

                      final serial = report.productSerial?.isNotEmpty == true
                          ? report.productSerial
                          : 'N/A';

                      return pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(report.productName ?? 'N/A',
                                style: pw.TextStyle()),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child:
                                pw.Text(formattedDate, style: pw.TextStyle()),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(
                                (report.productPrice ?? 0).toStringAsFixed(2),
                                style: pw.TextStyle()),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text((report.qty ?? 0).toString(),
                                style: pw.TextStyle()),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(serial, style: pw.TextStyle()),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(
                                (report.lineTotal ?? 0).toStringAsFixed(2),
                                style: pw.TextStyle()),
                          ),
                        ],
                      );
                    },
                  ),
                  if (context.pageNumber == chunks.length) buildTotalRow(),
                ],
              ),
            ];
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
    } catch (e) {
      print(e);
      CustomSnackbar.show(
        title: "¡Ocurrió un error!",
        message: "PDF no generado.",
        icon: Icons.close,
        backgroundColor: AppColors.invalid,
      );
    }
  }

  Future<void> generateSalesReportPdf(List<SalesReport> salesReports) async {
    final pdf = pw.Document();
    final headerColor = PdfColor.fromInt(AppColors.header.value);
    final totalRowColor = PdfColor.fromInt(AppColors.subHeader.value);

    final totalGeneral =
        salesReports.fold(0.0, (sum, report) => sum + report.lineTotal);

    final emissionDate = DateTime.now();
    final formattedEmissionDate =
        DateFormat('dd/MM/yyyy HH:mm').format(emissionDate);

    final List<UserApp> users = await dbHelper.getUsers();
    final user = users.isNotEmpty ? users.first : null;
    final userFullName =
        user != null ? '${user.name} ${user.lastName}' : 'Usuario Desconocido';

    final font = await PdfGoogleFonts.nunitoRegular();

    final ByteData data = await rootBundle.load('assets/images/tecposlogo.png');
    final Uint8List bytes = data.buffer.asUint8List();
    final pw.MemoryImage logo = pw.MemoryImage(bytes);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: pw.EdgeInsets.all(20),
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        build: (pw.Context context) => [
          pw.Header(
            level: 0,
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Row(
                  children: [
                    pw.Container(
                      width: 80,
                      height: 80,
                      child: pw.Image(logo),
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'TecPos Venezuela',
                          style: pw.TextStyle(
                            font: font,
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text('RIF: V-9657187-1',
                            style: pw.TextStyle(font: font, fontSize: 12)),
                        pw.SizedBox(height: 4),
                        pw.Text('Dirección: Caracas, Venezuela',
                            style: pw.TextStyle(font: font, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text('Fecha de Emisión: $formattedEmissionDate',
                        style: pw.TextStyle(font: font, fontSize: 12)),
                    pw.SizedBox(height: 4),
                    pw.Text('Usuario: $userFullName',
                        style: pw.TextStyle(font: font, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Center(
            child: pw.Text(
              'Reporte de Ventas',
              style: pw.TextStyle(
                font: font,
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.SizedBox(height: 10),
          if (salesReports.isEmpty)
            pw.Text(
              'No hay datos para mostrar',
              style: pw.TextStyle(font: font, fontSize: 12),
            )
          else
            pw.TableHelper.fromTextArray(
              border: pw.TableBorder.all(),
              headers: [
                'Producto',
                'Fecha Venta',
                'Precio (USD)',
                'Cantidad',
                'Serial',
                'Total Línea (USD)'
              ],
              data: salesReports.map((report) {
                final formattedDate = DateFormat('dd/MM/yyyy').format(
                  DateTime.fromMillisecondsSinceEpoch(report.invoiceDate),
                );
                return [
                  report.productName,
                  formattedDate,
                  report.productPrice.toStringAsFixed(2),
                  report.qty.toString(),
                  report.productSerial,
                  report.lineTotal.toStringAsFixed(2),
                ];
              }).toList(),
              headerStyle: pw.TextStyle(
                  font: font, fontWeight: pw.FontWeight.bold, fontSize: 12),
              cellStyle: pw.TextStyle(font: font, fontSize: 10),
              headerDecoration: pw.BoxDecoration(
                color: headerColor,
              ),
              columnWidths: {
                0: pw.FlexColumnWidth(2),
                1: pw.FlexColumnWidth(1.5),
                2: pw.FlexColumnWidth(1),
                3: pw.FlexColumnWidth(1),
                4: pw.FlexColumnWidth(1.5),
                5: pw.FlexColumnWidth(1.5),
              },
            ),
          pw.Container(
            color: totalRowColor,
            padding: const pw.EdgeInsets.all(8),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Total General',
                    style: pw.TextStyle(
                        font: font, fontWeight: pw.FontWeight.bold)),
                pw.Text(totalGeneral.toStringAsFixed(2),
                    style: pw.TextStyle(
                        font: font, fontWeight: pw.FontWeight.bold)),
              ],
            ),
          ),
        ],
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
