import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../../Core/Constant/image_constant.dart';
import '../../../../Utils/sized_box.dart';
import '../../../../shared/theme/colors.dart';
import '../../../../shared/theme/font_family.dart';
import '../../../../shared/theme/font_style.dart';
import '../../../../shared/widgets/custom_appbar.dart';
import '../../../../shared/widgets/custom_elevated_button.dart';
import '../../../../shared/widgets/otp_Input_field.dart';
import '../../../navigation_bar/view/nav_bar.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: AppColors.white,
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
                    'ALMOST',
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
            Text("Verification code",
                style: AppFontStyle.text_28_500(AppColors.black,
                  fontFamily: AppFontFamily.interSemiBold,)),
            hBox(1),
            Text("Please enter the verification code sent to ",
                style: AppFontStyle.text_16_400(AppColors.greyLightColor,
                  fontFamily: AppFontFamily.interRegular,)),
            hBox(6),
              Text("+971 12345678",style: AppFontStyle.text_15_400(AppColors.blackTextColor,
                fontFamily: AppFontFamily.interRegular,)),
                  hBox(25),
                  OtpInputField(
                    onCompleted: (otp) {
                      print("OTP: $otp");
                    },
                  ),
                  hBox(20),
                  CustomElevatedButton(
                      color: AppColors.buttonColor,
                      height: 52,
                      text: "Verify",
                      textStyle:
                      AppFontStyle.text_18_600(
                        AppColors.white,
                        fontFamily: AppFontFamily.interSemiBold,
                      ),
                      onPressed: (){
                        Get.offAll(() => MainScreen());
                        // Get.toNamed(AppRoutes.verifyScreen);
                      }
                  ),
                  hBox(20),
                  Center(
                    child: Text("Resend code in 55 s",
                        style: AppFontStyle.text_18_500(AppColors.greyTextColor,
                          fontFamily: AppFontFamily.interRegular,)),
                  ),
                ],
              ),
            ),
        ),
    );
  }
}