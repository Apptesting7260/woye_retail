import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:gyaawa/Utils/sized_box.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/RestaurantAddProduct/sub_screen/controller/retail_product_review_controller.dart';
import 'package:gyaawa/shared/widgets/vendor_widgets/app_container.dart';
import 'package:gyaawa/shared/widgets/vendor_widgets/custom_elevated_button.dart';
import '../../../../../../../shared/theme/colors.dart';
import '../../../../../../../shared/theme/font_family.dart';
import '../../../../../../../shared/theme/font_style.dart';
import '../../../../../../../shared/widgets/custom_appbar.dart';

class RetailProductReviewScreen extends StatefulWidget {
  const RetailProductReviewScreen({super.key});

  @override
  State<RetailProductReviewScreen> createState() => _RetailProductReviewScreenState();
}

class _RetailProductReviewScreenState extends State<RetailProductReviewScreen> {
  final RetailProductReviewController controller = Get.find<RetailProductReviewController>();
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
              hBox(20),
              buildVariantsTable(),
              hBox(20),
              buildBottomButtons(),
              hBox(16),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProductSummary() {
    return AppContainer(
      borderRadius: BorderRadius.circular(8),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Product Summary', style: AppFontStyle.text_16_400(AppColors.darkText, fontFamily: AppFontFamily.gilroySemiBold,),),
          hBox(16),
          Text('Product Name:', style: AppFontStyle.text_14_400(AppColors.darkText, fontFamily: AppFontFamily.gilroyMedium,),),
          Text('-', style: AppFontStyle.text_14_400(AppColors.greyTextColor,),),
          hBox(12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Category:', style: AppFontStyle.text_14_400(AppColors.darkText, fontFamily: AppFontFamily.gilroyMedium,),),
                    Text('Computers', style: AppFontStyle.text_14_400(AppColors.greyTextColor, fontFamily: AppFontFamily.interRegular,),),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Department:', style: AppFontStyle.text_14_400(AppColors.darkText, fontFamily: AppFontFamily.gilroyMedium,),),
                    Text('Electronics', style: AppFontStyle.text_14_400(AppColors.greyTextColor, fontFamily: AppFontFamily.interRegular,),),
                  ],
                ),
              ),
            ],
          ),
          hBox(12),
          Text('Description:', style: AppFontStyle.text_14_400(AppColors.darkText, fontFamily: AppFontFamily.gilroyMedium,),),
          Text('-', style: AppFontStyle.text_14_400(AppColors.greyTextColor,),),
          hBox(14),
          buildBasePriceSection(),
          hBox(8),
          Divider(color: AppColors.borderClr),
          hBox(8),
          Text('If you continue to save this product, you will add 9 Variants as shown in the table below. You can go back to make changes.',
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
              child: Text('Go Back', style: AppFontStyle.text_15_400(AppColors.darkText, fontFamily: AppFontFamily.gilroyMedium,),),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBasePriceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Base Price:',
          style: AppFontStyle.text_14_400(
            AppColors.darkText,
            fontFamily: AppFontFamily.gilroyMedium,
          ),
        ),
        hBox(4),
        Text(
          'GHC 0.00',
          style: AppFontStyle.text_14_400(
            AppColors.greyTextColor,
            fontFamily: AppFontFamily.interRegular,
          ),
        ),
      ],
    );
  }

  Widget buildVariantsTable() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderClr),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount:controller.variants.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              endIndent: 10,
              indent: 10,
              color: AppColors.borderClr,
            ),
            itemBuilder: (context, index) {
              final variant =controller.variants[index];
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: AppContainer(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        borderRadius: BorderRadius.circular(8),
                        child: Text(
                          variant['color']!,
                          style: AppFontStyle.text_13_400(
                            AppColors.darkText,
                          ),
                        ),
                      ),
                    ),
                    wBox(8),
                    Expanded(
                      child: AppContainer(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 3, vertical: 2),
                        borderRadius: BorderRadius.circular(8),
                        child: Text(
                          variant['storage']!,
                          style: AppFontStyle.text_13_400(
                            AppColors.darkText,
                          ),
                        ),
                      ),
                    ),
                    wBox(8),
                    Expanded(
                      child: AppContainer(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        borderRadius: BorderRadius.circular(8),
                        child: Text(
                          variant['ram']!,
                          style: AppFontStyle.text_13_400(
                            AppColors.darkText,
                          ),
                        ),
                      ),
                    ),
                    wBox(8),
                    Expanded(
                      flex: 3,
                      child: Text(
                        '${variant['price']!} | ${variant['stock']!}',
                        textAlign: TextAlign.right,
                        style: AppFontStyle.text_13_400(
                          AppColors.greyTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
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
            child: Text(
              'Cancel',
              style: AppFontStyle.text_15_400(
                AppColors.darkText,
                fontFamily: AppFontFamily.gilroyMedium,
              ),
            ),
          ),
          wBox(12),
          Expanded(
            child: CustomElevatedButton(
              height: 40.h,
              borderRadius: BorderRadius.circular(8),
              onPressed: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.save_outlined,
                    color: Colors.white,
                    size: 18,
                  ),
                  wBox(8),
                  Text(
                    'Save Product',
                    style: AppFontStyle.text_15_400(
                      Colors.white,
                      fontFamily: AppFontFamily.gilroyMedium,
                    ),
                  ),
                ],
              ),
            ),
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
