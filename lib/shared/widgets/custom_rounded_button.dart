
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/colors.dart';

class CustomRoundedButton extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadiusGeometry? borderRadius;
  final VoidCallback? onPressed;
  final Widget? child;
  final bool isLoading;

  const CustomRoundedButton(
      {super.key,
      this.width,
      this.height,
      this.borderRadius,
      this.isLoading = false,
      required this.onPressed,
      required this.child});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 60.h,
      width: width ?? 60.h,
      child: OutlinedButton(
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: borderRadius ?? BorderRadius.circular(100.r))),
          onPressed: onPressed,
          child: isLoading
              ? CircularProgressIndicator.adaptive(
                  backgroundColor: AppColors.white,
                  strokeWidth: 1.w,
                )
              : child),
    );
  }
}
