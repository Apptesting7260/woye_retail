

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:shimmer/shimmer.dart';

import '../../Utils/sized_box.dart';
import '../theme/colors.dart';

class ShimmerWidget extends StatelessWidget {
  final Color? baseClr;
  final Color? highlightColor;
  final Color? shimmerClr;
  final BorderRadius? borderRadius;
  final BoxBorder? border;
  final bool isRestaurantCard;

  const ShimmerWidget({
    super.key,
    this.baseClr,
    this.highlightColor,
    this.shimmerClr,
    this.borderRadius,
    this.border,
    this.isRestaurantCard = false,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseClr ?? AppColors.greyClr.withOpacity(0.4),
      highlightColor: highlightColor ?? AppColors.greyLightColor,
      child: isRestaurantCard ? restaurantCardShimmer() : simpleSimmer(),
    );
  }

  Widget simpleSimmer() {
    return Container(
      width: double.maxFinite,
      height: 220.h,
      decoration: BoxDecoration(
        border: border,
        color: shimmerClr ?? AppColors.greyClr.withOpacity(0.4),
        borderRadius: borderRadius ?? BorderRadius.circular(20.r),
      ),
    );
  }

  Widget restaurantCardShimmer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: borderRadius ?? BorderRadius.circular(20.r),
        border: border,
      ),
      padding: REdgeInsets.only(bottom: 50),
      width: Get.width * 0.78,
      // child: Column(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [
      //     hBox(225.h),
      //     // Container(
      //     //   height: 160.h,
      //     //   width: double.infinity,
      //     //   decoration: BoxDecoration(
      //     //     color: shimmerClr ?? AppColors.gray.withOpacity(0.4),
      //     //     borderRadius: BorderRadius.circular(20.r),
      //     //   ),
      //     // ),
      //     Container(
      //       height: 13.h,
      //       width: Get.width * 0.7 .w,
      //       decoration: BoxDecoration(
      //         borderRadius: BorderRadius.circular(1.r),
      //         color: shimmerClr ?? AppColors.gray.withOpacity(0.4),
      //       ),
      //
      //     ),
      //     hBox(8.h),
      //     // Category text
      //     Row(
      //       children: [
      //         Container(
      //           height: 12.h,
      //           width: 120.w,
      //           decoration: BoxDecoration(
      //             borderRadius: BorderRadius.circular(1.r),
      //             color: shimmerClr ?? AppColors.gray.withOpacity(0.4),
      //           ),
      //         ),
      //         wBox(10.w),
      //         Container(
      //           height: 12.h,
      //           width: 120.w,
      //           decoration: BoxDecoration(
      //             borderRadius: BorderRadius.circular(1.r),
      //             color: shimmerClr ?? AppColors.gray.withOpacity(0.4),
      //           ),
      //         ),
      //       ],
      //     ),
      //     hBox(12.h),
      //     Row(
      //       children: [
      //         Container(
      //           height: 10.h,
      //           width: Get.width * 0.22.w,
      //           decoration: BoxDecoration(
      //             borderRadius: BorderRadius.circular(1.r),
      //             color: shimmerClr ?? AppColors.gray.withOpacity(0.4),
      //           ),
      //         ),
      //         wBox(10.w),
      //         Container(
      //           height: 10.h,
      //           width: Get.width * 0.22.w,
      //           decoration: BoxDecoration(
      //             borderRadius: BorderRadius.circular(1.r),
      //             color: shimmerClr ?? AppColors.gray.withOpacity(0.4),
      //           ),
      //         ),
      //         wBox(10.w),
      //         Container(
      //           height: 10.h,
      //           width: Get.width * 0.22.w,
      //           decoration: BoxDecoration(
      //             borderRadius: BorderRadius.circular(1.r),
      //             color: shimmerClr ?? AppColors.gray.withOpacity(0.4),
      //           ),
      //         ),
      //       ],
      //     )
      //   ],
      // ),
    );
  }
}


class ShimmerWidgetHomeScreen extends StatelessWidget {
  final Color? baseClr;
  final Color? highlightColor;
  final Color? shimmerClr;
  final BorderRadius? borderRadius;
  final BoxBorder? border;
  final bool isRestaurantCard;

  const ShimmerWidgetHomeScreen({
    super.key,
    this.baseClr,
    this.highlightColor,
    this.shimmerClr,
    this.borderRadius,
    this.border,
    this.isRestaurantCard = false,
  });
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseClr ?? AppColors.greyClr.withOpacity(0.2),
      highlightColor: highlightColor ?? AppColors.lightText,
      child : SizedBox(/*height: 315.h,*/
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 210.h, width: Get.width*0.78,decoration: BoxDecoration(color: AppColors.primary,borderRadius: BorderRadius.circular(20.r)),),
            hBox(10.h),
            Container(height: 20.h, width: Get.width*0.78,decoration: BoxDecoration(color: AppColors.primary,borderRadius: BorderRadius.circular(15.r)),),
            hBox(10.h),
            Container(height: 20.h, width: Get.width*0.50,decoration: BoxDecoration(color: AppColors.primary,borderRadius: BorderRadius.circular(15.r)),),
            hBox(10.h),
            Container(height: 20.h, width: Get.width*0.30,decoration: BoxDecoration(color: AppColors.primary,borderRadius: BorderRadius.circular(15.r)),),
          ],
        ),
      ),
    );
  }
}
class ShimmerBox extends StatelessWidget {
  const ShimmerBox({super.key, required this.width, required this.height, this.radius, this.isCircle});

  final double width;
  final double height;
  final double? radius;
  final bool? isCircle;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: isCircle == true ? const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        )
            : BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius ?? 15),
        ),
      ),
    );
  }
}
