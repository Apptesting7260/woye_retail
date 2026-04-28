import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:gyaawa/shared/widgets/custom_elevated_button.dart';
import 'package:gyaawa/shared/widgets/image.dart';

import '../../../../../../Utils/sized_box.dart';
import '../../../../../../routes/user_routes/user_app_routes.dart';
import '../../../../../../shared/theme/colors.dart';
import '../../../../../../shared/theme/font_family.dart';
import '../../../../../../shared/theme/font_style.dart';
import '../../../../../../shared/widgets/custom_product_card.dart';
import '../../../../../../shared/widgets/custom_top_rated_vendors.dart';
import '../../../../../../shared/widgets/festival_banner.dart';
import '../../../common/home_address/view/home_address_screen.dart';
import '../../../common/tab_bar/common_tab_bar.dart';
import '../controller/home_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: HomeAddressScreen(),
          ),
          SliverToBoxAdapter(
            child: CustomCategoryBar(),
          ),
          SliverToBoxAdapter(child: hBox(15)),
          SliverToBoxAdapter(
            child: categories(),
          ),
          SliverToBoxAdapter(child: hBox(10)),
          SliverToBoxAdapter(
            child: mainBanner(),
          ),
          SliverToBoxAdapter(child: hBox(10)),
          SliverToBoxAdapter(
            child: festivalBannerListWidget(),
          ),
          SliverToBoxAdapter(child: hBox(10)),
          SliverToBoxAdapter(
            child: flashSaleWidget(),
          ),
          SliverToBoxAdapter(child: hBox(10)),
          SliverToBoxAdapter(
            child: trendingWidget(),
          ),
          SliverToBoxAdapter(child: hBox(10)),
          SliverToBoxAdapter(
            child: productGridWidget(),
          ),
          SliverToBoxAdapter(child: hBox(10)),
          SliverToBoxAdapter(
            child: giftIdeasWidget(),
          ),
          SliverToBoxAdapter(
            child: editorsChoiceWidget(),
          ),
          SliverToBoxAdapter(child: hBox(10)),
          SliverToBoxAdapter(
            child: topRatedVendorWidget(),
          ),
          SliverToBoxAdapter(child: hBox(10)),
          SliverToBoxAdapter(
            child: techCorpSliderWidget(),
          ),   SliverToBoxAdapter(child: hBox(10)),
          SliverToBoxAdapter(
            child: vendorCardWidget(),
          ), SliverToBoxAdapter(
            child: newArrivalsWidget(),
          ),SliverToBoxAdapter(child: hBox(30)),
          SliverToBoxAdapter(
            child: bestSellersWidget(),
          ),
          // SliverToBoxAdapter(
          //   child: _pages[_selectedIndex],
          // ),
          SliverToBoxAdapter(child: hBox(100)),
        ],
      ),
    );
  }

  Widget categories() {
    return Column(
      children: [
        Padding(
          padding: REdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text(
                "Categories",
                style: AppFontStyle.text_20_600(
                  AppColors.blackTextColor,
                  fontFamily: AppFontFamily.onestRegular,
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  Get.toNamed(UserRoutes.allCategoriesScreen);
                },
                child: Row(
                  children: [
                    Text(
                      "See All",
                      style: AppFontStyle.text_16_400(
                        AppColors.blueTextColor,
                        fontFamily: AppFontFamily.onestRegular,
                      ),
                    ),
                    wBox(4),
                    Icon(
                      Icons.arrow_forward_sharp,
                      color: AppColors.blueTextColor,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        hBox(14),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(controller.dummyCategories.length, (index) {
              return Padding(
                padding: REdgeInsets.only(
                  left: index == 0 ? 22 : 18,
                  right:
                      index == controller.dummyCategories.length - 1 ? 22 : 0,
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                       Get.toNamed(UserRoutes.categoryScreen);
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.r),
                        child: AppImage(
                          path: controller.dummyCategories[index]["image"]!,
                          fit: BoxFit.cover,
                          height: 55.h,
                          width: 55.h,
                        ),
                      ),
                    ),
                    hBox(10),
                    Text(
                      controller.dummyCategories[index]["name"]!,
                      style: AppFontStyle.text_15_400(
                        AppColors.blueLightColor,
                        fontFamily: AppFontFamily.onestMedium,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
        hBox(20.h),
      ],
    );
  }

  Widget mainBanner() {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount:controller.dummyBanners.length,
          options: CarouselOptions(
            height: 262.h,
            autoPlay: false,
            viewportFraction: 1.0,
            enlargeCenterPage: true,
          ),
          itemBuilder: (context, index, realIndex) {
            final banner = controller.dummyBanners[index];
            return Stack(
              children: [
                AppImage(
                  path: banner["image"],
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (banner["isNew"])
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            "New",
                            style: AppFontStyle.text_10_500(
                              AppColors.buttonColor,
                              fontFamily: AppFontFamily.interMedium,
                            ),
                          ),
                        ),
                      SizedBox(height: 5),
                      if (banner["isBestSeller"])
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.buttonColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "Best Seller",
                            style: AppFontStyle.text_10_500(
                              AppColors.white,
                              fontFamily: AppFontFamily.interMedium,
                            ),
                          ),
                        ),
                      SizedBox(height: 5),
                      if (banner["discount"] > 0)
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.boldRed,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            "-${banner["discount"]}%",
                            style: AppFontStyle.text_10_500(
                              AppColors.white,
                              fontFamily: AppFontFamily.interMedium,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 60,
                  left: 20,
                  child: Container(
                    height: 46,
                    width: 107,
                    decoration: BoxDecoration(
                      color: AppColors.blueButtonColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Center(
                      child: Text(
                        "Buy Now",
                        style: AppFontStyle.text_14_600(
                          AppColors.white,
                          fontFamily: AppFontFamily.onestExtraBold,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.favorite_border, size: 22),
                  ),
                ),
              ],
            );
          },
        ),
        hBox(20),
      ],
    );
  }

  Widget flashSaleWidget() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.darkRed1,
            AppColors.darkRed2,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          hBox(60),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.yellow,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "⚡ FLASH SALE - Limited Time Only!",
                  style: AppFontStyle.text_14_400(
                    AppColors.brownTextClr,
                    fontFamily: AppFontFamily.interMedium,
                  ),
                ),
              ],
            ),
          ),
          hBox(16),
          Text("Up to 80% Off",
              style: AppFontStyle.text_30_600(
                Colors.white,
                fontFamily: AppFontFamily.interBold,
              )),
          hBox(8),
          Text(
            "Grab these incredible deals before\nthey're gone!",
            textAlign: TextAlign.center,
            style: AppFontStyle.text_17_400(
              AppColors.white,
              fontFamily: AppFontFamily.interRegular,
            ),
          ),
          hBox(20),
          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Ends in:",
                      style: AppFontStyle.text_16_600(
                        Colors.white,
                        fontFamily: AppFontFamily.interBold,
                      )),
                  wBox(10),
                  _timerBox(
                      "${controller.hours.value.toString().padLeft(2, '0')}h"),
                  wBox(8),
                  _timerBox(
                      "${controller.minutes.value.toString().padLeft(2, '0')}m"),
                  wBox(8),
                  _timerBox(
                      "${controller.seconds.value.toString().padLeft(2, '0')}s"),
                ],
              )),
          hBox(24),
          SizedBox(
            height: 320,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(left: 16),
              itemCount: controller.flashSaleProducts.length,
              itemBuilder: (context, index) {
                final product = controller.flashSaleProducts[index];
                return _flashProductCard(product);
              },
            ),
          ),
          hBox(20),
        ],
      ),
    );
  }

  Widget _timerBox(String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        value,
        style: AppFontStyle.text_16_600(
          Colors.white,
          fontFamily: AppFontFamily.interBold,
        ).copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _flashProductCard(Map<String, dynamic> product) {
    return Container(
      width: 337,
      margin: EdgeInsets.only(right: 16, bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              AppImage(
                path: product["image"],
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
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
                    "New",
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
                    "Best Seller",
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
                    product["discount"],
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.favorite_border, size: 22),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product["brand"],
                  style: AppFontStyle.text_12_400(
                    AppColors.buttonHideColor,
                    fontFamily: AppFontFamily.interRegular,
                  ),
                ),
                hBox(4),
                Text(
                  product["name"],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppFontStyle.text_12_500(
                    AppColors.black,
                    fontFamily: AppFontFamily.interMedium,
                  ),
                ),
                hBox(6),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 15),
                    Icon(Icons.star, color: Colors.amber, size: 15),
                    Icon(Icons.star, color: Colors.amber, size: 15),
                    Icon(Icons.star, color: Colors.amber, size: 15),
                    wBox(4),
                    Text(
                      "${product["rating"]} (${product["reviews"]})",
                      style: AppFontStyle.text_12_400(
                        AppColors.buttonHideColor,
                        fontFamily: AppFontFamily.interRegular,
                      ),
                    ),
                  ],
                ),
                hBox(6),
                Row(
                  children: [
                    Text(
                      product["price"],
                      style: AppFontStyle.text_14_600(
                        AppColors.buttonColor,
                        fontFamily: AppFontFamily.interBold,
                      ),
                    ),
                    wBox(8),
                    Text(
                      product["originalPrice"],
                      style: AppFontStyle.text_12_400(
                        AppColors.buttonHideColor,
                        fontFamily: AppFontFamily.interRegular,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget trendingWidget() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Trending This Week",
                style: AppFontStyle.text_30_600(
                  AppColors.black,
                  fontFamily: AppFontFamily.interBold,
                ),
              ),
            ),
            hBox(4),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                "See what's popular and trending among our community of shoppers",
                maxLines: 2,
                textAlign: TextAlign.center,
                style: AppFontStyle.text_16_400(
                  AppColors.buttonHideColor,
                  fontFamily: AppFontFamily.interRegular,
                ),
              ),
            ),
            hBox(26),
            Text(
              "Most Searched",
              style: AppFontStyle.text_20_400(
                AppColors.black,
                fontFamily: AppFontFamily.interBold,
              ),
            ),
            ListView.builder(
              itemCount: controller.items.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final item = controller.items[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: Row(
                    children: [
                      Container(
                        height: 26,
                        width: 26,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          gradient: AppColors.blueGradient,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          "${index + 1}",
                          style: AppFontStyle.text_12_500(
                            AppColors.white,
                            fontFamily: AppFontFamily.interMedium,
                          ),
                        ),
                      ),
                      wBox(10),
                      Expanded(
                        child: Text(
                          item["title"]!,
                          style: AppFontStyle.text_14_600(
                            AppColors.black,
                            fontFamily: AppFontFamily.interSemiBold,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.trending_up,
                              color: AppColors.greenTextClr, size: 16),
                          wBox(4),
                          Text(
                            item["percent"]!,
                            style: AppFontStyle.text_12_500(
                              AppColors.greenTextClr,
                              fontFamily: AppFontFamily.interRegular,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget productGridWidget() {
    return GridView.builder(
      itemCount: 6,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.65,
      ),
      itemBuilder: (context, index) {
        return ProductCard(
          image: "https://picsum.photos/200",
          title: "Premium Wireless Laptop ",
          brand: "Brand",
          price: 1000,
          oldPrice: 12,
          rating: 4.5,
          reviews: 120,
          Seller: "Best Seller",
          tag: "New",
          discount: 10,
        );
      },
    );
  }

  Widget festivalBannerListWidget() {
    return ListView.builder(
      itemCount: 1,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(10),
      itemBuilder: (context, index) {
        return FestivalBanner(
          image: "https://picsum.photos/400/200",
          title: "Christmas Fashion",
          subtitle: "Holiday Outfits",
          description:
              "Look festive and stylish with Christmas sweaters, party dresses, and holiday accessories",
          tags: [
            "Christmas Sweaters",
            "Party Dresses",
            "Holiday Accessories",
            "Festive Ties",
          ],
          buttonText: "Shop Christmas Fashion →",
        );
      },
    );
  }

  Widget giftIdeasWidget() {
    return Container(
      width: double.infinity,
      height: 600,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.pinkDark.withAlpha(100),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.pinkDark,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "🎁 Perfect Gifts",
              style: AppFontStyle.text_15_500(
                AppColors.pink,
                fontFamily: AppFontFamily.interMedium,
              ),
            ),
          ),
          hBox(12),
          Text(
            "Gift Ideas for Everyone",
            textAlign: TextAlign.center,
            style: AppFontStyle.text_30_600(
              AppColors.black,
              fontFamily: AppFontFamily.interBold,
            ),
          ),
          SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Find the perfect gift for any occasion with our carefully curated gift collections",
              maxLines: 2,
              textAlign: TextAlign.center,
              style: AppFontStyle.text_15_400(
                AppColors.buttonHideColor,
                fontFamily: AppFontFamily.interRegular,
              ),
            ),
          ),
          hBox(20),
          SizedBox(
            height: 330,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  width: 337,
                  margin: EdgeInsets.only(right: 12),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "For Her",
                        style: AppFontStyle.text_20_600(
                          AppColors.black,
                          fontFamily: AppFontFamily.interBold,
                        ),
                      ),
                      hBox(4),
                      Text(
                        "Beauty & Fashion",
                        style: AppFontStyle.text_14_400(
                          AppColors.buttonHideColor,
                          fontFamily: AppFontFamily.interRegular,
                        ),
                      ),
                      hBox(4),
                      Text(
                        "From GHS 50",
                        style: AppFontStyle.text_16_500(
                          AppColors.buttonColor,
                          fontFamily: AppFontFamily.interSemiBold,
                        ),
                      ),
                      hBox(16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(3, (i) {
                          return AppImage(
                            path:
                                "https://images.unsplash.com/photo-1516826957135-700dedea698c",
                            height: 94,
                            width: 94,
                            fit: BoxFit.cover,
                            borderRadius: 10,
                          );
                        }),
                      ),
                      hBox(14),
                      CustomElevatedButton(
                        color: AppColors.pinkButtonClr,
                        onPressed: () {},
                        text: "Shop Gifts For Her",
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget editorsChoiceWidget() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.editorGradient,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Text(
              "⭐ Staff Picks",
              style: AppFontStyle.text_15_500(
                AppColors.white,
                fontFamily: AppFontFamily.interMedium,
              ),
            ),
          ),
          hBox(12),
          Text(
            "Editor's Choice",
            textAlign: TextAlign.center,
            style: AppFontStyle.text_30_600(
              AppColors.white,
              fontFamily: AppFontFamily.interBold,
            ),
          ),
          SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Handpicked by our team of experts - products that represent the best in quality, design, and value",
              textAlign: TextAlign.center,
              maxLines: 3,
              style: AppFontStyle.text_17_400(
                AppColors.white,
                fontFamily: AppFontFamily.interRegular,
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  child: AppImage(
                    path:
                        "https://images.unsplash.com/photo-1517336714731-489689fd1ca8",
                    height: 160,
                    width: 373,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.yellow,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          "EDITOR'S PICK OF THE WEEK",
                          style: AppFontStyle.text_10_500(AppColors.black,
                              fontFamily: AppFontFamily.interMedium),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Premium Wireless Laptop",
                        style: AppFontStyle.text_14_600(
                          AppColors.white,
                          fontFamily: AppFontFamily.interBold,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        '"This laptop has revolutionized my workflow. The build quality is exceptional, performance is blazing fast, and the design is simply stunning." - Sarah, Tech Editor',
                        maxLines: 4,
                        style: AppFontStyle.text_15_400(
                          AppColors.white,
                          fontFamily: AppFontFamily.interRegular,
                        ),
                      ),
                      hBox(10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              hBox(4),
                              Text(
                                "GHS 4,599.99",
                                style: AppFontStyle.text_26_400(
                                  AppColors.white,
                                  fontFamily: AppFontFamily.interBold,
                                ),
                              ),
                              Text(
                                "GHS 3,899.99",
                                style: AppFontStyle.text_14_600(
                                  AppColors.white,
                                  fontFamily: AppFontFamily.interBold,
                                ),
                              ),
                            ],
                          ),
                          CustomElevatedButton(
                            height: 35,
                            width: 111,
                            onPressed: () {},
                            text: "Shop Now",
                            textStyle: AppFontStyle.text_12_500(
                              AppColors.black,
                              fontFamily: AppFontFamily.interMedium,
                            ),
                          ),
                        ],
                      ),
                      hBox(20),
                    ],
                  ),
                ),
              ],
            ),
          ),
          hBox(30),
          productListWidget(),
        ],
      ),
    );
  }

  Widget productListWidget() {
    return ListView.builder(
      itemCount: 5,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: AppColors.white.withAlpha(30)),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: AppImage(
                  path: "https://picsum.photos/200",
                  height: 70,
                  width: 70,
                  fit: BoxFit.cover,
                ),
              ),
              wBox(13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Professional Wireless Headphones - Noise Cancelling",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppFontStyle.text_14_500(AppColors.white,
                            fontFamily: AppFontFamily.interSemiBold)),
                hBox(6),
                    Text(
                      "GHS 1099.99",
                        style: AppFontStyle.text_14_500(AppColors.white,
                            fontFamily: AppFontFamily.interSemiBold)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget techCorpSliderWidget() {
    return SizedBox(
      height: 805,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.productList.length,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemBuilder: (context, index) {
          final product = controller.productList[index];
          return Container(
            width: 360,
            margin: const EdgeInsets.only(right: 12),
            child: TechCorpStoreCard(
              brandName: product["brandName"],
              description: product["description"],
              category: product["category"],
              rating: product["rating"],
              reviews: product["reviews"],
              products: product["products"],
              yearsActive: product["yearsActive"],
              topTag: product["topTag"],
              bannerImageUrl: product["bannerImageUrl"],
              logoImageUrl: product["logoImageUrl"],
              popularProducts: List<Map<String, String>>.from(product["popularProducts"]),
              badges: List<String>.from(product["badges"]),
              onVisitTap: () {},
            ),
          );
        },
      ),
    );
  }

  Widget topRatedVendorWidget() {
    return Column(
      children: [

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              hBox(50),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.overlayColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "🏆 Trusted Marketplace Partners",
                  style: AppFontStyle.text_15_500(AppColors.buttonColor,
                      fontFamily: AppFontFamily.interMedium),
                ),
              ),
              hBox(16),
              Text(
                "Top Rated Vendors",
                textAlign: TextAlign.center,
                style: AppFontStyle.text_30_600(AppColors.blueTextColor,
                    fontFamily: AppFontFamily.interBold),
              ),
              hBox(10),
              Text(
                "Shop with confidence from our highest-rated marketplace sellers who have consistently delivered exceptional service and quality products",
                textAlign: TextAlign.center,
                maxLines: 5,
                style: AppFontStyle.text_17_400(AppColors.greyTextColor,
                    fontFamily: AppFontFamily.interRegular),
              ),
              hBox(20),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.all(18),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 0.9,color: AppColors.greyLightColor),
            gradient: AppColors.gradientClr,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child:  Text(
                      "🏆 Vendor of the Month",
                        style: AppFontStyle.text_12_500(AppColors.white,
                            fontFamily: AppFontFamily.interMedium)),
                    ),
                  wBox(10),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: AppColors.buttonColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child:  Text(
                      "Top Seller",
                        style: AppFontStyle.text_12_500(AppColors.white,
                            fontFamily: AppFontFamily.interMedium)),
                  ),
                ],
              ),
              hBox(15),
               Text(
                "TechCorp",
                  style: AppFontStyle.text_26_600(AppColors.blueTextColor,
                      fontFamily: AppFontFamily.interBold)),
             hBox(6),
               Text(
                "Leading technology retailer specializing in cutting-edge electronics and innovative gadgets for modern lifestyles.",
                maxLines: 3,
                  style: AppFontStyle.text_14_400(AppColors.greyTextColor,
                      fontFamily: AppFontFamily.interRegular)),
        
              hBox(10),
              Row(
                children: [
                  ...List.generate(
                    5,
                        (index) =>  Icon(Icons.star,
                        color: AppColors.starClr, size: 20),
                  ),
                  const SizedBox(width: 6),
                  Text("3.5",
                      style: AppFontStyle.text_17_600(AppColors.blueTextColor,
                          fontFamily: AppFontFamily.interBold)),
                 wBox(20),
                  Text("1,250+",
                      style: AppFontStyle.text_17_600(AppColors.buttonColor,
                          fontFamily: AppFontFamily.interBold)),
                ],
              ),
               hBox(4),
               Row(
                 children: [
                   Text(
                    "2,847 reviews",
                       style: AppFontStyle.text_13_400(AppColors.greyTextColor,
                       fontFamily: AppFontFamily.interRegular)
                             ),
                   wBox(60),
                   Text("Products available",
                       style: AppFontStyle.text_13_400(AppColors.greyTextColor,
                           fontFamily: AppFontFamily.interRegular)),
                 ],
               ),
              hBox(10),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child:  Text("Best Tech Vendor 2024",
                        style: AppFontStyle.text_10_500(AppColors.greyTextColor,
                            fontFamily: AppFontFamily.interMedium)),
                  ),
                wBox(6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child:  Text("98.8% Positive Feedback",
                        style: AppFontStyle.text_10_500(AppColors.greyTextColor,
                            fontFamily: AppFontFamily.interMedium)),
                  ),
                ],
              ),
              hBox(20),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text("Top Products",
          style: AppFontStyle.text_18_500(AppColors.blueTextColor,
          fontFamily: AppFontFamily.interBold)),
        ),
        
              topProductListWidget()
            ],
          ),
        ),
      ],
    );
  }

  Widget topProductListWidget() {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
          itemCount: 5,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 10),
          itemBuilder: (context, index) {
            return Container(
              margin:  EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              padding:  EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.white),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: AppImage(
                      path: "https://picsum.photos/200",
                      height: 51,
                      width: 51,
                      fit: BoxFit.cover,
                    ),
                  ),
                  wBox(13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Wireless Headphones",
                            style: AppFontStyle.text_14_500(AppColors.blueTextColor,
                                fontFamily: AppFontFamily.interSemiBold)),
                        hBox(6),
                        Text("GHS 1099.99",
                            style: AppFontStyle.text_10_500(AppColors.greyTextColor,
                                fontFamily: AppFontFamily.interRegular)),
                      ],
                    ),
                  ),
                   Icon(
                    Icons.arrow_forward,
                    size: 20,
                    color: AppColors.buttonColor
                  ),
                ],
              ),
            );
          },
        ),
        CustomElevatedButton(
          height: 40,
          width: 200,
          text: "Visit TechCorp Store    ->", textStyle: AppFontStyle.text_13_500(AppColors.white,
    fontFamily: AppFontFamily.interMedium),
          color: AppColors.buttonColor,
            onPressed: (){}
        ),
        hBox(20),
      ],
    );
  }
  Widget vendorCardWidget() {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 0.9,color: AppColors.borderClr),
        gradient: AppColors.gradientClr,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Want to Become a Vendor?",
            textAlign: TextAlign.center,
          style: AppFontStyle.text_20_500(AppColors.blueTextColor,
              fontFamily: AppFontFamily.interBold)),
         hBox(10),
          Text(
            "Join our growing marketplace of successful sellers and reach millions of potential customers worldwide",
            textAlign: TextAlign.center,
              maxLines: 3,
              style: AppFontStyle.text_14_400(AppColors.greyTextColor,
                  fontFamily: AppFontFamily.interRegular)),
          hBox(20),
          CustomElevatedButton(
            height: 45.h,
            borderRadius: BorderRadius.circular(10.r),
            color: AppColors.buttonColor,
            text: "Start Selling  →",
            onPressed: () {
            },
          ),
          hBox(12),
          CustomElevatedButton(
            height: 45.h,
            color: Colors.white,
            textColor: Colors.black,
            text: "Learn More About Selling",
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget newArrivalsWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.lightBlueClr,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            "✨ Fresh & New",
            style: AppFontStyle.text_16_500(
              AppColors.royalBlueClr,
              fontFamily: AppFontFamily.interMedium,
            ),
          ),
        ),
        hBox(10),
        Text(
          "New Arrivals",
          style: AppFontStyle.text_30_600(
            AppColors.blueTextColor,
            fontFamily: AppFontFamily.interBold,
          ),
        ),hBox(10),
        Padding(
          padding: const EdgeInsets.only(left: 16,right: 12),
          child: Text(
            "Be the first to discover our latest products from top brands and emerging designers",
            maxLines: 2,
            textAlign: TextAlign.center,
            style: AppFontStyle.text_15_400(
              AppColors.buttonHideColor,
              fontFamily: AppFontFamily.interRegular,
            ),
          ),
        ),
        hBox(20),

        GridView.builder(
          itemCount: 6,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(10),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.65,
          ),
          itemBuilder: (context, index) {
            return ProductCard(
              image: "https://picsum.photos/200",
              title: "Premium Wireless Laptop ",
              brand: "Brand",
              price: 1000,
              oldPrice: 12,
              rating: 4.5,
              reviews: 120,
              Seller: "Best Seller",
              tag: "New",
              discount: 10,
            );
          },
        ),    hBox(20),
        CustomElevatedButton(
          width: 280,
          height: 40,
          text: "Shop More New Arrivals   →",
          color: AppColors.buttonColor,
            onPressed: (){}

        ),
      ],
    );
  }
  Widget bestSellersWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.yellowLightClr,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            "🏆 Customer Favorites",
            style: AppFontStyle.text_16_500(
              AppColors.brownLightClr,
              fontFamily: AppFontFamily.interMedium,
            ),
          ),
        ),
        hBox(10),
        Text(
          "Best Sellers ",
          style: AppFontStyle.text_30_600(
            AppColors.blueTextColor,
            fontFamily: AppFontFamily.interBold,
          ),
        ),hBox(10),
        Padding(
          padding: const EdgeInsets.only(left: 16,right: 12),
          child: Text(
            "The most loved products by our community, proven by thousands of satisfied customers",
            maxLines: 2,
            textAlign: TextAlign.center,
            style: AppFontStyle.text_15_400(
              AppColors.buttonHideColor,
              fontFamily: AppFontFamily.interRegular,
            ),
          ),
        ),
        hBox(20),
        GridView.builder(
          itemCount: 6,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(10),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.65,
          ),
          itemBuilder: (context, index) {
            return ProductCard(
              image: "https://picsum.photos/200",
              title: "Premium Wireless Laptop ",
              brand: "Brand",
              price: 1000,
              oldPrice: 12,
              rating: 4.5,
              reviews: 120,
              Seller: "Best Seller",
              tag: "New",
              discount: 10,
            );
          },
        ),
      ],
    );
  }
}
