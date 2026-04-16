import 'package:flutter/material.dart';
import 'package:gyaawa/Utils/sized_box.dart';
import 'package:gyaawa/shared/widgets/image.dart';
import '../theme/colors.dart';
import '../theme/font_family.dart';
import '../theme/font_style.dart';

class TechCorpStoreCard extends StatelessWidget {
  final String brandName;
  final String description;
  final String category;
  final double rating;
  final int reviews;
  final int products;
  final int yearsActive;
  final String topTag;
  final String logoImageUrl;
  final String bannerImageUrl;
  final List<Map<String, String>> popularProducts;
  final List<String> badges;
  final String responseTime;
  final String shippingTime;

  const TechCorpStoreCard({
    Key? key,
    required this.brandName,
    required this.description,
    required this.category,
    required this.rating,
    required this.reviews,
    required this.products,
    required this.yearsActive,
    required this.topTag,
    required this.logoImageUrl,
    required this.bannerImageUrl,
    required this.popularProducts,
    required this.badges,
    this.responseTime = "< 2 hours",
    this.shippingTime = "1-2 days",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: AppImage(
                  path: bannerImageUrl,
                  width: double.infinity,
                  height: 111,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    topTag,
                    style: AppFontStyle.text_10_500(AppColors.blueTextColor,
                        fontFamily: AppFontFamily.interMedium),
                  ),
                ),
              ),
              Positioned(
                bottom: -22,
                left: 12,
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    border: Border.all(width: 1, color: AppColors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: AppImage(
                    path: logoImageUrl,
                    width: 40,
                    height: 40,
                    borderRadius: 12,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  brandName,
                  style: AppFontStyle.text_18_600(AppColors.black,
                      fontFamily: AppFontFamily.interBold),
                ),
                hBox(4),
                Text(
                  description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: AppFontStyle.text_13_400(AppColors.greyTextColor,
                      fontFamily: AppFontFamily.interRegular),
                ),
                hBox(8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.filledClr,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    category,
                    style: AppFontStyle.text_10_500(AppColors.buttonColor,
                        fontFamily: AppFontFamily.interMedium),
                  ),
                ),
                hBox(12),
                Row(
                  children: [
                    ...List.generate(
                      5,
                          (i) =>
                          Icon(Icons.star, color: AppColors.starClr, size: 20),
                    ),
                    wBox(6),
                    Text(
                      rating.toStringAsFixed(1),
                      style: AppFontStyle.text_15_400(AppColors.black,
                          fontFamily: AppFontFamily.interBold),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "$reviews reviews",
                      style: AppFontStyle.text_13_400(AppColors.greyColors,
                          fontFamily: AppFontFamily.interRegular),
                    ),
                  ],
                ),
                hBox(8),
                Row(
                  children: [
                    _infoChip(value: "$products", label: "Products"),
                    wBox(8),
                    _infoChip(value: "$yearsActive+", label: "Years Active", isHighlighted: true),
                  ],
                ),
                hBox(16),
                Row(
                  children: [
                    _dotInfo(color: AppColors.greenTextClr, text: "Response: $responseTime"),
                    wBox(19),
                    _dotInfo(color: AppColors.blueClr, text: "Shipping: $shippingTime"),
                  ],
                ),
              hBox(20),
                Text(
                  "Popular Products",
                  style: AppFontStyle.text_14_500(AppColors.black,
                      fontFamily: AppFontFamily.interSemiBold),
                ),
              hBox(8),
                Row(
                  children: List.generate(popularProducts.length > 3 ? 3 : popularProducts.length, (index) {
                    final item = popularProducts[index];
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: index == 2 ? 0 : 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppImage(
                              path: item["image"] ?? "",
                             width: 95,
                              height: 95,
                              fit: BoxFit.cover,
                              borderRadius: 10,
                            ),
                            hBox(6),
                            Text(
                              item["title"] ?? "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppFontStyle.text_12_500(
                                AppColors.greyTextColor,
                                fontFamily: AppFontFamily.interRegular,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
                hBox(30),

                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    decoration: BoxDecoration(
                      color: AppColors.buttonColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Visit $brandName Store",
                          style: AppFontStyle.text_14_500(AppColors.white,
                              fontFamily: AppFontFamily.interMedium),
                        ),
                        const SizedBox(width: 6),
                        Icon(Icons.arrow_forward, color: AppColors.white,
                            size: 16),
                      ],
                    ),
                  ),
                ),
                hBox(10),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: badges
                      .map(
                        (badge) =>
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: AppColors.borderClr),
                          ),
                          child: Text(
                            badge,
                            style: AppFontStyle.text_10_500(AppColors
                                .greyTextColor,
                                fontFamily: AppFontFamily.interMedium),
                          ),
                        ),
                  )
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _dotInfo({required Color color, required String text}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
wBox(6),
        Text(
          text,
          style: AppFontStyle.text_10_500(
            AppColors.greyTextColor,
            fontFamily: AppFontFamily.interRegular,
          ),
        ),
      ],
    );
  }

  Widget _infoChip({
    required String value,
    required String label,
    bool isHighlighted = false,
  }) {
    return Expanded(
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: AppColors.overlayColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: AppFontStyle.text_20_600(
                isHighlighted ? AppColors.greenTextClr : AppColors.black,
                fontFamily: AppFontFamily.interBold,
              ),
            ),
          hBox(5),
            Text(
              label,
              style: AppFontStyle.text_13_400(
                AppColors.greyTextColor,
                fontFamily: AppFontFamily.interRegular,
              ),
            ),
          ],
        ),
      ),
    );
  }
}