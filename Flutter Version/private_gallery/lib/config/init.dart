


import 'package:get/get.dart';
import 'package:private_gallery/controller/password_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> initialize() async {
  final prefs = await SharedPreferences.getInstance();
  Get.lazyPut(() => prefs);
  // Get.lazyPut(() => AppsController(prefs: Get.find()));
  // Get.lazyPut(() => HomeScreenController(prefs: Get.find()));
  // Get.lazyPut(() => MethodChannelController());
  // Get.lazyPut(() => PermissionController());
  Get.lazyPut(() => PasswordController(prefs: Get.find()));
}