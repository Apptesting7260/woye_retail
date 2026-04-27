import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:gyaawa/apps/user_app/presentation/common/login/controller/login_controller.dart';

import '../../../../../../Core/Constant/image_constant.dart';
import '../../../../../../Utils/sized_box.dart';
import '../../../../../../routes/user_routes/user_app_routes.dart';
import '../../../../../../shared/theme/colors.dart';
import '../../../../../../shared/theme/font_family.dart';
import '../../../../../../shared/theme/font_style.dart';
import '../../../../../../shared/widgets/custom_appbar.dart';
import '../../../../../../shared/widgets/custom_elevated_button.dart';
import '../../../../../../shared/widgets/custom_rounded_button.dart';
import '../../../../../../shared/widgets/custom_text_form_field.dart';

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
                Center(child: SvgPicture.asset(ImageConstants.loginSvg, height: 450.h, width: 371.w)),
                CustomAppBar(),
                Positioned(
                  top: 70, left: 150, right: 0,
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
                            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: loginController.selectedType.value == 'customer'
                                    ? AppColors.buttonColor
                                    : AppColors.greyLightColor,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  loginController.selectedType.value == 'customer'
                                      ? Icons.check_circle
                                      : Icons.circle_outlined,
                                  color: loginController.selectedType.value == 'customer'
                                      ? AppColors.buttonColor
                                      : AppColors.greyLightColor,
                                  size: 20,
                                ),
                                wBox(8),
                                Text("Customer",
                                    style: AppFontStyle.text_15_400(
                                      loginController.selectedType.value == 'customer'
                                          ? AppColors.blackTextColor
                                          : AppColors.greyLightColor,
                                      fontFamily: AppFontFamily.interRegular,
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
                            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: loginController.selectedType.value == 'vendor'
                                    ? AppColors.buttonColor
                                    : AppColors.greyLightColor,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  loginController.selectedType.value == 'vendor'
                                      ? Icons.check_circle
                                      : Icons.circle_outlined,
                                  color: loginController.selectedType.value == 'vendor'
                                      ? AppColors.buttonColor
                                      : AppColors.greyLightColor,
                                  size: 20,
                                ),
                                wBox(8),
                                Text("Vendor",
                                    style: AppFontStyle.text_15_400(
                                      loginController.selectedType.value == 'vendor'
                                          ? AppColors.blackTextColor
                                          : AppColors.greyLightColor,
                                      fontFamily: AppFontFamily.interRegular,
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
                          textStyle: AppFontStyle.text_15_400(AppColors.greyTextColor,
                              fontFamily: AppFontFamily.interRegular),
                          padding: const EdgeInsets.only(left: 10),
                          showFlag: false,
                          showDropDownButton: true,
                        ),
                      );
                    } else {
                      return Column(
                        children: [
                          CustomTextFormField(
                            height: 52,
                            hintText: "Email",
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(left: 18, right: 10),
                              child: Image.asset(
                                ImageConstants.emailLogo,
                                height: 19.h,
                                width: 18.h,
                                color: AppColors.hintText,
                              ),
                            ),
                            textInputType: TextInputType.emailAddress,
                          ),
                          hBox(16),
                          CustomTextFormField(
                            height: 52,
                            hintText: "Password",
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(left: 18, right: 10),
                              child: Image.asset(
                                ImageConstants.lockLogo,
                                height: 19.h,
                                width: 18.h,
                                color: AppColors.hintText,
                              ),
                            ),
                            obscureText: true,
                          ),
                        ],
                      );
                    }
                  }),

                  hBox(20),
                  CustomElevatedButton(
                    color: AppColors.buttonColor,
                    height: 52,
                    text: "Log In",
                    textStyle: AppFontStyle.text_18_600(AppColors.white,
                        fontFamily: AppFontFamily.interSemiBold),
                    onPressed: () {
                      Get.toNamed(UserRoutes.verifyScreen);

                    },
                  ),
                  hBox(20),
                  Text("or continue with",
                      style: AppFontStyle.text_16_400(AppColors.greyLightColor,
                          fontFamily: AppFontFamily.onestRegular)),
                  hBox(20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomRoundedButton(
                        onPressed: () {},
                        child: SvgPicture.asset(ImageConstants.fbLogo, height: 26, width: 26),
                      ),
                      wBox(15),
                      CustomRoundedButton(
                        onPressed: () {},
                        child: SvgPicture.asset(ImageConstants.googleLogo, height: 26, width: 26),
                      ),
                      wBox(15),
                      CustomRoundedButton(
                        onPressed: () {},
                        child: SvgPicture.asset(ImageConstants.appleLogo, height: 26, width: 26),
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
                            style: AppFontStyle.text_16_400(AppColors.greyLightColor,
                                fontFamily: AppFontFamily.onestRegular),
                          ),
                          TextSpan(
                            text: "Sign Up",
                            style: AppFontStyle.text_18_400(AppColors.blackTextColor,
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