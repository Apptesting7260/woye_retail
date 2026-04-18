import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:gyaawa/Routes/app_routes.dart';
import 'package:gyaawa/Utils/sized_box.dart';
import 'package:gyaawa/shared/widgets/Custom_search_field.dart';
import 'package:gyaawa/shared/widgets/custom_appbar.dart';
import '../../../../../Core/Constant/image_constant.dart';
import '../../../../../shared/theme/colors.dart';
import '../../../../../shared/theme/font_family.dart';
import '../../../../../shared/theme/font_style.dart';
import '../controller/departments_store_controller.dart';

class DepartmentsStoreScreen extends StatefulWidget {
  const DepartmentsStoreScreen({super.key});

  @override
  State<DepartmentsStoreScreen> createState() => _DepartmentsStoreScreenState();
}

class _DepartmentsStoreScreenState extends State<DepartmentsStoreScreen> {
  final DepartmentsStoreController controller =
      Get.find<DepartmentsStoreController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Padding(
          padding: const EdgeInsets.only(right: 130),
          child: Text(
            "Electronics",
            style: AppFontStyle.text_14_600(
              AppColors.black,
              fontFamily: AppFontFamily.interSemiBold,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: SvgPicture.asset(ImageConstants.closeSvg, width: 20),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomSearchField(
                hintText: "Search Electronics...",
                onChanged: (value) {
                },
              ),
              hBox(20),
              Text(
                "POPULAR PICKS",
                style: AppFontStyle.text_12_600(
                  AppColors.greyColors,
                  fontFamily: AppFontFamily.interSemiBold,
                ),
              ),
              hBox(16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ListView.builder(
                  itemCount: controller.popularPicks.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final item = controller.popularPicks[index];
                    return InkWell(
                      onTap: () {
                        Get.toNamed(AppRoutes.subcategoriesScreen);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item["title"],
                              style: AppFontStyle.text_12_500(
                                AppColors.blueTextColor,
                                fontFamily: AppFontFamily.interMedium,
                              ),
                            ),
                            if (item["tag"] != null)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                decoration: BoxDecoration(
                                  color: getTagColor(item["tag"]),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  item["tag"],
                                  style: AppFontStyle.text_10_500(
                                    Colors.white,
                                    fontFamily: AppFontFamily.interMedium,
                                  ),
                                ),
                              )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
             hBox(10),
              Container(
                height: 0.5,
                color: AppColors.borderClr,
              ),
              hBox(15),
              Text(
                "SUBCATEGORIES",
                style: AppFontStyle.text_12_600(
                  AppColors.greyColors,
                  fontFamily: AppFontFamily.interSemiBold,
                ),
              ),
              hBox(10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ListView.builder(
                  itemCount: controller.subCategories.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {

                    final item = controller.subCategories[index];
                    return InkWell(
                      onTap: () {
                        Get.toNamed(AppRoutes.subcategoriesScreen);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                item["title"],
                                style: AppFontStyle.text_12_500(
                                  AppColors.blueTextColor,
                                  fontFamily: AppFontFamily.interMedium,
                                ),
                              ),
                            ),
                            Text(
                              "${item["count"]}",
                              style: AppFontStyle.text_10_500(
                                AppColors.arrowIconColor,
                                fontFamily: AppFontFamily.interRegular,
                              ),
                            ),
                           wBox(6),
                            Icon(Icons.arrow_forward_ios,
                                size: 16, color: AppColors.arrowIconColor)
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              hBox(20),
            ],
          ),
        ),
      ),
    );
  }
  Color getTagColor(String tag) {
    switch (tag.toLowerCase()) {
      case "hot":
        return AppColors.red;
      case "sale":
        return AppColors.greenTextClr;
      case "new":
        return AppColors.blueClr;
      default:
        return AppColors.greyLightColor;
    }
  }
}
