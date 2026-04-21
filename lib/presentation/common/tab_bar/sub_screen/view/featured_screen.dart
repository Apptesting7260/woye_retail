import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gyaawa/Core/Constant/image_constant.dart';
import 'package:gyaawa/Utils/sized_box.dart';
import 'package:gyaawa/presentation/common/tab_bar/common_tab_bar.dart';
import 'package:gyaawa/presentation/common/tab_bar/sub_screen/controller/featured_controller.dart';
import 'package:gyaawa/shared/theme/colors.dart';
import 'package:gyaawa/shared/theme/font_family.dart';
import 'package:gyaawa/shared/theme/font_style.dart';

import '../../../../../Routes/app_routes.dart';
import '../../../../../shared/widgets/Custom_featured_card.dart';

class FeaturedScreen extends StatefulWidget {
  const FeaturedScreen({super.key});

  @override
  State<FeaturedScreen> createState() => _FeaturedScreenState();
}

class _FeaturedScreenState extends State<FeaturedScreen> {
  final FeaturedController controller = Get.put(FeaturedController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              CustomCategoryBar(),
              hBox(1),
              Container(
                height: 203,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                decoration: const BoxDecoration(
                  gradient: AppColors.categoryBarGradient,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () {Get.toNamed(AppRoutes.homeScreen);
                          print("Back button pressed");},
                          child: SvgPicture.asset(ImageConstants.backIconSvg,
                              width: 25),
                        ),
                        wBox(20),
                        Text(
                          "Featured Products",
                          style: AppFontStyle.text_28_600(
                            AppColors.white,
                            fontFamily: AppFontFamily.interBold,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35),
                      child: Text(
                        textAlign: TextAlign.center,
                        "Discover A selection of exceptional products presented by our partners",
                        maxLines: 2,
                        style: AppFontStyle.text_15_400(
                          AppColors.white,
                          fontFamily: AppFontFamily.interRegular,
                        ),
                      ),
                    ),
                    hBox(40)
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Obx(
                  () => Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 4,
                    runSpacing: 8,
                    children: [
                      _chip(
                          index: 0,
                          title: "All Featured",
                          icon: ImageConstants.kingSvg),
                      _chip(
                          index: 1,
                          title: "Best Sellers",
                          icon: ImageConstants.sellerSvg),
                      _chip(
                          index: 2,
                          title: "New Arrivals",
                          icon: ImageConstants.arrivalsSvg),
                      _chip(
                          index: 3,
                          title: "Trending",
                          icon: ImageConstants.tradeSvg),
                      _chip(
                          index: 4,
                          title: "Featured Deals",
                          icon: ImageConstants.starSvg),
                    ],
                  ),
                ),
              ),    hBox(15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 2,
                  children: [
                    statBox(number: "147", label: "Featured Products", color: Colors.black),
                    statBox(number: "124", label: "Highly Rated", color: Colors.green),
                    statBox(number: "29", label: "New Arrivals", color: Colors.blue),
                    statBox(number: "132", label: "Special Deals", color: Colors.orange),
                  ],
                ),
              ),
              hBox(20),
              SizedBox(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return CustomFeaturedCard(
                      onFavTap: () {},
                      image: "https://picsum.photos/id/${5 + index}/300/300",
                      title: "Premium Wireless Laptop - 15 inch Display, 16GB RAM, 512GB SSD",
                      socialCount: "716+",
                      searchCount: "4317+",
                      category: "TechCorp",
                      salePrize: 'GHS 3899.99',
                      regularPrize: 'GHS 4599.99',
                      rating: 4.9,
                      Seller: "Best Seller",
                      tag: "New",
                      discount: 10,
                      totalReviews: 1247,
                      onTap: () {},
                    );
                  },
                ),
              ),
            ],
          ),
        ),

      ),
    );
  }

  Widget _chip({
    required int index,
    required String title,
    required String icon,
  }) {
    final isSelected = controller.selectedIndex.value == index;

    return GestureDetector(
      onTap: () {
        controller.selectedIndex.value = index;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.buttonColor : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.borderClr),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              icon,
              width: 16,
              height: 16,
              colorFilter: ColorFilter.mode(
                isSelected ? AppColors.white : AppColors.black,
                BlendMode.srcIn,
              ),
            ),
            wBox(6),
            Text(
              title,
              style: AppFontStyle.text_12_500(
                isSelected ? AppColors.white : Colors.black,
                fontFamily: AppFontFamily.interMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget statBox({
    required String number,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderClr),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            number,
            style: AppFontStyle.text_26_600(
              color,
              fontFamily: AppFontFamily.interBold,
            ),
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppFontStyle.text_12_400(
              AppColors.buttonHideColor,
              fontFamily: AppFontFamily.interRegular,
            ),
          ),
        ],
      ),
    );
  }

}
