import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gyaawa/apps/user_app/presentation/common/tab_bar/common_tab_bar.dart';
import 'package:gyaawa/shared/widgets/custom_elevated_button.dart';
import '../../../../../../../Core/Constant/image_constant.dart';
import '../../../../../../../Utils/sized_box.dart';
import '../../../../../../../shared/theme/colors.dart';
import '../../../../../../../shared/theme/font_family.dart';
import '../../../../../../../shared/theme/font_style.dart';
import '../../../../../../../shared/widgets/Custom_editor_choice_card.dart';
import '../../../../../../../shared/widgets/Custom_featured_card.dart';
class EditorChoiceScreen extends StatefulWidget {
  const EditorChoiceScreen({super.key});

  @override
  State<EditorChoiceScreen> createState() => _EditorChoiceScreenState();
}

class _EditorChoiceScreenState extends State<EditorChoiceScreen> {
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
                height: 350,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: const BoxDecoration(
                  gradient: AppColors.darkGradient,
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
                          "Editor’s Choice",
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
                      "Handpicked by our team of experts - products that represent the best"
                      " in quality and value. Each item has been thoroughly tested and reviewed by our editorial team.",
                      textAlign: TextAlign.center,
                      maxLines: 4,
                      style: AppFontStyle.text_15_400(
                        AppColors.white,
                        fontFamily: AppFontFamily.interRegular,
                      ),
                    ),
                    hBox(30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _statBox("15+", "Experts Review"),
                        _statBox("50+", "Hours Testing"),
                        _statBox("4.8★", "Average Rating"),
                      ],
                    ),
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
                    return CustomEditorChoiceCard(
                      onFavTap: () {},
                      image: "https://picsum.photos/id/${0 + index}/300/300",
                      title: "Premium Wireless Laptop - 15 inch Display, 16GB RAM, 512GB SSD",
                      socialCount: "716+",
                      searchCount: "4317+",
                      subTitle: "Editor's Pick of the Week",
                      salePrize: 'GHS 3899.99',
                      regularPrize: 'GHS 4599.99',
                      rating: 4.9,
                      byCategory: "Expert: 9.5/10",
                      description: '""Exceptional build quality, outstanding performance, and incredible '
                          'value for money. This laptop has revolutionized our workflow and exceeded all expectations.""',
                      totalReviews: 1247,
                      expert: "9.5/10",
                      save: "Save GHS 700.00",
                      onTap: () {},
                    );
                  },
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
                      image: "https://picsum.photos/id/${10 + index}/300/300",
                      title: "Premium Wireless Laptop - 15 inch Display, 16GB RAM, 512GB SSD",
                      socialCount: "716+",
                      searchCount: "4317+",
                      subTitle: "Editor's Pick of the Week",
                      salePrize: 'GHS 3899.99',
                      regularPrize: 'GHS 4599.99',
                      rating: 4.9,
                      expert: "Expert: 9.5/10",
                      byCategory: "Expert: 9.5/10",
                      description: '"Exceptional build quality, outstanding performance, '
                          'and incredible value for money. This laptop has revolutionized"',
                      totalReviews: 1247,
                      onTap: () {},
                    );
                  },
                ),
              ),
              hBox(20),
              editorialProcessSection(),
              hBox(20),
              trustExpertSection(),
            ],
          ),
        ),
      ),
    );
  }
  Widget _statBox(String number, String label) {
    return Container(
      width: 113,
      margin: EdgeInsets.all(5),
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Text(
            number,
            style: AppFontStyle.text_26_600(
              AppColors.white,
              fontFamily: AppFontFamily.interRegular,
            ),
          ),
          hBox(4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppFontStyle.text_12_400(
              AppColors.white,
              fontFamily: AppFontFamily.interRegular,
            ),
          ),
        ],
      ),
    );
  }


  Widget editorialProcessSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        children: [
          Text(
            "Our Editorial Process",
            style: AppFontStyle.text_26_600(
              AppColors.blueTextColor,
              fontFamily: AppFontFamily.interBold,
            ),
          ),
          hBox(6),
          Text(
            "Every product in our Editor's Choice collection goes through a rigorous evaluation process",
            textAlign: TextAlign.center,
            maxLines: 2,
            style: AppFontStyle.text_14_400(
              AppColors.greyTextColor,
              fontFamily: AppFontFamily.interRegular,
            ),
          ),
          hBox(20),
          _processCard(
            icon: Icon(Icons.search,color: AppColors.white,size: 30,),
            title: "Research & Discovery",
            desc:
            "Our experts research market trends and emerging products across all categories",
            gradient: AppColors.blueGradient,
          ),
          _processCard(
            icon: SvgPicture.asset(
              ImageConstants.sellerSvg,
              color: AppColors.white,
              width: 30,
            ),
            title: "Hands-On Testing",
            desc:
            "Products are thoroughly tested by our team for quality, performance, and value",
              gradient: AppColors.greenGradient,

          ),
          _processCard(
            icon: Icon(Icons.group_sharp,color: AppColors.white,size: 30,),
            title: "Expert Review",
            desc:
            "Industry experts and specialists provide detailed assessments and ratings",
            gradient: AppColors.purpleGradient,
          ),
          _processCard(
            icon: SvgPicture.asset(
              ImageConstants.kingSvg,
              color: AppColors.white,
              width: 30,
            ),
            title: "Final Selection",
            desc:
            "Only the top-performing products earn the prestigious Editor’s Choice badge",
            gradient: AppColors.orangeGradient,
          ),
        ],
      ),
    );
  }
  Widget trustExpertSection() {
    return Container(
      height: 400,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: AppColors.darkGradient,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22,vertical: 14),
        child: Column(
          children: [
            Text(
              "Trust the Experts",
              style: AppFontStyle.text_18_600(
                AppColors.white,
                fontFamily: AppFontFamily.interBold,
              ),
            ),
            hBox(15),
            Text(
              "When you shop Editor's Choice, you're shopping with confidence."
                  " Our expert curation saves you time and ensures you get the best products available.",
              maxLines: 4,
              textAlign: TextAlign.center,
              style: AppFontStyle.text_17_400(
                AppColors.white,
                fontFamily: AppFontFamily.interRegular,
              ),
            ),

            hBox(17),
            CustomElevatedButton(
              onPressed: (){},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    ImageConstants.tradeSvg,
                    color: AppColors.buttonColor,
                    width: 20,
                  ),
                  wBox(10),
                  Text(
                    "View All Categories",
                    style: AppFontStyle.text_12_500(
                      AppColors.buttonColor,
                      fontFamily: AppFontFamily.interMedium,
                    ),
                  ),
                ],
              ),
            ),
            hBox(15),
            CustomElevatedButton(
              onPressed: (){},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border,size: 20,color: AppColors.redTextClr,),
                  wBox(10),
                  Text(
                    "Create Wishlist",
                    style: AppFontStyle.text_12_500(
                      AppColors.redTextClr,
                      fontFamily: AppFontFamily.interMedium,
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
  Widget _processCard({
    required Widget icon,
    required String title,
    required String desc,
    Color? color,
    Gradient? gradient,
  }) {return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: color,
              gradient: gradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(child: icon,),
          ),
          hBox(10),
          Text(
            title,
            style: AppFontStyle.text_16_600(
              AppColors.black,
              fontFamily: AppFontFamily.interBold,
            ),
          ),
          hBox(4),
          Text(
            desc,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: AppFontStyle.text_12_400(
              AppColors.greyTextColor,
              fontFamily: AppFontFamily.interRegular,
            ),
          ),
        ],
      ),
    );}}