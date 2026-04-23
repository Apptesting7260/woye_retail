import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../shared/theme/colors.dart';

class Utils {
  static String? showToast(
    String msg, {
    ToastGravity gravity = ToastGravity.TOP,
    Color? bgColor,
    Toast? toastLength,
  }) {
    Fluttertoast.showToast(
      msg: msg,
      backgroundColor: bgColor ?? AppColors.black,
      gravity: gravity,
      textColor: AppColors.white,
      toastLength: toastLength ?? Toast.LENGTH_SHORT,
    );
    return null;
  }

  static String? showSnackBar(
      {required BuildContext context, required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 1),
        content: Center(
          child: Text(
            message,
            style: TextStyle(fontSize: 14.sp, color: Colors.white),
          ),
        )));

    return null;
  }

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? showSnackBarProgress({required BuildContext context}) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(seconds: 1),
        backgroundColor: AppColors.primary,
        content: Center(
          child: SizedBox(
            height: 16.h,
            width: 16.h,
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
              strokeWidth: 1.w,
              strokeCap: StrokeCap.round,
            ),
          ),
        )));
  }

  static snackBar1(String title, String message) {
    Get.snackbar(
        title,
        colorText: AppColors.white,
        message,
        backgroundColor: AppColors.black);
  }
}
