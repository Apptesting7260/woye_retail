import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gyaawa/Data/components/general_exception.dart';
import 'package:gyaawa/Data/components/internet_exception.dart';
import 'package:gyaawa/apps/vendor_app/view/vendor_common/order_transaction_details/controller/order_transaction_details_controller.dart';

import '../../../../../../Data/response/status.dart';
import '../../../../../../Utils/sized_box.dart';
import '../../../../../../shared/theme/colors.dart';
import '../../../../../../shared/theme/font_family.dart';
import '../../../../../../shared/theme/font_style.dart';
import '../../../../../../shared/widgets/custom_appbar.dart';
import '../../../../../../shared/widgets/shimmer_widget.dart';
import '../../../../../../shared/widgets/vendor_widgets/custom_dropdown.dart';
import '../../../../../../shared/widgets/vendor_widgets/custom_no_result_found.dart';
import '../../../../../../shared/widgets/vendor_widgets/print.dart';


class OrderTransactionDetailsScreen extends StatefulWidget {
  const OrderTransactionDetailsScreen({super.key});

  @override
  State<OrderTransactionDetailsScreen> createState() => _OrderTransactionDetailsScreenState();
}

class _OrderTransactionDetailsScreenState extends State<OrderTransactionDetailsScreen> {
  final controller = Get.find<OverviewOrderTransactionDetailsController>();

  @override
  void initState() {
    super.initState();
    final args = Get.arguments ?? {};
    pt("args['earningType'] ${args['earningType']}");
    controller.setType(args['earningType'] ?? "");
    controller.getTransactionData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          "Earning Details",
          style: AppFontStyle.text_22_500(
            AppColors.darkText,
            fontFamily: AppFontFamily.gilroyMedium,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Column(
          children: [
            Obx(
              () => CustomDropDown(
                showClearButton: false,
                borderRadius: 10,
                filledClr: AppColors.white,
                border: Border.all(color: AppColors.borderClrDropdown),
                btnHeight: 50,
                selectedValue: controller.type.value,
                hintText: "Please select transaction type",
                items: controller.orderType,
                hintStyle: AppFontStyle.text_14_400(
                  AppColors.blackClr,
                  fontFamily: AppFontFamily.gilroyMedium,
                ),
                textStyle: AppFontStyle.text_14_400(
                  AppColors.blackClr,
                  fontFamily: AppFontFamily.gilroyMedium,
                ),
                onChanged: (value) {
                  pt(value.toString());
                  controller.setType(value ?? "");
                  controller.getTransactionData();
                },
              ),
            ),
            hBox(14.h),
            Expanded(
              child: Obx(() {
                switch (controller.transactionData.value.status) {
                  case ApiStatus.LOADING:
                    return orderTransactionShimmer();
                  case ApiStatus.ERROR:
                    if (controller.transactionData.value.message ==
                            'No internet' ||
                        controller.transactionData.value.message ==
                            'InternetExceptionWidget') {
                      return InternetExceptionWidget(
                        onPress: () {
                          controller.getTransactionData();
                        },
                      );
                    } else {
                      return GeneralExceptionWidget(
                        onPress: () {
                          controller.getTransactionData();
                        },
                      );
                    }
                  case ApiStatus.COMPLETED:
                    return (controller.transactionData.value.data?.data?.isEmpty  ?? false)
                        ? CustomNoResultFound(heightBox: hBox(20)) :
                    Padding(
                      padding: const EdgeInsets.only(bottom: 18.0),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: controller
                                .transactionData.value.data?.data?.length ??
                            0,
                        separatorBuilder: (_, __) => SizedBox(height: 10.h),
                        itemBuilder: (context, index) {
                          final item = controller
                              .transactionData.value.data?.data?[index];
                          final type = item?.paymentType?.toLowerCase() ?? "";
                          final paymentStatus = item?.paymentStatus?.toLowerCase() ?? "";
                          final color = controller.getColors(paymentStatus);

                          return Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.w, vertical: 12.h),
                            decoration: BoxDecoration(
                              color: color.withAlpha(12),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 4.w,
                                  height: 44.h,
                                  decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Container(
                                  padding: EdgeInsets.all(10.w),
                                  decoration: BoxDecoration(
                                    color: color.withAlpha(24),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Icon(
                                    controller.getIcons(paymentStatus),
                                    color: color,
                                    size: 20.sp,
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item?.paymentType?.capitalize ?? "",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppFontStyle.text_14_400(
                                          AppColors.blackClr,
                                          fontFamily:
                                              AppFontFamily.gilroySemiBold,
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        "${item?.orderId ?? item?.method?.capitalize ?? ""} • ${item?.formattedCreatedAt ?? ""}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppFontStyle.text_13_400(
                                          AppColors.greyClr,
                                          fontFamily: AppFontFamily.gilroyRegular,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    paymentStatus == "paid"
                                        ? "+\$${item?.total ?? "0"}"
                                        : "\$${item?.total ?? "0"}",
                                    style: AppFontStyle.text_14_400(
                                      paymentStatus == "paid"
                                          ? AppColors.greenClrRatingBar
                                          : color,
                                      fontFamily: AppFontFamily.gilroySemiBold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );

                  default:
                    return const SizedBox();
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget orderTransactionShimmer() {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: 10,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        return Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            children: [
              /// LEFT BAR
              ShimmerBox(
                width: 4,
                height: 44,
                radius: 4,
              ),

              SizedBox(width: 12),

              /// ICON
              ShimmerBox(
                width: 40,
                height: 40,
                radius: 8,
              ),

              SizedBox(width: 12),

              /// TEXT
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerBox(
                      width: double.infinity,
                      height: 12,
                      radius: 6,
                    ),
                    SizedBox(height: 6),
                    ShimmerBox(
                      width: 150,
                      height: 10,
                      radius: 6,
                    ),
                  ],
                ),
              ),

              SizedBox(width: 8),

              /// PRICE
              ShimmerBox(
                width: 50,
                height: 12,
                radius: 6,
              ),
            ],
          ),
        );
      },
    );
  }
}
