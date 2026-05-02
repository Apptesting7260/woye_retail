import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gyaawa/Data/Repository/repository.dart';
import 'package:gyaawa/routes/user_routes/user_app_routes.dart';

import '../../../../../../Data/response/status.dart';
import '../../../../../../Utils/snack_bar.dart';

class ForgotPasswordController extends GetxController {

  final Repository api = Repository();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  final rxRequestStatus = ApiStatus.COMPLETED.obs;

  void setRxRequestStatus(ApiStatus value) =>
      rxRequestStatus.value = value;

  Future<void> forgotPasswordApi() async {
    var data = {
      "email": emailController.text.trim(),
    };
    debugPrint("FORGOT DATA: $data");
    setRxRequestStatus(ApiStatus.LOADING);
    api.vendorForgotApi(data).then((value) {
      if (value.status == true) {
        setRxRequestStatus(ApiStatus.COMPLETED);
        Get.toNamed(UserRoutes.verifyScreen, arguments: {
          "email": emailController.text.trim(),
          "token": value.token ?? "",
          "type": "forgot"
        });
        Utils.showToast(value.message ?? "");
      } else {
        setRxRequestStatus(ApiStatus.ERROR);
        Utils.showToast(value.message ?? "Something went wrong");
      }
    }).onError((error, stackTrace) {
      setRxRequestStatus(ApiStatus.ERROR);
      Utils.showToast(error.toString());
    });
  }
  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

}