import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../theme/colors.dart';
import '../theme/font_family.dart';
import '../theme/font_style.dart';

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
     this.color = const Color.fromRGBO(54, 69, 79, 1),
    this.textColor,
    this.isLoading,
    this.text = "",
    this.textStyle,
    required this.onPressed,
    this.child,
    this.forGroundColor,
    this.borderSide,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? Get.width,
      height: height ?? 42.h,
      child: ElevatedButton(
        onPressed: isLoading != true ? onPressed : () {},
        style: ElevatedButton.styleFrom(
          padding: padding ?? EdgeInsets.zero,
          side: borderSide,
          elevation: 0,
          // foregroundColor: forGroundColor ?? AppColors.white,
          backgroundColor: color,
          overlayColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ??
                BorderRadius.all(Radius.circular(8.0.r)),
          ),
          alignment: Alignment.center,
        ),
        child: child ??
            (isLoading == true
                ? LoadingAnimationWidget.inkDrop(
              color: Colors.white,
              size: 30.h,
            )
                : Text(
              text,
              textAlign: TextAlign.center,
              style: textStyle ??
                  AppFontStyle.text_14_500(
                    textColor ?? AppColors.white,
                    fontFamily: AppFontFamily.interMedium,
                  ),
            )),
      ),
    );
  }
}