import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../../../../Data/response/status.dart';
import '../../../../../../../../../Utils/account_type_card.dart';
import '../../../../../../../../../Utils/sized_box.dart';
import '../../../../../../../../../Utils/validation.dart';
import '../../../../../../../../../shared/theme/colors.dart';
import '../../../../../../../../../shared/theme/font_family.dart';
import '../../../../../../../../../shared/theme/font_style.dart';
import '../../../../../../../../../shared/widgets/custom_appbar.dart';
import '../../../../../../../../../shared/widgets/vendor_widgets/app_container.dart';
import '../../../../../../../../../shared/widgets/vendor_widgets/custom_elevated_button.dart';
import '../../../../../../../../../shared/widgets/vendor_widgets/custom_no_result_found.dart';
import '../../../../../../../../../shared/widgets/vendor_widgets/custom_switch_btn.dart';
import '../../../../../../../../../shared/widgets/vendor_widgets/custom_text_form_field.dart';
import '../../RestaurantInformation/view/restaurant_information_screen.dart';
import '../controller/res_security_settings_controller.dart';

class ResSecuritySettingsScreen extends GetView<ResSecuritySettingsController> {
  const ResSecuritySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: body(),
    );
  }

  Widget body() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            header(
              title: "Security Settings",
              description: "Configure security settings and authentication options",
            ),
            hBox(16),
            accountSecurity(),
            Divider(
              height: 40,
              color: AppColors.borderClr.withAlpha(150),
            ),
            Text("Two-Factor Authentication",style: AppFontStyle.text_18_500(AppColors.blackClr,fontFamily: AppFontFamily.gilroySemiBold),),
            hBox(12),
            twoFactorAuthentication(),
            Divider(
              height: 40,
              color: AppColors.borderClr.withAlpha(150),
            ),
            Text("Recent Login Activity",style: AppFontStyle.text_18_500(AppColors.blackClr,fontFamily: AppFontFamily.gilroySemiBold),),
            hBox(12),
            (controller.fillRestaurantDetailsController.profileApiData.value.loginActivities?.isEmpty ?? false) ?
            CustomNoResultFound(heightBox: hBox(0)) :
            recentLoginActivity(),
            hBox(24),
            accountTypeCard(),
            hBox(24),
            Obx(
              ()=> controller.isAccountant || controller.isServiceStaff || controller.isKitchenStaff ? const SizedBox.shrink() : CustomElevatedButton(
                  isLoading: controller.userDetailsData.value.status == ApiStatus.LOADING,
                  onPressed: (){
                controller.twoFactorAuthenticationApi(
                  twoFaSms: controller.authList[0]['isEnabled'] ? "1" : "0",
                  twoFaApp: controller.authList[1]['isEnabled'] ? "1" : "0",
                );
              },text: "Save Changes"),
            ),

            hBox(10),
          ],
        ),
      ),
    );
  }

  Widget recentLoginActivity() {
    final activities = controller.fillRestaurantDetailsController
        .profileApiData.value.loginActivities;

    if (activities == null || activities.isEmpty) {
      return const SizedBox.shrink();
    }

    return Obx(() {
      int totalLength = activities.length;
      int visibleCount = controller.visibleItemsCount.value;

      // Ensure we don’t exceed total length
      int itemCount = visibleCount > totalLength ? totalLength : visibleCount;

      return Column(
        children: [
          ListView.separated(
            separatorBuilder: (context, index) => hBox(14),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: itemCount,
            itemBuilder: (context, index) {
              final activityData = activities[index];

              return AppContainer(
                radius: 12,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activityData.device ?? "",
                          style: AppFontStyle.text_16_400(
                            AppColors.blackClr,
                            fontFamily: AppFontFamily.gilroyMedium,
                          ),
                        ),
                        hBox(1),
                        Text(
                          activityData.location ?? "",
                          style: AppFontStyle.text_14_400(
                            AppColors.greyClr,
                            fontFamily: AppFontFamily.gilroyMedium,
                          ),
                        ),
                        hBox(1),
                        Text(
                          activityData.time ?? "",
                          style: AppFontStyle.text_14_400(
                            AppColors.greyClr,
                            fontFamily: AppFontFamily.gilroyMedium,
                          ),
                        ),
                      ],
                    ),
                    AppContainer(
                      radius: 24,
                      boxShadow: const [],
                      color: activityData.status == "Success"
                          ? AppColors.blueClr.withAlpha(44)
                          : activityData.status == "Current"
                          ? AppColors.primary.withAlpha(44)
                          : activityData.status == "Blocked"
                          ? AppColors.red.withAlpha(44)
                          : AppColors.greenLightClr.withAlpha(44),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      child: Text(
                        activityData.status ?? "",
                        style: AppFontStyle.text_12_400(
                          activityData.status == "Success"
                              ? AppColors.blueClr
                              : activityData.status == "Current"
                              ? AppColors.primary
                              : activityData.status == "Blocked"
                              ? AppColors.red
                              : AppColors.greenLightClr,
                          fontFamily: AppFontFamily.gilroyMedium,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          /// 🔽 See More / See Less Button
          if (totalLength > 5)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// 🔽 See Less (LEFT)
                  if (visibleCount > 5)
                    TextButton(
                      onPressed: () {
                        int newValue = controller.visibleItemsCount.value - 5;
                        controller.visibleItemsCount.value =
                        newValue < 5 ? 5 : newValue;
                      },
                      child: const Text(
                        "See Less",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    )
                  else
                    const SizedBox(), // keep spacing

                  /// 🔼 See More (RIGHT)
                  if (visibleCount < totalLength)
                    TextButton(
                      onPressed: () {
                        controller.visibleItemsCount.value += 5;
                      },
                      child: const Text(
                        "See More",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    )
                  else
                    const SizedBox(), // keep spacing
                ],
              ),
            )
        ],
      );
    });
  }
/*
  Widget recentLoginActivity() {
    return (controller.fillRestaurantDetailsController.profileApiData.value.loginActivities?.isEmpty ?? false)
    ? const SizedBox.shrink() : ListView.separated(
      separatorBuilder: (context, index) => hBox(14),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: controller.fillRestaurantDetailsController.profileApiData.value.loginActivities?.length ?? 0,
      itemBuilder: (context, index) {
      final activityData = controller.fillRestaurantDetailsController.profileApiData.value.loginActivities?[index];
      return AppContainer(
        radius: 12,
        padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(activityData?.device ?? "",style: AppFontStyle.text_16_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroyMedium),),
                hBox(1),
                Text(activityData?.location ?? "",style: AppFontStyle.text_14_400(AppColors.greyClr,fontFamily: AppFontFamily.gilroyMedium),),
                hBox(1),
                Text(activityData?.time ?? "",style: AppFontStyle.text_14_400(AppColors.greyClr,fontFamily: AppFontFamily.gilroyMedium),),
              ],
            ),
            AppContainer(
              radius: 24,
              boxShadow: const [],
              color:activityData?.status == "Success" ?  AppColors.blue.withAlpha(44) :
              activityData?.status == "Current" ? AppColors.primary.withAlpha(44)  :
              activityData?.status == "Blocked" ? AppColors.red.withAlpha(44) :
              AppColors.greenLight.withAlpha(44),
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 4),
              child: Text(activityData?.status ?? "",
                  style: AppFontStyle.text_12_400(
                  activityData?.status == "Success" ?  AppColors.blue :
                  activityData?.status == "Current" ? AppColors.primary :
                  activityData?.status == "Blocked" ? AppColors.red :
                  AppColors.greenLight,fontFamily: AppFontFamily.gilroyMedium)),
            ),
          ],
        ),
      );
    },);
  }
*/

  Widget twoFactorAuthentication() {
    return Obx(() {
      return ListView.separated(
        separatorBuilder: (context, index) => hBox(14),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.authList.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {

          final item = controller.authList[index];

          return IgnorePointer(
            ignoring: controller.isAccountant || controller.isServiceStaff || controller.isKitchenStaff ? true : false,
            child: AppContainer(
              radius: 12,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['title'],
                            style: AppFontStyle.text_15_400(
                                AppColors.blackClr,
                                fontFamily: AppFontFamily.gilroyMedium)),
                        hBox(4),
                        Text(item['des'],
                            maxLines: 2,
                            style: AppFontStyle.text_12_400(
                                AppColors.greyClr,
                                fontFamily: AppFontFamily.gilroyMedium)),
                      ],
                    ),
                  ),

                  Row(
                    children: [
                      Text(
                        item['isEnabled'] ? "Enabled" : "Disabled",
                        style: AppFontStyle.text_13_400(
                          item['isEnabled'] ? AppColors.primary : AppColors.greyClr,
                          fontFamily: AppFontFamily.gilroyMedium,
                        ),
                      ),
                      wBox(5),

                      CustomWideSwitch(
                        width: 44,
                        height: 24,
                        value: item['isEnabled'],
                        activeColor: AppColors.primary,
                        onChanged: (bool newValue) {
                          controller.toggleAuth(index, newValue);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }


  Widget accountSecurity() {
    return Form(
      key: controller.formKey,
      child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Account Security",style: AppFontStyle.text_18_500(AppColors.blackClr,fontFamily: AppFontFamily.gilroySemiBold),),
                hBox(12),
                title("Current Password"),
                hBox(5),
                Obx(
                      () => CustomTextFormField(
                        key: controller.currentPassKey,
                    controller: controller.oldPasswordController.value,
                    hintText: 'Enter current password',
                    obscureText: controller.isShowOldPassword.value,
                        onChanged: (value){
                          controller.passwordError("");
                        },
                    validator: (value) {
                      if (value == "" || (value?.isEmpty ?? false)) {
                        return "Please enter current password";
                      }
                      if (controller.passwordError.value!= "" ) {
                        return controller.passwordError.value;
                      }
                      return null;
                    },
                    suffix: IconButton(
                      onPressed: () {
                        controller.isShowOldPassword.value = !controller.isShowOldPassword.value;
                      },
                      icon: Icon(
                        controller.isShowOldPassword.value
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.hintText,
                      ),
                    ),
                  ),
                ),
                hBox(14),
                title("New Password"),
                hBox(5),
                Obx(
                      () => CustomTextFormField(
                        key: controller.newPassKey,

                        controller: controller.passwordController.value,
                    hintText: 'Enter new password',
                    obscureText: controller.isShowPassword.value,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter New Password ';
                      }
                      return validateStrongPassword(value ?? "");
                    },
                    suffix: IconButton(
                      onPressed: () {
                        controller.togglePasswordVisibility();
                      },
                      icon: Icon(
                        controller.isShowPassword.value
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.hintText,
                      ),
                    ),
                  ),
                ),
                hBox(14),
                title("Confirm New Password"),
                hBox(5),
                Obx(
                      () => CustomTextFormField(
                        key: controller.confirmNewPassKey,
                        controller:
                    controller.confirmPasswordController.value,
                    hintText: 'Re-enter new password',
                    obscureText: controller.isShowConfirmPassword.value,
                    validator: (value) {
                      return controller.validateConfirmPassword(value);
                    },
                    suffix: IconButton(
                      onPressed: () {
                        controller.togglePasswordVisibility(isConfirmPassword: true);
                      },
                      icon: Icon(
                        controller.isShowConfirmPassword.value
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.hintText,
                      ),
                    ),
                  ),
                ),
                hBox(16),
                Obx(
                  ()=> CustomElevatedButton(
                    isLoading: controller.rxRequestStatus.value == ApiStatus.LOADING,
                    height: 56,
                    onPressed: () {
                      final oldPass = controller.oldPasswordController.value.text;
                      final newPass = controller.passwordController.value.text;
                      final confirmPass = controller.confirmPasswordController.value.text;

                      if (oldPass.isEmpty) {
                        controller.scrollToFields(controller.currentPassKey);
                        controller.formKey.currentState?.validate();
                        return;
                      }

                      final strongError = validateStrongPassword(newPass);
                      if (newPass.isEmpty || strongError != null) {
                        controller.scrollToFields(controller.newPassKey);
                        controller.formKey.currentState?.validate();
                        return;
                      }

                      if (confirmPass.isEmpty) {
                        controller.scrollToFields(controller.confirmNewPassKey);
                        controller.formKey.currentState?.validate();
                        return;
                      }

                      if (confirmPass != newPass) {
                        controller.scrollToFields(controller.confirmNewPassKey);
                        controller.formKey.currentState?.validate();
                        return;
                      }

                      if (controller.formKey.currentState?.validate() ?? false) {
                        controller.updatePassword(Get.context!);
                      }
                    },
                    text: "Update Password",
                  ),
                )
              ],
            ),
    );
  }

  Text title(title) {
    return Text(
      title,
      style: AppFontStyle.text_16_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroySemiBold),
    );
  }

}
