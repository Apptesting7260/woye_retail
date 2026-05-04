import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/Profile/Sub_Screens/Setting/RestaurantInformation/model/profile_details_model.dart';

import '../../../../../../Data/Model/user_model.dart';
import '../../../../../../Data/Repository/repository.dart';
import '../../../../../../Data/response/status.dart';
import '../../../../../../Data/user_preference_controller.dart';
import '../../../../../../routes/vendor_routes/vendor_app_routes.dart';
import '../../../../../../shared/widgets/vendor_widgets/custom_confirm_password_dialog.dart';
import '../../../../../../shared/widgets/vendor_widgets/print.dart';


class CommonProfileController extends GetxController{

  final api = Repository();
  RxString error = ''.obs;

  @override
  void onInit() async {
    await initializeUser();

    if (token != null && token.isNotEmpty && token != "null" && token != "") {
      await getProfileDetailsApi();
    }

    super.onInit();
  }


String token = "";
  UserModel userModel = UserModel();
  var pref = UserPreference();
  Future<void> initializeUser() async {
    userModel = await pref.getUser();
    token = userModel.token??'';
    log("Token $token");
    log("Step ${userModel.step}");
  }

  final rxGetProfileRequestStatus = ApiStatus.COMPLETED.obs;
  final profileApiData = ProfileDetailsModel().obs;
  void personalDetailsSet(ProfileDetailsModel value) => profileApiData.value = value;

  void setError(String value) => error.value = value;

  getProfileDetailsApi() async {
    rxGetProfileRequestStatus(ApiStatus.LOADING);
    if (token == null || token.isEmpty || token == "null" || token == "") {
      pt("common get profile trying to call and token is invalid $token ${token.runtimeType}");
      return;
    }

    api.getProfileApi().then((value) async {
      log("==== PROFILE DEBUG START ====");
      log("STATUS: ${profileApiData.value.status}");
      log("STEP: ${profileApiData.value.vendor?.step}");
      log("VENDOR STATUS: ${profileApiData.value.vendor?.status}");
      log("IS PROFILE COMPLETE: ${profileApiData.value.isProfileComplete}");
      log("TYPE: ${profileApiData.value.vendor?.type}");
      log("==== PROFILE DEBUG END ====");
      personalDetailsSet(value);
      debugPrint("profile detailsccc: $value");
      if (profileApiData.value.status == true) {
        log("common get profile here Step ${profileApiData.value.vendor?.step} and Status ${profileApiData.value.vendor?.status}",name: ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
        rxGetProfileRequestStatus(ApiStatus.COMPLETED);
        if (profileApiData.value.vendor?.step == '3' && (profileApiData.value.vendor?.status == 'suspended' || profileApiData.value.vendor?.status == 'inactive'|| profileApiData.value.vendor?.status == 'pending')) {
          log("⚠️ PROFILE INCOMPLETE CONDITION HIT");
          await closeAllDialogs();
          if (profileApiData.value.vendor?.status == 'suspended') {
            Get.dialog(
              const CustomConfirmPasswordDialog(
                isError: true,
                title: "Account Suspended",
                subTitle: "Your account has been suspended.",
                isContactBtn: true,
              ),
              barrierDismissible: false,
            );
          } else if (profileApiData.value.vendor?.status == 'pending') {
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
          }else if ( profileApiData.value.vendor?.status == 'inactive') {
            Get.dialog(
              const CustomConfirmPasswordDialog(
                isError: true,
                title: "Account Inactive",
                subTitle:
                "Your account is not activated",
                isContactBtn: false,
              ),
              barrierDismissible: false,
            );
          }
        }else if( profileApiData.value.vendor?.status == 'active' &&  profileApiData.value.vendor?.step == "3" &&  profileApiData.value.isProfileComplete == false){
          // await closeAllDialogs();
          pt(">>>>>>>>>>>>>>>>>>>>here profile is not completed");

            CustomConfirmPasswordDialog(
              isError: true,
              title: "Profile Incomplete",
              subTitle: "Please complete your profile to continue.",
              isContactBtn: true,
              contactBtnTitle: "OK",
              isContactBtnOnTap: () async {
                Get.back();
                await Future.delayed(const Duration(milliseconds: 200));

                final type = profileApiData.value.vendor?.type;
                    print(">>>>>>>>>>>>>>>>>>>>>here profile is not completed and type is $type");
                if (type == "retail") {
                  Get.toNamed(VendorAppRoutes.restaurantInformationScreens);
                }
              },
            );

          // CustomConfirmPasswordDialog(
          //   isError: true,
          //   title: "Profile Incomplete",
          //   subTitle: "Please complete your profile to continue.",
          //   isContactBtn: true,
          //   contactBtnTitle: "OK",
          //   isContactBtnOnTap: () async {
          //     Get.back();
          //
          //     await Future.delayed(const Duration(milliseconds: 200));
          //
          //     final type = profileApiData.value.vendor?.type;
          //
          //     if (type == "retail") {
          //       Get.toNamed(VendorAppRoutes.restaurantInformationScreens);
          //     }
          //     // else if (type == 'pharmacy') {
          //     //   Get.toNamed(AppRoutes.pharmacyInformationScreens);
          //     // } else if (type == 'grocery') {
          //     //   Get.toNamed(AppRoutes.groceryInformationScreens);
          //     // }
          //   },
          // );
        }  else if(profileApiData.value.isProfileComplete == true &&  profileApiData.value.vendor?.status?.toLowerCase() == 'active') {
          pt("closing dialog inside common profile controller");
          await closeAllDialogs();
        }
      }
    }).onError((error, stackTrace) {
        rxGetProfileRequestStatus(ApiStatus.ERROR);
        setError(error.toString());
        debugPrint('Error CommonProfileController: $error');
      },
    );
  }


  Future<void> closeAllDialogs() async {
    while (Get.isDialogOpen ?? false) {
      Get.back();
      await Future.delayed(const Duration(milliseconds: 1)); // Wait a bit to ensure smooth closing
    }
  }

}