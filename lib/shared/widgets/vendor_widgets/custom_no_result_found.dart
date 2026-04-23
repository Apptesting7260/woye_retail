import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../Core/Constant/image_constant.dart';
import '../../../Utils/sized_box.dart';
import '../../theme/colors.dart';
import '../../theme/font_family.dart';
import '../../theme/font_style.dart';

class CustomNoResultFound extends StatelessWidget {
  final Widget? heightBox;
  final double? bottomHeight;

  const CustomNoResultFound({super.key, this.heightBox,this.bottomHeight});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        heightBox ?? hBox(Get.height / 6),
        Center(
          child: SvgPicture.asset(
            ImageConstants.noData,
            height: 300.h,
            width: 200.h,
          ),
        ),
        Text(
          "We couldn't find any results",
          style: AppFontStyle.text_20_600(AppColors.darkText,fontFamily: AppFontFamily.gilroyRegular),
        ),
        hBox(5.h),
        Text(
          "Explore more and shortlist some items",
          style: AppFontStyle.text_16_400(AppColors.mediumText,fontFamily: AppFontFamily.gilroyRegular),
        ),
        hBox(bottomHeight ?? 0),
      ],
    );
  }
}
