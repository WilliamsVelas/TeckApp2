import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../theme/colors.dart';
import '../../theme/text.dart';

class CustomSnackbar {
  static void show({
    required String message,
    required String title,
    required IconData icon,
    required Color backgroundColor,
    Color textColor = AppColors.principalWhite,
    Color iconColor = AppColors.principalWhite,
  }) {
    Get.snackbar(
      title,
      '',
      backgroundColor: backgroundColor,
      colorText: textColor,
      snackPosition: SnackPosition.TOP,
      borderRadius: 8,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      duration: const Duration(seconds: 5),
      isDismissible: true,
      shouldIconPulse: false,
      icon: Icon(icon, color: iconColor, size: 18),
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
      // titleText: const SizedBox.shrink(),
      messageText: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              message,
              style: textTheme.headlineSmall?.copyWith(
                color: textColor,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}