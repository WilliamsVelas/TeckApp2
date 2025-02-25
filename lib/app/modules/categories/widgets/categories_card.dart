import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../theme/colors.dart';
import '../../../database/models/categories_model.dart';
import '../controllers/categories_controller.dart';

class CategoryCard extends StatelessWidget {
  final Category category;

  const CategoryCard({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CategoriesController controller = Get.find<CategoriesController>();
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
                    Text(
                      '#${category.code ?? "Sin código"}',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.principalGray,
                      ),
                    ),
                    Text(
                      category.isActive ? 'Activa' : 'Inactiva', // Mostrar estado
                      style: TextStyle(
                        fontSize: 12,
                        color: category.isActive ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  category.name,
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
                          onPressed: category.isActive
                              ? () {
                            controller.deactivateCategory(category.id!);
                            isExpanded.value = false; // Contraer al desactivar
                          }
                              : null, // Deshabilitar si ya está inactiva
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
