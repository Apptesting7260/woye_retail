import 'package:flutter/cupertino.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:gyaawa/routes/vendor_routes/vendor_app_routes.dart';
import '../../../../../../Data/Model/user_model.dart';
import '../../../../../../Data/user_preference_controller.dart';
import '../../welcome/view/welcome_screen.dart';

class SplashController extends GetxController {

  final UserPreference pref = UserPreference();
  UserModel userModel = UserModel();

  stepWiseRouting() async {

    await Future.delayed(const Duration(seconds: 2));

    userModel = await pref.getUser();

    final isLogin = userModel.isLogin ?? false;
    final step = userModel.step ?? 0;
    final type = userModel.loginType ?? "";

    debugPrint("LOGIN: $isLogin");
    debugPrint("STEP: $step");
    debugPrint("TYPE: $type");

    if (!isLogin || (userModel.token ?? "").isEmpty) {
      Get.offAll(() => WelcomeScreen());
      return;
    }
    if (type == "retail") {
      if (step == 1) {
        Get.offAllNamed(VendorAppRoutes.resProfileDetailsScreen);
      } else if (step == 2) {
        Get.offAllNamed(VendorAppRoutes.chooseRestaurantCategoriesScreen);
      } else {
        Get.offAllNamed(VendorAppRoutes.restaurantNavbarScreen);
      }
    }

  }}