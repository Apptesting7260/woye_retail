import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../Core/Constant/image_constant.dart';
import '../../../../../../../../Data/components/general_exception.dart';
import '../../../../../../../../Data/components/internet_exception.dart';
import '../../../../../../../../Data/response/status.dart';
import '../../../../../../../../Utils/sized_box.dart';
import '../../../../../../../../shared/theme/colors.dart';
import '../../../../../../../../shared/theme/font_family.dart';
import '../../../../../../../../shared/theme/font_style.dart';
import '../../../../../../../../shared/widgets/custom_appbar.dart';
import '../../../../../../../../shared/widgets/shimmer_widget.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/app_container.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/custom_dropdown.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/custom_elevated_button.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/custom_switch_btn.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/custom_text_form_field.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/image.dart';
import '../controller/res_notification_settings_controller.dart';

class ResNotificationSettingsScreen extends GetView<ResNotificationSettingController> {
  const ResNotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {  
    return Scaffold(
      appBar: appbar(),
      body: Obx(
        () {
         switch(controller.rxGetProfileRequestStatus.value){
           case ApiStatus.LOADING :
            return shimmerGeneral();
           case ApiStatus.ERROR:
             if (controller.error.value == 'No internet' || controller.error.value == 'InternetExceptionWidget') {
               return InternetExceptionWidget(
                 onPress: () {
                   controller.getProfileDetailsApi();
                 },
               );
             } else {
               return  GeneralExceptionWidget(
                 onPress: () {
                   controller.getProfileDetailsApi();
                 },
               );
             }
           case ApiStatus.COMPLETED :
             return body();
           }
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(
            ()=> CustomElevatedButton(
            isLoading: controller.createNotificationData.value.status == ApiStatus.LOADING,
              onPressed: (){
              if(controller.isQuietHours.value){
                if(controller.formKey.currentState?.validate() ?? false){
                  controller.updateNotificationSettings();
                }else{
                  controller.updateSelectedType(0);
                  controller.formKey.currentState?.validate();
                }
              }
              else {
                controller.updateNotificationSettings();
              }
              },
              text: "Save Settings",
            ),
        ),
      ),
    );
  }

  Widget body() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            catButton(),
            hBox(18),
            Expanded(
              child: controller.selectedTypeIndex.value == 0 ?
              general() :
              controller.selectedTypeIndex.value == 1 ?
              alertWidget() :
              controller.selectedTypeIndex.value == 2 ?
              channels() :
              controller.selectedTypeIndex.value == 3 ?
              schedule() : const SizedBox.shrink(),
            ),
          ],
        ),
      );
  }

  Widget schedule() {
    return RefreshIndicator(
      onRefresh: () => controller.getProfileDetailsApi(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Obx(
          ()=> Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              title("Order Notification Frequency"),
              hBox(4),
               CustomDropDown(
                  btnHeight: 56,
                  items:controller.orderNotificationFrequencyList,
                  selectedValue: controller.selectedOrderN.value,
                  onChanged: (val){
                    controller.selectedOrderN.value = val ?? "";
                  },
                  iconSize: 26,
                ),
              hBox(16),
              title("Review Notification Frequency"),
              hBox(4),
              CustomDropDown(
                btnHeight: 56,
                items: controller.reviewNotificationFrequencyList,
                selectedValue: controller.selectedReviewN.value,
                onChanged: (val){
                  controller.selectedReviewN.value = val ?? "";
                },
                iconSize: 26,
              ),
              hBox(16),
              title("Inventory Alert Frequency"),
              hBox(4),
              CustomDropDown(
                btnHeight: 56,
                items: controller.inventoryNotificationFrequencyList,
                selectedValue: controller.selectedInventoryN.value,
                onChanged: (val){
                  controller.selectedInventoryN.value = val ?? "";
                },
                iconSize: 26,
              ),
              hBox(16),
            ],
          ),
        ),
      ),
    );
  }

   channels() {
    return RefreshIndicator(
      onRefresh: () => controller.getProfileDetailsApi(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            switchBtn(image: ImageConstants.notificaitonNew,onChanged: (val){controller.isPushNotification.value = val;}, titleText: "Push Notifications", subtitle: "In-app and browser notifications", value: controller.isPushNotification.value),
            hBox(12),
            switchBtn(image: ImageConstants.emailOutlined,onChanged: (val){controller.isEmailNotification.value = val;}, titleText: "Email Notifications", subtitle: "Notifications sent to your email", value: controller.isEmailNotification.value),
            hBox(12),
            switchBtn(image: ImageConstants.mobile,onChanged: (val){controller.isSmsNotification.value = val;}, titleText: "SMS Notifications", subtitle: "Text messages to your phone", value: controller.isSmsNotification.value),
            hBox(12),
          ],
        ),
      ),
    );
  }

  alertWidget() {
    return RefreshIndicator(
      onRefresh: () => controller.getProfileDetailsApi(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Order Notifications",style: AppFontStyle.text_16_400(AppColors.lightBlackClr,fontFamily: AppFontFamily.gilroySemiBold)),
            hBox(8),
            switchBtn(onChanged: (val){controller.isNewOrder.value = val;}, titleText: "New Orders", subtitle: "Notify when new orders are received", value: controller.isNewOrder.value),
            hBox(12),
            switchBtn(onChanged: (val){controller.isOrderUpdates.value = val;}, titleText: "Order Updates", subtitle: "Status changes and customer updates", value:  controller.isOrderUpdates.value),
            hBox(12),
            switchBtn(onChanged: (val){controller.isPaymentIssues.value = val;}, titleText: "Payment Issues", subtitle: "Failed payments and refund requests", value:  controller.isPaymentIssues.value),
            hBox(14),
            Text("Inventory Alerts",style: AppFontStyle.text_16_400(AppColors.lightBlackClr,fontFamily: AppFontFamily.gilroySemiBold)),
            hBox(8),
            switchBtn(onChanged: (val){controller.isLowStock.value = val;}, titleText: "Low Stock", subtitle: "Items running low on inventory", value:  controller.isLowStock.value),
            hBox(12),
            switchBtn(onChanged: (val){controller.isOutOfStock.value = val;}, titleText: "Out of Stock", subtitle: "Items completely out of stock", value:  controller.isOutOfStock.value),
            hBox(14),
            Text("Business-Specific Alerts",style: AppFontStyle.text_16_400(AppColors.lightBlackClr,fontFamily: AppFontFamily.gilroySemiBold)),
            hBox(8  ),
            switchBtn(onChanged: (val){controller.tableReservations.value = val;}, titleText: "Table Reservations", subtitle: "Items running low on inventory", value:  controller.tableReservations.value),
            hBox(12),
            switchBtn(onChanged: (val){controller.isMenuItemRequests.value = val;}, titleText: "Menu Item Requests", subtitle: "Customer requests for unavailable items", value:  controller.isMenuItemRequests.value),
          ],
        ),
      ),
    );
  }

  Widget general() {
    return RefreshIndicator(
      onRefresh: () => controller.getProfileDetailsApi(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Obx(
          ()=> Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                switchBtn(onChanged: (val){
                  controller.isEnableNotification.value = val;
                }, titleText: "Enable Notifications", subtitle: "Turn all notifications on or off", value: controller.isEnableNotification.value),
                hBox(12),
                switchBtn(onChanged: (val){
                  controller.isQuietHours.value = val;
                  if(val == false){
                    controller.startTimeController.value.clear();
                    controller.endTimeController.value.clear();
                  }
                },
                titleText: "Quiet Hours", subtitle: "Reduce notifications during specified hours", value: controller.isQuietHours.value),
                if(controller.isQuietHours.value)...[
                hBox(12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Start Time
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        title("Start Time"),
                        hBox(2),
                        SizedBox(
                          width: Get.width * 0.42,
                          child: CustomTextFormField(
                            controller: controller.startTimeController.value,
                            readOnly: true,
                            suffix: const Icon(Icons.access_time_rounded, size: 25),
                            hintText: "--:--",
                            onTap: () async {
                              final now = TimeOfDay.now();

                              final pickedTime = await showTimePicker(
                                context: Get.context!,
                                initialTime: now,
                                builder: (context, child) => MediaQuery(
                                  data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                                  child: child!,
                                ),
                              );

                              if (pickedTime != null) {
                                final formatted =
                                    '${pickedTime.hour.toString().padLeft(2,'0')}:${pickedTime.minute.toString().padLeft(2,'0')}';
                                controller.startTimeController.value.text = formatted;

                                // Optional: reset end time to force user to pick again if start changes
                                controller.endTimeController.value.text = '';
                              }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) return "Please select start time";
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),

                    wBox(10),

                    // End Time
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        title("End Time"),
                        hBox(2),
                        SizedBox(
                          width: Get.width * 0.42,
                          child: CustomTextFormField(
                            controller: controller.endTimeController.value,
                            readOnly: true,
                            suffix: const Icon(Icons.access_time_rounded, size: 25),
                            hintText: "--:--",
                            onTap: () async {
                              final now = TimeOfDay.now();

                              final pickedTime = await showTimePicker(
                                context: Get.context!,
                                initialTime: now,
                                builder: (context, child) => MediaQuery(
                                  data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                                  child: child!,
                                ),
                              );

                              if (pickedTime != null) {
                                final formatted =
                                    '${pickedTime.hour.toString().padLeft(2,'0')}:${pickedTime.minute.toString().padLeft(2,'0')}';
                                controller.endTimeController.value.text = formatted;

                                // Trigger validation
                                controller.endTimeController.refresh();
                              }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) return "Please select end time";

                              final startText = controller.startTimeController.value.text;
                              if (startText.isEmpty) return null;

                              final startParts = startText.split(':');
                              final startHour = int.parse(startParts[0]);
                              final startMin = int.parse(startParts[1]);

                              final endParts = value.split(':');
                              final endHour = int.parse(endParts[0]);
                              final endMin = int.parse(endParts[1]);

                              if (endHour < startHour || (endHour == startHour && endMin <= startMin)) {
                                return "End time must be after start time";
                              }

                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                ],
                hBox(12),
                switchBtn(onChanged: (val){
                  controller.isSoundNotification.value = val;
                }, titleText: "Sound Notifications", subtitle: "Play sound for new notifications", value: controller.isSoundNotification.value),
                hBox(12),
                switchBtn(onChanged: (val){
                  controller.isBadgeCount.value = val;
                }, titleText: "Badge Count", subtitle: "Show notification count on app icon", value: controller.isBadgeCount.value),
              ],
            ),
          ),
        ),
      ),
    );
  }


  switchBtn({String? image,required void Function(bool) onChanged,required String titleText,required String subtitle,required bool value}){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if(image?.isNotEmpty ?? false)...[
        AppImage(path: image ?? "",height: 18,width: 15,svgColor: ColorFilter.mode(AppColors.greyClr, BlendMode.srcIn)),
        wBox(10),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              title(titleText),
              Padding(
                padding: const EdgeInsets.only(right: 12.0,top: 2),
                child: Text(subtitle,maxLines:3,style: AppFontStyle.text_14_400(AppColors.greyClr,fontFamily: AppFontFamily.gilroyMedium)),
              ),
            ],
          ),
        ),
        CustomWideSwitch(onChanged:onChanged,value: value,width: 44,height: 26,activeColor: AppColors.primary),
      ],
    );
  }

  Text title(title) => Text(title,style: AppFontStyle.text_16_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroySemiBold));

  Widget catButton() {
    return AppContainer(
      boxShadow: const [],
      radius: 100,
      color: AppColors.whiteShadow,
      width: Get.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            controller.btnName.length,
                (index) => Obx(
                  () => InkWell(
                onTap: () {
                  controller.updateSelectedType(index);
                },
                child: AppContainer(
                  color: controller.selectedTypeIndex.value == index ? AppColors.white : AppColors.transparent,
                  radius: 100,
                  boxShadow: const [],
                  padding: const EdgeInsets.symmetric(horizontal:12, vertical: 6),
                  child: Text(controller.btnName[index], style: AppFontStyle.text_14_400(AppColors.blackClr, fontFamily: AppFontFamily.gilroySemiBold)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  appbar() {
    return CustomAppBar(
      title: Text(
        "Notification Settings",
        style: AppFontStyle.text_22_400(AppColors.darkText,
            fontFamily: AppFontFamily.gilroySemiBold),
      ),
    );
  }

  Widget shimmerGeneral() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: RefreshIndicator(
        onRefresh: () async {},
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(5, (index) {
              return Padding(
                padding: EdgeInsets.only(top: index == 0 ? 0 : 14),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withAlpha(60),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const ShimmerBox(width: 150, height: 20, radius: 5),
                            hBox(6),
                            const ShimmerBox(width: 200, height: 16, radius: 5),
                          ],
                        ),
                      ),
                      wBox(10),
                      const ShimmerBox(width: 48, height: 28, radius: 14),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
