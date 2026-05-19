import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gyaawa/shared/widgets/vendor_widgets/app_container.dart';
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
import '../../../../../vendor_common/Models/common_get_category_model.dart';
import '../../../../ChooseVendorCategories/model/vendor_category_model.dart';
import '../controller/vendor_edit_menu_controller.dart';

class RestaurantEditProductScreen extends StatelessWidget {
  RestaurantEditProductScreen({super.key});

  final VendorEditMenuController c = Get.put(VendorEditMenuController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Container(
        color: AppColors.backgroundClr,
        child: Scaffold(
          appBar: CustomAppBar(
            title: Text('Edit Product',
                style: AppFontStyle.text_22_400(AppColors.darkText,
                    fontFamily: AppFontFamily.gilroySemiBold)),
          ),
          body: Obx(() {
            switch (c.rxRequestCategoryStatus.value) {
              case ApiStatus.LOADING:
                return Center(child: circularProgressIndicator());
              case ApiStatus.ERROR:
                return c.error.value == 'No internet'
                    ? InternetExceptionWidget(
                        onPress: () =>
                            c.getSingleProductApi(productId: c.productId.value))
                    : GeneralExceptionWidget(
                        onPress: () =>
                            c.getSingleProductApi(productId: c.productId.value));
              case ApiStatus.COMPLETED:
                return SingleChildScrollView(
                  controller: c.scrollController,
                  child: Padding(
                    padding: REdgeInsets.symmetric(horizontal: 24.0),
                    child: Form(
                      key: c.publishButtonKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          hBox(8.h),
                          _profileImagePicker(context),
                          hBox(20.h),
                          _additionalImages(),
                          hBox(20.h),
                          _productTitle(),
                          hBox(12.h),
                          _productDescription(),
                          hBox(12.h),
                          _regularPriceAndPromoCode(),
                          hBox(12.h),
                          _statusAndOtherFields(),
                          hBox(12.h),
                          _additionalDetailsSection(),
                          hBox(4.h),
                          _variantSection(),
                          hBox(10.h),
                          _publishButton(),
                          hBox(20.h),
                        ],
                      ),
                    ),
                  ),
                );
            }
          }),
        ),
      ),
    );
  }

  Widget _profileImagePicker(BuildContext context) {
    return GetBuilder<VendorEditMenuController>(
      init: c,
      builder: (_) => Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(children: [
                DottedBorder(
                  strokeCap: StrokeCap.square,
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(12),
                  padding: const EdgeInsets.all(6),
                  dashPattern: const [5],
                  strokeWidth: 1.5,
                  color: c.isErrorColor.value ? AppColors.red : AppColors.borderClr,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    child: SizedBox(
                      height: Get.width * .7,
                      width: Get.width,
                      child: c.image.value != null
                          ? Image.file(c.image.value!, fit: BoxFit.fill)
                          : c.mainUrlImage.value.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: c.mainUrlImage.value,
                                  height: Get.width * .7,
                                  width: Get.width,
                                  fit: BoxFit.fill,
                                  placeholder: (ctx, url) => Shimmer.fromColors(
                                    baseColor: AppColors.bgColor,
                                    highlightColor: AppColors.lightText,
                                    child: Container(color: AppColors.grey),
                                  ),
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(ImageConstants.uploadImage,
                                        height: 30, width: 30),
                                    SizedBox(height: 34.h),
                                    Text('Upload Product Image',
                                        style: AppFontStyle.text_14_500(
                                            AppColors.lightBlackClr,
                                            fontFamily: AppFontFamily.gilroyMedium)),
                                    SizedBox(height: 2.h),
                                    Text('jpg/png should be less than 5mb',
                                        style: AppFontStyle.text_14_400(
                                            AppColors.hintText,
                                            fontFamily: AppFontFamily.gilroyMedium)),
                                    SizedBox(height: 16.h),
                                    CustomElevatedButton(
                                      borderSide: BorderSide(color: AppColors.black),
                                      borderRadius: BorderRadius.circular(10),
                                      color: AppColors.transparent,
                                      width: 110.w,
                                      height: 40.h,
                                      onPressed: () => c
                                          .pickImage(context)
                                          .then((_) => c.isErrorColor.value = false),
                                      text: 'Choose File',
                                      textStyle: AppFontStyle.text_15_400(
                                          AppColors.lightBlackClr,
                                          fontFamily: AppFontFamily.gilroySemiBold),
                                    ),
                                  ],
                                ),
                    ),
                  ),
                ),
                if (c.image.value != null || c.mainUrlImage.value.isNotEmpty)
                  Positioned(
                    right: 3.w,
                    top: 5.h,
                    child: GestureDetector(
                      onTap: () {
                        c.image.value = null;
                        c.mainUrlImage.value = '';
                        c.imageBase64.value = '';
                      },
                      child: Icon(Icons.cancel_outlined, size: 25, color: AppColors.red),
                    ),
                  ),
              ]),
              if (c.isErrorColor.value) ...[
                hBox(8.h),
                Text('Please select image',
                    style: AppFontStyle.text_12_200(AppColors.red,
                        fontFamily: AppFontFamily.gilroyMedium)),
              ],
            ],
          )),
    );
  }

  Widget _additionalImages() {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 6,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1),
      itemBuilder: (context, index) => Obx(() => Stack(children: [
            GestureDetector(
              onTap: () => c.pickMoreImage(index),
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
                  child: SizedBox(
                    width: Get.width * 0.42,
                    height: Get.width * 0.42,
                    child: c.additionalImages[index].value != null
                        ? Image.file(c.additionalImages[index].value!, fit: BoxFit.fill)
                        : c.additionalImageFromApi[index].value.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: c.additionalImageFromApi[index].value,
                                fit: BoxFit.fill,
                                placeholder: (ctx, url) => Shimmer.fromColors(
                                  baseColor: AppColors.bgColor,
                                  highlightColor: AppColors.lightText,
                                  child: Container(color: AppColors.grey),
                                ),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(ImageConstants.uploadImage,
                                      height: 24, width: 24),
                                  SizedBox(height: 15.h),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 3.0),
                                    child: Text('Additional\nImages',
                                        textAlign: TextAlign.center,
                                        style: AppFontStyle.text_14_400(AppColors.hintText,
                                            fontFamily: AppFontFamily.gilroyRegular),
                                        maxLines: 2),
                                  ),
                                ],
                              ),
                  ),
                ),
              ),
            ),
            if (c.additionalImages[index].value != null ||
                c.additionalImageFromApi[index].value.isNotEmpty)
              Positioned(
                right: 3.w,
                top: 5.h,
                child: GestureDetector(
                  onTap: () {
                    c.additionalImages[index].value = null;
                    c.additionalImageFromApi[index].value = '';
                    c.additionalImageBase64[index].value = '';
                  },
                  child: Icon(Icons.cancel_outlined, size: 25, color: AppColors.red),
                ),
              ),
          ])),
    );
  }

  Widget _productTitle() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Product Name',
          style: AppFontStyle.text_14_500(AppColors.lightBlackClr,
              fontFamily: AppFontFamily.interMedium)),
      hBox(5),
      CustomTextFormField(
        key: c.titleKey,
        controller: c.titleController.value,
        onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
        validator: (v) {
          if (v == null || v.trim().isEmpty) return 'Please enter product title';
          if (!isValidCharacters(v)) return 'Please enter a valid character';
          return null;
        },
        hintText: 'Product Title',
      ),
    ]);
  }

  Widget _productDescription() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Product Description',
          style: AppFontStyle.text_14_500(AppColors.lightBlackClr,
              fontFamily: AppFontFamily.interMedium)),
      hBox(5),
      CustomTextFormField(
        key: c.descriptionKey,
        textInputAction: TextInputAction.newline,
        textInputType: TextInputType.multiline,
        minLines: 4,
        maxLines: 8,
        controller: c.descriptionController.value,
        inputFormatters: [LengthLimitingTextInputFormatter(200)],
        onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
        buildCounter: (ctx,
                {required currentLength, required isFocused, required maxLength}) =>
            Padding(
                padding: const EdgeInsets.only(left: 22),
                child: Text('$currentLength Characters')),
        validator: (v) {
          if (v == null || v.trim().isEmpty) return 'Please enter product description';
          if (v.trim().length < 20) return 'Please enter minimum 20 characters';
          return null;
        },
        hintText: 'Product Description',
      ),
    ]);
  }

  Widget _regularPriceAndPromoCode() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Regular Price',
              style: AppFontStyle.text_14_500(AppColors.lightBlackClr,
                  fontFamily: AppFontFamily.interMedium)),
          hBox(5.h),
          CustomTextFormField(
            key: c.regularKey,
            controller: c.regularPriceController.value,
            textInputType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [LengthLimitingTextInputFormatter(6), DecimalTextInputFormatter()],
            onTap: () => c.activeSalePriceValidation.value = false,
            onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Please enter regular price';
              if ((double.tryParse(v) ?? 0) <= 0) return 'Invalid amount';
              if (!isValidNumberFormat(v)) return 'Invalid format';
              return null;
            },
            hintText: 'eg. GHC 1,300',
          ),
        ])),
        wBox(12.w),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Promo Price (Optional)',
              style: AppFontStyle.text_14_500(AppColors.lightBlackClr,
                  fontFamily: AppFontFamily.interMedium)),
          hBox(5.h),
          CustomTextFormField(
            controller: c.promoController.value,
            textInputType: TextInputType.number,
            onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
            hintText: 'eg. GHC 1,110',
          ),
        ])),
      ]),
      hBox(12.h),
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Stock Quantity',
              style: AppFontStyle.text_14_500(AppColors.lightBlackClr,
                  fontFamily: AppFontFamily.interMedium)),
          hBox(5.h),
          CustomTextFormField(
            key: c.stockKey,
            controller: c.stockController.value,
            textInputType: TextInputType.number,
            inputFormatters: [
              LengthLimitingTextInputFormatter(20),
              FilteringTextInputFormatter.digitsOnly
            ],
            onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Please enter stock quantity';
              if (int.tryParse(v) == null) return 'Invalid quantity';
              if ((int.tryParse(v) ?? 0) <= 0) return 'Quantity must be greater than 0';
              return null;
            },
            hintText: 'eg. 32',
          ),
        ])),
        wBox(12.w),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Stock Units',
              style: AppFontStyle.text_14_500(AppColors.lightBlackClr,
                  fontFamily: AppFontFamily.interMedium)),
          hBox(5.h),
          Container(
            key: c.stockSectionKey,
            child: Obx(() => CustomDropDown(
                  selectedValue: c.selectedStockSection.value.toUpperCase(),
                  items: c.stockUnitSection.map((e) => e.toUpperCase()).toList(),
                  borderColor: AppColors.textFieldBorder,
                  hintText: 'eg.Units,kg',
                  btnHeight: 50,
                  onChanged: (v) => c.selectedStockSection.value = v!.toLowerCase(),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Please select unit' : null,
                )),
          ),
        ])),
      ]),
      hBox(12.h),
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Seller SKU',
              style: AppFontStyle.text_14_500(AppColors.lightBlackClr,
                  fontFamily: AppFontFamily.interMedium)),
          hBox(5.h),
          CustomTextFormField(
            key: c.skuKey,
            controller: c.skuController.value,
            textInputType: TextInputType.text,
            inputFormatters: [LengthLimitingTextInputFormatter(20)],
            onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Please enter seller SKU' : null,
            hintText: 'eg. SM-A55-1-BLK',
          ),
        ])),
        wBox(12.w),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('GTIN/Barcode',
              style: AppFontStyle.text_14_500(AppColors.lightBlackClr,
                  fontFamily: AppFontFamily.interMedium)),
          hBox(5.h),
          CustomTextFormField(
            key: c.barcodeKey,
            controller: c.barcodeController.value,
            textInputType: TextInputType.text,
            onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Please enter barcode' : null,
            hintText: 'eg. EAN 8806091',
          ),
        ])),
      ]),
    ]);
  }

  Widget _statusAndOtherFields() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Status',
              style: AppFontStyle.text_14_500(AppColors.lightBlackClr,
                  fontFamily: AppFontFamily.interMedium)),
          hBox(5),
          Obx(() => CustomDropDownApi(
                selectedValue: c.status.value,
                items: statusItems,
                borderColor: AppColors.textFieldBorder,
                hintText: 'Choose Status',
                btnHeight: 50,
                onChanged: (v) => c.status.value = v!,
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Please select status' : null,
              )),
        ])),
        wBox(12.w),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Condition',
              style: AppFontStyle.text_14_500(AppColors.lightBlackClr,
                  fontFamily: AppFontFamily.interMedium)),
          hBox(5),
          CustomTextFormField(
            key: c.conditionKey,
            controller: c.conditionController.value,
            hintText: 'e.g brand new',
            onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Please enter condition' : null,
          ),
        ])),
      ]),
      hBox(12.h),
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Package Dimensions',
              style: AppFontStyle.text_14_500(AppColors.lightBlackClr,
                  fontFamily: AppFontFamily.interMedium)),
          hBox(5.h),
          CustomTextFormField(
            key: c.packageKey,
            controller: c.packageController.value,
            textInputType: TextInputType.text,
            inputFormatters: [LengthLimitingTextInputFormatter(20)],
            onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
            hintText: '30 x 20 x 12 cm',
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Please enter package' : null,
          ),
        ])),
        wBox(12.w),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Weight (Kg)',
              style: AppFontStyle.text_14_500(AppColors.lightBlackClr,
                  fontFamily: AppFontFamily.interMedium)),
          hBox(5.h),
          CustomTextFormField(
            key: c.weightKey,
            controller: c.weightController.value,
            textInputType: TextInputType.number,
            inputFormatters: [LengthLimitingTextInputFormatter(10)],
            onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Please enter weight' : null,
            hintText: '13 (Kg,Gm)',
          ),
        ])),
      ]),
      hBox(12.h),
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Fulfillment Type',
              style: AppFontStyle.text_14_500(AppColors.lightBlackClr,
                  fontFamily: AppFontFamily.interMedium)),
          hBox(5.h),
          CustomTextFormField(
            key: c.fulfillmentKey,
            controller: c.fulfillmentController.value,
            textInputType: TextInputType.text,
            inputFormatters: [LengthLimitingTextInputFormatter(20)],
            onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
            hintText: 'Seller',
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Please enter fulfillment type' : null,
          ),
        ])),
        wBox(12.w),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Preparation Time',
              style: AppFontStyle.text_14_500(AppColors.lightBlackClr,
                  fontFamily: AppFontFamily.interMedium)),
          hBox(5.h),
          CustomTextFormField(
            key: c.preparationKey,
            controller: c.preparationController.value,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[\d\-a-zA-Z]'))
            ],
            hintText: 'e.g, 2 days',
            onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Please enter preparation time' : null,
          ),
        ])),
      ]),
      hBox(12.h),
      Text('Department',
          style: AppFontStyle.text_14_500(AppColors.lightBlackClr,
              fontFamily: AppFontFamily.interMedium)),
      hBox(5),
      Obx(() => CustomDropDownApi(
            key: c.departmentKey,
            selectedValue: c.selectedDepartmentId.value.isEmpty
                ? null
                : c.selectedDepartmentId.value,
            items: c.apiCategoryData.value.data?.categories ?? [],
            borderColor: AppColors.textFieldBorder,
            hintText: 'Select Department',
            btnHeight: 50,
            onChanged: (v) {
              if (v == null || v.isEmpty) return;
              final deptList = c.apiCategoryData.value.data?.categories ?? [];
              final idx = deptList.indexWhere((d) => d.id == v);
              if (idx == -1) return;
              final selected = deptList[idx];
              c.selectedDepartmentId.value = selected.id ?? '';
              c.department.value = selected.name ?? '';
              c.selectedCategoryId.value = '';
              c.category.value = '';
              c.selectedSubCategoryId.value = '';
              c.subCategory.value = '';
              c.getVendorCategoriesApi();
            },
            validator: (v) =>
                c.department.value.isEmpty ? 'Please select department' : null,
          )),
      hBox(12),
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Category',
              style: AppFontStyle.text_14_500(AppColors.lightBlackClr,
                  fontFamily: AppFontFamily.interMedium)),
          hBox(5),
          Obx(() {
            final categoryList = c.categoriesData.value.categories ?? [];
            return CustomDropDownApi(
              key: c.categoryKey,
              selectedValue: c.selectedCategoryId.value.isEmpty
                  ? null
                  : c.selectedCategoryId.value,
              items: categoryList,
              borderColor: AppColors.textFieldBorder,
              hintText: 'Category',
              btnHeight: 50,
              onChanged: (v) async {
                c.selectedCategoryId.value = v.toString();
                final selected = categoryList.firstWhere(
                    (e) => e.id.toString() == v.toString(),
                    orElse: () => VendorCategories());
                c.category.value = selected.name ?? '';
                c.selectedSubCategoryId.value = '';
                c.subCategory.value = '';
                await c.getVendorSubCategoriesApi();
              },
              validator: (v) =>
                  c.selectedCategoryId.value.isEmpty ? 'Please select category' : null,
            );
          }),
        ])),
        wBox(12.w),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Sub Category',
              style: AppFontStyle.text_14_500(AppColors.lightBlackClr,
                  fontFamily: AppFontFamily.interMedium)),
          hBox(5),
          Obx(() {
            final subList = c.subCategoriesData.value.data ?? [];
            return CustomDropDownApi(
              key: c.subCategoryKey,
              selectedValue: c.selectedSubCategoryId.value.isEmpty
                  ? null
                  : c.selectedSubCategoryId.value,
              items: subList,
              borderColor: AppColors.textFieldBorder,
              hintText: 'Sub Category',
              btnHeight: 50,
              onChanged: (v) async {
                final selected = subList.firstWhere(
                    (e) => e.id.toString() == v.toString(),
                    orElse: () => subList.first);
                c.selectedSubCategoryId.value = selected.id ?? '';
                c.subCategory.value = selected.name ?? '';
                await c.getVendorProductAttributeApi();
              },
              validator: (v) =>
                  c.subCategory.value.isEmpty ? 'Please select sub category' : null,
            );
          }),
        ])),
      ]),
      hBox(15.h),
    ]);
  }

  Widget _additionalDetailsSection() {
    return Obx(() {
      final additionalDetails = c.attributeData.value.additionalDetails ?? [];
      if (additionalDetails.isEmpty) return const SizedBox();
      return Column(children: [
        Divider(color: AppColors.greyTextColor.withAlpha(70)),
        hBox(10.h),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            '${c.department.value} - ${c.category.value} - ${c.subCategory.value} -',
            style: AppFontStyle.text_13_500(AppColors.blueLightColor,
                fontFamily: AppFontFamily.interSemiBold),
          ),
          Text(' Additional Details',
              overflow: TextOverflow.ellipsis,
              style: AppFontStyle.text_13_500(AppColors.blueLightColor,
                  fontFamily: AppFontFamily.interSemiBold)),
        ]),
        hBox(20.h),
        ...List.generate((additionalDetails.length / 2).ceil(), (rowIndex) {
          int firstIndex = rowIndex * 2;
          int secondIndex = firstIndex + 1;
          final firstItem = additionalDetails[firstIndex];
          final secondItem =
              secondIndex < additionalDetails.length ? additionalDetails[secondIndex] : null;
          c.additionalControllers.putIfAbsent(
              firstItem.slug ?? '', () => TextEditingController());
          if (secondItem != null) {
            c.additionalControllers.putIfAbsent(
                secondItem.slug ?? '', () => TextEditingController());
          }
          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(firstItem.title ?? '',
                    style: AppFontStyle.text_14_500(AppColors.lightBlackClr,
                        fontFamily: AppFontFamily.interMedium)),
                hBox(5.h),
                CustomTextFormField(
                  key: ValueKey(firstItem.slug),
                  controller: c.additionalControllers[firstItem.slug ?? ''],
                  inputFormatters: [LengthLimitingTextInputFormatter(50)],
                  onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
                  hintText: firstItem.placeholder ?? '',
                ),
              ])),
              if (secondItem != null) ...[
                wBox(12.w),
                Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(secondItem.title ?? '',
                      style: AppFontStyle.text_14_500(AppColors.lightBlackClr,
                          fontFamily: AppFontFamily.interMedium)),
                  hBox(5.h),
                  CustomTextFormField(
                    controller: c.additionalControllers[secondItem.slug ?? ''],
                    inputFormatters: [LengthLimitingTextInputFormatter(50)],
                    onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
                    hintText: secondItem.placeholder ?? '',
                  ),
                ])),
              ] else
                const Expanded(child: SizedBox()),
            ]),
          );
        }),
      ]);
    });
  }

  Widget _variantSection() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      hBox(10),
      CustomCheckboxTile(
        scale: 1.2,
        title: ' This product has variants (e.g. different sizes)',
        style: AppFontStyle.text_13_500(AppColors.black,
            fontFamily: AppFontFamily.interMedium),
        value: c.hasVariants,
        onChanged: (val) => c.hasVariants.value = val,
      ),
      hBox(16),
      Obx(() {
        if (!c.hasVariants.value) return const SizedBox();
        return Column(children: [
          // ── Step 1: Select Attributes ──────────────────────────────────
          AppContainer(
            borderRadius: BorderRadius.circular(15),
            padding: const EdgeInsets.all(12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                _stepCircle('1'),
                wBox(10),
                Text('Select Variant Attributes',
                    style: AppFontStyle.text_14_500(AppColors.black,
                        fontFamily: AppFontFamily.interSemiBold)),
              ]),
              hBox(12),
              Obx(() => Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: c.allVariantAttributes.map((attr) {
                      final selected = c.selectedVariantAttributes.contains(attr);
                      return GestureDetector(
                        onTap: () => c.toggleAttribute(attr),
                        child: AppContainer(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          color: selected ? AppColors.primary : AppColors.white,
                          border: Border.all(color: AppColors.borderClr),
                          borderRadius: BorderRadius.circular(8),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            Text(attr,
                                style: AppFontStyle.text_12_500(
                                    selected ? AppColors.white : AppColors.black,
                                    fontFamily: AppFontFamily.interMedium)),
                            if (selected) ...[
                              wBox(5),
                              const Icon(Icons.close, size: 14, color: Colors.white),
                            ],
                          ]),
                        ),
                      );
                    }).toList(),
                  )),
              hBox(15),
              Divider(color: AppColors.borderClr, height: 1),
              hBox(15),
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(child: Column(children: [
                  CustomTextFormField(
                      controller: c.customAttrNameController,
                      hintText: 'Attribute name',
                      height: 45),
                  hBox(10),
                  CustomTextFormField(
                      controller: c.customAttrValueController,
                      hintText: 'Values (comma-separated)',
                      height: 45),
                ])),
                wBox(10),
                GestureDetector(
                  onTap: () => c.validateAndAddCustomAttribute(),
                  child: AppContainer(
                    height: 100,
                    width: 50,
                    border: Border.all(color: AppColors.borderClr),
                    borderRadius: BorderRadius.circular(8),
                    child: const Icon(Icons.add),
                  ),
                ),
              ]),
            ]),
          ),
          hBox(12),
          // ── Step 2: Configure Values ───────────────────────────────────
          Obx(() {
            if (c.selectedVariantAttributes.isEmpty) return const SizedBox();
            return AppContainer(
              borderRadius: BorderRadius.circular(15),
              padding: const EdgeInsets.all(12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  _stepCircle('2'),
                  wBox(10),
                  Text('Configure Attribute Values',
                      style: AppFontStyle.text_14_500(AppColors.black,
                          fontFamily: AppFontFamily.interSemiBold)),
                ]),
                hBox(12),
                Column(
                  children: c.selectedVariantAttributes.map((attr) {
                    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text(attr,
                            style: AppFontStyle.text_13_500(AppColors.blackTextColor,
                                fontFamily: AppFontFamily.interMedium)),
                        GestureDetector(
                          onTap: () => c.toggleValueField(attr),
                          child: AppContainer(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: AppColors.borderClr),
                            child: Row(mainAxisSize: MainAxisSize.min, children: [
                              const Icon(Icons.add, size: 14),
                              wBox(5),
                              Text('Add Value',
                                  style: AppFontStyle.text_12_500(AppColors.primary,
                                      fontFamily: AppFontFamily.interMedium)),
                            ]),
                          ),
                        ),
                      ]),
                      hBox(15),
                      Wrap(spacing: 8, runSpacing: 8, children: [
                        ...c.attributeValues[attr]!.map((val) {
                          final savedCtrl = c.savedValueControllers[attr]?[val]
                              ?? TextEditingController(text: val);
                          return AppContainer(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                            border: Border.all(color: AppColors.borderClr),
                            borderRadius: BorderRadius.circular(6),
                            child: Row(mainAxisSize: MainAxisSize.min, children: [
                              SizedBox(
                                width: 70.w,
                                height: 28.h,
                                child: TextField(
                                  controller: savedCtrl,
                                  style: AppFontStyle.text_12_400(
                                      AppColors.blackTextColor,
                                      fontFamily: AppFontFamily.interMedium),
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 4, vertical: 4),
                                  ),
                                  onChanged: (newVal) {
                                    if (newVal.trim().isNotEmpty) {
                                      c.updateAttributeValue(attr, val, newVal.trim());
                                    }
                                  },
                                ),
                              ),
                              GestureDetector(
                                onTap: () => c.removeAttributeValue(attr, val),
                                child: Icon(Icons.close, size: 16, color: AppColors.red),
                              ),
                            ]),
                          );
                        }),
                        Obx(() {
                          final show = c.showValueField[attr]?.value ?? false;
                          if (!show) return const SizedBox();
                          return AppContainer(
                            width: 100.w,
                            height: 30.h,
                            child: Row(children: [
                              wBox(4),
                              Expanded(
                                  child: TextField(
                                controller: c.valueControllers[attr],
                                autofocus: true,
                                style: AppFontStyle.text_13_400(AppColors.greyTextColor,
                                    fontFamily: AppFontFamily.interMedium),
                                decoration: InputDecoration(
                                  isDense: true,
                                  filled: true,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide: BorderSide.none),
                                  fillColor: AppColors.searchText,
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 2),
                                ),
                                onSubmitted: (val) {
                                  if (val.trim().isNotEmpty) c.addAttributeValue(attr);
                                },
                              )),
                              GestureDetector(
                                onTap: () {
                                  c.valueControllers[attr]?.clear();
                                  c.showValueField[attr]?.value = false;
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Icon(Icons.close, size: 16, color: AppColors.red),
                                ),
                              ),
                            ]),
                          );
                        }),
                      ]),
                      hBox(12),
                    ]);
                  }).toList(),
                ),
                hBox(12),
                CustomElevatedButton(
                  height: 46,
                  borderRadius: BorderRadius.circular(8),
                  onPressed: c.generateVariants,
                  child: Text('Generate Variant Matrix',
                      style: AppFontStyle.text_14_500(AppColors.white,
                          fontFamily: AppFontFamily.interMedium)),
                ),
              ]),
            );
          }),
          hBox(12),
          // ── Step 3: Variant Matrix Table ───────────────────────────────
            Obx(() {
              if (c.variantList.isEmpty) return const SizedBox();
              final tableAttributes = c.selectedVariantAttributes;
              final selectedVariants =
                  c.variantList.where((v) => v.isSelected.value).toList();
              return AppContainer(
                borderRadius: BorderRadius.circular(15),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      _stepCircle('3'),
                      Text('Variant Matrix (${selectedVariants.length})',
                          style: AppFontStyle.text_14_500(AppColors.lightBlackClr,
                              fontFamily: AppFontFamily.interMedium)),
                      AppContainer(
                        height: 30,
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        borderRadius: BorderRadius.circular(6),
                        onTap: () {
                          double basePrice = double.tryParse(
                                  c.regularPriceController.value.text.trim()) ??
                              0;
                          for (var v in c.variantList) {
                            v.price.value = basePrice;
                          }
                          c.update();
                        },
                        child: Text('Apply Base Price to All',
                            style: AppFontStyle.text_12_500(AppColors.lightBlackClr,
                                fontFamily: AppFontFamily.interMedium)),
                      ),
                    ]),
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
                            TableRow(children: [
                              _cell('Select'),
                              ...tableAttributes.map((attr) => _cell(attr)),
                              _cell('SKU'),
                              _cell('Price'),
                              _cell('Stock'),
                            ]),
                            ...c.variantList.map((variant) => TableRow(children: [
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 15),
                                      child: CustomCheckboxTile(
                                        value: variant.isSelected,
                                        onChanged: (v) => variant.isSelected.value = v,
                                        title: '',
                                      ),
                                    ),
                                  ),
                                  ...tableAttributes
                                      .map((attr) => _cell(variant.values[attr] ?? '')),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: TextFormField(
                                      initialValue: variant.sku,
                                      onChanged: (val) => variant.sku = val.trim(),
                                      style: AppFontStyle.text_12_500(
                                          AppColors.blackTextColor,
                                          fontFamily: AppFontFamily.interMedium),
                                      decoration: InputDecoration(
                                        isDense: true,
                                        filled: true,
                                        fillColor: AppColors.searchText,
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(6),
                                            borderSide: BorderSide.none),
                                        contentPadding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 6),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Obx(() => TextFormField(
                                          key: ValueKey(variant.price.value),
                                          initialValue:
                                              variant.price.value.toStringAsFixed(0),
                                          keyboardType: TextInputType.number,
                                          onChanged: (val) => variant.price.value =
                                              double.tryParse(val) ?? variant.price.value,
                                          style: AppFontStyle.text_12_500(
                                              AppColors.blackTextColor,
                                              fontFamily: AppFontFamily.interMedium),
                                          decoration: InputDecoration(
                                            isDense: true,
                                            filled: true,
                                            fillColor: AppColors.searchText,
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(6),
                                                borderSide: BorderSide.none),
                                            contentPadding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 6),
                                          ),
                                        )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: TextFormField(
                                      initialValue: variant.stock.value.toString(),
                                      keyboardType: TextInputType.number,
                                      onChanged: (val) => variant.stock.value =
                                          int.tryParse(val) ?? variant.stock.value,
                                      style: AppFontStyle.text_12_500(
                                          AppColors.blackTextColor,
                                          fontFamily: AppFontFamily.interMedium),
                                      decoration: InputDecoration(
                                        isDense: true,
                                        filled: true,
                                        fillColor: AppColors.searchText,
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(6),
                                            borderSide: BorderSide.none),
                                        contentPadding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 6),
                                      ),
                                    ),
                                  ),
                                ])),
                          ],
                        ),
                      ),
                    ),
                  ]),
                ),
              );
            }),
        ]);
      }),
    ]);
  }

  Widget _publishButton() {
    return Row(children: [
      Expanded(
          child: CustomElevatedButton(
        height: 52,
        onPressed: () => Get.back(),
        text: 'Cancel',
        color: AppColors.white,
      )),
      wBox(8.w),
      Expanded(
          child: Obx(() => CustomElevatedButton(
                height: 52,
                isLoading: c.rxRequestStatus.value == ApiStatus.LOADING,
                onPressed: () async {
                  bool isValid = await c.validateBeforeUpdate();
                  if (!isValid) return;
                  c.editProductApi();
                },
                text: 'Update',
              ))),
    ]);
  }

  Widget _stepCircle(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
          color: AppColors.blueLightColor, borderRadius: BorderRadius.circular(15)),
      child: Text(text,
          style: AppFontStyle.text_12_500(AppColors.white,
              fontFamily: AppFontFamily.interMedium)),
    );
  }

  Widget _cell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(text,
          style: AppFontStyle.text_12_500(AppColors.blackTextColor,
              fontFamily: AppFontFamily.interMedium)),
    );
  }
}
