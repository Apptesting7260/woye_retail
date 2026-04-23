// import 'dart:developer';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:woye_vendor_app/Core/Utils/snack_bar.dart';
// import 'package:woye_vendor_app/Data/Repository/repository.dart';
// import 'package:woye_vendor_app/Data/response/status.dart';
//
// import '../../../../../../../push_notification/push_notification.dart';
// import '../model/toggle_notification_model.dart';
//
// class RestaurantNotificationController extends GetxController {
//   RxBool isPushNotification = true.obs;
//   RxBool isEmailNotification = true.obs;
//
//   @override
//   void onInit() {
//     loadNotificationPreference();
//     super.onInit();
//   }
//
//   Future<void> loadNotificationPreference() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     isPushNotification.value = prefs.getBool('notifications_enabled') ?? true;
//     print("object ${isPushNotification.value}");
//   }
//
//   final api = Repository();
//
//   RxString walletError = ''.obs;
//
//   void setError(String value) => walletError.value = value;
//
//   Rx<ToggleNotificationModel> apiData = ToggleNotificationModel().obs;
//
//   void setWalletChartApiData(ToggleNotificationModel value) =>
//       apiData.value = value;
//
//   Rx<ApiStatus> rxWalletChartRequestStatus = ApiStatus.COMPLETED.obs;
//
//   void setWalletChartRxRequestStatus(ApiStatus value) =>
//       rxWalletChartRequestStatus.value = value;
//
//
//   Future<void> toggleNotificationApi({bool? notification, bool? emailNotification }) async {
//     var data = {
//       if(notification != null && notification != false)
//       "notification": notification.toString(),
//       if(emailNotification != null && emailNotification != false)
//        "email_notification": emailNotification.toString(),
//     };
//     setWalletChartRxRequestStatus(ApiStatus.LOADING);
//     api.toggleNotificationApi(data).then((value) {
//       setWalletChartApiData(value);
//       debugPrint("message  =================  ${apiData.value.message}");
//       debugPrint("emailNotificationStatus  =================  ${apiData.value
//           .emailNotificationStatus}");
//       debugPrint("notificationStatus  =================  ${apiData.value
//           .notificationStatus}");
//       if (apiData.value.status == true) {
//         setWalletChartRxRequestStatus(ApiStatus.COMPLETED);
//         Utils.showToast(apiData.value.message.toString());
//       } else {
//         setWalletChartRxRequestStatus(ApiStatus.ERROR);
//         Utils.showToast(apiData.value.message.toString());
//       }
//     }).onError((error, stackError) {
//       setError(error.toString());
//       log('Error $error');
//       setWalletChartRxRequestStatus(ApiStatus.ERROR);
//     });
//   }
//
//
// }
