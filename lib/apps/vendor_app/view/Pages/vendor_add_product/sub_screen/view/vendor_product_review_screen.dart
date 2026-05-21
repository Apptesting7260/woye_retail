import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:gyaawa/Core/Constant/image_constant.dart';
import 'package:gyaawa/Utils/sized_box.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/vendor_add_product/controller/restaurant_product_add_controller.dart';
import 'package:gyaawa/shared/widgets/vendor_widgets/app_container.dart';
import 'package:gyaawa/shared/widgets/vendor_widgets/custom_elevated_button.dart';
import '../../../../../../../Data/response/status.dart';
import '../../../../../../../shared/theme/colors.dart';
import '../../../../../../../shared/theme/font_family.dart';
import '../../../../../../../shared/theme/font_style.dart';
import '../../../../../../../shared/widgets/custom_appbar.dart';
import '../../../../../../../shared/widgets/vendor_widgets/circular_progress_indicator.dart';

class RetailProductReviewScreen extends StatefulWidget {
  const RetailProductReviewScreen({super.key});

  @override
  State<RetailProductReviewScreen> createState() => _RetailProductReviewScreenState();
}

class _RetailProductReviewScreenState extends State<RetailProductReviewScreen> {
  final RestaurantProductAddController controller = Get.find<RestaurantProductAddController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildProductSummary(),
              // hBox(20),
              // buildVariantsTable(),
              hBox(40),
              buildBottomButtons(),
              hBox(16),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProductSummary() {
    final selectedVariants = controller.variantList.where((variant) => variant.isSelected.value).toList();
    return AppContainer(
      color: AppColors.backgroundClr,
      borderRadius: BorderRadius.circular(8),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Product Summary', style: AppFontStyle.text_16_400(AppColors.darkText, fontFamily: AppFontFamily.gilroySemiBold,),),
          hBox(16),
          Text('Product Name:', style: AppFontStyle.text_14_400(AppColors.darkText, fontFamily: AppFontFamily.gilroyMedium,),),
          Text(  controller.titleController.value.text.isEmpty ? '-'
                : controller.titleController.value.text, style: AppFontStyle.text_14_400(AppColors.greyTextColor)),
          hBox(12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Department:', style: AppFontStyle.text_14_400(AppColors.darkText, fontFamily: AppFontFamily.gilroyMedium)),
                    Obx(() {
                      return Text(
                        controller.department.value.isEmpty ? "-" : controller.department.value,
                        style: AppFontStyle.text_14_400(
                          AppColors.greyTextColor, fontFamily: AppFontFamily.interRegular,
                        ),
                      );
                    }),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Category", style: AppFontStyle.text_14_400(AppColors.darkText, fontFamily: AppFontFamily.gilroyMedium)),
                    Text(controller.category.value.isEmpty ? "-" : controller.category.value,
                      style: AppFontStyle.text_14_400(AppColors.greyTextColor, fontFamily: AppFontFamily.interRegular)),
                  ],
                ),
              ),
            ],
          ),
          hBox(12),
          Text('Sub Category:', style: AppFontStyle.text_14_400(AppColors.darkText, fontFamily: AppFontFamily.gilroyMedium)),
          Text(
            controller.subCategory.value.isEmpty ? "-" : controller.subCategory.value, style: AppFontStyle.text_14_400(AppColors.greyTextColor)),
          hBox(12),

          Text('Description:', style: AppFontStyle.text_14_400(AppColors.darkText, fontFamily: AppFontFamily.gilroyMedium)),
          Text(
            controller.descriptionController.value.text.isEmpty ?
            '-' : controller.descriptionController.value.text, style: AppFontStyle.text_14_400(AppColors.greyTextColor)),
          hBox(14),
          buildBasePriceSection(),
          hBox(8),
          Divider(color: AppColors.borderClr),
          hBox(8),
          Text('If you continue to save this product, you will add ${selectedVariants.length} Variants as shown in the table below. You can go back to make changes.',
            maxLines: 5, textAlign: TextAlign.center, style: AppFontStyle.text_12_500(AppColors.black, fontFamily: AppFontFamily.interMedium,),),
          hBox(16),
          SizedBox(
            width: double.infinity,
            child: CustomElevatedButton(
              height: 40.h,
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.borderClr),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Go Back', style: AppFontStyle.text_15_400(AppColors.black, fontFamily: AppFontFamily.interMedium)),
            ),
          ),
          hBox(20),
          buildVariantsTable(),
        ],
      ),
    );
  }

  Widget buildBasePriceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Base Price:', style: AppFontStyle.text_14_400(AppColors.darkText, fontFamily: AppFontFamily.gilroyMedium),
        ),
        hBox(4),
        Text(
        controller.regularPriceController.value.text.isEmpty
           ? 'GHC 0.0' : 'GHC ${controller.regularPriceController.value.text}',
            style: AppFontStyle.text_14_400(
            AppColors.greyTextColor,
            fontFamily: AppFontFamily.interRegular,
          ),
        ),
      ],
    );
  }

  Widget buildVariantsTable() {
    return Obx(() {
      final selectedVariants = controller.variantList.where((e) => e.isSelected.value).toList();

      if (selectedVariants.isEmpty) {
        return const SizedBox();
      }

      final tableAttributes = controller.selectedVariantAttributes;

      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: selectedVariants.length,
        separatorBuilder: (_, __) => Divider(
          height: 1,
          thickness: 1,
          color: AppColors.borderClr,
        ),
        itemBuilder: (context, itemIndex) {
          final variant = selectedVariants[itemIndex];
          return Obx(() => Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: Row(
              children: [
                // Attribute chips
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: tableAttributes.map((attr) {
                      final val = variant.values[attr] ?? '-';
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 1),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: AppColors.borderClr, width: 1),
                        ),
                        child: Text(
                          val,
                          style: AppFontStyle.text_12_500(
                              AppColors.black,
                              fontFamily: AppFontFamily.interMedium),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'GHC ${variant.price.value.toStringAsFixed(0)} | Stock: ${variant.stock.value}',
                  style: AppFontStyle.text_12_400(AppColors.greyTextColor,fontFamily: AppFontFamily.interRegular),
                ),
              ],
            ),
          ));
        },
      );
    });
  }



  Widget buildBottomButtons() {
    return Padding(
      padding: const EdgeInsets.only(left: 60),
      child: Row(
        children: [
          CustomElevatedButton(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColors.borderClr),
            height: 40.h,
            width: 100.w,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel', style: AppFontStyle.text_15_400(AppColors.darkText, fontFamily: AppFontFamily.gilroyMedium)),
          ),
          wBox(12),
          Expanded(
            child: Obx(() => CustomElevatedButton(
              height: 40.h,
              borderRadius: BorderRadius.circular(8),
              onPressed: () async {
                bool isValid = await controller.validateBeforeReview();
                if (!isValid) return;
                await controller.restaurantAddProductApi(
                  productTitle: controller.titleController.value.text,
                  stockQty: controller.stockController.value.text,
                  categoryId: controller.selectedCategoryId.value,
                  status: controller.status.value == "1" ? "active" : "inactive",
                  regularPrice: controller.regularPriceController.value.text,
                  description: controller.descriptionController.value.text,
                  mainImage: controller.imageBase64.value,
                  image0: controller.additionalImageBase64[0].value,
                  image1: controller.additionalImageBase64[1].value,
                  image2: controller.additionalImageBase64[2].value,
                  image3: controller.additionalImageBase64[3].value,
                  image4: controller.additionalImageBase64[4].value,
                  image5: controller.additionalImageBase64[5].value,
                );
              },

              child: controller.rxRequestStatus.value == ApiStatus.LOADING
                  ? circularProgressIndicator(size: 25, color: AppColors.white,
              ) : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(ImageConstants.saveSvg),
                  wBox(8),
                  Text(
                    'Save Product', style: AppFontStyle.text_14_500(AppColors.white, fontFamily: AppFontFamily.interMedium),
                  ),
                ],
              ),
            )),
          ),
        ],
      ),
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
      ),
    );
  }
}
