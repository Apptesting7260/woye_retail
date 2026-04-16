import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:gyaawa/shared/widgets/custom_elevated_button.dart';

import '../../../Core/Constant/image_constant.dart';
import '../../../Routes/app_routes.dart';
import '../../../Utils/sized_box.dart';
import '../../../shared/theme/colors.dart';
import '../../../shared/theme/font_family.dart';
import '../../../shared/theme/font_style.dart';
import '../../../shared/widgets/custom_appbar.dart';
import '../../../shared/widgets/custom_text_form_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                        'SIGN UP',
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
              Text("Create your Account",
                  style: AppFontStyle.text_28_500(AppColors.black,
                    fontFamily: AppFontFamily.interSemiBold,)),
              hBox(1),
              Text("Enter your phone number to continue. We will send you a verification code",
                  maxLines: 2,
                  style: AppFontStyle.text_15_400(AppColors.greyLightColor,
                    fontFamily: AppFontFamily.interRegular,)),
              hBox(20),
              CustomTextFormField(
                height: 62,
                borderRadius: BorderRadius.circular(15),
                hintText: "Phone Number",
                textInputType: TextInputType.phone,
                hintStyle: AppFontStyle.text_15_400(AppColors.greyLightColor,
                    fontFamily: AppFontFamily.interRegular),
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
              hBox(20),
              CustomElevatedButton(
                  color: AppColors.buttonColor,
                  height: 52,
                  text: "Sign Up",
                  textStyle:
                  AppFontStyle.text_18_600(
                    AppColors.white,
                    fontFamily: AppFontFamily.interSemiBold,
                  ),
                  onPressed: (){
                    Get.toNamed(AppRoutes.verifyScreen);
                  }
              ),
              hBox(20),
              signUpButton(),
            ],
          ),
        ),
      ),
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
                  text: "Already have an account?  ",
                  style: AppFontStyle.text_16_400(
                    AppColors.greyLightColor,
                    fontFamily: AppFontFamily.onestRegular,
                  ),
                ),
                TextSpan(
                  text: "Log In",
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
