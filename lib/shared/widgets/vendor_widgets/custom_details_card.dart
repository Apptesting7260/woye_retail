import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Utils/sized_box.dart';
import '../../theme/colors.dart';
import '../../theme/font_family.dart';
import '../../theme/font_style.dart';
import '../image.dart';


class CustomDetailsCard extends StatelessWidget {
  final String? image;
  final String? increaseLogo;
  final String? title;
  final String? subTitle;
  final String? text;
  final TextStyle? subtitleTextStyle;
  final bool? isTextdClr;
  final bool isColor;
  final VoidCallback? onTap;
  final Color? containerClr;
  final Color? imageClr;
  final Widget? widget;
  final TextStyle? titleStyle;

  const CustomDetailsCard({
    super.key,
    this.image,
    this.increaseLogo,
    this.title,
    this.subTitle,
    this.text,
    this.subtitleTextStyle,
    this.isTextdClr = false,
    this.isColor = true,
    this.onTap,
    this.containerClr,
    this.imageClr,
    this.widget,
    this.titleStyle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // height: 170,
        // width: 182,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow:[
            BoxShadow(color: AppColors.black.withAlpha(15),blurRadius: 1,spreadRadius: 1),
          ]
        ),
        child: Padding(
          padding: REdgeInsets.fromLTRB(15.h, 15.h, 15.h, 10.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: REdgeInsets.all(11.h),
                height: 44.h,
                width: 44.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: containerClr ?? AppColors.ultraLightPrimary2,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: AppImage(path: image!,
                    color: imageClr ?? AppColors.primary,
                    svgColor: ColorFilter.mode(imageClr ?? AppColors.primary, BlendMode.srcIn),
                  ),
                ),
              ),
              hBox(10),
              Text(
                title ?? "",
                style: titleStyle ?? AppFontStyle.text_16_400(
                  AppColors.darkText,
                  fontFamily: AppFontFamily.gilroyBold,
                ),
              ),
              hBox(1.h),
              Text(
                subTitle ?? "",
                style: subtitleTextStyle ??
                    AppFontStyle.text_14_400(
                      AppColors.greyClr,
                      fontFamily: AppFontFamily.gilroyMedium,
                    ),
              ),
              text != null ? hBox(5.h) : const SizedBox.shrink(),
              widget ?? const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
