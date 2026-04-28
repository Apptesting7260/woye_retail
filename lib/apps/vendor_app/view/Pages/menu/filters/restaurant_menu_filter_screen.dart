import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gyaawa/shared/widgets/vendor_widgets/custom_checkbox.dart';
import '../../../../../../Utils/sized_box.dart';
import '../../../../../../Utils/snack_bar.dart';
import '../../../../../../shared/theme/colors.dart';
import '../../../../../../shared/theme/font_family.dart';
import '../../../../../../shared/theme/font_style.dart';
import '../../../../../../shared/widgets/custom_appbar.dart';
import '../../../../../../shared/widgets/vendor_widgets/custom_dropdown.dart';
import '../../../../../../shared/widgets/vendor_widgets/custom_elevated_button.dart';
import '../../../../../../shared/widgets/vendor_widgets/print.dart';
import '../controller/restaurant_menu_controller.dart';
import '../model/restaurant_menu_model.dart';

class RestaurantMenuFilterScreen extends GetView<RestaurantMenuController> {
  const RestaurantMenuFilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            attributes(),
            hBox(10),
            Text("Preparation Time",style: AppFontStyle.text_14_400(AppColors.black,fontFamily: AppFontFamily.gilroySemiBold)),
            hBox(6),
            preparationTime(),
            hBox(80),
          ],
        ),
      )),
      bottomNavigationBar: clearAndApplyBtn(),
    );
  }

  Padding clearAndApplyBtn() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(child:
          CustomElevatedButton(
            height: 54,
            color: AppColors.white,
            borderSide: BorderSide(color: AppColors.black),
            onPressed: () {
              controller.clearFilter();
            },
              child: Text("Clear All",
                style:  AppFontStyle.text_17_600(
                  AppColors.black,
                  fontFamily: AppFontFamily.gilroyMedium,
                ),
              )
          ),
          ),
          wBox(14),
          Expanded(child: CustomElevatedButton(
              height: 54,
              onPressed: () {
                if (controller.selectedAttributeIds.isEmpty && controller.selectedPreparationTime.value == "") {
                  Utils.showToast("Please select at least one filter option to continue");
                }else{
                controller.getProductListApi(isShowLoading: false);
                Get.back();
                }
              },
            child: Obx(
              () {
                final totalFilter =  controller.selectedAttributeIds.length + (controller.selectedPreparationTime.value != "" ? 1  : 0);
                return Text("Apply Filter ($totalFilter)",
                style:  AppFontStyle.text_17_600(
                  AppColors.white,
                  fontFamily: AppFontFamily.gilroyMedium,
                ),
              );
              },
            )
          ),
          ),
        ],
      ),
    );
  }

  Obx preparationTime() {
    return Obx(
      ()=> CustomDropDown(
        showClearButton: true,
        borderRadius: 14,
          btnHeight: 54,
          items: controller.preparationTimeList,
          selectedValue: controller.selectedPreparationTime.value,
          onChanged: (value){
          controller.selectedPreparationTime.value = value ?? "";
          },
      ),
    );
  }

  Widget attributes() {
    return Obx(
      () {
        final category = controller.menuData.value.data;
        final attributes = category?.productAttributes ?? <ProductAttributes>[].obs;

        if (attributes.isEmpty) {
          return const SizedBox.shrink();
        }
        return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...attributes.map((group) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  group.groupName ?? "",
                  style: AppFontStyle.text_16_400(
                    AppColors.blackTextColor,
                    fontFamily: AppFontFamily.gilroySemiBold,
                  ),
                ),
                hBox(4.h),

                // 🔹 Changed from GridView to Column (List style)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: group.items?.map((item) {
                    final isChecked = controller.selectedAttributeIds
                        .contains(item.id.toString())
                        .obs;

                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.h),
                      child: CustomCheckboxTile(
                        title: item.name ?? "",
                        value: isChecked,
                        onChanged: (v) {
                          isChecked.value = v;
                          if (v) {
                            if (item.id != null &&
                                !controller.selectedAttributeIds
                                    .contains(item.id.toString())) {
                              controller.selectedAttributeIds
                                  .add(item.id.toString());
                            }
                          } else {
                            controller.selectedAttributeIds
                                .remove(item.id.toString());
                          }

                          pt(controller.selectedAttributeIds.toString());
                        },
                      ),
                    );
                  }).toList() ?? [],
                ),

                hBox(12.h),
              ],
            );
          }),
        ],
      );
      },
    );
  }

  CustomAppBar _appBar() {
    return CustomAppBar(
      centetTitle: true,
      title: Text(
        "More Filters",
        style: AppFontStyle.text_20_600(
          AppColors.darkText,
          fontFamily: AppFontFamily.gilroyMedium,
        ).copyWith(height: 1.0),
      ),
    );
  }
}
