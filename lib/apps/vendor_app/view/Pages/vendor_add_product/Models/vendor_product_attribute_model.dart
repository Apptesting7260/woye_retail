class VendorProductAttributeModel {
  bool? status;
  List<Attributes>? attributes;
  List<AdditionalDetails>? additionalDetails;

  VendorProductAttributeModel(
      {this.status, this.attributes, this.additionalDetails});

  VendorProductAttributeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['attributes'] != null) {
      attributes = <Attributes>[];
      json['attributes'].forEach((v) {
        attributes!.add(new Attributes.fromJson(v));
      });
    }
    if (json['additionalDetails'] != null) {
      additionalDetails = <AdditionalDetails>[];
      json['additionalDetails'].forEach((v) {
        additionalDetails!.add(new AdditionalDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.attributes != null) {
      data['attributes'] = this.attributes!.map((v) => v.toJson()).toList();
    }
    if (this.additionalDetails != null) {
      data['additionalDetails'] =
          this.additionalDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Attributes {
  String? id;
  String? name;
  String? attrValues;
  String? isCommon;
  String? department;
  String? category;
  String? subCategory;
  String? status;
  String? isDeleted;
  String? createdAt;
  String? updatedAt;
  List<String>? separateAttrValues;

  Attributes(
      {this.id,
        this.name,
        this.attrValues,
        this.isCommon,
        this.department,
        this.category,
        this.subCategory,
        this.status,
        this.isDeleted,
        this.createdAt,
        this.updatedAt,
        this.separateAttrValues});

  Attributes.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    name = json['name']?.toString();
    attrValues = json['attr_values']?.toString();
    isCommon = json['is_common']?.toString();
    department = json['department']?.toString();
    category = json['category']?.toString();
    subCategory = json['sub_category']?.toString();
    status = json['status']?.toString();
    isDeleted = json['is_deleted']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    separateAttrValues = json['separate_attr_values'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['attr_values'] = this.attrValues;
    data['is_common'] = this.isCommon;
    data['department'] = this.department;
    data['category'] = this.category;
    data['sub_category'] = this.subCategory;
    data['status'] = this.status;
    data['is_deleted'] = this.isDeleted;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['separate_attr_values'] = this.separateAttrValues;
    return data;
  }
}

class AdditionalDetails {
  String? id;
  String? department;
  String? category;
  String? subCategory;
  String? slug;
  String? title;
  String? placeholder;
  String? status;
  String? isDeleted;
  String? createdAt;
  String? updatedAt;

  AdditionalDetails(
      {this.id,
        this.department,
        this.category,
        this.subCategory,
        this.slug,
        this.title,
        this.placeholder,
        this.status,
        this.isDeleted,
        this.createdAt,
        this.updatedAt});

  AdditionalDetails.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    department = json['department']?.toString();
    category = json['category']?.toString();
    subCategory = json['sub_category']?.toString();
    slug = json['slug']?.toString();
    title = json['title']?.toString();
    placeholder = json['placeholder']?.toString();
    status = json['status']?.toString();
    isDeleted = json['is_deleted']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['department'] = this.department;
    data['category'] = this.category;
    data['sub_category'] = this.subCategory;
    data['slug'] = this.slug;
    data['title'] = this.title;
    data['placeholder'] = this.placeholder;
    data['status'] = this.status;
    data['is_deleted'] = this.isDeleted;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
// Widget additionalDetailsSection() {
//
//   return Column(
//     children: [
//       Divider(color: AppColors.greyTextColor.withAlpha(70)),
//       hBox(10.h),
//       Center(
//         child: Text(
//           "Electronics - Computers Additional Details",style: AppFontStyle.text_12_500(
//           AppColors.blueLightColor, fontFamily: AppFontFamily.interSemiBold)),
//       ),
//       hBox(20.h),
//       Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "${restaurantProductAddController}",  style: AppFontStyle.text_14_500(AppColors.lightBlackClr, fontFamily: AppFontFamily.interMedium)),
//                 hBox(5.h),
//                 CustomTextFormField(
//                   key: restaurantProductAddController.brandKey,
//                   controller: restaurantProductAddController.brandController.value,
//                   textInputType: TextInputType.text,
//                   inputFormatters: [
//                     LengthLimitingTextInputFormatter(20),
//                   ],
//                   onTapOutside: (event) {
//                     FocusManager.instance.primaryFocus?.unfocus();
//                   },
//                   hintText: 'eg, Apple, Dell',
//                 ),
//               ],
//             ),
//           ),
//           wBox(12.w),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "Model Number",style: AppFontStyle.text_14_500(AppColors.lightBlackClr, fontFamily: AppFontFamily.interMedium)),
//                 hBox(5.h),
//                 CustomTextFormField(
//                   key: restaurantProductAddController.modelNoKey,
//                   controller: restaurantProductAddController.modelController.value,
//                   textInputType: TextInputType.text,
//                   inputFormatters: [
//                     LengthLimitingTextInputFormatter(20),
//                   ],
//                   onTapOutside: (event) {
//                     FocusManager.instance.primaryFocus?.unfocus();
//                   },
//                   hintText: 'Model number',
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       hBox(12.h),
//       Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "Screen Size",
//                   style: AppFontStyle.text_14_500(
//                     AppColors.lightBlackClr,
//                     fontFamily: AppFontFamily.interMedium,
//                   ),
//                 ),
//                 hBox(5.h),
//                 CustomTextFormField(
//                   key: restaurantProductAddController.screenSizeKey,
//                   controller: restaurantProductAddController.screenSizeController.value,
//                   textInputType: TextInputType.text,
//                   inputFormatters: [
//                     LengthLimitingTextInputFormatter(20),
//                   ],
//                   onTapOutside: (event) {
//                     FocusManager.instance.primaryFocus?.unfocus();
//                   },
//                   hintText: 'eg, 13, 15.5',
//                 ),
//               ],
//             ),
//           ),
//           wBox(12.w),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text("Storage", style: AppFontStyle.text_14_500(AppColors.lightBlackClr, fontFamily: AppFontFamily.interMedium)),
//                 hBox(5.h),
//                 CustomTextFormField(
//                   key: restaurantProductAddController.storageKey,
//                   controller: restaurantProductAddController.storageController.value,
//                   textInputType: TextInputType.text,
//                   inputFormatters: [
//                     LengthLimitingTextInputFormatter(20),
//                   ],
//                   onTapOutside: (event) {
//                     FocusManager.instance.primaryFocus?.unfocus();
//                   },
//                   hintText: 'eg, 256GB, 1TB',
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       hBox(12.h),
//       Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "Processor", style: AppFontStyle.text_14_500(AppColors.lightBlackClr, fontFamily: AppFontFamily.interMedium)),
//                 hBox(5.h),
//                 CustomTextFormField(
//                   key: restaurantProductAddController.processorKey,
//                   controller: restaurantProductAddController.processorController.value,
//                   textInputType: TextInputType.text,
//                   inputFormatters: [
//                     LengthLimitingTextInputFormatter(20),
//                   ],
//                   onTapOutside: (event) {
//                     FocusManager.instance.primaryFocus?.unfocus();
//                   },
//                   hintText: 'eg, Intel i5, Apple M1',
//                 ),
//               ],
//             ),
//           ),
//           wBox(12.w),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text("Ram", style: AppFontStyle.text_14_500(AppColors.lightBlackClr, fontFamily: AppFontFamily.interMedium)),
//                 hBox(5.h),
//                 CustomTextFormField(
//                   key: restaurantProductAddController.ramKey,
//                   controller: restaurantProductAddController.ramController.value,
//                   textInputType: TextInputType.text,
//                   inputFormatters: [
//                     LengthLimitingTextInputFormatter(20),
//                   ],
//                   onTapOutside: (event) {
//                     FocusManager.instance.primaryFocus?.unfocus();
//                   },
//                   hintText: 'eg, 8GB, 16GB',
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       hBox(12.h),
//       Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text("Warranty Period", style: AppFontStyle.text_14_500(AppColors.lightBlackClr,fontFamily: AppFontFamily.interMedium)),
//                 hBox(5.h),
//                 CustomTextFormField(
//                   key: restaurantProductAddController.warrantyKey,
//                   controller: restaurantProductAddController.warrantController.value,
//                   textInputType: TextInputType.text,
//                   inputFormatters: [
//                     LengthLimitingTextInputFormatter(20),
//                   ],
//                   onTapOutside: (event) {
//                     FocusManager.instance.primaryFocus?.unfocus();
//                   },
//                   hintText: 'eg, 1 Year, 2 Years',
//                 ),
//               ],
//             ),
//           ),
//           wBox(12.w),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text("Color", style: AppFontStyle.text_14_500(AppColors.lightBlackClr, fontFamily: AppFontFamily.interMedium)),
//                 hBox(5.h),
//                 CustomTextFormField(
//                   key: restaurantProductAddController.colorKey,
//                   controller: restaurantProductAddController.colorController.value,
//                   textInputType: TextInputType.text,
//                   inputFormatters: [
//                     LengthLimitingTextInputFormatter(20),
//                   ],
//                   onTapOutside: (event) {
//                     FocusManager.instance.primaryFocus?.unfocus();
//                   },
//                   hintText: 'eg, Black, White',
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       hBox(12.h),
//     ],
//   );
// }

//
// Future<void> restaurantAddProductApi({
//   required String productTitle,
//   // required String skuTitle,
//   required String categoryId,
//   required String status,
//   required String regularPrice,
//   required String description,
//   // required String cuisineType,
//   required String mainImage,
//   required String image0,
//   required String image1,
//   required String image2,
//   required String image3,
//   required String image4,
//   required String image5,
//
// }) async {
//   final addOns = buildAddOnPayload();
//   // final options = getOptionsPayload();
//
//   var data = {
//     "title": productTitle,
//     "category_id": categoryId,
//     "regular_price": regularPrice,
//     "description": description,
//     "status": status,
//     "stock_unit": formatToSnakeCase(selectedStockSection.value.toLowerCase()),
//     "preparation_time": preparationController.value.text,
//     if (addOns.isNotEmpty) "addons": addOns,
//     // if (options.isNotEmpty) "options": options,
//     if (selectedAttributeIds
//         .isNotEmpty)"product_attributes": selectedAttributeIds,
//     "image": mainImage,
//     "addimg1": image0,
//     "addimg2": image1,
//     "addimg3": image2,
//     "addimg4": image3,
//     "addimg5": image4,
//     "addimg6": image5,
//   };
//
//   debugPrint("📦 API DATA BODY => ${jsonEncode(data)}");
//
//   setRxRequestStatus(ApiStatus.LOADING);
//
//   await api.restaurantAddProductApi(jsonEncode(data)).then((value) {
//     addProductSet(value);
//     if (apiData.value.status == true) {
//       // restaurantProductController.productApi();
//       restaurantDashboardController.dashboardApi();
//       setRxRequestStatus(ApiStatus.COMPLETED);
//       Get.back(result: true);
//       Utils.showToast(apiData.value.message ?? "Something went wrong!");
//     } else {
//       setError(error.toString());
//       setRxRequestStatus(ApiStatus.ERROR);
//       Utils.showToast(
//         apiData.value.errors?.first ?? "Something went wrong!",);
//     }
//   }).onError((error, stackError) {
//     setError(error.toString());
//     Utils.showToast(apiData.value.message.toString());
//     log(error.toString(), name: "add product error");
//     setRxRequestStatus(ApiStatus.ERROR);
//   });
// }

// CustomElevatedButton(
//     borderRadius: BorderRadius.circular(8.r),
//     height: 45.h,
//     width: 150.w,
//     isLoading: restaurantProductAddController.rxRequestStatus.value == ApiStatus.LOADING,
//     onPressed: () async {
//       bool hasError = false;
//
//       restaurantProductAddController.publishButtonKey.currentState?.validate();
//       restaurantProductAddController.addOnButtonKey.currentState?.validate();
//
//       bool isAllValidate = true;
//       for (GlobalKey<FormState> key in restaurantProductAddController.indexedKey) {
//         if (!(key.currentState?.validate() ?? false)) {
//           isAllValidate = false;
//         }
//       }
//
//       // ------------------------------------------------
//       // ✅ Step 3: Validate Image + Basic Details
//       // ------------------------------------------------
//       if (restaurantProductAddController.imageBase64.value.isEmpty) {
//         restaurantProductAddController.isErrorColor.value = true;
//         restaurantProductAddController.scrollToTop(0);
//         return;
//       }
//
//       if (restaurantProductAddController.titleController.value.text.trim().isEmpty ||
//           !isValidCharacters(restaurantProductAddController.titleController.value.text)) {
//         restaurantProductAddController.scrollToField(restaurantProductAddController.titleKey);
//         return;
//       }
//
//       if (restaurantProductAddController.selectedCategoryId.value.trim().isEmpty) {
//         restaurantProductAddController.scrollToField(restaurantProductAddController.categoryKey);
//         return;
//       }
//
//       // if (restaurantProductAddController.selectedCuisineType.value.trim().isEmpty) {
//       //   restaurantProductAddController.scrollToField(restaurantProductAddController.cuisineKey);
//       //   return;
//       // }
//
//       if (restaurantProductAddController.selectedStockSection.value.trim().isEmpty) {
//         restaurantProductAddController.scrollToField(restaurantProductAddController.stockSectionKey);
//         return;
//       }
//
//       if (restaurantProductAddController.regularPriceController.value.text.trim().isEmpty ||
//           !isValidCharacters(restaurantProductAddController.regularPriceController.value.text) ||
//           ((double.tryParse(restaurantProductAddController.salePriceController.value.text.trim()) ?? 0) >=
//               (double.tryParse(restaurantProductAddController.regularPriceController.value.text.trim()) ?? 0)) ||
//           ((double.tryParse(restaurantProductAddController.regularPriceController.value.text.trim()) ?? 0) <= 0)) {
//         restaurantProductAddController.scrollToField(restaurantProductAddController.regularKey);
//         return;
//       }
//
//       if (restaurantProductAddController.preparationController.value.text.trim().isEmpty ||
//           !RegExp(r'^\d{1,3}-\d{1,3}(min|hr|hrs)$', caseSensitive: false).hasMatch(restaurantProductAddController
//               .preparationController.value.text.trim())) {
//         restaurantProductAddController.scrollToField(restaurantProductAddController.preparationKey, allignment: 0.02);
//         return;
//       }
//
//       if (restaurantProductAddController.descriptionController.value.text.trim().isEmpty ||
//           restaurantProductAddController.descriptionController.value.text.length < 20) {
//         restaurantProductAddController.scrollToField(restaurantProductAddController.descriptionKey);
//         return;
//       }
//
//       dynamic firstErrorKey; // Track first invalid field
//       hasError = false;
//
//       for (int optionIndex = 0; optionIndex < restaurantProductAddController.sizeConfigs.length; optionIndex++) {
//         final configs = restaurantProductAddController.sizeConfigs[optionIndex];
//         for (int configIndex = 0;
//             configIndex < configs.length;
//             configIndex++) {
//           final config = configs[configIndex];
//           final name = config["name"].text.trim();
//           final price = config["price"].text.trim();
//
//           // Reset previous errors
//           config["nameError"].value = "";
//           config["priceError"].value = "";
//
//           // Check name
//           if (name.isEmpty) {
//             config["nameError"].value = "Please enter title";
//             firstErrorKey ??= config["keyName"];
//             hasError = true;
//           }
//
//           // Check price
//           if (price.isEmpty) {
//             config["priceError"].value = "Please enter price";
//             firstErrorKey ??= config["keyPrice"];
//             hasError = true;
//           }
//         }
//       }
//
//       restaurantProductAddController.sizeConfigs.refresh();
//
//       if (hasError && firstErrorKey != null) {
//         restaurantProductAddController.scrollToField(firstErrorKey);
//         return;
//       }
//
//       final formState = restaurantProductAddController.addOnFormKey.currentState;
//
//       if (formState == null || !formState.validate()) {
//         for (int i = 0; i < restaurantProductAddController.addOnFieldKeys.length; i++) {
//           final fieldMap = restaurantProductAddController.addOnFieldKeys[i];
//           final dropdownKey = fieldMap["dropdownKey"] as GlobalKey?;
//           final priceKey = fieldMap["priceKey"] as GlobalKey?;
//           final dropdownError = fieldMap["dropdownError"] as RxString;
//           final priceError = fieldMap["priceError"] as RxString;
//
//           final priceController = restaurantProductAddController.addOnPriceControllers[i];
//           final selectedIds = restaurantProductAddController.selectedAddOnIds;
//
//           dropdownError.value = "";
//           priceError.value = "";
//
//           if (selectedIds.length <= i || selectedIds[i].isEmpty) {
//             dropdownError.value = "Please select add-on";
//             restaurantProductAddController.scrollToField(dropdownKey!);
//             hasError = true;
//             break;
//           }
//
//           if (priceController.text.trim().isEmpty) {
//             priceError.value = "Please enter price";
//             restaurantProductAddController.scrollToField(priceKey!);
//             hasError = true;
//             break;
//           }
//         }
//
//         restaurantProductAddController.addOnFieldKeys.refresh();
//       }
//
//       if (hasError) return;
//       // ------------------------------------------------
//       // ✅ Step 7: If All Valid — Call API
//       // ------------------------------------------------
//       await restaurantProductAddController.restaurantAddProductApi(
//         productTitle: restaurantProductAddController.titleController.value.text,
//         categoryId: restaurantProductAddController.selectedCategoryId.value,
//         status: restaurantProductAddController.status.value == "1" ? "active" : "inActive",
//         regularPrice: restaurantProductAddController.regularPriceController.value.text,
//         description: restaurantProductAddController.descriptionController.value.text,
//         // cuisineType: restaurantProductAddController.selectedCuisineType.value,
//         mainImage: restaurantProductAddController.imageBase64.value,
//         image0: restaurantProductAddController.additionalImageBase64[0].value,
//         image1: restaurantProductAddController.additionalImageBase64[1].value,
//         image2: restaurantProductAddController.additionalImageBase64[2].value,
//         image3: restaurantProductAddController.additionalImageBase64[3].value,
//         image4: restaurantProductAddController.additionalImageBase64[4].value,
//         image5: restaurantProductAddController.additionalImageBase64[5].value,
//       );
//     },
//     text: "Save Product", textStyle: AppFontStyle.text_16_400(AppColors.white, fontFamily: AppFontFamily.interMedium)),