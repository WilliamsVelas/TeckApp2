import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../theme/colors.dart';
import '../../../database/models/categories_model.dart';

class CategoryCard extends StatelessWidget {
  final Category category;

  const CategoryCard({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
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
          ],
        ),
      ),
    );
  }
}
