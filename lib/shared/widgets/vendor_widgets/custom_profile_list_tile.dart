import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../Utils/sized_box.dart';
import '../../theme/colors.dart';
import '../../theme/font_family.dart';
import '../../theme/font_style.dart';
import 'app_container.dart';

class CustomProfileListTile extends StatelessWidget {
  final String? image;
  final String? title;
  final VoidCallback? onTap;
  final Color? color;
  final bool? isIcon;
  final bool? isImage;
  final bool? isPngImage;

  const CustomProfileListTile({
    super.key,
    this.image,
    this.title,
    this.onTap,
    this.color,
    this.isIcon = true,
    this.isImage = true,
    this.isPngImage,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: AppContainer(
        boxShadow: const [],
        color: AppColors.white,
        radius: 14,
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 12),
        child: Row(
          children: [
            if(isImage == true)...[
            isPngImage == true
                ? Image.asset(
                    image!,
                    height: 23,
                    width: 23,
                    color: color ?? AppColors.black,
                  )
                : SvgPicture.asset(
                    image!,
                    height: 24,
                    width: 24,
                    colorFilter: ColorFilter.mode(
                      color ?? AppColors.black,
                      BlendMode.srcIn,
                    ),
                  ),
            wBox(10.h),
            ],
            Text(title!,
                style: AppFontStyle.customText(
                  color ?? AppColors.darkText,
                  17.sp,
                  FontWeight.w400,
                  fontFamily: AppFontFamily.gilroyMedium,
                )),
            if (isIcon != false) const Spacer(),
            if (isIcon != false)
              Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: AppColors.black,
              ),
          ],
        ),
      ),
    );
  }
}
