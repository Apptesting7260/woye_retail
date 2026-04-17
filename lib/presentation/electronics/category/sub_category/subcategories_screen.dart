import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import '../../../../Core/Constant/image_constant.dart';
import '../../../../Utils/sized_box.dart';
import '../../../../shared/theme/colors.dart';
import '../../../../shared/theme/font_family.dart';
import '../../../../shared/theme/font_style.dart';
import '../../../../shared/widgets/custom_appbar.dart';
import '../../../../shared/widgets/custom_text_form_field.dart';

class SubcategoriesScreen extends StatefulWidget {
  const SubcategoriesScreen({super.key});

  @override
  State<SubcategoriesScreen> createState() => _SubcategoriesScreenState();
}

class _SubcategoriesScreenState extends State<SubcategoriesScreen> {
    @override
    Widget build(BuildContext context) {
      final List<String> categories = [
        "ELECTRONICS",
        "HOME & LIVING",
        "FASHION",
        "HEALTH & BEAUTY",
        "GROCERIES",
        "BABY & KIDS",
        "SPORTS & FITNESS",
        "AUTOMOTIVE",
        "INDUSTRIAL & BUSINESS",
        "BOOKS & MEDIA",
        "PET SUPPLIES",
        "SPORTS & FITNESS",
        "AUTOMOTIVE",
        "INDUSTRIAL & BUSINESS",
        "BOOKS & MEDIA",
        "PET SUPPLIES",
      ];
      return Scaffold(
          appBar: CustomAppBar(
            title: Padding(
              padding: const EdgeInsets.only(right: 70),
              child: Text(
                    "Phones & Tablets",
                    style: AppFontStyle.text_16_600(
                      AppColors.black,
                      fontFamily: AppFontFamily.interSemiBold,
                    ),
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
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                CustomTextFormField(
                height: 45,
                hintText: "Search Phones & Tablets...",
                prefixIcon:  Icon(Icons.search, size: 22, color: AppColors.greyLightColor),
                borderRadius: BorderRadius.circular(8),
                onChanged: (value) {},
              ),
              hBox(10),
                  Expanded(
                    child: ListView.separated(
                      itemCount: categories.length,
                      separatorBuilder: (_, __) => const SizedBox(),
                      itemBuilder: (context, index) {
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            categories[index],
                            style: AppFontStyle.text_14_500(
                              AppColors.blueTextColor,
                              fontFamily: AppFontFamily.interMedium,
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: AppColors.blueTextColor,
                            size: 18,
                          ),
                          onTap: () {},
                        );
                      },
                    ),
                  ),
          ]),
          )
      );
  }
}
