import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../theme/font_family.dart';
import '../theme/font_style.dart';
import 'image.dart';

class ProductCard extends StatelessWidget {
  final String image;
  final String title;
  final String brand;
  final double price;
  final double oldPrice;
  final double rating;
  final int reviews;
  final String tag;
  final String Seller;
  final int discount;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.image,
    required this.title,
    required this.brand,
    required this.price,
    required this.oldPrice,
    required this.rating,
    required this.reviews,
    required this.tag,
    required this.Seller,
    required this.discount,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child:  Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16)),
                  child: AppImage(
                    path: image,
                    height: 167,
                    width: 180,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      tag,
                      style: AppFontStyle.text_10_500(
                        AppColors.buttonColor,
                        fontFamily: AppFontFamily.interMedium,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 10,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.buttonColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                       Seller,
                      style: AppFontStyle.text_10_500(
                        AppColors.white,
                        fontFamily: AppFontFamily.interMedium,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 70,
                  left: 10,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.boldRed,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "-$discount%",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.favorite_border, size: 18),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),
            Text(
              brand,
              style: AppFontStyle.text_12_400(
                AppColors.buttonHideColor,
                fontFamily: AppFontFamily.interRegular,
              ),
            ),

            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppFontStyle.text_12_500(
                AppColors.black,
                fontFamily: AppFontFamily.interMedium,
              ),
            ),

            const SizedBox(height: 5),
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 14),
                Icon(Icons.star, color: Colors.amber, size: 14),
                Icon(Icons.star, color: Colors.amber, size: 14),
                Icon(Icons.star, color: Colors.amber, size: 14),
                Text(
                  "$rating ($reviews)",
               style: AppFontStyle.text_12_400(
                    AppColors.buttonHideColor,
                    fontFamily: AppFontFamily.interRegular,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 5),
            Row(
              children: [
                Text(
                  "GHS $price",
                  style: AppFontStyle.text_14_600(
                    AppColors.buttonColor,
                    fontFamily: AppFontFamily.interBold,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  "GHS $oldPrice",
                  overflow: TextOverflow.ellipsis,
                  style:  AppFontStyle.text_12_400(
                    AppColors.buttonHideColor,
                    fontFamily: AppFontFamily.interRegular,
                  ),
                ),
              ],
            ),
          ],
        ),
    ),
    );
  }
}

