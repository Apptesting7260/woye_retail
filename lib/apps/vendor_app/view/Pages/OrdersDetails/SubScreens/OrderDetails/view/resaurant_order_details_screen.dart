import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../../../../Data/components/general_exception.dart';
import '../../../../../../../../Data/components/internet_exception.dart';
import '../../../../../../../../Data/response/status.dart';
import '../../../../../../../../Utils/date_format.dart';
import '../../../../../../../../Utils/sized_box.dart';
import '../../../../../../../../Utils/validation.dart';
import '../../../../../../../../routes/vendor_routes/vendor_app_routes.dart';
import '../../../../../../../../shared/theme/colors.dart';
import '../../../../../../../../shared/theme/font_family.dart';
import '../../../../../../../../shared/theme/font_style.dart';
import '../../../../../../../../shared/widgets/custom_appbar.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/circular_progress_indicator.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/custom_elevated_button.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/custom_text_form_field.dart';
import '../controller/resaurant_order_details_controller.dart';

class RestaurantOrderDetailsScreen extends StatelessWidget {
  RestaurantOrderDetailsScreen({super.key});

  final RestaurantOrderDetailsController controller =
      Get.put(RestaurantOrderDetailsController());

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: SafeArea(
        child: Scaffold(
          appBar: CustomAppBar(
            title: Text(
              "Order Details",
              style: AppFontStyle.text_20_600(
                AppColors.darkText,
                fontFamily: AppFontFamily.gilroyRegular,
              ),
            ),
          ),
          body: Obx(
            () {
              switch (controller.rxRequestStatus.value) {
                case ApiStatus.LOADING:
                  return Center(child: circularProgressIndicator());
                case ApiStatus.ERROR:
                  if (controller.error.value == 'No internet') {
                    return InternetExceptionWidget(
                      onPress: () {
                        controller.singleOrdersApi();
                      },
                    );
                  } else {
                    return GeneralExceptionWidget(
                      onPress: () {
                        controller.singleOrdersApi();
                      },
                    );
                  }
                case ApiStatus.COMPLETED:
                  return RefreshIndicator(
                    onRefresh: () {
                      return controller.singleOrdersApi();
                    },
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: REdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            hBox(5.h),
                            header(),
                            hBox(15.h),
                            const Divider(),
                            hBox(15.h),
                            deliveryAddress(),
                            hBox(26.h),
                            if((controller.apiData.value.order?.deliverySoon?.isNotEmpty ??  false) && (controller.apiData.value.order?.deliveryNotes?.isNotEmpty ?? false) )...[
                            deliveryNotesAndAsSoonAsPossible(),
                            hBox(26.h),
                            ],
                            orderAmountDetails(),
                            hBox(26.h),
                            buttons(context),
                            hBox(30.h),
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
    );
  }

  Column orderAmountDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Order ID: ${controller.apiData.value.order?.orderId}",
          style: AppFontStyle.text_20_600(
            AppColors.darkText,
            fontFamily: AppFontFamily.gilroyRegular,
          ),
        ),
        hBox(14.h),
        ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              double totalAmount = double.tryParse(
                      controller.apiData.value.order?.total ?? "") ??
                  0.0;
              double deliveryCharges = double.tryParse(
                      controller.deliveryCharges.value.toString()) ??
                  0.0;
              double deliveryTips = double.tryParse(controller.apiData.value.order?.courierTip.toString() ?? "0.0") ?? 0.0;

              return allData(
                title: index == 0
                    ? "Customer"
                    : index == 1
                        ? "Date & Time"
                        : index == 2
                            ? "Status"
                            : index == 3
                                ? "Payment Method"
                                : index == 4
                                    ? "Subtotal"
                                    : index == 5
                                        ? "Discount"
                                        : index == 6
                                            ? "Delivery Charge"
                                        : index == 7
                                            ? "Delivery Tip"
                                            : "",
                trailing: index == 0
                    ? "${controller.apiData.value.order?.customer?.firstName ?? ''} ${controller.apiData.value.order?.customer?.lastName ?? ''}"
                    : index == 1
                        ? FormatDate.formatDateString(controller
                                .apiData.value.order?.createdAt
                                .toString() ??
                            "")
                        : index == 2
                            ? controller.apiData.value.order?.status ==
                                    'in_progress'
                                ? "In Process"
                                : controller.apiData.value.order?.status ==
                                        "completed"
                                    ? "Completed"
                                    : controller.apiData.value.order?.status ==
                                            "pending"
                                        ? "Pending"
                                        : controller.apiData.value.order
                                                    ?.status ==
                                                "cancelled"
                                            ? "Cancelled"
                                            : controller.apiData.value.order
                                                        ?.status ==
                                                    "on_the_way"
                                                ? "On the way"
                                                : controller
                                                    .apiData.value.order?.status
                            : index == 3
                                ? controller.apiData.value.order
                                            ?.paymentMethod ==
                                        "credit_card"
                                    ? "Credit Card"
                                    : controller.apiData.value.order
                                                ?.paymentMethod ==
                                            "Cash On Delivery"
                                        ? "COD"
                                        : controller.apiData.value.order
                                                    ?.paymentMethod ==
                                                "cash_on_delivery"
                                            ? "COD"
                                            : controller.apiData.value.order
                                                ?.paymentMethod
                                : index == 4
                                    ? "\$${totalAmount - deliveryCharges - deliveryTips}"
                                    : index == 5
                                        ? "${0.0}%"
                                        : index == 6
                                            ? "\$${controller.deliveryCharges.value}"
                                          : index == 7
                                            ? "\$${controller.apiData.value.order?.courierTip}"
                                            : "",
                color: index == 2
                    ? controller.apiData.value.order?.status == 'pending'
                        ? AppColors.yellow
                        : controller.apiData.value.order?.status == 'completed'
                            ? AppColors.blueClr
                            : controller.apiData.value.order?.status ==
                                    'cancelled'
                                ? AppColors.red
                                : AppColors.primary
                    : AppColors.darkText,
              );
            },
            separatorBuilder: (context, index) => hBox(15.h),
            itemCount: 8),
        hBox(15.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Order Total",
              style: AppFontStyle.text_16_400(
                AppColors.darkText,
                fontFamily: AppFontFamily.gilroySemiBold,
              ),
            ),
            Text(
              "\$${controller.apiData.value.order?.total}",
              style: AppFontStyle.text_16_400(
                AppColors.primary,
                fontFamily: AppFontFamily.gilroySemiBold,
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget deliveryAddress() {
    final addressType = controller.apiData.value.order?.address?.addressType;
    return addressType != null ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Delivery Address",
          style: AppFontStyle.text_20_600(
            AppColors.darkText,
            fontFamily: AppFontFamily.gilroyRegular,
          ),
        ),
        hBox(10.h),
        Text(
          "${addressType[0].toUpperCase()}${addressType.substring(1)}",
          style: AppFontStyle.text_15_400(
            AppColors.primary,
            fontFamily: AppFontFamily.gilroyMedium,
          ),
        ),
        hBox(8.h),
        Text(
          controller.apiData.value.order?.address?.fullName ?? "",
          style: AppFontStyle.text_15_400(
            AppColors.darkText,
            fontFamily: AppFontFamily.gilroySemiBold,
          ),
        ),
        hBox(11.h),
        Text(
          controller.apiData.value.order?.address?.houseDetails ?? "",
          style: AppFontStyle.text_15_500(
            AppColors.mediumText,
            fontFamily: AppFontFamily.gilroyRegular,
          ),
          maxLines: 15,
        ),
        hBox(3.h),
        Text(
          controller.apiData.value.order?.address?.address ?? "",
          style: AppFontStyle.text_15_500(
            AppColors.mediumText,
            fontFamily: AppFontFamily.gilroyRegular,
          ),
          maxLines: 15,
        ),
        hBox(11.h),
        Text(
          "${controller.apiData.value.order?.address?.countryCode} ${controller.apiData.value.order?.address?.phoneNumber} ",
          style: AppFontStyle.text_15_400(
            AppColors.darkText,
            fontFamily: AppFontFamily.gilroyMedium,
          ),
        ),
      ],
    ) : const SizedBox.shrink();
  }

  header() {
    return Obx(
      () => ListView.separated(
        shrinkWrap: true,
        itemCount:
            controller.apiData.value.order?.decodedAttribute?.length ?? 0,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: CachedNetworkImage(
                      imageUrl: controller.apiData.value.order
                              ?.decodedAttribute?[index].productImage ??
                          "",
                      height: 80.h,
                      width: 80.w,
                      fit: BoxFit.fill,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: AppColors.bgColor,
                        highlightColor: AppColors.lightText,
                        child: Container(
                          height: 80.h,
                          width: 80.w,
                          decoration: BoxDecoration(
                            color: AppColors.grey,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                      ),
                    ),
                  ),
                  wBox(13.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.apiData.value.order?.decodedAttribute?[index]
                                .productName ??
                            "",
                        style: AppFontStyle.text_16_400(
                          AppColors.darkText,
                          fontFamily: AppFontFamily.gilroySemiBold,
                        ),
                      ),
                      hBox(2.h),
                      Text(
                        "\$${controller.apiData.value.order?.decodedAttribute?[index].price}",
                        style: AppFontStyle.text_15_400(
                          AppColors.mediumText,
                          fontFamily: AppFontFamily.gilroyMedium,
                        ),
                      ),
                      hBox(5.h),
                      Text(
                        "Qty: ${controller.apiData.value.order?.decodedAttribute?[index].quantity}",
                        style: AppFontStyle.text_14_400(
                          AppColors.mediumText,
                          fontFamily: AppFontFamily.gilroyMedium,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (controller.apiData.value.order?.decodedAttribute?[index]
                      .attribute?.isNotEmpty ??
                  false)
                hBox(12.h),
              if (controller.apiData.value.order?.decodedAttribute?[index]
                      .attribute?.isNotEmpty ??
                  false)
                Text(
                  "Attributes",
                  style: AppFontStyle.text_16_400(
                    AppColors.darkText,
                    fontFamily: AppFontFamily.gilroySemiBold,
                  ),
                ),
              if (controller.apiData.value.order?.decodedAttribute?[index]
                      .attribute?.isNotEmpty ??
                  false)
                hBox(8.h),
              ListView.separated(
                itemCount: controller.apiData.value.order
                        ?.decodedAttribute?[index].attribute?.length ??
                    0,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index1) {
                  return allData(
                    title: controller
                            .apiData
                            .value
                            .order
                            ?.decodedAttribute?[index]
                            .attribute?[index1]
                            .itemDetails
                            ?.itemName ??
                        "",
                    trailing:
                        "\$${controller.apiData.value.order?.decodedAttribute?[index].attribute?[index1].itemDetails?.itemPrice ?? ""}",
                  );
                },
                separatorBuilder: (context, index) => hBox(12.h),
              ),
              if (controller.apiData.value.order?.decodedAttribute?[index]
                      .addons?.isNotEmpty ??
                  false)
                hBox(15.h),
              if (controller.apiData.value.order?.decodedAttribute?[index]
                      .addons?.isNotEmpty ??
                  false)
                Text(
                  "Addons",
                  style: AppFontStyle.text_16_400(
                    AppColors.darkText,
                    fontFamily: AppFontFamily.gilroySemiBold,
                  ),
                ),
              if (controller.apiData.value.order?.decodedAttribute?[index]
                      .addons?.isNotEmpty ??
                  false)
                hBox(8.h),
              ListView.separated(
                itemCount: controller.apiData.value.order
                        ?.decodedAttribute?[index].addons?.length ??
                    0,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index1) {
                  return allData(
                    title: controller.apiData.value.order
                            ?.decodedAttribute?[index].addons?[index1].name ??
                        "",
                    trailing:
                        "\$${controller.apiData.value.order?.decodedAttribute?[index].addons?[index1].price ?? ""}",
                  );
                },
                separatorBuilder: (context, index) => hBox(12.h),
              ),
            ],
          );
        },
        separatorBuilder: (context, index) => Divider(height: 40.h),
      ),
    );
  }

  orderTextTile(String title, String titleDetail, {bool isDark = true}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppFontStyle.text_15_400(AppColors.lightText),
        ),
        Text(
          titleDetail,
          style: AppFontStyle.text_15_400(
              isDark ? AppColors.darkText : AppColors.yellow),
        ),
      ],
    );
  }

  buttons(context) {
    return controller.apiData.value.order?.status == "completed"
        ? CustomElevatedButton(
              height: 55,
              color: AppColors.primary,
              onPressed: () {
                Get.toNamed(VendorAppRoutes.restaurantMoreOrderDetailsScreen);
              },
              text: "Order Delivered",
            )
        : controller.apiData.value.order?.status == 'cancelled'
            ? CustomElevatedButton(
                  height: 55,
                  color: AppColors.darkText,
                  onPressed: () {},
                  text: "Order Cancelled",
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if(controller.apiData.value.order?.status == 'pending')...[
                  Expanded(
                    child: CustomElevatedButton(
                        /*isLoading:controller.rxRequestRejectOrderStatus.value == ApiStatus.LOADING,*/
                        height: 55,
                        color: AppColors.darkText,
                        onPressed: () {
                          showDialog(context: context,
                            barrierDismissible: false,
                            // useSafeArea: false,
                            builder: (context) {
                              return PopScope(
                                canPop: false,
                                child: Stack(
                                  children: [
                                    AlertDialog(
                                        insetPadding: const EdgeInsets.symmetric(horizontal: 22),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        contentPadding: EdgeInsets.zero,
                                        backgroundColor: AppColors.white,
                                        content:Stack(children:[
                                          addCancelProductNotes(context),
                                          Positioned(
                                            right: 0,
                                            top: 0,
                                            child: IconButton(onPressed: (){
                                              Get.back();
                                            }, icon:  Icon(Icons.cancel,color: AppColors.primary,size: 26,)),
                                          ),
                                        ])
                                    ),

                                  ],
                                ),
                              );
                            },);
                        },
                        text: "Cancel",
                      ),
                    ),
                  if(controller.apiData.value.order?.status == 'pending')
                  wBox(15.w),
                  ],
                  Expanded(
                    child: Obx(
                      () => SizedBox(
                        width: double.infinity,
                        child: CustomElevatedButton(
                          // isLoading:
                          //     controller.rxRequestAcceptOrderStatus.value ==
                          //         ApiStatus.LOADING,
                          height: 55.h,width: Get.width,
                          color: AppColors.primary,
                          onPressed: () {
                            if (controller.apiData.value.order?.status ==
                                'pending') {
                              // controller.acceptOrderApi();
                            } else {
                              Get.toNamed(
                                  VendorAppRoutes.restaurantMoreOrderDetailsScreen);
                            }
                          },
                          text:
                              controller.apiData.value.order?.status == 'pending'
                                  ? "Accept"
                                  : "Accepted",
                        ),
                      ),
                    ),
                  ),
                ],
              );
  }

  Widget deliveryNotesAndAsSoonAsPossible() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Other Details",
          style: AppFontStyle.text_20_600(
            AppColors.darkText,
            fontFamily: AppFontFamily.gilroyRegular,
          ),
        ),
        if(controller.apiData.value.order?.deliveryNotes?.isNotEmpty ?? false)...[
        hBox(15.h),
        allData(title: "Delivery Notes",trailing: controller.apiData.value.order?.deliveryNotes ?? "",maxLine: 20),
        ],
        if( controller.apiData.value.order?.deliverySoon?.isNotEmpty ?? false)...[
        hBox(15.h),
        allData(title: "Delivery Soon",trailing: controller.apiData.value.order?.deliverySoon ?? ""),
      ],
    ],
    );
  }

  allData({String? title, String? trailing, Color? color,int? maxLine}) {
    return Padding(
      padding: const EdgeInsets.only(left: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              title ?? "",
              style: AppFontStyle.text_14_400(
                AppColors.mediumText,
                fontFamily: AppFontFamily.gilroyMedium,
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "$trailing",
                maxLines: maxLine,
                style: AppFontStyle.customText(
                  color ?? AppColors.darkText,
                  15.h,
                  FontWeight.w500,
                  fontFamily: AppFontFamily.gilroyMedium,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  addCancelProductNotes(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Stack(
        children: [
              Form(
                key: controller.addCancelNotes,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    hBox(30.h),
                    Center(child: Text("Cancel Product",style:  AppFontStyle.text_22_600(AppColors.black, fontFamily: AppFontFamily.gilroyRegular,),)),
                    hBox(20.h),
                    Padding(
                      padding: REdgeInsets.symmetric(horizontal: 25.0),
                      child: CustomTextFormField(
                        controller: controller.cancelProductController.value,
                        hintText: 'Enter a reason for cancelling the product.',
                        onTapOutside: (value){
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        validator: (value) {
                          if(value == null || value.isEmpty){
                            return "Please enter reason";
                          }
                          if (!isValidCharacters(value)) {
                            return "Please enter a valid reason (only A-Z, a-z, and numbers 1-10 allowed)";
                          }
                          return null;
                        },
                      ),
                    ),
                    hBox(13.h),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Obx(
                        ()=> CustomElevatedButton(
                          isLoading: controller.rxRequestRejectOrderStatus.value ==  ApiStatus.LOADING,
                          width: 145.w,
                          height: 50.h,
                          onPressed: () {
                            if(controller.addCancelNotes.currentState?.validate() ?? false){
                             controller.rejectOrderApi();
                            }
                          },
                          text: "Cancel",
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    hBox(30.h),
                  ],
                ),
              ),
        ],
      ),
    );
  }

}
