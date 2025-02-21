import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../theme/colors.dart';
import '../../../database/models/clients_model.dart';

class ClientCard extends StatelessWidget {
  final Client client;

  const ClientCard({Key? key, required this.client}) : super(key: key);

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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.person,
                  color: AppColors.principalGray,
                  size: 20,
                ),
                Text(
                  ' (${client.codeBank})-',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.principalGray,
                  ),
                ),
                Text(
                  '${client.bankAccount}',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.principalGray,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${client.name}${client.lastName}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.principalWhite,
                  ),
                ),
                Text(
                  '${client.affiliateCode}',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.principalGray,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
