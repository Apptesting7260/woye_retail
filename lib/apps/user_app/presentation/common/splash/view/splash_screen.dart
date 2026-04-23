import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:gyaawa/Utils/sized_box.dart';
import 'package:gyaawa/shared/theme/font_style.dart';
import '../../../../../../Core/Constant/image_constant.dart';
import '../../../../../../shared/theme/colors.dart';
import '../../../../../../shared/theme/font_family.dart';
import '../../../../../vendor_app/Gyaawa/Restaurant_navbar/view/restaurant_navbar.dart';
import '../../welcome/view/welcome_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      // Get.offAll(() => SelectDeliveryAddress());
      Get.offAll(() => WelcomeScreen());
      // Get.offAll(() => RestaurantNavbarScreen());
      // Get.offAll(() => FeaturedScreen());
    });

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 23),
        child: Column(
          children: [
            Stack(
              children: [
                SvgPicture.asset(
                  ImageConstants.splashSvg,
                  height: 669.h,
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
    );
  }
}