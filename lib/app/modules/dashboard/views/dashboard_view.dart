import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:teck_app/app/modules/dashboard/controllers/dashboard_controller.dart';

import '../../../../theme/colors.dart';
import '../../home/views/home_view.dart';

class DashboardView extends StatelessWidget {
  final DashboardController controller = Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    final ScreenConfig config = ScreenConfig(
      backgroundColor: AppColors.onPrincipalBackground,
      content: Container(
        width: MediaQuery.of(context).size.width * 1,
        decoration: const BoxDecoration(
          color: AppColors.principalBackground,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(32.0),
            bottom: Radius.circular(32.0),
          ),
        ),
        padding: const EdgeInsets.all(16.0),
      ),
    );

    return GenericScreen(config: config); // Usa GenericScreen
  }
}
