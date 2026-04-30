import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gyaawa/apps/user_app/presentation/navigation_bar/view/user_nav_bar.dart';
import 'package:gyaawa/shared/widgets/vendor_widgets/circular_progress_indicator.dart';
import '../../../../../../Core/Constant/image_constant.dart';
import '../../../../../../Data/response/status.dart';
import '../../../../../../Utils/sized_box.dart';
import '../../../../../../shared/theme/colors.dart';
import '../../../../../../shared/theme/font_family.dart';
import '../../../../../../shared/theme/font_style.dart';
import '../../../../../../shared/widgets/custom_appbar.dart';
import '../../../../../../shared/widgets/custom_elevated_button.dart';
import '../../../../../../shared/widgets/otp_Input_field.dart';
import '../../../../../../shared/widgets/vendor_widgets/print.dart';
import '../controller/verify_controller.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final VerifyController verifyController = Get.find<VerifyController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Center(
                      child: SvgPicture.asset(
                        ImageConstants.loginSvg,
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                hBox(20),
                Text("Verification code",
                    style: AppFontStyle.text_28_500(AppColors.black,
                      fontFamily: AppFontFamily.interSemiBold,)),
                hBox(1),
                Text("Please enter the verification code sent to ",
                    style: AppFontStyle.text_16_400(AppColors.greyLightColor,
                      fontFamily: AppFontFamily.interRegular,)),
                hBox(6),
                      Obx(() => Text(
                        verifyController.email.value,
                        style: AppFontStyle.text_15_400(
                          AppColors.blackTextColor,
                          fontFamily: AppFontFamily.interRegular,
                        ),
                      )),
                      hBox(25),
                      Form(
                        key: verifyController.verifyFormKey,
                        child: OtpInputField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter OTP";
                            }
                            if (value.length < 6) {
                              return "Enter valid 6 digit OTP";
                            }
                            return null;
                          },
                          onCompleted: (otp) {
                            verifyController.otp.value = otp;
                          },
                        ),
                      ),
                      hBox(20),
                  Obx(() => CustomElevatedButton(
                      height: 52,
                    child: verifyController.rxRequestStatus.value == ApiStatus.LOADING
                        ? circularProgressIndicator(size: 30, color: Colors.white,)
                        : Text(
                      "Verify",
                      style: AppFontStyle.text_18_600(
                        AppColors.white,
                        fontFamily: AppFontFamily.interSemiBold,
                      ),
                    ),
                    onPressed: () {
                      if (verifyController.verifyFormKey.currentState?.validate() != true) return;
                      pt("OTP value: ${verifyController.otp.value}");
                      verifyController.otpVerifyApi();
                    },
                  ),
                  ),
                      hBox(20),
                      Obx(() => Center(
                        child: GestureDetector(
                          onTap: () {
                            if (verifyController.resendTimer.value == 0) {
                              verifyController.resendOtpApi();
                            }
                          },
                          child: Text(
                            verifyController.resendTimer.value > 0
                                ? "Resend code in ${verifyController.resendTimer.value} s"
                                : "Resend Code",
                            style: AppFontStyle.text_18_500(
                              verifyController.resendTimer.value > 0
                                  ? AppColors.greyTextColor
                                  : AppColors.primary,
                              fontFamily: AppFontFamily.interRegular,
                            ),
                          ),
                        ),
                      ))
                    ],
                  ),
                ),
              ],
            ),
        ),
    );
  }
}