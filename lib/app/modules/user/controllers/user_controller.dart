import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../database/database_helper.dart';
import '../../../database/models/user_model.dart';

class UserController extends GetxController {
  final Rx<User?> user = Rx<User?>(null);
  final DatabaseHelper dbHelper = DatabaseHelper();
  final RxBool isLoading = true.obs; // Variable para el estado de carga

  // Variables para el formulario
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchUser();
  }

  Future<void> fetchUser() async {
    isLoading.value = true;
    final List<User> users = await dbHelper.getUsers();
    user.value = users.isNotEmpty ? users.first : null;
    isLoading.value = false;
  }

  Future<void> saveUser() async {
    if (nameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        usernameController.text.isEmpty) {
      Get.snackbar('Error', 'Todos los campos son obligatorios');
      return;
    }

    final newUser = User(
      name: nameController.text,
      lastName: lastNameController.text,
      username: usernameController.text,
      createdAt: DateTime.now(),
    );

    try {
      await dbHelper.insertUser(newUser);
      await fetchUser(); // Actualizar el usuario mostrado
      Get.back(); // Cerrar el formulario
      Get.snackbar('Éxito', 'Usuario guardado correctamente');
    } catch (e) {
      Get.snackbar('Error', 'No se pudo guardar el usuario: $e');
    }
  }

  void clearFields() {
    nameController.clear();
    lastNameController.clear();
    usernameController.clear();
  }
}
