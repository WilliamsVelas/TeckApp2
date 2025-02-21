import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../theme/colors.dart';
import '../../../database/models/providers_model.dart';

class ProviderCard extends StatelessWidget {
  final Provider provider;

  const ProviderCard({Key? key, required this.provider}) : super(key: key);

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
              children: [
                Icon(
                  Icons.person,
                  color: AppColors.principalGray,
                  size: 20,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    provider.value,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.principalGray,
                    ),
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
          ],
        ),
      ),
    );
  }
}