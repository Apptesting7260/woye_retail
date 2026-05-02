import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:gyaawa/Data/Repository/repository.dart';
import 'package:gyaawa/routes/user_routes/user_app_routes.dart';

import '../../../../../../../Data/response/status.dart';
import '../../../../../../../Utils/snack_bar.dart';
import '../../../../../../../shared/widgets/vendor_widgets/print.dart';
class ChangePasswordController extends GetxController {

  final Repository api = Repository();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  RxString token = ''.obs;

  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  RxBool isShowNewPass = true.obs;
  RxBool isShowConfirmPass = true.obs;

  Rx<ApiStatus> rxRequestStatus = ApiStatus.COMPLETED.obs;

  void setRxRequestStatus(ApiStatus value) =>
      rxRequestStatus.value = value;

  @override
  void onInit() {
    super.onInit();
    token.value = Get.arguments?['token'] ?? "";
  }

  Future<void> changePasswordApi() async {
    var data = {
      "password": newPasswordController.text.trim(),
      "confirm_password": confirmPasswordController.text.trim(),
    };
    pt("CHANGE PASSWORD DATA: $data");
    setRxRequestStatus(ApiStatus.LOADING);
    api.changePasswordApi(token.value, data).then((value) {
      if (value.status == true) {
        setRxRequestStatus(ApiStatus.COMPLETED);
        Utils.showToast(value.message ?? "Password changed successfully");
        Get.offAllNamed(UserRoutes.loginScreen);
      } else {
        setRxRequestStatus(ApiStatus.ERROR);
        Utils.showToast(value.message ?? "Something went wrong");
      }
    }).onError((error, stackTrace) {
      setRxRequestStatus(ApiStatus.ERROR);
      pt("CHANGE PASSWORD ERROR: $error");
    });
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

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}