import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';

import '../../../../theme/colors.dart';
import '../../../common/custom_snakcbar.dart';
import '../../../database/database_helper.dart';
import '../../../database/models/user_model.dart';
import '../../../routes/app_routes.dart';

class UserController extends GetxController {
  final Rx<UserApp?> user = Rx<UserApp?>(null);
  final DatabaseHelper dbHelper = DatabaseHelper();
  final RxBool isLoading = true.obs;
  final RxBool isEditing = false.obs;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final LocalAuthentication _localAuth = LocalAuthentication();

  @override
  void onInit() {
    super.onInit();
    fetchUser();
  }

  Future<void> fetchUser() async {
    isLoading.value = true;
    final List<UserApp> users = await dbHelper.getUsers();
    user.value = users.isNotEmpty ? users.first : null;
    isLoading.value = false;
  }

  Future<bool> _canAuthenticate() async =>
      await _localAuth.canCheckBiometrics ||
      await _localAuth.isDeviceSupported();

  Future<bool> authenticateUser() async {
    if (!await _canAuthenticate()) {
      CustomSnackbar.show(
        title: "¡Error!",
        message: "El dispositivo no soporta autenticación biométrica ni clave",
        icon: Icons.cancel,
        backgroundColor: AppColors.invalid,
      );
      return false;
    }

    try {
      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Verifique su identidad para editar su perfil',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: false,
        ),
      );

      if (!didAuthenticate) {
        CustomSnackbar.show(
          title: "¡Error!",
          message: "Autenticación fallida",
          icon: Icons.cancel,
          backgroundColor: AppColors.invalid,
        );
        return false;
      }

      return true;
    } catch (e) {
      print('Error en autenticación: $e');
      CustomSnackbar.show(
        title: "¡Error!",
        message: "Fallo en la autenticación: $e",
        icon: Icons.cancel,
        backgroundColor: AppColors.invalid,
      );
      return false;
    }
  }

  void loadUserForEdit() {
    if (user.value != null) {
      nameController.text = user.value!.name;
      lastNameController.text = user.value!.lastName;
      usernameController.text = user.value!.username;
      isEditing.value = true;
    }
  }

  Future<void> saveUser() async {
    if (nameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        usernameController.text.isEmpty) {
      CustomSnackbar.show(
        title: "¡Error!",
        message: "Todos los campos son obligatorios",
        icon: Icons.cancel,
        backgroundColor: AppColors.invalid,
      );
      return;
    }

    final updatedUser = UserApp(
      id: user.value?.id,
      name: nameController.text,
      lastName: lastNameController.text,
      username: usernameController.text,
      createdAt: user.value?.createdAt ?? DateTime.now().millisecondsSinceEpoch,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
      isActive: user.value?.isActive ?? true,
    );

    try {
      if (isEditing.value && user.value != null) {
        await dbHelper.updateUser(updatedUser);
        CustomSnackbar.show(
          title: "¡Actualizado!",
          message: "Usuario actualizado correctamente",
          icon: Icons.check_circle,
          backgroundColor: AppColors.principalGreen,
        );
      } else {
        await dbHelper.insertUser(updatedUser);
        CustomSnackbar.show(
          title: "¡Aprobado!",
          message: "Usuario guardado correctamente",
          icon: Icons.check_circle,
          backgroundColor: AppColors.principalGreen,
        );
      }
      await fetchUser();
      isEditing.value = false;
      Get.back();
    } catch (e) {
      CustomSnackbar.show(
        title: "¡Ocurrió un error!",
        message: "Verifique los datos e intente nuevamente: $e",
        icon: Icons.cancel,
        backgroundColor: AppColors.invalid,
      );
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      print('Sesión de Firebase cerrada');

      await _googleSignIn.signOut();
      print('Sesión de Google cerrada');

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('is_registered');
      print('SharedPreferences limpiado');

      Get.offAllNamed(AppRoutes.AUTH_SELECTION);

      CustomSnackbar.show(
        title: "¡Sesión cerrada!",
        message: "Has cerrado sesión exitosamente",
        icon: Icons.check_circle,
        backgroundColor: AppColors.principalGreen,
      );
    } catch (e) {
      print('Error al cerrar sesión: $e');
      CustomSnackbar.show(
        title: "¡Error!",
        message: "No se pudo cerrar sesión: $e",
        icon: Icons.cancel,
        backgroundColor: AppColors.invalid,
      );
    }
  }

  void clearFields() {
    nameController.clear();
    lastNameController.clear();
    usernameController.clear();
    isEditing.value = false;
  }
}
