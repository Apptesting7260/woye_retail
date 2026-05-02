import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gyaawa/Utils/sized_box.dart';

import '../theme/colors.dart';
import '../theme/font_family.dart';
import '../theme/font_style.dart';
import 'custom_elevated_button.dart';
import 'image.dart';

class BrandCard extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const BrandCard({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AppImage(
                  path: image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            hBox(20),
            Text(
              title,
              style: AppFontStyle.text_14_600(
                AppColors.black,
                fontFamily: AppFontFamily.interSemiBold,
              ),
              textAlign: TextAlign.center,
            ),
            hBox(5),
            Text(
              subtitle,
              style: AppFontStyle.text_12_400(
                AppColors.greyTextColor,
                fontFamily: AppFontFamily.interRegular,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}