import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../theme/colors.dart';
import '../../../database/models/providers_model.dart';
import '../controllers/provider_controller.dart';

class ProviderCard extends StatelessWidget {
  final Provider provider;

  const ProviderCard({Key? key, required this.provider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProviderController controller = Get.find<ProviderController>();
    RxBool isExpanded = false.obs; // Estado para controlar expansión

    return Obx(
          () => GestureDetector(
        onTap: () => isExpanded.value = !isExpanded.value, // Alternar expansión
        child: Card(
          color: AppColors.onPrincipalBackground,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                          color: AppColors.principalGray,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          provider.value,
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.principalGray,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      provider.isActive ? 'Activo' : 'Inactivo', // Mostrar estado
                      style: TextStyle(
                        fontSize: 12,
                        color: provider.isActive ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  provider.businessName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.principalWhite,
                  ),
                ),
                if (isExpanded.value) // Mostrar íconos cuando está expandido
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: provider.isActive
                              ? () {
                            controller.deactivateProvider(provider.id!);
                            isExpanded.value = false; // Contraer al desactivar
                          }
                              : null, // Deshabilitar si ya está inactivo
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}