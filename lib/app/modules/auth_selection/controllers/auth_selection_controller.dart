import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../theme/colors.dart';
import '../../../common/custom_snakcbar.dart';
import '../../../routes/app_routes.dart';

class AuthSelectionController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<bool> isUserRegistered() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_registered') ?? false;
  }

  Future<void> setUserRegistered() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_registered', true);
  }

  Future<User?> signInWithGoogle() async {
    try {
      print('Iniciando Google Sign-In...');
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      print('Resultado de signIn(): $googleUser');
      if (googleUser == null) {
        print('Usuario canceló el inicio de sesión');
        return null;
      }
      print('Email: ${googleUser.email}, ID: ${googleUser.id}');
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      print('AccessToken: ${googleAuth.accessToken}, IDToken: ${googleAuth.idToken}');
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      print('Usuario autenticado: ${userCredential.user?.email}');
      return userCredential.user;
    } catch (e, stackTrace) {
      print('Error en Google Sign-In: $e');
      print('StackTrace: $stackTrace');
      CustomSnackbar.show(
        title: "¡Error!",
        message: "No se pudo iniciar sesión: $e",
        icon: Icons.cancel,
        backgroundColor: AppColors.invalid,
      );
      return null;
    }
  }

  Future<bool> isEmailWhitelisted(String email) async {
    final doc = await FirebaseFirestore.instance
        .collection('whitelist')
        .doc(email)
        .get();
    return doc.exists && doc.data()?['allowed'] == true;
  }

  Future<void> toLogin() async {
    final user = await signInWithGoogle();
    if (user != null) {
      final email = user.email;
      if (email != null && await isEmailWhitelisted(email)) {
        await setUserRegistered();
        Get.offAllNamed(AppRoutes.HOME);
        CustomSnackbar.show(
          title: "¡Aprobado!",
          message: "Bienvenido, $email",
          icon: Icons.check_circle,
          backgroundColor: AppColors.principalGreen,
        );
      } else {
        await _auth.signOut();
        await _googleSignIn.signOut();
        CustomSnackbar.show(
          title: "¡Acceso denegado!",
          message: "Tu correo no está autorizado",
          icon: Icons.cancel,
          backgroundColor: AppColors.invalid,
        );
      }
    } else {
      CustomSnackbar.show(
        title: "¡Cancelado!",
        message: "Inicio de sesión cancelado",
        icon: Icons.cancel,
        backgroundColor: AppColors.invalid,
      );
    }
  }
}