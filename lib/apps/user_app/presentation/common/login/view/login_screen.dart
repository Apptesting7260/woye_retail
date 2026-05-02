import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_utils/src/get_utils/get_utils.dart';
import 'package:gyaawa/apps/user_app/presentation/common/login/controller/login_controller.dart';

import '../../../../../../Core/Constant/image_constant.dart';
import '../../../../../../Data/response/status.dart';
import '../../../../../../Utils/sized_box.dart';
import '../../../../../../routes/user_routes/user_app_routes.dart';
import '../../../../../../shared/theme/colors.dart';
import '../../../../../../shared/theme/font_family.dart';
import '../../../../../../shared/theme/font_style.dart';
import '../../../../../../shared/widgets/custom_appbar.dart';
import '../../../../../../shared/widgets/custom_elevated_button.dart';
import '../../../../../../shared/widgets/custom_rounded_button.dart';
import '../../../../../../shared/widgets/custom_text_form_field.dart';
import '../../../../../../shared/widgets/vendor_widgets/circular_progress_indicator.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final LoginController loginController = Get.find<LoginController>();

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
                    child: SvgPicture.asset(ImageConstants.loginSvg,
                        height: 450.h, width: 371.w)),
                CustomAppBar(),
                Positioned(
                  top: 70,
                  left: 150,
                  right: 0,
                  child: Center(
                    child: Text('LOG IN',
                        style: AppFontStyle.text_34_500(AppColors.black,
                            fontFamily: AppFontFamily.interMedium)),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  hBox(20),
                  Text("Enter your registered phone number to log in",
                      style: AppFontStyle.text_15_400(AppColors.greyLightColor,
                          fontFamily: AppFontFamily.interRegular)),
                  hBox(25),
                  Obx(() => Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: loginController.setCustomer,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 14, horizontal: 16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: loginController.selectedType.value ==
                                            'customer'
                                        ? AppColors.buttonColor
                                        : AppColors.greyLightColor,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      loginController.selectedType.value ==
                                              'customer'
                                          ? Icons.check_circle
                                          : Icons.circle_outlined,
                                      color:
                                          loginController.selectedType.value ==
                                                  'customer'
                                              ? AppColors.buttonColor
                                              : AppColors.greyLightColor,
                                      size: 20,
                                    ),
                                    wBox(8),
                                    Text("Customer",
                                        style: AppFontStyle.text_15_400(
                                          loginController.selectedType.value ==
                                                  'customer'
                                              ? AppColors.blackTextColor
                                              : AppColors.greyLightColor,
                                          fontFamily:
                                              AppFontFamily.interRegular,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          wBox(12),
                          Expanded(
                            child: GestureDetector(
                              onTap: loginController.setVendor,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 14, horizontal: 16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: loginController.selectedType.value ==
                                            'vendor'
                                        ? AppColors.buttonColor
                                        : AppColors.greyLightColor,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      loginController.selectedType.value ==
                                              'vendor'
                                          ? Icons.check_circle
                                          : Icons.circle_outlined,
                                      color:
                                          loginController.selectedType.value ==
                                                  'vendor'
                                              ? AppColors.buttonColor
                                              : AppColors.greyLightColor,
                                      size: 20,
                                    ),
                                    wBox(8),
                                    Text("Vendor",
                                        style: AppFontStyle.text_15_400(
                                          loginController.selectedType.value ==
                                                  'vendor'
                                              ? AppColors.blackTextColor
                                              : AppColors.greyLightColor,
                                          fontFamily:
                                              AppFontFamily.interRegular,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                  hBox(20),
                  Obx(() {
                    if (loginController.selectedType.value == 'customer') {
                      return CustomTextFormField(
                        height: 52,
                        hintText: "Phone Number",
                        showBorder: true,
                        textInputType: TextInputType.phone,
                        prefixIcon: CountryCodePicker(
                          textStyle: AppFontStyle.text_15_400(
                              AppColors.greyTextColor,
                              fontFamily: AppFontFamily.interRegular),
                          padding: const EdgeInsets.only(left: 10),
                          showFlag: false,
                          showDropDownButton: true,
                        ),
                      );
                    } else {
                      return Form(
                        key: loginController.loginFormKey,
                        child: Column(
                          children: [
                            CustomTextFormField(
                              hintText: "Email",
                              controller: loginController.emailController.value,
                              prefixIcon: Padding(
                                padding:
                                    const EdgeInsets.only(left: 18, right: 10),
                                child: Image.asset(
                                  ImageConstants.emailLogo,
                                  height: 19.h,
                                  width: 18.h,
                                  color: AppColors.hintText,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Email is required";
                                }
                                if (!GetUtils.isEmail(value.trim())) {
                                  return "Enter valid email";
                                }
                                return null;
                              },
                              textInputType: TextInputType.emailAddress,
                            ),
                            hBox(16),
                            CustomTextFormField(
                              hintText: "Password",
                              controller: loginController.passwordController.value,
                              obscureText: loginController.isShowPassword.value,
                              prefixIcon: Padding(
                                padding:
                                    const EdgeInsets.only(left: 18, right: 10),
                                child: Image.asset(
                                  ImageConstants.lockLogo,
                                  height: 19.h,
                                  width: 18.h,
                                  color: AppColors.hintText,
                                ),
                              ),
                              suffix: GestureDetector(
                                onTap: () {
                                  loginController.togglePassword();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: Icon(
                                    loginController.isShowPassword.value ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                    color: AppColors.hintText,
                                    size: 20,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Password is required";
                                }
                                if (value.length < 6) {
                                  return "Password must be at least 6 characters";
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      );
                    }
                  }),
                  hBox(20),
                  Obx(() => CustomElevatedButton(
                    height: 52,
                    onPressed: () {
                      if (loginController.rxRequestStatus.value == ApiStatus.LOADING) return;

                      if (loginController.loginFormKey.currentState!.validate()) {
                        if (loginController.selectedType.value == "vendor") {
                          loginController.loginApi();
                        }
                      }
                    },
                    child: loginController.rxRequestStatus.value == ApiStatus.LOADING
                        ? circularProgressIndicator(
                      size: 30,
                      color: Colors.white,
                    )
                        : Text(
                      "Log In",
                      style: AppFontStyle.text_18_600(
                        AppColors.white,
                        fontFamily: AppFontFamily.interSemiBold,
                      ),
                    ),
                  )),
                  Obx(() {
                    if (loginController.selectedType.value == 'vendor') {
                      return Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () {
                               Get.toNamed(UserRoutes.forgotPasswordScreen);
                            },
                            child: Text(
                              "Forgot Password?",
                              style: AppFontStyle.text_15_500(
                                AppColors.buttonColor,
                                fontFamily: AppFontFamily.interMedium,
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  }),
                  hBox(15),
                  Text("or continue with",
                      style: AppFontStyle.text_16_400(AppColors.greyLightColor,
                          fontFamily: AppFontFamily.onestRegular)),
                  hBox(20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomRoundedButton(
                        onPressed: () {},
                        child: SvgPicture.asset(ImageConstants.fbLogo,
                            height: 26, width: 26),
                      ),
                      wBox(15),
                      CustomRoundedButton(
                        onPressed: () {},
                        child: SvgPicture.asset(ImageConstants.googleLogo,
                            height: 26, width: 26),
                      ),
                      wBox(15),
                      CustomRoundedButton(
                        onPressed: () {},
                        child: SvgPicture.asset(ImageConstants.appleLogo,
                            height: 26, width: 26),
                      ),
                    ],
                  ),
                  hBox(20),
                  InkWell(
                    onTap: () => Get.toNamed(UserRoutes.signupScreen),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Don't have an account? ",
                            style: AppFontStyle.text_16_400(
                                AppColors.greyLightColor,
                                fontFamily: AppFontFamily.onestRegular),
                          ),
                          TextSpan(
                            text: "Sign Up",
                            style: AppFontStyle.text_18_400(
                                AppColors.blackTextColor,
                                fontFamily: AppFontFamily.onestRegular),
                          ),
                        ],
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
