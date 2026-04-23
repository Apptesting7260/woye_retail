import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:shimmer/shimmer.dart';

import '../../../Utils/sized_box.dart';
import '../../theme/colors.dart';
import '../../theme/font_family.dart';
import '../../theme/font_style.dart';

class CustomQueryTile extends StatelessWidget {
  const CustomQueryTile({super.key, this.onTap, this.imageUrl, this.vendorName, this.title, this.subject, this.date});

  final Callback? onTap;
  final String? imageUrl;
  final String? vendorName;
  final String? title;
  final String? subject;
  final String? date;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        // height: 115.h,
        width: Get.width,
        alignment: Alignment.topLeft,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container(
            //   height: 40.h,
            //   width: 40.w,
            //   child: ClipRRect(
            //       borderRadius: BorderRadius.circular(20.r),
            //       child: Image.asset(ImageConstants.profileMan)),
            // ),
            Container(
              decoration: BoxDecoration(
                  color: AppColors.imageBgColor,
                shape: BoxShape.circle,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25.r),
                child: CachedNetworkImage(
                  imageUrl: imageUrl ?? '',
                  height: 50.h,
                  width: 50.w,
                  fit: BoxFit.fill,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: AppColors.bgColor,
                    highlightColor: AppColors.lightText,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.grey,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) {
                    return const Icon(Icons.error_outline, size: 18,);
                  },
                ),
              ),
            ),
            wBox(16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(vendorName ?? "NA", style: AppFontStyle.text_14_400(AppColors.greyClr, fontFamily: AppFontFamily.gilroyRegular, overflow: TextOverflow.ellipsis),)),
                      wBox(8.w),
                      Text(date ?? "12 Jan", style: AppFontStyle.text_14_400(AppColors.greyClr, fontFamily: AppFontFamily.gilroyRegular),),
                    ],
                  ),
                  hBox(8.h),
                  Text(title ?? "Unable to select currency when order.", style: AppFontStyle.text_16_400(AppColors.darkText, fontFamily: AppFontFamily.gilroySemiBold, overflow: TextOverflow.clip),),
                  hBox(8.h),
                  Text(subject ?? "Hello team, I am facing problem as i  can not select currency on buy order.",
                    style: AppFontStyle.text_14_400(AppColors.greyClr, fontFamily: AppFontFamily.gilroyRegular, overflow: TextOverflow.clip),),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
