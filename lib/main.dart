import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:teck_app/app/routes/app_pages.dart';
import 'package:teck_app/theme/colors.dart';
import 'package:teck_app/theme/text.dart';

import 'app/modules/auth_selection/controllers/auth_selection_controller.dart';
import 'app/routes/app_routes.dart';
import 'firebase_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final isAuthenticated = FirebaseAuth.instance.currentUser != null;

  runApp(MyApp(
      initialRoute:
          isAuthenticated ? AppRoutes.HOME : AppRoutes.AUTH_SELECTION));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'TeckApp',
      initialRoute: initialRoute,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: true,
      theme: ThemeData(
        textTheme: textTheme,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.principalGreen),
        useMaterial3: true,
      ),
    );
  }
}
