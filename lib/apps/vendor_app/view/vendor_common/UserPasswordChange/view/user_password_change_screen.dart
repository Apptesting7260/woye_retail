import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../Core/Constant/image_constant.dart';
import '../../../../../../Data/response/status.dart';
import '../../../../../../Utils/sized_box.dart';
import '../../../../../../Utils/validation.dart';
import '../../../../../../shared/theme/colors.dart';
import '../../../../../../shared/theme/font_family.dart';
import '../../../../../../shared/theme/font_style.dart';
import '../../../../../../shared/widgets/custom_appbar.dart';
import '../../../../../../shared/widgets/custom_elevated_button.dart';
import '../../../../../../shared/widgets/vendor_widgets/custom_text_form_field.dart';
import '../controller/user_password_change_controller.dart';

class UserPasswordChangeScreen extends StatelessWidget {
  UserPasswordChangeScreen({super.key});

  final UserPasswordChangeController controller =
      Get.put(UserPasswordChangeController());

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: CustomAppBar(
            title: Text("Change Password",
                style: AppFontStyle.text_20_600(AppColors.darkText,
                    fontFamily: AppFontFamily.gilroyRegular)),
          ),
          body: Form(
            key:controller.formKey,
            child: Padding(
              padding: REdgeInsets.symmetric(horizontal: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  oldPasswordFormField(),
                  hBox(15.h),
                  _passwordFormField(),
                  hBox(15.h),
                  _confirmPasswordFormField(),
                  hBox(25.h),
                  Obx(
                    ()=> CustomElevatedButton(
                      isLoading: controller.rxRequestStatus.value == ApiStatus.LOADING,
                      onPressed: () {
                        // controller.isNewPassRedClr.value = true;
                        // controller.isConfirmPassRedClr.value = true;
                        // controller.isOldPassRedClr.value = true;
                        if(controller.formKey.currentState?.validate() ?? false){
                          controller.updatePassword(context);
                        }
                      },
                      text: "Save Password",
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _passwordFormField() {
    return Obx(
      () => CustomTextFormField(
        controller: controller.passwordController.value,
        hintText: 'New Password',
        obscureText: controller.isShowPassword.value,
        // // errorTextStyle: AppFontStyle.text_12_400(
        //   controller.isNewPassRedClr.value ? AppColors.red :AppColors.darkText,
        //   fontFamily: AppFontFamily.gilroyMedium,
        // ),
        // onTap: (){
        //   controller.isNewPassRedClr.value = false;
        // },
        validator: (value) {
          return validateStrongPassword(value!);
        },
        prefix: Padding(
          padding: const EdgeInsets.only(left: 18, right: 10),
          child: Image.asset(
            ImageConstants.lockLogo,
            height: 18.h,
            width: 16.h,
            color: AppColors.hintText,
          ),
        ),
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
    );
  }

  oldPasswordFormField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
              () => CustomTextFormField(
            controller: controller.oldPasswordController.value,
            hintText: 'Old Password',
            obscureText: controller.isShowOldPassword.value,
            // errorTextStyle: AppFontStyle.text_12_400(
            //   controller.isOldPassRedClr.value ? AppColors.red : AppColors.darkText,
            //   fontFamily: AppFontFamily.gilroyMedium,
            // ),
            // onTap: () {
            //   controller.isOldPassRedClr.value = false;
            //   controller.apiData.value.message?.isEmpty;
            // },
            validator: (value) {
              if (value == "" || value!.isEmpty) {
                return "Please enter old password";
              }
              return null;
            },
            prefix: Padding(
              padding: const EdgeInsets.only(left: 18, right: 10),
              child: Image.asset(
                ImageConstants.lockLogo,
                height: 18.h,
                width: 16.h,
                color: AppColors.hintText,
              ),
            ),
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
        // hBox(8.h),
        // Text(
        //   "Forgot Password",
        //   style: AppFontStyle.text_16_400(
        //     AppColors.primary,
        //     fontFamily: AppFontFamily.gilroyMedium,
        //   ),
        // ),
      ],
    );
  }


  _confirmPasswordFormField() {
    return Obx(
      () => CustomTextFormField(
        controller:
        controller.confirmPasswordController.value,
        hintText: 'Confirm Password',
        obscureText: controller.isShowConfirmPassword.value,
        // errorTextStyle: AppFontStyle.text_12_400(
        //   controller.isConfirmPassRedClr.value ? AppColors.red :AppColors.darkText,
        //   fontFamily: AppFontFamily.gilroyMedium,
        // ),
        // onTap: (){
        //   controller.isConfirmPassRedClr.value = false;
        // },
        validator: (value) {
          return controller.validateConfirmPassword(value);
        },
        prefix: Padding(
          padding: const EdgeInsets.only(left: 18, right: 10),
          child: Image.asset(
            ImageConstants.lockLogo,
            height: 18.h,
            width: 16.h,
            color: AppColors.hintText,
          ),
        ),
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
    );
  }

  Widget header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Change Password",
          style: TextStyle(
            fontSize: 28.sp,
            fontFamily: AppFontFamily.gilroySemiBold,
            fontWeight: FontWeight.w500,
            color: AppColors.darkText,
          ),
        ),
        hBox(9.h),
        Text(
          "Your new password must be different from\nthe previously used password",
          style: AppFontStyle.text_16_400(
            AppColors.mediumText,
            fontFamily: AppFontFamily.gilroyRegular,
          ),
        ),
      ],
    );
  }
}
