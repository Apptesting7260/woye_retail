import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../../../../Data/response/status.dart';
import '../../../../../../../../Utils/sized_box.dart';
import '../../../../../../../../routes/vendor_routes/vendor_app_routes.dart';
import '../../../../../../../../shared/theme/colors.dart';
import '../../../../../../../../shared/theme/font_family.dart';
import '../../../../../../../../shared/theme/font_style.dart';
import '../../../../../../../../shared/widgets/custom_appbar.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/circular_progress_indicator.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/custom_delete_alert_dialog.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/custom_elevated_button.dart';
import '../controller/restro_product_details_controller.dart';

class RestaurantProductDetailsScreen extends StatelessWidget {
  RestaurantProductDetailsScreen({super.key});

  final ProductDetailsController productDetailsController =
      Get.put(ProductDetailsController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        color: AppColors.white,
        child: SafeArea(
          child: Scaffold(
            appBar: const CustomAppBar(),
            body: productDetailsController.rxRequestSingleProductStatus.value == ApiStatus.LOADING
                ? Center(child: circularProgressIndicator())
                : SingleChildScrollView(
                    child: Padding(
                      padding: REdgeInsets.symmetric(horizontal: 22),
                      child: Column(
                        children: [
                          hBox(8.h),
                          productTile(),
                          hBox(15),
                          // productDetails(),
                          hBox(20.h),
                          editDeleteButton(context),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Row productTile() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        child: CachedNetworkImage(
            imageUrl: "productDetailsController.apiSingleProductData.value.product?.urlImage" ?? "",
            height: 80.h,
            width: 80.w,
            fit: BoxFit.fill,
            placeholder: (context, url) => Shimmer.fromColors(
              baseColor: AppColors.bgColor,
              highlightColor: AppColors.lightText,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.grey,
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
            ),
          ),
        ),
        wBox(13.h),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 180),
              child: Text(
                productDetailsController.apiSingleProductData.value.product?.title
                    .toString() ?? "",
                style: AppFontStyle.text_16_400(
                  AppColors.darkText,
                  fontFamily: AppFontFamily.gilroySemiBold,
                ),
              ),
            ),
            hBox(2),
            Text(
              "\$${productDetailsController.apiSingleProductData.value.product?.salePrice ?? productDetailsController.apiSingleProductData.value.product?.regularPrice}",
              style: AppFontStyle.text_15_400(
                AppColors.mediumText,
                fontFamily: AppFontFamily.gilroyMedium,
              ),
            ),
            hBox(3),
          ],
        ),
      ],
    );
  }



  Row editDeleteButton(BuildContext context) {
    return Row(
      children: [
        CustomElevatedButton(
          width: 105,
          height: 43,
          color: AppColors.black,
          onPressed: () {
            Get.toNamed(
              VendorAppRoutes.restaurantEditProductScreen,
              arguments: productDetailsController.productId.value,
            );
          },
          text: "Edit",
        ),
        wBox(15),
        CustomElevatedButton(
          width: 105,
          height: 43,
          color: AppColors.primary,
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => CustomDeleteAlertDialog(
                title: "Delete",
                subtitle: "Are you sure you delete this product",
                cancelOnTap: () {
                  Get.back();
                },
                deleteOnTap: () {
                  Get.back();
                },
              ),
            );
          },
          text: 'Delete',
        ),
      ],
    );
  }
}
