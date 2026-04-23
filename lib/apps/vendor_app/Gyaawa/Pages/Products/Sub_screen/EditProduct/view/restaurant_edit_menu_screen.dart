import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../../../../Core/Constant/image_constant.dart';
import '../../../../../../../../Data/components/general_exception.dart';
import '../../../../../../../../Data/components/internet_exception.dart';
import '../../../../../../../../Data/response/status.dart';
import '../../../../../../../../Utils/decimal_formater.dart';
import '../../../../../../../../Utils/sized_box.dart';
import '../../../../../../../../Utils/validation.dart';
import '../../../../../../../../shared/theme/colors.dart';
import '../../../../../../../../shared/theme/font_family.dart';
import '../../../../../../../../shared/theme/font_style.dart';
import '../../../../../../../../shared/widgets/custom_appbar.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/circular_progress_indicator.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/custom_checkbox.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/custom_dropdown.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/custom_dropdown_api.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/custom_elevated_button.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/custom_text_form_field.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/print.dart';
import '../../../../../vendor_common/Models/common_get_category_model.dart';
import '../Model/res_single_product_model.dart';
import '../controller/restaurant_edit_menu_controller.dart';

class RestaurantEditProductScreen extends StatelessWidget {
  RestaurantEditProductScreen({super.key});

  final RestaurantEditMenuController restaurantProductEditController = Get.put(RestaurantEditMenuController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Container(
        color: AppColors.white,
        child: SafeArea(
          child: Scaffold(
            appBar: appbar(),
            body: Obx(
                  () {
                switch (restaurantProductEditController.rxRequestCategoryStatus.value) {
                  case ApiStatus.LOADING:
                    return Center(child: circularProgressIndicator());
                  case ApiStatus.ERROR:
                    if (restaurantProductEditController.error.value ==
                        'No internet') {
                      return InternetExceptionWidget(
                        onPress: () {
                          restaurantProductEditController.getSingleProductApi(
                              productId: restaurantProductEditController
                                  .productId.value);
                        },
                      );
                    } else {
                      return GeneralExceptionWidget(
                        onPress: () {
                          restaurantProductEditController.getSingleProductApi(
                              productId: restaurantProductEditController
                                  .productId.value);
                        },
                      );
                    }
                  case ApiStatus.COMPLETED:
                    return RefreshIndicator(
                      onRefresh: () async {
                        restaurantProductEditController.addOnControllersKeyList.value = [];
                        restaurantProductEditController.addOnDropdownKeyList.value = [];
                        restaurantProductEditController.masterNameKeyList.value = [];
                        restaurantProductEditController.masterPriceKeyList.value = [];
                        restaurantProductEditController.indexedKey = [];
                        restaurantProductEditController.isExtra.value = [];
                        restaurantProductEditController.isErrorColor.value = false;
                        for (var item in restaurantProductEditController.additionalImages) {
                          item.value = null;
                        }
                        for (var apiImage in restaurantProductEditController.additionalImageFromApi) {
                          apiImage.value = '';
                        }
                        for (var baseImage in restaurantProductEditController.additionalImageBase64) {
                          baseImage.value = '';
                        }
                        restaurantProductEditController.isAddOn.value = false;
                        restaurantProductEditController.onInit();
                      },
                      child: SingleChildScrollView(
                        controller: restaurantProductEditController.scrollController,
                        child: Padding(
                          padding: REdgeInsets.symmetric(horizontal: 24.0),
                          child: Form(
                            key: restaurantProductEditController
                                .publishButtonKey,
                            child: Obx(
                                  () =>
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      hBox(8.h),
                                      _profileImagePicker(context),
                                      hBox(20.h),
                                      additionalImages(),
                                      hBox(20.h),
                                      productTitle(),
                                      hBox(12.h),
                                      category(),
                                      hBox(12.h),
                                      preparationTime(),
                                      hBox(12.h),
                                      status(),
                                      hBox(20.h),
                                      productDescription(),
                                      // hBox(4.h),
                                      options(),
                                      // hBox(20.h),

                                      // if (restaurantProductEditController.attributeList.value.attributes != null &&
                                      //     restaurantProductEditController.attributeList.value.attributes!.isNotEmpty) ...[
                                      //   customAttributeListGenerator(),
                                      // ],

                                      // Form(
                                      //   key: restaurantProductEditController.addOnButtonKey,
                                      //   child: Column(
                                      //     children: [
                                      //       if (restaurantProductEditController.apiAddOnData.value.addons != null) ...[
                                      //         if (restaurantProductEditController.apiAddOnData.value.addons!.length > 1) ...[
                                                addOnList(),
                                      //         ]
                                      //       ],
                                      //     ],
                                      //   ),
                                      // ),
                                      // discount(),
                                      hBox(14.h),
                                      attributes(),
                                      hBox(18.h),
                                      publishButton(),
                                      hBox(10.h),
                                    ],
                                  ),
                            ),
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

  Widget publishButton() {
    return Row(
      children: [
        Expanded(
          child: CustomElevatedButton(
            height: 52,
            onPressed: () {
              Get.back();
            },
            text: "Cancel",
            color: AppColors.darkText,
          ),
        ),
        wBox(8.w),
        Expanded(
          child: Obx(() =>
            CustomElevatedButton(
              height: 52,
              isLoading: restaurantProductEditController.rxRequestStatus.value == ApiStatus.LOADING,
              onPressed: () async {
                final text = restaurantProductEditController.preparationController.value.text.trim();

                bool isAllValidate = true;
                for (GlobalKey<FormState> key in restaurantProductEditController.indexedKey) {
                  if (key.currentState != null && !key.currentState!.validate()) {
                    isAllValidate = false;
                  }
                }

                if (restaurantProductEditController.imageBase64.value == '' && restaurantProductEditController.imageBase64.value.isEmpty) {
                  restaurantProductEditController.isErrorColor.value = true;
                  restaurantProductEditController.scrollToTop();
                }
                else if(restaurantProductEditController.apiSingleProductData.value.product?.title == null || (restaurantProductEditController.apiSingleProductData.value.product?.title?.trim().isEmpty ?? false)
                || restaurantProductEditController.apiSingleProductData.value.product?.title == '' || !isValidCharacters(restaurantProductEditController.apiSingleProductData.value.product?.title ?? '')){
                  restaurantProductEditController.scrollToField(restaurantProductEditController.titleKey);
                }
                else if(restaurantProductEditController.apiSingleProductData.value.product?.categoryId == null || (restaurantProductEditController.apiSingleProductData.value.product?.categoryId?.isEmpty ?? false)
                    || restaurantProductEditController.apiSingleProductData.value.product?.categoryId == ''){
                  restaurantProductEditController.scrollToField(restaurantProductEditController.categoryKey);
                }
                else if(restaurantProductEditController.apiSingleProductData.value.product?.regularPrice == null || restaurantProductEditController.apiSingleProductData.value.product?.regularPrice == ''
                    || ((double.tryParse(restaurantProductEditController.apiSingleProductData.value.product?.salePrice ?? "0") ?? 0) >= (double.tryParse(restaurantProductEditController.apiSingleProductData.value.product?.regularPrice ?? "0") ?? 0))
                    || (double.tryParse(restaurantProductEditController.apiSingleProductData.value.product?.regularPrice ?? "0") ?? 0 )<= 0){
                  restaurantProductEditController.scrollToField(restaurantProductEditController.regularKey);
                }else if (text.isEmpty ||!RegExp(r'^\d{1,3}-\d{1,3}(min|hr|hrs)$', caseSensitive: false)
                        .hasMatch(text)) {restaurantProductEditController.scrollToField(restaurantProductEditController.preparationKey,);
                }
                else if(restaurantProductEditController.apiSingleProductData.value.product?.description == null || (restaurantProductEditController.apiSingleProductData.value.product?.description?.isEmpty ?? false)
                    || restaurantProductEditController.apiSingleProductData.value.product?.description == ''
                    || (restaurantProductEditController.apiSingleProductData.value.product?.description?.length ?? 0) < 20
                ){
                  restaurantProductEditController.scrollToField(restaurantProductEditController.descriptionKey);
                }

                bool optionsValid = restaurantProductEditController.validateAllOptions();
                if (!optionsValid) {
                  return;
                }

                bool addonsValid = restaurantProductEditController.validateAllAddons();
                if (!addonsValid) {
                  return;
                }

                if ((restaurantProductEditController.publishButtonKey.currentState?.validate() ?? false) &&
                    (restaurantProductEditController.mainUrlImage.value != '' || restaurantProductEditController.imageBase64.value != '')
                    /* && (restaurantProductEditController.addOnButtonKey.currentState?.validate() ?? false)*/ && isAllValidate) {
                  restaurantProductEditController.buildOptionsJson();
                  restaurantProductEditController.buildAddonsPayload();
                  pt("selected Attributes-------------------------------> ${restaurantProductEditController.selectedAttributeIds}");

                  restaurantProductEditController.editProductApi(/*dataForSubmit*/);
                }

                // else if(restaurantProductEditController.apiSingleProductData.value.product?.cuisineType == null || (restaurantProductEditController.apiSingleProductData.value.product?.cuisineType?.isEmpty ?? false)
                //     || restaurantProductEditController.apiSingleProductData.value.product?.cuisineType == ''){
                //   restaurantProductEditController.scrollToField(restaurantProductEditController.cuisineKey);
                // }
                // else {
                //   for(int i = 0; i < restaurantProductEditController.attributeList.value.attributes!.length; i++){
                //     for(int j = 0; j < restaurantProductEditController.apiSingleProductData.value.product!.extra![i].item!.length; j++){
                //       if(restaurantProductEditController.isExtra[i] && (restaurantProductEditController.apiSingleProductData.value.product!.extra![i].item![j].name == null || restaurantProductEditController.apiSingleProductData.value.product!.extra![i].item![j].name == "") ){
                //         log(i.toString(), name: "index");
                //         log(restaurantProductEditController.masterNameKeyList.length.toString(), name: "index kay");
                //         restaurantProductEditController.scrollToField(restaurantProductEditController.masterNameKeyList[i][j]);
                //
                //         restaurantProductEditController.isExtraValidationError.value = true;
                //         log(restaurantProductEditController.isExtraValidationError.value.toString(), name: "namefgbf");
                //         return;
                //       }
                //       if(restaurantProductEditController.isExtra[i] && (restaurantProductEditController.apiSingleProductData.value.product!.extra![i].item![j].price == null || restaurantProductEditController.apiSingleProductData.value.product!.extra![i].item![j].price == "" )){
                //         restaurantProductEditController.scrollToField(restaurantProductEditController.masterPriceKeyList[i][j]);
                //         restaurantProductEditController.isExtraValidationError.value = true;
                //         log(restaurantProductEditController.isExtraValidationError.value.toString(), name: "price");
                //         return;
                //       }
                //     }
                //   }

                  // if (restaurantProductEditController.apiSingleProductData.value.product!.addOnWithNames != null) {
                  //   for (int i = 0; i < restaurantProductEditController.apiSingleProductData.value.product!.addOnWithNames!.length; i++) {
                  //     String? addOnId = restaurantProductEditController.apiSingleProductData.value.product!.addOnWithNames![i].id?.value;
                  //     String? addOnPrice = restaurantProductEditController.apiSingleProductData.value.product!.addOnWithNames![i].price;
                  //
                  //     if (addOnId == null || addOnId.trim().isEmpty) {
                  //       restaurantProductEditController.scrollToField(restaurantProductEditController.addOnDropdownKeyList[i]);
                  //       return;
                  //     }
                  //     else if (addOnPrice == null || addOnPrice.trim().isEmpty) {
                  //       restaurantProductEditController.scrollToField(restaurantProductEditController.addOnControllersKeyList[i]);
                  //       return;
                  //     }
                  //   }
                  // }
                // }

              },
              text: "Update",
            ),
          ),
        ),
      ],
    );
  }

  Widget status() {
    return Obx(
          () =>
          CustomDropDownApi(
            selectedValue: restaurantProductEditController.status.value,
            // selectedValue: restaurantProductAddController.apiSingleProductData.value.product?.status == '0' ? "Inactive" : "Active",
            items: statusItems,
            borderColor: AppColors.textFieldBorder,
            hintText: "Status",
            btnHeight: 50,
            onChanged: (value) {
              restaurantProductEditController.status.value = value!;
              restaurantProductEditController.apiSingleProductData.value.product
                  ?.status = value;
            },
          ),
    );
  }

  Text title({String? title}) {
    return Text(
      title ?? "",
      style: AppFontStyle.text_16_600(
        AppColors.darkText,
        fontFamily: AppFontFamily.gilroyRegular,
      ),
    );
  }

  Column category() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // title(title: "Category"),
        Obx(() =>
            CustomDropDownApi(
              key: restaurantProductEditController.categoryKey,
              selectedValue: restaurantProductEditController
                  .apiSingleProductData.value.product?.categoryId,
              items: restaurantProductEditController.apiCategoryData.value
                  .categories ?? [],
              borderColor: AppColors.textFieldBorder,
              hintText: "Category",
              labelText: "Category",
              btnHeight: 50,
              onChanged: (value) {
                final c = restaurantProductEditController;

                // Clear all previous state first
                c.clearAllCategoryData();

                // Set new category
                c.apiSingleProductData.value.product?.categoryId = value;
                c.selectedCategoryId.value = value!;
                c.attributeList.value = c.apiCategoryData.value.categories!.firstWhere((category) =>
                category.id == value);

                // Now rebuild based on new category
                c.initializeCategoryState();

                // Clear any product-specific data that should reset
                c.apiSingleProductData.value.product?.productAttributes?.clear();
                c.apiSingleProductData.value.product?.options?.clear();
                c.apiSingleProductData.value.product?.addOns?.clear();
              },
              // onChanged: (value) {
              //   final c = restaurantProductEditController;
              //
              //   c.apiSingleProductData.value.product?.categoryId = value;
              //   c.selectedCategoryId.value = value!;
              //   c.attributeList.value = c.apiCategoryData.value.categories!.firstWhere((category) =>
              //       category.id == value);
              //   // restaurantProductEditController.apiSingleProductData.value.product?.extra = <Extra>[].obs;
              //   c.isExtra.value = [];
              //   c.indexedKey = [];
              //   c.masterNameKeyList.value = [];
              //   c.masterPriceKeyList.value = [];
              //   for (int i = 0; i < c.attributeList.value.attributes!.length; i++) {
              //     c.indexedKey.add(GlobalKey<FormState>());
              //     c.masterNameKeyList.add([]);
              //     c.masterPriceKeyList.add([]);
              //     c.isExtra.insert(i, false);
              //     // c.apiSingleProductData.value.product?.extra?.add(Extra(
              //     //     titleid: c.attributeList.value.attributes?[i].id,
              //     //     item: <Item>[].obs,
              //     //     title: c.attributeList.value.attributes?[i].name),
              //     // );
              //     c.openedAddOnRows.clear();
              //     c.selectedAddOnIds.clear();
              //     c.addOnPriceControllers.clear();
              //     c.addOnFieldKeys.clear();
              //     c.filteredAddOns.clear();
              //
              //     c.selectedAttributeIds.clear();
              //     c.isAttributesPrefilled.value = false;
              //     // Optional: reset any error flags or colors
              //     c.isErrorColor.value = false;
              //
              //     debugPrint("🧹 Category changed → Cleared all add-ons");
              //   }
              // },
              validator: (value) {
                if (value == null || value == '' || value.trim().isEmpty) {
                  return "Please select category";
                }
                return null;
              },
            ),
        ),
        hBox(20.h),

        // title(title: "Cuisine"),
        Row(
          children: [
            Expanded(
              child: Obx(() =>
                  CustomDropDownApi(
                    selectedValue: restaurantProductEditController.apiSingleProductData.value.product?.cuisineId,
                    items: restaurantProductEditController.apiCuisineTypeData.value.cuisine ?? [],
                    borderColor: AppColors.textFieldBorder,
                    hintText: "Cuisine Type",
                    labelText: 'Cuisine',
                    btnHeight: 50,
                    // errorTextClr: restaurantProductEditController.isRedColor.value ? AppColors.red : AppColors.darkText,
                    onMenuStateChange: (isOpen) {
                      // restaurantProductEditController.isRedColor.value = false;
                    },
                    onChanged: (value) {
                      restaurantProductEditController.apiSingleProductData.value.product?.cuisineId = value;
                      // restaurantProductAddController.selectedCuisineType.value = value!;
                    },
                  ),),
            ),
            wBox(14.w),
            Expanded(
              child: Obx(
                    () => CustomDropDown(
                  // key: restaurantProductAddController.menuSectionKey,
                      labelText: "Menu Section",
                  selectedValue: restaurantProductEditController.selectedMenuSection.value,
                  items: restaurantProductEditController.menuSection ?? [],
                  borderColor: AppColors.textFieldBorder,
                  hintText: "Menu Section",
                  btnHeight: 50,
                  onChanged: (value) {
                    restaurantProductEditController.selectedMenuSection.value = value!;
                  },
                  validator: (value){
                    if(restaurantProductEditController.selectedMenuSection.value == "" || restaurantProductEditController.selectedMenuSection.value.isEmpty){
                      return "Please select menu";
                    }
                    return null;
                  },
                ),
              ),
            ),
          ],
        ),
        hBox(20.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CustomTextFormField(
                key: restaurantProductEditController.regularKey,
                labelText: "Regular Price",
                // errorTextClr: restaurantProductEditController.isRedColor.value ? AppColors.red : AppColors.darkText,
                controller: TextEditingController(
                    text: restaurantProductEditController
                        .apiSingleProductData.value.product?.regularPrice ??
                        ''),
                onTap: () {
                  // restaurantProductEditController.isSubmit.value = false;
                  restaurantProductEditController.activeSalePriceValidation
                      .value = false;
                  // restaurantProductEditController.isRedColor.value = false;
                },
                textInputType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) {
                  restaurantProductEditController.apiSingleProductData.value
                      .product?.regularPrice = value;
                },
                inputFormatters: [
                  // FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                  DecimalTextInputFormatter(),
                ],
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus!.unfocus();
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    // if (restaurantProductEditController.isSubmit.value) {
                    //   restaurantProductEditController.scrollToField(restaurantProductEditController.regularKey);
                    // }
                    return "Please enter regular price";
                  }
                  double sale = 0;
                  double regular = 0;
                  try {
                    sale = double.parse(
                        restaurantProductEditController.apiSingleProductData
                            .value.product?.salePrice != ''
                            ? restaurantProductEditController
                            .apiSingleProductData.value.product?.salePrice ??
                            '0' : "0");
                    regular = double.parse(
                        restaurantProductEditController.apiSingleProductData
                            .value.product?.regularPrice != ''
                            ? restaurantProductEditController
                            .apiSingleProductData.value.product?.regularPrice ??
                            "0" : "0");
                  } catch (e) {
                    debugPrint(e.toString());
                  }
                  if (sale >= regular) {
                    // if (restaurantProductEditController.isSubmit.value) {
                    //   restaurantProductEditController.scrollToField(restaurantProductEditController.regularKey);
                    // }
                    return restaurantProductEditController
                        .activeSalePriceValidation.value
                        ? null
                        : "Regular price must\nbe grater than the\nsale price.";
                  }
                  if (regular <= 0) {
                    // if (restaurantProductEditController.isSubmit.value) {
                    //   restaurantProductEditController.scrollToField(restaurantProductEditController.regularKey);
                    // }
                    return "Amount 0 not\nacceptable";
                  }
                  if (!isValidNumberFormat(value)) {
                    // if (restaurantProductEditController.isSubmit.value) {
                    //   restaurantProductEditController.scrollToField(restaurantProductEditController.regularKey);
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
                key: restaurantProductEditController.saleKey,
                labelText: "Sale Price",
                // errorTextClr: restaurantProductEditController.isRedColor.value ? AppColors.red : AppColors.darkText,
                controller: TextEditingController(
                    text: restaurantProductEditController
                        .apiSingleProductData.value.product?.salePrice ??
                        ''),
                textInputType: const TextInputType.numberWithOptions(decimal: true),
                onTap: () {
                  // restaurantProductEditController.isSubmit.value = false;
                  restaurantProductEditController.activeSalePriceValidation
                      .value = true;
                  // restaurantProductEditController.isRedColor.value = false;
                },
                onChanged: (value) {
                  restaurantProductEditController
                      .apiSingleProductData.value.product?.salePrice = value;
                },
                inputFormatters: [
                  // FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                  DecimalTextInputFormatter(),
                ],
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus!.unfocus();
                },
                validator: (value) {
                  double sale = 0;
                  double regular = 0;
                  try {
                    sale = double.parse(
                        restaurantProductEditController.apiSingleProductData
                            .value.product?.salePrice != ''
                            ? restaurantProductEditController
                            .apiSingleProductData.value.product?.salePrice ??
                            '0' : "0");
                    regular = double.parse(
                        restaurantProductEditController.apiSingleProductData
                            .value.product?.regularPrice != ''
                            ? restaurantProductEditController
                            .apiSingleProductData.value.product?.regularPrice ??
                            "0" : "0");
                  } catch (e) {
                    debugPrint(e.toString());
                  }
                  if (sale <= 0 && value!.isNotEmpty && value != '') {
                    // if (restaurantProductEditController.isSubmit.value) {
                    //   restaurantProductEditController.scrollToField(restaurantProductEditController.saleKey);
                    // }
                    return "Amount 0 not\nacceptable";
                  }
                  if (sale >= regular) {
                    // if (restaurantProductEditController.isSubmit.value) {
                    //   restaurantProductEditController.scrollToField(restaurantProductEditController.saleKey);
                    // }
                    return restaurantProductEditController
                        .activeSalePriceValidation.value
                        ? "sale price must be\nless than the\nRegular price."
                        : null;
                  }
                  if (value != null && value != '' &&
                      !isValidNumberFormat(value)) {
                    // if (restaurantProductEditController.isSubmit.value) {
                    //   restaurantProductEditController.scrollToField(restaurantProductEditController.saleKey);
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
        hBox(20.h),
      ],
    );
  }


  // CustomTextFormField preparationTime() {
  //   return CustomTextFormField(
  //     key: restaurantProductEditController.preparationKey,
  //     controller: restaurantProductEditController.preparationController.value,
  //     inputFormatters: [
  //       FilteringTextInputFormatter.allow(RegExp(r'[\d\-a-zA-Z]')),
  //     ],
  //     onChanged: (value) {
  //       final controller = restaurantProductEditController.preparationController.value;
  //
  //       if (value.contains("min")) {
  //         final newValue = value.replaceAll("min", "Min");
  //         controller.value = controller.value.copyWith(
  //           text: newValue,
  //           selection: TextSelection.collapsed(offset: newValue.length),
  //         );
  //       }
  //     },
  //     onTapOutside: (event) {
  //       FocusManager.instance.primaryFocus?.unfocus();
  //     },
  //     labelText: "Preparation Time (e.g, 15-20Min)",
  //     validator: (value) {
  //       if (value == null || value.trim().isEmpty) {
  //         return "Please enter preparation time";
  //       }
  //
  //       final trimmed = value.trim();
  //
  //       final validPattern = RegExp(r'^(?:\d{1,3}|\d{1,3}-\d{1,3}Min)$');
  //
  //       if (validPattern.hasMatch(trimmed)) {
  //         return null;
  //       }
  //
  //       if (RegExp(r'^\d{1,3}-$').hasMatch(trimmed)) {
  //         return "Please complete the range (e.g, 15-20Min)";
  //       }
  //
  //       if (RegExp(r'^\d{1,3}-\d{1,3}$').hasMatch(trimmed)) {
  //         return "Please include 'Min' at the end (e.g, 15-20Min)";
  //       }
  //
  //       if (trimmed.contains('min')) {
  //         return "Please use uppercase 'Min' (e.g, 15-20Min)";
  //       }
  //
  //       if (RegExp(r'^\d{1,3}Min$').hasMatch(trimmed)) {
  //         return "Single value cannot include 'Min' (use 15 or 15-20Min)";
  //       }
  //
  //       return "Invalid format. Use 15 or 15-20Min.";
  //     },
  //     hintText: 'Preparation Time (e.g, 15-20Min)',
  //   );
  // }


  CustomTextFormField preparationTime() {
    return CustomTextFormField(
      key: restaurantProductEditController.preparationKey,
      controller: restaurantProductEditController.preparationController.value,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[\d\-a-zA-Z]')),
      ],
      onChanged: (value) {
        final controller = restaurantProductEditController.preparationController.value;

        // Normalize suffix to lowercase
        final normalized = value
            .replaceAll("Min", "min")
            .replaceAll("HR", "hr")
            .replaceAll("HRS", "hrs");

        if (value != normalized) {
          controller.value = controller.value.copyWith(
            text: normalized,
            selection: TextSelection.collapsed(offset: normalized.length),
          );
        }
      },
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      labelText: "Preparation Time (e.g, 15-20min or 1-2hr)",
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Please enter preparation time";
        }

        final trimmed = value.trim().toLowerCase();

        // Match patterns like 10-20min, 1-2hr, 2-3hrs, 60-90min, 1-24hr
        final validPattern = RegExp(r'^\d{1,3}-\d{1,3}(min|hr|hrs)$');

        if (validPattern.hasMatch(trimmed)) {
          return null;
        }

        // Common error hints
        if (RegExp(r'^\d{1,3}-\d{1,3}$').hasMatch(trimmed)) {
          return "Please include time unit (min/hr/hrs) at the end";
        }

        if (RegExp(r'^\d{1,3}$').hasMatch(trimmed)) {
          return "Please use range format with unit (e.g, 10-20min)";
        }

        return "Invalid format. Use 10-20min, 1-2hr, or 2-3hrs.";
      },
      hintText: 'Preparation Time (e.g, 10-20min or 1-2hr)',
    );
  }

  CustomTextFormField productDescription() {
    return CustomTextFormField(
      textInputAction: TextInputAction.newline,
      textInputType: TextInputType.multiline,
      key: restaurantProductEditController.descriptionKey,
      labelText: "Description",
      minLines: 6,
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      maxLines: 8,
      // errorTextClr: restaurantProductEditController.isRedColor.value ? AppColors.red : AppColors.darkText,
      controller: TextEditingController(text: restaurantProductEditController.apiSingleProductData.value.product?.description ?? ''),
      buildCounter: (context, {required currentLength, required isFocused, required maxLength}) {
        int actualLength = restaurantProductEditController.apiSingleProductData.value.product?.description?.trim().length ?? 0;
        return Text('$actualLength Characters');
      },
      onChanged: (value) {
        restaurantProductEditController.apiSingleProductData.value.product?.description = value;
      },
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          // if (restaurantProductEditController.isSubmit.value) {
          //   restaurantProductEditController.scrollToField(restaurantProductEditController.descriptionKey);
          // }
          return "Please enter product description";
        }
        if (value.trim().length < 20) {
          // if (restaurantProductEditController.isSubmit.value) {
          //   restaurantProductEditController.scrollToField(restaurantProductEditController.descriptionKey);
          // }
          return "Please enter minimum 20 character";
        }
        return null;
      },
      hintText: 'Product Description',
    );
  }


  Widget options() {
    return Obx(() {
      final controller = restaurantProductEditController;
      final options = controller.attributeList.value.options ?? [];

      // Ensure list lengths match
      if (controller.sizeConfigs.length != options.length) {
        controller.sizeConfigs.value =
            List.generate(options.length, (_) => <Map<String, dynamic>>[].obs);
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          hBox(4.h),
          Text(
            "Options",
            style: AppFontStyle.text_18_400(
              AppColors.lightBlackClr,
              fontFamily: AppFontFamily.gilroySemiBold,
            ),
          ),
          Text(
            "(Customizable product variations)",
            style: AppFontStyle.text_14_400(
              AppColors.greyClr,
              fontFamily: AppFontFamily.gilroyMedium,
            ),
          ),

          if (options.isNotEmpty) ...[
            hBox(14.h),

            // STEP 1: OPTION CHECKBOXES
            ...List.generate(options.length, (index) {
              final option = options[index];
              final isSelected =
              controller.selectedOptionIndexes.contains(index);

              return Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: CustomCheckboxTile(
                  title: option.name ?? "",
                  value: RxBool(isSelected),
                  onChanged: (checked) {
                    if (checked) {
                      if (!controller.selectedOptionIndexes.contains(index)) {
                        controller.selectedOptionIndexes.add(index);
                      }
                      if (controller.sizeConfigs[index].isEmpty) {
                        controller.sizeConfigs[index]
                            .add(controller.createNewConfig());
                      }
                    } else {
                      controller.selectedOptionIndexes.remove(index);
                      controller.sizeConfigs[index].clear();
                    }
                    controller.sizeConfigs.refresh();
                    controller.selectedOptionIndexes.refresh();
                  },
                ),
              );
            }),

            hBox(10.h),

            // STEP 2: CONFIGURATIONS FOR SELECTED OPTIONS
            ...List.generate(options.length, (index) {
              final option = options[index];
              final isSelected =
              controller.selectedOptionIndexes.contains(index);
              if (!isSelected) return const SizedBox.shrink();

              final configs = controller.sizeConfigs[index];

              return Padding(
                padding: EdgeInsets.only(bottom: 14.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${option.name ?? ''} Configuration",
                          style: AppFontStyle.text_16_400(
                            AppColors.lightBlackClr,
                            fontFamily: AppFontFamily.gilroySemiBold,
                          ),
                        ),

                        // ➕ Add new config button
                        GestureDetector(
                          onTap: () {
                            if (configs.isNotEmpty) {
                              final last = configs.last;
                              final lastName = last["name"].text.trim();
                              final lastPrice = last["price"].text.trim();

                              last["nameError"].value = "";
                              last["priceError"].value = "";

                              // 🔹 Scroll to invalid field if empty
                              if (lastName.isEmpty) {
                                last["nameError"].value = "Please enter title";
                                // controller.scrollToField(last["keyName"]);
                                controller.sizeConfigs.refresh();
                                return;
                              }
                              if (lastPrice.isEmpty) {
                                last["priceError"].value = "Please enter price";
                                // controller.scrollToField(last["keyPrice"]);
                                controller.sizeConfigs.refresh();
                                return;
                              }
                            }

                            configs.add(controller.createNewConfig());
                            controller.sizeConfigs.refresh();
                          },
                          child: Icon(Icons.add, color: AppColors.primary, size: 24),
                        ),
                      ],
                    ),
                    hBox(12.h),

                    // Config list
                    Obx(() => ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: configs.length,
                      itemBuilder: (context, configIndex) {
                        final config = configs[configIndex];
                        final isLast = configIndex == configs.length - 1;
                        final showRemove = configs.length > 1;

                        return Padding(
                          padding: EdgeInsets.only(bottom: 14.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 🟩 Name field
                              Obx(() => Column(
                                key: config["keyName"],
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  CustomTextFormField(
                                    hintText:
                                    "E.g., Small, Medium, Large",
                                    controller: config["name"],
                                    onChanged: (v) {
                                      if (v.trim().isNotEmpty) {
                                        config["nameError"].value = "";
                                      }
                                    },
                                  ),
                                  if (config["nameError"].value.isNotEmpty)
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 4.h, left: 4.w),
                                      child: Text(
                                        config["nameError"].value,
                                        style:
                                        AppFontStyle.text_12_400(
                                          AppColors.errorColor,
                                          fontFamily: AppFontFamily
                                              .gilroyMedium,
                                        ),
                                      ),
                                    ),
                                ],
                              )),
                              hBox(10.h),

                              // 🟦 Price field
                              Obx(() => Column(
                                key: config["keyPrice"],
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  CustomTextFormField(
                                    hintText: "Price",
                                    controller: config["price"],
                                    textInputType:
                                    const TextInputType
                                        .numberWithOptions(
                                        decimal: true),
                                    onChanged: (v) {
                                      if (v.trim().isNotEmpty) {
                                        config["priceError"].value = "";
                                      }
                                    },
                                  ),
                                  if (config["priceError"]
                                      .value.isNotEmpty)
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 4.h, left: 4.w),
                                      child: Text(
                                        config["priceError"].value,
                                        style:
                                        AppFontStyle.text_12_400(
                                          AppColors.errorColor,
                                          fontFamily: AppFontFamily
                                              .gilroyMedium,
                                        ),
                                      ),
                                    ),
                                ],
                              )),
                              hBox(10.h),

                              // ➕ Add/Remove Buttons
                              Row(
                                children: [
                                  if (showRemove)
                                    GestureDetector(
                                      onTap: () {
                                        configs.removeAt(configIndex);
                                        controller.sizeConfigs.refresh();
                                      },
                                      child: Row(
                                        children: [
                                          Icon(Icons.close,
                                              color: AppColors.red, size: 18),
                                          wBox(4.w),
                                          Text(
                                            "Remove",
                                            style:
                                            AppFontStyle.text_14_400(
                                              AppColors.red,
                                              fontFamily: AppFontFamily
                                                  .gilroyMedium,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  const Spacer(),
                                  if (isLast)
                                    GestureDetector(
                                      onTap: () {
                                        final name =
                                        config["name"].text.trim();
                                        final price =
                                        config["price"].text.trim();

                                        config["nameError"].value = "";
                                        config["priceError"].value = "";

                                        // 🔹 Scroll to invalid field
                                        if (name.isEmpty) {
                                          config["nameError"].value =
                                          "Please enter title";
                                          // controller.scrollToField(config["keyName"]);
                                          controller.sizeConfigs.refresh();
                                          return;
                                        }
                                        if (price.isEmpty) {
                                          config["priceError"].value = "Please enter price";
                                          // controller.scrollToField(config["keyPrice"]);
                                          controller.sizeConfigs.refresh();
                                          return;
                                        }

                                        configs.add(controller.createNewConfig());
                                        controller.sizeConfigs.refresh();
                                      },
                                      child: Row(
                                        children: [
                                          Icon(Icons.add,
                                              color: AppColors.primary,
                                              size: 18),
                                          wBox(4.w),
                                          Text(
                                            "Add More",
                                            style:
                                            AppFontStyle.text_14_400(
                                              AppColors.primary,
                                              fontFamily: AppFontFamily
                                                  .gilroyMedium,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    )),
                  ],
                ),
              );
            }),
          ],
        ],
      );
    });
  }

  Widget attributes() {
    final category = restaurantProductEditController.attributeList.value;
    final attributes = category.attributes ?? <Attributes>[].obs;
    final product = restaurantProductEditController.apiSingleProductData.value.product;

    if (attributes.isEmpty) {
      return const SizedBox.shrink();
    }

    if (!restaurantProductEditController.isAttributesPrefilled.value &&
        product?.productAttributes != null &&
        product!.productAttributes!.isNotEmpty) {
      restaurantProductEditController.selectedAttributeIds.addAll(product.productAttributes!);
      restaurantProductEditController.isAttributesPrefilled.value = true;
    }


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Attributes",
          style: AppFontStyle.text_18_400(
            AppColors.lightBlackClr,
            fontFamily: AppFontFamily.gilroySemiBold,
          ),
        ),
        Text(
          "(Dietary restrictions and food characteristics)",
          style: AppFontStyle.text_14_400(
            AppColors.greyClr,
            fontFamily: AppFontFamily.gilroyMedium,
          ),
        ),
        hBox(8.h),

        ...attributes.map((group) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                group.groupName ?? "",
                style: AppFontStyle.text_16_400(
                  AppColors.lightBlackClr,
                  fontFamily: AppFontFamily.gilroySemiBold,
                ),
              ),
              hBox(4.h),

              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 20.w,
                mainAxisSpacing: 8.h,
                childAspectRatio: 4.5,
                children: group.items?.map((item) {
                  return Obx(() {
                    final isChecked = restaurantProductEditController.selectedAttributeIds
                        .contains(item.id.toString());

                    return CustomCheckboxTile(
                      title: item.name ?? "",
                      value: RxBool(isChecked),
                      onChanged: (v) {
                        if (v) {
                          if (!restaurantProductEditController.selectedAttributeIds
                              .contains(item.id.toString())) {
                            restaurantProductEditController.selectedAttributeIds
                                .add(item.id.toString());
                          }
                        } else {
                          restaurantProductEditController.selectedAttributeIds
                              .remove(item.id.toString());
                        }

                        pt("✅ selectedAttributeIds: ${restaurantProductEditController.selectedAttributeIds}");
                      },
                    );
                  });
                }).toList() ?? [],
              ),
              hBox(12.h),
            ],
          );
        }),
      ],
    );
  }

  CustomTextFormField productTitle() {
    return CustomTextFormField(
      key: restaurantProductEditController.titleKey,
      labelText: "Title",
      onTap: () {
        // restaurantProductEditController.isSubmit.value = false;
        // restaurantProductEditController.isRedColor.value = false;
      },
      // errorTextClr: restaurantProductEditController.isRedColor.value ? AppColors.red : AppColors.darkText,
      controller: TextEditingController(text: restaurantProductEditController.apiSingleProductData.value.product?.title ?? ''),
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      onChanged: (value) {
        restaurantProductEditController
            .apiSingleProductData.value.product!.title = value;
      },
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          // if (restaurantProductEditController.isSubmit.value) {
          //   restaurantProductEditController.scrollToField(restaurantProductEditController.titleKey);
          // }
          return "Please enter product title";
        }
        if (!isValidCharacters(value)) {
          // if (restaurantProductEditController.isSubmit.value) {
          //   restaurantProductEditController.scrollToField(restaurantProductEditController.titleKey);
          // }
          return "Please enter a valid character";
        }
        return null;
      },
      hintText: 'Product Title',
    );
  }

  GetBuilder<RestaurantEditMenuController> _profileImagePicker(BuildContext contexts) {
    return GetBuilder(
      init: restaurantProductEditController,
      builder: (context) {
        return Obx(() =>
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if(restaurantProductEditController.image.value != null || restaurantProductEditController.mainUrlImage.value.isNotEmpty){
                        restaurantProductEditController.pickImage(contexts).then((val) => restaurantProductEditController.isErrorColor.value = false);
                        }
                      },
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(12),
                        padding: const EdgeInsets.all(6),
                        dashPattern: const [4],
                        color: restaurantProductEditController.isErrorColor
                            .value ? AppColors.red : AppColors.primary
                            .withOpacity(0.5),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(
                              12)),
                          child: Center(
                            child: Obx(
                                  () =>
                                  SizedBox(
                                    height: Get.width * .7,
                                    width: Get.width,
                                    child: restaurantProductEditController.image
                                        .value !=
                                        null
                                        ? Image.file(
                                      restaurantProductEditController.image
                                          .value!,
                                      width: 130,
                                      height: 130,
                                      fit: BoxFit.fill,
                                    )
                                        : restaurantProductEditController
                                        .mainUrlImage.value.isNotEmpty
                                        ? Center(
                                      child: CachedNetworkImage(
                                        imageUrl: restaurantProductEditController
                                            .mainUrlImage.value,
                                        height: Get.width * .7,
                                        width: Get.width,
                                        fit: BoxFit.fill,
                                        placeholder: (context, url) =>
                                            Shimmer.fromColors(
                                              baseColor: AppColors.bgColor,
                                              highlightColor: AppColors
                                                  .lightText,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: AppColors.grey,
                                                  borderRadius:
                                                  BorderRadius.circular(20.r),
                                                ),
                                              ),
                                            ),
                                      ),
                                    )
                                        : Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center,
                                      mainAxisAlignment: MainAxisAlignment
                                          .center,
                                      children: [
                                        SvgPicture.asset(
                                          ImageConstants.uploadImage,
                                          height: 30,
                                          width: 30,
                                        ),
                                        SizedBox(height: 15.h),
                                        Text(
                                          "Upload Product Image",
                                          style: AppFontStyle.text_14_500(
                                            AppColors.lightBlackClr,
                                            fontFamily: AppFontFamily.gilroyMedium,
                                          ),
                                        ),
                                        SizedBox(height: 2.h),
                                        Text(
                                          "jpg/png should be less than 5mb",
                                          style: AppFontStyle.text_14_400(
                                            AppColors.hintText,
                                            fontFamily: AppFontFamily.gilroyMedium,
                                          ),
                                        ),
                                        SizedBox(height: 16.h),
                                        CustomElevatedButton(
                                          borderSide: BorderSide(color: AppColors.black),
                                          borderRadius: BorderRadius.circular(10),
                                          color: AppColors.transparent,
                                          width: 110.w,
                                          height: 40.h,
                                          onPressed: (){
                                            restaurantProductEditController.pickImage(contexts)
                                                .then((val) =>
                                            restaurantProductEditController.isErrorColor.value =
                                            false);
                                            },
                                          text: "Choose File",
                                          // textColor: AppColors.lightBlackClr,
                                          textStyle: AppFontStyle.text_15_400(AppColors.lightBlackClr,fontFamily: AppFontFamily.gilroySemiBold),
                                        )
                                      ],
                                    ),
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (restaurantProductEditController.mainUrlImage.value
                        .isNotEmpty ||
                        restaurantProductEditController.image.value != null)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: IconButton(
                          onPressed: () {
                            if (restaurantProductEditController.image.value !=
                                null) {
                              restaurantProductEditController.image.value =
                              null;
                              restaurantProductEditController.mainUrlImage
                                  .value = '';
                              restaurantProductEditController.imageBase64
                                  .value = '';
                            } else if (restaurantProductEditController
                                .mainUrlImage.value != '') {
                              restaurantProductEditController.mainUrlImage
                                  .value = '';
                              restaurantProductEditController.imageBase64
                                  .value = '';
                            }
                          },
                          icon: Icon(
                            Icons.cancel_outlined,
                            color: AppColors.red,
                          ),
                        ),
                      ),
                  ],
                ),
                if(restaurantProductEditController.isErrorColor.value) ...[
                  hBox(8.h),
                  Text("Please select image", style: AppFontStyle.text_12_200(
                      AppColors.red, fontFamily: AppFontFamily.gilroyMedium),),
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
          "Edit Menu Item",
          style: AppFontStyle.text_22_600(
            AppColors.darkText,
            fontFamily: AppFontFamily.gilroyMedium,
          ),
        ));
  }

  GridView additionalImages() {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 4,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        return Obx(() =>
          Stack(
            children: [
              GestureDetector(
                onTap: () {
                  restaurantProductEditController.pickMoreImage(index);
                },
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(12),
                  padding: const EdgeInsets.all(6),
                  dashPattern: const [4],
                  color: AppColors.primary.withOpacity(0.35),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(
                        Radius.circular(12)),
                    child: Obx(() {
                      final imageFile = restaurantProductEditController.additionalImages[index];
                      return SizedBox(
                        width: Get.width * 0.42,
                        height: Get.width * 0.42,
                        child: imageFile.value != null
                            ? Image.file(
                          imageFile.value!,
                          // width: 130,
                          // height: 130,
                          width: Get.width * 0.41,
                          height: Get.width * 0.41,
                          fit: BoxFit.fill,
                        )
                            : restaurantProductEditController.additionalImageFromApi[index].isNotEmpty
                            ? Center(
                          child: CachedNetworkImage(
                            imageUrl: restaurantProductEditController.additionalImageFromApi[index].value,
                            width: Get.width * 0.41,
                            height: Get.width * 0.41,
                            fit: BoxFit.fill,
                            errorWidget: (context, url, error) {
                              return Icon(
                                Icons.error,
                                color: AppColors.red.withOpacity(0.8),
                              );
                            },
                            placeholder: (context, url) =>
                                Shimmer.fromColors(
                                  baseColor: AppColors.bgColor,
                                  highlightColor: AppColors.lightText,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.grey,
                                      borderRadius:
                                      BorderRadius.circular(20.r),
                                    ),
                                  ),
                                ),
                          ),
                        )
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 3.0),
                              child: Text(
                                "Additional\nImages",
                                textAlign: TextAlign.center,
                                style: AppFontStyle.text_14_400(
                                  AppColors.hintText,
                                  fontFamily: AppFontFamily.gilroyRegular,
                                ),
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
              if (restaurantProductEditController.additionalImages[index].value != null ||
                  restaurantProductEditController.additionalImageFromApi[index].value != "")
                Positioned(
                  right: 8,
                  top: 8,
                  child: GestureDetector(
                    onTap: () {
                      // if (restaurantProductEditController.additionalImageFromApi[index].value != "") {
                      restaurantProductEditController
                          .additionalImageFromApi[index].value = "";
                      // } else if (restaurantProductEditController.additionalImages[index].value != null) {
                      restaurantProductEditController
                          .additionalImages[index].value = null;
                      restaurantProductEditController
                          .additionalImageBase64[index].value = '';
                      log("ha image cut ho gyi $index");
                      // }
                    },
                    child: Icon(
                      Icons.cancel_outlined,
                      size: 20,
                      color: AppColors.red,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget addOnList() {
    return Obx(() {
      final openedRows = restaurantProductEditController.openedAddOnRows;
      final selectedIds = restaurantProductEditController.selectedAddOnIds;
      final priceControllers = restaurantProductEditController.addOnPriceControllers;
      final availableAddOns = restaurantProductEditController.filteredAddOns;

      final allSelected = availableAddOns.length == selectedIds.length;

      // Ensure each row has unique field keys
      // Ensure each row has unique field keys
      if (restaurantProductEditController.addOnFieldKeys.length != openedRows.length) {
        // Only generate keys if openedRows has actual data
        if (openedRows.isNotEmpty) {
          restaurantProductEditController.addOnFieldKeys.value =
              List.generate(openedRows.length, (_) {
                return {
                  "dropdownKey": GlobalKey(),
                  "priceKey": GlobalKey(),
                  "dropdownError": RxString(""),
                  "priceError": RxString(""),
                };
              });
        } else {
          // Keep keys empty if no rows
          restaurantProductEditController.addOnFieldKeys.clear();
        }
      }


      final fieldKeys = restaurantProductEditController.addOnFieldKeys;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SizedBox(height: 16.h),
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Add-ons",
                    style: AppFontStyle.text_18_400(
                      AppColors.lightBlackClr,
                      fontFamily: AppFontFamily.gilroySemiBold,
                    ),
                  ),
                  Text("(Extra Items with additional cost)",
                    style: AppFontStyle.text_14_400(
                      AppColors.greyClr,
                      fontFamily: AppFontFamily.gilroyMedium,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  // Validate last field before adding
                  if (openedRows.isNotEmpty) {
                    final lastIndex = openedRows.length - 1;
                    final keys = fieldKeys[lastIndex];
                    final dropdownId = selectedIds.length > lastIndex
                        ? selectedIds[lastIndex]
                        : null;
                    final price = priceControllers[lastIndex].text.trim();

                    keys["dropdownError"].value = "";
                    keys["priceError"].value = "";

                    if (dropdownId == null || dropdownId.isEmpty) {
                      keys["dropdownError"].value = "Please select add-on";
                      // restaurantProductAddController.scrollToField(keys["dropdownKey"]);
                      return;
                    }
                    if (price.isEmpty) {
                      keys["priceError"].value = "Please enter price";
                      // restaurantProductAddController.scrollToField(keys["priceKey"]);
                      return;
                    }
                  }

                  // Add new empty row
                  final unselected = availableAddOns
                      .where((a) => !selectedIds.contains(a.id))
                      .toList();

                  if (unselected.isNotEmpty) {
                    openedRows.add(Addons(id: '', name: ''));
                    priceControllers.add(TextEditingController());
                    restaurantProductEditController.addOnFieldKeys.add({
                      "dropdownKey": GlobalKey(),
                      "priceKey": GlobalKey(),
                      "dropdownError": RxString(""),
                      "priceError": RxString(""),
                    });
                  }
                },
                child: Icon(Icons.add,
                    color: allSelected ? Colors.grey : AppColors.primary, size: 24),
              ),
            ],
          ),

          SizedBox(height: 14.h),

          // No Add-ons yet
          if (availableAddOns.isEmpty || openedRows.isEmpty)
            DottedBorder(
              strokeCap: StrokeCap.square,
              borderType: BorderType.RRect,
              radius: const Radius.circular(12),
              padding: const EdgeInsets.all(6),
              dashPattern: const [5],
              strokeWidth: 1.5,
              color: restaurantProductEditController.isErrorColor.value
                  ? AppColors.red
                  : AppColors.borderClr,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Column(
                      children: [
                        Text(
                          availableAddOns.isNotEmpty ? "No add-ons added yet" : "No add-ons available",
                          style: const TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                        SizedBox(height: 6.h),
                        CustomElevatedButton(
                          color: availableAddOns.isEmpty ? AppColors.primary.withAlpha(200) : AppColors.primary,
                          width: 120,
                          height: 40,
                          onPressed: () {
                            if (availableAddOns.isNotEmpty) {
                              openedRows.clear();
                              selectedIds.clear();
                              priceControllers.clear();
                              restaurantProductEditController.addOnFieldKeys.clear();

                              openedRows.add(Addons(id: '', name: ''));
                              priceControllers.add(TextEditingController());
                              restaurantProductEditController.addOnFieldKeys.add({
                                "dropdownKey": GlobalKey(),
                                "priceKey": GlobalKey(),
                                "dropdownError": RxString(""),
                                "priceError": RxString(""),
                              });
                            }
                          },
                          text: "Add Add-on",
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          if (openedRows.isNotEmpty) SizedBox(height: 12.h),

          // Add-on Rows
          ...List.generate(openedRows.length, (index) {
            final controller = priceControllers[index];
            final currentSelectedId =
            selectedIds.length > index ? selectedIds[index] : null;
            final availableForRow = availableAddOns
                .where((a) =>
            !selectedIds.contains(a.id) || a.id == currentSelectedId)
                .toList();

            final keys = fieldKeys[index];

            return Padding(
              padding: EdgeInsets.only(bottom: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dropdown
                  Obx(() => Column(
                    key: keys["dropdownKey"],
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomDropDownApi(
                        hintText: "Select Add-on",
                        items: availableForRow,
                        selectedValue: currentSelectedId,
                        onChanged: (value) {
                          if (value == null) return;
                          if (selectedIds.length > index) {
                            selectedIds[index] = value;
                          } else {
                            selectedIds.add(value);
                          }
                          keys["dropdownError"].value = "";
                        },
                      ),
                      if (keys["dropdownError"].value.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(top: 4.h, left: 4.w),
                          child: Text(
                            keys["dropdownError"].value,
                            style: AppFontStyle.text_12_400(
                              AppColors.errorColor,
                              fontFamily: AppFontFamily.gilroyMedium,
                            ),
                          ),
                        ),
                    ],
                  )),
                  SizedBox(height: 10.h),

                  // Price field
                  Obx(() => Column(
                    key: keys["priceKey"],
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextFormField(
                        controller: controller,
                        textInputType:
                        const TextInputType.numberWithOptions(decimal: true),
                        hintText: 'Price',
                        onChanged: (v) {
                          if (v.trim().isNotEmpty) {
                            keys["priceError"].value = "";
                          }
                        },
                      ),
                      if (keys["priceError"].value.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(top: 4.h, left: 4.w),
                          child: Text(
                            keys["priceError"].value,
                            style:AppFontStyle.text_12_400(
                              AppColors.errorColor,
                              fontFamily: AppFontFamily.gilroyMedium,
                            ),
                          ),
                        ),
                    ],
                  )),

                  SizedBox(height: 8.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Remove Button
                      GestureDetector(
                        onTap: () {
                          if (selectedIds.length > index) selectedIds.removeAt(index);
                          openedRows.removeAt(index);
                          controller.dispose();
                          priceControllers.removeAt(index);
                          fieldKeys.removeAt(index);

                          if (openedRows.isEmpty) {
                            selectedIds.clear();
                            priceControllers.clear();
                            fieldKeys.clear();
                          }
                        },
                        child: Row(
                          children: [
                            Icon(Icons.clear, color: AppColors.errorColor, size: 18),
                            Text(" Remove",
                                style: AppFontStyle.text_14_400(AppColors.errorColor,fontFamily: AppFontFamily.gilroyMedium)),
                          ],
                        ),
                      ),

                      // Add More
                      if (index == openedRows.length - 1 &&
                          availableAddOns.length > selectedIds.length)
                        GestureDetector(
                          onTap: () {
                            final keys = fieldKeys[index];
                            final dropdownId = selectedIds.length > index
                                ? selectedIds[index]
                                : null;
                            final price = controller.text.trim();

                            keys["dropdownError"].value = "";
                            keys["priceError"].value = "";

                            if (dropdownId == null || dropdownId.isEmpty) {
                              keys["dropdownError"].value = "Please select add-on";
                              // restaurantProductAddController
                              //     .scrollToField(keys["dropdownKey"]);
                              return;
                            }

                            if (price.isEmpty) {
                              keys["priceError"].value = "Please enter price";
                              // restaurantProductAddController
                              //     .scrollToField(keys["priceKey"]);
                              return;
                            }

                            final unselected = availableAddOns
                                .where((a) => !selectedIds.contains(a.id))
                                .toList();

                            if (unselected.isNotEmpty) {
                              openedRows.add(Addons(id: '', name: ''));
                              priceControllers.add(TextEditingController());
                              fieldKeys.add({
                                "dropdownKey": GlobalKey(),
                                "priceKey": GlobalKey(),
                                "dropdownError": RxString(""),
                                "priceError": RxString(""),
                              });
                            }
                          },
                          child: Row(
                            children: [
                              Icon(Icons.add, color: AppColors.primary, size: 18),
                              Padding(
                                padding: const EdgeInsets.only(top: 2.0),
                                child: Text(" Add More",
                                    style: AppFontStyle.text_14_400(AppColors.primary,fontFamily: AppFontFamily.gilroyMedium)),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      );
    });
  }

}




/*
  Widget addOnList() {
    return Obx(() =>
      Column(
        children: [
          GestureDetector(
            onTap: () {
              // restaurantProductEditController.isAddOn.value = !restaurantProductEditController.isAddOn.value;
              // if (!restaurantProductEditController.isAddOn.value) {
              //   restaurantProductEditController.apiSingleProductData.value.product!.addOnWithNames = <AddOnWithNames>[].obs;
              //   restaurantProductEditController.apiSingleProductData.value.product!.addOnWithNames!.add(AddOnWithNames(name: "", id: ''.obs, price: ""));
              //   restaurantProductEditController.addOnControllersKeyList.value = [];
              //   restaurantProductEditController.addOnDropdownKeyList.value = [];
              // } else {
              //   restaurantProductEditController.addOnControllersKeyList.add(GlobalKey());
              //   restaurantProductEditController.addOnDropdownKeyList.add(GlobalKey());
              //   if ((restaurantProductEditController.apiSingleProductData.value.product!.addOnWithNames?.isEmpty ?? false)) {
              //     restaurantProductEditController.apiSingleProductData.value.product!.addOnWithNames = <AddOnWithNames>[].obs;
              //     restaurantProductEditController.apiSingleProductData.value.product!.addOnWithNames?.add(AddOnWithNames(name: "", id: ''.obs, price: ""));
              //
              //   }
              // }
            },
            child: Row(
              children: [
                SvgPicture.asset(
                  restaurantProductEditController.isAddOn.value
                      ? ImageConstants.checkCircle
                      : ImageConstants.circle,
                  height: 22,
                  width: 22,
                ),
                wBox(8.w),
                title(title: "Add On"),
              ],
            ),
          ),
          hBox(16.h),
          // if (restaurantProductEditController.isAddOn.value) ...[
          //   restaurantProductEditController.apiSingleProductData.value.product!.addOnWithNames != null && restaurantProductEditController.apiSingleProductData.value.product!.addOnWithNames!.isNotEmpty
          //   ? ListView.builder(
          //       physics: const NeverScrollableScrollPhysics(),
          //       shrinkWrap: true,
          //       itemCount: restaurantProductEditController.apiSingleProductData.value.product!.addOnWithNames != null
          //         ? restaurantProductEditController.apiSingleProductData.value.product!.addOnWithNames!.length
          //         : 0,
          //       itemBuilder: (BuildContext context, index) {
          //         return Column(
          //           children: [
          //             Obx(
          //             ()=> CustomDropDownApi(
          //                 key: restaurantProductEditController.addOnDropdownKeyList[index],
          //                 selectedValue: restaurantProductEditController.apiSingleProductData.value.product!.addOnWithNames![index].id?.value,
          //                 items: restaurantProductEditController.apiAddOnData.value.addons ?? [],
          //                 borderColor: AppColors.textFieldBorder,
          //                 hintText: "Choose Addon",
          //                 btnHeight: 50,
          //                 onChanged: (value) {
          //                   // restaurantProductEditController.isSubmit.value = false;
          //                   log(value.toString());
          //                   restaurantProductEditController.apiSingleProductData.value.product!.addOnWithNames![index].id?.value = value!;
          //                   log(restaurantProductEditController.apiSingleProductData.value.product!.addOnWithNames![index].id?.value.toString() ?? "000",name: "dfddddddd");
          //                   restaurantProductEditController.apiSingleProductData.value.product!.addOnWithNames![index].name = restaurantProductEditController.apiAddOnData.value.addons?.where((item) => item.id == value).elementAt(0).name;
          //                   restaurantProductEditController.apiSingleProductData.refresh();
          //                 },
          //                 selectedValues: restaurantProductEditController.apiSingleProductData.value.product!.addOnWithNames!.map((item) => item.id.toString()).toList(),
          //                 // errorTextClr: restaurantProductEditController.isRedColor.value ? AppColors.red : AppColors.darkText,
          //                 onMenuStateChange: (isOpen) {
          //                   // restaurantProductEditController.isRedColor.value = false;
          //                 },
          //                 validator: (value) {
          //                   log(value.toString());
          //                   if (restaurantProductEditController.apiSingleProductData.value.product!.addOnWithNames![index].id?.value == null ||
          //                       restaurantProductEditController.apiSingleProductData.value.product!.addOnWithNames![index].id?.value == '') {
          //                     // if(restaurantProductEditController.isSubmit.value){
          //                     //   restaurantProductEditController.scrollToField(restaurantProductEditController.addOnDropdownKeyList[index]);
          //                     // }
          //                     return "please select Addon";
          //                   }
          //                   return null;
          //                 },
          //               ),
          //             ),
          //             hBox(12.h),
          //             CustomTextFormField(
          //               key: restaurantProductEditController.addOnControllersKeyList[index],
          //               labelText: "Price",
          //               // errorTextClr: restaurantProductEditController.isRedColor.value ? AppColors.red : AppColors.darkText,
          //               controller: TextEditingController(text: restaurantProductEditController.apiSingleProductData.value.product!.addOnWithNames![index].price ?? ''),
          //               onChanged: (value) {
          //                 restaurantProductEditController.apiSingleProductData
          //                     .value.product!.addOnWithNames![index].price =
          //                     value;
          //               },
          //               textInputType: const TextInputType.numberWithOptions(decimal: true),
          //               inputFormatters: [
          //                 // FilteringTextInputFormatter.digitsOnly,
          //                 DecimalTextInputFormatter(),
          //                 LengthLimitingTextInputFormatter(6),
          //               ],
          //               onTap: () {
          //                 // restaurantProductEditController.isSubmit.value = false;
          //                 // restaurantProductEditController.isRedColor.value = false;
          //               },
          //               onTapOutside: (event) {
          //                 FocusManager.instance.primaryFocus!.unfocus();
          //               },
          //               hintText: 'Price',
          //               validator: (value) {
          //                 if (value == null || value.trim().isEmpty) {
          //                   // if(restaurantProductEditController.isSubmit.value){
          //                   //   restaurantProductEditController.scrollToField(restaurantProductEditController.addOnControllersKeyList[index]);
          //                   // }
          //                   return "Please enter price";
          //                 }
          //                 if (!isValidNumberFormat(value)) {
          //                   // if(restaurantProductEditController.isSubmit.value){
          //                   //   restaurantProductEditController.scrollToField(restaurantProductEditController.addOnControllersKeyList[index]);
          //                   // }
          //                   return "Please enter a valid amount";
          //                 }
          //                 return null;
          //               },
          //             ),
          //             hBox(8.h),
          //             Row(
          //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //               children: [
          //                 if(restaurantProductEditController.apiSingleProductData.value.product!.addOnWithNames!.length > 1) ...[
          //                   GestureDetector(
          //                     onTap: () {
          //                       restaurantProductEditController
          //                           .apiSingleProductData.value.product!
          //                           .addOnWithNames!.removeAt(index);
          //                       restaurantProductEditController.addOnControllersKeyList.removeAt(index);
          //                       restaurantProductEditController.addOnDropdownKeyList.removeAt(index);
          //                     },
          //                     child: Row(
          //                       children: [
          //                         Icon(
          //                           CupertinoIcons.minus,
          //                           color: AppColors.red,
          //                           size: 20.sp,
          //                         ),
          //                         Text(
          //                           " Remove",
          //                           style: AppFontStyle.text_16_400(
          //                               AppColors.red,
          //                               fontFamily: AppFontFamily.gilroyMedium),
          //                         )
          //                       ],
          //                     ),
          //                   ),
          //                 ],
          //                 const Spacer(),
          //                 if(index == (restaurantProductEditController.apiSingleProductData.value.product!.addOnWithNames!.length - 1)) ...[
          //                   GestureDetector(
          //                     onTap: () {
          //                       if (restaurantProductEditController.addOnButtonKey.currentState!.validate()) {
          //                         restaurantProductEditController.apiSingleProductData.value.product!.addOnWithNames!.add(AddOnWithNames(name: "", id: ''.obs, price: ""));
          //                         restaurantProductEditController.addOnControllersKeyList.add(GlobalKey());
          //                         restaurantProductEditController.addOnDropdownKeyList.add(GlobalKey());
          //                       }
          //                     },
          //                     child: Row(
          //                       children: [
          //                         Icon(
          //                           Icons.add,
          //                           color: AppColors.primary,
          //                           size: 20.sp,
          //                         ),
          //                         Text(
          //                           " Add More",
          //                           style: AppFontStyle.text_16_400(
          //                               AppColors.primary,
          //                               fontFamily: AppFontFamily.gilroyMedium),
          //                         )
          //                       ],
          //                     ),
          //                   ),
          //                 ]
          //
          //               ],
          //             ),
          //             hBox(20.h),
          //           ],
          //         );
          //       },
          //   )
          //   : const SizedBox.shrink(),
          // ],
        ],
      ),
    );
  }
*/

// Widget customAttributeListGenerator() {
//   // log(restaurantProductEditController.apiSingleProductData.value.product!.extra!.length.toString(), name: "extra ki length");
//   return Obx(() =>
//     ListView.builder(
//       physics: const NeverScrollableScrollPhysics(),
//       shrinkWrap: true,
//       itemCount: restaurantProductEditController.attributeList.value.attributes?.length ?? 0,
//       itemBuilder: (BuildContext context, index) {
//         log(restaurantProductEditController.masterNameKeyList.length.toString(), name: "masterNameKeyList lengthhhh");
//         return  customAttributeWidgetList(
//           restaurantProductEditController.attributeList.value.attributes?[index].name ?? '',
//           restaurantProductEditController.attributeList.value.attributes?[index].id ?? '',
//           index,
//           restaurantProductEditController.masterNameKeyList[index],
//           restaurantProductEditController.masterPriceKeyList[index],
//         );
//       },
//     ),
//   );
// }

// Widget customAttributeWidgetList(String attributeName, String attributeId, int extraIndex,
//     List<GlobalKey> subNameKeyList , List<GlobalKey> subPriceKeyList) {
//   return Form(
//     key: restaurantProductEditController.indexedKey[extraIndex],
//     child: Obx(() =>
//       Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           GestureDetector(
//             onTap: () {
//               // restaurantProductEditController.isExtra[extraIndex] = !restaurantProductEditController.isExtra[extraIndex];
//               // if (restaurantProductEditController.isExtra[extraIndex] &&
//               //     (restaurantProductEditController.apiSingleProductData.value.product!.extra?[extraIndex].item?.isEmpty ?? false)) {
//               //   subNameKeyList.add(GlobalKey());
//               //   subPriceKeyList.add(GlobalKey());
//               //   restaurantProductEditController.apiSingleProductData.value.product!.extra?[extraIndex].item?.add(Item(price: "", id: "1", name: ""));
//               // } else
//               // if (!restaurantProductEditController.isExtra[extraIndex]) {
//               //   subNameKeyList = [];
//               //   subPriceKeyList = [];
//               //   restaurantProductEditController.apiSingleProductData.value.product!.extra?[extraIndex].item = <Item>[].obs;
//               // }
//             },
//             child: Row(
//               children: [
//                 SvgPicture.asset(
//                   restaurantProductEditController.isExtra[extraIndex]
//                       ? ImageConstants.checkCircle
//                       : ImageConstants.circle,
//                   height: 22,
//                   width: 22,
//                 ),
//                 wBox(8.w),
//                 title(title: attributeName),
//               ],
//             ),
//           ),
//           hBox(24.h),
//           if (restaurantProductEditController.isExtra[extraIndex]) ...[
//             Obx(() =>
//               ListView.builder(
//                 physics: const NeverScrollableScrollPhysics(),
//                 shrinkWrap: true,
//                 // itemCount: restaurantProductEditController.apiSingleProductData.value.product!.extra![extraIndex].item!.length,
//                 itemBuilder: (BuildContext context, index) {
//                   return Column(
//                     children: [
//                       CustomTextFormField(
//                         key: subNameKeyList[index],
//                         labelText: "Name",
//                         // errorTextClr: restaurantProductEditController.isRedColor.value ? AppColors.red : AppColors.darkText,
//                         onTap: () {
//                           // restaurantProductEditController.isSubmit.value = false;
//                           // restaurantProductEditController.isRedColor.value = false;
//                         },
//                         // controller: TextEditingController(text: restaurantProductEditController.apiSingleProductData.value.product!.extra?[extraIndex].item![index].name ?? ''),
//                         onTapOutside: (event) {
//                           FocusManager.instance.primaryFocus!.unfocus();
//                         },
//                         onChanged: (value) {
//                           // restaurantProductEditController.apiSingleProductData.value.product!.extra?[extraIndex].item![index].name = value;
//                         },
//                         hintText: attributeName,
//                         validator: (value) {
//                           if (value == null || value.trim().isEmpty) {
//                             // if(restaurantProductEditController.isSubmit.value){
//                             //   restaurantProductEditController.scrollToField(subNameKeyList[index]);
//                             // }
//                             return "Please enter $attributeName";
//                           }
//                           return null;
//                         },
//                       ),
//                       hBox(12.h),
//                       CustomTextFormField(
//                         key: subPriceKeyList[index],
//                         labelText: "Price",
//                         // errorTextClr: restaurantProductEditController.isRedColor.value ? AppColors.red : AppColors.darkText,
//                         onTap: () {
//                           // restaurantProductEditController.isSubmit.value = false;
//                           // restaurantProductEditController.isRedColor.value = false;
//                         },
//                         // controller: TextEditingController(text: restaurantProductEditController.apiSingleProductData.value
//                         //     .product!.extra?[extraIndex].item![index].price ??''),
//                         onTapOutside: (event) {
//                           FocusManager.instance.primaryFocus!.unfocus();
//                         },
//                         onChanged: (value) {
//                           // restaurantProductEditController.apiSingleProductData.value.product!.extra?[extraIndex].item![index].price = value;
//                           // log(restaurantProductEditController.apiSingleProductData.value.product!.extra!.toString(), name: "Extra value yha hai");
//                         },
//                         textInputType: const TextInputType.numberWithOptions(decimal: true),
//                         inputFormatters: [
//                           // FilteringTextInputFormatter.digitsOnly,
//                           DecimalTextInputFormatter(),
//                           LengthLimitingTextInputFormatter(6),
//
//                         ],
//                         hintText: 'Price',
//                         validator: (value) {
//                           if (value == null || value.trim().isEmpty) {
//                             // if(restaurantProductEditController.isSubmit.value){
//                             //   restaurantProductEditController.scrollToField(subPriceKeyList[index]);
//                             // }
//                             return "Please enter price";
//                           }
//                           double price = 0;
//                           try {
//                             price = double.parse(value);
//                           } catch (e) {
//                             debugPrint(e.toString());
//                           }
//                           if (price <= 0) {
//                             // if(restaurantProductEditController.isSubmit.value){
//                             //   restaurantProductEditController.scrollToField(subPriceKeyList[index]);
//                             // }
//                             return "Price must be grater than zero";
//                           }
//                           // if (!isValidNumberFormat(value)) {
//                           //   if(restaurantProductEditController.isSubmit.value){
//                           //     restaurantProductEditController.scrollToField(subPriceKeyList[index]);
//                           //   }
//                           //   return "Please enter a valid amount";
//                           // }
//                           return null;
//                         },
//                       ),
//                       hBox(8.h),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           // if(restaurantProductEditController.apiSingleProductData.value.product!.extra![extraIndex].item!.length > 1) ...[
//                             GestureDetector(
//                               onTap: () {
//                                 // restaurantProductEditController.apiSingleProductData.value.product!.extra?[extraIndex].item!.removeAt(index);
//                                 subNameKeyList.removeAt(index);
//                                 subPriceKeyList.removeAt(index);
//                               },
//                               child: Row(
//                                 children: [
//                                   Icon(
//                                     CupertinoIcons.minus,
//                                     color: AppColors.red,
//                                     size: 20.sp,
//                                   ),
//                                   Text(
//                                     " Remove",
//                                     style: AppFontStyle.text_15_400(
//                                         AppColors.red,
//                                         fontFamily: AppFontFamily
//                                             .gilroyMedium),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           // ],
//                           const Spacer(),
//
//                           // if(index == (restaurantProductEditController.apiSingleProductData.value.product!.extra![extraIndex].item!.length - 1)) ...[
//                           //   GestureDetector(
//                           //     onTap: () {
//                           //       // restaurantProductEditController.isRedColor.value = true;
//                           //       if (restaurantProductEditController.indexedKey[extraIndex].currentState!.validate()) {
//                           //         subNameKeyList.add(GlobalKey());
//                           //         subPriceKeyList.add(GlobalKey());
//                           //         restaurantProductEditController.apiSingleProductData.value.product!.extra?[extraIndex].item!.add(Item(
//                           //             name: "",
//                           //             id: (restaurantProductEditController.apiSingleProductData.value.product!.extra![extraIndex]
//                           //                 .item!.length).toString(),
//                           //             price: ""));
//                           //       }
//                           //     },
//                           //     child: Row(
//                           //       children: [
//                           //         Icon(
//                           //           Icons.add,
//                           //           color: AppColors.primary,
//                           //           size: 20.sp,
//                           //         ),
//                           //         Text(
//                           //           " Add More",
//                           //           style: AppFontStyle.text_15_400(
//                           //               AppColors.primary,
//                           //               fontFamily: AppFontFamily
//                           //                   .gilroyMedium),
//                           //         )
//                           //       ],
//                           //     ),
//                           //   ),
//                           // ],
//
//                         ],
//                       ),
//                       hBox(24.h),
//                     ],
//                   );
//                 },
//               ),
//             ),
//           ],
//         ],
//       ),
//     ),
//   );
// }
