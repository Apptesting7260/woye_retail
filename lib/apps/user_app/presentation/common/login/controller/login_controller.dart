// import 'package:get/get.dart';
//
// class LoginController extends GetxController {
//   RxString selectedType = "customer".obs;
//
//   void setCustomer() {
//     selectedType.value = "customer";
//   }
//
//   void setVendor() {
//     selectedType.value = "vendor";
//   }
//
//
//
//
// }

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:gyaawa/Data/Repository/repository.dart';
import '../../../../../../Data/Model/user_model.dart';
import '../../../../../../Data/response/status.dart';
import '../../../../../../Data/user_preference_controller.dart';
import '../../../../../../Utils/snack_bar.dart';
import '../../../../../../routes/user_routes/user_app_routes.dart';
import '../../../../../../routes/vendor_routes/vendor_app_routes.dart';
import '../../../../../../shared/widgets/vendor_widgets/print.dart';

class LoginController extends GetxController {
  final loginFormKey = GlobalKey<FormState>();
  final UserPreference pref = UserPreference();
  UserModel userModel = UserModel();
  @override
  void onInit() {
    super.onInit();

    emailController.value.clear();
    passwordController.value.clear();
  }
  @override
  void onClose() {
    emailController.value.clear();
    passwordController.value.clear();
    super.onClose();
  }
  RxString selectedType = "customer".obs;

  void setCustomer() {
    selectedType.value = "customer";
  }

  void setVendor() {
    selectedType.value = "vendor";
  }

  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> passwordController = TextEditingController().obs;

  RxBool isShowPassword = true.obs;

  final rxRequestStatus = ApiStatus.COMPLETED.obs;
  RxString error = ''.obs;

  final api = Repository();

  final apiData = Rxn<dynamic>();

  void setRxRequestStatus(ApiStatus value) =>
      rxRequestStatus.value = value;

  void setError(String value) => error.value = value;

  void loginSet(dynamic value) => apiData.value = value;

  RxString emailError = "".obs;
  void setEmailError(String value) => emailError.value = value;


  Future<void> loginApi() async {
    var data = {
      "email": emailController.value.text.trim(),
      "password": passwordController.value.text.trim(),
      "type": selectedType.value,
    };
    debugPrint("LOGIN DATA: $data");
    setRxRequestStatus(ApiStatus.LOADING);
    api.loginApi(data).then((value) {
      loginSet(value);
      if (value.status == true) {
        setRxRequestStatus(ApiStatus.COMPLETED);
        if (value.action == "verify_2fa") {
          Get.toNamed(UserRoutes.verifyScreen, arguments: {
            "email": value.email,
            "type": "2fa"
          });
          Utils.showToast(value.message ?? "");
          return;
        }
        Utils.showToast(value.message ?? "");
        pref.saveToken(value.token.toString());
        pref.saveStep(int.parse(value.step ?? "1"));
        pref.saveIsLogin(true);

        userModel.token = value.token ?? "";
        userModel.step = int.tryParse(value.step ?? "1") ?? 1;
        userModel.loginType = value.type ?? "";
        userModel.isLogin = value.status ?? false;

        pref.saveUser(userModel);
        singleVendorRouting();
        // if (value.type == "retail" || selectedType.value == "vendor") {
        //   Get.offAllNamed(VendorAppRoutes.resProfileDetailsScreen);
        // }
      } else {
        setRxRequestStatus(ApiStatus.ERROR);
        Utils.showToast(value.message ?? "Login failed");
      }
    }).onError((error, stackTrace) {
      setRxRequestStatus(ApiStatus.ERROR);
      pt("LOGIN ERROR: $error");
    });
  }
  void singleVendorRouting() {
    final step = int.tryParse(apiData.value.step.toString()) ?? 1;

    switch (step) {
      case 1:
        Get.offAllNamed(VendorAppRoutes.resProfileDetailsScreen);
        break;

      case 2:
        Get.offAllNamed(VendorAppRoutes.chooseRestaurantCategoriesScreen);
        break;

      case 3:
        Get.offAllNamed(VendorAppRoutes.restaurantNavbarScreen);
        break;

      default:
        Get.offAllNamed(VendorAppRoutes.resProfileDetailsScreen);
    }
  }
  void togglePassword() {
    isShowPassword.value = !isShowPassword.value;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter email";
    }
    return null;
  }
  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return "Please enter password";
    }
    String errorMessage = '';

    if (password.length < 8) {
      errorMessage += 'Password must be longer than 8 characters.\n';
    }

    if (!password.contains(RegExp(r'[A-Z]'))) {
      errorMessage += 'At least one uppercase letter\n';
    }

    if (!password.contains(RegExp(r'[a-z]'))) {
      errorMessage += 'At least one lowercase letter\n';
    }

    if (!password.contains(RegExp(r'[0-9]'))) {
      errorMessage += 'At least one numeric digit\n';
    }

    if (!password.contains(RegExp(r'[!@#%^&*(),.?":{}|<>]'))) {
      errorMessage += 'At least one special character\n';
    }

    return errorMessage.isEmpty ? null : errorMessage;
  }


  void resetForm() {
    loginFormKey.currentState?.reset();
    emailController.value.clear();
    passwordController.value.clear();
    emailError.value = "";
    isShowPassword.value = true;
  }

  @override
  void dispose() {
    emailController.value.dispose();
    passwordController.value.dispose();
    super.dispose();
  }
}