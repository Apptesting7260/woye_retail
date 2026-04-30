import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:gyaawa/Data/user_preference_controller.dart';
import 'package:gyaawa/apps/user_app/presentation/common/verify/model/verify_otp_model.dart';
import '../../../../../../Data/Repository/repository.dart';
import '../../../../../../Data/response/status.dart';
import '../../../../../../Utils/snack_bar.dart';
import '../../../../../../routes/vendor_routes/vendor_app_routes.dart';
import '../../../../../../shared/theme/colors.dart';
import '../../../../../../shared/widgets/vendor_widgets/print.dart';

class VerifyController extends GetxController {
  final UserPreference pref = UserPreference();

  RxBool isLoading = false.obs;
  RxInt resendTimer = 55.obs;
  RxString otp = ''.obs;
  final api = Repository();
  RxString otpError = ''.obs;
  RxString email = ''.obs;
  final GlobalKey<FormState> verifyFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    email.value = Get.arguments?['email'] ?? '';
    startTimer();
  }


  Rx<ApiStatus> rxRequestStatus = ApiStatus.COMPLETED.obs;
  Rx<VerifyOtpModel> apiData = VerifyOtpModel().obs;
  void setRxRequestStatus(ApiStatus status) {rxRequestStatus.value = status;}
  void verifySet(VerifyOtpModel value) {apiData.value = value;}
  // Future<void> verifyOtpApi() async {
  //   var data = {
  //     "email": email.value,
  //     "otp": otp.value,
  //   };
  //
  //   debugPrint("Data body for verify OTP : $data");
  //
  //   setRxRequestStatus(ApiStatus.LOADING);
  //   api.verifyVendorApi(data).then((value) {
  //     debugPrint("Response data: $value");
  //     verifySet(value);
  //
  //     if (apiData.value.status == true) {
  //       setRxRequestStatus(ApiStatus.COMPLETED);
  //       Utils.showToast(apiData.value.message.toString());
  //       Get.offAllNamed(VendorAppRoutes.resProfileDetailsScreen);
  //       pt("Navigating to resProfileDetailsScreen");
  //     } else if (apiData.value.status == false) {
  //       setRxRequestStatus(ApiStatus.ERROR);
  //       Utils.showToast(apiData.value.message.toString());
  //     } else {
  //       setRxRequestStatus(ApiStatus.ERROR);
  //       Utils.showToast('${apiData.value.message}');
  //     }
  //   }).onError((error, stackTrace) {
  //     setRxRequestStatus(ApiStatus.ERROR);
  //     debugPrint('Verify OTP Error: >>>>>>>>>>>>>>>>> $error');
  //   });
  // }



  otpVerifyApi() async {
    var data = {
      "email": email.value,
      "otp": otp.value,
    };
    debugPrint("Data body: $data");
    setRxRequestStatus(ApiStatus.LOADING);
    api.verifyVendorApi(data).then((value) {
      verifySet(value);
      if (apiData.value.status == true && apiData.value.step == "1") {
        setRxRequestStatus(ApiStatus.COMPLETED);

        pref.saveToken(apiData.value.token.toString());
        pref.saveStep(int.parse(apiData.value.step.toString()));
        pref.saveIsLogin(true);
        Utils.showToast(apiData.value.message.toString());
        Get.offAllNamed(VendorAppRoutes.resProfileDetailsScreen);
      }
    }).onError((error, stackTrace) {
      setRxRequestStatus(ApiStatus.ERROR);
      Utils.showToast('Error: $error');
      debugPrint('Error: $error');
    });
  }




  Rx<ApiStatus> resendRequestStatus = ApiStatus.COMPLETED.obs;

  void setResendRequestStatus(ApiStatus status) {
    resendRequestStatus.value = status;

  }

  Future<void> resendOtpApi() async {
    var data = {
      "email": email.value,
    };

    pt("Resend OTP Data: $data");
    resendRequestStatus(ApiStatus.LOADING);

    api.vendorResendOtpApi(data).then((value) {
      debugPrint("Resend OTP Response: $value");
      verifySet(value);

      if (apiData.value.status == true) {
        resendRequestStatus(ApiStatus.COMPLETED);
        resetOtpForm();
        startTimer();
        Utils.showToast(apiData.value.message.toString());
      }
    }).onError((error, stackTrace) {
      resendRequestStatus(ApiStatus.ERROR);
      pt('Resend OTP Error: $error');
    });
  }

  void startTimer() {
    resendTimer.value = 55;
    Future.doWhile(() async {
      await Future.delayed(Duration(seconds: 1));
      if (resendTimer.value > 0) {
        resendTimer.value--;
        return true;
      }
      return false;
    });
  }
  void resetOtpForm() {
    verifyFormKey.currentState?.reset();
  }
}