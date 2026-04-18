import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gyaawa/Core/Constant/image_constant.dart';
import 'package:gyaawa/Utils/sized_box.dart';
import 'package:gyaawa/shared/theme/font_family.dart';
import 'package:gyaawa/shared/theme/font_style.dart';
import 'package:gyaawa/shared/widgets/custom_elevated_button.dart';
import 'package:gyaawa/shared/widgets/image.dart';

import '../theme/colors.dart';

class CustomEditsCard extends StatelessWidget {
  final String image;
  final String title;
  final String socialCount;
  final String searchCount;
  final String subTitle;
  final String editor;
  final String expert;
  final VoidCallback? onFavTap;
  final VoidCallback? onTap;

  const CustomEditsCard({
    super.key,
    required this.image,
    required this.title,
    required this.socialCount,
    required this.searchCount,
    required this.subTitle,
    required this.editor,
    required this.expert,
    this.onFavTap,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderClr, width: 0.9),
          color: AppColors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: AppImage(
                    path: image,
                    height: 370,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.buttonColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          ImageConstants.kingSvg,
                          width: 15,
                        ),
                        wBox(4),
                        Text(editor,
                            style: AppFontStyle.text_10_500(AppColors.white,
                                fontFamily: AppFontFamily.interBold)),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.yellowButtonClr,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text("+$expert",
                        style: AppFontStyle.text_10_500(AppColors.white,
                            fontFamily: AppFontFamily.interMedium)),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: onFavTap,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: SvgPicture.asset(
                        ImageConstants.favoriteSvg,
                        width: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            hBox(10),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.lightButtonClr,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text("$subTitle ",
                          style: AppFontStyle.text_10_500(AppColors.buttonColor,
                              fontFamily: AppFontFamily.interMedium)),
                    ),
                    hBox(10),
                    Text(title,
                        maxLines: 2,
                        style: AppFontStyle.text_15_600(AppColors.black,
                            fontFamily: AppFontFamily.interBold)),
                    hBox(10),
                    Row(
                      children: [
                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              index < 4 ? Icons.star : Icons.star_border,
                              color: AppColors.starClr,
                              size: 18,
                            );
                          }),
                        ),
                        wBox(6),
                        Text("4.9",
                            style: AppFontStyle.text_12_500(AppColors.black,
                                fontFamily: AppFontFamily.interMedium)),
                        wBox(6),
                        Text("(1247)",
                            style: AppFontStyle.text_12_400(
                                AppColors.greyColors,
                                fontFamily: AppFontFamily.interRegular)),
                      ],
                    ),
                    hBox(8),
                    Text(
                      maxLines: 4,
                      '"Exceptional build quality, outstanding performance, and incredible value for money. This laptop has revolutionized"',
                      style: AppFontStyle.text_12_400(AppColors.greyTextColor,
                          fontFamily: AppFontFamily.interRegular),
                    ),
                    hBox(10),
                    Row(
                      children: [
                         Text(
                          "GHS 3899.99",
                          style: AppFontStyle.text_20_500(AppColors.buttonColor,
                              fontFamily: AppFontFamily.interBold),
                        ),
                       wBox(6),
                        Text(
                          "GHS 4599.99",
                          style: AppFontStyle.text_16_400(AppColors.greyColors,
                              fontFamily: AppFontFamily.interRegular),
                        ),
                      ],
                    ),
                    hBox(12),
                    CustomElevatedButton(
                      onPressed: onTap ?? () {},
                      color: AppColors.buttonColor,
                      width: double.infinity,
                      height: 42,
                      text: "Add to Cart",
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statBox({required String value, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(value,
              style: AppFontStyle.text_13_500(AppColors.errorColor,
                  fontFamily: AppFontFamily.interBold)),
          hBox(4),
          Text(label,
              style: AppFontStyle.text_10_500(AppColors.greyTextColor,
                  fontFamily: AppFontFamily.interRegular)),
        ],
      ),
    );
  }
}
