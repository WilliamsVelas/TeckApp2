import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../theme/colors.dart';
import '../../../database/models/clients_model.dart';
import '../../bank_accounts/widgets/bank_account_card.dart';
import '../controllers/clients_controller.dart';

class ClientCard extends StatelessWidget {
  final Client client;

  const ClientCard({Key? key, required this.client}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ClientsController controller = Get.find<ClientsController>();
    RxBool isExpanded = false.obs;

    return Obx(
      () => GestureDetector(
        onTap: () => isExpanded.value = !isExpanded.value,
        // Alternar expansión
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
                        Text(
                          "${client.value} (${client.phoneNumber})",
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.principalGray,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      client.isActive ? 'Activo' : 'Inactivo',
                      // Mostrar estado
                      style: TextStyle(
                        fontSize: 12,
                        color: client.isActive ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${client.name} ${client.lastName}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.principalWhite,
                      ),
                    ),
                    // Text(
                    //   '${client.affiliateCode}',
                    //   style: TextStyle(
                    //     fontSize: 14,
                    //     color: AppColors.principalGray,
                    //   ),
                    // ),
                  ],
                ),
                if (isExpanded.value)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.account_balance_sharp,
                            color: AppColors.principalGreen,
                          ),
                          onPressed: client.isActive
                              ? () {
                                  controller.showBankAccountsModal(
                                      client.id!, context);
                                  isExpanded.value = false;
                                }
                              : null,
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: AppColors.warning,
                          ),
                          onPressed: client.isActive
                              ? () {
                                  controller.editClient(client, context);
                                  isExpanded.value = false;
                                }
                              : null,
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: AppColors.invalid,
                          ),
                          onPressed: client.isActive
                              ? () {
                                  controller.deactivateClient(client.id!);
                                  isExpanded.value = false;
                                }
                              : null,
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

class BankAccountsModal extends StatelessWidget {
  final int clientId;

  const BankAccountsModal({required this.clientId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ClientsController>();

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Cuentas Bancarias',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.principalWhite)),
              IconButton(
                icon: Icon(Icons.close, color: AppColors.principalGray),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          Obx(() {
            if (controller.isLoadingBankAccounts.value) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child:
                    CircularProgressIndicator(color: AppColors.principalGreen),
              );
            }

            if (controller.clientBankAccounts.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Text('No hay cuentas bancarias asociadas',
                    style: TextStyle(color: AppColors.principalGray)),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: controller.clientBankAccounts.length,
              separatorBuilder: (_, __) => SizedBox(height: 12),
              itemBuilder: (context, index) {
                final account = controller.clientBankAccounts[index];
                return BankAccountCard(bankAccount: account);
              },
            );
          }),
        ],
      ),
    );
  }
}
