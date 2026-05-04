import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gyaawa/Data/Repository/repository.dart';
import 'package:gyaawa/routes/vendor_routes/vendor_app_routes.dart';
import 'package:gyaawa/shared/widgets/vendor_widgets/custom_confirm_password_dialog.dart';

import '../../../../../../Data/response/api_response.dart';
import '../../../../../../shared/widgets/vendor_widgets/print.dart';
import '../model/vendor_account_status_model.dart';

class VendorAccountStatusController extends GetxController{


  Repository api = Repository();


  @override
  void onInit() async {
    super.onInit();
  }
  // bool isDialogVisible = false;
  bool isApiCalling = false;
  Rx<ApiResponse<VendorAccountStatusModel>> accountStatusData = Rx<ApiResponse<VendorAccountStatusModel>>(ApiResponse.loading());

  bool isOnInformationScreen() {
    final route = Get.currentRoute;

    return route == VendorAppRoutes.restaurantInformationScreens;
  }

  Future<void> getAccountStatusApi() async {
    if (isApiCalling) return;
    isApiCalling = true;
    accountStatusData.value = ApiResponse.loading();
    api.getAccountStatusApi().then((value) async {
      if(value.status == true){
        accountStatusData.value = ApiResponse.completed(value);
        // pt("accountStatusData.value.data?.vendorStatus?.toLowerCase() ${accountStatusData.value.data?.vendorStatus?.toLowerCase()}");
        // pt("accountStatusData.value.data?.isProfileComplete ${accountStatusData.value.data?.isProfileComplete}");
        // pt("accountStatusData.value.data?.roleName  ${accountStatusData.value.data?.roleName}");
        final data = accountStatusData.value.data;

        final isActive = data?.vendorStatus?.toLowerCase() == "active";

        pt("vendorStatus: ${data?.vendorStatus}");
        pt("isProfileComplete: ${data?.isProfileComplete}");
        pt("role: ${data?.roleName}");
        pt("step: ${data?.step}");


        if (accountStatusData.value.data?.vendorStatus?.toLowerCase() == 'suspended' || accountStatusData.value.data?.vendorStatus?.toLowerCase() == 'inactive' || accountStatusData.value.data?.vendorStatus?.toLowerCase() == 'pending') {
          pt("isActive111: $isActive");

          await closeAllDialogs();
          pt("isActive222: $isActive");

          if (accountStatusData.value.data?.vendorStatus == 'suspended') {
            pt("isActive: suspended $isActive");

            Get.dialog(
              const CustomConfirmPasswordDialog(
                isError: true,
                title: "Account Suspended",
                subTitle: "Your account has been suspended.",
                isContactBtn: true,
              ),
              barrierDismissible: false,
            );
          } else if (accountStatusData.value.data?.vendorStatus == 'inactive') {
            pt("isActive: inactive $isActive");

            Get.dialog(
              const CustomConfirmPasswordDialog(
                isError: true,
                title: "Account Inactive",
                subTitle:
                "Your account is not activated.",
                isContactBtn: false,
              ),
              barrierDismissible: false,
            );
          }else if (accountStatusData.value.data?.vendorStatus == 'pending') {
            pt("isActive: pending $isActive");

            Get.dialog(
              const CustomConfirmPasswordDialog(
                isError: true,
                title: "Under Approval",
                subTitle:
                "Your account is not activated, wait for admin approval",
                isContactBtn: false,
              ),
              barrierDismissible: false,
            );
          }
        }else if (accountStatusData.value.data?.vendorStatus == 'active' && data?.isProfileComplete == false && data?.step == "3") {
          pt("here Account is active but profile not completed");
          await closeAllDialogs().then((value) {
            showProfileIncompleteDialog();
          },);
        } else if(accountStatusData.value.data?.isProfileComplete == true &&  accountStatusData.value.data?.vendorStatus?.toLowerCase() == 'active') {
          pt("isActive: closeAllDialogs $isActive");

          await closeAllDialogs();
          }
      }else{
        pt("isActive123: closeAllDialogs ");

        accountStatusData.value = ApiResponse.error("account status error");
      }
    }).onError((error, stackError) {
      debugPrint("account status error ---> ${error.toString()}");
      accountStatusData.value = ApiResponse.error(error.toString());
    });
    isApiCalling = false;
  }

  void showProfileIncompleteDialog() {
    if (isOnInformationScreen()) {
      pt("Already on information screen → no popup");
      return;
    }

    if (Get.isDialogOpen ?? false) return;

    Future.delayed(Duration.zero, () {
      Get.dialog(
        PopScope(
          canPop: false,
          child: CustomConfirmPasswordDialog(
            isError: true,
            title: "Profile Incomplete",
            subTitle: "Please complete your profile to continue.",
            isContactBtn: true,
            contactBtnTitle: "OK",
            isContactBtnOnTap: () async {
              closeAllDialogs();

              await Future.delayed(const Duration(milliseconds: 200));

              final type = accountStatusData.value.data?.vendorType;

              if (type == "retail") {
                Get.toNamed(VendorAppRoutes.restaurantInformationScreens);
              }
            },
          ),
        ),
        barrierDismissible: false,
      );
    });
  }

  Future<void> closeAllDialogs() async {
    while (Get.isDialogOpen ?? false) {
      Get.back();
      await Future.delayed(const Duration(milliseconds: 1)); // Wait a bit to ensure smooth closing
    }

    if (isOnInformationScreen()) {
      pt("On info screen → skip reopening dialog");
      return;
    }

    if (accountStatusData.value.data?.vendorStatus == 'active' && accountStatusData.value.data?.isProfileComplete == false && accountStatusData.value.data?.step == "3") {
      await Future.delayed(const Duration(milliseconds: 200));
      showProfileIncompleteDialog();
    }
  }

}