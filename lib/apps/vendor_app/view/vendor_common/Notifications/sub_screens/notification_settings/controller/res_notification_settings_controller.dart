import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/Profile/Sub_Screens/Setting/RestaurantInFormation/model/profile_details_model.dart';
import 'package:intl/intl.dart';
import '../../../../../../../../Data/Repository/repository.dart';
import '../../../../../../../../Data/response/api_response.dart';
import '../../../../../../../../Data/response/status.dart';
import '../../../../../../../../Utils/snack_bar.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/custom_confirm_password_dialog.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/print.dart';
import '../../../../GetProfileController/controller/common_get_profile_controller.dart';
import '../../../../Models/common_response_model.dart';

class ResNotificationSettingController extends GetxController{

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Rx<TextEditingController> startTimeController = TextEditingController().obs;
  Rx<TextEditingController> endTimeController = TextEditingController().obs;

  //general
  RxBool isEnableNotification = false.obs;
  RxBool isQuietHours = false.obs;
  RxBool isSoundNotification = false.obs;
  RxBool isBadgeCount = false.obs;

  //alert
  RxBool isNewOrder = false.obs;
  RxBool isOrderUpdates = false.obs;
  RxBool isPaymentIssues = false.obs;
  RxBool isLowStock = false.obs;
  RxBool isOutOfStock = false.obs;
  RxBool tableReservations = false.obs;
  RxBool isMenuItemRequests = false.obs;

  //channels
  RxBool isPushNotification = false.obs;
  RxBool isEmailNotification = false.obs;
  RxBool isSmsNotification = false.obs;


  RxString selectedOrderN = "".obs;
  RxString selectedReviewN = "".obs;
  RxString selectedInventoryN = "".obs;


  @override
  void onInit() {
    selectedTypeIndex.value = 0;
    getProfileDetailsApi();
    super.onInit();
  }

  RxList<String> btnName = ["General","Alerts","Channels","Schedule"].obs;
  RxList<String> orderNotificationFrequencyList = ["Immediate","Hourly","Daily","Weekly","Monthly","Never"].obs;
  RxList<String> reviewNotificationFrequencyList = ["Immediate","Daily","Weekly"].obs;
  RxList<String> inventoryNotificationFrequencyList = ["Immediate","Daily","Weekly"].obs;

  RxInt selectedTypeIndex = 0.obs;

  void updateSelectedType(int index){
    selectedTypeIndex.value = index;
    update();
  }


  final api = Repository();

  final rxGetProfileRequestStatus = ApiStatus.COMPLETED.obs;
  final profileApiData = ProfileDetailsModel().obs;
  void personalDetailsSet(ProfileDetailsModel value) => profileApiData.value = value;
  RxString error = ''.obs;
  void setError(String value) => error.value = value;

  getProfileDetailsApi() async {
    rxGetProfileRequestStatus(ApiStatus.LOADING);
    api.getProfileApi().then((value) async {
      personalDetailsSet(value);
      debugPrint("profile details: $value");
      if (profileApiData.value.status == true) {
        final vendor =  profileApiData.value.vendor;
        isSoundNotification.value = vendor?.notificationSounds == "0" ? false : true;
        isBadgeCount.value = vendor?.notificationBadges == "0" ? false : true;
        isNewOrder.value = vendor?.notifyNewOrders == "0" ? false : true;
        isOrderUpdates.value = vendor?.notifyOrderUpdates == "0" ? false : true;
        isPaymentIssues.value = vendor?.notifyPaymentIssues == "0" ? false : true;
        isLowStock.value = vendor?.notifyLowStock == "0" ? false : true;
        isOutOfStock.value = vendor?.notifyOutOfStock == "0" ? false : true;
        tableReservations.value = vendor?.notifyTableReservations == "0" ? false : true;
        isMenuItemRequests.value = vendor?.notifyMenuItemRequests == "0" ? false : true;
        isPushNotification.value = vendor?.pushNotifications == "0" ? false : true;
        isEmailNotification.value = vendor?.emailNotifications == "0" ? false : true;
        isSmsNotification.value = vendor?.smsNotifications == "0" ? false : true;
        selectedOrderN.value = vendor?.orderSummaryFrequency?.capitalizeFirst ?? "";
        selectedReviewN.value = vendor?.reviewNotificationFrequency?.capitalizeFirst  ?? "";
        selectedInventoryN.value = vendor?.inventoryAlertFrequency?.capitalizeFirst  ?? "";
        isEnableNotification.value = vendor?.doNotDisturb == "0" ? false : true;
        startTimeController.value.text =  vendor?.startTime?.substring(0, 5) ?? "";
        endTimeController.value.text =  vendor?.endTime?.substring(0, 5) ?? "";
        isQuietHours.value = vendor?.quietHours == "0" ? false : true;
        rxGetProfileRequestStatus(ApiStatus.COMPLETED);
        if (profileApiData.value.vendor?.step == '3' && (profileApiData.value.vendor?.status == 'suspended' || profileApiData.value.vendor?.status == 'inactive'|| profileApiData.value.vendor?.status == 'pending')) {
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
        } else {
          await closeAllDialogs();
        }
      }
    }).onError((error, stackTrace) {
      rxGetProfileRequestStatus(ApiStatus.ERROR);
      setError(error.toString());
      debugPrint('Error res notification controller: $error');
    },
  );
  }

  final Rx<ApiResponse<CommonResponseModel>> _createNotificationData = Rx<ApiResponse<CommonResponseModel>>(ApiResponse.completed(null));
  Rx<ApiResponse<CommonResponseModel>> get createNotificationData => _createNotificationData;
  setSettingNotification(ApiResponse<CommonResponseModel> data){
    _createNotificationData.value = data;
  }
  int boolToInt(bool value) => value ? 1 : 0;

  Future<void> updateNotificationSettings() async {
    setSettingNotification(ApiResponse.loading());
    var data  = {
      "do_not_disturb": boolToInt(isEnableNotification.value),
      "quiet_hours": boolToInt(isQuietHours.value),
      "start_time":startTimeController.value.text,
      "end_time": endTimeController.value.text,
      "notification_sounds": boolToInt(isSoundNotification.value),
      "notification_badges":boolToInt(isBadgeCount.value),

      "notify_new_orders": boolToInt(isNewOrder.value),
      "notify_order_updates": boolToInt(isOrderUpdates.value),
      "notify_payment_issues":boolToInt(isPaymentIssues.value),
      "notify_low_stock": boolToInt(isLowStock.value),
      "notify_out_of_stock":boolToInt(isOutOfStock.value),
      "notify_table_reservations": boolToInt(tableReservations.value),
      "notify_menu_item_requests": boolToInt(isMenuItemRequests.value),

      "push_notifications":boolToInt(isPushNotification.value),
      "email_notifications": boolToInt(isEmailNotification.value),
      "sms_notifications": boolToInt(isSmsNotification.value),

      "order_summary_frequency":selectedOrderN.value.toLowerCase(),
      "review_notification_frequency": selectedReviewN.value.toLowerCase(),
      "inventory_alert_frequency": selectedInventoryN.value.toLowerCase()
    };

    pt("data>>>>>>>>>> $data");

    api.notificationSettings(jsonEncode(data)).then((value) async{
      if(value.status == true){
        setSettingNotification(ApiResponse.completed(value));
        Utils.showToast(value.message ?? "");
        final profileController = Get.find<CommonProfileController>();
        await profileController.getProfileDetailsApi();
      }else{
        ApiResponse.error(value.message ?? "");
      }
    },).onError((error, stackTrace) {
      ApiResponse.error(error.toString() ?? "");
      setError(error.toString());
      debugPrint('Error: $error');
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