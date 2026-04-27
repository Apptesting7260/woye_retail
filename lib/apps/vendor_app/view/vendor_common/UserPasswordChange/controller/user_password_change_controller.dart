import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../Data/Repository/repository.dart';
import '../../../../../../Data/response/status.dart';
import '../../../../../../Utils/snack_bar.dart';
import '../../../../../../shared/widgets/vendor_widgets/custom_confirm_password_dialog.dart';
import '../../../../../../shared/widgets/vendor_widgets/pref_utils.dart';
import '../UpdatePasswordModel/update_password_model.dart';

class UserPasswordChangeController extends GetxController {
  Rx<TextEditingController> passwordController = TextEditingController().obs;
  Rx<TextEditingController> oldPasswordController = TextEditingController().obs;
  Rx<TextEditingController> confirmPasswordController = TextEditingController().obs;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  PrefUtils prefUtils = PrefUtils();

  RxBool isShowPassword = true.obs;
  RxBool isShowConfirmPassword = true.obs;
  RxBool isShowOldPassword = true.obs;

  // RxBool isOldPassRedClr = false.obs;
  // RxBool isNewPassRedClr = false.obs;
  // RxBool isConfirmPassRedClr = false.obs;

  RxString error = "".obs;
  final api = Repository();
  final apiData = UpdatePasswordModel().obs;
  final rxRequestStatus = ApiStatus.COMPLETED.obs;

  void setRxUpdatePassword(UpdatePasswordModel value) => apiData.value = value;

  void setError(String value) => error.value = value;

  void setRxRequestStatus(ApiStatus value) => rxRequestStatus.value = value;

  updatePassword(context) {
    final data = {
      "old_password": oldPasswordController.value.text,
      "new_password": passwordController.value.text,
    };
    setRxRequestStatus(ApiStatus.LOADING);
    api.updatePassword(data).then((value) {
      setRxUpdatePassword(value);
      if (apiData.value.status == true) {
        setRxRequestStatus(ApiStatus.COMPLETED);
        showDialog(
          context: context,
          builder: (context) {
            return CustomConfirmPasswordDialog(onTap: () {
              prefUtils.logout();
              // Get.offAndToNamed(AppRoutes.loginScreen);
            });
          },
        );
      } else {
        setRxRequestStatus(ApiStatus.ERROR);
        Utils.showToast(apiData.value.message.toString());
      }
    }).onError((error, stackError) {
      setError(error.toString());
      debugPrint('Error Update password : $error');
      Utils.showToast(apiData.value.message.toString());
      setRxRequestStatus(ApiStatus.ERROR);
    });
  }

  togglePasswordVisibility({bool? isConfirmPassword}) {
    if (isConfirmPassword == true) {
      isShowConfirmPassword.value = !isShowConfirmPassword.value;
    } else {
      isShowPassword.value = !isShowPassword.value;
    }
  }

  String? validateConfirmPassword(String? value) {
    if (value!.isEmpty || value == "") {
      return "Please re-enter password";
    } else if (passwordController.value.text !=
        confirmPasswordController.value.text) {
      return "Password not matched";
    }
    return null;
  }
}
