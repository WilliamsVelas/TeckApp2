import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teck_app/app/modules/clients/controllers/clients_controller.dart';

import '../../../../theme/colors.dart';
import '../../../common/generic_input.dart';
import '../widgets/clients_card.dart';
import '../widgets/clients_form.dart';

class ClientView extends GetView<ClientsController> {
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
        title:Text(
          'Clientes',
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
                    hintText: 'Buscar cliente...',
                    onChanged: (value) {
                      controller.searchClients(value);
                    },
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.sort),
                  onPressed: () {
                    _showSortDialog(context, controller);
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
                    'Clientes',
                    style: TextStyle(fontSize: 18.0, color: AppColors.principalWhite, fontWeight: FontWeight.bold),
                  ),
                  Obx(() =>
                      Text(
                        '${controller.clients.length} clientes',
                        style: TextStyle(fontSize: 12.0, color: AppColors.principalGray),
                      ),
                  ),
                  Expanded(
                    child: Obx(() {
                      final clients = controller.clients;

                      if (clients.isEmpty) {
                        return const Center(
                          child: Text(
                            'No hay clientes disponibles.',
                            style: TextStyle(fontSize: 16.0, color:  AppColors.principalGray),
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: clients.length,
                        itemBuilder: (context, index) {
                          final client = clients[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: ClientCard(client: client),
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
                _openClientForm(context);
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

  void _showSortDialog(BuildContext context, ClientsController controller) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ordenar clientes'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Fecha de creación'),
                onTap: () {
                  controller.sortClients("date");
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Nombre'),
                onTap: () {
                  controller.sortClients("name");
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Apellido'),
                onTap: () {
                  controller.sortClients("lastName");
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _openClientForm(BuildContext context) {
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
          child: ClientForm(),
        );
      },
    );
  }
}