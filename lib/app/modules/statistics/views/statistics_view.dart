import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../../../../theme/colors.dart';
import '../controllers/statistics_controller.dart';

class StatisticsView extends GetView<StatisticsController> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.onPrincipalBackground,
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left_outlined,
              color: AppColors.principalWhite),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Estadísticas',
          style: TextStyle(color: AppColors.principalWhite),
        ),
      ),
      backgroundColor: AppColors.onPrincipalBackground,
      body: Obx(
        () => controller.isLoading.value
            ? Center(
                child:
                    CircularProgressIndicator(color: AppColors.principalWhite))
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Productos más vendidos',
                      style: textTheme.displaySmall?.copyWith(
                        fontSize: 16,
                        color: AppColors.principalWhite,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    if (controller.topSoldProducts.isNotEmpty) ...[
                      Container(
                        height: 200,
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            barGroups: controller.topSoldProducts
                                .asMap()
                                .entries
                                .map((entry) => BarChartGroupData(
                                      x: entry.key,
                                      barRods: [
                                        BarChartRodData(
                                          toY: entry.value['total_sold']
                                              .toDouble(),
                                          color: AppColors.principalGreen,
                                          width: 16,
                                        ),
                                      ],
                                    ))
                                .toList(),
                            titlesData: FlTitlesData(
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) => Text(
                                    controller.topSoldProducts[value.toInt()]
                                        ['name'],
                                    style: TextStyle(
                                        color: AppColors.principalWhite,
                                        fontSize: 10),
                                  ),
                                ),
                              ),
                              leftTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: true)),
                            ),
                          ),
                        ),
                      ),
                    ] else ...[
                      Text(
                        'No hay datos disponibles',
                        style: TextStyle(color: AppColors.principalWhite),
                      ),
                    ],
                    SizedBox(height: 32),
                    Text(
                      'Productos cerca del stock mínimo',
                      style: textTheme.displaySmall?.copyWith(
                        fontSize: 16,
                        color: AppColors.principalWhite,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    if (controller.nearMinStockProducts.isNotEmpty) ...[
                      Container(
                        height: 200,
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            barGroups: controller.nearMinStockProducts
                                .asMap()
                                .entries
                                .map((entry) => BarChartGroupData(
                                      x: entry.key,
                                      barRods: [
                                        BarChartRodData(
                                          toY: entry.value['serialsQty']
                                              .toDouble(),
                                          color: AppColors.invalid,
                                          width: 16,
                                        ),
                                      ],
                                    ))
                                .toList(),
                            titlesData: FlTitlesData(
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) => Text(
                                    controller
                                            .nearMinStockProducts[value.toInt()]
                                        ['name'],
                                    style: TextStyle(
                                        color: AppColors.principalWhite,
                                        fontSize: 10),
                                  ),
                                ),
                              ),
                              leftTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: true)),
                            ),
                          ),
                        ),
                      ),
                    ] else ...[
                      Text(
                        'No hay datos disponibles',
                        style: TextStyle(color: AppColors.principalWhite),
                      ),
                    ],
                    // SizedBox(height: 32),
                    // Text(
                    //   'Ventas por fecha',
                    //   style: textTheme.displaySmall?.copyWith(
                    //     fontSize: 16,
                    //     color: AppColors.principalWhite,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    // SizedBox(height: 16),
                    // if (controller.salesByDate.isNotEmpty) ...[
                    //   Container(
                    //     height: 200,
                    //     child: LineChart(
                    //       LineChartData(
                    //         lineBarsData: [
                    //           LineChartBarData(
                    //             spots: controller.salesByDate
                    //                 .asMap()
                    //                 .entries
                    //                 .map((entry) => FlSpot(
                    //                       entry.key.toDouble(),
                    //                       entry.value['total_sales'].toDouble(),
                    //                     ))
                    //                 .toList(),
                    //             isCurved: true,
                    //             color: AppColors.principalGreen,
                    //             dotData: FlDotData(show: false),
                    //           ),
                    //         ],
                    //         titlesData: FlTitlesData(
                    //           bottomTitles: AxisTitles(
                    //             sideTitles: SideTitles(
                    //               showTitles: true,
                    //               getTitlesWidget: (value, meta) => Text(
                    //                 controller.salesByDate[value.toInt()]
                    //                         ['sale_date']
                    //                     .substring(5),
                    //                 style: TextStyle(
                    //                     color: AppColors.principalWhite,
                    //                     fontSize: 10),
                    //               ),
                    //             ),
                    //           ),
                    //           leftTitles: AxisTitles(
                    //               sideTitles: SideTitles(
                    //             showTitles: true,
                    //           ),),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ] else ...[
                    //   Text(
                    //     'No hay datos disponibles',
                    //     style: TextStyle(color: AppColors.principalWhite),
                    //   ),
                    // ],
                  ],
                ),
              ),
      ),
    );
  }
}
