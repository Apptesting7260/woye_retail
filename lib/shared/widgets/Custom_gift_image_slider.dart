import 'package:flutter/cupertino.dart';

import '../../Utils/sized_box.dart';
import '../theme/colors.dart';
import '../theme/font_family.dart';
import '../theme/font_style.dart';
import 'image.dart';

class ImageSliderCard extends StatelessWidget {
  final String title;
  final String subTitle;
  final List<String> images;
  final String itemCount;
  final Gradient? gradient;

  const ImageSliderCard({
    super.key,
    required this.title,
    required this.subTitle,
    required this.images,
    required this.itemCount,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: gradient ?? AppColors.redGreenGradient,
        ),
        child: Column(
          children: [
            Text(
              title,
              style: AppFontStyle.text_18_600(
                AppColors.white,
                fontFamily: AppFontFamily.interBold,
              ),
            ),
            hBox(4),
            Text(
              subTitle,
              textAlign: TextAlign.center,
              style: AppFontStyle.text_12_400(
                AppColors.white,
                fontFamily: AppFontFamily.interRegular,
              ),
            ),
            hBox(14),
            SizedBox(
              height: 90,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: AppImage(
                        path: images[index],
                        height: 90,
                        width: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
            hBox(12),
            Text(
              itemCount,
              style: AppFontStyle.text_12_400(
                AppColors.white,
                fontFamily: AppFontFamily.interRegular,
              ),
            ), hBox(12),
          ],
        ),
      ),
    );
  }
}