import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gyaawa/Core/Constant/image_constant.dart';
import 'package:gyaawa/Utils/sized_box.dart';
import 'package:gyaawa/shared/theme/font_family.dart';
import 'package:gyaawa/shared/theme/font_style.dart';
import 'package:gyaawa/shared/widgets/custom_elevated_button.dart';
import 'package:gyaawa/shared/widgets/image.dart';

import '../theme/colors.dart';

class CustomKitchenWordCard extends StatelessWidget {
  String? image;
   String? title;
   String? socialCount;
   String? searchCount;
   String? subTitle;
   String? percentage;
   String? description;
  String? dayLeft;
  String? salePrize;
  String? regularPrize;
   double? rating;
   int? totalReviews;
   VoidCallback? onFavTap;
   VoidCallback? onTap;
   VoidCallback? save;


   CustomKitchenWordCard({
    super.key,
     this.image,
     this.title,
     this.socialCount,
     this.description,
     this.searchCount,
     this.subTitle,
     this.percentage,
     this.salePrize,
     this.regularPrize,
     this.rating,
     this.totalReviews,
     this.dayLeft,
    this.onFavTap,
    this.onTap,
    this.save,
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
                    path: image ?? "",
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
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.errorColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(percentage ?? "",
                        style: AppFontStyle.text_15_600(AppColors.white,
                            fontFamily: AppFontFamily.interBold)),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.watch_later_outlined,color: AppColors.white,size: 15,),
                        wBox(5),
                        Text("$dayLeft",
                            style: AppFontStyle.text_10_500(AppColors.white,
                                fontFamily: AppFontFamily.interMedium)),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
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
                    Text("$title ",
                        maxLines: 2,
                        style: AppFontStyle.text_15_600(AppColors.black,
                            fontFamily: AppFontFamily.interBold)),
                    hBox(10),
                    Text(
                        subTitle ?? "",
                        style: AppFontStyle.text_12_500(AppColors.buttonColor,
                            fontFamily: AppFontFamily.interMedium)),
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
                        Text(
                            rating!.toStringAsFixed(1),
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
                    // hBox(8),
                    // Text(
                    //   maxLines: 4,
                    //   description ?? "",
                    //   style: AppFontStyle.text_12_400(AppColors.greyTextColor,
                    //       fontFamily: AppFontFamily.interRegular),
                    // ),
                     hBox(6),
                    Row(
                      children: [
                        Text(
                          salePrize ?? "",
                          style: AppFontStyle.text_20_500(AppColors.redTextClr,
                              fontFamily: AppFontFamily.interBold),
                        ),
                        wBox(6),
                        Text(
                          regularPrize ?? "",
                          style: AppFontStyle.text_16_400(AppColors.greyColors,
                              fontFamily: AppFontFamily.interRegular),
                        ),
                      ],
                    ),
                    hBox(12),
                    CustomElevatedButton(
                      onPressed: save ?? () {},
                      color: AppColors.greenButtonColor,
                      width: double.infinity,
                      height: 42,
                      text: "You Save: GHS 200.00",
                      textColor: AppColors.greenBtnTextClr,
                    ),

                    hBox(12),
                    CustomElevatedButton(
                      onPressed: onTap ?? () {},
                      color: AppColors.errorColor,
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
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}