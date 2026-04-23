import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../Utils/sized_box.dart';
import '../../theme/colors.dart';
import '../../theme/font_family.dart';
import '../../theme/font_style.dart';
import '../custom_elevated_button.dart';

class CustomDeleteAlertDialog extends StatelessWidget {
  final VoidCallback? deleteOnTap;
  final VoidCallback? cancelOnTap;
  final String? title;
  final String? subtitle;
  final String? btnName;
  final int? maxLine;
  final TextAlign? textAlign;
  final Color? titleColor;
  final bool? isLoading;

  const CustomDeleteAlertDialog({
    super.key,
    this.deleteOnTap,
    this.cancelOnTap,
    this.title,
    this.subtitle,
    this.btnName,
    this.maxLine,
    this.textAlign, this.titleColor, this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width.h,
      child: AlertDialog(
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.transparent,
        insetPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Center(
            child: Text(
          title ?? "",
          style: AppFontStyle.text_24_600(
            titleColor ?? AppColors.darkText,
            fontFamily: AppFontFamily.gilroyRegular,
          ),
        )),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              subtitle ?? "",
              style: AppFontStyle.text_16_400(
                AppColors.mediumText,
                fontFamily: AppFontFamily.gilroyRegular,
              ),
              maxLines: maxLine,
              textAlign:textAlign ?? TextAlign.center,
            ),
            hBox(20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomElevatedButton(
                  width: 120,
                  height: 42,
                  color: AppColors.black,
                  onPressed: cancelOnTap??(){},
                  text: "Cancel",
                  textStyle: AppFontStyle.text_16_400(
                    AppColors.white,
                    fontFamily: AppFontFamily.gilroyMedium,
                  ),
                ),
                wBox(10.h),
                CustomElevatedButton(
                  isLoading: isLoading ?? false,
                  width: 120,
                  height: 42,
                  color: AppColors.red,
                  onPressed: deleteOnTap??(){},
                  text: "Yes, ${btnName ?? "Delete"}",
                  textStyle: AppFontStyle.text_18_400(
                    AppColors.white,
                    fontFamily: AppFontFamily.gilroyMedium,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
