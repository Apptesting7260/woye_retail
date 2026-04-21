import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gyaawa/presentation/common/tab_bar/common_tab_bar.dart';
import '../../../../../Core/Constant/image_constant.dart';
import '../../../../../Utils/sized_box.dart';
import '../../../../../shared/theme/colors.dart';
import '../../../../../shared/theme/font_family.dart';
import '../../../../../shared/theme/font_style.dart';
import '../../../../../shared/widgets/Custom_featured_card.dart';
import '../../../../../shared/widgets/Custom_gift_image_slider.dart';
import '../controller/gift_controller.dart';

class GiftScreen extends StatefulWidget {
  const GiftScreen({super.key});

  @override
  State<GiftScreen> createState() => _GiftScreenState();
}

class _GiftScreenState extends State<GiftScreen> {
  final GiftController controller = Get.put(GiftController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            CustomCategoryBar(),
            hBox(1),
            Container(
              height: 210,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: const BoxDecoration(
                gradient: AppColors.pinkRedGradient,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: SvgPicture.asset(
                          ImageConstants.backIconSvg,
                          width: 24,
                          color: AppColors.white,
                        ),
                      ),
                      const Spacer(
                        flex: 2,
                      ),
                      Text(
                        "Gift Ideas",
                        style: AppFontStyle.text_24_600(
                          AppColors.white,
                          fontFamily: AppFontFamily.interBold,
                        ),
                      ),
                      const Spacer(flex: 2),
                    ],
                  ),
                  hBox(20),
                  Text(
                    "Find the perfect gift for everyone on your list. From thoughtful surprises to "
                    "luxury treats, we have something special for every occasion and budget",
                    textAlign: TextAlign.center,
                    maxLines: 4,
                    style: AppFontStyle.text_16_400(
                      AppColors.white,
                      fontFamily: AppFontFamily.interRegular,
                    ),
                  ),
                ],
              ),
            ),
            hBox(10),
            ImageSliderCard(
              title: "Stocking Stuffers",
              subTitle: "Small gifts, big smiles",
              images: [
                "https://picsum.photos/200",
                "https://picsum.photos/201",
                "https://picsum.photos/202",
                "https://picsum.photos/203",
                "https://picsum.photos/200",
                "https://picsum.photos/201",
                "https://picsum.photos/202",
                "https://picsum.photos/203",
                "https://picsum.photos/200",
                "https://picsum.photos/201",
                "https://picsum.photos/202",
                "https://picsum.photos/203",
              ],
              itemCount: "15 Items",
            ),
            ImageSliderCard(
              title: "Luxury Gifts",
              subTitle: "Premium presents for special people",
              gradient: AppColors.purpleBlueGradient,
              images: [
                "https://picsum.photos/200",
                "https://picsum.photos/201",
                "https://picsum.photos/202",
                "https://picsum.photos/203",
                "https://picsum.photos/200",
                "https://picsum.photos/201",
                "https://picsum.photos/202",
                "https://picsum.photos/203",
                "https://picsum.photos/200",
                "https://picsum.photos/201",
                "https://picsum.photos/202",
                "https://picsum.photos/203",
              ],
              itemCount: "15 Items",
            ),
            ImageSliderCard(
              title: "Tech Gifts",
              subTitle: "Latest gadgets & innovations",
              gradient: AppColors.blueCyanGradient,
              images: [
                "https://picsum.photos/200",
                "https://picsum.photos/201",
                "https://picsum.photos/202",
                "https://picsum.photos/203",
                "https://picsum.photos/200",
                "https://picsum.photos/201",
                "https://picsum.photos/202",
                "https://picsum.photos/203",
                "https://picsum.photos/200",
                "https://picsum.photos/201",
                "https://picsum.photos/202",
                "https://picsum.photos/203",
              ],
              itemCount: "154 Items",
            ),
            ImageSliderCard(
              title: "Wellness & Self-Care",
              subTitle: "Gifts for mind, body & soul",
              gradient: AppColors.greenTealGradient,
              images: [
                "https://picsum.photos/200",
                "https://picsum.photos/201",
                "https://picsum.photos/202",
                "https://picsum.photos/203",
                "https://picsum.photos/200",
                "https://picsum.photos/201",
                "https://picsum.photos/202",
                "https://picsum.photos/203",
                "https://picsum.photos/200",
                "https://picsum.photos/201",
                "https://picsum.photos/202",
                "https://picsum.photos/203",
              ],
              itemCount: "154 Items",
            ),
            hBox(10),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                "Gift Categories",
                style: AppFontStyle.text_14_400(AppColors.black,fontFamily: AppFontFamily.interBold)
              ),
            ),
            hBox(14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 16,
                  childAspectRatio: 2.4,
                ),
                itemCount: controller.categories.length,
                itemBuilder: (context, index) {
                  final cat = controller.categories[index];
                  final isSelected = controller.selectedCategory == cat["title"];
                  return GestureDetector(
                    onTap: () => controller.selectedCategory = cat["title"],
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.buttonColor : AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? AppColors.buttonColor : AppColors.borderClr,
                          width: 1.2,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Icon(
                                cat["icon"],
                                size: 20,
                                color: isSelected ? AppColors.white : const Color(0xFF2D3748),
                              ),
                              wBox(8),
                              Text(
                                cat["title"],
                                style: AppFontStyle.text_14_600(
                                  isSelected ? AppColors.white : AppColors.black,
                                  fontFamily: AppFontFamily.interMedium,
                                ),
                              ),
                            ],
                          ),
                        hBox(2),
                          Text(
                            cat["subtitle"],
                            style: AppFontStyle.text_10_500(
                              isSelected ? AppColors.white : AppColors.black,
                              fontFamily: AppFontFamily.interMedium,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ), hBox(10),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    "Prize Range",
                      style: AppFontStyle.text_14_400(AppColors.black,fontFamily: AppFontFamily.interBold)

                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Obx(
                        () => Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 4,
                      runSpacing: 8,
                      children: [
                        _chip(
                          index: 0,
                          title: "All Prices",
                        ),
                        _chip(
                          index: 1,
                          title: "Under GHS 100",
                        ),
                        _chip(
                          index: 2,
                          title: "GHS 100 - 500",
                        ),
                        _chip(
                          index: 3,
                          title: "GHS 500 - 1,000",
                        ),
                        _chip(
                          index: 4,
                          title: "Over GHS 1,000",
                        ),
                      ],
                    ),
                  ),
                ),
                hBox(10),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    "All Gift Ideas(101 items)",
                      style: AppFontStyle.text_20_600(AppColors.black,fontFamily: AppFontFamily.interBold),
                  ),
                ),
            SizedBox(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 6,
                itemBuilder: (context, index) {
                  return CustomFeaturedCard(
                    onFavTap: () {},
                    image: "https://picsum.photos/id/${5 + index}/300/300",
                    title:
                        "Premium Wireless Laptop - 15 inch Display, 16GB RAM, 512GB SSD",
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
          ]),
        ),
      ),
    );
  }
  Widget _chip({
    required int index,
    required String title,
  }) {
    final isSelected = controller.selectedIndex.value == index;

    return GestureDetector(
      onTap: () {
        controller.selectedIndex.value = index;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.buttonColor : AppColors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.borderClr),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.attach_money,
              size: 16,
              color: isSelected ? AppColors.white : AppColors.black,
            ),
            Text(
              title,
              style: AppFontStyle.text_12_500(
                isSelected ? AppColors.white : AppColors.black,
                fontFamily: AppFontFamily.interMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }}
