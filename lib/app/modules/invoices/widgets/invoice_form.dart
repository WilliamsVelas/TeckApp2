import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:teck_app/app/database/models/clients_model.dart';

import '../../../../theme/colors.dart';
import '../../../common/generic_input.dart';
import '../../../database/models/products_model.dart';
import '../../../database/models/serials_model.dart';
import '../controllers/invoice_controller.dart';

class InvoiceForm extends StatelessWidget {
  final InvoiceController invoiceController = Get.find<InvoiceController>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Agregar Factura',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: AppColors.principalWhite,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.0),

            GenericFormInput(
              label: 'Nombre de la categoría',
              keyboardType: TextInputType.text,
              icon: Icons.insert_drive_file,
              onChanged: (value) => invoiceController.documentNo.value = value,
              controller: TextEditingController()..text = invoiceController.documentNo.value,
            ),
            SizedBox(height: 16.0),
            GenericFormInput(
              label: 'Tipo',
              keyboardType: TextInputType.text,
              icon: Icons.type_specimen,
              onChanged: (value) => invoiceController.type.value = value,
              controller: TextEditingController()..text = invoiceController.type.value,
            ),
            SizedBox(height: 16.0),
            Obx(
                  () => CustomDropdown<Client>(
                hintText: 'Cliente',
                value: invoiceController.selectedClient.value,
                items:  invoiceController.clients,
                itemTextBuilder: (clients) => clients.name,
                onChanged: (client) =>
                    invoiceController.selectClient(client),
              ),
            ),
            Obx(
                  () => CustomDropdown<Product>(
                hintText: 'Producto',
                value: invoiceController.selectedProduct.value,
                items:  invoiceController.products,
                itemTextBuilder: (products) => products.name,
                onChanged: (product) =>
                    invoiceController.selectProduct(product),
              ),
            ),
            SizedBox(height: 16.0),
            Obx(() {
              print("Renderizando Dropdown con ${invoiceController.availableSerials.length} seriales");
              return CustomDropdown<Serial>(
                hintText: 'Seriales',
                value: invoiceController.selectedSerial.value,
                items: invoiceController.availableSerials.toList(),
                itemTextBuilder: (serial) => serial.serial,
                onChanged: (serial) => invoiceController.selectSerial(serial),
              );
            }),
            SizedBox(height: 24.0),

            Text("Líneas de Factura", style: TextStyle(fontSize: 18, color: AppColors.principalWhite, fontWeight: FontWeight.bold)),
            SizedBox(height: 16.0),

            Obx(() => Column(
              children: invoiceController.invoiceLines.map((invoiceLine) {
                int index = invoiceController.invoiceLines.indexOf(invoiceLine);
                return ListTile(
                  title: Text("${invoiceLine.productName} - ${invoiceLine.total}", style: TextStyle(color: AppColors.principalWhite)),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: AppColors.invalid),
                    onPressed: () => invoiceController.invoiceLines.removeAt(index),
                  ),
                );
              }).toList(),
            )),
            SizedBox(height: 32.0),

            // Botones de acción
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => invoiceController.saveInvoice(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.principalButton,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: Text('Guardar'),
                ),
                ElevatedButton(
                  onPressed: () => invoiceController.clearFields(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.invalid,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: Text('Borrar'),
                ),
              ],
            ),
            SizedBox(height: 24.0),
          ],
        ),
      ),
    );
  }
}