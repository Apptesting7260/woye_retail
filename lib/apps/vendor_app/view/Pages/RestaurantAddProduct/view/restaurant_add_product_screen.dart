import 'dart:developer';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

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
        color: AppColors.white,
        child: SafeArea(
          child: Scaffold(
            appBar: appbar(),
            body: Obx(
              () {
                switch (restaurantProductAddController.rxRequestCategoryStatus.value) {
                  case ApiStatus.LOADING:
                    return Center(child: circularProgressIndicator());
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
                              category(),
                              hBox(12.h),
                              // customAttributeListGenerator(),
                              hBox(12.h),
                              preparationTime(),
                              hBox(12.h),
                              status(),
                              hBox(12.h),
                              productDescription(),
                              hBox(4.h),
                              options(),
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
                              addOnList(),
                              hBox(10.h),
                              attributes(),
                              hBox(14.h),
                              publishButton(),
                              hBox(10.h),
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

  Widget attributes() {
    final category = restaurantProductAddController.attributeList.value;
    final attributes = category.attributes ?? <Attributes>[].obs;

    if (attributes.isEmpty) {
      return const SizedBox.shrink();
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
                children: group?.items?.map((item) {
                  final isChecked = restaurantProductAddController.selectedAttributeIds
                      .contains(item.id.toString())
                      .obs;
                  return CustomCheckboxTile(
                    title: item.name ?? "",
                    value: isChecked,
                    onChanged: (v) {
                      isChecked.value = v;
                      if (v) {
                        if (item.id != null &&
                            !restaurantProductAddController.selectedAttributeIds
                                .contains(item.id.toString())) {
                          restaurantProductAddController.selectedAttributeIds
                              .add(item.id.toString());
                        }
                      } else {
                        restaurantProductAddController.selectedAttributeIds
                            .remove(item.id.toString());
                      }

                      pt(restaurantProductAddController.selectedAttributeIds.toString());
                    },
                  );
                }).toList() ?? [],
              ),
              hBox(12.h),
            ],
          );
        }),
      ],
    );
  }


  Widget options() {
    return Obx(() {
      final options = restaurantProductAddController.attributeList.value.options ?? [];

      // Ensure config list length == options length
      if (restaurantProductAddController.sizeConfigs.length != options.length) {
        restaurantProductAddController.sizeConfigs.value =
            List.generate(options.length, (_) => []);
      }

      if (options.isEmpty) return const SizedBox.shrink();

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
          hBox(14.h),

          // Step 1: Show all options
          ...List.generate(options.length, (index) {
            final option = options[index];
            final isSelected =
            restaurantProductAddController.selectedOptionIndexes.contains(index);

            return Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: CustomCheckboxTile(
                title: option.name ?? "",
                value: isSelected.obs,
                onChanged: (checked) {
                  if (checked) {
                    restaurantProductAddController.selectedOptionIndexes.add(index);

                    if (restaurantProductAddController.sizeConfigs[index].isEmpty) {
                      restaurantProductAddController.sizeConfigs[index].add({
                        "name": TextEditingController(),
                        "price": TextEditingController(),
                        "nameError": RxString(""),
                        "priceError": RxString(""),
                        "keyName": GlobalKey(),
                        "keyPrice": GlobalKey(),
                      });
                    }
                  } else {
                    restaurantProductAddController.selectedOptionIndexes.remove(index);
                    restaurantProductAddController.sizeConfigs[index].clear();
                  }
                  restaurantProductAddController.sizeConfigs.refresh();
                },
              ),
            );
          }),

          hBox(10.h),

          // Step 2: Configurations for selected options
          ...List.generate(options.length, (index) {
            final option = options[index];
            final isSelected =
            restaurantProductAddController.selectedOptionIndexes.contains(index);
            if (!isSelected) return const SizedBox.shrink();
            return Padding(
              padding: EdgeInsets.only(bottom: 14.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                      GestureDetector(
                        onTap: () {
                          final configs = restaurantProductAddController.sizeConfigs[index];

                          if (configs.isNotEmpty) {
                            final last = configs.last;
                            final lastName = last["name"].text.trim();
                            final lastPrice = last["price"].text.trim();

                            last["nameError"].value = "";
                            last["priceError"].value = "";

                            // Scroll only to the first empty field
                            if (lastName.isEmpty) {
                              last["nameError"].value = "Please enter title";
                              // restaurantProductAddController.scrollToField(last["keyName"]);
                              // restaurantProductAddController.sizeConfigs.refresh();
                              return; // ✅ Stop here, don't check price yet
                            }

                            if (lastPrice.isEmpty) {
                              last["priceError"].value = "Please enter price";
                              // restaurantProductAddController.scrollToField(last["keyPrice"]);
                              // restaurantProductAddController.sizeConfigs.refresh();
                              return; // Stop here
                            }
                          }

                          // If all valid, add new config
                          restaurantProductAddController.sizeConfigs[index].add({
                            "name": TextEditingController(),
                            "price": TextEditingController(),
                            "nameError": RxString(""),
                            "priceError": RxString(""),
                            "keyName": GlobalKey(),
                            "keyPrice": GlobalKey(),
                          });
                          restaurantProductAddController.sizeConfigs.refresh();
                        },
                        child: Icon(Icons.add, color: AppColors.primary, size: 24),
                      ),

                    ],
                  ),
                  hBox(12.h),

                  // Configurations list
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: restaurantProductAddController.sizeConfigs[index].length,
                    itemBuilder: (context, configIndex) {
                      final configs = restaurantProductAddController.sizeConfigs[index];
                      final config = configs[configIndex];
                      final isLast = configIndex == configs.length - 1;
                      final showRemove = configs.length > 1;

                      return Padding(
                        padding: EdgeInsets.only(bottom: 14.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Name Field
                            Obx(() => Column(
                              key: config["keyName"],
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomTextFormField(
                                  hintText: "E.G., Small, Medium, Large",
                                  controller: config["name"],
                                  onChanged: (v) {
                                    if (v.trim().isNotEmpty) {
                                      config["nameError"].value = "";
                                    }
                                  },
                                ),
                                if (config["nameError"].value.isNotEmpty)
                                  Padding(
                                    padding: EdgeInsets.only(top: 4.h, left: 4.w),
                                    child: Text(
                                      config["nameError"].value,
                                      style: AppFontStyle.text_12_400(
                                        AppColors.errorColor,
                                        fontFamily: AppFontFamily.gilroyMedium,
                                      ),
                                    ),
                                  ),
                              ],
                            )),
                            hBox(10.h),

                            // Price Field
                            Obx(() => Column(
                              key: config["keyPrice"],
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomTextFormField(
                                  hintText: "Price",
                                  controller: config["price"],
                                  textInputType: const TextInputType.numberWithOptions(
                                      decimal: true),
                                  onChanged: (v) {
                                    if (v.trim().isNotEmpty) {
                                      config["priceError"].value = "";
                                    }
                                  },
                                ),
                                if (config["priceError"].value.isNotEmpty)
                                  Padding(
                                    padding: EdgeInsets.only(top: 4.h, left: 4.w),
                                    child: Text(
                                      config["priceError"].value,
                                      style: AppFontStyle.text_12_400(
                                        AppColors.errorColor,
                                        fontFamily: AppFontFamily.gilroyMedium,
                                      ),
                                    ),
                                  ),
                              ],
                            )),
                            hBox(10.h),

                            // Add & Remove buttons
                            Row(
                              children: [
                                if (showRemove)
                                  GestureDetector(
                                    onTap: () {
                                      restaurantProductAddController.sizeConfigs[index]
                                          .removeAt(configIndex);
                                      restaurantProductAddController.sizeConfigs.refresh();
                                    },
                                    child: Row(
                                      children: [
                                        Icon(Icons.close, color: AppColors.red, size: 18),
                                        wBox(4.w),
                                        Text(
                                          "Remove",
                                          style: AppFontStyle.text_14_400(
                                            AppColors.red,
                                            fontFamily: AppFontFamily.gilroyMedium,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                const Spacer(),

                                if (isLast)
                                  GestureDetector(
                                    onTap: () {
                                      final lastName = config["name"].text.trim();
                                      final lastPrice = config["price"].text.trim();

                                      config["nameError"].value = "";
                                      config["priceError"].value = "";

                                      // Scroll to first invalid field only
                                      if (lastName.isEmpty) {
                                        config["nameError"].value = "Please enter title";
                                        // restaurantProductAddController.scrollToField(config["keyName"]);
                                        // restaurantProductAddController.sizeConfigs.refresh();
                                        return; // ✅ Stop here
                                      }

                                      if (lastPrice.isEmpty) {
                                        config["priceError"].value = "Please enter price";
                                        // restaurantProductAddController.scrollToField(config["keyPrice"]);
                                        // restaurantProductAddController.sizeConfigs.refresh();
                                        return; // ✅ Stop here
                                      }

                                      // If both fields are valid, add a new config
                                      restaurantProductAddController.sizeConfigs[index].add({
                                        "name": TextEditingController(),
                                        "price": TextEditingController(),
                                        "nameError": RxString(""),
                                        "priceError": RxString(""),
                                        "keyName": GlobalKey(),
                                        "keyPrice": GlobalKey(),
                                      });
                                      restaurantProductAddController.sizeConfigs.refresh();
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(Icons.add, color: AppColors.primary, size: 18),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 2.0),
                                          child: Text("Add More",
                                           style: AppFontStyle.text_14_400(AppColors.primary,fontFamily: AppFontFamily.gilroyMedium),
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
                  ),
                ],
              ),
            );
          }),
        ],
      );
    });
  }


  Widget publishButton() {
    return Obx(() =>
      CustomElevatedButton(
        isLoading: restaurantProductAddController.rxRequestStatus.value == ApiStatus.LOADING,
        onPressed: () async {
          bool hasError = false;

          // ------------------------------------------------
          // ✅ Step 1: Assign IDs to extras
          // ------------------------------------------------
          // for (int j = 0; j < restaurantProductAddController.extraListOfMap.length; j++) {
          //   for (int i = 0; i < (restaurantProductAddController.extraListOfMap[j]['item'] as List).length; i++) {
          //     restaurantProductAddController.extraListOfMap[j]['item'][i]['id'] = i + 1;
          //   }
          // }

          // ------------------------------------------------
          // ✅ Step 2: Validate Main Product Form
          // ------------------------------------------------
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

          if (restaurantProductAddController.preparationController.value.text.trim().isEmpty ||!RegExp(r'^\d{1,3}-\d{1,3}(min|hr|hrs)$', caseSensitive: false)
              .hasMatch(restaurantProductAddController.preparationController.value.text.trim())) {restaurantProductAddController.scrollToField(restaurantProductAddController.preparationKey,allignment: 0.02);
          return;
          }

          if (restaurantProductAddController.descriptionController.value.text.trim().isEmpty ||
              restaurantProductAddController.descriptionController.value.text.length < 20) {
            restaurantProductAddController.scrollToField(restaurantProductAddController.descriptionKey);
            return;
          }








          // // ------------------------------------------------
          // // ✅ Step 4: Validate OPTIONS
          // // ------------------------------------------------
          // for (int optionIndex in restaurantProductAddController.selectedOptionIndexes) {
          //   final configs = restaurantProductAddController.sizeConfigs[optionIndex];
          //
          //   for (int configIndex = 0; configIndex < configs.length; configIndex++) {
          //     final config = configs[configIndex];
          //     final name = config["name"].text.trim();
          //     final price = config["price"].text.trim();
          //
          //     config["nameError"].value = "";
          //     config["priceError"].value = "";
          //
          //     if (name.isEmpty) {
          //       config["nameError"].value = "Please enter title";
          //       restaurantProductAddController.scrollToField(config["keyName"]);
          //       hasError = true;
          //       break;
          //     }
          //
          //     if (price.isEmpty) {
          //       config["priceError"].value = "Please enter price";
          //       restaurantProductAddController.scrollToField(config["keyPrice"]);
          //       hasError = true;
          //       break;
          //     }
          //   }
          //
          //   if (hasError) break;
          // }
          //
          // restaurantProductAddController.sizeConfigs.refresh();
          // if (hasError) return;
          // ------------------------------------------------
// ✅ Step 4: Validate OPTIONS
// ------------------------------------------------
          dynamic firstErrorKey; // Track first invalid field
          hasError = false;

          for (int optionIndex = 0; optionIndex < restaurantProductAddController.sizeConfigs.length; optionIndex++) {
            final configs = restaurantProductAddController.sizeConfigs[optionIndex];

            for (int configIndex = 0; configIndex < configs.length; configIndex++) {
              final config = configs[configIndex];
              final name = config["name"].text.trim();
              final price = config["price"].text.trim();

              // Reset previous errors
              config["nameError"].value = "";
              config["priceError"].value = "";

              // Check name
              if (name.isEmpty) {
                config["nameError"].value = "Please enter title";
                if (firstErrorKey == null) firstErrorKey = config["keyName"];
                hasError = true;
              }

              // Check price
              if (price.isEmpty) {
                config["priceError"].value = "Please enter price";
                if (firstErrorKey == null) firstErrorKey = config["keyPrice"];
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


          // ------------------------------------------------
          // ✅ Step 5: Validate EXTRAS
          // ------------------------------------------------
          // for (int i = 0; i < restaurantProductAddController.extraListOfMap.length; i++) {
          //   for (int j = 0; j < restaurantProductAddController.extraListOfMap[i]['item'].length; j++) {
          //     if (restaurantProductAddController.isExtra[i] &&
          //         restaurantProductAddController.extraListOfMap[i]['item'][j]['name'].trim().isEmpty) {
          //       restaurantProductAddController.scrollToField(restaurantProductAddController.masterNameKeyList[i][j]);
          //       return;
          //     }
          //     if (restaurantProductAddController.extraListOfMap[i]['item'][j]['price'].trim().isEmpty) {
          //       restaurantProductAddController.scrollToField(restaurantProductAddController.masterPriceKeyList[i][j]);
          //       return;
          //     }
          //   }
          // }

          // ------------------------------------------------
          // ✅ Step 6: Validate ADD-ONS
          // ------------------------------------------------
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

          // ------------------------------------------------
          // print
          // restaurantProductAddController.printAddOnPayload();
          // restaurantProductAddController.printOptionsPayload();
          // restaurantProductAddController.printFullProductPayload();
          // pt(name: " ------------------>>>>>> Selected attributes",restaurantProductAddController.selectedAttributeIds.toString());

          // ------------------------------------------------

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
          );
        },
        text: "Add Menu Item",
      ),
    );
  }

  Widget status() {
    return Obx(
      () => CustomDropDownApi(
        selectedValue: restaurantProductAddController.status.value,
        items: statusItems,
        borderColor: AppColors.textFieldBorder,
        hintText: "Choose Status",
        btnHeight: 50,
        onChanged: (value) {
          restaurantProductAddController.status.value = value!;
        },
        validator: (value){
          if(restaurantProductAddController.status.value == '' || restaurantProductAddController.status.value.isEmpty){
            return "Please select status";
          }
          return null;
        },
      ),
    );
  }

  Text title({String? title}) {
    return Text(
      title ?? "",
        style: AppFontStyle.text_18_400(AppColors.lightBlackClr,fontFamily: AppFontFamily.gilroySemiBold)
    );
  }

  Column category() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() =>
          CustomDropDownApi(
            key: restaurantProductAddController.categoryKey,
            selectedValue: restaurantProductAddController.selectedCategoryId.value,
            items: restaurantProductAddController.apiCategoryData.value.categories ?? [],
            borderColor: AppColors.textFieldBorder,
            hintText: "Select Category",
            btnHeight: 50,
/*
            onChanged: (value) {
              restaurantProductAddController.selectedCategoryId.value = value!;
              restaurantProductAddController.filterAddOnsByCategory( restaurantProductAddController.selectedCategoryId.value);

              // Reset attribute list based on selected category
              restaurantProductAddController.attributeList.value =
                  restaurantProductAddController.apiCategoryData.value.categories!
                      .firstWhere((category) => category.id == restaurantProductAddController.selectedCategoryId.value);

              // -------------------------------
              // Reset all option-related data
              restaurantProductAddController.selectedOptionIndexes.clear();
              restaurantProductAddController.sizeConfigs.clear();
              restaurantProductAddController.sizeConfigs.value =
                  List.generate(restaurantProductAddController.attributeList.value.options?.length ?? 0, (_) => []);
              // -------------------------------

              // restaurantProductAddController.attributeList.value = restaurantProductAddController.apiCategoryData.value.categories!.firstWhere((category) => category.id == restaurantProductAddController.selectedCategoryId.value);
              restaurantProductAddController.indexedKey = [];
              restaurantProductAddController.masterNameControllerList.value = [];
              restaurantProductAddController.masterPriceControllerList.value = [];
              restaurantProductAddController.masterNameKeyList.value = [];
              restaurantProductAddController.masterPriceKeyList.value = [];
              // restaurantProductAddController.extraListOfMap.value = [];
              restaurantProductAddController.isExtra.value = [];
              restaurantProductAddController.increaseItemCount.value = [];
              if(restaurantProductAddController.attributeList.value.attributes != null){
                for(int  i = 0; i < restaurantProductAddController.attributeList.value.attributes!.length; i++){
                  restaurantProductAddController.indexedKey.add(GlobalKey<FormState>());
                  restaurantProductAddController.masterNameControllerList.add([]);
                  restaurantProductAddController.masterPriceControllerList.add([]);
                  restaurantProductAddController.masterNameKeyList.add([]);
                  restaurantProductAddController.masterPriceKeyList.add([]);
                  // restaurantProductAddController.extraListOfMap.add({});
                  restaurantProductAddController.isExtra.add(false);
                  restaurantProductAddController.increaseItemCount.add(0.obs);
                  // restaurantProductAddController.extraListOfMap[i]['titleid'] = restaurantProductAddController.attributeList.value.attributes?[i].id ?? '';
                  // restaurantProductAddController.extraListOfMap[i]['item'] = [];
                }
              }
            },
*/


            onChanged: (value) {
              restaurantProductAddController.selectedCategoryId.value = value!;

              // 🔹 CLEAR OLD ATTRIBUTE SELECTIONS
              restaurantProductAddController.selectedAttributeIds.clear();

              restaurantProductAddController.filterAddOnsByCategory(
                restaurantProductAddController.selectedCategoryId.value,
              );

              // Reset attribute list based on selected category
              restaurantProductAddController.attributeList.value =
                  restaurantProductAddController.apiCategoryData.value.categories!
                      .firstWhere(
                          (category) => category.id == restaurantProductAddController.selectedCategoryId.value);

              // -------------------------------
              // Reset all option-related data
              restaurantProductAddController.selectedOptionIndexes.clear();
              restaurantProductAddController.sizeConfigs.clear();
              restaurantProductAddController.sizeConfigs.value =
                  List.generate(restaurantProductAddController.attributeList.value.options?.length ?? 0, (_) => []);
              // -------------------------------

              restaurantProductAddController.indexedKey = [];
              restaurantProductAddController.masterNameControllerList.value = [];
              restaurantProductAddController.masterPriceControllerList.value = [];
              restaurantProductAddController.masterNameKeyList.value = [];
              restaurantProductAddController.masterPriceKeyList.value = [];
              restaurantProductAddController.isExtra.value = [];
              restaurantProductAddController.increaseItemCount.value = [];

              if (restaurantProductAddController.attributeList.value.attributes != null) {
                for (int i = 0;
                i < restaurantProductAddController.attributeList.value.attributes!.length;
                i++) {
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
            onMenuStateChange: (isOpen){
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
                  validator: (value){
                    if(restaurantProductAddController.selectedCuisineType.value == "" || restaurantProductAddController.selectedCuisineType.value.isEmpty){
                     // restaurantProductAddController.scrollToField(restaurantProductAddController.cuisineKey);
                      return "Please select cuisine";
                    }
                    return null;
                  },
                  onMenuStateChange: (isOpen){
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
                  validator: (value){
                    if(restaurantProductAddController.selectedMenuSection.value == "" || restaurantProductAddController.selectedMenuSection.value.isEmpty){
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
                controller: restaurantProductAddController.regularPriceController.value,
                onTap: (){

                  // restaurantProductAddController.isRedColor.value = false;
                  restaurantProductAddController.activeSalePriceValidation.value = false;
                },
                textInputType: const TextInputType.numberWithOptions(decimal: true),
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
                    sale = double.parse(restaurantProductAddController.salePriceController.value.text != '' ? restaurantProductAddController.salePriceController.value.text : "0");
                    regular = double.parse(restaurantProductAddController.regularPriceController.value.text != '' ? restaurantProductAddController.regularPriceController.value.text : "0");
                  } catch (e) {
                    debugPrint(e.toString());
                  }
                  if (sale >= regular) {
                    // if(restaurantProductAddController.isSubmit.value){
                    //   restaurantProductAddController.scrollToField(restaurantProductAddController.regularKey);
                    // }
                    return restaurantProductAddController.activeSalePriceValidation.value ? null : "Regular price must be grater than the sale price.";
                  }
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
                onTap: (){
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
                    sale = double.parse(restaurantProductAddController.salePriceController.value.text != '' ? restaurantProductAddController.salePriceController.value.text : "0");
                    regular = double.parse(restaurantProductAddController.regularPriceController.value.text != '' ? restaurantProductAddController.regularPriceController.value.text : "0");
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

  CustomTextFormField productDescription() {
    return CustomTextFormField(
      textInputAction: TextInputAction.newline,
      textInputType: TextInputType.multiline,
      key: restaurantProductAddController.descriptionKey,
      minLines: 6,
      // errorTextClr: restaurantProductAddController.isRedColor.value ? AppColors.red : AppColors.darkText,
      onTapOutside: (event) {
        // restaurantProductAddController.isRedColor.value = false;
        FocusManager.instance.primaryFocus!.unfocus();
      },
      inputFormatters: [
        LengthLimitingTextInputFormatter(200)
      ],
      onTap: (){

        // restaurantProductAddController.isRedColor.value = false;
      },
      maxLines: 8,
      controller: restaurantProductAddController.descriptionController.value,
      buildCounter: (context, {required currentLength, required isFocused, required maxLength}) {
        int actualLength = restaurantProductAddController.descriptionController.value.text.trim().length;
        return Padding(padding: const EdgeInsets.only(left: 22), child: Text('$actualLength Characters'));
      },
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          // if(restaurantProductAddController.isSubmit.value){
          //   restaurantProductAddController.scrollToField(restaurantProductAddController.descriptionKey);
          // }
          return "Please enter product description";
        }
        if (restaurantProductAddController.descriptionController.value.text.trim().length < 20) {
          // if(restaurantProductAddController.isSubmit.value){
          //   restaurantProductAddController.scrollToField(restaurantProductAddController.descriptionKey);
          // }
          return "Please enter minimum 20 character";
        }
        return null;
      },
      hintText: 'Product Description',
    );
  }

  CustomTextFormField productTitle() {
    return CustomTextFormField(
      key: restaurantProductAddController.titleKey,
      controller: restaurantProductAddController.titleController.value,
      // errorTextClr: restaurantProductAddController.isRedColor.value ? AppColors.red : AppColors.darkText,
      onTapOutside: (event) {
        // restaurantProductAddController.isRedColor.value = false;
        FocusManager.instance.primaryFocus!.unfocus();
      },
      onTap: (){

        // restaurantProductAddController.isRedColor.value = false;
      },
      validator: (value) {
        if(value == null || value.trim().isEmpty){
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
    );
  }

  CustomTextFormField preparationTime() {
    return CustomTextFormField(
      key: restaurantProductAddController.preparationKey,
      controller: restaurantProductAddController.preparationController.value,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d\-a-zA-Z]'))],
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
/*
  CustomTextFormField preparationTime() {
    return CustomTextFormField(
      key: restaurantProductAddController.preparationKey,
      controller: restaurantProductAddController.preparationController.value,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[\d\-a-zA-Z]')),
      ],
      onChanged: (value) {
        final controller = restaurantProductAddController.preparationController.value;
        String newValue = value;

        // Normalize any case variation of "min" → "Min"
        if (newValue.toLowerCase().endsWith("min")) {
          newValue = newValue.substring(0, newValue.length - 3) + "Min";
        }
        // If user hasn’t typed min yet, append it
        else if (newValue.isNotEmpty && !newValue.toLowerCase().endsWith("min")) {
          newValue = "$newValue" "Min";
        }

        // Prevent recursive update
        if (newValue != controller.text) {
          controller.text = newValue;
          controller.selection = TextSelection.fromPosition(
            TextPosition(offset: controller.text.length - 3), // keep cursor before "Min"
          );
        }
      },
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Please enter preparation time";
        }
        final pattern = RegExp(r'^\d{1,3}-\d{1,3}Min$');
        if (!pattern.hasMatch(value.trim())) {
          return "Please enter in format 15-20Min";
        }
        return null;
      },
      hintText: 'Preparation Time (e.g., 15-20Min)',
    );
  }
*/

  GetBuilder<RestaurantProductAddController> _profileImagePicker(BuildContext contexts) {
    return GetBuilder(
      init: restaurantProductAddController,
      builder: (context) {
        return Obx(()=>
          Column(
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
                    color: restaurantProductAddController.isErrorColor.value ? AppColors.red : AppColors.borderClr,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      child: Center(
                        child: Obx(
                          () => SizedBox(
                            height: Get.width * .7,
                            width: Get.width,
                            child: restaurantProductAddController.image.value != null
                                ? Image.file(
                                    restaurantProductAddController.image.value!,
                                    width: 130,
                                    height: 130,
                                    fit: BoxFit.fill,
                                  )
                                : Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
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
                                          restaurantProductAddController.pickImage(contexts).then((val)=> restaurantProductAddController.isErrorColor.value = false);
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
                  if (restaurantProductAddController.image.value !=null)
                    Positioned(
                      right: 3.w,
                      top: 5.h,
                      child: GestureDetector(
                        onTap: () {
                          if (restaurantProductAddController.image.value !=null) {
                            restaurantProductAddController.image.value = null;
                            restaurantProductAddController.imageBase64.value = '';
                          }
                        },
                        child: Icon(
                          Icons.cancel_outlined,
                          size: 25,
                          color: AppColors.red,
                        ),
                      ),
                    ),
                ],
              ),
              if(restaurantProductAddController.isErrorColor.value) ...[
                hBox(8.h),
                Text("Please select image", style: AppFontStyle.text_12_200(AppColors.red, fontFamily: AppFontFamily.gilroyMedium),),
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
      "Add Menu Item",
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
      itemCount: 4,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
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
                        child: imageFile.value != null
                            ? Image.file(
                                imageFile.value!,
                                // width: 130,
                                // height: 130,
                                fit: BoxFit.fill,
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
                    child: Icon(
                      Icons.cancel_outlined,
                      size: 25,
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
        final openedRows = restaurantProductAddController.openedAddOnRows;
        final selectedIds = restaurantProductAddController.selectedAddOnIds;
        final priceControllers = restaurantProductAddController.addOnPriceControllers;
        final availableAddOns = restaurantProductAddController.filteredAddOns;

        final allSelected = availableAddOns.length == selectedIds.length;

        // Ensure each row has unique field keys
        if (restaurantProductAddController.addOnFieldKeys.length != openedRows.length) {
          restaurantProductAddController.addOnFieldKeys.value =
              List.generate(openedRows.length, (_) {
                return {
                  "dropdownKey": GlobalKey(),
                  "priceKey": GlobalKey(),
                  "dropdownError": RxString(""),
                  "priceError": RxString(""),
                };
              });
        }

        final fieldKeys = restaurantProductAddController.addOnFieldKeys;

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
                      restaurantProductAddController.addOnFieldKeys.add({
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
                color: restaurantProductAddController.isErrorColor.value
                    ? AppColors.red
                    : AppColors.borderClr,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Column(
                        children: [
                          const Text(
                            "No add-ons added yet",
                            style: TextStyle(fontSize: 14, color: Colors.black54),
                          ),
                          SizedBox(height: 6.h),
                          CustomElevatedButton(
                            width: 120,
                            height: 40,
                            color: allSelected ? Colors.grey : AppColors.primary,
                            onPressed: () {
                              if (availableAddOns.isNotEmpty) {
                                openedRows.clear();
                                selectedIds.clear();
                                priceControllers.clear();
                                restaurantProductAddController.addOnFieldKeys.clear();

                                openedRows.add(Addons(id: '', name: ''));
                                priceControllers.add(TextEditingController());
                                restaurantProductAddController.addOnFieldKeys.add({
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

  /*
    Widget addOnList() {
      // restaurantProductAddController.addOnListOfMap.add({});
      return Obx(() =>
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
  */

  /*
            GestureDetector(
              onTap: () {
                restaurantProductAddController.isAddOn.value = !restaurantProductAddController.isAddOn.value;
                if (restaurantProductAddController.isAddOn.value) {
                  restaurantProductAddController.addOnControllersList.add(TextEditingController());
                  restaurantProductAddController.addOnControllersKeyList.add(GlobalKey());
                  restaurantProductAddController.addOnDropdownKeyList.add(GlobalKey());
                  restaurantProductAddController.addOnListOfMap.add({});
                  restaurantProductAddController.addOnItemCount.value = 1;
                  restaurantProductAddController.selectedAddOnExtra.add('');
                }
                if (!restaurantProductAddController.isAddOn.value) {
                  restaurantProductAddController.selectedAddons.value = [];
                  restaurantProductAddController.addOnListOfMap.value = [];
                  restaurantProductAddController.addOnControllersList.value = [];
                  restaurantProductAddController.addOnControllersKeyList.value = [];
                  restaurantProductAddController.addOnDropdownKeyList.value = [];
                  restaurantProductAddController.selectedAddOnExtra.value = [];
                }
              },
              child: Row(
                children: [
                  SvgPicture.asset(
                    restaurantProductAddController.isAddOn.value
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
  */

  /*

            hBox(16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    title(title: "Add-ons"),
                    Text(
                      "(Extra Items with additional cost)",
                      style: AppFontStyle.text_14_400(AppColors.greyClr,fontFamily: AppFontFamily.gilroyMedium),
                    ),
                  ],
                ),
                Icon(Icons.add,color: AppColors.primary,size: 24)
              ],
            ),
          hBox(14.h),
          SizedBox(
            width: Get.width,
            child: DottedBorder(
                strokeCap: StrokeCap.square,
                borderType: BorderType.RRect,
                radius: const Radius.circular(12),
                padding: const EdgeInsets.all(6),
                dashPattern: const [5],
                strokeWidth: 1.5,
                color: restaurantProductAddController.isErrorColor.value ? AppColors.red : AppColors.borderClr,
                child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Column(
                          children: [
                            Text("No add-ons assed yet",style: AppFontStyle.text_14_400(AppColors.lightBlackClr,fontFamily: AppFontFamily.gilroyMedium),
                            ),
                            hBox(6.h),
                            CustomElevatedButton(
                              width: 113,
                              height: 40,
                              onPressed: () {
                                restaurantProductAddController.isAddOn.value = !restaurantProductAddController.isAddOn.value;
                                if (restaurantProductAddController.isAddOn.value) {
                                  restaurantProductAddController.addOnControllersList.add(TextEditingController());
                                  restaurantProductAddController.addOnControllersKeyList.add(GlobalKey());
                                  restaurantProductAddController.addOnDropdownKeyList.add(GlobalKey());
                                  restaurantProductAddController.addOnListOfMap.add({});
                                  restaurantProductAddController.addOnItemCount.value = 1;
                                  restaurantProductAddController.selectedAddOnExtra.add('');
                                }
                                if (!restaurantProductAddController.isAddOn.value) {
                                  restaurantProductAddController.selectedAddons.value = [];
                                  restaurantProductAddController.addOnListOfMap.value = [];
                                  restaurantProductAddController.addOnControllersList.value = [];
                                  restaurantProductAddController.addOnControllersKeyList.value = [];
                                  restaurantProductAddController.addOnDropdownKeyList.value = [];
                                  restaurantProductAddController.selectedAddOnExtra.value = [];
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
          ),
            if (restaurantProductAddController.isAddOn.value) ...[
              Obx(() =>
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: restaurantProductAddController.addOnItemCount.value,
                  itemBuilder: (BuildContext context, index) {
                    // restaurantProductAddController.selectedAddOnExtra.add(restaurantProductAddController.apiAddOnData.value.addons![0].id ?? '');
                    // restaurantProductAddController.addOnListOfMap[index]["id"] = restaurantProductAddController.selectedAddOnExtra[index];
                    return Column(
                      children: [
                        Obx(() =>
                          CustomDropDownApi(
                            key: restaurantProductAddController.addOnDropdownKeyList[index],
                            selectedValue: restaurantProductAddController.selectedAddOnExtra[index],
                            items: restaurantProductAddController.apiAddOnData.value.addons ?? [],
                            borderColor: AppColors.textFieldBorder,
                            hintText: "Choose Addon",
                            btnHeight: 50,
                            onChanged: (value) {

                              if (value != null) {
                                restaurantProductAddController.selectedAddons.add(value);
                                restaurantProductAddController.selectedAddons.remove(restaurantProductAddController.selectedAddOnExtra[index]);
                                restaurantProductAddController.selectedAddOnExtra[index] = value;
                                restaurantProductAddController.addOnListOfMap[index]["id"] = value;
                              }
                            },
                            selectedValues: restaurantProductAddController.selectedAddons,
                            // errorTextClr: restaurantProductAddController.isRedColor.value ? AppColors.red : AppColors.darkText,
                            onMenuStateChange: (isOpen){
                              // restaurantProductAddController.isRedColor.value = false;
                              restaurantProductAddController.isDropdownOpen.value = isOpen;
                            },
                            validator: (value) {
                              if (restaurantProductAddController.selectedAddOnExtra[index] == '' || restaurantProductAddController.selectedAddOnExtra[index].isEmpty) {

                                return "Please choose addon";
                              }
                              return null;
                            },
                          ),
                        ),
                        hBox(12.h),
                        CustomTextFormField(
                          key: restaurantProductAddController.addOnControllersKeyList[index],
                          controller: restaurantProductAddController.addOnControllersList[index],
                          onChanged: (value) {
                            restaurantProductAddController.addOnListOfMap[index]["price"] = value;
                            log(restaurantProductAddController.addOnListOfMap.where((map) => map.isNotEmpty).toList().toString(), name: "non blank");
                          },
                          textInputType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            // FilteringTextInputFormatter.digitsOnly,
                            DecimalTextInputFormatter(),
                            LengthLimitingTextInputFormatter(6),
                          ],
                          // errorTextClr: restaurantProductAddController.isRedColor.value ? AppColors.red : AppColors.darkText,
                          onTapOutside: (event) {
                            // restaurantProductAddController.isRedColor.value = false;
                            FocusManager.instance.primaryFocus!.unfocus();
                          },
                          onTap: (){

                            // restaurantProductAddController.isRedColor.value = false;
                          },
                          hintText: 'Price',
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Please enter price";
                            }
                            if (!isValidNumberFormat(value)) {
                              return "Please enter a valid amount";
                            }
                            return null;
                          },
                        ),
                        hBox(8.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if(restaurantProductAddController.addOnItemCount.value > 1) ...[
                              GestureDetector(
                                onTap: () {
                                  restaurantProductAddController.selectedAddons.remove(restaurantProductAddController.selectedAddOnExtra[index]);
                                  restaurantProductAddController.addOnControllersList.removeAt(index);
                                  restaurantProductAddController.addOnControllersKeyList.removeAt(index);
                                  restaurantProductAddController.addOnDropdownKeyList.removeAt(index);
                                  restaurantProductAddController.selectedAddOnExtra.removeAt(index);
                                  restaurantProductAddController.addOnItemCount.value--;
                                  restaurantProductAddController.addOnListOfMap.removeAt(index);
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      CupertinoIcons.minus,
                                      color: AppColors.red,
                                      size: 20.sp,
                                    ),
                                    Text(
                                      " Remove",
                                      style: AppFontStyle.text_16_400(AppColors.red,
                                          fontFamily: AppFontFamily.gilroyMedium),
                                    )
                                  ],
                                ),
                              ),
                            ],
                            const Spacer(),
                            if(index == (restaurantProductAddController.addOnItemCount.value -1)) ...[
                              GestureDetector(
                                onTap: () {
                                  if (restaurantProductAddController.addOnButtonKey.currentState!.validate()) {
                                    restaurantProductAddController.addOnItemCount.value++;
                                    restaurantProductAddController.selectedAddOnExtra.add('');
                                    restaurantProductAddController.addOnControllersList.add(TextEditingController());
                                    restaurantProductAddController.addOnControllersKeyList.add(GlobalKey());
                                    restaurantProductAddController.addOnDropdownKeyList.add(GlobalKey());
                                    restaurantProductAddController.addOnListOfMap.add({});
                                  }
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.add,
                                      color: AppColors.primary,
                                      size: 20.sp,
                                    ),
                                    Text(
                                      " Add More",
                                      style: AppFontStyle.text_16_400(AppColors.primary,
                                          fontFamily: AppFontFamily.gilroyMedium),
                                    )
                                  ],
                                ),
                              ),
                            ],

                          ],
                        ),
                        hBox(20.h),
                      ],
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      );
    }
  */

  /*Widget customAttributeListGenerator() {
    return Obx(() =>
      ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: restaurantProductAddController.attributeList.value.attributes?.length ?? 0,
        itemBuilder: (BuildContext context, index) {
          return customAttributeWidgetList(
            restaurantProductAddController.attributeList.value.attributes?[index].name ?? '',
            restaurantProductAddController.attributeList.value.attributes?[index].id ?? '',
            index,
            restaurantProductAddController.masterNameControllerList[index],
            restaurantProductAddController.masterPriceControllerList[index],
            restaurantProductAddController.masterNameKeyList[index],
            restaurantProductAddController.masterPriceKeyList[index],
          );
        },
      ),
    );
  }

  Widget customAttributeWidgetList(String attributeName, String attributeId, int extraIndex, List<TextEditingController> subNameList, List<TextEditingController> subPriceList, List<GlobalKey> subNameKeyList,List<GlobalKey> subPriceKeyList ) {
    return Form(
      key: restaurantProductAddController.indexedKey[extraIndex],
      child: Obx(() =>
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {

                  restaurantProductAddController.isExtra[extraIndex] = !restaurantProductAddController.isExtra[extraIndex];

                  if(restaurantProductAddController.isExtra[extraIndex]){
                    restaurantProductAddController.extraListOfMap[extraIndex]['item'].add({
                      "id": restaurantProductAddController.increaseItemCount[extraIndex].value + 1,
                      "name": '',
                      "price": ''
                    });
                    subNameList.add(TextEditingController());
                    subPriceList.add(TextEditingController());
                    subNameKeyList.add(GlobalKey());
                    subPriceKeyList.add(GlobalKey());
                    restaurantProductAddController.increaseItemCount[extraIndex].value = 1;
                  }
                  if(!restaurantProductAddController.isExtra[extraIndex]){
                    subPriceList = [];
                    subNameList = [];
                    subNameKeyList = [];
                    subPriceKeyList = [];
                    restaurantProductAddController.extraListOfMap[extraIndex]['item'] = [];
                  }

              },
              child: Row(
                children: [
                  SvgPicture.asset(
                    restaurantProductAddController.isExtra[extraIndex]
                        ? ImageConstants.checkCircle
                        : ImageConstants.circle,
                    height: 22,
                    width: 22,
                  ),
                  wBox(8.w),
                  title(title: attributeName),
                ],
              ),
            ),
            hBox(24.h),
            if (restaurantProductAddController.isExtra[extraIndex]) ...[
              Obx(() =>
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: restaurantProductAddController.increaseItemCount[extraIndex].value,
                  itemBuilder: (BuildContext context, index) {
                    return Column(
                      children: [
                        CustomTextFormField(
                          key: subNameKeyList[index],
                          controller: subNameList[index],
                          // errorTextClr: restaurantProductAddController.isRedColor.value ? AppColors.red : AppColors.darkText,
                          onTapOutside: (event) {
                            // restaurantProductAddController.isRedColor.value = false;
                            FocusManager.instance.primaryFocus!.unfocus();
                          },
                          onTap: (){

                            // restaurantProductAddController.isRedColor.value = false;
                          },
                          onChanged: (value) {
                            restaurantProductAddController.extraListOfMap[extraIndex]['item'][index]['name'] = value;
                          },
                          hintText: attributeName,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              // if(restaurantProductAddController.isSubmit.value){
                              //   restaurantProductAddController.scrollToField(subNameKeyList[index]);
                              // }
                              return "Please enter $attributeName";
                            }
                            if (!isValidCharacters(value)) {
                              // if(restaurantProductAddController.isSubmit.value){
                              //   restaurantProductAddController.scrollToField(subNameKeyList[index]);
                              // }
                              return "Please enter a valid character";
                            }
                            return null;
                          },
                        ),
                        hBox(12.h),
                        CustomTextFormField(
                          key: subPriceKeyList[index],
                          controller: subPriceList[index],
                          // errorTextClr: restaurantProductAddController.isRedColor.value ? AppColors.red : AppColors.darkText,
                          onTapOutside: (event) {
                            // restaurantProductAddController.isRedColor.value = false;
                            FocusManager.instance.primaryFocus!.unfocus();
                          },
                          onTap: (){

                            // restaurantProductAddController.isRedColor.value = false;
                          },
                          onChanged: (value) {
                            restaurantProductAddController.extraListOfMap[extraIndex]['item'][index]['price'] = value;
                            log(restaurantProductAddController.extraListOfMap.where((map) => map.isNotEmpty && (map['item'] as List).isNotEmpty).toList().toString(), name: "meMap");
                          },
                          textInputType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            // FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(6),
                            DecimalTextInputFormatter(),
                          ],
                          hintText: 'Price',
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              // if(restaurantProductAddController.isSubmit.value){
                              //   restaurantProductAddController.scrollToField(subPriceKeyList[index]);
                              // }
                              return "Please enter price";
                            }
                            double price = 0;
                            try {
                              price = double.parse(value);
                            } catch (e) {
                              debugPrint(e.toString());
                            }
                            if (price <= 0) {
                              // if(restaurantProductAddController.isSubmit.value){
                              //   restaurantProductAddController.scrollToField(subPriceKeyList[index]);
                              // }
                              return "Price must be grater than zero";
                            }
                            if (!isValidNumberFormat(value)) {
                              // if(restaurantProductAddController.isSubmit.value){
                              //   restaurantProductAddController.scrollToField(subPriceKeyList[index]);
                              // }
                              return "Please enter a valid amount";
                            }
                            return null;
                          },
                        ),
                        hBox(8.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if(restaurantProductAddController.increaseItemCount[extraIndex].value >1) ...[
                              GestureDetector(
                                onTap: () {
                                  restaurantProductAddController.increaseItemCount[extraIndex].value--;
                                  subPriceList.removeAt(index);
                                  subNameList.removeAt(index);
                                  subNameKeyList.removeAt(index);
                                  subPriceKeyList.removeAt(index);
                                  restaurantProductAddController.extraListOfMap[extraIndex]['item'].removeAt(index);

                                  log(restaurantProductAddController.extraListOfMap.where((map) => map.isNotEmpty && (map['item'] as List).isNotEmpty).toList().toString(),name: "remove map");
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      CupertinoIcons.minus,
                                      color: AppColors.red,
                                      size: 20.sp,
                                    ),
                                    Text(
                                      " Remove",
                                      style: AppFontStyle.text_15_400(AppColors.red,
                                          fontFamily: AppFontFamily.gilroyMedium),
                                    )
                                  ],
                                ),
                              ),
                            ],
                            const Spacer(),
                            if(index == (restaurantProductAddController.increaseItemCount[extraIndex].value -1)) ...[
                              GestureDetector(
                                onTap: () {
                                    if (restaurantProductAddController.indexedKey[extraIndex].currentState!.validate()) {
                                      restaurantProductAddController.extraListOfMap[extraIndex]['item'].add({
                                        "id": restaurantProductAddController.increaseItemCount[extraIndex].value + 1,
                                        "name": '',
                                        "price": ''
                                      });
                                      subNameList.add(TextEditingController());
                                      subPriceList.add(TextEditingController());
                                      subNameKeyList.add(GlobalKey());
                                      subPriceKeyList.add(GlobalKey());
                                      restaurantProductAddController.increaseItemCount[extraIndex].value++;
                                    }

                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.add,
                                      color: AppColors.primary,
                                      size: 20.sp,
                                    ),
                                    Text(
                                      " Add More",
                                      style: AppFontStyle.text_15_400(AppColors.primary,
                                          fontFamily: AppFontFamily.gilroyMedium),
                                    )
                                  ],
                                ),
                              ),
                            ]
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }*/
}