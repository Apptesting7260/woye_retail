  import 'package:flutter/material.dart';
  import 'package:flutter_screenutil/flutter_screenutil.dart';
  import 'package:flutter_svg/flutter_svg.dart';
  import 'package:get/get.dart';
  import 'package:gyaawa/apps/user_app/presentation/common/forgot_password/controller/forgot_password_controller.dart';

  import '../../../../../../Core/Constant/image_constant.dart';
  import '../../../../../../Data/response/status.dart';
  import '../../../../../../Utils/sized_box.dart';
  import '../../../../../../shared/theme/colors.dart';
  import '../../../../../../shared/theme/font_family.dart';
  import '../../../../../../shared/theme/font_style.dart';
  import '../../../../../../shared/widgets/custom_appbar.dart';
  import '../../../../../../shared/widgets/custom_elevated_button.dart';
  import '../../../../../../shared/widgets/custom_text_form_field.dart';
  import '../../../../../../shared/widgets/vendor_widgets/circular_progress_indicator.dart';

  class ForgotPasswordScreen extends StatefulWidget {
    ForgotPasswordScreen({super.key});

    @override
    State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
  }

  class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
    final ForgotPasswordController controller = Get.put(ForgotPasswordController());
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
                    child: SvgPicture.asset(
                      ImageConstants.loginSvg,
                      height: 450.h,
                      width: 371.w,
                    ),
                  ),
                  CustomAppBar(),
                ],
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Form(
                  key:controller.formKey,
                  child: Column(
                    children: [
                      hBox(20),
                      Text(
                        "Enter your registered email to receive reset instructions",
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: AppFontStyle.text_15_400(
                          AppColors.greyLightColor,
                          fontFamily: AppFontFamily.interRegular,
                        ),
                      ),

                      hBox(30),
                      CustomTextFormField(
                        hintText: "Email",
                        controller: controller.emailController,
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
                      hBox(30),
                      Obx(() => CustomElevatedButton(
                        height: 52,
                        onPressed: () {
                          if (controller.rxRequestStatus.value == ApiStatus.LOADING) return;

                          if (controller.formKey.currentState!.validate()) {
                            controller.forgotPasswordApi();
                          }
                        },
                        child: controller.rxRequestStatus.value == ApiStatus.LOADING
                            ? circularProgressIndicator(color: Colors.white,size: 30)
                            : Text(
                          "Reset Password",
                          style: AppFontStyle.text_18_600(
                            AppColors.white,
                            fontFamily: AppFontFamily.interSemiBold,
                          ),
                        ),
                      )),
                      hBox(20),
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
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