import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:intl/intl.dart';

import '../../../../theme/colors.dart';
import '../../reports/widgets/date_selector.dart';
import '../controllers/statistics_controller.dart';

class StatisticsView extends GetView<StatisticsController> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.onPrincipalBackground,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_left_outlined,
              color: AppColors.principalWhite),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Estadísticas',
          style: TextStyle(color: AppColors.principalWhite),
        ),
      ),
      backgroundColor: AppColors.onPrincipalBackground,
      body: Obx(
        () => controller.isLoading.value
            ? const Center(
                child:
                    CircularProgressIndicator(color: AppColors.principalWhite))
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    DateSelector(
                      label: 'Fecha de inicio',
                      selectedDate: controller.startDate.value,
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          controller.startDate.value =
                              DateTime(picked.year, picked.month, picked.day);
                          if (controller.endDate.value != null) {
                            controller.updateStatistics();
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    DateSelector(
                      label: 'Fecha de fin',
                      selectedDate: controller.endDate.value,
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          controller.endDate.value = DateTime(picked.year,
                              picked.month, picked.day, 23, 59, 59, 999);
                          if (controller.startDate.value != null) {
                            controller.updateStatistics();
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Productos más vendidos',
                      style: textTheme.displaySmall?.copyWith(
                        fontSize: 16,
                        color: AppColors.principalWhite,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (controller.topSoldProducts.isNotEmpty) ...[
                      Container(
                        height: 250,
                        child: PieChart(
                          PieChartData(
                            sections: controller.topSoldProducts
                                .asMap()
                                .entries
                                .map((entry) {
                              final index = entry.key;
                              final product = entry.value;
                              return PieChartSectionData(
                                value: product['total_sold'].toDouble(),
                                title:
                                    '${product['name']}\n${product['total_sold']}',
                                color: colors[index % colors.length],
                                radius: 80,
                                titleStyle: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.principalWhite,
                                ),
                              );
                            }).toList(),
                            sectionsSpace: 4,
                            centerSpaceRadius: 50,
                            pieTouchData: PieTouchData(
                              touchCallback:
                                  (FlTouchEvent event, pieTouchResponse) {
                                if (event is FlTapUpEvent &&
                                    pieTouchResponse != null) {
                                  final sectionIndex = pieTouchResponse
                                      .touchedSection?.touchedSectionIndex;
                                  if (sectionIndex != null &&
                                      sectionIndex >= 0) {
                                    final product = controller
                                        .topSoldProducts[sectionIndex];
                                    Get.snackbar(
                                      'Producto',
                                      '${product['name']}: ${product['total_sold']} vendidos',
                                      backgroundColor: AppColors.principalGreen,
                                      colorText: AppColors.principalWhite,
                                    );
                                  }
                                }
                              },
                            ),
                          ),
                          swapAnimationDuration:
                              const Duration(milliseconds: 500),
                          swapAnimationCurve: Curves.easeInOut,
                        ),
                      ),
                    ] else ...[
                      const Text(
                        'No hay datos disponibles',
                        style: TextStyle(color: AppColors.principalWhite),
                      ),
                    ],
                    const SizedBox(height: 32),
                    Text(
                      'Productos cerca del stock mínimo',
                      style: textTheme.displaySmall?.copyWith(
                        fontSize: 16,
                        color: AppColors.principalWhite,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (controller.nearMinStockProducts.isNotEmpty) ...[
                      Container(
                        height: 250,
                        child: PieChart(
                          PieChartData(
                            sections: controller.nearMinStockProducts
                                .asMap()
                                .entries
                                .map((entry) {
                              final index = entry.key;
                              final product = entry.value;
                              return PieChartSectionData(
                                value: product['serialsQty'].toDouble(),
                                title:
                                    '${product['name']}\n${product['serialsQty']}',
                                color: colors[index % colors.length],
                                radius: 80,
                                titleStyle: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.principalWhite,
                                ),
                              );
                            }).toList(),
                            sectionsSpace: 4,
                            centerSpaceRadius: 50,
                            pieTouchData: PieTouchData(
                              touchCallback:
                                  (FlTouchEvent event, pieTouchResponse) {
                                if (event is FlTapUpEvent &&
                                    pieTouchResponse != null) {
                                  final sectionIndex = pieTouchResponse
                                      .touchedSection?.touchedSectionIndex;
                                  if (sectionIndex != null &&
                                      sectionIndex >= 0) {
                                    final product = controller
                                        .nearMinStockProducts[sectionIndex];
                                    Get.snackbar(
                                      'Producto',
                                      '${product['name']}: ${product['serialsQty']} en stock',
                                      backgroundColor: AppColors.invalid,
                                      colorText: AppColors.principalWhite,
                                    );
                                  }
                                }
                              },
                            ),
                          ),
                          swapAnimationDuration:
                              const Duration(milliseconds: 500),
                          swapAnimationCurve: Curves.easeInOut,
                        ),
                      ),
                    ] else ...[
                      const Text(
                        'No hay datos disponibles',
                        style: TextStyle(color: AppColors.principalWhite),
                      ),
                    ],
                    const SizedBox(height: 32),
                    Text(
                      'Ventas por fecha',
                      style: textTheme.displaySmall?.copyWith(
                        fontSize: 16,
                        color: AppColors.principalWhite,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (controller.salesByDate.isNotEmpty) ...[
                      Container(
                        height: 300,
                        child: LineChart(
                          LineChartData(
                            lineBarsData: [
                              LineChartBarData(
                                spots: controller.salesByDate
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                  final index = entry.key;
                                  final sale = entry.value;
                                  return FlSpot(index.toDouble(),
                                      sale['total_sales']?.toDouble() ?? 0.0);
                                }).toList(),
                                isCurved: true,
                                color: AppColors.principalGreen,
                                barWidth: 4,
                                belowBarData: BarAreaData(
                                  show: true,
                                  color:
                                      AppColors.principalGreen.withOpacity(0.3),
                                ),
                              ),
                            ],
                            titlesData: FlTitlesData(
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 40,
                                  getTitlesWidget: (value, meta) {
                                    final index = value.toInt();
                                    if (index >= 0 &&
                                        index < controller.salesByDate.length) {
                                      final saleDate =
                                          controller.salesByDate[index]
                                              ['sale_date'] as String?;
                                      if (saleDate != null) {
                                        final date = DateTime.parse(saleDate);
                                        return Text(
                                          DateFormat('dd/MM').format(date),
                                          style: const TextStyle(
                                              color: AppColors.principalWhite,
                                              fontSize: 12),
                                        );
                                      }
                                    }
                                    return const Text('');
                                  },
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 40,
                                  getTitlesWidget: (value, meta) => Text(
                                    value.toInt().toString(),
                                    style: const TextStyle(
                                        color: AppColors.principalWhite,
                                        fontSize: 12),
                                  ),
                                ),
                              ),
                              topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                            ),
                            gridData:
                                FlGridData(show: true, drawVerticalLine: false),
                            borderData: FlBorderData(show: false),
                            lineTouchData: LineTouchData(
                              touchTooltipData: LineTouchTooltipData(
                                getTooltipItems: (touchedSpots) {
                                  return touchedSpots.map((spot) {
                                    final sale =
                                        controller.salesByDate[spot.x.toInt()];
                                    final saleDate =
                                        sale['sale_date'] as String?;
                                    if (saleDate != null) {
                                      final date = DateTime.parse(saleDate);
                                      return LineTooltipItem(
                                        '${DateFormat('dd/MM/yyyy').format(date)}\n\$${sale['total_sales'] ?? 0}',
                                        const TextStyle(
                                            color: AppColors.principalWhite),
                                      );
                                    }
                                    return const LineTooltipItem(
                                        'Dato inválido',
                                        TextStyle(
                                            color: AppColors.principalWhite));
                                  }).toList();
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ] else ...[
                      const Text(
                        'No hay datos disponibles',
                        style: TextStyle(color: AppColors.principalWhite),
                      ),
                    ],
                  ],
                ),
              ),
      ),
    );
  }

  final List<Color> colors = [
    AppColors.principalGreen,
    Colors.red,
    Colors.blue,
    Colors.yellow,
    Colors.purple,
  ];
}
