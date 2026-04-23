import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../../Data/Repository/repository.dart';
import '../../../../../../../../../Data/response/api_response.dart';
import '../../../../../../../../../Data/response/status.dart';
import '../../../../../../../../../Data/user_preference_controller.dart';
import '../../../../../../../../../Utils/snack_bar.dart';
import '../../../../../../../../../shared/widgets/vendor_widgets/custom_confirm_password_dialog.dart';
import '../../../../../../../../../shared/widgets/vendor_widgets/pref_utils.dart';
import '../../../../../../../../../shared/widgets/vendor_widgets/print.dart';
import '../../../../../../vendor_common/Models/common_response_model.dart';
import '../../../../../../vendor_common/UserPasswordChange/UpdatePasswordModel/update_password_model.dart';
import '../../RestaurantInFormation/controller/restaurant_information_controller.dart';

class ResSecuritySettingsController extends GetxController{

  final FillRestaurantDetailsController fillRestaurantDetailsController = Get.isRegistered<FillRestaurantDetailsController>()? Get.find<FillRestaurantDetailsController>() : Get.put(FillRestaurantDetailsController());

  RxInt visibleItemsCount = 5.obs;
  final repo = Repository();
  RxString passwordError = "".obs;
  setPasswordError( String value){
    passwordError.value = value;
    update();
  }

  RxList<Map<String, dynamic>> authList = [
    {
      "key": "sms",
      "title": "SMS Authentication",
      "des": "Get OTP on your mobile.",
      "isEnabled": true,
    },
    {
      "key": "app",
      "title": "App Authentication",
      "des": "Use Google Authenticator.",
      "isEnabled": true,
    },
  ].obs;

  Timer? _debounceTimer;


  void toggleAuth(int index, bool value) {
    authList[index]['isEnabled'] = value;
    authList.refresh();
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      twoFactorAuthenticationApi(
        twoFaSms: authList[0]['isEnabled'] ? "1" : "0",
        twoFaApp: authList[1]['isEnabled'] ? "1" : "0",
      );
    });
  }


  void setApiDataForToggle(String sms, String app) {
    authList[0]['isEnabled'] = sms == "1";
    authList[1]['isEnabled'] = app == "1";
    authList.refresh();
  }

  RxString userRole = "".obs;

  @override
  void onInit()async {
    userRole.value = await UserPreference.getUserRole();
    final vendor = fillRestaurantDetailsController.profileApiData.value.vendor;
    setApiDataForToggle(
      vendor?.twoFaSms ?? "0",
      vendor?.twoFaApp ?? "0",
    );
    super.onInit();
  }

  bool get isAccountant => userRole.value.toLowerCase() == UserType.accountant.name;
  bool get isServiceStaff => userRole.value.replaceAll(" ", "").toLowerCase() == UserType.servicestaff.name;
  bool get isKitchenStaff => userRole.value.replaceAll(" ", "").toLowerCase() == UserType.kitchenstaff.name;

  final Rx<ApiResponse<CommonResponseModel>> _getUserDetails = Rx<ApiResponse<CommonResponseModel>>(ApiResponse.completed(null));
  Rx<ApiResponse<CommonResponseModel>> get userDetailsData => _getUserDetails;
  setGetUserApiData(ApiResponse<CommonResponseModel> value){
    _getUserDetails.value = value;
  }

  Future<void> twoFactorAuthenticationApi({String? twoFaSms,String? twoFaApp})async{
    setGetUserApiData(ApiResponse.loading());
    var data = {
      "two_fa_sms": twoFaSms,
      "two_fa_app":  twoFaApp
    };
    repo.twoFactorAuthentication(jsonEncode(data)).then((value) {
      if(value.status == true){
        fillRestaurantDetailsController.getProfileDetailsApi();
        setGetUserApiData(ApiResponse.completed(value));
        Utils.showToast(value.message ?? "");
      }else{
        setGetUserApiData(ApiResponse.error(value.message.toString()));
        Utils.showToast(value.message ?? "");
      }
    },).onError((error, stackTrace) {
      setGetUserApiData(ApiResponse.error(error.toString()));
      pt(error.toString());
    },);

  }


  Rx<TextEditingController> passwordController = TextEditingController().obs;
  Rx<TextEditingController> oldPasswordController = TextEditingController().obs;
  Rx<TextEditingController> confirmPasswordController = TextEditingController().obs;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey currentPassKey = GlobalKey();
  GlobalKey newPassKey = GlobalKey();
  GlobalKey confirmNewPassKey = GlobalKey();
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
      "current_password": oldPasswordController.value.text,
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
      }

      else {
        setRxRequestStatus(ApiStatus.ERROR);
    setPasswordError(apiData.value.message.toString());
      }
      final password = apiData.value.message?.toLowerCase() ?? "";

      if (password.contains("password")) {
        setPasswordError(apiData.value.message!);
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

  scrollToFields(GlobalKey key){
    final context = key.currentContext;
   if(context != null){
     Scrollable.ensureVisible(context,
     duration: const Duration(milliseconds: 100),
       alignment: 0.05
     );
   }
  }

  @override
  void onClose() {
    _debounceTimer?.cancel();
    super.onClose();
  }
}