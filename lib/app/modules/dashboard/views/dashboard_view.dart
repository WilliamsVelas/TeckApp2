import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:teck_app/app/modules/dashboard/controllers/dashboard_controller.dart';

import '../../../../theme/colors.dart';
import '../../home/views/home_view.dart';
import '../../invoices/widgets/invoice_card.dart';
import '../../products/views/product_card.dart';

class DashboardView extends StatelessWidget {
  final DashboardController controller = Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.onPrincipalBackground,
      body: RefreshIndicator(
        onRefresh: () async {
          controller.fetchAll();
        },
        color: AppColors.principalGreen,
        backgroundColor: AppColors.onPrincipalBackground,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Obx(
                            () => SizedBox(
                          width: 150,
                          child: Card(
                            color: AppColors.principalBackground,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Ventas',
                                    style: TextStyle(color: AppColors.principalWhite, fontSize: 16),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    '${controller.totalSales.value}',
                                    style: TextStyle(
                                      color: AppColors.principalGreen,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Obx(
                            () => SizedBox(
                          width: 150,
                          child: Card(
                            color: AppColors.principalBackground,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Por cobrar',
                                    style: TextStyle(color: AppColors.principalWhite, fontSize: 16),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    '${controller.totalSalesNonPayment.value}',
                                    style: TextStyle(
                                      color: AppColors.invalid,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Obx(
                            () => SizedBox(
                          width: 150,
                          child: Card(
                            color: AppColors.principalBackground,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Vendido',
                                    style: TextStyle(color: AppColors.principalWhite, fontSize: 16),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    '\$${controller.totalPayed.value}',
                                    style: TextStyle(
                                      color: AppColors.principalGreen,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: const BoxDecoration(
                  color: AppColors.principalBackground,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(32.0),
                    bottom: Radius.circular(32.0),
                  ),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Últimos Productos',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: AppColors.principalWhite,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Obx(
                          () => Text(
                        '${controller.products.length} productos',
                        style: TextStyle(fontSize: 12.0, color: AppColors.principalGray),
                      ),
                    ),
                    SizedBox(
                      height: 200,
                      child: Obx(() {
                        final products = controller.products;
                        if (products.isEmpty) {
                          return const Center(
                            child: Text(
                              'No hay productos disponibles.',
                              style: TextStyle(fontSize: 16.0, color: AppColors.principalGray),
                            ),
                          );
                        }
                        return ListView.builder(
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 1.0),
                              child: ProductCard(product: product),
                            );
                          },
                        );
                      }),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: const BoxDecoration(
                  color: AppColors.principalBackground,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(32.0),
                    bottom: Radius.circular(32.0),
                  ),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Últimas Ventas',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: AppColors.principalWhite,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Obx(
                          () => Text(
                        '${controller.invoices.length} ventas',
                        style: TextStyle(fontSize: 12.0, color: AppColors.principalGray),
                      ),
                    ),
                    SizedBox(
                      height: 200,
                      child: Obx(() {
                        final invoices = controller.invoices;
                        if (invoices.isEmpty) {
                          return const Center(
                            child: Text(
                              'No hay ventas disponibles.',
                              style: TextStyle(fontSize: 16.0, color: AppColors.principalGray),
                            ),
                          );
                        }
                        return ListView.builder(
                          itemCount: invoices.length,
                          itemBuilder: (context, index) {
                            final invoice = invoices[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 1.0),
                              child: InvoiceCard(invoice: invoice),
                            );
                          },
                        );
                      }),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
