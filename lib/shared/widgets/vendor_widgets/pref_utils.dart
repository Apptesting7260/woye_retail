
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Data/Model/user_model.dart';
import '../../../Data/user_preference_controller.dart';


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
  // scaffoldKey = null;
  // Get.deleteAll();
  // if (Get.currentRoute != AppRoutes.loginScreen) {
  //   Get.offAllNamed(AppRoutes.loginScreen);
  // }n
  // Get.offAndToNamed(AppRoutes.loginScreen);
}
}
