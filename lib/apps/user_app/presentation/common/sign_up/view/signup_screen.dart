import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:gyaawa/apps/user_app/presentation/common/sign_up/controller/sign_up_controller.dart';

import '../../../../../../Core/Constant/image_constant.dart';
import '../../../../../../Data/response/status.dart';
import '../../../../../../Utils/sized_box.dart';
import '../../../../../../routes/user_routes/user_app_routes.dart';
import '../../../../../../shared/theme/colors.dart';
import '../../../../../../shared/theme/font_family.dart';
import '../../../../../../shared/theme/font_style.dart';
import '../../../../../../shared/widgets/custom_appbar.dart';
import '../../../../../../shared/widgets/custom_text_form_field.dart';
import '../../../../../../shared/widgets/vendor_widgets/circular_progress_indicator.dart';
import '../../../../../../shared/widgets/vendor_widgets/custom_elevated_button.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final SignUpController signUpController = Get.find<SignUpController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Center(
                  child: SvgPicture.asset(ImageConstants.loginSvg, height: 450.h, width: 371.w),
                ),
                CustomAppBar(),
                Positioned(
                  top: 70,
                  left: 150,
                  right: 0,
                  child: Center(
                    child: Text('SIGN UP',
                        style: AppFontStyle.text_34_500(AppColors.black, fontFamily: AppFontFamily.interMedium)),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  hBox(20),
                  Text("Create your Account",
                      style: AppFontStyle.text_28_500(AppColors.black, fontFamily: AppFontFamily.interSemiBold)),
                  hBox(1),
                  Text(
                      "Enter your phone number to continue. We will send you a verification code",
                      maxLines: 2,
                      style: AppFontStyle.text_15_400(AppColors.greyLightColor,
                          fontFamily: AppFontFamily.interRegular)),
                  hBox(20),
                  Obx(() => Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: signUpController.setCustomer,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 14, horizontal: 16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: signUpController.selectedType.value == 'customer' ? AppColors.buttonColor : AppColors.greyLightColor,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      signUpController.selectedType.value == 'customer' ? Icons.check_circle : Icons.circle_outlined,
                                      color: signUpController.selectedType.value == 'customer' ? AppColors.buttonColor : AppColors.greyLightColor,
                                      size: 20,
                                    ),
                                    wBox(8),
                                    Text("Customer",
                                        style: AppFontStyle.text_15_400(
                                          signUpController.selectedType.value == 'customer' ? AppColors.blackTextColor :
                                          AppColors.greyLightColor, fontFamily: AppFontFamily.interRegular,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          wBox(12),
                          Expanded(
                            child: GestureDetector(
                              onTap: signUpController.setVendor,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 14, horizontal: 16),decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: signUpController.selectedType.value == 'vendor' ? AppColors.buttonColor : AppColors.greyLightColor,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      signUpController.selectedType.value == 'vendor'
                                          ? Icons.check_circle : Icons.circle_outlined,
                                      color: signUpController.selectedType.value == 'vendor' ? AppColors.buttonColor : AppColors.greyLightColor,
                                      size: 20,
                                    ),
                                    wBox(8),
                                    Text("Vendor",
                                        style: AppFontStyle.text_15_400(
                                          signUpController.selectedType.value == 'vendor' ? AppColors.blackTextColor : AppColors.greyLightColor, fontFamily: AppFontFamily.interRegular,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                  hBox(20),
                  Form(
                    key: signUpController.signUpFormKey,
                    child: Obx(() {
                      if (signUpController.selectedType.value == 'customer') {
                        return CustomTextFormField(
                          height: 52,
                          hintText: "Phone Number",
                          textInputType: TextInputType.phone,
                          prefixIcon: CountryCodePicker(
                            textStyle: AppFontStyle.text_15_400(
                                AppColors.greyTextColor, fontFamily: AppFontFamily.interRegular),
                            padding: const EdgeInsets.only(left: 10),
                            showFlag: false,
                            showDropDownButton: true,
                          ),
                        );
                      } else {
                        return Column(
                          children: [
                            CustomTextFormField(
                              controller: signUpController.emailController.value,
                              hintText: "Email",
                              validator: signUpController.validateEmail,
                              textInputType: TextInputType.emailAddress,
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(left: 18, right: 10),
                                child: Image.asset(
                                  ImageConstants.emailLogo, height: 19.h, width: 18.h, color: AppColors.hintText,
                                ),
                              ),
                            ),
                            hBox(16),
                            CustomTextFormField(
                              controller: signUpController.passwordController.value,
                              hintText: "Password",
                              validator: signUpController.validatePassword,
                              obscureText: signUpController.isShowPassword.value,
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(left: 18, right: 10),
                                child: Image.asset(
                                  ImageConstants.lockLogo,
                                  height: 14.h,
                                  width: 14.h,
                                  color: AppColors.hintText,
                                ),
                              ),
                              suffix: GestureDetector(
                                onTap: () {
                                  signUpController.togglePasswordVisibility();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: Icon(
                                    signUpController.isShowPassword.value ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                    color: AppColors.hintText,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                            hBox(16),
                            CustomTextFormField(
                              controller: signUpController.confirmPasswordController.value,
                              hintText: "Confirm Password",
                              validator: signUpController.validateConfirmPassword,
                               obscureText: signUpController.isShowConfirmPassword.value,
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(left: 18, right: 10),
                                child: Image.asset(
                                  ImageConstants.lockLogo,
                                  height: 14.h, width: 14.h,
                                  color: AppColors.hintText,
                                ),
                              ),
                              suffix: GestureDetector(
                                onTap: () {
                                  signUpController.togglePasswordVisibility(isConfirmPassword: true);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: Icon(
                                    signUpController.isShowConfirmPassword.value ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                    color: AppColors.hintText,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }),
                  ),

                  hBox(20),
                  // CustomElevatedButton(
                  //   color: AppColors.buttonColor,
                  //   height: 52,
                  //   text: "Sign Up",
                  //   textStyle: AppFontStyle.text_18_600(AppColors.white,
                  //       fontFamily: AppFontFamily.interSemiBold),
                  //   onPressed: () {
                  //     Get.toNamed(UserRoutes.verifyScreen);
                  //   },
                  // ),
                  Obx(() => CustomElevatedButton(
                    height: 52,
                    onPressed: () {
                      if (signUpController.rxRequestStatus.value == ApiStatus.LOADING) return;
                      if (signUpController.signUpFormKey.currentState!.validate()) {
                        signUpController.vendorSignUpApi();
                      }
                    },
                    child: signUpController.rxRequestStatus.value == ApiStatus.LOADING
                        ? circularProgressIndicator(size: 30, color: Colors.white,)
                        : Text(
                      "Sign Up",
                      style: AppFontStyle.text_18_600(
                        AppColors.white,
                        fontFamily: AppFontFamily.interSemiBold,
                      ),
                    ),
                  )),
                  hBox(20),
                  InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () => Get.toNamed(UserRoutes.loginScreen),
                    child: Align(
                      alignment: Alignment.center,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Already have an account?  ",
                              style: AppFontStyle.text_16_400(
                                  AppColors.greyLightColor,
                                  fontFamily: AppFontFamily.onestRegular),
                            ),
                            TextSpan(
                              text: "Log In",
                              style: AppFontStyle.text_16_400(
                                  AppColors.blackTextColor,
                                  fontFamily: AppFontFamily.onestRegular),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  hBox(20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
