import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/OrdersDetails/SubScreens/OrderDetails/controller/resaurant_order_details_controller.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../../../../Core/Constant/image_constant.dart';
import '../../../../../../../../Data/components/general_exception.dart';
import '../../../../../../../../Data/components/internet_exception.dart';
import '../../../../../../../../Data/response/status.dart';
import '../../../../../../../../Utils/date_format.dart';
import '../../../../../../../../Utils/sized_box.dart';
import '../../../../../../../../shared/theme/colors.dart';
import '../../../../../../../../shared/theme/font_family.dart';
import '../../../../../../../../shared/theme/font_style.dart';
import '../../../../../../../../shared/widgets/custom_appbar.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/circular_progress_indicator.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/custom_order_tacker.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/custom_review_list_tile.dart';

class VendorMoreOrderDetailsScreen extends StatelessWidget {
  VendorMoreOrderDetailsScreen({super.key});

  final RestaurantOrderDetailsController controller = Get.put(RestaurantOrderDetailsController());

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
          )),
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
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Padding(
                        padding: REdgeInsets.symmetric(horizontal: 22.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            hBox(8.h),
                            trackingBar(),
                            hBox(32.h),
                            productDetailsCard(),
                            Divider(height: 40.h),
                            hBox(10.h),
                            deliveryGuyCard(),
                            hBox(20.h),
                            deliveryAddress(),
                            if((controller.apiData.value.order?.deliverySoon?.isNotEmpty ??  false) && (controller.apiData.value.order?.deliveryNotes?.isNotEmpty ?? false) )...[
                            hBox(20.h),
                            deliveryNotesAndAsSoonAsPossible(),
                            ],
                            hBox(30.h),
                            orderAmountDetails(),
                           if(controller.apiData.value.order?.reviews != null)...[
                             Divider(
                               height: 35.h,
                               color: AppColors.textFieldBorder,
                               thickness: 0.7,
                             ),
                              reviews(),
                            ],
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
    );
  }

  trackingBar() {
    return Padding(
      padding: REdgeInsets.only(left: 3.w),
      child: Column(
        children: [
          TrackerStep(
            stepNumber: "01",
            title: 'Order received',
            isProcessing: false,
            isCompleted:
                controller.apiData.value.order?.status == "in_progress" ||
                        controller.apiData.value.order?.status == "completed" ||
                        controller.apiData.value.order?.status == "on_the_way"
                    ? true
                    : false,
            nextStepCompleted:
                controller.apiData.value.order?.status == "in_progress" ||
                        controller.apiData.value.order?.status == "completed" ||
                        controller.apiData.value.order?.status == "on_the_way"
                    ? true
                    : false,
          ),
          TrackerStep(
            stepNumber: "02",
            title: 'Processing',
            isProcessing:
                controller.apiData.value.order?.status == "in_progress"
                    ? true
                    : false,
            isCompleted:
                controller.apiData.value.order?.status == "in_progress" ||
                        controller.apiData.value.order?.status == "completed" ||
                        controller.apiData.value.order?.status == "on_the_way"
                    ? true
                    : false,
            nextStepCompleted:
                controller.apiData.value.order?.status == "in_progress" ||
                        controller.apiData.value.order?.status == "completed" ||
                        controller.apiData.value.order?.status == "on_the_way"
                    ? true
                    : false,
          ),
          TrackerStep(
            stepNumber: "03",
            title: 'On the way',
            isProcessing:
                controller.apiData.value.order?.status == "in_progress" ||
                        controller.apiData.value.order?.status == "on_the_way"
                    ? true
                    : false,
            isCompleted:
                controller.apiData.value.order?.status == "completed" ||
                        controller.apiData.value.order?.status == "on_the_way"
                    ? true
                    : false,
            nextStepCompleted:
                controller.apiData.value.order?.status == "completed"
                    ? true
                    : false,
          ),
          TrackerStep(
            stepNumber: "04",
            title: 'Delivered',
            isProcessing:
                controller.apiData.value.order?.status == "in_progress"
                    ? true
                    : false,
            isCompleted: controller.apiData.value.order?.status == "completed"
                ? true
                : false,
            nextStepCompleted: null,
          ),
        ],
      ),
    );
  }

  Widget  deliveryAddress() {
    final addressType = controller.apiData.value.order?.address?.addressType;
    return addressType != null ?  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        hBox(15.h),
        Text(
          "Delivery Address",
          style: AppFontStyle.text_20_600(
            AppColors.darkText,
            fontFamily: AppFontFamily.gilroyRegular,
          ),
        ),
        hBox(10.h),
        Text(
          addressType[0].toUpperCase() + addressType.substring(1),
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
          "${controller.apiData.value.order?.address?.houseDetails}",
          style: AppFontStyle.text_15_500(
            AppColors.mediumText,
            fontFamily: AppFontFamily.gilroyRegular,
          ),
          maxLines: 15,
        ),
        hBox(3.h),
        Text(
          "${controller.apiData.value.order?.address?.address}",
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
    )  : const SizedBox.shrink();
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
              double totalAmount =
                  double.tryParse(controller.apiData.value.order!.total!) ??
                      0.0;
              double deliveryCharges = double.tryParse(controller.deliveryCharges.value.toString()) ?? 0.0;
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
                                    ? "\$${totalAmount - deliveryCharges -deliveryTips}"
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

  Column deliveryGuyCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Delivery Guy",
          style: AppFontStyle.text_20_600(
            AppColors.darkText,
            fontFamily: AppFontFamily.gilroyRegular,
          ),
        ),
        hBox(16.h),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.r),
            color: AppColors.cardBgColor,
          ),
          child: Padding(
            padding: REdgeInsets.all(16.0),
            child: Column(
              children: [
                hBox(16.h),
                Container(
                  height: 80.h,
                  width: 80.w,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(40.r),
                      child: Image.asset(
                        ImageConstants.man,
                        width: 80.w,
                        height: 80.h,
                        fit: BoxFit.cover,
                      )),
                ),
                hBox(15.h),
                Text(
                  "Rainold Hawkins",
                  style: AppFontStyle.text_18_400(
                    AppColors.darkText,
                    fontFamily: AppFontFamily.gilroySemiBold,
                  ),
                ),
                hBox(10.h),
                Text(
                  "ID 412455",
                  style: AppFontStyle.text_15_400(
                    AppColors.lightText,
                    fontFamily: AppFontFamily.gilroyMedium,
                  ),
                ),
                hBox(10.h),
                Divider(
                  thickness: 1,
                  height: 30,
                  color: AppColors.textFieldBorder,
                ),
                hBox(4.h),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return orderTextTiles(
                      title: index == 0
                          ? "Phone Number"
                          : index == 1
                              ? "Delivery Date"
                              : index == 2
                                  ? "Delivery Time"
                                  : "",
                      trailing: index == 0
                          ? "+12 345 5662 66"
                          : index == 1
                              ? "12 Apr 2023"
                              : index == 2
                                  ? "12:52 AM"
                                  : "",
                    );
                  },
                  separatorBuilder: (context, index) => Divider(
                    thickness: 1,
                    height: 26.h,
                    color: AppColors.textFieldBorder,
                  ),
                  itemCount: 3,
                ),
                hBox(12.h),
              ],
            ),
          ),
        ),
      ],
    );
  }

  productDetailsCard() {
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

  orderTextTiles({String? title, String? trailing, Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(left: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title ?? "",
            style: AppFontStyle.text_14_400(
              AppColors.mediumText,
              fontFamily: AppFontFamily.gilroyMedium,
            ),
          ),
          Text(
            "$trailing",
            style: AppFontStyle.customText(
              color ?? AppColors.darkText,
              14.h,
              FontWeight.w500,
              fontFamily: AppFontFamily.gilroySemiBold,
            ),
          ),
        ],
      ),
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

  Widget reviews() {
    int ratingLength = int.tryParse(controller.apiData.value.order?.reviews?.rating.toString() ?? "0") ?? 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Review",
              style: AppFontStyle.text_20_600(
                AppColors.darkText,
                fontFamily: AppFontFamily.gilroyRegular,
              ),
            ),
          ],
        ),
        hBox(15.h),
        CustomReviewListTile(
        image: controller.apiData.value.order?.customer?.imageUrl ?? "",
        title: (controller.apiData.value.order?.customer?.firstName?.isEmpty ?? true) && (controller.apiData.value.order?.customer?.lastName?.isEmpty ?? true)
        ? ""
            : "${controller.apiData.value.order?.customer?.firstName ?? ""} ${controller.apiData.value.order?.customer?.lastName ?? ""}",
        description: controller.apiData.value.order?.reviews?.review ?? "",
        dateTime: FormatDate.formatDateString(controller.apiData.value.order?.reviews?.createdAt.toString() ?? ""),
        star:  List.generate(
        5,
        (index) => Icon(
        Icons.star,
        size: 19.h,
        color: index < ratingLength ? AppColors.goldStar : AppColors.starClr,
            ),
          ),
        ),
      ],
    );
  }
}
