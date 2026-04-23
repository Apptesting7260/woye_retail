import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Utils/sized_box.dart';
import '../../theme/colors.dart';
import '../../theme/font_family.dart';
import '../../theme/font_style.dart';

class CustomExpansionTile extends StatelessWidget {
  const CustomExpansionTile(
      {super.key, required this.question, required this.answer});

  final String question;
  final String answer;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      backgroundColor: AppColors.cardBgColor,
      collapsedBackgroundColor: AppColors.cardBgColor,
      shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: const BorderSide(
            color: Colors.transparent,
            width: 0,
          )),
      collapsedShape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: const BorderSide(
            color: Colors.transparent,
            width: 0,
          )),
      tilePadding: REdgeInsets.only(left: 16, right: 12),
      collapsedIconColor: AppColors.darkText,
      iconColor: AppColors.darkText,
      childrenPadding: REdgeInsets.only(
        left: 18,
        right: 10,
        bottom: 18,
      ),
      title: Text(
        question,
        style: AppFontStyle.customText(AppColors.darkText, 16, FontWeight.w400,fontFamily: AppFontFamily.gilroySemiBold),
        maxLines: 10,
        textAlign: TextAlign.start,
      ),
      children: [
        Divider(
          color: AppColors.ultraLightPrimary,
        ),
        hBox(8.h),
        Text(
          answer,
          style: AppFontStyle.text_15_400(AppColors.greyClr,
              fontFamily: AppFontFamily.gilroyRegular,
              overflow: TextOverflow.clip),
          maxLines: 150,
          textAlign: TextAlign.start,
        ),
      ],
    );
  }
}
