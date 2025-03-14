import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:teck_app/app/modules/auth_selection/controllers/auth_selection_controller.dart';

import '../../../../theme/colors.dart';
import '../../../../theme/text.dart';

class AuthSelectionView extends GetView<AuthSelectionController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.principalBackground,
      body: Stack(
        children: [
          Center(
            child: SizedBox(
              width: 300,
              height: 300,
              child: Image.asset(
                'assets/images/logo.png',
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.3,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: ElevatedButton(
                      onPressed: () => controller.toLogin(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.principalButton,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                'Iniciar sesión con Google',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: AppColors.onPrincipalBackground,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(width: 4.0),
                            Icon(
                              Icons.g_mobiledata,
                              color: AppColors.onPrincipalBackground,
                              size: 26.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
