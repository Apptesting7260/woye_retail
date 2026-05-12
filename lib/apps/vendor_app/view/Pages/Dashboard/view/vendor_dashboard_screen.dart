import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gyaawa/Utils/account_type_card.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/Dashboard/controller/vendor_dashboard_controller.dart';
import 'package:gyaawa/apps/vendor_app/view/vendor_navbar/controller/vendor_navbar_controller.dart';
import 'package:gyaawa/routes/vendor_routes/vendor_app_routes.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../../Core/Constant/image_constant.dart';
import '../../../../../../Data/components/general_exception.dart';
import '../../../../../../Data/components/internet_exception.dart';
import '../../../../../../Data/response/status.dart';
import '../../../../../../Utils/sized_box.dart';
import '../../../../../../shared/theme/colors.dart';
import '../../../../../../shared/theme/font_family.dart';
import '../../../../../../shared/theme/font_style.dart';
import '../../../../../../shared/widgets/image.dart';
import '../../../../../../shared/widgets/shimmer_widget.dart';
import '../../../../../../shared/widgets/vendor_widgets/app_container.dart';
import '../../../../../../shared/widgets/vendor_widgets/custom_details_card.dart';
import '../../../../../../shared/widgets/vendor_widgets/custom_dropdown.dart';
import '../../../../../../shared/widgets/vendor_widgets/custom_text_form_field.dart';
import '../../../../../../shared/widgets/vendor_widgets/print.dart';
import '../../../vendor_common/chart/common_chart.dart';
import '../../../vendor_common/common_appbar_header/common_appbar_header.dart';



class VendorDashboardScreen extends StatefulWidget {
  const VendorDashboardScreen({super.key});

  @override
  State<VendorDashboardScreen> createState() =>
      _VendorDashboardScreenState();
}

class _VendorDashboardScreenState extends State<VendorDashboardScreen> {

  final VendorDashboardController controller = Get.find<VendorDashboardController>();
  // final FillRestaurantDetailsController fillResController = Get.put(FillRestaurantDetailsController());

  @override
  void initState() {
    super.initState();
    // fillResController.getProfileDetailsApi();
    controller.getInitData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
         appBar: const CommonAppbarHeader(
            title: "Dashboard",
           // controller: Get.find<FillRestaurantDetailsController>(),
          ),
          body: Obx(
          () {
            switch (controller.rxRequestStatus.value) {
              case ApiStatus.LOADING:
                return shimmerLoadingBody();
              case ApiStatus.ERROR:
                if (controller.error.value == 'No internet' || controller.error.value == 'InternetExceptionWidget') {
                  return InternetExceptionWidget(
                    onPress: () {
                      controller.getInitData();
                      controller.fillRestaurantDetailsController.getProfileDetailsApi();
                    },
                  );
                } else {
                  return GeneralExceptionWidget(
                    onPress: () {
                      controller.getInitData();
                      controller.fillRestaurantDetailsController.getProfileDetailsApi();
                    },
                  );
                }
              case ApiStatus.COMPLETED:
                return body();
            }
          },
        ),
          ),
    );
  }

  Widget body() {
    return RefreshIndicator(
      onRefresh: () {
        controller.selectedRevenueTrend.value = "";
        controller.recentOrderSelectedDay.value = "";
        // controller.chartApi();
        controller.getInitData();

        controller.fillRestaurantDetailsController.getProfileDetailsApi();
        return controller.dashboardApi();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              hBox(3.h),
              profileCard(),
              // hBox(14),
              // searchField(),
              hBox(18.h),
              productDetailsCard(),
              hBox(30.h),
              revenue(),
              hBox(24.h),
              orderStatus(),
              if (controller.apiData.value.dashboard?.recentOrders?.isNotEmpty ?? false) ...[
                hBox(10),
                recentOrders(),
              ],
              if (controller.apiData.value.dashboard?.topSellingProducts?.isNotEmpty ?? false) ...[
              hBox(16.h),
              topSellingProducts(),
              ],
              if (controller.apiData.value.dashboard?.reviews?.isNotEmpty ?? false) ...[
              hBox(16.h),
              customerReview(),
                hBox(6.h),
              ]else...[
                hBox(16.h),
              ],
              accountTypeCard(),
              hBox(85),
            ],
          ),
        ),
      ),
    );
  }

  Widget profileCard() {
    return Obx(
      ()=> controller.fillRestaurantDetailsController.rxGetProfileRequestStatus.value == ApiStatus.LOADING ?
      ShimmerBox(width: Get.width, height: 80) :
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.blueLightColor
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: AppImage(
                    path: controller.fillRestaurantDetailsController.profileApiData.value.vendor?.coverPhotoUrl ?? controller.fillRestaurantDetailsController.profileApiData.value.vendor?.logoUrl ?? "",
                    width: 56,
                    height: 56,
                    fit: BoxFit.fill),
              ),
              wBox(12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(controller.fillRestaurantDetailsController.profileApiData.value.vendor?.shopName?.capitalize ?? "",
                      style: AppFontStyle.text_16_600(AppColors.white,
                          fontFamily: AppFontFamily.gilroyMedium)),
                  Text(controller.fillRestaurantDetailsController.profileApiData.value.vendor?.type?.toString().capitalizeFirst ?? "",
                      style: AppFontStyle.text_14_400(AppColors.white,
                          fontFamily: AppFontFamily.gilroyMedium)),
                ],
              ),
             // const Spacer(),
             // Obx(
             //   ()=> CustomWideSwitch(
             //        width: 42,
             //        height: 23,
             //        activeColor: AppColors.primary,
             //        inactiveColor: AppColors.borderClr,
             //        value: controller.isShopOpen.value,
             //        onChanged: (value) {
             //          pt("value $value");
             //          controller.toggleSwitch(value);
             //        },
             //      ),
             // ),
            ],
          ),
        ),
      ),
    );
  }

  CustomTextFormField searchField() {
    return CustomTextFormField(
      prefix: Padding(
        padding: const EdgeInsets.only(left: 15, right: 10),
        child: SvgPicture.asset(
          ImageConstants.searchLogo,
          height: 24,
          width: 24,
        ),
      ),
      hintText: "Search for items...",
    );
  }

  Widget recentOrders() {
    final recentOrdersData = controller.apiData.value.dashboard?.recentOrders;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Recent Order",
              style: AppFontStyle.text_20_400(AppColors.blackClr,
                  fontFamily: AppFontFamily.gilroySemiBold),
            ),
            TextButton.icon(
              style: ButtonStyle(
                  overlayColor: WidgetStatePropertyAll(AppColors.transparent),
                  padding: const WidgetStatePropertyAll(EdgeInsets.zero)),
              onPressed: () {
                controller.vendorNavbarController.getIndex(2);
              },
              icon: Text(
                "See All",
                style: AppFontStyle.text_16_400(AppColors.primary,
                    fontFamily: AppFontFamily.gilroyMedium),
              ),
              label: Icon(Icons.arrow_forward,
                  color: AppColors.primary, weight: 2, size: 18),
            ),
          ],
        ),
        hBox(6),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: recentOrdersData?.length ?? 0,
          itemBuilder: (context, index) {
            final recentOrders = recentOrdersData?[index];
            return AppContainer(
              boxShadow: const [],
              borderRadius: BorderRadius.circular(10),
              color: controller.getOrdersCardClr(recentOrders?.status ?? "").withAlpha(12),
              height: 70,
              width: Get.width,
              child: Row(
                children: [
                  AppContainer(
                    boxShadow: const [],
                    height: 70,
                    width: 5,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10)),
                    color: controller.getOrdersCardClr(recentOrders?.status ?? ""),
                  ),
                  wBox(16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "#${recentOrders?.orderId ?? ""}",
                        style: AppFontStyle.text_16_400(AppColors.blackClr,
                            fontFamily: AppFontFamily.gilroyMedium),
                      ),
                      hBox(1),
                      Text(
                        "${recentOrders?.items ?? "0"} items • \$${recentOrders?.amount ?? "0"}",
                        style: AppFontStyle.text_16_400(AppColors.greyClr,
                            fontFamily: AppFontFamily.gilroyMedium),
                      ),
                    ],
                  ),
                  const Spacer(),
                  AppContainer(
                    boxShadow: const [],
                    color: controller.getOrdersCardClr(recentOrders?.status ?? "").withAlpha(35),
                    borderRadius: BorderRadius.circular(24),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Text(
                      recentOrders?.status?.replaceAll("_", " ") ?? "",
                      style: AppFontStyle.text_12_500(controller.getOrdersCardClr(recentOrders?.status ?? ""),
                          fontFamily: AppFontFamily.gilroyMedium),
                    ),
                  ),
                  wBox(20),
                ],
              ),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(height: 10),
        ),
      ],
    );
  }


  Widget topSellingProducts() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Top Selling Items",
              style: AppFontStyle.text_20_400(AppColors.blackClr,
                  fontFamily: AppFontFamily.gilroySemiBold),
            ),
            // TextButton.icon(
            //   style: ButtonStyle(
            //       overlayColor: WidgetStatePropertyAll(AppColors.transparent),
            //       padding: const WidgetStatePropertyAll(EdgeInsets.zero)),
            //   onPressed: () {},
            //   icon: Text(
            //     "See All",
            //     style: AppFontStyle.text_16_400(AppColors.primary,
            //         fontFamily: AppFontFamily.gilroyMedium),
            //   ),
            //   label: Icon(Icons.arrow_forward,
            //       color: AppColors.primary, weight: 2, size: 18),
            // ),
          ],
        ),
        hBox(8.h),
        ListView.separated(
          separatorBuilder: (context, index) => hBox(14.h),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: controller.apiData.value.dashboard?.topSellingProducts?.length ?? 0,
          itemBuilder: (context, index) {
            final topProductData = controller.apiData.value.dashboard?.topSellingProducts?[index];
            return AppContainer(
              onTap: () => Get.toNamed(VendorAppRoutes.restaurantMenuItemDetailsScreen,arguments: topProductData?.productId ?? ""),
              borderRadius: BorderRadius.circular(12),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              boxShadow: const [],
              color: AppColors.blackClr.withAlpha(6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      child: AppImage(
                          path: topProductData?.image ?? "",
                          height: 55,
                          width: 55,
                          fit: BoxFit.fill)),
                  wBox(15.h),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        topProductData?.name ?? "",
                        style: AppFontStyle.text_16_400(AppColors.blackClr,
                            fontFamily: AppFontFamily.gilroySemiBold),
                      ),
                      hBox(4),
                      Text(
                        "${topProductData?.items} Order",
                        //, topProductData[index].title ?? '',
                        style: AppFontStyle.text_14_400(AppColors.greyClr,
                            fontFamily: AppFontFamily.gilroyMedium),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    "\$${topProductData?.price ?? ""}",
                    //, topProductData[index].title ?? '',
                    style: AppFontStyle.text_16_400(AppColors.primary,
                        fontFamily: AppFontFamily.gilroySemiBold),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget customerReview() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Customer Reviews",
              style: AppFontStyle.text_20_400(AppColors.blackClr,
                  fontFamily: AppFontFamily.gilroySemiBold),
            ),
            TextButton.icon(
              style: ButtonStyle(
                  overlayColor: WidgetStatePropertyAll(AppColors.transparent),
                  padding: const WidgetStatePropertyAll(EdgeInsets.zero)),
              onPressed: () {
                controller.vendorNavbarController.getIndex(4);
              },
              icon: Text(
                "See All",
                style: AppFontStyle.text_16_400(AppColors.primary,
                    fontFamily: AppFontFamily.gilroyMedium,
                ),
              ),
              label: Icon(Icons.arrow_forward,
                  color: AppColors.primary, weight: 2, size: 18),
            ),
          ],
        ),
        ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: controller.apiData.value.dashboard?.reviews?.length ?? 0,
            separatorBuilder: (context, index) => hBox(4),
            itemBuilder: (context, index) {
              final reviews = controller.apiData.value.dashboard?.reviews?[index];
              final rating = double.tryParse(reviews?.rating ?? "0") ?? 0;
              return AppContainer(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(16),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: AppColors.black.withAlpha(8),
                      blurRadius: 1,
                      spreadRadius: 1,
                  ),
                ],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          height: 34,
                          width: 34,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: AppImage(
                                path: reviews?.image ?? "",
                                height: 34,
                                width: 34,
                                fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          reviews?.name ?? "",
                          style: AppFontStyle.text_16_600(
                            AppColors.blackClr,
                            fontFamily: AppFontFamily.gilroyMedium,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(5, (i) {
                        if (rating >= i + 1) {
                          return Padding(
                              padding: const EdgeInsets.only(left: 3),
                              child:AppImage(path: ImageConstants.starLogo,color: AppColors.goldStar,height: 15,width: 15)
                          );
                        } else if (rating >= i + 0.5) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 1.0),
                            child: Icon(Icons.star_half_rounded, color: AppColors.goldStar, size: 21),
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.only(left: 3),
                            child: AppImage(path: ImageConstants.starLogo ,color: AppColors.grey.withAlpha(65),height: 15,width: 15),
                          );
                        }
                      },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      reviews?.review ?? "",
                      maxLines: 10,
                      style: AppFontStyle.text_14_400(AppColors.greyClr,
                          fontFamily: AppFontFamily.gilroyRegular),
                    ),
                  ],
                ),
              );
            }),
      ],
    );
  }


  Widget revenue() {
    return Obx(
      () {
        final revenueTrend = controller.apiData.value.dashboard?.revenueTrend;

        double peak = double.tryParse(revenueTrend?.peak.toString() ?? "0") ?? 0.0;
        double low = double.tryParse(revenueTrend?.low.toString() ?? "0") ?? 0.0;
        if (peak == 0 && low == 0) {
          low = 0;
          peak = 100;
        }
        double maxYValue = (peak <= 50)
            ? 50
            : (peak <= 100)
            ? 100
            : (peak <= 200)
            ? 200
            : (peak <= 300)
            ? 300
            : (peak <= 500)
            ? 600
            : (peak <= 1000)
            ? 1200
            : peak + 200;

        double minYValue = low;
        double midYValue = (minYValue + maxYValue) / 2;

        pt("minY=$minYValue maxY=$maxYValue midY=$midYValue");

        List<double> revenueList = (revenueTrend?.revenue ?? [])
            .map((e) => double.tryParse(e.toString()) ?? 0.0)
            .toList();

        pt("revenueList $revenueList");

        List<FlSpot> chartSpots = List.generate(
          revenueList.length,
              (index) => FlSpot(index.toDouble(), revenueList[index]),
        );

        pt("chartSpots $revenueList");

        return AppContainer(
        key: controller.todayRevenueKey,
        radius: 14,
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Revenue Trend",
                    style: AppFontStyle.text_18_400(
                      AppColors.darkText,
                      fontFamily: AppFontFamily.gilroySemiBold,
                    ),
                  ),
                  CustomDropDown(
                    btnWidth: 130.w,
                    borderColor: AppColors.black,
                    borderRadius: 9,
                    border: Border.all(color: AppColors.borderClr.withAlpha(120)),
                    padding: 8.h,
                    hintStyle: AppFontStyle.text_12_400(
                      AppColors.greyClr,
                      fontFamily: AppFontFamily.gilroyMedium,
                    ),
                    textStyle: AppFontStyle.text_12_400(
                      AppColors.blackClr,
                      fontFamily: AppFontFamily.gilroyMedium,
                    ),
                    btnHeight: 31.5.h,
                    hintText: "Last 7 days",
                    items: controller.revenueTrend,
                    selectedValue: controller.selectedRevenueTrend.value,
                    onChanged: (value) {
                      controller.selectedRevenueTrend.value = value ?? "";
                      if(controller.selectedRevenueTrend.value?.isNotEmpty ?? false){
                        controller.dashboardApi(isRefresh: false,isRevenueLoading: true);
                      }
                    },
                    iconClr: AppColors.greyClr,
                    iconSize: 20,
                  ),
                ],
              ),
            ),

            hBox(18.h),
            controller.rxRequestStatusForRevenue.value == ApiStatus.LOADING ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: ShimmerBox(width: Get.width, height: 200.h),
            ) : SizedBox(
              height: 200.h,
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: LineChart(
                  LineChartData(
                    minX: 0,
                    maxX: (controller.labels.length - 1).toDouble(),
                    minY: minYValue,
                    maxY: maxYValue,
                    lineTouchData: LineTouchData(
                      enabled: true,
                      touchTooltipData: LineTouchTooltipData(
                        // tooltipRoundedRadius: 10,
                        getTooltipColor: (touchedSpot) =>  AppColors.primary,
                        fitInsideHorizontally: true,
                        fitInsideVertically: true,
                        tooltipPadding: const EdgeInsets.symmetric(horizontal: 6,vertical: 2),
                        tooltipRoundedRadius: 4,
                        tooltipMargin:0 ,
                        getTooltipItems: (touchedSpots) {
                          if (touchedSpots.isEmpty) return [];
                          final spot = touchedSpots.first;
                          final index = spot.spotIndex;

                          final revenueList = controller.apiData.value.dashboard?.revenueTrend?.revenue ?? [];
                          final orderCountList = controller.apiData.value.dashboard?.revenueTrend?.orderCount ?? [];

                          final revenue = revenueList.isNotEmpty && index < revenueList.length
                              ? revenueList[index]
                              : 0;

                          final orderCount = orderCountList.isNotEmpty && index < orderCountList.length
                              ? orderCountList[index]
                              : 0;

                          return [
                            LineTooltipItem(
                              "Revenue: \$${formatRevenue(revenue.toString() ?? "0")}\nOrders: $orderCount",
                              AppFontStyle.text_14_500(
                                AppColors.white,
                                fontFamily: AppFontFamily.gilroyRegular,
                              ),
                            ),
                          ];
                        },
                      ),
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          interval: (maxYValue - minYValue) / 3,
                          getTitlesWidget: (value, meta) {
                            String label;

                            if (value >= 1000) {
                              label = "\$${(value / 1000).toStringAsFixed(0)}K";
                            } else {
                              label = "\$${value.toStringAsFixed(0)}";
                            }

                            return Padding(
                              padding: const EdgeInsets.only(right: 4,left: 4),
                              child: Text(
                                label,
                                style: AppFontStyle.text_12_400(
                                  AppColors.mediumText,
                                  fontFamily: AppFontFamily.gilroyMedium,
                                ),
                              ),
                            );
                          },
                          // getTitlesWidget: (value, meta) {
                          //   bool isClose(double a, double b) => (a - b).abs() < 2;
                          //
                          //   if (isClose(value, maxYValue)) {
                          //     return _yText(maxYValue);
                          //   }
                          //
                          //   if (isClose(value, midYValue)) {
                          //     return _yText(midYValue);
                          //   }
                          //
                          //   if (isClose(value, minYValue)) {
                          //     return _yText(minYValue);
                          //   }
                          //
                          //   return const SizedBox.shrink();
                          // },
                        ),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          reservedSize: 30,
                          showTitles: true,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(
                                controller.labels[value.toInt()],
                                style: AppFontStyle.text_12_400(
                                  AppColors.mediumText,
                                  fontFamily: AppFontFamily.gilroyMedium,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      drawHorizontalLine: true,
                      horizontalInterval: maxYValue / 3,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: AppColors.greyClr.withAlpha(60),
                          strokeWidth: 1,
                          dashArray: [5, 5],
                        );
                      },
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border(
                        left: BorderSide(color: AppColors.greyClr.withAlpha(100), width: 1.5),
                        bottom: BorderSide(color: AppColors.greyClr.withAlpha(100), width: 1.5),
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        isCurved: true,
                        color: AppColors.primary,
                        barWidth: 6,
                        curveSmoothness: 0.5,
                        preventCurveOverShooting: true,
                        preventCurveOvershootingThreshold: 1.0,
                        belowBarData: BarAreaData(
                          show: true,
                          color: AppColors.primary.withAlpha(20),
                        ),
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, bar, index) {
                            return FlDotCirclePainter(
                              radius: 5,
                              color: Colors.white,
                              strokeWidth: 3,
                              strokeColor: AppColors.primary,
                            );
                          },
                        ),

                        spots: chartSpots.map((e) => FlSpot(e.x, e.y + 0.01)).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 26,right: 10,top: 4),
              child: Divider(height: 26),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  revenueTextWidget("Average",controller.apiData.value.dashboard?.revenueTrend?.average ?? "0"),
                  revenueTextWidget("Peak",controller.apiData.value.dashboard?.revenueTrend?.peak ?? "0"),
                  revenueTextWidget("Low",controller.apiData.value.dashboard?.revenueTrend?.low ?? "0"),
                ],
              ),
            ),
          ],
        ),
      );
      },
    );
  }




  Widget _yText(double value) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Text(
        value.toStringAsFixed(0),
        textAlign: TextAlign.right,
        style: AppFontStyle.text_12_400(AppColors.mediumText,fontFamily: AppFontFamily.gilroyMedium),
      ),
    );
  }


  Widget orderStatus() {
    return Obx(
      () {
        final orderStatus = controller.apiData.value.dashboard?.orderStatusChart;
        return AppContainer(
        borderRadius: BorderRadius.circular(14),
        width: Get.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Order Status",
                            style: AppFontStyle.text_18_400(AppColors.blackClr,
                                fontFamily: AppFontFamily.gilroySemiBold,
                            ),
                        ),
                        hBox(1),
                        RichText(
                          text:  TextSpan(
                            children: [
                              TextSpan(text: "Total: ",
                                style: AppFontStyle.text_12_400(AppColors.blackClr,
                                  fontFamily: AppFontFamily.gilroyRegular,
                                ),
                              ),
                              TextSpan(text: orderStatus?.totalOrders ?? "0",
                                style: AppFontStyle.text_12_400(AppColors.blackClr,
                                  fontFamily: AppFontFamily.gilroySemiBold,
                                ),
                              ),
                              TextSpan(text: " orders",
                                style: AppFontStyle.text_12_400(AppColors.blackClr,
                                  fontFamily: AppFontFamily.gilroyRegular,
                                ),
                              )
                            ],
                        ),
                        ),
                      ],
                    ),
                    CustomDropDown(
                      btnWidth: 115.w,
                      borderColor: AppColors.black,
                      borderRadius: 9,
                      border: Border.all(color: AppColors.borderClr.withAlpha(120)),
                      padding: 8.h,
                      hintStyle: AppFontStyle.text_12_400(
                        AppColors.greyClr,
                        fontFamily: AppFontFamily.gilroyMedium,
                      ),
                      textStyle: AppFontStyle.text_12_400(
                        AppColors.blackClr,
                        fontFamily: AppFontFamily.gilroyMedium,
                      ),
                      btnHeight: 31.5.h,
                      hintText: "Today",
                      items: controller.orderStatusList,
                      selectedValue: controller.recentOrderSelectedDay.value,
                      onChanged: (value) {
                        controller.recentOrderSelectedDay.value = value;
                        if(controller.recentOrderSelectedDay.value?.isNotEmpty ?? false){
                          controller.dashboardApi(isOrderLoading: true,isRevenueLoading: false,isRefresh: false);
                        }
                      },
                      iconClr: AppColors.greyClr,
                      iconSize: 20,
                    ),
                  ],
                ),
              ),
              hBox(20),
              if(controller.rxRequestStatusForOrder.value == ApiStatus.LOADING)...[
                ShimmerBox(width: Get.width, height: 380.h)
              ]else...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonChart(percentage: double.tryParse(orderStatus?.successRate ?? "0") ?? 0,
                    values: [
                      double.tryParse( orderStatus?.orderStatus?.delivered?.percent ?? "0") ?? 0,
                      double.tryParse( orderStatus?.orderStatus?.preparing?.percent ?? "0") ?? 0,
                      double.tryParse( orderStatus?.orderStatus?.pending?.percent ?? "0") ?? 0,
                      double.tryParse( orderStatus?.orderStatus?.cancelled?.percent ?? "0") ?? 0,
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15,top: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            percentageTitleText(title: "Success Rate"),
                          ],
                        ),
                        hBox(3),
                        percentageText(title: "${orderStatus?.successRate ?? "0"}%",color: AppColors.primary),
                        hBox(16),
                        percentageTitleText(title: "Active Orders"),
                        hBox(3),
                        percentageText(title: orderStatus?.activeOrders ?? "0",color: AppColors.chartBlueClr),
                        hBox(16),
                        percentageTitleText(title: "Cancel Rate"),
                        hBox(3),
                        percentageText(title: "${orderStatus?.cancelRate ?? "0"}%",color: AppColors.errorColor),
                      ],
                    ),
                  )
                ],
              ),
              hBox(20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    orderStatusChild(dotClr: AppColors.primary, title: "Delivered", subTitle: "${orderStatus?.orderStatus?.delivered?.count ?? "0"} orders", percentage: orderStatus?.orderStatus?.delivered?.percent ?? "0"),
                    wBox(8),
                    orderStatusChild(dotClr: AppColors.chartBlueClr, title: "Preparing", subTitle: "${orderStatus?.orderStatus?.preparing?.count ?? "0"} orders", percentage:orderStatus?.orderStatus?.preparing?.percent ?? "0"),
                  ],
                ),
              ),
              hBox(20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    orderStatusChild(dotClr: AppColors.chartYellowClr, title: "Pending", subTitle: "${orderStatus?.orderStatus?.pending?.count ?? "0"} orders", percentage: orderStatus?.orderStatus?.pending?.percent ?? "0"),
                    wBox(8),
                    orderStatusChild(dotClr: AppColors.errorColor, title: "Cancelled", subTitle: "${orderStatus?.orderStatus?.cancelled?.count ?? "0"} orders", percentage: orderStatus?.orderStatus?.cancelled?.percent ?? "0"),
                  ],
                ),
              ),
              ],
              hBox(2),
            ],
          ),
        ),
      );
      },
    );
  }

  Widget orderStatusChild({
    required Color dotClr,
    required String title,
    required String subTitle,
    required String percentage,
  }) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: AppContainer(
              height: 14,
              width: 14,
              boxShadow: const [],
              color:dotClr,
              shape: BoxShape.circle,
            ),
          ),
          wBox(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(title,
                  style: AppFontStyle.text_14_500(AppColors.blackClr,fontFamily: AppFontFamily.gilroyMedium),
                ),
                hBox(2),
                Padding(
                  padding: const EdgeInsets.only(left: 2.0),
                  child: Text(subTitle,
                    style: AppFontStyle.text_13_400(AppColors.greyClr,fontFamily: AppFontFamily.gilroyMedium),
                  ),
                ),
                hBox(2),
                Text("$percentage%",style: AppFontStyle.text_14_600(AppColors.blackClr,fontFamily: AppFontFamily.gilroyMedium),textAlign: TextAlign.center),
                ],
            ),
          ),
         ],
      ),
    );
  }

  Text percentageText({Color? color,required String title}) => Text(title,style: AppFontStyle.text_14_600(color ?? AppColors.blackClr,fontFamily: AppFontFamily.gilroySemiBold),textAlign: TextAlign.center);
  Text percentageTitleText({Color? color,required String title}) => Text(title,style: AppFontStyle.text_12_400(color ?? AppColors.blueLightColor,fontFamily: AppFontFamily.gilroyMedium),textAlign: TextAlign.center);

  productDetailsCard() {
    final cardData = controller.apiData.value.dashboard?.cards;
    List<String> cardSubTitle = ["\$${cardData?.todayRevenue ?? "0"}",cardData?.totalProducts ?? "0",cardData?.totalOrders ?? "0",cardData?.customerRating ?? "0"];
    List<String> cardPer = [(cardData?.todayRevenuePercentage ?? "0"),cardData?.totalProductsPercentage ?? "0",cardData?.totalOrdersPercentage ?? "0",cardData?.customerRatingPercentage ?? "0"];
    return GridView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: controller.iconList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.03,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
      ),
      itemBuilder: (context, index) {
        return CustomDetailsCard(
          // onTap: () {
          //   if (index == 0) {
          //     // Get.to(() => const RestaurantOrderListScreen());
          //     // restaurantNavbarController.getIndex(2);
          //   } else if (index == 1) {
          //     // restaurantNavbarController.getIndex(1);
          //     // Get.to(() => const RestaurantProductScreen());
          //   } else if (index == 3) {
          //     // Get.toNamed(AppRoutes.restaurantProductReviewScreen);
          //   }
          // },
          onTap: () {
            final navbarController = Get.find<VendorNavbarController>();
            if (index == 0) {
              controller.scrollToFields(controller.todayRevenueKey);
            } else if (index == 1) {
              navbarController.getIndex(1);
            } else if (index == 2) {
              navbarController.getIndex(2);
            } else if (index == 3) {
              navbarController.getIndex(4);
            }
          },

          containerClr: controller.cardColor[index].withAlpha(30),
          imageClr: controller.cardColor[index],
          image: controller.iconList[index],
          title: cardSubTitle[index],
          subTitle: controller.cardTitle[index],
          widget: Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppImage(
                  path: ImageConstants.upwardArrow,
                  height: 12,
                  width: 10,
                ),
                wBox(4),
                Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Text(
                    "+${cardPer[index]}%",
                    style: AppFontStyle.text_14_400(
                      AppColors.primary,
                      fontFamily: AppFontFamily.gilroyMedium,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

// @override
// void dispose() {
//   WidgetsBinding.instance.removeObserver(this);
//   super.dispose();
// }


/*List<LineChartBarData> lineChartBars() {
    List<double> data = controller.chartApiData.value.upperCurve
            ?.map((e) => double.tryParse(e.toString()) ?? 0.0)
            .toList() ??
        [];
    int length = controller.chartApiData.value.labels?.length ?? 0;

    return [
      LineChartBarData(
        spots: List.generate(
            length,
            (index) => FlSpot(
                index.toDouble(), data.length > index ? data[index] : 0.0)),
        isCurved: true,
        color: AppColors.black,
        barWidth: 1.2,
        show: true,
        preventCurveOverShooting: true,
        dotData: FlDotData(
          show: true,
          getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
            radius: 3,
            color: AppColors.black,
            strokeWidth: 1,
            strokeColor: AppColors.white,
          ),
        ),
        belowBarData: BarAreaData(
          show: true,
          color: AppColors.normalStar.withOpacity(0.5),
          applyCutOffY: true,
        ),
      )
    ];
  }*/


  Widget shimmerLoadingBody() {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(), // Prevents scrolling during loading
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            hBox(3.h),

            // Profile Card Shimmer
            ShimmerBox(width: Get.width, height: 80, radius: 12),
            hBox(14),

            // Search Field Shimmer
            ShimmerBox(width: Get.width, height: 50, radius: 10),
            hBox(18.h),

            // 2x2 Grid - Product Details Cards
            GridView.builder(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 4,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.05,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
              ),
              itemBuilder: (context, index) {
                return ShimmerBox(width: Get.width / 2 - 30, height: 160, radius: 14);
              },
            ),

            hBox(30.h),

            // Revenue Trend Chart Card
            ShimmerBox(width: Get.width, height: 280, radius: 14),
            hBox(24.h),

            // Order Status Card
            ShimmerBox(width: Get.width, height: 340, radius: 14),
            hBox(20),

            // Recent Orders Title + List
            const ShimmerBox(width: 180, height: 28, radius: 8),
            hBox(12),
            ...List.generate(3, (index) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ShimmerBox(width: Get.width, height: 70, radius: 10),
            )),

            hBox(20),

            // Top Selling Products Title + List
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShimmerBox(width: 160, height: 28, radius: 8),
                ShimmerBox(width: 80, height: 20, radius: 20),
              ],
            ),
            hBox(16),
            ...List.generate(4, (index) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: ShimmerBox(width: Get.width, height: 80, radius: 12),
            )),

            hBox(20),

            // Customer Reviews Title + Cards
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShimmerBox(width: 180, height: 28, radius: 8),
                ShimmerBox(width: 80, height: 20, radius: 20),
              ],
            ),
            hBox(16),
            ...List.generate(3, (index) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ShimmerBox(width: Get.width, height: 140, radius: 12),
            )),

            // Account Type Card (optional)
            hBox(20),
            ShimmerBox(width: Get.width, height: 100, radius: 12),

            hBox(100), // Extra bottom space
          ],
        ),
      ),
    );
  }
}

Widget revenueTextWidget(String title,String price) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(title,style: AppFontStyle.text_14_400(AppColors.greenLightClr,fontFamily: AppFontFamily.arial)),
      Text("\$${formatWithCommas(double.tryParse(price) ?? 0)}",style: AppFontStyle.text_20_400(AppColors.blackClr,fontFamily: AppFontFamily.arialBold)),
    ],
  );
}

String formatWithCommas(num number) {return number.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'),(Match match) => '${match[1]},');

}

String formatRevenue(String value) {
  final double number = double.tryParse(value) ?? 0.0;

  return number.toStringAsFixed(2).replaceAllMapped(
    RegExp(r'(\d)(?=(\d{3})+\.)'),
        (match) => '${match[1]},',
  );
}