import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

import '../../../Core/Constant/image_constant.dart';
import '../../../Utils/sized_box.dart';
import '../../theme/colors.dart';
import '../../theme/font_family.dart';
import '../../theme/font_style.dart';

class ProfileCategoryTile extends StatelessWidget {
  const ProfileCategoryTile({
    super.key,
     this.imagePath,
    required this.title,
    required this.subTitle,
    this.imageBgColor,
    this.imageWidth,
    this.imageHeight,
    this.onTap,
    this.isPngImage = false,
    this.padding,
    this.image,
  });

  final String? imagePath;
  final String title;
  final String subTitle;
  final Color? imageBgColor;
  final double? imageWidth;
  final double? imageHeight;
  final Callback? onTap;
  final bool? isPngImage;
  final EdgeInsetsGeometry? padding;
  final Widget? image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // height: 100.h,
        width: Get.width,
        decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(15.r),
            border: Border.all(color: AppColors.lightPrimary)),
        child: Padding(
          padding: REdgeInsets.all(10.0),
          child: Row(
            children: [
              image ??
                  Container(
                    height: 80.h,
                    width: 80.w,
                    decoration: BoxDecoration(
                      color: imageBgColor ?? Colors.transparent,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: isPngImage == true
                        ? Padding(
                            padding: padding ?? REdgeInsets.all(14.0),
                            child: Image.asset(
                              imagePath!,
                              height: imageHeight ?? 40.h,
                              width: imageWidth ?? 40.w,
                            ),
                          )
                        : SvgPicture.asset(
                            imagePath!,
                            height: imageHeight ?? 40.h,
                            width: imageWidth ?? 40.w,
                          ),
                  ),
              wBox(16.w),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        maxLines: 2,
                        style: AppFontStyle.text_18_400(AppColors.darkText,
                            fontFamily: AppFontFamily.gilroyMedium)),
                    hBox(8.h),
                    Text(subTitle,
                        style: AppFontStyle.text_16_400(AppColors.lightText,
                            fontFamily: AppFontFamily.gilroyRegular)),
                  ],
                ),
              ),
              // const Spacer(),
              SvgPicture.asset(ImageConstants.forwardIcon),
            ],
          ),
        ),
      ),
    );
  }
}
