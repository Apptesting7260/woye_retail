import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:gyaawa/Utils/sized_box.dart';
import 'package:gyaawa/apps/user_app/presentation/common/splash/controller/splash_controller.dart';
import 'package:gyaawa/shared/theme/font_style.dart';
import '../../../../../../Core/Constant/image_constant.dart';
import '../../../../../../shared/theme/colors.dart';
import '../../../../../../shared/theme/font_family.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  final SplashController splashController = Get.put(SplashController());

  @override
  void initState() {
    super.initState();
    splashController.stepWiseRouting();
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 23),
          child: Column(
            children: [
              Stack(
                children: [
                  SvgPicture.asset(
                    ImageConstants.splashSvg,
                    height: 600.h,
                    width: 371.w,
                  ),
                  Positioned(
                    top: 70,
                    left: 180,
                    right: 0,
                    child: Center(
                      child: Text(
                        'GYAAWA',
                        style: AppFontStyle.text_34_400(
                          AppColors.black,
                          fontFamily: AppFontFamily.rubikRegular,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              hBox(60),
              Text(
                'Everything You Need... Delivered.',
                style: AppFontStyle.text_20_400(
                  AppColors.greyTextColor,
                  fontFamily: AppFontFamily.interRegular,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}