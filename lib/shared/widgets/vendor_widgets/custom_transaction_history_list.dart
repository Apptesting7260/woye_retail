import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';

import '../../theme/colors.dart';
import '../../theme/font_family.dart';
import '../../theme/font_style.dart';

class CustomTransactionHistoryList extends StatelessWidget {
  final String? image;
  final String? title;
  final String? dateTime;
  final String? amount;
  final String? transactionType;
  final Color? color;
  final bool? isAssetImage;

  const CustomTransactionHistoryList({
    super.key,
    this.image,
    this.title,
    this.amount,
    this.dateTime,
    this.transactionType,
    this.color,
    this.isAssetImage = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        height: 55.h,
        width: 55.w,
        decoration: BoxDecoration(
          color: AppColors.ultraLightPrimary,
          shape: BoxShape.circle,
        ),
        child: isAssetImage == true ? Padding(
          padding: const EdgeInsets.all(16),
          child: SvgPicture.asset(
            image!,
            colorFilter: ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
          ),
        ):  ClipRRect(
          borderRadius: BorderRadius.circular(100.r),
          child: CachedNetworkImage(
            imageUrl: image ?? "",
            height: 35.h,
            width: 35.w,
            fit: BoxFit.fill,
            errorWidget: (context, url, error) => Icon(CupertinoIcons.person_fill,color: AppColors.greyPerson,size: 28,),
            placeholder: (context, url) => Shimmer.fromColors(
              baseColor: AppColors.bgColor,
              highlightColor: AppColors.lightText,
              child: Container(
                height: 35.h,
                width: 35.w,
                decoration: BoxDecoration(
                  color: AppColors.grey,
                  borderRadius: BorderRadius.circular(100.r),
                ),
              ),
            ),
          ),
        ),

      ),
      title: Text(
        title ?? "",
        maxLines: 2,
        style: AppFontStyle.text_15_400(
          AppColors.darkText,
          fontFamily: AppFontFamily.gilroySemiBold,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 3.0),
        child: Text(
          dateTime ?? "",
          style: AppFontStyle.text_13_400(
            AppColors.mediumText,
            fontFamily: AppFontFamily.gilroyRegular,
          ),
        ),
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            amount ?? "",
            style: AppFontStyle.text_16_400(
              color ?? AppColors.primary,
              fontFamily: AppFontFamily.gilroySemiBold,
            ),
          ),
          Text(
            transactionType ?? "",
            style: AppFontStyle.text_13_400(
              AppColors.mediumText,
              fontFamily: AppFontFamily.gilroyRegular,
            ),
          ),
        ],
      ),
    );
  }
}
