import 'dart:developer';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gyaawa/routes/vendor_routes/vendor_app_routes.dart';
import 'package:gyaawa/shared/widgets/vendor_widgets/app_container.dart';
import 'package:path/path.dart';

import '../../../../../../Core/Constant/image_constant.dart';
import '../../../../../../Data/components/general_exception.dart';
import '../../../../../../Data/components/internet_exception.dart';
import '../../../../../../Data/response/status.dart';
import '../../../../../../Utils/decimal_formater.dart';
import '../../../../../../Utils/sized_box.dart';
import '../../../../../../Utils/validation.dart';
import '../../../../../../shared/theme/colors.dart';
import '../../../../../../shared/theme/font_family.dart';
import '../../../../../../shared/theme/font_style.dart';
import '../../../../../../shared/widgets/custom_appbar.dart';
import '../../../../../../shared/widgets/vendor_widgets/circular_progress_indicator.dart';
import '../../../../../../shared/widgets/vendor_widgets/custom_checkbox.dart';
import '../../../../../../shared/widgets/vendor_widgets/custom_dropdown.dart';
import '../../../../../../shared/widgets/vendor_widgets/custom_dropdown_api.dart';
import '../../../../../../shared/widgets/vendor_widgets/custom_elevated_button.dart';
import '../../../../../../shared/widgets/vendor_widgets/custom_text_form_field.dart';
import '../../../../../../shared/widgets/vendor_widgets/print.dart';
import '../../../vendor_common/Models/common_get_category_model.dart';
import '../../ChooseVendorCategories/model/vendor_category_model.dart';
import '../controller/restaurant_product_add_controller.dart';

class RestaurantAddProductScreen extends StatelessWidget {
  RestaurantAddProductScreen({super.key});

  final RestaurantProductAddController restaurantProductAddController = Get.put(RestaurantProductAddController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
          FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Container(
        color: AppColors.backgroundClr,
          child: Scaffold(
            appBar: appbar(),
            body: Obx(() {
                switch (restaurantProductAddController.rxRequestCategoryStatus.value) {
                  case ApiStatus.LOADING:
                    return Center(child: circularProgressIndicator());
                  case ApiStatus.ERROR:
                    if (restaurantProductAddController.error.value == 'No internet') {
                      return InternetExceptionWidget(
                        onPress: () {
                          restaurantProductAddController.getDepartmentApi();
                          // restaurantProductAddController.getAddOnApi();
                          // restaurantProductAddController.getVendorCategoriesApi();
                        },
                      );
                    } else {
                      return GeneralExceptionWidget(
                        onPress: () {
                          restaurantProductAddController.getDepartmentApi();
                          // restaurantProductAddController.getAddOnApi();
                          // restaurantProductAddController.getVendorCategoriesApi();
                        },
                      );
                    }
                  case ApiStatus.COMPLETED:
                    return SingleChildScrollView(
                      controller: restaurantProductAddController.scrollController,
                      child: Padding(
                        padding: REdgeInsets.symmetric(horizontal: 24.0),
                        child: Form(
                          key: restaurantProductAddController.publishButtonKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              hBox(8.h),
                              _profileImagePicker(context),
                              hBox(20.h),
                              additionalImages(),
                              hBox(20.h),
                              productTitle(),
                              hBox(12.h),
                              productDescription(),
                              hBox(12.h),
                              regularPrizeAndPromoCode(),
                              hBox(12.h),
                              status(),
                              hBox(12.h),
                              additionalDetailsSection(),
                              hBox(4.h),
                              variantSection(restaurantProductAddController),
                              hBox(10.h),
                              publishButton(),
                              hBox(20.h),
                            ],
                          ),
                        ),
                      ),
                    );
                }
              },
            ),
          ),
        ),
    );
  }

  Widget status() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Status", style: AppFontStyle.text_14_500(AppColors.lightBlackClr, fontFamily: AppFontFamily.interMedium)),
                  hBox(5),
                  Obx(
                    () => CustomDropDownApi(
                      selectedValue: restaurantProductAddController.status.value,
                      items: statusItems,
                      borderColor: AppColors.textFieldBorder,
                      hintText: "Choose Status",
                      btnHeight: 50,
                      onChanged: (value) {restaurantProductAddController.status.value = value!;},
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please select status";
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            wBox(12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Condition", style: AppFontStyle.text_14_500(AppColors.lightBlackClr, fontFamily: AppFontFamily.interMedium)),
                  hBox(5),
                  CustomTextFormField(
                    key:restaurantProductAddController.conditionKey,
                    controller: restaurantProductAddController.conditionController.value,
                    hintText: " e.g brand new",
                    onTapOutside: (event) {FocusManager.instance.primaryFocus?.unfocus();},
                    validator: (value) {
                      if (restaurantProductAddController.conditionController.value.text.trim().isEmpty) {
                        return "Please enter condition";
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        hBox(12.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Package Dimensions", style: AppFontStyle.text_14_500(AppColors.lightBlackClr, fontFamily: AppFontFamily.interMedium)),
                  hBox(5.h),
                  CustomTextFormField(
                    key: restaurantProductAddController.packageKey,
                    controller: restaurantProductAddController.packageController.value,
                    textInputType: TextInputType.text,
                    inputFormatters: [LengthLimitingTextInputFormatter(20)],
                    onTapOutside: (event) {FocusManager.instance.primaryFocus?.unfocus();},
                    hintText: '30 x 20 x 12 cm',
                    validator: (value) {
                      if (restaurantProductAddController.packageController.value.text.trim().isEmpty) {
                        return "Please enter package";
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            wBox(12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Weight (Kg)", style: AppFontStyle.text_14_500(AppColors.lightBlackClr, fontFamily: AppFontFamily.interMedium)),
                  hBox(5.h),
                  CustomTextFormField(
                    key: restaurantProductAddController.weightKey,
                    controller: restaurantProductAddController.weightController.value,
                    textInputType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10),
                    ],
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    validator: (value) {
                      if (restaurantProductAddController.weightController.value.text.trim().isEmpty) {
                        return "Please enter weight";
                      }
                      return null;
                    },
                    hintText: '13 (Kg,Gm)',
                  ),
                ],
              ),
            ),
          ],
        ),//
        hBox(12.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Fulfillment Type", style: AppFontStyle.text_14_500(AppColors.lightBlackClr, fontFamily: AppFontFamily.interMedium)),
                  hBox(5.h),
                  CustomTextFormField(
                    key: restaurantProductAddController.fulfillmentKey,
                    controller: restaurantProductAddController.fulfillmentController.value,
                    textInputType: TextInputType.text,
                    inputFormatters: [LengthLimitingTextInputFormatter(20)],
                    onTapOutside: (event) {FocusManager.instance.primaryFocus?.unfocus();},
                    hintText: 'Seller',
                    validator: (value) {
                      if (restaurantProductAddController.fulfillmentController.value.text.trim().isEmpty) {
                        return "Please enter seller";
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            wBox(12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Preparation Time", style: AppFontStyle.text_14_500(AppColors.lightBlackClr, fontFamily: AppFontFamily.interMedium)),
                  hBox(5.h),
                  CustomTextFormField(
                    key: restaurantProductAddController.preparationKey,
                    controller: restaurantProductAddController.preparationController.value,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[\d\-a-zA-Z]'))
                    ],
                    hintText: "e.g, 2 days",
                       validator: (value) {
                         if (value == null || value.trim().isEmpty) {
                           return "Please enter preparation time";
                         }
                         return null;
                       }
                  ),
                ],
              ),
            ),
          ],
        ),
        hBox(12.h),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Department", style: AppFontStyle.text_14_500(AppColors.lightBlackClr, fontFamily: AppFontFamily.interMedium)),
            hBox(5),
            CustomDropDownApi(
              // selectedValue: restaurantProductAddController.department.value,
              selectedValue: restaurantProductAddController.selectedDepartmentId.value,
              items: restaurantProductAddController.apiCategoryData.value.data?.categories ?? [],
              borderColor: AppColors.textFieldBorder,
              hintText: "Select Department",
              btnHeight: 50,
              onChanged: (value) {
                pt("Selected Value: $value");
                if (value == null || value.isEmpty) {
                  return;
                }
                restaurantProductAddController.department.value = value;
                final categoriesList = restaurantProductAddController.apiCategoryData.value.data?.categories;
                if (categoriesList == null || categoriesList.isEmpty) {
                  pt("Categories list is empty!");
                  return;
                }
                Categories? selectedDepartment;
                for (var category in categoriesList) {
                  if (category.id == value) {selectedDepartment = category;
                    break;
                  }
                }
                pt("Selected Department Found: ${selectedDepartment != null}");
                if (selectedDepartment != null) {
                  restaurantProductAddController.department.value = selectedDepartment.name ?? "";
                  restaurantProductAddController.selectedDepartmentId.value = selectedDepartment.id ?? "";
                  pt("Department ID: ${restaurantProductAddController.selectedDepartmentId.value}");
                  if (restaurantProductAddController.selectedDepartmentId.value.isNotEmpty) {
                    pt("🚀 Calling getVendorCategoriesApi...");
                    restaurantProductAddController.getVendorCategoriesApi();
                  }
                }
              },
              validator: (value) {
                if (restaurantProductAddController.department.value.isEmpty) {
                  return "Please select department";
                }
                return null;
              },
            ),
            hBox(12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Category", style: AppFontStyle.text_14_500(AppColors.lightBlackClr, fontFamily: AppFontFamily.interMedium)),
                      hBox(5),
                      Obx(() {
                        final categoryList = restaurantProductAddController.categoriesData.value.categories ?? [];
                        return CustomDropDownApi(
                          // selectedValue:
                          // restaurantProductAddController.selectedCategoryId.value,
                          selectedValue: restaurantProductAddController.selectedCategoryId.value,
                          items: categoryList,
                          borderColor: AppColors.textFieldBorder,
                          hintText: "Category",
                          btnHeight: 50,
                          onChanged: (value) async {
                            restaurantProductAddController.selectedCategoryId.value = value.toString();
                            final selectedCategory = categoryList.firstWhere((e) => e.id.toString()
                                == value.toString(), orElse: () => VendorCategories());
                            restaurantProductAddController.category.value = selectedCategory.name ?? "";
                            pt("Category ID = ${selectedCategory.id}");
                            pt("Category Name = ${selectedCategory.name}");
                            restaurantProductAddController.subCategory.value = "";
                            await restaurantProductAddController.getVendorSubCategoriesApi();
                          },
                          validator: (value) {
                            if (restaurantProductAddController.selectedCategoryId.value.isEmpty) {
                              return "Please select category";
                            }
                            return null;
                          },
                        );
                      }),
                    ],
                  ),
                ),
                wBox(12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Sub Category", style: AppFontStyle.text_14_500(AppColors.lightBlackClr, fontFamily: AppFontFamily.interMedium)),
                      hBox(5),
                      Obx(() {
                        final subCategoryList = restaurantProductAddController.subCategoriesData.value.data ?? [];
                        return CustomDropDownApi(
                          // selectedValue: restaurantProductAddController.subCategory.value,
                          selectedValue: restaurantProductAddController.selectedAttributeId.value,
                          items: subCategoryList,
                          borderColor: AppColors.textFieldBorder,
                          hintText: "Sub Category",
                          btnHeight: 50,
                          onChanged: (value) async {
                            restaurantProductAddController.subCategory.value = value.toString();
                            final selectedSubCategory = subCategoryList.firstWhere((e) => e.id.toString() == value.toString(),
                              orElse: () => subCategoryList.first,
                            );
                            restaurantProductAddController.subCategory.value = selectedSubCategory.name ?? "";
                            restaurantProductAddController.selectedAttributeId.value = selectedSubCategory.id.toString();
                            pt("SubCategory ID = ${selectedSubCategory.id}");
                            pt("SubCategory Name = ${selectedSubCategory.name}");
                            await restaurantProductAddController.getVendorProductAttributeApi();
                          },
                          validator: (value) {
                            if (restaurantProductAddController
                                .subCategory.value.isEmpty) {
                              return "Please select sub category";
                            }
                            return null;
                          },
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
            hBox(15.h),
          ],
        ),
      ],
    );
  }

  Widget additionalDetailsSection() {
    final additionalDetails = restaurantProductAddController.attributeData.value.additionalDetails ?? [];
    if (additionalDetails.isEmpty) {
      return const SizedBox();
    }
    return Column(
      children: [
        Divider(color: AppColors.greyTextColor.withAlpha(70)),
        hBox(10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${restaurantProductAddController.department.value}"
                  " - ${restaurantProductAddController.category.value}"
                  " - ${restaurantProductAddController.subCategory.value } -",
              style: AppFontStyle.text_13_500(
                AppColors.blueLightColor,
                fontFamily: AppFontFamily.interSemiBold,
              ),
            ),
            Text(
              " Additional Details",
              overflow:TextOverflow.ellipsis, style: AppFontStyle.text_13_500(
                AppColors.blueLightColor, fontFamily: AppFontFamily.interSemiBold),
            ),
          ],
        ),
        hBox(20.h),
        ...List.generate(
          (additionalDetails.length / 2).ceil(), (rowIndex) {
            int firstIndex = rowIndex * 2;
            int secondIndex = firstIndex + 1;
            final firstItem = additionalDetails[firstIndex];
            final secondItem = secondIndex < additionalDetails.length ? additionalDetails[secondIndex] : null;
            restaurantProductAddController.additionalControllers.putIfAbsent(firstItem.slug ?? "", () => TextEditingController());
            if (secondItem != null) {
              restaurantProductAddController.additionalControllers.putIfAbsent(secondItem.slug ?? "", () => TextEditingController());
            }
            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(firstItem.title ?? "", style: AppFontStyle.text_14_500(AppColors.lightBlackClr, fontFamily: AppFontFamily.interMedium)),
                        hBox(5.h),
                        CustomTextFormField(
                          key: ValueKey(firstItem.slug),
                          controller: restaurantProductAddController.additionalControllers[firstItem.slug ?? ""],
                          textInputType: TextInputType.text,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(50),
                          ],
                          onTapOutside: (event) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          hintText: firstItem.placeholder ?? "",
                        ),
                      ],
                    ),
                  ),
                  if (secondItem != null) ...[
                    wBox(12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(secondItem.title ?? "", style: AppFontStyle.text_14_500(AppColors.lightBlackClr, fontFamily: AppFontFamily.interMedium)),
                          hBox(5.h),
                          CustomTextFormField(
                            controller: restaurantProductAddController.additionalControllers[secondItem.slug ?? ""],
                            textInputType: TextInputType.text,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(50),
                            ],
                            onTapOutside: (event) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            hintText: secondItem.placeholder ?? "",
                          ),
                        ],
                      ),
                    ),
                  ] else Expanded(child: SizedBox()),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Text title({String? title}) {
    return Text(title ?? "", style: AppFontStyle.text_18_400(AppColors.lightBlackClr, fontFamily: AppFontFamily.gilroySemiBold));}

  Widget variantSection(RestaurantProductAddController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        hBox(10),
        CustomCheckboxTile(
            scale: 1.2,
          title: " This product has variants (e.g. different sizes)",style: AppFontStyle.text_13_500(
            AppColors.black,
            fontFamily: AppFontFamily.interMedium,
         ),
          value: controller.hasVariants,
          onChanged: (val) {
            controller.hasVariants.value = val;
          },
        ),
        hBox(16),
        Obx(() {
          if (!controller.hasVariants.value) {
            return SizedBox();
          }
          return Column(
            children: [
              AppContainer(
                borderRadius: BorderRadius.circular(15),
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        stepCircle("1"),
                        wBox(10),
                        Text("Select Variant Attributes", style: AppFontStyle.text_14_500(AppColors.black,
                            fontFamily: AppFontFamily.interSemiBold)),
                      ],
                    ),
                    hBox(12),
                    Obx(() {
                      return Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: controller.allVariantAttributes.map((attr) {
                          final selected = controller.selectedVariantAttributes.contains(attr);
                          return GestureDetector(
                            onTap: () => controller.toggleAttribute(attr),
                            child: AppContainer(
                              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              color: selected ? AppColors.primary : AppColors.white,
                              border: Border.all(color: AppColors.borderClr),
                              borderRadius: BorderRadius.circular(8),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(attr, style: AppFontStyle.text_12_500(selected ? AppColors.white : AppColors.black, fontFamily: AppFontFamily.interMedium)),
                                  if (selected) ...[
                                    wBox(5),
                                    Icon(Icons.close, size: 14, color: AppColors.white),
                                  ],
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }),
                    hBox(15),
                    Divider(color: AppColors.borderClr,height: 1),
                    hBox(15),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                             CustomTextFormField(
                                controller: controller.customAttrNameController,
                                hintText: "Attribute name",
                                height: 45,
                              ),
                              hBox(10),
                              CustomTextFormField(
                                controller: controller.customAttrValueController,
                                hintText: "Values (comma-separated)",
                               height: 45,
                              ),
                            ],
                          ),
                        ),
                        wBox(10),
                        GestureDetector(
                          onTap: () {
                            controller.validateAndAddCustomAttribute();
                          },
                          child: AppContainer(
                            height: 100,
                            width: 50,
                            border: Border.all(color: AppColors.borderClr),
                            borderRadius: BorderRadius.circular(8),
                            child: const Icon(Icons.add),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              hBox(12),
              //<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>> STEP 2 <<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>
              Obx(() {
                if (controller.selectedVariantAttributes.isEmpty) {
                  return SizedBox();
                }
                return AppContainer(
                  borderRadius: BorderRadius.circular(15),
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          stepCircle("2"),
                          wBox(10),
                          Text("Configure Attribute Values", style: AppFontStyle.text_14_500(AppColors.black,
                            fontFamily: AppFontFamily.interSemiBold)),
                        ],
                      ),
                      hBox(12),
                      Column(
                        children: controller.selectedVariantAttributes.map((attr) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(attr,
                                    style: AppFontStyle.text_13_500(AppColors.blackTextColor, fontFamily: AppFontFamily.interMedium)),
                                  GestureDetector(
                                    onTap: () {
                                      if (controller.showValueField[attr]?.value == true) {
                                        String currentVal = controller.valueControllers[attr]?.text.trim() ?? "";
                                        if (currentVal.isNotEmpty) {
                                          controller.addAttributeValue(attr);
                                        }
                                        controller.showValueField[attr]?.value = false;
                                        Future.delayed(Duration(milliseconds: 100), () {
                                          controller.showValueField[attr]?.value = true;
                                        });
                                      } else {

                                        controller.showValueField[attr]?.value = true;
                                      }
                                    },
                                    child: GestureDetector(
                                      onTap: () {
                                        controller.toggleValueField(attr);
                                      },
                                      child: AppContainer(
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(color: AppColors.borderClr),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.add, size: 14),
                                            wBox(5),
                                            Text("Add Value", style: AppFontStyle.text_12_500(AppColors.primary, fontFamily: AppFontFamily.interMedium)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              hBox(15),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  ...controller.attributeValues[attr]!.map((val) {
                                    // ✅ Editable saved value
                                    final savedCtrl = controller.savedValueControllers[attr]?[val]
                                        ?? TextEditingController(text: val);
                                    return AppContainer(
                                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                      border: Border.all(color: AppColors.borderClr),
                                      borderRadius: BorderRadius.circular(6),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            width: 70.w,
                                            height: 25.h,
                                            child: TextField(
                                              controller: savedCtrl,
                                              style: AppFontStyle.text_13_400(AppColors.greyTextColor,
                                                  fontFamily: AppFontFamily.interMedium),
                                              decoration: InputDecoration(
                                                isDense: true,
                                                filled: true,
                                                border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(6),
                                                    borderSide: BorderSide.none),
                                                fillColor: AppColors.searchText,
                                                contentPadding: const EdgeInsets.symmetric(
                                                    vertical: 2, horizontal: 3),
                                              ),
                                              onChanged: (newVal) {
                                                if (newVal.trim().isNotEmpty) {
                                                  controller.updateAttributeValue(
                                                      attr, val, newVal.trim());
                                                }
                                              },
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              controller.removeAttributeValue(attr, val);
                                            },
                                            child: Icon(Icons.close, size: 16, color: AppColors.red),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                  Obx(() {
                                    final show = controller.showValueField[attr]?.value ?? false;
                                    if (!show) return SizedBox();

                                    return AppContainer(
                                      width: 100.w,
                                      height: 30.h,

                                      child: Row(
                                        children: [
                                          wBox(4),
                                          Expanded(
                                            child: TextField(
                                              controller: controller.valueControllers[attr],
                                              autofocus: false,
                                              style: AppFontStyle.text_13_400(
                                                  AppColors.greyTextColor,
                                                  fontFamily: AppFontFamily.interMedium
                                              ),
                                              decoration: InputDecoration(
                                                isDense: true,
                                                filled: true,
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(6),
                                                  borderSide: BorderSide.none,
                                                ),
                                                fillColor:AppColors.searchText,
                                                contentPadding: EdgeInsets.symmetric(vertical: 2),
                                              ),
                                              onSubmitted: (val) {
                                                if (val.trim().isNotEmpty) {
                                                  controller.addAttributeValue(attr);
                                                }
                                              },
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              controller.valueControllers[attr]?.clear();
                                              controller.showValueField[attr]?.value = false;
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 8),
                                              child: Icon(
                                                Icons.close,
                                                size: 16,
                                                color: AppColors.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                ],
                              ),
                              hBox(12),
                            ],
                          );
                        }).toList(),
                      ),
                      hBox(12),
                      CustomElevatedButton(
                        height: 46,
                        borderRadius: BorderRadius.circular(8),
                        onPressed: controller.generateVariants,
                        child: Text("Generate Variant Matrix", style: AppFontStyle.text_14_500(AppColors.white, fontFamily: AppFontFamily.interMedium)),
                      ),
                    ],
                  ),
                );
              }),
              hBox(12),

              Obx(() {
                if (controller.variantList.isEmpty) {
                  return SizedBox();
                }
                final tableAttributes = controller.generatedTableAttributes;
                final selectedVariants = controller.variantList.where((variant) => variant.isSelected.value).toList();
                return AppContainer(
                  borderRadius: BorderRadius.circular(15),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            stepCircle("3"),
                            Text("Variant Matrix (${selectedVariants.length})",
                                style: AppFontStyle.text_14_500(AppColors.lightBlackClr,
                                    fontFamily: AppFontFamily.interMedium)),
                            AppContainer(
                              height: 30,
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              borderRadius: BorderRadius.circular(6),
                              onTap: () {
                                double basePrice = double.tryParse(
                                  controller.regularPriceController.value.text.trim(),
                                ) ?? 0;

                                for (var variant in controller.variantList) {
                                  variant.price.value = basePrice;
                                }

                                controller.update();
                              },
                              child: Text("Apply Base Price to All",
                                style: AppFontStyle.text_12_500(AppColors.lightBlackClr,
                                  fontFamily: AppFontFamily.interMedium,
                                ),
                              ),
                            ),
                          ],
                        ),
                        hBox(12),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(minWidth: Get.width),
                            child: Table(
                              border: TableBorder.all(color: AppColors.borderClr),
                              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                              columnWidths: {
                                0: const IntrinsicColumnWidth(),
                                for (int i = 1; i < tableAttributes.length + 4; i++)
                                  i: const IntrinsicColumnWidth(),
                              },
                              children: [
                                // Header Row
                                TableRow(
                                  children: [
                                    cell("Select"),
                                    ...tableAttributes.map((attr) => cell(attr)),
                                    cell("SKU"),
                                    cell("Price"),
                                    cell("Stock"),
                                  ],
                                ),
                                // Data Rows
                                ...controller.variantList.map((variant) {
                                  return TableRow(
                                    children: [
                                      Center(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                                          child: CustomCheckboxTile(
                                            value: variant.isSelected,
                                            onChanged: (v) {
                                              variant.isSelected.value = v;
                                            },
                                            title: '',
                                          ),
                                        ),
                                      ),
                                      ...tableAttributes.map((attr) => cell(variant.values[attr] ?? "")),

                                      // Editable SKU
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: TextFormField(
                                          initialValue: variant.sku,
                                          onChanged: (val) {
                                            variant.sku = val.trim();
                                          },
                                          style: AppFontStyle.text_12_500(
                                            AppColors.blackTextColor,
                                            fontFamily: AppFontFamily.interMedium,
                                          ),
                                          decoration:  InputDecoration(
                                            isDense: true,
                                            filled: true,
                                            fillColor: AppColors.searchText,
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(6),
                                              borderSide: BorderSide.none,
                                            ),
                                            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),

                                          ),
                                        ),
                                      ),

                                      // Editable Price
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Obx(() {
                                          return TextFormField(
                                            key: ValueKey(variant.price.value),
                                            initialValue: variant.price.value.toStringAsFixed(0),
                                            keyboardType: TextInputType.number,
                                            onChanged: (val) {
                                              variant.price.value = double.tryParse(val) ?? variant.price.value;
                                            },
                                            style: AppFontStyle.text_12_500(
                                              AppColors.blackTextColor,
                                              fontFamily: AppFontFamily.interMedium,
                                            ),
                                            decoration: InputDecoration(
                                              isDense: true,
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(6),
                                                borderSide: BorderSide.none,
                                              ),
                                              filled: true,
                                              fillColor: AppColors.searchText,
                                              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                            ),
                                          );
                                        }),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: TextFormField(
                                          initialValue: variant.stock.value.toString(),
                                          keyboardType: TextInputType.number,
                                          onChanged: (val) {
                                            variant.stock.value = int.tryParse(val) ?? variant.stock.value;
                                          },
                                          style: AppFontStyle.text_12_500(
                                            AppColors.blackTextColor,
                                            fontFamily: AppFontFamily.interMedium,
                                          ),
                                          decoration:  InputDecoration(
                                            isDense: true,
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(6),
                                              borderSide: BorderSide.none,
                                            ),
                                            filled: true,
                                            fillColor: AppColors.searchText,
                                            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                              ],
                            ),
                          ),
                        ),
                        hBox(16),
                        Padding(
                          padding: const EdgeInsets.only(left: 120),
                          child: Obx(() {
                            return CustomElevatedButton(
                              color: AppColors.black,
                              height: 45.h,
                              borderRadius: BorderRadius.circular(8),
                              onPressed: () async {
                                if (restaurantProductAddController.rxRequestStatus.value == ApiStatus.LOADING) {
                                  return;
                                }
                                bool isValid = await restaurantProductAddController.validateBeforeReview();

                                if (!isValid) return;

                                await Future.delayed(const Duration(milliseconds: 200));

                                await Get.toNamed(
                                  VendorAppRoutes.vendorProductReviewScreen,
                                );
                              },
                              child: restaurantProductAddController.rxRequestStatus.value == ApiStatus.LOADING
                                  ? Center(
                                child: circularProgressIndicator2(
                                  size: 30,
                                  color: AppColors.white,
                                ),
                              )
                                  : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Continue To Review',
                                    style: AppFontStyle.text_15_500(
                                      AppColors.white,
                                      fontFamily: AppFontFamily.interMedium,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        )
                      ],
                    ),
                  ),
                );
              }),
            ],
          );
        }),
      ],
    );
  }

  Widget stepCircle(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.blueLightColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(text, style: AppFontStyle.text_12_500(AppColors.white, fontFamily: AppFontFamily.interMedium)));
  }

  Widget cell(String text) {
    return Padding(padding: EdgeInsets.all(8),
      child: Text(text, style: AppFontStyle.text_12_500(AppColors.blackTextColor, fontFamily: AppFontFamily.interMedium)),
    );
  }

  Column regularPrizeAndPromoCode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Regular Price", style: AppFontStyle.text_14_500(AppColors.lightBlackClr, fontFamily: AppFontFamily.interMedium)),
                  hBox(5.h),
                  CustomTextFormField(
                    key: restaurantProductAddController.regularKey,
                    controller: restaurantProductAddController.regularPriceController.value,
                    textInputType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(6),
                      DecimalTextInputFormatter(),
                    ],
                    onTap: () {
                      restaurantProductAddController.activeSalePriceValidation.value = false;
                    },
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter regular price";
                      }
                      double sale = double.tryParse(restaurantProductAddController.salePriceController.value.text) ?? 0;
                      double regular = double.tryParse(value) ?? 0;
                      if (sale >= regular) {return restaurantProductAddController.activeSalePriceValidation.value? null : "Regular > Sale required";}
                      if (regular <= 0) return "Invalid amount";
                      if (!isValidNumberFormat(value)) return "Invalid format";
                      return null;
                    },
                    hintText: 'eg. GHC 1,300',
                  ),
                ],
              ),
            ),
            wBox(12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Promo Code (Optional)", style: AppFontStyle.text_14_500(AppColors.lightBlackClr, fontFamily: AppFontFamily.interMedium,),),
                  hBox(5.h),
                  CustomTextFormField(
                    controller: restaurantProductAddController.promoController.value,
                    textInputType: TextInputType.number,
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    hintText: 'eg. GHC 1,110',
                  ),
                ],
              ),
            ),
          ],
        ),
        hBox(12.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Stock Quantity", style: AppFontStyle.text_14_500(AppColors.lightBlackClr, fontFamily: AppFontFamily.interMedium)),
                  hBox(5.h),
                  CustomTextFormField(
                    key: restaurantProductAddController.stockKey,
                    controller: restaurantProductAddController.stockController.value,
                    textInputType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(20),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter stock quantity";
                      }
                      if (int.tryParse(value) == null) {
                        return "Invalid quantity";
                      }
                      if ((int.tryParse(value) ?? 0) <= 0) {
                        return "Quantity must be greater than 0";
                      }
                      return null;
                    },
                    hintText: 'eg. 32',
                  ),
                ],
              ),
            ),
            wBox(12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Stock Units", style: AppFontStyle.text_14_500(AppColors.lightBlackClr, fontFamily: AppFontFamily.interMedium)),
                  hBox(5.h),
                  Container(
                    key: restaurantProductAddController.stockSectionKey,
                    child: Obx(() => CustomDropDown(
                        selectedValue: restaurantProductAddController.selectedStockSection.value.toUpperCase(),
                        items: restaurantProductAddController.stockUnitSection.map((e) => e.toUpperCase()).toList(),
                        borderColor: AppColors.textFieldBorder,
                        hintText: "eg.Units,kg",
                        btnHeight: 50,
                        onChanged: (value) {
                          restaurantProductAddController.selectedStockSection.value = value!.toLowerCase();
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please select unit";
                          }
                          return null;
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        hBox(12.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Seller SKU", style: AppFontStyle.text_14_500(AppColors.lightBlackClr,fontFamily: AppFontFamily.interMedium)),
                  hBox(5.h),
                  CustomTextFormField(
                    key: restaurantProductAddController.skuKey,
                    controller: restaurantProductAddController.skuController.value,
                    textInputType: TextInputType.text,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(20),
                    ],
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    validator: (value) {
                      if (restaurantProductAddController.skuController.value.text.trim().isEmpty) {
                        return "Please enter seller";
                      }
                      return null;
                    },
                    hintText: 'eg. SM-A55-1-BLK',
                  ),
                ],
              ),
            ),
            wBox(12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("GTIN/Barcode",style: AppFontStyle.text_14_500(AppColors.lightBlackClr, fontFamily: AppFontFamily.interMedium,),),
                  hBox(5.h),
                  CustomTextFormField(
                    key: restaurantProductAddController.barcodeKey,
                    controller: restaurantProductAddController.barcodeController.value,
                    textInputType: TextInputType.text,
                    validator: (value) {
                      if (restaurantProductAddController.barcodeController.value.text.trim().isEmpty) {
                        return "Please enter barcode";
                      }
                      return null;
                    },
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    hintText: 'eg. EAN 8806091',
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Column productDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Product Description  ", style: AppFontStyle.text_14_500(AppColors.lightBlackClr, fontFamily: AppFontFamily.interMedium)),
        hBox(5),
        CustomTextFormField(
          textInputAction: TextInputAction.newline,
          textInputType: TextInputType.multiline,
          key: restaurantProductAddController.descriptionKey,
          minLines: 4,
          onTapOutside: (event) {
            FocusManager.instance.primaryFocus!.unfocus();
          },
          inputFormatters: [LengthLimitingTextInputFormatter(200)],
          onTap: () {
          },
          maxLines: 8,
          controller: restaurantProductAddController.descriptionController.value,
          buildCounter: (context,
              {required currentLength,
              required isFocused,
              required maxLength}) {
            int actualLength = restaurantProductAddController.descriptionController.value.text.trim().length;
            return Padding(padding: const EdgeInsets.only(left: 22),
                child: Text('$actualLength Characters'));
          },
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "Please enter product description";
            }
            if (restaurantProductAddController.descriptionController.value.text.trim().length < 20) {
              return "Please enter minimum 20 character";
            }
            return null;
          },
          hintText: 'Product Description',
        ),
      ],
    );
  }

  Column productTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Product Name  ", style: AppFontStyle.text_14_500(AppColors.lightBlackClr, fontFamily: AppFontFamily.interMedium),),
        hBox(5),
        CustomTextFormField(
          key: restaurantProductAddController.titleKey,
          controller: restaurantProductAddController.titleController.value,
          onTapOutside: (event) {
            FocusManager.instance.primaryFocus!.unfocus();
          },
          onTap: () {
          },
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "Please enter product title";
            }
            if (!isValidCharacters(value)) {
              return "Please enter a valid character";
            }
            return null;
          },
          hintText: 'Product Title',
        ),
      ],
    );
  }

  GetBuilder<RestaurantProductAddController> _profileImagePicker(BuildContext contexts) {
    return GetBuilder(
      init: restaurantProductAddController,
      builder: (context) {
        return Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  DottedBorder(
                    strokeCap: StrokeCap.square,
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(12),
                    padding: const EdgeInsets.all(6),
                    dashPattern: const [5],
                    strokeWidth: 1.5,
                    color: restaurantProductAddController.isErrorColor.value
                        ? AppColors.red
                        : AppColors.borderClr,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      child: Center(
                        child: Obx(
                          () => SizedBox(
                            height: Get.width * .7,
                            width: Get.width,
                            child: restaurantProductAddController.image.value !=
                                    null
                                ? Image.file(
                                    restaurantProductAddController.image.value!,
                                    width: 130,
                                    height: 130,
                                    fit: BoxFit.fill,
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        ImageConstants.uploadImage,
                                        height: 30,
                                        width: 30,
                                      ),
                                      SizedBox(height: 34.h),
                                      Text(
                                        "Upload Product Image",
                                        style: AppFontStyle.text_14_500(
                                          AppColors.lightBlackClr,
                                          fontFamily:
                                              AppFontFamily.gilroyMedium,
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                      Text(
                                        "jpg/png should be less than 5mb",
                                        style: AppFontStyle.text_14_400(
                                          AppColors.hintText,
                                          fontFamily:
                                              AppFontFamily.gilroyMedium,
                                        ),
                                      ),
                                      SizedBox(height: 16.h),
                                      CustomElevatedButton(
                                        borderSide: BorderSide(color: AppColors.black),
                                        borderRadius: BorderRadius.circular(10),
                                        color: AppColors.transparent,
                                        width: 110.w,
                                        height: 40.h,
                                        onPressed: () {
                                          restaurantProductAddController.pickImage(contexts).then((val) =>
                                          restaurantProductAddController.isErrorColor.value = false);
                                        },
                                        text: "Choose File",
                                        // textColor: AppColors.lightBlackClr,
                                        textStyle: AppFontStyle.text_15_400(AppColors.lightBlackClr, fontFamily: AppFontFamily.gilroySemiBold),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (restaurantProductAddController.image.value != null)
                    Positioned(
                      right: 3.w,
                      top: 5.h,
                      child: GestureDetector(
                        onTap: () {
                          if (restaurantProductAddController.image.value != null) {
                            restaurantProductAddController.image.value = null;restaurantProductAddController.imageBase64.value = '';
                          }
                        },
                        child: Icon(Icons.cancel_outlined, size: 25, color: AppColors.red),
                      ),
                    ),
                ],
              ),
              if (restaurantProductAddController.isErrorColor.value) ...[
                hBox(8.h),
                Text("Please select image", style: AppFontStyle.text_12_200(AppColors.red, fontFamily: AppFontFamily.gilroyMedium)),
              ],
            ],
          ),
        );
      },
    );
  }

  CustomAppBar appbar() {
    return CustomAppBar(
        title: Text(
      "Add Product",
      style: AppFontStyle.text_22_400(
        AppColors.darkText,
        fontFamily: AppFontFamily.gilroySemiBold,
      ),
    ));
  }

  GridView additionalImages() {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 6,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        return Obx(
          () => Stack(
            children: [
              GestureDetector(
                onTap: () {
                  restaurantProductAddController.pickMoreImage(index);
                },
                child: DottedBorder(
                  strokeCap: StrokeCap.square,
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(12),
                  padding: const EdgeInsets.all(6),
                  dashPattern: const [5],
                  strokeWidth: 1.5,
                  color: AppColors.borderClr,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    child: Obx(() {
                      final imageFile = restaurantProductAddController.additionalImages[index];
                      return SizedBox(
                        width: Get.width * 0.42,
                        height: Get.width * 0.42,
                        child: imageFile.value != null ? Image.file(imageFile.value!, fit: BoxFit.fill,)
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    ImageConstants.uploadImage,
                                    height: 24,
                                    width: 24,
                                  ),
                                  SizedBox(height: 15.h),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 3.0),
                                    child: Text("Additional\nImages", textAlign: TextAlign.center, style: AppFontStyle.text_14_400(
                                      AppColors.hintText, fontFamily: AppFontFamily.gilroyRegular),
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                      );
                    }),
                  ),
                ),
              ),
              if (restaurantProductAddController.additionalImages[index].value != null)
                Positioned(
                  right: 3.w,
                  top: 5.h,
                  child: GestureDetector(
                    onTap: () {
                      if (restaurantProductAddController.additionalImages[index].value != null) {
                        restaurantProductAddController.additionalImages[index].value = null;
                        restaurantProductAddController.additionalImageBase64[index].value = '';
                      }
                    },
                    child: Icon(Icons.cancel_outlined, size: 25, color: AppColors.red),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget publishButton() {
    return Obx(() {
      if (restaurantProductAddController.hasVariants.value) {
        return SizedBox();
      }
      return Row(
        children: [
          Spacer(),
          AppContainer(
            borderRadius: BorderRadius.circular(8.r),
            height: 45.h,
            width: 80.w,
            alignment: Alignment.center,
            child: Text("Cancel", style: AppFontStyle.text_14_400(AppColors.black, fontFamily: AppFontFamily.interMedium)),
          ),
          wBox(20.w),
          CustomElevatedButton(
            borderRadius: BorderRadius.circular(8.r),
            height: 45.h,
            width: 160.w,
            isLoading: restaurantProductAddController.rxRequestStatus.value == ApiStatus.LOADING,
            onPressed: () async {
              bool isValid = await restaurantProductAddController.validateBeforeReview();
              if (!isValid) return;
              //
            //   for (GlobalKey<FormState> key in restaurantProductAddController.indexedKey) {
            //     if (!(key.currentState?.validate() ?? false)) {
            //       break;
            //     }
            //   }
            //   if (restaurantProductAddController.imageBase64.value.isEmpty) {
            //   restaurantProductAddController.isErrorColor.value = true;
            //   restaurantProductAddController.scrollToTop(0);
            //   return;
            // }
            //   if (restaurantProductAddController.titleController.value.text.trim().isEmpty) {
            //     restaurantProductAddController.scrollToField(restaurantProductAddController.titleKey,);
            //     return;
            //   }
            //   if (restaurantProductAddController.descriptionController.value.text.trim().isEmpty) {
            //     restaurantProductAddController.scrollToField(restaurantProductAddController.descriptionKey,);
            //     return;
            //   }
            //   if (restaurantProductAddController.regularPriceController.value.text.trim().isEmpty) {
            //     restaurantProductAddController.scrollToField(restaurantProductAddController.regularKey,);
            //     return;
            //   }
            //   if (restaurantProductAddController.stockController.value.text.trim().isEmpty) {
            //     restaurantProductAddController.scrollToField(restaurantProductAddController.stockKey,);
            //     return;
            //   }
            //   if (restaurantProductAddController.selectedStockSection.value.isEmpty) {
            //     restaurantProductAddController.scrollToField(restaurantProductAddController.stockSectionKey);
            //     return;
            //   }
            //   if (restaurantProductAddController.skuController.value.text.trim().isEmpty) {
            //     restaurantProductAddController.scrollToField(restaurantProductAddController.skuKey,);
            //     return;
            //   }
            //   if (restaurantProductAddController.barcodeController.value.text.trim().isEmpty) {
            //     restaurantProductAddController.scrollToField(restaurantProductAddController.barcodeKey,);
            //     return;
            //   }
            //   if (restaurantProductAddController.conditionController.value.text.trim().isEmpty) {
            //     restaurantProductAddController.scrollToField(restaurantProductAddController.conditionKey,);
            //     return;
            //   }
            //   if (restaurantProductAddController.packageController.value.text.trim().isEmpty) {
            //     restaurantProductAddController.scrollToField(restaurantProductAddController.packageKey,);
            //     return;
            //   }
            //   if (restaurantProductAddController.weightController.value.text.trim().isEmpty) {
            //     restaurantProductAddController.scrollToField(restaurantProductAddController.weightKey,);
            //     return;
            //   }
            //   if (restaurantProductAddController.fulfillmentController.value.text.trim().isEmpty) {
            //     restaurantProductAddController.scrollToField(restaurantProductAddController.fulfillmentKey,);
            //     return;
            //   }
            //   if (restaurantProductAddController.preparationController.value.text.trim().isEmpty) {
            //     restaurantProductAddController.scrollToField(restaurantProductAddController.preparationKey,);
            //     return;
            //   }
            //   if (restaurantProductAddController.department.value.isEmpty) {
            //     restaurantProductAddController.scrollToField(restaurantProductAddController.departmentKey);
            //     return;
            //   }
            //   if (restaurantProductAddController.category.value.isEmpty) {
            //     restaurantProductAddController.scrollToField(restaurantProductAddController.categoryKey);
            //     return;
            //   }
            //   if (restaurantProductAddController.subCategory.value.isEmpty) {
            //     restaurantProductAddController.scrollToField(restaurantProductAddController.subCategoryKey);
            //     return;
            //   }
            //   if (restaurantProductAddController.selectedCategoryId.value.trim().isEmpty) {
            //     restaurantProductAddController. scrollToField(restaurantProductAddController.categoryKey,);
            //     return;
            //   }
            //   if (restaurantProductAddController.stockController.value.text.trim().isEmpty) {
            //     restaurantProductAddController. scrollToField(
            //       restaurantProductAddController.stockKey,
            //     );
            //     return;
            //   }
            //   if (restaurantProductAddController.status.value.trim().isEmpty) {
            //     restaurantProductAddController.scrollToField(restaurantProductAddController.stockSectionKey,);
            //     return;
            //   }
              await restaurantProductAddController.restaurantAddProductApi(
                productTitle: restaurantProductAddController.titleController.value.text,
                stockQty: restaurantProductAddController.stockController.value.text,
                categoryId: restaurantProductAddController.selectedCategoryId.value,
                status: restaurantProductAddController.status.value == "1" ? "active" : "inactive",
                regularPrice: restaurantProductAddController.regularPriceController.value.text, description:
              restaurantProductAddController.descriptionController.value.text,
                mainImage: restaurantProductAddController.imageBase64.value,
                image0: restaurantProductAddController.additionalImageBase64[0].value,
                image1: restaurantProductAddController.additionalImageBase64[1].value,
                image2: restaurantProductAddController.additionalImageBase64[2].value,
                image3: restaurantProductAddController.additionalImageBase64[3].value,
                image4: restaurantProductAddController.additionalImageBase64[4].value,
                image5: restaurantProductAddController.additionalImageBase64[5].value,
              );
              pt("restaurantProductAddController${restaurantProductAddController.stockController}");
            },
            child:
            restaurantProductAddController.rxRequestStatus.value == ApiStatus.LOADING ?
            circularProgressIndicator(size: 30, color: AppColors.white) : Row(
              children: [
                // const Icon(Icons.save_outlined, color: Colors.white, size: 18),
                // wBox(8),
                Text('Save Product', style: AppFontStyle.text_15_500(AppColors.white, fontFamily: AppFontFamily.interMedium),
                ),
              ],
            ),
          )
        ],
      );
    });
  }
}
