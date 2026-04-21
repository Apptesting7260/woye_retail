import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gyaawa/Utils/sized_box.dart';
import 'package:gyaawa/shared/theme/font_family.dart';
import 'package:gyaawa/shared/theme/font_style.dart';
import 'package:gyaawa/shared/widgets/custom_elevated_button.dart';
import 'package:gyaawa/shared/widgets/image.dart';

import '../../Core/Constant/image_constant.dart';
import '../theme/colors.dart';

class CustomFeaturedCard extends StatelessWidget {
  final String image;
  final String title;
  final String socialCount;
  final String searchCount;
  String? subTitle;
  String? editor;
  String? expert;
  final String salePrize;
  final String regularPrize;
  final double rating;
  final int totalReviews;
  String? tag;
  String? Seller;
  String? description;
  String? category;
  String? byCategory;
  int? discount;
  final VoidCallback? onFavTap;
  final VoidCallback? onTap;

  CustomFeaturedCard({
    super.key,
    required this.image,
    required this.title,
    required this.socialCount,
    required this.searchCount,
    this.subTitle,
    this.editor,
    this.expert,
    this.byCategory,
    this.description,
    required this.salePrize,
    required this.regularPrize,
    required this.rating,
    required this.totalReviews,
    this.onFavTap,
    this.onTap,
    this.category,
    this.tag,
    this.Seller,
    this.discount,
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
                if (tag?.isNotEmpty ?? false)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: _buildTag(
                      tag!,
                      AppColors.greenLightClr,
                      AppColors.white,
                    ),
                  ),
                if (editor?.isNotEmpty ?? false)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.buttonColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            ImageConstants.kingSvg,
                            width: 17,
                          ),
                          wBox(5),
                          Text("$editor",
                              style: AppFontStyle.text_10_500(AppColors.white,
                                  fontFamily: AppFontFamily.interMedium)),
                        ],
                      ),
                    ),
                  ),
                if (expert?.isNotEmpty ?? false)
                  Positioned(
                    bottom: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.yellowButtonClr,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text("$expert",
                          style: AppFontStyle.text_10_500(AppColors.white,
                              fontFamily: AppFontFamily.interMedium)),
                    ),
                  ),
                if (Seller?.isNotEmpty ?? false)
                  Positioned(
                    top: 35,
                    left: 8,
                    child: _buildTag(
                      Seller!,
                      AppColors.yellowButtonClr,
                      AppColors.white,
                    ),
                  ),
                if ((discount ?? 0) > 0)
                  Positioned(
                    top: 62,
                    left: 8,
                    child: _buildTag(
                      "SAVE ${discount!}%",
                      AppColors.errorColor,
                      AppColors.white,
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
                        child: Icon(
                          Icons.favorite_border,
                          size: 23,
                        )),
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
                    (subTitle?.isNotEmpty ?? false)
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: AppColors.lightButtonClr,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              subTitle!,
                              style: AppFontStyle.text_10_500(
                                AppColors.buttonColor,
                                fontFamily: AppFontFamily.interMedium,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                    hBox(10),
                    Text(title,
                        maxLines: 2,
                        style: AppFontStyle.text_15_600(AppColors.black,
                            fontFamily: AppFontFamily.interSemiBold)),
                    hBox(10),
                    if(category?.isNotEmpty ==true)...[
                    Text("$category ",
                        style: AppFontStyle.text_12_400(
                            AppColors.buttonHideColor,
                            fontFamily: AppFontFamily.interRegular)),
                    hBox(10),],
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
                        Text(rating.toStringAsFixed(1),
                            style: AppFontStyle.text_12_500(AppColors.black,
                                fontFamily: AppFontFamily.interMedium)),
                        wBox(6),
                        Text("($totalReviews)",
                            style: AppFontStyle.text_12_400(
                                AppColors.greyColors,
                                fontFamily: AppFontFamily.interRegular)),
                      ],
                    ),
                    hBox(8),
                    if (description?.isNotEmpty == true) ...[
                    Text(
                      maxLines: 3,
                      description ?? "",
                      style: AppFontStyle.text_12_400(AppColors.greyTextColor,
                          fontFamily: AppFontFamily.interRegular),
                    ),
                    hBox(10),],
                    Row(
                      children: [
                        Text(
                          salePrize,
                          style: AppFontStyle.text_20_500(AppColors.buttonColor,
                              fontFamily: AppFontFamily.interBold),
                        ),
                        wBox(6),
                        Text(
                          regularPrize,
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
                    if (byCategory?.isNotEmpty == true) ...[
                      hBox(20),
                      Center(
                        child: Text(
                          byCategory!,
                          style: AppFontStyle.text_12_400(
                            AppColors.greyColors,
                            fontFamily: AppFontFamily.interRegular,
                          ),
                        ),
                      ),
                    ],
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: AppFontStyle.text_10_500(
          textColor,
          fontFamily: AppFontFamily.interMedium,
        ),
      ),
    );
  }
}
