import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../Core/Constant/image_constant.dart';
import '../../../Utils/sized_box.dart';
import '../../theme/colors.dart';
import '../../theme/font_family.dart';
import '../../theme/font_style.dart';

class CustomProductReviewCard extends StatelessWidget {
  final String? image;
  final String? profileimage;
  final String? title;
  final String? replay;
  final String? subTitle;
  final String? description;
  final String? name;
  final EdgeInsetsGeometry? padding;
  final Color? cardBgColor;
  final List<Widget>? star;
  final VoidCallback? onPressed;
  final VoidCallback? onTap;
  final bool? isShowReplayBtn ;
  final int? maxLines;

  const CustomProductReviewCard({
    super.key,
    this.image,
    this.title,
    this.subTitle,
    this.description,
    this.name,
    this.profileimage,
    this.padding,
    this.cardBgColor,
    this.star,
    this.onPressed,
    this.replay,
    this.onTap,
    this.isShowReplayBtn = true,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      padding: REdgeInsets.symmetric(horizontal: 15, vertical: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.textFieldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              // Container(
              //   height: 80.h,
              //   width: 80.w,
              //   decoration: BoxDecoration(
              //     color: cardBgColor ?? Colors.transparent,
              //     borderRadius: BorderRadius.circular(15.r),
              //   ),
              //   child: Padding(
              //     padding: padding ?? REdgeInsets.all(0.0),
              //     child: Image.asset(
              //       image!,
              //       height: 75.h,
              //       width: 75.h,
              //     ),
              //   ),
              // ),
              // Container(
              //   height: 80.h,
              //   width: 80.w,
              //   decoration: BoxDecoration(
              //     color: AppColors.greyBackground,
              //     borderRadius: BorderRadius.circular(15.r),
              //   ),
              //   child: ClipRRect(
              //     borderRadius: BorderRadius.circular(15.r),
              //     child: CachedNetworkImage(
              //       imageUrl: image ?? "",
              //       height: 80.h,
              //       width: 80.w,
              //       fit: BoxFit.fill,
              //       errorWidget: (context, url, error) => const Icon(Icons.error_outline),
              //       placeholder: (context, url) => Shimmer.fromColors(
              //         baseColor: AppColors.bgColor,
              //         highlightColor: AppColors.lightText,
              //         child: Container(
              //           height: 80.h,
              //           width: 80.w,
              //           decoration: BoxDecoration(
              //             color: AppColors.gray,
              //             borderRadius: BorderRadius.circular(20.r),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              // wBox(10.w),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title!,
                      style: AppFontStyle.text_18_500(
                        AppColors.darkText,
                        fontFamily: AppFontFamily.gilroySemiBold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subTitle!,
                      style: AppFontStyle.text_16_400(
                        AppColors.mediumText,
                        fontFamily: AppFontFamily.gilroyRegular,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          hBox(22.h),
          Text(
            description!,
            maxLines: maxLines ?? 4,
            overflow: TextOverflow.ellipsis,
            style: AppFontStyle.text_14_400(
              AppColors.darkText,
              fontFamily: AppFontFamily.gilroyRegular,
            ),
          ),
          hBox(20.h),
          Container(
            height: 80,
            width: Get.width,
            decoration: BoxDecoration(
              color: AppColors.bgColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const SizedBox(width: 10),
                Container(
                  height: 55.h,
                  width: 54.w,
                  decoration: BoxDecoration(
                    color: AppColors.greyBackground,
                    shape: BoxShape.circle,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100.r),
                    child: CachedNetworkImage(
                      imageUrl: profileimage ?? "",
                      // height: 55.h,
                      // width: 55.w,
                      fit: BoxFit.fill,
                      errorWidget: (context, url, error) =>
                          Center(child: Icon(CupertinoIcons.person_solid,color:AppColors.greyPerson,size: 30,)),
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: AppColors.bgColor,
                        highlightColor: AppColors.lightText,
                        child: Container(
                          // height: 80.h,
                          // width: 80.w,
                          decoration: BoxDecoration(
                            color: AppColors.grey,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name!,
                      style: AppFontStyle.text_15_400(
                        AppColors.darkText,
                        fontFamily: AppFontFamily.gilroyMedium,
                      ),
                    ),
                    Row(
                      children: star!,
                    ),
                  ],
                ),
                const Spacer(),
                if(isShowReplayBtn == true)
                Align(
                    alignment: const Alignment(0, -1),
                    child: IconButton(
                      onPressed: onPressed,
                      icon: Icon(
                        Icons.reply,
                        color: AppColors.primary,
                      ),
                    )),
              ],
            ),
          ),
          if(isShowReplayBtn == false)...[
            hBox(20.h),
            Align(
              alignment: const Alignment(1.02, 0),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.bgColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: REdgeInsets.symmetric(horizontal: 11.0, vertical: 15),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: onTap,
                        child: SvgPicture.asset(
                          ImageConstants.editSvgLogo,
                          colorFilter: ColorFilter.mode(
                              AppColors.primary, BlendMode.srcIn),
                        ),
                      ),
                      wBox(13.h),
                      Flexible(
                        child: Text(
                          "$replay",
                          maxLines: 100,
                          softWrap: true,
                          style: TextStyle(
                            color: AppColors.darkText,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontFamily: AppFontFamily.gilroyMedium,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ]

        ],
      ),
    );
  }
}
