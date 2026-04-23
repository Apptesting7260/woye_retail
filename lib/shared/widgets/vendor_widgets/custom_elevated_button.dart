import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../theme/colors.dart';
import '../../theme/font_family.dart';
import '../../theme/font_style.dart';

class CustomElevatedButton extends StatelessWidget {
  final BorderRadiusGeometry? borderRadius;
  final double? width;
  final double? height;
  final Color? color;
  final Color? textColor;
  final Color? forGroundColor;
  final VoidCallback onPressed;
  final Widget? child;
  final bool? isLoading;
  final String text;
  final TextStyle? textStyle;
  final BorderSide? borderSide;
  final EdgeInsetsGeometry? padding;
  const CustomElevatedButton({
    super.key,
    this.borderRadius,
    this.width,
    this.height,
    this.color = const Color.fromRGBO(6, 132, 75, 1),
    this.textColor,
    this.isLoading,
    this.text = "",
    this.textStyle,
    required this.onPressed,
    this.child,
    this.forGroundColor,
    this.borderSide,
    this.padding
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? Get.width,
      height: height ?? 55.h,
      // height: height ?? 56.h,
      child: ElevatedButton(
        onPressed: isLoading != true ? onPressed : () {},
        style: ElevatedButton.styleFrom(
          padding: padding,
          side: borderSide,
          elevation: 0,
          foregroundColor: forGroundColor ?? AppColors.white,
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.all(
              Radius.circular(14.0.r),
            ),
          ),
          alignment: Alignment.center,
          textStyle: textStyle ??
              AppFontStyle.text_16_400(
                AppColors.white,
                fontFamily: AppFontFamily.gilroySemiBold,
              ),
        ),
        child: child ??
            Center(
                child: isLoading != true
                    ? FittedBox(child: Text(text,
                  style: textStyle ?? AppFontStyle.text_16_400(
                   textColor ?? AppColors.white,
                  fontFamily: AppFontFamily.gilroySemiBold,
                ),
                )) : LoadingAnimationWidget.inkDrop(
                        color: Colors.white,
                        size: 30.h,
                      )),
      ),
    );
  }
}
