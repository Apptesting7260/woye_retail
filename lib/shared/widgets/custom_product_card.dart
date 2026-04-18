import 'package:flutter/material.dart';
import 'package:gyaawa/Utils/sized_box.dart';

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
      child: Container(
        width: 180,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
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
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                if (tag.isNotEmpty)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: _buildTag(tag, AppColors.white, AppColors.buttonColor),
                  ),

                if (Seller.isNotEmpty)
                  Positioned(
                    top: 35,
                    left: 8,
                    child: _buildTag(Seller, AppColors.buttonColor, Colors.white),
                  ),

                if (discount > 0)
                  Positioned(
                    top: 62,
                    left: 8,
                    child: _buildTag(
                      "-$discount%",
                      AppColors.boldRed,
                      Colors.white,
                    ),
                  ),

                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.favorite_border, size: 18),
                  ),
                ),
              ],
            ),
           hBox(8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    brand,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppFontStyle.text_12_400(
                      AppColors.buttonHideColor,
                      fontFamily: AppFontFamily.interRegular,
                    ),
                  ),
                  Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: AppFontStyle.text_12_500(
                      AppColors.black,
                      fontFamily: AppFontFamily.interMedium,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 2),
                      Text(
                        "$rating ($reviews)",
                        style: AppFontStyle.text_12_400(
                          AppColors.buttonHideColor,
                          fontFamily: AppFontFamily.interRegular,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "GHS $price",
                        style: AppFontStyle.text_14_600(
                          AppColors.buttonColor,
                          fontFamily: AppFontFamily.interBold,
                        ),
                      ),
                      wBox(4),
                      Text(
                        "GHS $oldPrice",
                        style: AppFontStyle.text_12_400(
                          AppColors.buttonHideColor,
                          fontFamily: AppFontFamily.interRegular,
                        ).copyWith(
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            hBox(10),
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
