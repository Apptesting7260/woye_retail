import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gyaawa/Core/Constant/image_constant.dart';
import '../../../Utils/sized_box.dart';
import '../../../shared/theme/colors.dart';
import '../../../shared/theme/font_family.dart';
import '../../../shared/theme/font_style.dart';

class HomeAddressScreen extends StatelessWidget {
  const HomeAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        color: Colors.white,
        child: Padding(
          padding: REdgeInsets.only(
              left: 16.h, top: 20.h, right: 24.h, bottom: 20.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        "Delivery To:",
                        style: AppFontStyle.text_14_500(
                          AppColors.buttonColor,
                          fontFamily: AppFontFamily.onestMedium,
                        ),
                      ),
                    ),
                    hBox(2.h),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              "Madina, La-Nkwanta...",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppFontStyle.text_12_300(
                                AppColors.greyClr,
                                fontFamily: AppFontFamily.onestLight,
                              ),
                            ),
                          ),
                         wBox(4),
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 25.r,
                            color: AppColors.buttonColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      
             wBox(15),
              Container(
                padding:
                EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color:AppColors.greyLightColor,width: 0.9),
                ),
                child: Text(
                  "Help",
                  style: AppFontStyle.text_14_500(
                    AppColors.greyTextColor,
                    fontFamily: AppFontFamily.interMedium,
                  ),
                ),
              ),
              SvgPicture.asset(
                ImageConstants.cartSvg,
                height: 42.h,
                width: 42.w,
              ),
              wBox(4),
              SvgPicture.asset(
                ImageConstants.notificationSvg,
                height: 25.h,
                width: 25.w,
              ),
            ],
          ),
        ),
      ),
    );
  }
}