import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:teck_app/app/database/models/clients_model.dart';

import '../../../../theme/colors.dart';
import '../../../common/generic_input.dart';
import '../../../database/models/payment_method_model.dart';
import '../../../database/models/products_model.dart';
import '../../../database/models/serials_model.dart';
import '../../../utils/input_validations.dart';
import '../controllers/invoice_controller.dart';

class InvoiceForm2 extends StatelessWidget {
  final InvoiceController invoiceController = Get.find<InvoiceController>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GenericFormInput(
              label: 'Número del documento',
              keyboardType: TextInputType.number,
              icon: Icons.insert_drive_file,
              onChanged: (value) => invoiceController.documentNo.value = value,
              controller: TextEditingController()
                ..text = invoiceController.documentNo.value,
              inputFormatters: InputFormatters.numericCode(),
            ),
            SizedBox(height: 16.0),
            Obx(
              () => CustomDropdown<Client>(
                hintText: 'Cliente',
                value: invoiceController.selectedClient.value,
                items: invoiceController.clients,
                itemTextBuilder: (client) => client.name,
                onChanged: (client) => invoiceController.selectClient(client),
              ),
            ),
            SizedBox(height: 16.0),
            Obx(
              () => CustomDropdown<Product>(
                hintText: 'Producto',
                value: invoiceController.selectedProduct.value,
                items: invoiceController.products,
                itemTextBuilder: (product) => product.name,
                onChanged: (product) =>
                    invoiceController.selectProduct(product),
              ),
            ),
            SizedBox(height: 16.0),
            Obx(
              () => invoiceController.availableSerials.isNotEmpty
                  ? CustomDropdown<Serial>(
                      hintText: 'Seriales',
                      value: invoiceController.selectedSerial.value,
                      items: invoiceController.availableSerials.toList(),
                      itemTextBuilder: (serial) => serial.serial,
                      onChanged: (serial) =>
                          invoiceController.selectSerial(serial),
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: GenericFormInput(
                            label: 'Cantidad',
                            keyboardType: TextInputType.number,
                            icon: Icons.numbers,
                            onChanged: (value) => invoiceController
                                .selectedQty.value = int.tryParse(value) ?? 1,
                            controller: TextEditingController()
                              ..text = invoiceController.selectedQty.value
                                  .toString(),
                            inputFormatters: InputFormatters.numericCode(),
                          ),
                        ),
                        if (invoiceController.selectedProduct.value != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              'Disponible: ${invoiceController.selectedProduct.value!.serialsQty}',
                              style: TextStyle(color: AppColors.principalWhite),
                            ),
                          ),
                      ],
                    ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => invoiceController.addInvoiceLine(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.principalGreen,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: Text('Agregar Línea'),
            ),
            SizedBox(height: 24.0),
            Text(
              "Productos",
              style: TextStyle(
                fontSize: 18,
                color: AppColors.principalWhite,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Obx(
              () => Column(
                children: invoiceController.invoiceLines.map((invoiceLine) {
                  int index =
                      invoiceController.invoiceLines.indexOf(invoiceLine);
                  return ListTile(
                    title: Text(
                      "${invoiceLine.productName} (x${invoiceLine.qty}) - \$${invoiceLine.total}",
                      style: TextStyle(color: AppColors.principalWhite),
                    ),
                    subtitle: invoiceLine.productSerial.isNotEmpty
                        ? Text(
                            "Serial: ${invoiceLine.productSerial}",
                            style: TextStyle(color: AppColors.principalGray),
                          )
                        : null,
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: AppColors.invalid),
                      onPressed: () =>
                          invoiceController.invoiceLines.removeAt(index),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 24.0),
            Text(
              "Pagos",
              style: TextStyle(
                fontSize: 18,
                color: AppColors.principalWhite,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            // Sección para agregar pagos
            Obx(
              () => CustomDropdown<PaymentMethod>(
                hintText: 'Método de Pago',
                value: invoiceController.selectedPaymentMethod.value,
                items: invoiceController.paymentMethods,
                itemTextBuilder: (method) => method.name,
                onChanged: (method) =>
                    invoiceController.selectPaymentMethod(method),
              ),
            ),
            SizedBox(height: 16.0),
            GenericFormInput(
              label: 'Monto del Pago',
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              icon: Icons.money,
              onChanged: (value) =>
                  invoiceController.paymentAmount.value = value,
              controller: TextEditingController()
                ..text = invoiceController.paymentAmount.value,
              inputFormatters: InputFormatters.numeric(),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => invoiceController.addPayment(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.principalGreen,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: Text('Agregar Pago'),
            ),
            SizedBox(height: 16.0),
            Obx(
              () => Column(
                children: invoiceController.payments.map((payment) {
                  int index = invoiceController.payments.indexOf(payment);
                  return ListTile(
                    title: Text(
                      "${invoiceController.paymentMethods.firstWhere((m) => m.id == payment.paymentMethodId).name} - \$${payment.amount}",
                      style: TextStyle(color: AppColors.principalWhite),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: AppColors.invalid),
                      onPressed: () =>
                          invoiceController.payments.removeAt(index),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 16.0),
            Obx(
              () => Text(
                'Monto Total: \$${invoiceController.calculateTotalAmount().toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.principalWhite,
                ),
              ),
            ),
            Obx(
              () => Text(
                'Monto Pendiente: \$${invoiceController.calculateRemainingBalance().toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.principalWhite,
                ),
              ),
            ),
            SizedBox(height: 32.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => invoiceController.saveInvoice(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.principalButton,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  child: Text('Guardar'),
                ),
                ElevatedButton(
                  onPressed: () => invoiceController.clearFields(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.invalid,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  child: Text('Borrar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class InvoiceForm extends StatelessWidget {
  final InvoiceController invoiceController = Get.find<InvoiceController>();
  final bool isPaymentMode;

  InvoiceForm({this.isPaymentMode = false});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GenericFormInput(
              label: 'Número del documento',
              keyboardType: TextInputType.number,
              icon: Icons.insert_drive_file,
              onChanged: (value) => invoiceController.documentNo.value = value,
              controller: TextEditingController()
                ..text = invoiceController.documentNo.value,
              inputFormatters: InputFormatters.numericCode(),
              readOnly: true,
            ),
            SizedBox(height: 16.0),
            Obx(
              () => CustomDropdown<Client>(
                hintText: 'Cliente',
                value: invoiceController.selectedClient.value,
                items: invoiceController.clients,
                itemTextBuilder: (client) => client.name,
                onChanged: (client) => invoiceController.selectClient(client),
              ),
            ),
            if (!isPaymentMode) ...[
              SizedBox(height: 16.0),
              Obx(
                () => CustomDropdown<Product>(
                  hintText: 'Producto',
                  value: invoiceController.selectedProduct.value,
                  items: invoiceController.products,
                  itemTextBuilder: (product) => product.name,
                  onChanged: (product) =>
                      invoiceController.selectProduct(product),
                ),
              ),
              SizedBox(height: 16.0),
              Obx(
                () => invoiceController.availableSerials.isNotEmpty
                    ? CustomDropdown<Serial>(
                        hintText: 'Seriales',
                        value: invoiceController.selectedSerial.value,
                        items: invoiceController.availableSerials.toList(),
                        itemTextBuilder: (serial) => serial.serial,
                        onChanged: (serial) =>
                            invoiceController.selectSerial(serial),
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: GenericFormInput(
                              label: 'Cantidad',
                              keyboardType: TextInputType.number,
                              icon: Icons.numbers,
                              onChanged: (value) => invoiceController
                                  .selectedQty.value = int.tryParse(value) ?? 1,
                              controller: TextEditingController()
                                ..text = invoiceController.selectedQty.value
                                    .toString(),
                              inputFormatters: InputFormatters.numericCode(),
                            ),
                          ),
                          if (invoiceController.selectedProduct.value != null)
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                'Disponible: ${invoiceController.selectedProduct.value!.serialsQty}',
                                style:
                                    TextStyle(color: AppColors.principalWhite),
                              ),
                            ),
                        ],
                      ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () => invoiceController.addInvoiceLine(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.principalGreen,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: Text('Agregar Línea'),
              ),
            ],
            SizedBox(height: 24.0),
            Text(
              "Productos",
              style: TextStyle(
                fontSize: 18,
                color: AppColors.principalWhite,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Obx(
              () => Column(
                children: invoiceController.invoiceLines.map((invoiceLine) {
                  int index =
                      invoiceController.invoiceLines.indexOf(invoiceLine);
                  return ListTile(
                    title: Text(
                      "${invoiceLine.productName} (x${invoiceLine.qty}) - \$${invoiceLine.total}",
                      style: TextStyle(color: AppColors.principalWhite),
                    ),
                    subtitle: invoiceLine.productSerial.isNotEmpty
                        ? Text(
                            "Serial: ${invoiceLine.productSerial}",
                            style: TextStyle(color: AppColors.principalGray),
                          )
                        : null,
                    trailing: !isPaymentMode
                        ? IconButton(
                            icon: Icon(Icons.delete, color: AppColors.invalid),
                            onPressed: () =>
                                invoiceController.invoiceLines.removeAt(index),
                          )
                        : null,
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 24.0),
            Text(
              "Pagos",
              style: TextStyle(
                fontSize: 18,
                color: AppColors.principalWhite,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Obx(
              () => CustomDropdown<PaymentMethod>(
                hintText: 'Método de Pago',
                value: invoiceController.selectedPaymentMethod.value,
                items: invoiceController.paymentMethods,
                itemTextBuilder: (method) => method.name,
                onChanged: (method) =>
                    invoiceController.selectPaymentMethod(method),
              ),
            ),
            SizedBox(height: 16.0),
            GenericFormInput(
              label: 'Monto del Pago',
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              icon: Icons.money,
              onChanged: (value) =>
                  invoiceController.paymentAmount.value = value,
              controller: TextEditingController()
                ..text = invoiceController.paymentAmount.value,
              inputFormatters: InputFormatters.numeric(),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => invoiceController.addPayment(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.principalGreen,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: Text('Agregar Pago'),
            ),
            SizedBox(height: 16.0),
            Obx(
              () => Column(
                children: invoiceController.payments.map((payment) {
                  int index = invoiceController.payments.indexOf(payment);
                  return ListTile(
                    title: Text(
                      "${invoiceController.paymentMethods.firstWhere((m) => m.id == payment.paymentMethodId).name} - \$${payment.amount}",
                      style: TextStyle(color: AppColors.principalWhite),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: AppColors.invalid),
                      onPressed: () =>
                          invoiceController.payments.removeAt(index),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 16.0),
            Obx(
              () => Text(
                'Monto Total: \$${invoiceController.calculateTotalAmount().toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.principalWhite,
                ),
              ),
            ),
            Obx(
              () => Text(
                'Monto Pendiente: \$${invoiceController.calculateRemainingBalance().toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.principalWhite,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            GenericFormInput(
              label: 'Nota',
              keyboardType: TextInputType.text,
              icon: Icons.note,
              onChanged: (value) => invoiceController.note.value = value,
              controller: TextEditingController()
                ..text = invoiceController.note.value,
            ),
            SizedBox(height: 32.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () =>
                      invoiceController.saveInvoice(isUpdate: isPaymentMode),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.principalButton,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  child: Text('Guardar'),
                ),
                ElevatedButton(
                  onPressed: () => invoiceController.clearFields(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.invalid,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  child: Text('Borrar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
