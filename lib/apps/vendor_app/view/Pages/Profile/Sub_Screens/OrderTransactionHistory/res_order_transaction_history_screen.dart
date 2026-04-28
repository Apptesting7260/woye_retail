import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/Profile/Sub_Screens/OrderTransactionHistory/controller/res_order_transaction_controller.dart';
import '../../../../../../../Core/Constant/image_constant.dart';
import '../../../../../../../Data/components/general_exception.dart';
import '../../../../../../../Data/components/internet_exception.dart';
import '../../../../../../../Data/response/status.dart';
import '../../../../../../../Utils/date_format.dart';
import '../../../../../../../Utils/sized_box.dart';
import '../../../../../../../routes/vendor_routes/vendor_app_routes.dart';
import '../../../../../../../shared/theme/colors.dart';
import '../../../../../../../shared/theme/font_family.dart';
import '../../../../../../../shared/theme/font_style.dart';
import '../../../../../../../shared/widgets/custom_appbar.dart';
import '../../../../../../../shared/widgets/custom_elevated_button.dart';
import '../../../../../../../shared/widgets/vendor_widgets/circular_progress_indicator.dart';
import '../../../../../../../shared/widgets/vendor_widgets/custom_details_card.dart';
import '../../../../../../../shared/widgets/vendor_widgets/custom_dropdown.dart';
import '../../../../../../../shared/widgets/vendor_widgets/custom_transaction_history_list.dart';

class ResOrderTransHistoryScreen extends StatefulWidget {
  const ResOrderTransHistoryScreen({super.key});

  @override
  State<ResOrderTransHistoryScreen> createState() =>
      _ResOrderTransHistoryScreenState();
}

class _ResOrderTransHistoryScreenState
    extends State<ResOrderTransHistoryScreen> {
  final ResOrderTransactionController controller =
      Get.put(ResOrderTransactionController());

  @override
  void initState() {
    controller.onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: SafeArea(
        child: Scaffold(
          appBar: CustomAppBar(
            title: Text(
              "Orders transactions",
              style: AppFontStyle.text_22_600(
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
                        controller.getWalletDetails();
                      },
                    );
                  } else {
                    return GeneralExceptionWidget(
                      onPress: () {
                        controller.getWalletDetails();
                      },
                    );
                  }
                case ApiStatus.COMPLETED:
                  return RefreshIndicator(
                      onRefresh: () {
                        controller.selectedDay.value = "10 days";
                        return controller.getWalletDetails();
                      },
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            children: [
                              hBox(8.h),
                              currentBalanceCard(),
                              hBox(25.h),
                              balanceStatistics(),
                              if (controller
                                      .apiData.value.transactions?.isNotEmpty ??
                                  true) ...[
                                // hBox(20.h),
                                transactionAndSeeAllTextBtn(),
                                // hBox(5.h),
                                // toggleButtons(),
                                // hBox(10.h),
                                transactionHistory(),
                              ],
                              hBox(15.h),
                            ],
                          ),
                        ),
                      ));
              }
            },
          ),
        ),
      ),
    );
  }

  Row transactionAndSeeAllTextBtn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Transaction history",
          style: AppFontStyle.text_20_600(
            AppColors.darkText,
            fontFamily: AppFontFamily.gilroyRegular,
          ),
        ),
        TextButton.icon(
          style: const ButtonStyle(
            padding: WidgetStatePropertyAll(EdgeInsets.zero),
          ),
          onPressed: () {},
          label: Icon(
            Icons.arrow_forward,
            color: AppColors.primary,
            size: 17,
          ),
          icon: Text(
            "See All",
            style: AppFontStyle.text_14_400(
              AppColors.primary,
              fontFamily: AppFontFamily.gilroyMedium,
            ),
          ),
        ),
      ],
    );
  }

  Column balanceStatistics() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Balance Statistics",
              style: AppFontStyle.text_20_600(
                AppColors.darkText,
                fontFamily: AppFontFamily.gilroyRegular,
              ),
            ),
            Obx(
              () => CustomDropDown(
                btnWidth: 115.w,
                borderColor: AppColors.black,
                textStyle: AppFontStyle.text_14_400(
                  AppColors.black,
                  fontFamily: AppFontFamily.gilroyMedium,
                ),
                hintText: "Today",
                hintStyle: AppFontStyle.text_14_400(
                  AppColors.black,
                  fontFamily: AppFontFamily.gilroyMedium,
                ),
                padding: 5.w,
                borderRadius: 50.r,
                btnHeight: 32.h,
                items:  const ["Today", "Yesterday"],
                selectedValue: controller.chartSelectedDay.value ,
                onChanged: (value) {
                  if (value != null) {
                    controller.chartSelectedDay.value = value;
                  }
                },
              ),
            ),
          ],
        ),
        hBox(18.h),
        Center(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.bgColor,
              borderRadius: BorderRadius.circular(15),
            ),
            height: 234.h,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 25, 15, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: BarChart(
                      BarChartData(
                        barTouchData: BarTouchData(enabled: false),
                        maxY: 120,
                        titlesData: FlTitlesData(
                          show: true,
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: bottomTitles,
                              reservedSize: 30.h,
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 30,
                              reservedSize: 20.h,
                              getTitlesWidget: (value, meta) {
                                return Text(value.toInt().toString(),
                                    style: AppFontStyle.text_12_400(
                                      AppColors.mediumText,
                                      fontFamily: AppFontFamily.gilroyRegular,
                                    ));
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(
                          show: true,
                          border: Border(
                            bottom: BorderSide(
                                color: AppColors.hintText.withOpacity(0.3),
                                width: 1),
                          ),
                        ),
                        barGroups: controller.barGroups,
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          drawHorizontalLine: true,
                          horizontalInterval: 25,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: AppColors.hintText.withOpacity(0.3),
                              strokeWidth: 1,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  hBox(5.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                        ),
                      ),
                      wBox(4.w),
                      Text(
                        "Income",
                        style: AppFontStyle.customText(
                          AppColors.darkText,
                          13.sp,
                          FontWeight.w500,
                          fontFamily: AppFontFamily.gilroyMedium,
                        ),
                      ),
                      wBox(15.h),
                      Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.yellow,
                        ),
                      ),
                      wBox(3.h),
                      Text(
                        "Outgoings",
                        style: AppFontStyle.customText(
                          AppColors.darkText,
                          13.sp,
                          FontWeight.w500,
                          fontFamily: AppFontFamily.gilroyMedium,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    const titles = ['F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O'];
    if (value.toInt() < 0 || value.toInt() >= titles.length) {
      return const SizedBox.shrink();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 8.h,
      child: Text(titles[value.toInt()],
          style: AppFontStyle.text_12_400(
            AppColors.mediumText,
            fontFamily: AppFontFamily.gilroyRegular,
          )),
    );
  }

  transactionHistory() {
    String? selectedFilter = controller.selectedDay.value;
    DateTime currentDate = DateTime.now();
    DateTime? filterDate;

    if (selectedFilter == "Today") {
      filterDate = DateTime(currentDate.year, currentDate.month, currentDate.day);
    } else if (selectedFilter == "10 days") {
      filterDate = currentDate.subtract(const Duration(days: 10));
    } else if (selectedFilter == "25 days") {
      filterDate = currentDate.subtract(const Duration(days: 25));
    }
    else if (selectedFilter == "50 days") {
      filterDate = currentDate.subtract(const Duration(days: 50));
    } else if (selectedFilter == "100 days") {
      filterDate = currentDate.subtract(const Duration(days: 100));
    }

    var filteredHistory = controller.apiData.value.transactions?.where((transaction) {
      DateTime reviewDate = DateTime.parse(transaction.transactionDate ?? "");
      if (filterDate != null) {
        return reviewDate.isAfter(filterDate);
      }
      return true;
    }).toList();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(
                  () => CustomDropDown(
                btnWidth: 70.w,
                borderColor: AppColors.black,
                textStyle: AppFontStyle.text_13_400(
                  AppColors.black,
                  fontFamily: AppFontFamily.gilroyMedium,
                ),
                hintStyle: AppFontStyle.text_13_400(
                  AppColors.black,
                  fontFamily: AppFontFamily.gilroyMedium,
                ),
                padding: 5,
                borderRadius: 50,
                btnHeight: 32,
                items: const ["All"],
                selectedValue: controller.selectedAll.value,
                onChanged: (value) {
                  if (value != null) {
                    controller.selectedAll.value = value;
                  }
                },
              ),
            ),
            wBox(5.w),
            Obx(
                  () => CustomDropDown(
                btnWidth: 105.w,
                borderColor: AppColors.black,
                textStyle: AppFontStyle.text_14_400(
                  AppColors.black,
                  fontFamily: AppFontFamily.gilroyMedium,
                ),
                hintStyle: AppFontStyle.text_14_400(
                  AppColors.black,
                  fontFamily: AppFontFamily.gilroyMedium,
                ),
                padding: 5,
                borderRadius: 50,
                btnHeight: 32,
                items: controller.days,
                selectedValue: controller.selectedDay.value,
                onChanged: (value) {
                  if (value != null) {
                    controller.selectedDay.value = value;
                  }
                },
              ),
            ),
            wBox(5.w),
            Container(
              height: 36.h,
              decoration: BoxDecoration(
                color: AppColors.primary,
                border: Border.all(color: AppColors.primary, width: 1),
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: Padding(
                padding: REdgeInsets.symmetric(horizontal: 7.0),
                child: Row(
                  children: [
                    SvgPicture.asset(ImageConstants.downloadLogo),
                    Text(
                      "Export Transaction",
                      // style: GoogleFonts.inter(
                      //   fontSize: 12.sp,
                      //   fontWeight: FontWeight.w400,
                      //   color: AppColors.white,
                      // ),
                      style: AppFontStyle.text_12_400(
                        AppColors.white,
                        fontFamily: AppFontFamily.gilroyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        // Display filtered transactions
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filteredHistory?.length ?? 0,
          itemBuilder: (context, index) {
            return CustomTransactionHistoryList(
              image:filteredHistory?[index].user?.imageUrl,
              title:"${filteredHistory?[index].user?.firstName ?? ""} ${filteredHistory?[index].user?.lastName ?? ""}",
              dateTime: FormatDate.formatDateString(
                  filteredHistory?[index].transactionDate ?? ""),
              amount: filteredHistory?[index].transactionType == "Order"
                  ? "+\$${filteredHistory?[index].amount}"
                  : "-\$${filteredHistory?[index].amount}",
              transactionType: filteredHistory?[index].transactionType == "Order"
                  ? "Credit"
                  : "Refund",
              color: filteredHistory?[index].transactionType == "Order"
                  ? AppColors.primary
                  : AppColors.red,
            );
          },
          separatorBuilder: (context, index) => hBox(15.h),
        ),
      ],
    );
  }


  Container currentBalanceCard() {
    return Container(
      // height: 180,
      width: Get.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColors.primary.withOpacity(0.1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          hBox(22.h),
          Text(
            "Current Balance",
            style: AppFontStyle.text_16_400(
              AppColors.darkText,
              fontFamily: AppFontFamily.gilroyMedium,
            ),
          ),
          hBox(6.h),
          Text(
              "\$${double.tryParse(controller.apiData.value.wallet?.walletBalance.toString() ?? "0") ?? 0}",
              style: AppFontStyle.text_28_600(
                AppColors.primary,
                fontFamily: AppFontFamily.gilroyRegular,
              )),
          hBox(14.h),
          CustomElevatedButton(
            width: 145.h,
            height: 46.h,
            onPressed: () {
              Get.toNamed(VendorAppRoutes.restaurantWithdrawScreen);
            },
            text: "Withdraw",
            textStyle: AppFontStyle.text_16_400(
              AppColors.primary,
              fontFamily: AppFontFamily.gilroySemiBold,
            ),
          ),
          hBox(28.h),
        ],
      ),
    );
  }

  walletDetailsCard() {
    return GridView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 4,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.27,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15),
      itemBuilder: (context, index) {
        return CustomDetailsCard(
          image: index == 0
              ? ImageConstants.dollarImage
              : index == 1
                  ? ImageConstants.walletPngImage
                  : index == 2
                      ? ImageConstants.bankImage
                      : index == 3
                          ? ImageConstants.indianRupeesImage
                          : ImageConstants.productLogo,
          title: index == 0
              ? "\$23,568.00"
              : index == 1
                  ? "\$400.00"
                  : index == 2
                      ? "200"
                      : index == 3
                          ? "\$5,631.50"
                          : "",
          subTitle: index == 0
              ? "Earning Amount"
              : index == 1
                  ? "Current Balance"
                  : index == 2
                      ? "Total Transaction"
                      : index == 3
                          ? 'Outgoing'
                          : "",
        );
      },
    );
  }
}
