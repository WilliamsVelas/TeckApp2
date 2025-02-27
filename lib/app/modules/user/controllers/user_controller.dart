import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../database/database_helper.dart';
import '../../../database/models/user_model.dart';

class UserController extends GetxController {
  final Rx<User?> user = Rx<User?>(null);
  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  void onInit() {
    super.onInit();
    fetchUser();
  }

  Future<void> fetchUser() async {
    final List<User> users = await dbHelper.getUsers();
    user.value = users.isNotEmpty ? users.first : null;
  }
}