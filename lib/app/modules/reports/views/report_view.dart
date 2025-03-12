import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import '../../../../theme/colors.dart';
import '../../../common/custom_snakcbar.dart';
import '../controllers/report_controller.dart';

class ReportView extends GetView<ReportController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.onPrincipalBackground,
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_arrow_left_outlined,
            color: AppColors.principalWhite,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Reportes',
          style: TextStyle(color: AppColors.principalWhite),
        ),
      ),
      backgroundColor: AppColors.onPrincipalBackground,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildReportItem(
              context,
              reportName: 'Reporte de Ventas',
              onPrintPressed: () => _showDateRangeDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportItem(BuildContext context,
      {required String reportName, required VoidCallback onPrintPressed}) {
    return Card(
      color: AppColors.principalBackground,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              reportName,
              style: TextStyle(
                color: AppColors.principalWhite,
                fontSize: 16,
              ),
            ),
            ElevatedButton(
              onPressed: onPrintPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.principalButton,
              ),
              child: Text(
                'Imprimir',
                style: TextStyle(color: AppColors.onPrincipalBackground),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDateRangeDialog(BuildContext context) {
    DateTime? startDate;
    DateTime? endDate;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Seleccione el rango de fechas'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Fecha de inicio'),
                subtitle: Text(
                  startDate != null
                      ? DateFormat('dd/MM/yyyy').format(startDate!)
                      : 'No seleccionada',
                ),
                trailing: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      startDate = picked;
                      (context as Element).markNeedsBuild();
                    }
                  },
                ),
              ),
              ListTile(
                title: Text('Fecha de fin'),
                subtitle: Text(
                  endDate != null
                      ? DateFormat('dd/MM/yyyy').format(endDate!)
                      : 'No seleccionada',
                ),
                trailing: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      endDate = picked;
                      (context as Element).markNeedsBuild();
                    }
                  },
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (startDate == null || endDate == null) {
                  CustomSnackbar.show(
                    title: "¡Ocurrió un error!",
                    message: "Seleccione un rango de fechas válido.",
                    icon: Icons.cancel,
                    backgroundColor: AppColors.invalid,
                  );
                  return;
                }

                final salesReports = await controller.fetchSalesReport(
                    startDate!.millisecondsSinceEpoch!,
                    endDate!.millisecondsSinceEpoch!);
                if (salesReports.isEmpty) {
                  CustomSnackbar.show(
                    title: "¡Ocurrió un error!",
                    message:
                        "No hay ventas en el rango de fechas seleccionado.",
                    icon: Icons.cancel,
                    backgroundColor: AppColors.invalid,
                  );
                  return;
                }

                Navigator.pop(context);
                await controller.generateSalesReportPdf(salesReports);
              },
              child: Text('Generar PDF'),
            ),
          ],
        );
      },
    );
  }
}
