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

class CustomEditorChoiceCard extends StatelessWidget {
  final String image;
  final String title;
  final String socialCount;
  final String searchCount;
  String? subTitle;
  String? editor;
  String? expert;
  String? save;
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

  CustomEditorChoiceCard({
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
    this.save,
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
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 15),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.yellowCardBorder, width: 1),
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
                // if (expert?.isNotEmpty ?? false)
                //   Positioned(
                //     bottom: 10,
                //     left: 10,
                //     child: Container(
                //       padding: const EdgeInsets.symmetric(
                //           horizontal: 10, vertical: 5),
                //       decoration: BoxDecoration(
                //         color: AppColors.yellowButtonClr,
                //         borderRadius: BorderRadius.circular(8),
                //       ),
                //       child: Text("$expert",
                //           style: AppFontStyle.text_10_500(AppColors.white,
                //               fontFamily: AppFontFamily.interMedium)),
                //     ),
                //   ),
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
                        ? Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8),
                                decoration: BoxDecoration(
                                  gradient: AppColors.orangeGradient,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  subTitle!,
                                  style: AppFontStyle.text_10_500(
                                    AppColors.white,
                                    fontFamily: AppFontFamily.interMedium,
                                  ),
                                ),
                              ),wBox(10),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.buttonColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  "Expert Score: $expert",
                                  style: AppFontStyle.text_10_500(
                                    AppColors.white,
                                    fontFamily: AppFontFamily.interMedium,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                    hBox(10),
                    Text(title,
                        maxLines: 3,
                        style: AppFontStyle.text_26_600(AppColors.blueTextColor,
                            fontFamily: AppFontFamily.interSemiBold)),
                    hBox(10),
                    if (category?.isNotEmpty == true) ...[
                      Text("$category ",
                          style: AppFontStyle.text_12_400(
                              AppColors.buttonHideColor,
                              fontFamily: AppFontFamily.interRegular)),
                      hBox(10),
                    ],
                    Row(
                      children: [
                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              index < 4 ? Icons.star : Icons.star_border,
                              color: AppColors.starClr,
                              size: 22,
                            );
                          }),
                        ),
                        wBox(6),
                        Text(rating.toStringAsFixed(1),
                            style: AppFontStyle.text_14_500(AppColors.black,
                                fontFamily: AppFontFamily.interBold)),
                        wBox(6),
                        Text("($totalReviews)",
                            style: AppFontStyle.text_14_400(
                                AppColors.greyColors,
                                fontFamily: AppFontFamily.interRegular)),
                      ],
                    ),
                    hBox(8),
                    if (description?.isNotEmpty == true) ...[
                      Text(
                        maxLines: 4,
                        description ?? "",
                        style: AppFontStyle.text_15_400(AppColors.greyTextColor,
                            fontFamily: AppFontFamily.interRegular),
                      ),
                      hBox(10),
                    ],
                    Row(
                      children: [
                        Text(
                          salePrize,
                          style: AppFontStyle.text_30_600(AppColors.buttonColor,
                              fontFamily: AppFontFamily.interBold),
                        ),
                        wBox(6),
                        Text(
                          regularPrize,
                          style: AppFontStyle.text_17_400(AppColors.greyColors,
                              fontFamily: AppFontFamily.interRegular),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.greenButtonColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "$save",
                        style: AppFontStyle.text_15_500(
                          AppColors.greenTextClr,
                          fontFamily: AppFontFamily.interMedium,
                        ),
                      ),
                    ),
                    hBox(12),
                    CustomElevatedButton(
                      onPressed: onTap ?? () {},
                      color: AppColors.yellowButtonClr,
                      width: double.infinity,
                      height: 42,
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.shopping_cart_outlined,size: 18,color: AppColors.white,),
                          wBox(5),
                          Text(
                            "Add To Cart",
                            style: AppFontStyle.text_14_500(
                              AppColors.white,
                              fontFamily: AppFontFamily.interMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                    hBox(10),
                    CustomElevatedButton(
                      onPressed: onFavTap ?? () {},
                      borderSide: BorderSide(color: AppColors.borderClr, width: 1),
                      color: AppColors.white,
                      width: double.infinity,
                      height: 42,
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.favorite_border,size: 18,color: AppColors.black,),
                          wBox(5),
                          Text(
                            "Add To Cart",
                            style: AppFontStyle.text_14_500(
                              AppColors.black,
                              fontFamily: AppFontFamily.interMedium,
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (byCategory?.isNotEmpty == true) ...[
                      hBox(20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Why Our Editors Love This",
                              style: AppFontStyle.text_16_600(
                                AppColors.black,
                                fontFamily: AppFontFamily.interBold,
                              ),
                            ),
                            hBox(10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text("*  "),
                                    Expanded(child: Text("Exceptional build quality and premium materials", style: AppFontStyle.text_14_400(
                                      AppColors.greyTextColor,
                                      fontFamily: AppFontFamily.interRegular,
                                    ),)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("*  "),
                                    Expanded(child: Text("Outstanding value for the price point", style: AppFontStyle.text_14_400(
                                      AppColors.greyTextColor,
                                      fontFamily: AppFontFamily.interRegular,
                                    ),)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("*  "),
                                    Expanded(child: Text("Excellent customer reviews and ratings", style: AppFontStyle.text_14_400(
                                      AppColors.greyTextColor,
                                      fontFamily: AppFontFamily.interRegular,
                                    ),)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("*  "),
                                    Expanded(child: Text("Innovative features that solve real problems", style: AppFontStyle.text_14_400(
                                      AppColors.greyTextColor,
                                      fontFamily: AppFontFamily.interRegular,
                                    ),)),
                                  ],
                                ),
                              ],
                            )
                          ],
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
