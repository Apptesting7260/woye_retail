import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/menu/controller/vendor_menu_item_details_controller.dart';
import '../../../../../../Core/Constant/image_constant.dart';
import '../../../../../../Data/components/general_exception.dart';
import '../../../../../../Data/components/internet_exception.dart';
import '../../../../../../Data/response/status.dart';
import '../../../../../../Utils/sized_box.dart';
import '../../../../../../shared/theme/colors.dart';
import '../../../../../../shared/theme/font_family.dart';
import '../../../../../../shared/theme/font_style.dart';
import '../../../../../../shared/widgets/custom_appbar.dart';
import '../../../../../../shared/widgets/image.dart';
import '../../../../../../shared/widgets/shimmer_widget.dart';
import '../../Products/Sub_screen/EditProduct/Model/res_single_product_model.dart';

class VendorMenuItemDetailsScreen  extends GetView<VendorMenuItemDetailsController> {
  const VendorMenuItemDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: RefreshIndicator(
        onRefresh: () {
          return controller.getSingleProductApi(productId: controller.productId.value);
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Obx(() {
              switch(controller.apiData.value.status) {
                case ApiStatus.LOADING:
                  return loadingShimmer();
                case ApiStatus.ERROR:
                  if (controller.error.value == 'No internet' || controller.error.value  == 'InternetExceptionWidget') {
                    return InternetExceptionWidget(
                      onPress: () {
                        controller.getSingleProductApi(productId: controller.productId.value);
                      },
                    );
                  } else {
                    return Padding(
                      padding: EdgeInsets.only(top: Get.height * 0.15),
                      child: GeneralExceptionWidget(
                        onPress: () {
                          controller.getSingleProductApi(productId: controller.productId.value);
                        },
                      ),
                    );
                  }
                case ApiStatus.COMPLETED:
                  final product = controller.apiData.value.data?.product;
                  return body(product);
                default:
                  return const SizedBox.shrink();
              }
            }),
          ),
        ),
      ),
    );
  }

  Widget body(Product? product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        mainImage(product),
        hBox(14),
        additionalImage(product),
        hBox(16),
        Text(product?.title?.capitalize.toString() ?? "",
          style: AppFontStyle.text_20_600(
          AppColors.darkText,
          fontFamily: AppFontFamily.gilroyRegular,
        ),
        ),
        Text(product?.description ?? "",
          maxLines: 6,
          overflow: TextOverflow.ellipsis,
          style: AppFontStyle.text_15_400(
          AppColors.greyClr,
          fontFamily: AppFontFamily.gilroyMedium,
        ),
        ),
        hBox(8),
        ratingAndOrders(product),
        hBox(12),
        statusAndAmount(product),
        hBox(20),
        categoryCuisine(product),
        hBox(20),
        availabilityPreparation(product),
        hBox(20),
        Text("Dietary Information",style: AppFontStyle.text_15_400(AppColors.black,fontFamily: AppFontFamily.gilroyMedium)),
        hBox(2),
        Text(product?.productAttributeName ?? "No special dietary attributes",maxLines: 10,style: AppFontStyle.text_14_400(AppColors.greyClr,fontFamily: AppFontFamily.gilroyMedium)),
        hBox(20),
        // Text("Allergen Information",style: AppFontStyle.text_16_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroySemiBold)),
        // hBox(8),
        // Container(
        //   decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(40),
        //       color:AppColors.yellowClr.withAlpha(20),
        //     border: Border.all(color: AppColors.yellowClr,width: 1)
        //   ),
        //   padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 4),
        //   child: Text(
        //     "Fish",
        //     style: AppFontStyle.text_13_400(
        //        AppColors.yellowClr,
        //       fontFamily: AppFontFamily.gilroyMedium,
        //     ),
        //   ),
        // ),
        // hBox(25),
        performanceStatics(),
        hBox(50),
      ],
    );
  }

  Widget performanceStatics() {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: AppColors.borderClr.withAlpha(150),blurRadius: 0.001),
        ]
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Performance Statistics",style: AppFontStyle.text_16_400(AppColors.black,fontFamily: AppFontFamily.gilroySemiBold)),
            hBox(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: AppColors.white,
                  ),
                  child:  Column(
                    children: [
                      Text( controller.apiData.value.data?.product?.performanceStats?.totalOrders ?? "",style: AppFontStyle.text_20_600(AppColors.primary,fontFamily: AppFontFamily.gilroyMedium)),
                      Text("Total Orders",style: AppFontStyle.text_14_400(AppColors.greyClr,fontFamily: AppFontFamily.gilroyMedium)),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: AppColors.white,
                  ),
                  child:  Column(
                    children: [
                      Text(controller.apiData.value.data?.product?.performanceStats?.averageRating ?? "",style: AppFontStyle.text_20_600(AppColors.primary,fontFamily: AppFontFamily.gilroyMedium)),
                      Text("Average Rating",style: AppFontStyle.text_14_400(AppColors.greyClr,fontFamily: AppFontFamily.gilroyMedium)),
                    ],
                  ),
                ),
              ],
            ),
            hBox(22),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("\$${double.tryParse(controller.apiData.value.data?.product?.performanceStats?.totalRevenue ?? "0")?.toStringAsFixed(2) ?? ""}",style: AppFontStyle.text_20_600(AppColors.primary,fontFamily: AppFontFamily.gilroyMedium)),
                  Text("Total Revenue",style: AppFontStyle.text_14_400(AppColors.greyClr,fontFamily: AppFontFamily.gilroyMedium)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget availabilityPreparation(Product? product) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Availability",style: AppFontStyle.text_14_400(AppColors.greyClr,fontFamily: AppFontFamily.gilroyMedium)),
              Text(product?.menuSection?.capitalizeFirst.toString() ?? "",style: AppFontStyle.text_16_400(AppColors.black,fontFamily: AppFontFamily.gilroyMedium)),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Preparation Time",style: AppFontStyle.text_14_400(AppColors.greyClr,fontFamily: AppFontFamily.gilroyMedium)),
              Text(product?.preparationTime?.capitalizeFirst.toString() ?? "",style: AppFontStyle.text_16_400(AppColors.black,fontFamily: AppFontFamily.gilroyMedium)),
            ],
          ),
        ),
      ],
    );
  }

  Widget categoryCuisine(Product? product) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Category",style: AppFontStyle.text_14_400(AppColors.greyClr,fontFamily: AppFontFamily.gilroyMedium)),
              Text(product?.categoryName ?? "",style: AppFontStyle.text_16_400(AppColors.black,fontFamily: AppFontFamily.gilroyMedium)),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Cuisine Type",style: AppFontStyle.text_14_400(AppColors.greyClr,fontFamily: AppFontFamily.gilroyMedium)),
              Text(product?.cuisineName ?? "",style: AppFontStyle.text_16_400(AppColors.black,fontFamily: AppFontFamily.gilroyMedium)),
            ],
          ),
        ),
      ],
    );
  }

  Widget statusAndAmount(Product? product) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
              color:product?.status == "active" ?  AppColors.primary.withAlpha(60) : AppColors.red.withAlpha(40)
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 3),
          child: Text(
            product?.status?.capitalizeFirst.toString() ?? "",
            style: AppFontStyle.text_13_400(
              product?.status == "active" ? AppColors.primary : AppColors.red,
              fontFamily: AppFontFamily.gilroyMedium,
            ),
          ),
        ),
        wBox(14),
        Text("\$${product?.salePrice ?? product?.regularPrice}",style: AppFontStyle.text_22_600(AppColors.primary,fontFamily: AppFontFamily.gilroyMedium))
      ],
    );
  }

  Widget ratingAndOrders(Product? product) {
    return Row(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppImage(path: ImageConstants.starLogo,color: AppColors.goldStar,height: 18,width: 18),
            wBox(6),
            Text("${product?.rating == "0.00" ? "0.0" : product?.rating ?? 0.0} rating",
              maxLines: 10,
              style: AppFontStyle.text_15_400(
                AppColors.greyClr,
                fontFamily: AppFontFamily.gilroyMedium,
              ),
            ),
          ],
        ),
        wBox(20),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppImage(path: ImageConstants.users,height: 18,width: 18),
            wBox(6),
            Text("${product?.performanceStats?.totalOrders == "0.00" ? "0.0" : product?.performanceStats?.totalOrders ?? 0.0} orders",
              maxLines: 10,
              style: AppFontStyle.text_15_400(
                AppColors.greyClr,
                fontFamily: AppFontFamily.gilroyMedium,
              ),
            ),
          ],
        ),
      ],
    );
  }

  GridView additionalImage(Product? product) {
    return GridView.builder(
      itemCount: 4,
      // always 4 boxes
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
      ),
      itemBuilder: (context, index) {
        final imagePath = (product?.addimgUrl != null && index < product!.addimgUrl!.length)
            ? product.addimgUrl![index]
            : null;

        return SizedBox(
          height: 248,
          child: DottedBorder(
            strokeCap: StrokeCap.square,
            borderType: BorderType.RRect,
            radius: const Radius.circular(12),
            padding: const EdgeInsets.all(6),
            dashPattern: const [5],
            strokeWidth: 1.5,
            color: AppColors.borderClr,
            child: Center(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.all(Radius.circular(12)),
                child: imagePath != null && imagePath.isNotEmpty
                    ? AppImage(
                        path: imagePath,
                        height: 248,
                        width: Get.width,
                        fit: BoxFit.fill,
                      )
                    : Container(
                        width: 50,
                        height: 50,
                        color: AppColors.transparent,
                        child: AppImage(path: ImageConstants.noDataImage),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  SizedBox mainImage(Product? product) {
    return SizedBox(
      height: 248,
      child: DottedBorder(
        strokeCap: StrokeCap.square,
        borderType: BorderType.RRect,
        radius: const Radius.circular(12),
        padding: const EdgeInsets.all(6),
        dashPattern: const [5],
        strokeWidth: 1.5,
        color: AppColors.borderClr,
        child: Center(
          child: ClipRRect(
            borderRadius:
                const BorderRadius.all(Radius.circular(12)),
            child: AppImage(
                path: product?.imageUrl ?? "",
                height: 248,
                width: Get.width,
                fit: BoxFit.fill),
          ),
        ),
      ),
    );
  }

  CustomAppBar _appBar() {
    return CustomAppBar(
      centetTitle: true,
      title: Text(
        "Menu Item Details",
        style: AppFontStyle.text_20_600(
          AppColors.darkText,
          fontFamily: AppFontFamily.gilroyMedium,
        ).copyWith(height: 1.0),
      ),
    );
  }

  Widget loadingShimmer() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main Image
          ShimmerBox(width: Get.width, height: 248, radius: 12),
          const SizedBox(height: 14),

          // Additional Images Grid (4 boxes)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
            ),
            itemBuilder: (context, index) {
              return const ShimmerBox(width: double.infinity, height: 120, radius: 12);
            },
          ),
          const SizedBox(height: 16),

          // Title
          ShimmerBox(width: Get.width * 0.6, height: 20),
          const SizedBox(height: 8),

          // Description (3 lines)
          ShimmerBox(width: Get.width * 0.8, height: 14),
          const SizedBox(height: 4),
          ShimmerBox(width: Get.width * 0.7, height: 14),
          const SizedBox(height: 4),
          ShimmerBox(width: Get.width * 0.5, height: 14),
          const SizedBox(height: 12),

          // Rating and Orders
          const Row(
            children: [
              ShimmerBox(width: 60, height: 14),
              SizedBox(width: 20),
              ShimmerBox(width: 60, height: 14),
            ],
          ),
          const SizedBox(height: 12),

          // Status and Amount
          const Row(
            children: [
              ShimmerBox(width: 60, height: 20, radius: 40),
              SizedBox(width: 14),
              ShimmerBox(width: 80, height: 20, radius: 8),
            ],
          ),
          const SizedBox(height: 20),

          // Category & Cuisine
          const Row(
            children: [
              ShimmerBox(width: 80, height: 16),
              SizedBox(width: 20),
              ShimmerBox(width: 80, height: 16),
            ],
          ),
          const SizedBox(height: 20),

          // Availability & Preparation
          const Row(
            children: [
              ShimmerBox(width: 80, height: 16),
              SizedBox(width: 20),
              ShimmerBox(width: 80, height: 16),
            ],
          ),
          const SizedBox(height: 20),

          // Dietary & Allergen info
          const ShimmerBox(width: 120, height: 14),
          const SizedBox(height: 8),
          const ShimmerBox(width: 80, height: 14),
          const SizedBox(height: 25),

          // Performance Stats Box
          ShimmerBox(width: Get.width, height: 150, radius: 12),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

}
