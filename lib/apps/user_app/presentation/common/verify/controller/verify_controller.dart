import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:gyaawa/Data/user_preference_controller.dart';
import 'package:gyaawa/apps/user_app/presentation/common/forgot_password/model/change_password_model.dart';
import 'package:gyaawa/apps/user_app/presentation/common/login/model/two_factor_model.dart';
import 'package:gyaawa/apps/user_app/presentation/common/verify/model/verify_otp_model.dart';
import 'package:gyaawa/routes/user_routes/user_app_routes.dart';
import '../../../../../../Data/Model/user_model.dart';
import '../../../../../../Data/Repository/repository.dart';
import '../../../../../../Data/response/status.dart';
import '../../../../../../Utils/snack_bar.dart';
import '../../../../../../routes/vendor_routes/vendor_app_routes.dart';
import '../../../../../../shared/widgets/vendor_widgets/print.dart';

class VerifyController extends GetxController {
  final UserPreference pref = UserPreference();
  RxBool isForgotFlow = false.obs;
  RxBool isLoading = false.obs;
  RxInt resendTimer = 55.obs;
  RxString otp = ''.obs;
  final api = Repository();
  RxString otpError = ''.obs;
  RxString email = ''.obs;
  RxString token = ''.obs;
  RxString type = ''.obs;
  final GlobalKey<FormState> verifyFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    email.value = Get.arguments?['email'] ?? '';
    token.value = Get.arguments?['token'] ?? '';
    type.value = Get.arguments?['type'] ?? 'signup';
    isForgotFlow.value = (type.value == "forgot");
    startTimer();
  }


  Rx<ApiStatus> rxRequestStatus = ApiStatus.COMPLETED.obs;
  Rx<VerifyOtpModel> apiData = VerifyOtpModel().obs;
  void setRxRequestStatus(ApiStatus status) {rxRequestStatus.value = status;}
  void verifySet(VerifyOtpModel value) {apiData.value = value;}


  otpVerifyApi() async {
    var data = {
      "email": email.value,
      "otp": otp.value,
    };
    debugPrint("Data body: $data");
    setRxRequestStatus(ApiStatus.LOADING);
    otpError.value = "";
    api.verifyVendorApi(data).then((value) async {
      verifySet(value);
      if (apiData.value.status == true) {
        setRxRequestStatus(ApiStatus.COMPLETED);
        UserModel user = UserModel();
        user.token = apiData.value.token ?? "";
        user.step = int.tryParse(apiData.value.step ?? "1") ?? 1;
        user.loginType = apiData.value.type ?? "retail";
        user.isLogin = true;
        await pref.saveUser(user);
        Utils.showToast(apiData.value.message ?? "");
        Get.offAllNamed(VendorAppRoutes.resProfileDetailsScreen);

      } else{
        setRxRequestStatus(ApiStatus.ERROR);
        otpError.value = apiData.value.message.toString();
        verifyFormKey.currentState?.validate();
        pt("OTP ERROR: ${apiData.value.message}");
      }
    }).onError((error, stackTrace) {
      setRxRequestStatus(ApiStatus.ERROR);
      Utils.showToast('Error: $error');
      debugPrint('Error: $error');
    });
  }

  // >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>forgot password otp verify api<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


  Rx<ApiStatus> forgotOtpStatus = ApiStatus.COMPLETED.obs;
  Rx<ForgotOtpVerifyModel> forgotOtpData = ForgotOtpVerifyModel().obs;

  void setForgotOtpStatus(ApiStatus status) {forgotOtpStatus.value = status;}

  void setForgotOtpData(ForgotOtpVerifyModel value) {forgotOtpData.value = value;}

  Future<void> forgotOtpApi() async {
    var data = {
      "otp": otp.value,
    };
    pt("FORGOT OTP DATA: $data TOKEN: ${token.value}");
    setForgotOtpStatus(ApiStatus.LOADING);
    otpError.value = "";
    api.vendorForgotOtpApi(token.value, data).then((value) {
      setForgotOtpData(value);
      if (forgotOtpData.value.status == true) {
        setForgotOtpStatus(ApiStatus.COMPLETED);
        Utils.showToast(forgotOtpData.value.message ?? "");
        Get.toNamed(UserRoutes.changePasswordScreen, arguments: {
          "token": token.value
        });
      } else {
        setForgotOtpStatus(ApiStatus.ERROR);
        otpError.value = forgotOtpData.value.message ?? "Invalid OTP";
        verifyFormKey.currentState?.validate();
      }
    }).onError((error, stackTrace) {
      setForgotOtpStatus(ApiStatus.ERROR);
      Utils.showToast('Error: $error');
      debugPrint('Error: $error');
    });
  }

  Future<void> verifyOtpApi() async {
    if (isForgotFlow.value) {
      await forgotOtpApi();
    }
    else if (type.value == "2fa") {
      await twoFactorOtpApi();
    } else {
      await otpVerifyApi();
    }
  }
  Rx<ApiStatus> forgotResendRequestStatus = ApiStatus.COMPLETED.obs;
  Future<void> resendForgotOtpApi() async {
    var data = {
      "email": email.value,
    };

    pt("Resend OTP Data: $data");

    forgotResendRequestStatus.value = ApiStatus.LOADING;

    api.vendorForgotResendOtpApi(token.value, data).then((value) {

      if (value.status == true) {
        forgotResendRequestStatus.value = ApiStatus.COMPLETED;

        resetOtpForm();
        startTimer();

        Utils.showToast(value.message ?? "");
      } else {
        forgotResendRequestStatus.value = ApiStatus.ERROR;
        Utils.showToast(value.message ?? "");
      }

    }).onError((error, stackTrace) {
      forgotResendRequestStatus.value = ApiStatus.ERROR;
      pt('Resend OTP Error: $error');
    });
  }


  // >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Resend OTP API<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  Rx<ApiStatus> resendRequestStatus = ApiStatus.COMPLETED.obs;

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


  // >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>2FA OTP Verify API<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  Rx<TwoFactorModel> twoFactorData = TwoFactorModel().obs;
  Rx<ApiStatus> twoFactorStatus = ApiStatus.COMPLETED.obs;
  void setTwoFactorStatus(ApiStatus status) {twoFactorStatus.value = status;}

  void setTwoFactorData(TwoFactorModel value) {twoFactorData.value = value;}

  Future<void> twoFactorOtpApi() async {
    var data = {
      "email": email.value,
      "otp": otp.value,
    };
    pt("2FA OTP DATA: $data");
    setTwoFactorStatus(ApiStatus.LOADING);
    otpError.value = "";
    api.twoFactorOtpVerifyApi(data).then((value) async {
      setTwoFactorData(value);
      if (value.status == true) {
        setTwoFactorStatus(ApiStatus.COMPLETED);
        Utils.showToast(value.message ?? "");
        UserModel user = UserModel();

        user.token = value.token ?? "";
        user.step = int.tryParse(value.step ?? "1") ?? 1;
        user.loginType = value.type ?? "retail";
        user.isLogin = true;
        await pref.saveUser(user);
        Get.offAllNamed(VendorAppRoutes.resProfileDetailsScreen);
      } else {
        setTwoFactorStatus(ApiStatus.ERROR);
        otpError.value = value.message ?? "Invalid OTP";
        verifyFormKey.currentState?.validate();
      }

    }).onError((error, stackTrace) {
      setTwoFactorStatus(ApiStatus.ERROR);
      Utils.showToast("Error: $error");

      debugPrint("2FA ERROR: $error");
    });
  }
  // >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>2FA Resend OTP API<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  Rx<ApiStatus> twoFactorOtpStatus = ApiStatus.COMPLETED.obs;
  Rx<TwoFactorResendModel> twoFactorResendData = TwoFactorResendModel().obs;

  void setTwoFactorOtpStatus(ApiStatus status) {
    twoFactorOtpStatus.value = status;
  }

  void setTwoFactorResendData(TwoFactorResendModel value) {
    twoFactorResendData.value = value;
  }
  Future<void> twoFactorResendOtpApi() async {
    var data = {
      "email": email.value,
    };
    pt("2FA RESEND OTP DATA: $data");
    setTwoFactorOtpStatus(ApiStatus.LOADING);
    api.vendorTwoFactorOtpResendApi(data).then((value) {
      setTwoFactorResendData(value);
      debugPrint("Resend OTP Response: $value");
      if (value.status == true) {
        setTwoFactorOtpStatus(ApiStatus.COMPLETED);
        resetOtpForm();
        startTimer();
        Utils.showToast(value.message ?? "");
      } else {
        setTwoFactorOtpStatus(ApiStatus.ERROR);
        Utils.showToast(value.message ?? "Failed");
      }
    }).onError((error, stackTrace) {
      setTwoFactorOtpStatus(ApiStatus.ERROR);
      pt('Resend OTP Error: $error');
    });
  }


  // >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Timer for Resend OTP<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

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