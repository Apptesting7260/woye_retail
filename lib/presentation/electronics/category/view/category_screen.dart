import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gyaawa/Core/Constant/image_constant.dart';
import 'package:gyaawa/Utils/sized_box.dart';
import '../../../../shared/theme/colors.dart';
import '../../../../shared/theme/font_family.dart';
import '../../../../shared/theme/font_style.dart';
import '../../../../shared/widgets/custom_dropdown.dart';
import '../../../../shared/widgets/custom_product_card.dart';
import '../../../common/tab_bar/common_tab_bar.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              const CustomCategoryBar(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Electronics",
                          style: AppFontStyle.text_20_500(
                            AppColors.black,
                            fontFamily: AppFontFamily.interBold,
                          ),
                        ),
                        hBox(2),
                        Text(
                          "36 products found",
                          style: AppFontStyle.text_14_400(
                            AppColors.buttonHideColor,
                            fontFamily: AppFontFamily.interRegular,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.share_outlined,
                            size: 22,
                            color: AppColors.black,
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          child: SvgPicture.asset(
                            ImageConstants.cartSvg,
                            height: 35,
                            width: 35,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.borderClr),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 13),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.overlayColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: CustomDropDown(
                        selectedValue: "Featured",
                        hintText: "Featured",
                        items: const ["Featured", "Popular", "Newest"],
                        borderColor: Colors.transparent,
                        btnHeight: 40,
                        padding: 8,
                        onChanged: (value) {},
                      ),
                    ),

                   wBox(18),
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.overlayColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: SvgPicture.asset(ImageConstants.gridViewSvg)
                          ),
                        wBox(6),
                           Padding(
                            padding: EdgeInsets.all(8.0),
                            child: SvgPicture.asset(ImageConstants.menuSvg,width: 20,)
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),
                    Container(
                      height: 40,
                      margin: const EdgeInsets.only(right: 16),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.overlayColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child:  Row(
                        children: [
                          SvgPicture.asset(ImageConstants.filterSvg,width: 15,),
                          SizedBox(width: 6),
                          Text("Filters", style: AppFontStyle.text_12_500(
                            AppColors.black,
                            fontFamily: AppFontFamily.interMedium,
                          ),),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              bestSellersWidget()
            ],
          ),
        ),
      ),
    );
  }
  Widget bestSellersWidget() {
    return
        GridView.builder(
          itemCount: 15,
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
}