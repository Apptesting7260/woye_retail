import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:gyaawa/Utils/sized_box.dart';
import 'package:gyaawa/presentation/electronics/search/sub_search_screen/controller/result_filter_controller.dart';
import 'package:gyaawa/shared/widgets/custom_elevated_button.dart';
import '../../../../shared/theme/colors.dart';
import '../../../../shared/theme/font_family.dart';
import '../../../../shared/theme/font_style.dart';
import '../../../../shared/widgets/custom_select_unselect.dart';
import '../../../../shared/widgets/simple_wrap_dropdown.dart';

class ResultFilterScreen extends StatefulWidget {
  const ResultFilterScreen({super.key});
  @override
  State<ResultFilterScreen> createState() => _ResultFilterScreenState();
}
class _ResultFilterScreenState extends State<ResultFilterScreen> {
  final ResultFilterController  controller = Get.put (ResultFilterController());
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
      Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Filters",
                style: AppFontStyle.text_16_600(
                  AppColors.black,
                  fontFamily: AppFontFamily.interSemiBold,
                ),
              ),
              wBox(10),
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  color: AppColors.buttonColor,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Center(
                  child: Text(
                    "1",
                    style: AppFontStyle.text_10_500(
                      AppColors.white,
                      fontFamily: AppFontFamily.interSemiBold,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close),
              ),
            ],
          ),
          Text(
            "Refine your search results",
            style: AppFontStyle.text_12_400(
              AppColors.buttonHideColor,
              fontFamily: AppFontFamily.interRegular,
            ),
          ),
        ],
      ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Quick Filters",
                    style: AppFontStyle.text_12_600(
                      AppColors.black,
                      fontFamily: AppFontFamily.interSemiBold,
                    ),
                  ),
               hBox(10),
                  GetBuilder<ResultFilterController>(
                    builder: (controller) => Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              height: 37,
                              width: 180,
                              child: CustomFilterChip(
                                text: controller.quickFilters[0],
                                isSelected: controller.selectedQuick.contains(controller.quickFilters[0]),
                                onTap: () => controller.toggleQuickFilter(controller.quickFilters[0]),
                              ),
                            ),
                            wBox(10),
                            SizedBox(
                              height: 37,
                              width: 180,
                              child: CustomFilterChip(
                                text: controller.quickFilters[1],
                                isSelected: controller.selectedQuick.contains(controller.quickFilters[1]),
                                onTap: () => controller.toggleQuickFilter(controller.quickFilters[1]),
                              ),
                            ),
                          ],
                        ),
                        hBox(10),
                        Row(
                          children: [
                            SizedBox(
                              height: 37,
                              width: 180,
                              child: CustomFilterChip(
                                text: controller.quickFilters[2],
                                isSelected: controller.selectedQuick.contains(controller.quickFilters[2]),
                                onTap: () => controller.toggleQuickFilter(controller.quickFilters[2]),
                              ),
                            ),
                            wBox(10),
                            SizedBox(
                              height: 37,
                              width: 180,
                              child: CustomFilterChip(
                                text: controller.quickFilters[3],
                                isSelected: controller.selectedQuick.contains(controller.quickFilters[3]),
                                onTap: () => controller.toggleQuickFilter(controller.quickFilters[3]),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  hBox(15),
                 Divider(),
                 hBox(20),
                  GetBuilder<ResultFilterController>(
                    builder: (controller) => Column(
                      children: [
                        SimpleWrapDropdown(
                          items: controller.prizeRange,
                          selectedItems: controller.selectedPriceRange,
                          getLabel: (e) => e,
                          hintText: "Price Range",
                          onChanged: controller.updatePriceRange,
                        ),
                        Divider(),
                        SimpleWrapDropdown(
                          items: controller.categories,
                          selectedItems: controller.selectedCategories,
                          getLabel: (e) => e,
                          hintText: "Category",
                          onChanged: controller.updateCategories,
                          borderRadius: 13,
                        ),
                        Divider(),
                        SimpleWrapDropdown(
                          items: controller.brands,
                          selectedItems: controller.selectedBrands,
                          getLabel: (e) => e,
                          hintText: "Brands",
                          onChanged: controller.updateBrands,
                          borderRadius: 10,
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                 hBox(80),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.borderClr)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: CustomElevatedButton(
                    borderSide: BorderSide(width: 0.5),
                    color: AppColors.white,
                    text: "Reset",
                    textColor: AppColors.black,
                    onPressed: () {
                        controller.selectedQuick.clear();
                        controller. selectedCategories.clear();
                    },
                  ),
                ),
               wBox(10),
                Expanded(
                  child: CustomElevatedButton(
                    color: AppColors.buttonColor,
                    text: "",
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Apply Filters",
                          style: AppFontStyle.text_14_500(
                            AppColors.white,
                            fontFamily: AppFontFamily.interMedium,
                          ),
                        ),
                       wBox(8),
                        Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Center(
                            child: Text(
                              "1",
                              style: AppFontStyle.text_10_500(
                                AppColors.buttonColor,
                                fontFamily: AppFontFamily.interSemiBold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}