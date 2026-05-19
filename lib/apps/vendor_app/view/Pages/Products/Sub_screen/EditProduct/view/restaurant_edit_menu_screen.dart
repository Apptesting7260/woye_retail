import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/Products/Sub_screen/EditProduct/controller/vendor_edit_menu_controller.dart';
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
import '../../../../../../../../shared/widgets/vendor_widgets/custom_dropdown.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/custom_dropdown_api.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/custom_elevated_button.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/custom_text_form_field.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/print.dart';

class RestaurantEditProductScreen extends StatelessWidget {
  RestaurantEditProductScreen({super.key});

  final VendorEditMenuController restaurantProductEditController = Get.put(VendorEditMenuController());

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
            body: Obx(
                  () {
                switch (restaurantProductEditController.rxRequestCategoryStatus.value) {
                  case ApiStatus.LOADING:
                    return Center(child: circularProgressIndicator());
                  case ApiStatus.ERROR:
                    if (restaurantProductEditController.error.value == 'No internet') {
                      return InternetExceptionWidget(
                        onPress: () {
                          restaurantProductEditController.getSingleProductApi(
                              productId: restaurantProductEditController.productId.value);
                        },
                      );
                    } else {
                      return GeneralExceptionWidget(
                        onPress: () {
                          restaurantProductEditController.getSingleProductApi(
                              productId: restaurantProductEditController.productId.value);
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
                            child: Obx(() =>
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
                                      hBox(14.h),
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
            color: AppColors.white,
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
                if ((restaurantProductEditController.publishButtonKey.currentState?.validate() ?? false) &&
                    (restaurantProductEditController.mainUrlImage.value != '' || restaurantProductEditController.imageBase64.value != '')
                    /* && (restaurantProductEditController.addOnButtonKey.currentState?.validate() ?? false)*/ && isAllValidate) {
                  restaurantProductEditController.buildOptionsJson();
                  // restaurantProductEditController.buildAddonsPayload();
                  pt("selected Attributes-------------------------------> ${restaurantProductEditController.selectedAttributeIds}");

                  restaurantProductEditController.editProductApi(/*dataForSubmit*/);
                }
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

                    return restaurantProductEditController
                        .activeSalePriceValidation.value
                        ? null
                        : "Regular price must\nbe grater than the\nsale price.";
                  }
                  if (regular <= 0) {

                    return "Amount 0 not\nacceptable";
                  }
                  if (!isValidNumberFormat(value)) {

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
                controller: TextEditingController(
                    text: restaurantProductEditController
                        .apiSingleProductData.value.product?.salePrice ??
                        ''),
                textInputType: const TextInputType.numberWithOptions(decimal: true),
                onTap: () {
                  restaurantProductEditController.activeSalePriceValidation
                      .value = true;
                },
                onChanged: (value) {
                  restaurantProductEditController
                      .apiSingleProductData.value.product?.salePrice = value;
                },
                inputFormatters: [
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

                    return "Amount 0 not\nacceptable";
                  }
                  if (sale >= regular) {
                    return restaurantProductEditController
                        .activeSalePriceValidation.value
                        ? "sale price must be\nless than the\nRegular price."
                        : null;
                  }
                  if (value != null && value != '' &&
                      !isValidNumberFormat(value)) {
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
          return "Please enter product description";
        }
        if (value.trim().length < 20) {
          return "Please enter minimum 20 character";
        }
        return null;
      },
      hintText: 'Product Description',
    );
  }


  CustomTextFormField productTitle() {
    return CustomTextFormField(
      key: restaurantProductEditController.titleKey,
      labelText: "Title",
      onTap: () {
      },
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

          return "Please enter product title";
        }
        if (!isValidCharacters(value)) {

          return "Please enter a valid character";
        }
        return null;
      },
      hintText: 'Product Title',
    );
  }

  GetBuilder<VendorEditMenuController> _profileImagePicker(BuildContext contexts) {
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
                      AppColors.red, fontFamily: AppFontFamily.gilroyMedium)),
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
          "Edit Store Item",
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
}
