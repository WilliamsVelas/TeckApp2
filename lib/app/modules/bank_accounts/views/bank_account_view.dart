import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teck_app/app/modules/bank_accounts/controller/bank_account_controller.dart';
import 'package:teck_app/app/modules/bank_accounts/widgets/bank_account_form.dart';

import '../../../../theme/colors.dart';
import '../../../common/generic_input.dart';
import '../widgets/bank_account_card.dart';

class BankAccountView extends GetView<BankAccountController> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.onPrincipalBackground,
        leading: IconButton(
          icon: const Icon(
            Icons.keyboard_arrow_left_outlined,
            color: AppColors.principalWhite,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Cuentas de banco',
          style: TextStyle(color: AppColors.principalWhite),
        ),
      ),
      backgroundColor: AppColors.onPrincipalBackground,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: GenericInput(
                    hintText: 'Buscar cuenta bancaria...',
                    onChanged: (value) {
                      //controller.searchBankAccounts(value); // Implement search if required
                    },
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.sort),
                  onPressed: () {
                    //_showSortDialog(context, controller); // Implement sort if required
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
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
                    'Cuentas Bancarias',
                    style: TextStyle(fontSize: 18.0, color: AppColors.principalWhite, fontWeight: FontWeight.bold),
                  ),
                  Obx(() =>
                      Text(
                        '${controller.bankAccounts.length} cuentas bancarias',
                        style: TextStyle(fontSize: 12.0, color: AppColors.principalGray),
                      ),
                  ),
                  Expanded(
                    child: Obx(() {
                      final bankAccounts = controller.bankAccounts;

                      if (bankAccounts.isEmpty) {
                        return const Center(
                          child: Text(
                            'No hay cuentas bancarias disponibles.',
                            style: TextStyle(fontSize: 16.0, color:  AppColors.principalGray),
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: bankAccounts.length,
                        itemBuilder: (context, index) {
                          final bankAccount = bankAccounts[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: BankAccountCard(bankAccount: bankAccount),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: ElevatedButton(
              onPressed: () {
                _openBankAccountForm(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.principalButton,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                child: Text(
                  'Agregar',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: AppColors.onPrincipalBackground,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }

  void _openBankAccountForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.onPrincipalBackground,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 16.0,
            left: 16.0,
            right: 16.0,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: BankAccountForm(),
        );
      },
    );
  }
}