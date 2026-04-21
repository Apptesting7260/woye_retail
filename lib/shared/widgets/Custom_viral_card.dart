import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gyaawa/Core/Constant/image_constant.dart';
import 'package:gyaawa/Utils/sized_box.dart';
import 'package:gyaawa/shared/theme/font_family.dart';
import 'package:gyaawa/shared/theme/font_style.dart';
import 'package:gyaawa/shared/widgets/custom_elevated_button.dart';
import 'package:gyaawa/shared/widgets/image.dart';

import '../theme/colors.dart';

class ViralProductCard extends StatelessWidget {
  final String image;
  final String title;
  final String socialCount;
  final String searchCount;
  final String growth;
  final String viral;
  final VoidCallback? onTap;
  final VoidCallback? onFavTap;


  const ViralProductCard({
    super.key,
    required this.image,
    required this.title,
    required this.socialCount,
    required this.searchCount,
    required this.growth,
    required this.viral,
    required this.onTap,
    this.onFavTap,

  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder,width: 0.9),
          gradient: AppColors.lightWarmGradient,
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
                   path:  image,
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
                      color: AppColors.errorColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child:  Text(
                      "$viral🔥",
                      style: AppFontStyle.text_10_500(AppColors.white,fontFamily:AppFontFamily.interBold)
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "+$growth growth",
                        style: AppFontStyle.text_10_500(AppColors.errorColor,fontFamily:AppFontFamily.interMedium)
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child:  GestureDetector(
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
            hBox(20),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                      style: AppFontStyle.text_15_600(AppColors.black,fontFamily:AppFontFamily.interBold)
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _statBox(
                          value: socialCount,
                          label: "Social Mentions",
                        ),
                      ),
                    wBox(8),
                      Expanded(
                        child: _statBox(
                          value: searchCount,
                          label: "Searches",
                        ),
                      ),
                    ],
                  ),
                   hBox(12),
                  CustomElevatedButton(
                    onPressed: onTap ?? (){},
                    color: AppColors.errorColor,
                    width: double.infinity,
                    height: 42,
                    text: "Join the Trend - Add to Cart",
                  ),
                ],
              ),
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
        color:AppColors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            value,
              style: AppFontStyle.text_13_500(AppColors.errorColor,fontFamily:AppFontFamily.interBold)
          ),
         hBox(4),
          Text(
            label,
              style: AppFontStyle.text_10_500(AppColors.greyTextColor,fontFamily:AppFontFamily.interRegular)
          ),
        ],
      ),
    );
  }
}

class PopularProductCard extends StatelessWidget {
  final String image;
  final String title;
  final String subTitle;
  final String socialCount;
  final String searchCount;
  final String socialLabel;
  final String searchLabel;
  final String popular;
  final String trending;
  final String salePrize;
  final String regularPrize;
  final double rating;
  final int totalReviews;
  final String trade;
  final VoidCallback? onTap;
  final VoidCallback? onFavTap;

  const PopularProductCard({
    super.key,
    required this.image,
    required this.title,
    required this.subTitle,
    required this.socialCount,
    required this.searchCount,
    required this.socialLabel,
    required this.searchLabel,
    required this.popular,
    required this.trending,
    required this.onTap,
    required this.salePrize,
    required this.regularPrize,
    required this.rating,
    required this.totalReviews,
    required this.trade,
    this.onFavTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderClr,width: 0.9),
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
                   path:  image,
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
                      color: AppColors.errorColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child:  Text(
                      trending,
                      style: AppFontStyle.text_10_500(AppColors.white,fontFamily:AppFontFamily.interBold),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.greenLightClr,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "⭐$popular",
                        style: AppFontStyle.text_10_500(AppColors.white,fontFamily:AppFontFamily.interMedium),
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
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(ImageConstants.tradeSvg),
                        wBox(5),
                        Text("+$trade",
                            style: AppFontStyle.text_10_500(AppColors.greenTextClr,
                                fontFamily: AppFontFamily.interMedium)),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child:  GestureDetector(
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
            hBox(20),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                      maxLines: 3,
                      style: AppFontStyle.text_15_600(AppColors.black,fontFamily:AppFontFamily.interBold)
                  ),
                  Text(
                    subTitle,
                      maxLines: 3,
                      style: AppFontStyle.text_12_400(AppColors.greyColors,fontFamily:AppFontFamily.interRegular)
                  ),
                 hBox(10),
                  Row(
                    children: [
                      Expanded(
                        child: _statBox(
                          valueColor: AppColors.blueClr,
                          value: socialCount,
                          label: "Social Mentions",
                        ),
                      ),
                    wBox(8),
                      Expanded(
                        child: _statBox(
                          valueColor: AppColors.errorColor,
                          value: searchCount,
                          label: "Searches",
                        ),
                      ),
                    ],
                  ),
                  hBox(15),
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
                      Text(
                          rating.toStringAsFixed(1),
                          style: AppFontStyle.text_12_500(AppColors.black,
                              fontFamily: AppFontFamily.interMedium)),
                      wBox(6),
                      Text(
                          "($totalReviews)",
                          style: AppFontStyle.text_12_400(
                              AppColors.greyColors,
                              fontFamily: AppFontFamily.interRegular)),
                    ],
                  ),
                  hBox(10),
                  Row(
                    children: [
                      Text(
                        regularPrize,
                        style: AppFontStyle.text_20_500(AppColors.buttonColor,
                            fontFamily: AppFontFamily.interBold),
                      ),
                      wBox(6),
                      Text(
                        salePrize,
                        style: AppFontStyle.text_16_400(AppColors.greyColors,
                            fontFamily: AppFontFamily.interRegular),
                      ),
                    ],
                  ),
                   hBox(12),
                  CustomElevatedButton(
                    onPressed: onTap ?? (){},
                    color: AppColors.errorColor,
                    width: double.infinity,
                    height: 42,
                   child:  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_cart_outlined,size: 18,color: AppColors.white,),
                      wBox(5),
                      Text(
                        "Jump on Trend",
                        style: AppFontStyle.text_14_500(
                          AppColors.white,
                          fontFamily: AppFontFamily.interMedium,
                        ),
                      ),
                    ],
                  ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _statBox({required String value, required String label,required Color valueColor, }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color:AppColors.overlayColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            value,
              style: AppFontStyle.text_13_500(valueColor, fontFamily:AppFontFamily.interBold,)
          ),
         hBox(4),
          Text(
            label,
              style: AppFontStyle.text_10_500(AppColors.greyTextColor,fontFamily:AppFontFamily.interRegular)
          ),
        ],
      ),
    );
  }
}