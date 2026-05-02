import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../Data/Repository/repository.dart';
import '../../../../../Data/response/api_response.dart';
import '../../../../../Data/response/status.dart';
import '../../../../../Utils/snack_bar.dart';
import '../../../../../routes/user_routes/user_app_routes.dart';
import '../../../../../shared/widgets/vendor_widgets/custom_delete_alert_dialog.dart';
import '../../../../../shared/widgets/vendor_widgets/pref_utils.dart';
import '../../../../../shared/widgets/vendor_widgets/print.dart';
import '../Models/common_response_model.dart';

class SignOutController extends GetxController{
  final repo = Repository();
  PrefUtils prefUtils = PrefUtils();

  final Rx<ApiResponse<CommonResponseModel>> _signOutData = Rx<ApiResponse<CommonResponseModel>>(ApiResponse.completed(null));
  Rx<ApiResponse<CommonResponseModel>> get signOutData => _signOutData;
  setSignOutUserApiData(ApiResponse<CommonResponseModel> value){
    _signOutData.value = value;
  }

  Future<void> signOut()async{
    setSignOutUserApiData(ApiResponse.loading());
    var data = {};
    repo.signOut(data).then((value)async {
      if(value.status == true){
        await prefUtils.logout();
        setSignOutUserApiData(ApiResponse.completed(value));
        Utils.showToast(value.message ?? "");
        Get.offAllNamed(UserRoutes.welcomeScreen);
      }else{
        setSignOutUserApiData(ApiResponse.error(value.message.toString()));
        Utils.showToast(value.message ?? "");
      }
    },).onError((error, stackTrace) {
      setSignOutUserApiData(ApiResponse.error(error.toString()));
      pt(error.toString());
    },);
  }

  SizedBox logoutBtn() {
    return SizedBox(
      width: Get.width,
      child: Obx(
        ()=> CustomDeleteAlertDialog(
          isLoading: signOutData.value.status == ApiStatus.LOADING,
          title: 'Logout',
          subtitle: "Are you sure you want to log out?",
          btnName: "Logout",
          cancelOnTap: () {
            Get.back();
          },
          deleteOnTap: () {
            // for (var controller in _fillRestaurantDetailsController.shopStartTimeControllers) {
            //   controller.clear();
            // }
            // for (var controller in _fillRestaurantDetailsController.shopClosedTimeControllers) {
            //   controller.clear();
            // }
            // for (var isToggle in _fillRestaurantDetailsController.isToggleList) {
            //   isToggle.value = false;
            // }
            if(Get.isDialogOpen ?? false){
              Get.back();
            }
            signOut();

          },
        ),
      ),
    );
  }


}