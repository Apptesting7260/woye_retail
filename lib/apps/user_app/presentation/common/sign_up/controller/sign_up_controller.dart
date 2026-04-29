// import 'package:get/get_rx/src/rx_types/rx_types.dart';
// import 'package:get/get_state_manager/get_state_manager.dart';
//
// class SignUpController extends GetxController {
//   RxString selectedType = "customer".obs;
//
//   void setCustomer() {
//     selectedType.value = "customer";
//   }
//
//   void setVendor() {
//     selectedType.value = "vendor";
//   }
// }

// lib/controllers/sign_up_controller.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:gyaawa/Data/Repository/repository.dart';
import 'package:gyaawa/apps/user_app/presentation/common/sign_up/model/sign_up_model.dart';
import 'package:gyaawa/routes/user_routes/user_app_routes.dart';
import '../../../../../../Data/response/status.dart';
import '../../../../../../Utils/snack_bar.dart';
import '../../../../../../Utils/validation.dart';
import '../../../../../../shared/theme/colors.dart';
import '../../../../../../shared/widgets/vendor_widgets/print.dart';

class SignUpController extends GetxController {
  final signUpFormKey = GlobalKey<FormState>();
  String? tokenFcm;
  RxString emailError = "".obs;

  setEmailError(String value) {
    emailError.value = value;
    update();
  }

  // @override
  // void onInit() async {
  //   tokenFcm = await FirebaseMessaging.instance.getToken();
  //   if (kDebugMode) {
  //     debugPrint("tokenFcm >>>>>>>>>>>>>> $tokenFcm");
  //   }
  //   super.onInit();
  // }

  RxString selectedType = "customer".obs;

  void setCustomer() {
    selectedType.value = "customer";
  }

  void setVendor() {
    selectedType.value = "vendor";
  }

  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> passwordController = TextEditingController().obs;
  Rx<TextEditingController> confirmPasswordController = TextEditingController().obs;

  RxBool isShowPassword = true.obs;
  RxBool isShowConfirmPassword = true.obs;

  final rxRequestStatus = ApiStatus.COMPLETED.obs;
  RxString error = ''.obs;
  final api = Repository();

  void setRxRequestStatus(ApiStatus value) => rxRequestStatus.value = value;
  void setError(String value) => error.value = value;
  final apiData = SignUpResponseModel().obs;
  void signUpSet(SignUpResponseModel value) => apiData.value = value;

  Future<void> vendorRegisterApi() async {
    if (selectedType.value != "vendor") return;

    var data = {
      "email": emailController.value.text.trim(),
      "password": passwordController.value.text.trim(),
      // "device_token": tokenFcm ?? "",
    };

    debugPrint("Data body for signup : $data");

    setRxRequestStatus(ApiStatus.LOADING);

    api.createVendorApi(data).then((value) {
      setEmailError("");
      debugPrint("Response data: $value");
      signUpSet(value);

      if (apiData.value.status == true) {
        setRxRequestStatus(ApiStatus.COMPLETED);
        Utils.showToast(apiData.value.message.toString());

        Get.toNamed(UserRoutes.verifyScreen);

      } else if (apiData.value.status == false) {
        setRxRequestStatus(ApiStatus.ERROR);

        final email = apiData.value.message?.toLowerCase() ?? "";

        if (email.contains("email")) {
          setEmailError(apiData.value.message!);
        } else {
          Utils.showToast(apiData.value.message!, bgColor: AppColors.red);
        }
      } else {
        setRxRequestStatus(ApiStatus.ERROR);
        Utils.showToast('${apiData.value.message}', bgColor: AppColors.red,);
      }
    }).onError((error, stackTrace) {
      pt(' SignUp Error: >>>>>>>>>>>>>>>>> $error');
    });
  }

  // Toggle Password Visibility
  togglePasswordVisibility({bool? isConfirmPassword}) {
    if (isConfirmPassword == true) {
      isShowConfirmPassword.value = !isShowConfirmPassword.value;
    } else {
      isShowPassword.value = !isShowPassword.value;
    }
  }

  String? validateEmail(String? value) {
    if (value!.isEmpty || !isValidEmail(value, isRequired: true) || value == "") {
      return "Please enter a valid Email";
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value!.isEmpty || value == "") {
      return "Please re-enter password";
    } else if (passwordController.value.text != confirmPasswordController.value.text) {
      return "Password not matched";
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
    signUpFormKey.currentState?.reset();
    emailController.value.clear();
    passwordController.value.clear();
    confirmPasswordController.value.clear();
    emailError.value = "";
    isShowPassword.value = true;
    isShowConfirmPassword.value = true;
  }

  @override
  void dispose() {
    emailController.value.dispose();
    passwordController.value.dispose();
    confirmPasswordController.value.dispose();
    super.dispose();
  }
}