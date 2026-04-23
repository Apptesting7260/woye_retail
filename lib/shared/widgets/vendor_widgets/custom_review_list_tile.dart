import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../Utils/sized_box.dart';
import '../../theme/colors.dart';
import '../../theme/font_family.dart';
import '../../theme/font_style.dart';


class CustomReviewListTile extends StatelessWidget {
  final String? image;
  final String? title;
  final String? subTitle;
  final String? dateTime;
  final String? description;
  final List<Widget>? star;


  const CustomReviewListTile({
    super.key,
    this.image,
    this.title,
    this.subTitle,
    this.description,
    this.dateTime,
    this.star,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CachedNetworkImage(
                imageUrl: image!,
                imageBuilder: (context, imageProvider) => CircleAvatar(
                  radius: 25,
                  backgroundImage: imageProvider, // The network image will be set here
                ),
                errorWidget: (context, url, error) => Container(
                    decoration: BoxDecoration(color: AppColors.bgColor,shape: BoxShape.circle),
                    width: 53.r,
                    height: 53.r,
                    child:  Icon(CupertinoIcons.person_solid,size: 32,color:AppColors.greyPerson),),
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: AppColors.bgColor,
                  highlightColor: AppColors.lightText,
                  child: Container(
                    width: 50.r,
                    height: 50.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.grey,
                    ),
                  ),
                ),
              ),
            wBox(8.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 3.0),
                  child: Text(
                    title ?? "",
                    style: AppFontStyle.text_15_400(
                      AppColors.darkText,
                      fontFamily: AppFontFamily.gilroyMedium,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: star!
                ),
              ],
            ),
          ],
        ),
        Padding(
          padding: REdgeInsets.only(left: 63.0.h, top: 2.h),
          child: Text(
            description ?? " ",
            style: AppFontStyle.text_14_400(
              AppColors.darkText,
              fontFamily: AppFontFamily.gilroyRegular,
            ),
            maxLines: 1000,
          ),
        ),
        hBox(5.h),
        Padding(
          padding: REdgeInsets.only(left: 63.0.h, top: 2.h),
          child: Text(
            dateTime ?? "",
            style: AppFontStyle.text_14_400(
              AppColors.hintText,
              fontFamily: AppFontFamily.gilroyRegular,
            ),
            maxLines: 4,
          ),
        )
      ],
    );
  }
}
