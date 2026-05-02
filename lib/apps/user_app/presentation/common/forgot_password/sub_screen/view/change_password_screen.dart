import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gyaawa/apps/user_app/presentation/common/forgot_password/sub_screen/controller/change_password_controller.dart';
import 'package:gyaawa/shared/widgets/image.dart';

import '../../../../../../../Core/Constant/image_constant.dart';
import '../../../../../../../Data/response/status.dart';
import '../../../../../../../Utils/sized_box.dart';
import '../../../../../../../routes/user_routes/user_app_routes.dart';
import '../../../../../../../shared/theme/colors.dart';
import '../../../../../../../shared/theme/font_family.dart';
import '../../../../../../../shared/theme/font_style.dart';
import '../../../../../../../shared/widgets/custom_appbar.dart';
import '../../../../../../../shared/widgets/custom_elevated_button.dart';
import '../../../../../../../shared/widgets/custom_text_form_field.dart';
import '../../../../../../../shared/widgets/vendor_widgets/circular_progress_indicator.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final ChangePasswordController controller = Get.put (ChangePasswordController());
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            Stack(
              children: [
                Center(
                  child: AppImage(
                   path:ImageConstants.loginSvg,
                    height: 450.h,
                    width: 371.w,
                  ),
                ),
                CustomAppBar(),
                Positioned(
                  top: 70,
                  left: 150,
                  right: 0,
                  child: Center(
                    child: Text(
                      'NEW PASSWORD',
                      style: AppFontStyle.text_24_500(
                        AppColors.black,
                        fontFamily: AppFontFamily.interMedium,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    hBox(20),
                    Text(
                      "Create a new password for your account",
                      textAlign: TextAlign.center,
                      style: AppFontStyle.text_15_400(
                        AppColors.greyLightColor,
                        fontFamily: AppFontFamily.interRegular,
                      ),
                    ),
                    hBox(30),
                    Obx(() => CustomTextFormField(
                      hintText: "New Password",
                      controller: controller.newPasswordController,
                      obscureText: controller.isShowNewPass.value,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 18, right: 10),
                        child: Image.asset(
                          ImageConstants.lockLogo,
                          height: 14.h, width: 14.h,
                          color: AppColors.hintText,
                        ),
                      ),
                      suffix: InkWell(
                        onTap: () {
                          controller.isShowNewPass.value =
                          !controller.isShowNewPass.value;
                        },
                        child: Icon(
                          controller.isShowNewPass.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.hintText,
                          size: 20,
                        ),
                      ),
                      validator:controller.validatePassword,
                    )),
                    hBox(10),
                    Obx(() => CustomTextFormField(
                      hintText: "Confirm Password",
                      controller: controller.confirmPasswordController,
                      obscureText: controller.isShowConfirmPass.value,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 18, right: 10),
                        child: Image.asset(
                          ImageConstants.lockLogo,
                          height: 10.h, width: 10.h,
                          color: AppColors.hintText,
                        ),
                      ),
                      suffix: InkWell(
                        onTap: () {
                          controller.isShowConfirmPass.value =
                          !controller.isShowConfirmPass.value;
                        },
                        child: Icon(
                          controller.isShowConfirmPass.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.hintText,
                          size: 20,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Confirm your password";
                        }
                        if (value != controller.newPasswordController.text) {
                          return "Password not matched";
                        }
                        return null;
                      },
                    )),
                    hBox(30),
                    Obx(() => CustomElevatedButton(
                      height: 52,
                      onPressed: () {
                        if (controller.rxRequestStatus.value == ApiStatus.LOADING) return;

                        if (controller.formKey.currentState!.validate()) {
                          controller.changePasswordApi();
                        }
                      },
                      child: controller.rxRequestStatus.value == ApiStatus.LOADING
                          ? circularProgressIndicator(color: Colors.white, size: 30)
                          : Text(
                        "Change Password",
                        style: AppFontStyle.text_18_600(
                          AppColors.white,
                          fontFamily: AppFontFamily.interSemiBold,
                        ),
                      ),
                    )),
                    hBox(20),
                    InkWell(
                      onTap: () => Get.offAllNamed(UserRoutes.loginScreen),
                      child: Text(
                        "Back to Login",
                        style: AppFontStyle.text_16_400(
                          AppColors.buttonColor,
                          fontFamily: AppFontFamily.interRegular,
                        ),
                      ),
                    ),
                    hBox(20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}