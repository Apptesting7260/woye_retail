import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gyaawa/Utils/sized_box.dart';
import 'package:gyaawa/shared/theme/colors.dart';
import 'package:gyaawa/shared/widgets/custom_appbar.dart';
import '../../../../../../../Core/Constant/image_constant.dart';
import '../../../../../../../shared/theme/font_family.dart';
import '../../../../../../../shared/theme/font_style.dart';
import '../../../../../../../shared/widgets/Custom_search_field.dart';
import '../../../../../user_routes/app_routes.dart';
import '../controller/all_category_controller.dart';

class AllCategoriesScreen extends StatelessWidget {
  const AllCategoriesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final AllCategoryController controller = Get.put (AllCategoryController());
    return Scaffold(
      appBar: CustomAppBar(
        title: Row(
          children: [
            wBox(20),
             Text(
              "All Categories",
              style: AppFontStyle.text_16_600(
                AppColors.black,
                fontFamily: AppFontFamily.interSemiBold,
              ),
            ),
            wBox(8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.overlayColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child:  Text(
                "52",
                style: AppFontStyle.text_10_500(
                  AppColors.black,
                  fontFamily: AppFontFamily.interMedium,
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
             Get.back();
            },
            icon: SvgPicture.asset(ImageConstants.closeSvg,width: 20),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              CustomSearchField(
                hintText: "Search categories...",
                onChanged: (value) {},
              ),
              hBox(20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.buttonColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(ImageConstants.gridViewSvg, width: 20),
                      wBox(18),
                      Text(
                        "Main Store Departments",
                        style: AppFontStyle.text_12_500(
                          AppColors.white,
                          fontFamily: AppFontFamily.interMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              hBox(10),
              ListView.separated(
                itemCount: controller.categories.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                separatorBuilder: (_, __) => const SizedBox(),
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      controller.categories[index],
                      style: AppFontStyle.text_14_500(
                        AppColors.blueTextColor,
                        fontFamily: AppFontFamily.interMedium,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.arrowIconColor,
                      size: 18,
                    ),
                    onTap: () {
                      Get.toNamed(UserRoutes.departmentsStoreScreen);
                    },
                  );
                },
              ),
              hBox(20),
              Divider(color: AppColors.borderClr, height: 0.5),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Text(
                      "Browse 11 departments, 52 categories, 1000s of Products.",
                      style: AppFontStyle.text_10_500(
                        AppColors.buttonHideColor,
                        fontFamily: AppFontFamily.interRegular,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "Find exactly what you're looking for",
                      style: AppFontStyle.text_10_500(
                        AppColors.buttonHideColor,
                        fontFamily: AppFontFamily.interRegular,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              hBox(10),
            ],
          ),
        ),
      ),
    );
  }
}