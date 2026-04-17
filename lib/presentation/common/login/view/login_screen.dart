import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:gyaawa/Utils/sized_box.dart';
import 'package:gyaawa/shared/widgets/custom_appbar.dart';
import '../../../../Routes/app_routes.dart';
import '../../../../core/constant/image_constant.dart';
import '../../../../shared/theme/colors.dart';
import '../../../../shared/theme/font_family.dart';
import '../../../../shared/theme/font_style.dart';
import '../../../../shared/widgets/custom_rounded_button.dart';
import '../../../../shared/widgets/custom_text_form_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              Stack(
                children: [
                  SvgPicture.asset(
                    ImageConstants.loginSvg,
                    height: 500,
                    width: 371,
                  ),
                  CustomAppBar(),
                  Positioned(
                    top: 70,
                    left: 150,
                    right: 0,
                    child: Center(
                      child: Text(
                        'LOG IN',
                        style: AppFontStyle.text_34_500(
                          AppColors.black,
                          fontFamily: AppFontFamily.interMedium,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              hBox(20),
              Text("Enter your registered phone number to log in",
                style: AppFontStyle.text_15_400(AppColors.greyLightColor,
                  fontFamily: AppFontFamily.interRegular,)),
              hBox(25),
              CustomTextFormField(
                height: 62,
                borderRadius: BorderRadius.circular(15),
                hintText: "Phone Number",
                textInputType: TextInputType.phone,
                  prefixIcon: CountryCodePicker(
                    textStyle:AppFontStyle.text_15_400(AppColors.greyTextColor,
                        fontFamily: AppFontFamily.interRegular),
                  padding: const EdgeInsets.only(left: 10),
                  showFlag: false,
                  showDropDownButton: true,
                  // onChanged: (CountryCode countryCode) {
                  // },
                ),
              ),
              hBox(25),
              Text(
                "or continue with",
                style: AppFontStyle.text_16_400(
                  AppColors.greyLightColor,
                  fontFamily: AppFontFamily.onestRegular,
                ),),
              hBox(20),
              socialButtons(context),
              hBox(20),
              signUpButton(),
            ],
          ),
        ),
      ),
    );
  }
  Widget socialButtons(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomRoundedButton(
          onPressed: () {
            // socialLoginController.facebookLogin(context);
          },
          child: SvgPicture.asset(
            ImageConstants.fbLogo,
            height: 26.h,
            width: 26.h,
          ),
        ),
        wBox(15),
        CustomRoundedButton(
            onPressed: () {
              // socialLoginController.signInWithGoogle(context);
            },
            child: SvgPicture.asset(
              ImageConstants.googleLogo,
              height: 26.h,
              width: 26.h,
            )),
        wBox(15),
        CustomRoundedButton(
          onPressed: () {
            // socialLoginController.appleLogin(context);
          },
          child: SvgPicture.asset(
            ImageConstants.appleLogo,
            height: 26.h,
            width: 26.h,
          ),
        ),
      ],
    );
  }
  Widget signUpButton() {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        Get.toNamed(AppRoutes.signupScreen);
      },
      child: Align(
        alignment: Alignment.center,
        child: Padding(
            padding: REdgeInsets.only(
              bottom: 1,
            ),
            child:RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: "Don't have an account? ",
                  style: AppFontStyle.text_16_400(
                    AppColors.greyLightColor,
                    fontFamily: AppFontFamily.onestRegular,
                  ),
                ),
                TextSpan(
                  text: "Sign Up",
                  style: AppFontStyle.text_18_400(
                    AppColors.blackTextColor,
                    fontFamily: AppFontFamily.onestRegular,
                  ),
                ),
              ]),
            )
        ),
      ),
    );
  }
}