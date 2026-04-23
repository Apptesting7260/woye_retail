import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../../Core/Constant/image_constant.dart';
import '../../../../../../Utils/sized_box.dart';
import '../../../../../../shared/theme/colors.dart';
import '../../../../../../shared/theme/font_family.dart';
import '../../../../../../shared/theme/font_style.dart';
import '../../../../../../shared/widgets/custom_elevated_button.dart';
import '../../../../../../shared/widgets/custom_rounded_button.dart';
import '../../../../user_routes/app_routes.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 23),
        child: Column(
          children: [
            Stack(
              children: [
                SvgPicture.asset(
                  ImageConstants.welcomeSvg,
                  height: 530.h,
                  width: 371.w,
                ),
                Positioned(
                  top: 70,
                  left: 150,
                  right: 0,
                  child: Center(
                    child: Text(
                      'WELCOME',
                      style: AppFontStyle.text_34_500(
                        AppColors.black,
                        fontFamily: AppFontFamily.interMedium,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            hBox(50),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Row(
                children: [
                  CustomElevatedButton(
                     width: 130,
                     color: AppColors.buttonColor,
                    onPressed: () {
                     Get.toNamed(UserRoutes.loginScreen);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          ImageConstants.personSvg,
                          height: 18,
                          width: 14,
                        ),
                       wBox(8),
                        Text(
                          "Log in",
                          style: AppFontStyle.text_18_500(
                            AppColors.white,
                            fontFamily: AppFontFamily.onestSemiBold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  wBox(15),
                  CustomElevatedButton(
                    text: "Continue As Quest",
                    textStyle: AppFontStyle.text_18_400(
                      AppColors.black,
                      fontFamily: AppFontFamily.onestRegular,
                    ),
                    width: 200,
                    color: AppColors.buttonHideColor.withAlpha(20),
                    borderSide: BorderSide(color: AppColors.buttonHideColor.withAlpha(50), width: 0.5),
                    onPressed: () {
                      // Get.to(() => const LoginScreen());
                    },
                  ),
                ],
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
        Get.toNamed(UserRoutes.signupScreen);
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
                style: AppFontStyle.text_16_400(
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
