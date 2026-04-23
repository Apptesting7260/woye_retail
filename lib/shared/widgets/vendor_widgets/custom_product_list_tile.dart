import 'dart:core';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../Utils/sized_box.dart';
import '../../theme/colors.dart';
import '../../theme/font_family.dart';
import '../../theme/font_style.dart';

class CustomProductListTile extends StatelessWidget {
  final String? image;
  final bool? isActive;
  final String? status;
  final String? activeInavtive;
  final String? title;
  final String? subtitle;
  final VoidCallback? onPressed;
  final Widget? icon;
  final Color? color;
  final double? borderWidth;
  final int? imageHeight;
  final int? imageWidth;
  final double? padding;
  final Widget? headerText;
  final EdgeInsetsGeometry? imagePadding;
  final bool? isShowSubtitle;

  const CustomProductListTile({
    super.key,
    this.image,
    this.title,
    this.activeInavtive,
    this.isActive,
    this.subtitle,
    this.status,
    this.onPressed,
    this.color,
    this.borderWidth,
    this.imageWidth,
    this.imageHeight,
    this.padding,
    this.headerText,
    this.icon,
    this.imagePadding,
    this.isShowSubtitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      padding: REdgeInsets.fromLTRB(10, 10, padding ?? 0, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: color ?? AppColors.textFieldBorder,
          width: borderWidth ?? 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 80,
            width: 78,
            decoration: BoxDecoration(
              color: AppColors.bgColor,
              borderRadius: const BorderRadius.all(Radius.circular(15)),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              child: Padding(
                padding: imagePadding ?? REdgeInsets.all(0.0),
                child: Center(
                  child: CachedNetworkImage(
                    imageUrl:image.toString(),
                    height: 80,
                    width: 78,
                    fit: BoxFit.fill,
                    placeholder: (context, url) =>
                        Shimmer.fromColors(
                          baseColor: AppColors.bgColor,
                          highlightColor: AppColors.lightText,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.grey,
                              borderRadius:
                              BorderRadius.circular(15.r),
                            ),
                          ),
                        ),
                    errorWidget: (context, url, error) => Icon(Icons.error,color: AppColors.grey,),
                  ),
                )
              ),
            ),
          ),
          wBox(13.h),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                headerText ??
                    Text(
                      status?.capitalizeFirst.toString() ?? "" /*== '1' ? "Active" : "Inactive"*/,
                      style: AppFontStyle.text_13_400(
                          status != 'active' ? AppColors.red : AppColors.primary,
                          fontFamily: AppFontFamily.gilroyRegular),
                    ),
                hBox(2.h),
                Text(
                  title!,
                  style: AppFontStyle.text_16_400(AppColors.darkText,
                      fontFamily: AppFontFamily.gilroySemiBold),
                ),
                if(isShowSubtitle == true)...[
                  hBox(2.h),
                  Text(
                    subtitle!,
                    style: AppFontStyle.text_13_400(AppColors.mediumText,
                        fontFamily: AppFontFamily.gilroyRegular),
                  ),
                  ],
              ],
            ),
          ),
          GestureDetector(
            onTap: onPressed,
            child: icon,
          ),
        ],
      ),
    );
  }
}
