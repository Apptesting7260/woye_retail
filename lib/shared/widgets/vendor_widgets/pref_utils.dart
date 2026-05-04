
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:gyaawa/routes/user_routes/user_app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Data/Model/user_model.dart';
import '../../../Data/user_preference_controller.dart';
import '../../../main.dart';


class PrefUtils {
UserPreference pref = UserPreference();
SharedPreferences? _sharedPreferences;
UserModel userModel = UserModel();

Future<void> _initPrefs() async {
  _sharedPreferences = await SharedPreferences.getInstance();
}

Future<void> logout() async {
  if (_sharedPreferences == null) {
    await _initPrefs();
  }
  await pref.removeUser();
  _sharedPreferences!.remove('token');
  _sharedPreferences!.remove('isLogin');
  _sharedPreferences!.remove('Step');
  _sharedPreferences!.remove('loginType');
  _sharedPreferences!.remove('permissions');
  _sharedPreferences!.clear();
  userModel.clear();
  scaffoldKey = null;
  Get.deleteAll();
  if (Get.currentRoute != UserRoutes.loginScreen) {
    Get.offAllNamed(UserRoutes.loginScreen);
  }
  Get.offAndToNamed(UserRoutes.loginScreen);
}
}
