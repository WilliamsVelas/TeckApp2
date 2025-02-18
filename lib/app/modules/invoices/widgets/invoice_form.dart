import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../theme/colors.dart';
import '../../../common/generic_input.dart';
import '../../../database/models/products_model.dart';
import '../controllers/invoice_controller.dart';

class InvoiceForm extends StatelessWidget {
  final invoiceController = Get.find<InvoiceController>();

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

            // Basic Invoice Information Inputs
            GenericFormInput(
              label: 'Número de Documento',
              keyboardType: TextInputType.text,
              icon: Icons.insert_drive_file,
              onChanged: (value) => invoiceController.documentNo.value = value,
              controller: TextEditingController()
                ..text = invoiceController.documentNo.value,
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

            // ... Selector para Cliente y BankAccount (puedes usar CustomDropdown) ...
            // ... Implementa la lógica para mostrar los selectores de cliente y cuenta bancaria ...

            SizedBox(height: 24.0),

            // Add Product and Serial
            Text("Agregar Productos", style: TextStyle(fontSize: 18, color: AppColors.principalWhite, fontWeight: FontWeight.bold)),
            SizedBox(height: 16.0),

            ProductSelectorAndSerialInput(), // Widget para seleccionar producto y serial

            SizedBox(height: 24.0),

            Text("Líneas de Factura", style: TextStyle(fontSize: 18, color: AppColors.principalWhite, fontWeight: FontWeight.bold)),
            SizedBox(height: 16.0),

            // Invoice Line List
            Obx(() => Column(
              children: invoiceController.invoiceLines.map((invoiceLine) {
                int index = invoiceController.invoiceLines.indexOf(invoiceLine);
                return ListTile(
                  title: Text("${invoiceLine.productName} - ${invoiceLine.total}", style: TextStyle(color: AppColors.principalWhite)),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: AppColors.invalid),
                    onPressed: () => invoiceController.removeInvoiceLine(index), //Implement this method in InvoiceController
                  ),
                );
              }).toList(),
            )),

            SizedBox(height: 32.0),

            // Save and Clear Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // invoiceController.saveInvoiceWithLines();

                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.principalButton,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    textStyle: TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: Text('Guardar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    invoiceController.clearFields();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.invalid,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    textStyle: TextStyle(fontSize: 16),
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

class ProductSelectorAndSerialInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final invoiceController = Get.find<InvoiceController>();
    return Row(
      children: [
        Expanded(
          child: CustomDropdown<Product>( // Replace with your dropdown widget
            hintText: 'Seleccionar Producto',
            value: null, // Use null for the selected product
            items: [], // load with productController.products //load the array with products
            itemTextBuilder: (product) => product.name,
            onChanged: (product) {
              // Implement code to execute if product was selected
            },
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: TextField(
            decoration: InputDecoration(labelText: 'Serial'),
            onChanged: (value) {
              // implement to save in variable productController.newSerial
            },
          ),
        ),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            // implement function to create invoice Line if product and serial were typed
          },
        ),
      ],
    );
  }
}