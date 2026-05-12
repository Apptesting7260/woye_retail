import 'dart:developer';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gyaawa/routes/vendor_routes/vendor_app_routes.dart';
import 'package:gyaawa/shared/widgets/vendor_widgets/app_container.dart';

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
        child: SafeArea(
          child: Scaffold(
            appBar: appbar(),
            body: Obx(() {
                switch (restaurantProductAddController.rxRequestCategoryStatus.value) {
                  case ApiStatus.LOADING:return Center(child: circularProgressIndicator());
                  case ApiStatus.ERROR:
                    if (restaurantProductAddController.error.value == 'No internet') {
                      return InternetExceptionWidget(
                        onPress: () {
                          restaurantProductAddController.getCategoryApi();
                          // restaurantProductAddController.getAddOnApi();
                          restaurantProductAddController.getCuisineTypeApi();
                        },
                      );
                    } else {
                      return GeneralExceptionWidget(
                        onPress: () {
                          restaurantProductAddController.getCategoryApi();
                          // restaurantProductAddController.getAddOnApi();
                          restaurantProductAddController.getCuisineTypeApi();
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
                              // hBox(12.h),
                              // category(),
                              // hBox(12.h),
                              // customAttributeListGenerator(),
                              hBox(12.h),
                              status(),
                              hBox(4.h),
                              variantSection(restaurantProductAddController),
                              // options(),
                              // Form(
                              //   key: restaurantProductAddController.addOnButtonKey,
                              //   child: Column(
                              //       children: [
                              // if (restaurantProductAddController.apiAddOnData.value.addons != null) ...[
                              //   if (restaurantProductAddController.apiAddOnData.value.addons!.length >1) ...[
                              //     addOnList(),
                              //   ]
                              // ],
                              //       ],
                              //   ),
                              // ),
                              // addOnList(),
                              // hBox(10.h),
                              // attributes(),
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
                        if (restaurantProductAddController.status.value.isEmpty) {
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
                    controller: restaurantProductAddController.conditionController.value,
                    hintText: " e.g ",
                    onTapOutside: (event) {FocusManager.instance.primaryFocus?.unfocus();},
                    validator: (value) {
                      if (restaurantProductAddController.status.value == "Rejected" && (value == null || value.isEmpty)) {
                        return "Condition required";
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
                    hintText: '30*20*10 ',
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
                      LengthLimitingTextInputFormatter(20),
                    ],
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    hintText: '13 (Kg)',
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
                  ),
                ],
              ),
            ),
            wBox(12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Order Preparation Time", style: AppFontStyle.text_14_500(AppColors.lightBlackClr, fontFamily: AppFontFamily.interMedium,)),
                  hBox(5.h),
                  CustomTextFormField(
                    key: restaurantProductAddController.preparationKey,
                    controller: restaurantProductAddController.preparationController.value,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[\d\-a-zA-Z]'))
                    ],
                    hintText: "e.g, 15-20min or 1-2hr",
                    // labelText: "Preparation Time (e.g, 15-20min or 1-2hr)",
                    //    validator: (value) {
                    //     if (value == null || value.trim().isEmpty) {
                    //     return "Please enter preparation time";
                    //      }
                    //
                    //        final trimmed = value.trim().toLowerCase();
                    //
                    //       // Match patterns like 10-20min, 1-2hr, 2-3hrs, 60-90min, 1-24hr
                    //      final validPattern = RegExp(r'^\d{1,3}-\d{1,3}(min|hr|hrs)$');
                    //
                    //        if (validPattern.hasMatch(trimmed)) {
                    //        return null;
                    //            }
                    //
                    //       // Common error hints
                    //          if (RegExp(r'^\d{1,3}-\d{1,3}$').hasMatch(trimmed)) {
                    //       return "Please include time unit (min/hr/hrs) at the end";
                    //         }
                    //
                    //         if (RegExp(r'^\d{1,3}$').hasMatch(trimmed)) {
                    //                return "Please use range format with unit (e.g, 10-20min)";
                    //                    }
                    //
                    //          return "Invalid format. Use 10-20min, 1-2hr, or 2-3hrs.";
                    //                },
                    //               hintText: 'Preparation Time (e.g, 10-20min or 1-2hr)',
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
            Obx(() => CustomDropDownApi(
                  selectedValue: restaurantProductAddController.department.value,
                  items: departmentItems,
                  borderColor: AppColors.textFieldBorder,
                  hintText: "Electronics",
                  btnHeight: 50,
                  onChanged: (value) {
                    restaurantProductAddController.department.value = value!;
                  },
                  validator: (value) {
                    if (restaurantProductAddController.department.value.isEmpty) {
                      return "Please select department";
                    }
                    return null;
                  },
                )),
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
                      Obx(() => CustomDropDownApi(
                            selectedValue: restaurantProductAddController.category.value,
                            items: departmentItems,
                            borderColor: AppColors.textFieldBorder,
                            hintText: "Category",
                            btnHeight: 50,
                            onChanged: (value) {
                              restaurantProductAddController.category.value = value!;
                            },
                            validator: (value) {
                              if (restaurantProductAddController.category.value.isEmpty) {
                                return "Please select category";
                              }
                              return null;
                            },
                          )),
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
                      Obx(() => CustomDropDownApi(
                            selectedValue: restaurantProductAddController.subCategory.value,
                            items: departmentItems,
                            borderColor: AppColors.textFieldBorder,
                            hintText: "Sub Category",
                            btnHeight: 50,
                            onChanged: (value) {
                              restaurantProductAddController.subCategory.value = value!;
                            },
                            validator: (value) {
                              if (restaurantProductAddController.subCategory.value.isEmpty) {
                                return "Please select sub category";
                              }
                              return null;
                            },
                          )),
                    ],
                  ),
                ),
              ],
            ),
            hBox(15.h),
            Divider(),
            hBox(10.h),
            Center(
              child: Text(
                  "Electronics - Computers Additional Details", style: AppFontStyle.text_12_500(AppColors.blueLightColor, fontFamily: AppFontFamily.interSemiBold,)),),
            hBox(20.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Brand", style: AppFontStyle.text_14_500(AppColors.lightBlackClr, fontFamily: AppFontFamily.interMedium)),
                      hBox(5.h),
                      CustomTextFormField(
                        key: restaurantProductAddController.brandKey,
                        controller: restaurantProductAddController.brandController.value,
                        textInputType: TextInputType.text,
                        inputFormatters: [LengthLimitingTextInputFormatter(20),],
                        onTapOutside: (event) {FocusManager.instance.primaryFocus?.unfocus();},
                        hintText: 'eg, Apple Dell,etc',
                      ),
                    ],
                  ),
                ),
                wBox(12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Model Number", style: AppFontStyle.text_14_500(AppColors.lightBlackClr, fontFamily: AppFontFamily.interMedium,),),
                      hBox(5.h),
                      CustomTextFormField(
                        key: restaurantProductAddController.modelNoKey,
                        controller: restaurantProductAddController.modelController.value,
                        textInputType: TextInputType.number,
                        inputFormatters: [LengthLimitingTextInputFormatter(20),],
                        onTapOutside: (event) {FocusManager.instance.primaryFocus?.unfocus();},
                        hintText: 'Model number',
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
                      Text("Screen Size", style: AppFontStyle.text_14_500(AppColors.lightBlackClr, fontFamily: AppFontFamily.interMedium)),
                      hBox(5.h),
                      CustomTextFormField(
                        key: restaurantProductAddController.screenSizeKey,
                        controller: restaurantProductAddController.screenSizeController.value,
                        textInputType: TextInputType.text,
                        inputFormatters: [LengthLimitingTextInputFormatter(20),],
                        onTapOutside: (event) {FocusManager.instance.primaryFocus?.unfocus();},
                        hintText: 'eg, 13,15.5',
                      ),
                    ],
                  ),
                ),
                wBox(12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Storage", style: AppFontStyle.text_14_500(AppColors.lightBlackClr, fontFamily: AppFontFamily.interMedium,),),
                      hBox(5.h),
                      CustomTextFormField(
                        key: restaurantProductAddController.storageKey,
                        controller: restaurantProductAddController.storageController.value,
                        textInputType: TextInputType.number,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(20),
                        ],
                        onTapOutside: (event) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        hintText: 'eg, 256GB,1TB',
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
                      Text("Processor", style: AppFontStyle.text_14_500(AppColors.lightBlackClr, fontFamily: AppFontFamily.interMedium)),
                      hBox(5.h),
                      CustomTextFormField(
                        key: restaurantProductAddController.processorKey,
                        controller: restaurantProductAddController.processorController.value,
                        textInputType: TextInputType.text,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(20),
                        ],
                        onTapOutside: (event) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        hintText: 'eg, Intel i5, Apple M1',
                      ),
                    ],
                  ),
                ),
                wBox(12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Ram", style: AppFontStyle.text_14_500(AppColors.lightBlackClr, fontFamily: AppFontFamily.interMedium)),
                      hBox(5.h),
                      CustomTextFormField(
                        key: restaurantProductAddController.ramKey,
                        controller: restaurantProductAddController.ramController.value,
                        textInputType: TextInputType.number,
                        inputFormatters: [LengthLimitingTextInputFormatter(20)],
                        onTapOutside: (event) {FocusManager.instance.primaryFocus?.unfocus();},
                        hintText: 'eg, 8GB,16GB',
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
                      Text("Warranty Period", style: AppFontStyle.text_14_500(AppColors.lightBlackClr, fontFamily: AppFontFamily.interMedium)),
                      hBox(5.h),
                      CustomTextFormField(
                        key: restaurantProductAddController.warrantyKey,
                        controller: restaurantProductAddController.warrantController.value,
                        textInputType: TextInputType.text,
                        inputFormatters: [LengthLimitingTextInputFormatter(20),],
                        onTapOutside: (event) {FocusManager.instance.primaryFocus?.unfocus();},
                        hintText: 'eg, Intel i5, Apple M1',
                      ),
                    ],
                  ),
                ),
                wBox(12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Color", style: AppFontStyle.text_14_500(AppColors.lightBlackClr, fontFamily: AppFontFamily.interMedium)),
                      hBox(5.h),
                      CustomTextFormField(
                        key: restaurantProductAddController.colorKey,
                        controller: restaurantProductAddController.colorController.value,
                        textInputType: TextInputType.number,
                        inputFormatters: [LengthLimitingTextInputFormatter(20)],
                        onTapOutside: (event) {FocusManager.instance.primaryFocus?.unfocus();},
                        hintText: 'eg, Color,',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        hBox(12.h),
      ],
    );
  }

  Text title({String? title}) {
    return Text(title ?? "", style: AppFontStyle.text_18_400(AppColors.lightBlackClr, fontFamily: AppFontFamily.gilroySemiBold));}

  Widget variantSection(RestaurantProductAddController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomCheckboxTile(
          title: "This product has variants (e.g., different sizes, colors)",
          value: controller.hasVariants,
          onChanged: (val) {
            controller.hasVariants.value = val;
          },
        ),
       hBox(12),
        Obx(() {
          if (!controller.hasVariants.value) return SizedBox();

          return Column(
            children: [
              // ================= STEP 1 =================
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
                        Text("Select Variant Attributes", style: AppFontStyle.text_14_500(AppColors.lightBlackClr, fontFamily: AppFontFamily.interMedium,),),
                      ],
                    ),
                    hBox(12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: controller.allVariantAttributes.map((attr) {
                        final selected = controller.selectedVariantAttributes.contains(attr);
                        return GestureDetector(
                          onTap: () => controller.toggleAttribute(attr),
                          child: AppContainer(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            color: selected ? AppColors.primary : AppColors.white,
                            border: Border.all(color: AppColors.borderClr),
                            borderRadius: BorderRadius.circular(8),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(attr, style: AppFontStyle.text_12_500(selected ? AppColors.white : AppColors.black,
                                  fontFamily: AppFontFamily.interMedium,
                                  ),
                                ),
                                if (selected) ...[
                                  SizedBox(width: 5),
                                  Icon(Icons.close, size: 14, color: Colors.white),
                                ],
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    hBox(12),
                    //Custom Attribute
                    Obx(() {
                      return Column(
                        children: List.generate(
                          controller.customAttributes.length,
                              (index) {
                            final item = controller.customAttributes[index];
                            final isLast = index == controller.customAttributes.length - 1;

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: [
                                            CustomTextFormField(
                                              controller: item.nameController,
                                              hintText: index == 0 ? "Attribute name *" : "Attribute name",
                                              height: 45,
                                            ),
                                            const SizedBox(height: 8),
                                            CustomTextFormField(
                                              controller: item.valueController,
                                              hintText: index == 0 ? "Values (comma-separated) *" : "Values (comma-separated)",
                                              height: 45,
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (isLast) ...[
                                        wBox(10),
                                        GestureDetector(
                                          onTap: controller.addCustomAttributeField,
                                          child: AppContainer(
                                            height: 70,
                                            width: 50,
                                            border: Border.all(color: AppColors.borderClr),
                                            borderRadius: BorderRadius.circular(8),
                                            child: const Icon(Icons.add),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                hBox(6),
                                  if (index != 0)
                                    GestureDetector(
                                      onTap: () => controller.removeCustomAttributeField(index),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.close, color: Colors.red, size: 16),
                                         wBox(5),
                                           Text("Remove", style: AppFontStyle.text_12_500(AppColors.red, fontFamily: AppFontFamily.interMedium,),),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    }),
                    hBox(12),
                  ],
                ),
              ),
              hBox(12),
              // ================= STEP 2 =================
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
                          SizedBox(width: 10),
                          Text("Configure Attribute Values", style: AppFontStyle.text_14_500(AppColors.lightBlackClr, fontFamily: AppFontFamily.interMedium,),
                          ),
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
                                  Text(attr, style: AppFontStyle.text_13_500(AppColors.blackTextColor, fontFamily: AppFontFamily.interMedium,),),
                                  GestureDetector(
                                    onTap: () => controller.addAttributeValue(attr),
                                    child: Row(
                                      children: [
                                        AppContainer(
                                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                          borderRadius: BorderRadius.circular(6),
                                          border: Border.all(color: AppColors.borderClr),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.add, size: 14),
                                            wBox(5),
                                              Text("Add Value", style: AppFontStyle.text_12_500(AppColors.primary, fontFamily: AppFontFamily.interMedium,),),
                                            ],
                                          ),
                                        ),
                                        wBox(10),
                                        AppContainer(
                                          borderRadius: BorderRadius.circular(4),
                                          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                          child: Icon(Icons.delete_outline, color: AppColors.greyTextColor, size: 22)),
                                      ],
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
                                    return AppContainer(
                                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                      color: AppColors.searchText,
                                      borderRadius: BorderRadius.circular(6),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(val, style: AppFontStyle.text_12_400(AppColors.blackTextColor, fontFamily: AppFontFamily.interMedium,),),
                                          wBox(5),
                                          GestureDetector(
                                            onTap: () => controller.removeAttributeValue(attr, val),
                                            child: Icon(Icons.close, size: 16, color: AppColors.red),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                  Container(
                                    width: 90,
                                    height: 34,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: AppColors.borderClr), color: Colors.white),
                                    child: TextField(
                                      controller: controller.valueControllers[attr],
                                      style: AppFontStyle.text_13_400(AppColors.greyTextColor, fontFamily: AppFontFamily.interMedium,),
                                      decoration: InputDecoration(
                                        isDense: true,
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6,),
                                        suffixIcon: GestureDetector(
                                          onTap: () {
                                            controller.valueControllers[attr]?.clear();
                                          },
                                          child: Icon(Icons.close, size: 16, color: AppColors.red),
                                        ),
                                      ),
                                      onSubmitted: (val) {
                                        controller.addAttributeValue(attr);
                                      },
                                    ),
                                  ),
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
                        child: Text(
                          "Generate Variant Matrix (9 variants)",
                          style: AppFontStyle.text_14_500(
                            Colors.white,
                            fontFamily: AppFontFamily.interMedium,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              hBox(12),
              Obx(() {
                if (controller.variantList.isEmpty) return SizedBox();

                final tableAttributes = controller.selectedVariantAttributes.where((attr) => attr == "Storage" || attr == "RAM").toList();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Variant Matrix (${controller.variantList.length})", style: AppFontStyle.text_14_500(
                          AppColors.lightBlackClr, fontFamily: AppFontFamily.interMedium,),),

                        AppContainer(
                          height: 30,
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          borderRadius: BorderRadius.circular(6),
                          onTap: () {
                            double basePrice = double.tryParse(controller.basePriceController.text.trim()) ?? 0;
                            int baseStock = int.tryParse(controller.baseStockController.text.trim()) ?? 0;

                            for (var variant in controller.variantList) {
                              variant.price.value = basePrice;
                              variant.stock.value = baseStock;
                            }
                          },
                          child: Text("Apply Base Price to All",style: AppFontStyle.text_14_500(AppColors.lightBlackClr, fontFamily: AppFontFamily.interMedium)),
                        ),
                      ],
                    ),
                    hBox(12),
                    Table(
                      border: TableBorder.all(color: AppColors.borderClr),
                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                      children: [
                        TableRow(
                          children: [
                            Center(
                              child: Text("Select", style: AppFontStyle.text_12_500(AppColors.lightBlackClr, fontFamily: AppFontFamily.interMedium))),
                            ...tableAttributes.map((attr) => cell(attr)),
                            cell("SKU"),
                            cell("Price"),
                            cell("Stock"),
                          ],
                        ),
                        ...controller.variantList.map((variant) {
                          return TableRow(
                            children: [
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                                  child: CustomCheckboxTile(
                                    value: variant.isSelected,
                                    onChanged: (v) {
                                      variant.isSelected.value = v ?? false;
                                    },
                                    title: '',
                                  ),
                                ),
                              ),

                              ...tableAttributes.map((attr) => cell(variant.values[attr] ?? "")),
                              cell("PRD-${variant.sku}"),
                              cell(variant.price.value.toStringAsFixed(2)),

                              cell(variant.stock.value.toString()),
                            ],
                          );
                        }),
                      ],
                    ),
                    hBox(16),
                    // Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(left: 120),
                      child: CustomElevatedButton(
                        color: AppColors.black,
                        height: 40.h,
                        borderRadius: BorderRadius.circular(8),
                        onPressed: () {
                          // print("Saving Variants: $variantData");
                          Get.toNamed(VendorAppRoutes.retailProductReviewScreen);
                        },
                        child: Text("Continue to Review", style: AppFontStyle.text_16_500(AppColors.white, fontFamily: AppFontFamily.interMedium)),
                      ),
                    ),
                  ],
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
                    hintText: 'Regular Price',
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
                    key: restaurantProductAddController.promoKey,
                    controller: restaurantProductAddController.promoController.value,
                    textInputType: TextInputType.text,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(20),
                    ],
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    hintText: 'Promo Code',
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
                  Text("Stock Quantity", style: AppFontStyle.text_14_500(AppColors.lightBlackClr, fontFamily: AppFontFamily.interMedium,),),
                  hBox(5.h),
                  CustomTextFormField(
                    key: restaurantProductAddController.stockKey,
                    controller: restaurantProductAddController.stockController.value,
                    textInputType: TextInputType.text,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(20),
                    ],
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    hintText: 'Quantity',
                  ),
                ],
              ),
            ),
            wBox(12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Stock Units", style: AppFontStyle.text_14_500(AppColors.lightBlackClr, fontFamily: AppFontFamily.interMedium,)),
                  hBox(5.h),
                  Obx(() => CustomDropDown(
                        key: restaurantProductAddController.menuSectionKey,
                        selectedValue: restaurantProductAddController.selectedMenuSection.value,
                        items: restaurantProductAddController.menuSection ?? [],
                        borderColor: AppColors.textFieldBorder,
                        hintText: "Units (Kg)",
                        btnHeight: 50,
                        onChanged: (value) {
                          restaurantProductAddController.selectedMenuSection.value = value!;
                        },
                        validator: (value) {
                          if (restaurantProductAddController.selectedMenuSection.value.isEmpty) {
                            return "Please select unit";
                          }
                          return null;
                        },
                      )),
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
                  Text("Seller SKU", style: AppFontStyle.text_14_500(AppColors.lightBlackClr,fontFamily: AppFontFamily.interMedium,),),
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
                    hintText: 'Seller SKU',
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
                    textInputType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(20),
                    ],
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    hintText: 'Barcode',
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
        Text(
          "Product Description  ",
          style: AppFontStyle.text_14_500(AppColors.lightBlackClr,
              fontFamily: AppFontFamily.interMedium),
        ),
        hBox(5),
        CustomTextFormField(
          textInputAction: TextInputAction.newline,
          textInputType: TextInputType.multiline,
          key: restaurantProductAddController.descriptionKey,
          minLines: 4,
          // errorTextClr: restaurantProductAddController.isRedColor.value ? AppColors.red : AppColors.darkText,
          onTapOutside: (event) {
            // restaurantProductAddController.isRedColor.value = false;
            FocusManager.instance.primaryFocus!.unfocus();
          },
          inputFormatters: [LengthLimitingTextInputFormatter(200)],
          onTap: () {
            // restaurantProductAddController.isRedColor.value = false;
          },
          maxLines: 8,
          controller: restaurantProductAddController.descriptionController.value,
          buildCounter: (context,
              {required currentLength,
              required isFocused,
              required maxLength}) {
            int actualLength = restaurantProductAddController
                .descriptionController.value.text
                .trim()
                .length;
            return Padding(
                padding: const EdgeInsets.only(left: 22),
                child: Text('$actualLength Characters'));
          },
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              // if(restaurantProductAddController.isSubmit.value){
              //   restaurantProductAddController.scrollToField(restaurantProductAddController.descriptionKey);
              // }
              return "Please enter product description";
            }
            if (restaurantProductAddController.descriptionController.value.text
                    .trim()
                    .length <
                20) {
              // if(restaurantProductAddController.isSubmit.value){
              //   restaurantProductAddController.scrollToField(restaurantProductAddController.descriptionKey);
              // }
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
          // errorTextClr: restaurantProductAddController.isRedColor.value ? AppColors.red : AppColors.darkText,
          onTapOutside: (event) {
            // restaurantProductAddController.isRedColor.value = false;
            FocusManager.instance.primaryFocus!.unfocus();
          },
          onTap: () {
            // restaurantProductAddController.isRedColor.value = false;
          },
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              // if(restaurantProductAddController.isSubmit.value){
              //   restaurantProductAddController.scrollToField(restaurantProductAddController.titleKey);
              // }
              return "Please enter product title";
            }
            if (!isValidCharacters(value)) {
              // if(restaurantProductAddController.isSubmit.value){
              //   restaurantProductAddController.scrollToField(restaurantProductAddController.titleKey);
              // }
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
                    child: Icon(Icons.cancel_outlined, size: 25, color: AppColors.red,),
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
              width: 150.w,
              isLoading: restaurantProductAddController.rxRequestStatus.value == ApiStatus.LOADING,
              onPressed: () async {
                bool hasError = false;

                restaurantProductAddController.publishButtonKey.currentState?.validate();
                restaurantProductAddController.addOnButtonKey.currentState?.validate();

                bool isAllValidate = true;
                for (GlobalKey<FormState> key in restaurantProductAddController.indexedKey) {
                  if (!(key.currentState?.validate() ?? false)) {
                    isAllValidate = false;
                  }
                }

                // ------------------------------------------------
                // ✅ Step 3: Validate Image + Basic Details
                // ------------------------------------------------
                if (restaurantProductAddController.imageBase64.value.isEmpty) {
                  restaurantProductAddController.isErrorColor.value = true;
                  restaurantProductAddController.scrollToTop(0);
                  return;
                }

                if (restaurantProductAddController.titleController.value.text.trim().isEmpty ||
                    !isValidCharacters(restaurantProductAddController.titleController.value.text)) {
                  restaurantProductAddController.scrollToField(restaurantProductAddController.titleKey);
                  return;
                }

                if (restaurantProductAddController.selectedCategoryId.value.trim().isEmpty) {
                  restaurantProductAddController.scrollToField(restaurantProductAddController.categoryKey);
                  return;
                }

                if (restaurantProductAddController.selectedCuisineType.value.trim().isEmpty) {
                  restaurantProductAddController.scrollToField(restaurantProductAddController.cuisineKey);
                  return;
                }

                if (restaurantProductAddController.selectedMenuSection.value.trim().isEmpty) {
                  restaurantProductAddController.scrollToField(restaurantProductAddController.menuSectionKey);
                  return;
                }

                if (restaurantProductAddController.regularPriceController.value.text.trim().isEmpty ||
                    !isValidCharacters(restaurantProductAddController.regularPriceController.value.text) ||
                    ((double.tryParse(restaurantProductAddController.salePriceController.value.text.trim()) ?? 0) >=
                        (double.tryParse(restaurantProductAddController.regularPriceController.value.text.trim()) ?? 0)) ||
                    ((double.tryParse(restaurantProductAddController.regularPriceController.value.text.trim()) ?? 0) <= 0)) {
                  restaurantProductAddController.scrollToField(restaurantProductAddController.regularKey);
                  return;
                }

                if (restaurantProductAddController.preparationController.value.text.trim().isEmpty ||
                    !RegExp(r'^\d{1,3}-\d{1,3}(min|hr|hrs)$', caseSensitive: false).hasMatch(restaurantProductAddController
                        .preparationController.value.text.trim())) {
                  restaurantProductAddController.scrollToField(restaurantProductAddController.preparationKey, allignment: 0.02);
                  return;
                }

                if (restaurantProductAddController.descriptionController.value.text.trim().isEmpty ||
                    restaurantProductAddController.descriptionController.value.text.length < 20) {
                  restaurantProductAddController.scrollToField(restaurantProductAddController.descriptionKey);
                  return;
                }

                dynamic firstErrorKey; // Track first invalid field
                hasError = false;

                for (int optionIndex = 0; optionIndex < restaurantProductAddController.sizeConfigs.length; optionIndex++) {
                  final configs = restaurantProductAddController.sizeConfigs[optionIndex];
                  for (int configIndex = 0;
                      configIndex < configs.length;
                      configIndex++) {
                    final config = configs[configIndex];
                    final name = config["name"].text.trim();
                    final price = config["price"].text.trim();

                    // Reset previous errors
                    config["nameError"].value = "";
                    config["priceError"].value = "";

                    // Check name
                    if (name.isEmpty) {
                      config["nameError"].value = "Please enter title";
                      firstErrorKey ??= config["keyName"];
                      hasError = true;
                    }

                    // Check price
                    if (price.isEmpty) {
                      config["priceError"].value = "Please enter price";
                      firstErrorKey ??= config["keyPrice"];
                      hasError = true;
                    }
                  }
                }

                restaurantProductAddController.sizeConfigs.refresh();

                if (hasError && firstErrorKey != null) {
                  restaurantProductAddController.scrollToField(firstErrorKey);
                  return;
                }

                final formState = restaurantProductAddController.addOnFormKey.currentState;

                if (formState == null || !formState.validate()) {
                  for (int i = 0; i < restaurantProductAddController.addOnFieldKeys.length; i++) {
                    final fieldMap = restaurantProductAddController.addOnFieldKeys[i];
                    final dropdownKey = fieldMap["dropdownKey"] as GlobalKey?;
                    final priceKey = fieldMap["priceKey"] as GlobalKey?;
                    final dropdownError = fieldMap["dropdownError"] as RxString;
                    final priceError = fieldMap["priceError"] as RxString;

                    final priceController = restaurantProductAddController.addOnPriceControllers[i];
                    final selectedIds = restaurantProductAddController.selectedAddOnIds;

                    dropdownError.value = "";
                    priceError.value = "";

                    if (selectedIds.length <= i || selectedIds[i].isEmpty) {
                      dropdownError.value = "Please select add-on";
                      restaurantProductAddController.scrollToField(dropdownKey!);
                      hasError = true;
                      break;
                    }

                    if (priceController.text.trim().isEmpty) {
                      priceError.value = "Please enter price";
                      restaurantProductAddController.scrollToField(priceKey!);
                      hasError = true;
                      break;
                    }
                  }

                  restaurantProductAddController.addOnFieldKeys.refresh();
                }

                if (hasError) return;
                // ------------------------------------------------
                // ✅ Step 7: If All Valid — Call API
                // ------------------------------------------------
                await restaurantProductAddController.restaurantAddProductApi(
                  productTitle: restaurantProductAddController.titleController.value.text,
                  categoryId: restaurantProductAddController.selectedCategoryId.value,
                  status: restaurantProductAddController.status.value == "1" ? "active" : "inActive",
                  regularPrice: restaurantProductAddController.regularPriceController.value.text,
                  salePrice: restaurantProductAddController.salePriceController.value.text,
                  description: restaurantProductAddController.descriptionController.value.text,
                  cuisineType: restaurantProductAddController.selectedCuisineType.value,
                  mainImage: restaurantProductAddController.imageBase64.value,
                  image0: restaurantProductAddController.additionalImageBase64[0].value,
                  image1: restaurantProductAddController.additionalImageBase64[1].value,
                  image2: restaurantProductAddController.additionalImageBase64[2].value,
                  image3: restaurantProductAddController.additionalImageBase64[3].value,
                  image4: restaurantProductAddController.additionalImageBase64[4].value,
                  image5: restaurantProductAddController.additionalImageBase64[5].value,
                );
              },
              text: "Save Product", textStyle: AppFontStyle.text_16_400(AppColors.white, fontFamily: AppFontFamily.interMedium)),
        ],
      );
    });
  }

  Column category() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () => CustomDropDownApi(
            key: restaurantProductAddController.categoryKey,
            selectedValue: restaurantProductAddController.selectedCategoryId.value,
            items: restaurantProductAddController.apiCategoryData.value.categories ?? [],
            borderColor: AppColors.textFieldBorder,
            hintText: "Select Category",
            btnHeight: 50,
            onChanged: (value) {
              restaurantProductAddController.selectedCategoryId.value = value!;

              // 🔹 CLEAR OLD ATTRIBUTE SELECTIONS
              restaurantProductAddController.selectedAttributeIds.clear();

              restaurantProductAddController.filterAddOnsByCategory(
                restaurantProductAddController.selectedCategoryId.value,
              );

              // Reset attribute list based on selected category
              restaurantProductAddController.attributeList.value = restaurantProductAddController.apiCategoryData.value.categories!.firstWhere((category) =>
                          category.id == restaurantProductAddController.selectedCategoryId.value);
              // -------------------------------
              // Reset all option-related data
              restaurantProductAddController.selectedOptionIndexes.clear();
              restaurantProductAddController.sizeConfigs.clear();
              restaurantProductAddController.sizeConfigs.value = List.generate(
                  restaurantProductAddController.attributeList.value.options?.length ??
                      0,
                  (_) => []);
              // -------------------------------

              restaurantProductAddController.indexedKey = [];
              restaurantProductAddController.masterNameControllerList.value = [];
              restaurantProductAddController.masterPriceControllerList.value = [];
              restaurantProductAddController.masterNameKeyList.value = [];
              restaurantProductAddController.masterPriceKeyList.value = [];
              restaurantProductAddController.isExtra.value = [];
              restaurantProductAddController.increaseItemCount.value = [];

              if (restaurantProductAddController.attributeList.value.attributes != null) {
                for (int i = 0; i < restaurantProductAddController.attributeList.value.attributes!.length; i++) {
                  restaurantProductAddController.indexedKey.add(GlobalKey<FormState>());
                  restaurantProductAddController.masterNameControllerList.add([]);
                  restaurantProductAddController.masterPriceControllerList.add([]);
                  restaurantProductAddController.masterNameKeyList.add([]);
                  restaurantProductAddController.masterPriceKeyList.add([]);
                  restaurantProductAddController.isExtra.add(false);
                  restaurantProductAddController.increaseItemCount.add(0.obs);
                }
              }
            },
            // errorTextClr: restaurantProductAddController.isRedColor.value ? AppColors.red : AppColors.darkText,
            validator: (value) {
              if (restaurantProductAddController.selectedCategoryId.value.isEmpty && !restaurantProductAddController.isDropdownOpen.value) {
                restaurantProductAddController.scrollToField(restaurantProductAddController.categoryKey);
                return 'Please select category';
              }
              return null;
            },
            onMenuStateChange: (isOpen) {
              // restaurantProductAddController.isRedColor.value = false;
              restaurantProductAddController.isDropdownOpen.value = isOpen;
              // restaurantProductAddController.update();
            },
          ),
        ),
        hBox(12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Obx(
                () => CustomDropDownApi(
                  key: restaurantProductAddController.cuisineKey,
                  selectedValue: restaurantProductAddController.selectedCuisineType.value,
                  items: restaurantProductAddController.apiCuisineTypeData.value.cuisine ?? [],
                  borderColor: AppColors.textFieldBorder,
                  hintText: "Brand",
                  btnHeight: 50,
                  onChanged: (value) {
                    restaurantProductAddController.selectedCuisineType.value = value!;
                  },
                  validator: (value) {
                    if (restaurantProductAddController.selectedCuisineType.value == "" ||
                        restaurantProductAddController.selectedCuisineType.value.isEmpty) {
                      // restaurantProductAddController.scrollToField(restaurantProductAddController.cuisineKey);
                      return "Please select brand";
                    }
                    return null;
                  },
                  onMenuStateChange: (isOpen) {
                    restaurantProductAddController.isDropdownOpen.value = isOpen;
                  },
                ),
              ),
            ),
            wBox(12.w),
            Expanded(
              child: Obx(
                () => CustomDropDown(
                  key: restaurantProductAddController.menuSectionKey,
                  selectedValue: restaurantProductAddController.selectedMenuSection.value,
                  items: restaurantProductAddController.menuSection ?? [],
                  borderColor: AppColors.textFieldBorder,
                  hintText: "Department",
                  btnHeight: 50,
                  onChanged: (value) {
                    restaurantProductAddController.selectedMenuSection.value = value!;
                  },
                  validator: (value) {
                    if (restaurantProductAddController.selectedMenuSection.value == "" ||
                        restaurantProductAddController.selectedMenuSection.value.isEmpty) {
                      return "Please select menu";
                    }
                    return null;
                  },
                ),
              ),
            ),
          ],
        ),
        hBox(12.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CustomTextFormField(
                key: restaurantProductAddController.regularKey,
                controller:
                    restaurantProductAddController.regularPriceController.value,
                onTap: () {
                  // restaurantProductAddController.isRedColor.value = false;
                  restaurantProductAddController.activeSalePriceValidation.value = false;
                },
                textInputType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(6),
                  // FilteringTextInputFormatter.digitsOnly,
                  DecimalTextInputFormatter(),
                ],
                // errorTextClr: restaurantProductAddController.isRedColor.value ? AppColors.red : AppColors.darkText,
                onTapOutside: (event) {
                  // restaurantProductAddController.isRedColor.value = false;
                  FocusManager.instance.primaryFocus!.unfocus();
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    // if(restaurantProductAddController.isSubmit.value){
                    //   restaurantProductAddController.scrollToField(restaurantProductAddController.regularKey);
                    // }
                    return "Please enter regular price";
                  }
                  double sale = 0;
                  double regular = 0;
                  try {
                    sale = double.parse(restaurantProductAddController.salePriceController.value.text != '' ? restaurantProductAddController
                        .salePriceController.value.text : "0");
                    regular = double.parse(restaurantProductAddController.regularPriceController.value.text != '' ? restaurantProductAddController
                            .regularPriceController.value.text : "0");
                  } catch (e) {
                    debugPrint(e.toString());
                  }
                  if (sale >= regular) {
                    // if(restaurantProductAddController.isSubmit.value){
                    //   restaurantProductAddController.scrollToField(restaurantProductAddController.regularKey);
                    // }
                    return restaurantProductAddController.activeSalePriceValidation.value ? null : "Regular price must be grater than the sale price.";}
                  if (regular <= 0) {
                    // if(restaurantProductAddController.isSubmit.value){
                    //   restaurantProductAddController.scrollToField(restaurantProductAddController.regularKey);
                    // }
                    return "Amount 0 not acceptable.";
                  }
                  if (!isValidNumberFormat(value)) {
                    // if(restaurantProductAddController.isSubmit.value){
                    //   restaurantProductAddController.scrollToField(restaurantProductAddController.regularKey);
                    // }
                    return "Please enter a valid amount";
                  }
                  return null;
                },
                hintText: 'Regular Price',
              ),
            ),
            wBox(12.w),
            Expanded(
              child: CustomTextFormField(
                key: restaurantProductAddController.saleKey,
                controller: restaurantProductAddController.salePriceController.value,
                textInputType: const TextInputType.numberWithOptions(decimal: true),
                onTap: () {
                  // restaurantProductAddController.isRedColor.value = false;

                  restaurantProductAddController.activeSalePriceValidation.value = true;
                },
                inputFormatters: [
                  // FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                  DecimalTextInputFormatter(),
                ],
                // errorTextClr: restaurantProductAddController.isRedColor.value ? AppColors.red : AppColors.darkText,
                onTapOutside: (event) {
                  // restaurantProductAddController.isRedColor.value = false;
                  FocusManager.instance.primaryFocus!.unfocus();
                },
                validator: (value) {
                  double sale = 0;
                  double regular = 0;
                  try {
                    sale = double.parse(restaurantProductAddController.salePriceController.value.text != '' ? restaurantProductAddController
                        .salePriceController.value.text : "0");
                    regular = double.parse(restaurantProductAddController.regularPriceController.value.text != ''
                        ? restaurantProductAddController.regularPriceController.value.text
                        : "0");
                  } catch (e) {
                    debugPrint(e.toString());
                  }
                  if (sale <= 0 && value!.isNotEmpty && value != '') {
                    // if(restaurantProductAddController.isSubmit.value){
                    //   restaurantProductAddController.scrollToField(restaurantProductAddController.saleKey);
                    // }
                    return "Amount 0 not\nacceptable.";
                  }
                  if (sale >= regular) {
                    // if(restaurantProductAddController.isSubmit.value){
                    //   restaurantProductAddController.scrollToField(restaurantProductAddController.saleKey);
                    // }
                    return restaurantProductAddController.activeSalePriceValidation.value ? "sale price must be\nless than the Regular\nprice." : null;
                  }
                  if (value != null && value != '' && !isValidNumberFormat(value)) {
                    // if(restaurantProductAddController.isSubmit.value){
                    //   restaurantProductAddController.scrollToField(restaurantProductAddController.saleKey);
                    // }
                    return "Please enter a valid amount";
                  }
                  return null;
                },
                hintText: 'Sale Price',
              ),
            ),
          ],
        ),
        // hBox(12.h),
      ],
    );
  }
}
