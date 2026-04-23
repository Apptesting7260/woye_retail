import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gyaawa/apps/user_app/presentation/electronics/category/sub_category/controller/subcategories_controller.dart';

import '../../../../../../../Core/Constant/image_constant.dart';
import '../../../../../../../Utils/sized_box.dart';
import '../../../../../../../shared/theme/colors.dart';
import '../../../../../../../shared/theme/font_family.dart';
import '../../../../../../../shared/theme/font_style.dart';
import '../../../../../../../shared/widgets/Custom_search_field.dart';
import '../../../../../../../shared/widgets/custom_appbar.dart';

class SubcategoriesScreen extends StatefulWidget {
  const SubcategoriesScreen({super.key});

  @override
  State<SubcategoriesScreen> createState() => _SubcategoriesScreenState();
}

class _SubcategoriesScreenState extends State<SubcategoriesScreen> {
  final SubcategoriesController controller = Get.find<SubcategoriesController>();
  @override
    Widget build(BuildContext context) {
      return Scaffold(
          appBar: CustomAppBar(
            title: Text(
                  "Phones & Tablets",
                  style: AppFontStyle.text_16_600(
                    AppColors.black,
                    fontFamily: AppFontFamily.interSemiBold,
                  ),
            ),
            actions: [
              IconButton(
                onPressed: () {Get.back();},
                icon: SvgPicture.asset(ImageConstants.closeSvg,width: 20),
              ),
            ],
          ),
          body:  Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                children: [
                  CustomSearchField(
                  hintText: "Search Phones & Tablets...",
                  onChanged: (value) {},
                  ),
              hBox(10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ListView.builder(
                        itemCount: controller.categories.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {},
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Text(
                                controller.categories[index],
                                style: AppFontStyle.text_12_400(
                                  AppColors.blueLightColor,
                                  fontFamily: AppFontFamily.interRegular,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
          ]),
          ),
      );
  }
}
