import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gyaawa/apps/vendor_app/Gyaawa/Pages/Wallet/controller/restaurant_wallets_controller.dart';
import 'package:gyaawa/apps/vendor_app/vendor_app_routes/vendor_app_routes.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../../Core/Constant/image_constant.dart';
import '../../../../../../Data/components/general_exception.dart';
import '../../../../../../Data/components/internet_exception.dart';
import '../../../../../../Data/response/status.dart';
import '../../../../../../Utils/account_type_card.dart';
import '../../../../../../Utils/date_format.dart';
import '../../../../../../Utils/sized_box.dart';
import '../../../../../../shared/theme/colors.dart';
import '../../../../../../shared/theme/font_family.dart';
import '../../../../../../shared/theme/font_style.dart';
import '../../../../../../shared/widgets/image.dart';
import '../../../../../../shared/widgets/shimmer_widget.dart';
import '../../../../../../shared/widgets/vendor_widgets/app_container.dart';
import '../../../../../../shared/widgets/vendor_widgets/custom_delete_alert_dialog.dart';
import '../../../../../../shared/widgets/vendor_widgets/custom_details_card.dart';
import '../../../../../../shared/widgets/vendor_widgets/custom_dropdown.dart';
import '../../../../../../shared/widgets/vendor_widgets/custom_elevated_button.dart';
import '../../../../../../shared/widgets/vendor_widgets/custom_text_form_field.dart';
import '../../../../../../shared/widgets/vendor_widgets/print.dart';
import '../../../../common_appbar_header/common_appbar_header.dart';
import '../../../vendor_common/NoTransactionFoundWidget/no_transaction_found_widget.dart';
import '../../Profile/Sub_Screens/Setting/RestaurantInFormation/controller/restaurant_information_controller.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  // final RestaurantWalletsController controller = Get.find<RestaurantWalletsController>();
  final RestaurantWalletsController controller = Get.put (RestaurantWalletsController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        controller.getInitData();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundClr,
        appBar: const CommonAppbarHeader(
          title: "Wallet",
          // controller: Get.find<FillRestaurantDetailsController>(),
        ),
        body: Obx(
          () {
            switch (controller.walletApiData.value.status) {
              case ApiStatus.LOADING:
                return Center(child: shimmerWallet());
              case ApiStatus.ERROR:
                if (controller.walletApiData.value.message == 'No internet') {
                  return InternetExceptionWidget(
                    onPress: () {},
                  );
                } else {
                  return GeneralExceptionWidget(
                    onPress: () {
                      controller.selectedDay.value = "Today";
                      controller.getInitData();
                    },
                  );
                }
              case ApiStatus.COMPLETED:
                return body();

              default:
                return const SizedBox();
            }
          },
        ),
      ),
    );
  }

  body() {
    return RefreshIndicator(
      onRefresh: () {
        controller.chartSelectedDay.value = "Last 12 months";
        return controller.getWalletApi();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              hBox(14),
              // searchField(),
              // hBox(18),
              productDetailsCard(),
              hBox(22.h),
              // currentBalanceCard(),
              // hBox(25.h),
              balanceStatistics(),
              // if(controller.apiData.value.transactions?.isNotEmpty ?? true)...[
              hBox(20.h),
              Text(
                "Quick Action",
                style: AppFontStyle.text_20_400(
                  AppColors.darkText,
                  fontFamily: AppFontFamily.gilroySemiBold,
                ),
              ),
              hBox(10),
              quickAction(),
              // transactionAndSeeAllTextBtn(),
              // hBox(10.h),
              // transactionHistory(),
              // ],
              hBox(16.h),
              paymentSchedule(),
              hBox(20.h),
              recentTransactions(),
              hBox(20),
              paymentDetails(),
              hBox(18.h),
              accountTypeCard(),
              hBox(74.h),
            ],
          ),
        ),
      ),
    );
  }

  paymentDetails() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Payment Details",
              style: AppFontStyle.text_20_400(AppColors.blackClr,
                  fontFamily: AppFontFamily.gilroySemiBold),
            ),
            if((controller.walletApiData.value.data?.paymentMethods?.bank?.isEmpty ?? false) || (controller.walletApiData.value.data?.paymentMethods?.mobileMoney?.isEmpty ?? false))
            TextButton.icon(
              style: ButtonStyle(
                  overlayColor: WidgetStatePropertyAll(AppColors.transparent),
                  padding: const WidgetStatePropertyAll(EdgeInsets.zero)),
              onPressed: () async{
                final result = await Get.toNamed(VendorAppRoutes.resManagePaymentMethod,
                arguments: {
                  "selectedIndex": (controller.walletApiData.value.data?.paymentMethods?.bank?.isEmpty ?? false) ? "0" : "1"
                }
                );

                if (result == true) {
                  controller.getWalletApi(isShowLoading: false,isSowChartLoading: false);
                }
              },
              label: Text(
                "Add Method",
                style: AppFontStyle.text_16_400(AppColors.primary,
                    fontFamily: AppFontFamily.gilroyMedium),
              ),
              icon: Icon(Icons.add,
                  color: AppColors.primary, weight: 2, size: 18),
            ),
          ],
        ),
        hBox(12),
        if( (controller.walletApiData.value.data?.paymentMethods?.bank?.isEmpty ?? false) && (controller.walletApiData.value.data?.paymentMethods?.mobileMoney?.isEmpty ?? false))...[
          const NoTransactionFound(icon: Icons.account_balance,title: "No Payment Details Found",subtitle: "You don’t have any payment details yet."),
          hBox(10),
        ],
        if(controller.walletApiData.value.data?.paymentMethods?.bank?.isNotEmpty ?? false)
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: controller.walletApiData.value.data?.paymentMethods?.bank?.length ?? 0,
          itemBuilder: (context, index) {
            return DottedBorder(
              borderType: BorderType.RRect,
              radius: const Radius.circular(8),
              strokeWidth: index == 0 ? 1.8 : 0,
              color: index == 0 ? AppColors.primary : AppColors.transparent,
              dashPattern: const [6, 5],
              child: AppContainer(
                padding: const EdgeInsets.all(14),
                radius: 10,
                boxShadow: index == 0
                    ? []
                    : [
                        BoxShadow(
                            color: AppColors.black.withAlpha(15),
                            blurRadius: 1,
                            spreadRadius: 1),
                      ],
                // height: 150,
                width: Get.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppContainer(
                          height: 42.h,
                          width: 42.h,
                          radius: 8,
                          boxShadow: const [],
                          color: index == 0
                              ? AppColors.primary.withAlpha(25)
                              : AppColors.blueClr.withAlpha(25),
                          padding: const EdgeInsets.all(12),
                          child: AppImage(
                            path: ImageConstants.primaryBank,
                            svgColor: ColorFilter.mode(
                              index == 0
                                  ? AppColors.primary
                                  : AppColors.blueClr,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        wBox(10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Primary Bank Account",
                                style: AppFontStyle.text_15_600(
                                  AppColors.blackClr,
                                  fontFamily: AppFontFamily.gilroyMedium,
                                ),
                              ),
                              hBox(2),
                              Text(
                                "Default payout method",
                                style: AppFontStyle.text_13_400(
                                  AppColors.greyClr,
                                  fontFamily: AppFontFamily.gilroyMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 28,
                          child: PopupMenuButton<String>(
                            color: AppColors.white,
                            menuPadding: EdgeInsets.zero,
                            padding: EdgeInsets.zero,
                            iconSize: 20,
                            splashRadius: 20,
                            offset: const Offset(-20, 40),
                            icon: const Icon(Icons.more_vert),
                            onSelected: (value)async {
                              if(value == "edit"){
                              final result = await  Get.toNamed(VendorAppRoutes.resManagePaymentMethod,arguments: {"payment_method":"bank"});
                              if(result == true){
                                controller.getWalletApi(isShowLoading: false,isSowChartLoading: false);
                              }
                              }

                              if(value == "delete"){
                                showDialog(
                                  context: Get.context!,
                                  builder: (context) => Obx(
                                        ()=> Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                          child: CustomDeleteAlertDialog(
                                            isLoading: controller.deletePaymentMethodData.value.status == ApiStatus.LOADING,
                                            // textAlign: ,
                                            title: "Delete Bank Details",
                                            btnName:"Delete" ,
                                            cancelOnTap: (){Get.back();},
                                            deleteOnTap:(){controller.deletePaymentMethod(paymentMethod: "bank", id:controller.walletApiData.value.data?.paymentMethods?.bank?[index].id ?? "");},
                                            maxLine: 5,
                                            subtitle: "Are you sure you want to delete ${controller.walletApiData.value.data?.paymentMethods?.bank?[index].bankname ?? ""} bank detail?",
                                            titleColor: AppColors.blackClr,
                                          ),
                                        ),
                                  ),
                                );
                              }

                            },
                            itemBuilder: (context) => const [
                              PopupMenuItem(
                                value: "edit",
                                child: Text("Edit"),
                              ),
                              PopupMenuItem(
                                value: "delete",
                                child: Text("Delete"),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    hBox(20),
                    _buildBankRow(title: "Bank Name:", subTitle: controller.walletApiData.value.data?.paymentMethods?.bank?[index].bankname ?? ""),
                    hBox(8),
                    _buildBankRow(
                        title: "Account Type:", subTitle: controller.walletApiData.value.data?.paymentMethods?.bank?[index].acType ?? ""),
                    hBox(8),
                    _buildBankRow(
                        title: "Account Number:", subTitle: controller.maskAccountNumber(controller.walletApiData.value.data?.paymentMethods?.bank?[index].acNo ?? ""))
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (context, index) => hBox(10),
        ),
        if(controller.walletApiData.value.data?.paymentMethods?.mobileMoney?.isNotEmpty ?? false)...[
        hBox(12.h),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: controller.walletApiData.value.data?.paymentMethods?.mobileMoney?.length ?? 0,
          itemBuilder: (context, index) {
            return DottedBorder(
              borderType: BorderType.RRect,
              radius: const Radius.circular(8),
              color:  AppColors.transparent,
              dashPattern: const [6, 5],
              child: AppContainer(
                padding: const EdgeInsets.all(14),
                radius: 10,
                boxShadow: [BoxShadow(color: AppColors.black.withAlpha(15),blurRadius: 1,spreadRadius: 1)],
                width: Get.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppContainer(
                          height: 42.h,
                          width: 42.h,
                          radius: 8,
                          boxShadow: const [],
                          color: AppColors.blueClr.withAlpha(25),
                          padding: const EdgeInsets.all(12),
                          child: AppImage(
                            path:  ImageConstants.mobileMoney,
                            svgColor: ColorFilter.mode(
                              AppColors.blueClr,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        wBox(10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Mobile Money Account",
                                style: AppFontStyle.text_15_600(
                                  AppColors.blackClr,
                                  fontFamily: AppFontFamily.gilroyMedium,
                                ),
                              ),
                              hBox(2),
                              Text(
                                "Alternative payout method",
                                style: AppFontStyle.text_13_400(
                                  AppColors.greyClr,
                                  fontFamily: AppFontFamily.gilroyMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 28,
                          child: PopupMenuButton<String>(
                            color: AppColors.white,
                            menuPadding: EdgeInsets.zero,
                            padding: EdgeInsets.zero,
                            iconSize: 20,
                            splashRadius: 20,
                            offset: const Offset(-20, 40),
                            icon: const Icon(Icons.more_vert),
                            onSelected: (value) async {
                              if(value == "edit"){
                                final result = await  Get.toNamed(VendorAppRoutes.resManagePaymentMethod,arguments: {"payment_method":"mobile_money"});
                                if(result == true){
                                  controller.getWalletApi(isShowLoading: false,isSowChartLoading: false);
                                }
                              }
                              if(value == "delete"){
                                showDialog(
                                  context: Get.context!,
                                  builder: (context) => Obx(
                                        ()=> Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                      child: CustomDeleteAlertDialog(
                                        isLoading: controller.deletePaymentMethodData.value.status == ApiStatus.LOADING,
                                        // textAlign: ,
                                        title: "Delete Account",
                                        btnName:"Delete" ,
                                        cancelOnTap: (){Get.back();},
                                        deleteOnTap:(){controller.deletePaymentMethod(paymentMethod: "mobile_money", id:controller.walletApiData.value.data?.paymentMethods?.mobileMoney?[index].id ?? "");},
                                        maxLine: 5,
                                        subtitle: "Are you sure you want to delete ${controller.walletApiData.value.data?.paymentMethods?.mobileMoney?[index].provider?.replaceAll("_", " ").capitalize ?? ""} detail?",
                                        titleColor: AppColors.blackClr,
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                            itemBuilder: (context) => const [
                              PopupMenuItem(
                                value: "edit",
                                child: Text("Edit"),
                              ),
                              PopupMenuItem(
                                value: "delete",
                                child: Text("Delete"),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    hBox(20),
                    _buildBankRow(title: "Provider:", subTitle: controller.walletApiData.value.data?.paymentMethods?.mobileMoney?[index].provider?.replaceAll("_", " ").capitalize ?? ""),
                    hBox(8),
                    _buildBankRow(
                        title: "Account Name:", subTitle: controller.walletApiData.value.data?.paymentMethods?.mobileMoney?[index].acName ?? ""),
                    hBox(8),
                    _buildBankRow(
                        title: "Phone Number:", subTitle: controller.maskPhoneNumber(controller.walletApiData.value.data?.paymentMethods?.mobileMoney?[index].phone ?? ""))
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (context, index) => hBox(10),
        ),
    ],
      ],
    );
  }

  Widget _buildBankRow({String? title, String? subTitle}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title ?? "",
          style: AppFontStyle.text_15_400(
            AppColors.greyClr,
            fontFamily: AppFontFamily.gilroyMedium,
          ),
        ),
        Text(
          subTitle ?? "",
          style: AppFontStyle.text_15_400(
            AppColors.blackClr,
            fontFamily: AppFontFamily.gilroyMedium,
          ),
        ),
      ],
    );
  }

  AppContainer paymentSchedule() {
    return AppContainer(
      radius: 10,
      boxShadow: [],
      color: AppColors.blueClr.withAlpha(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Payout Schedule",
            style: AppFontStyle.text_16_400(
              AppColors.blueClr,
              fontFamily: AppFontFamily.gilroySemiBold,
            ),
          ),
          hBox(4),
          RichText(
              text: TextSpan(children: [
            TextSpan(
              text: "Your next automatic payout is scheduled for ",
              style: AppFontStyle.text_14_400(
                AppColors.blueClr,
                fontFamily: AppFontFamily.gilroyMedium,
              ),
            ),
            TextSpan(
              text: " ${controller.walletApiData.value.data?.stats?.lastPayoutDate ?? ""}",
              style: AppFontStyle.text_14_400(
                AppColors.blueClr,
                fontFamily: AppFontFamily.gilroySemiBold,
              ),
            ),
          ]))
        ],
      ),
    );
  }

  Widget recentTransactions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                "Recent Transactions",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppFontStyle.text_20_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroySemiBold),
              ),
            ),
            // if(controller.walletApiData.value.data?.recentTransactions?.isNotEmpty == true)
            // TextButton(
            //   onPressed: () {},
            //   style: TextButton.styleFrom(
            //     padding: EdgeInsets.zero,
            //     minimumSize: Size(60.w, 30.h),
            //     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            //   ),
            //   child: Row(
            //     children: [
            //       Text(
            //         "See All",
            //         style: AppFontStyle.text_14_400(
            //           AppColors.primary,
            //           fontFamily: AppFontFamily.gilroyMedium,
            //         ),
            //       ),
            //       SizedBox(width: 4.w),
            //       Icon(
            //         Icons.arrow_forward,
            //         size: 16.sp,
            //         color: AppColors.primary,
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),

        SizedBox(height: 12.h),

        /// Transaction List
        (controller.walletApiData.value.data?.recentTransactions?.isEmpty == true) ?
        const NoTransactionFound() :
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.walletApiData.value.data?.recentTransactions?.length ?? 0,
          separatorBuilder: (_, __) => SizedBox(height: 10.h),
          itemBuilder: (context, index) {
            final item = controller.walletApiData.value.data?.recentTransactions?[index];
            final type = item?.transactionType?.toLowerCase() ?? "";
            final color = controller.getColors(type);

            return Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
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
                      controller.getIcons(type),
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
                          item?.descp ?? "",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppFontStyle.text_14_400(
                            AppColors.blackClr,
                            fontFamily: AppFontFamily.gilroySemiBold,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                         "${item?.transactionType ?? ""} ${FormatDate.convertIsoToFormatted(item?.createdAt ?? "")}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppFontStyle.text_12_400(
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
                      type == "credit"
                          ? "+\$${item?.amount ?? "0"}"
                          : "\$${item?.amount ?? "0"}",
                      style: AppFontStyle.text_14_400(
                        type == "credit" ? AppColors.primary : color,
                        fontFamily: AppFontFamily.gilroySemiBold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  ListView quickAction() {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: controller.btnList.length,
      itemBuilder: (context, index) {
        return CustomElevatedButton(
          color: index == 0 ? AppColors.primary : AppColors.whiteShadow,
          onPressed: ()async {
            switch (index) {
              case 0:
                Get.toNamed(VendorAppRoutes.resRequestPayoutScreen);
              case 1:
              final result = await Get.toNamed(VendorAppRoutes.resManagePaymentMethod);
              if(result == true){
                controller.getWalletApi(isShowLoading: false,isSowChartLoading: false);
              }
              case 2:
                Get.toNamed(VendorAppRoutes.resDownloadStatementScreen);
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppImage(path: controller.btnList[index]['image']),
              wBox(10),
              Text(
                controller.btnList[index]['title'],
                style: AppFontStyle.text_16_600(
                  index == 0 ? AppColors.white : AppColors.blackClr,
                  fontFamily: AppFontFamily.gilroyRegular,
                ),
              )
            ],
          ),
        );
      },
      separatorBuilder: (context, index) => hBox(12),
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
        // TextButton.icon(
        //   style: const ButtonStyle(
        //     padding: WidgetStatePropertyAll(EdgeInsets.zero),
        //   ),
        //   onPressed: () {},
        //   label: Icon(
        //     Icons.arrow_forward,
        //     color: AppColors.primary,
        //     size: 17,
        //   ),
        //   icon: Text(
        //     "See All",
        //     style: AppFontStyle.text_14_400(
        //       AppColors.primary,
        //       fontFamily: AppFontFamily.gilroyMedium,
        //     ),
        //   ),
        // ),
      ],
    );
  }

   balanceStatistics() {
    final walletOverView =
        controller.walletApiData.value.data?.walletOverview?.stats;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Wallet Overview",
              style: AppFontStyle.text_20_400(
                AppColors.darkText,
                fontFamily: AppFontFamily.gilroySemiBold,
              ),
            ),
            Obx(
              () => CustomDropDown(
                btnWidth: 145.w,
                border: Border.all(color: AppColors.greyClr.withAlpha(50)),
                textStyle: AppFontStyle.text_14_400(
                  AppColors.black,
                  fontFamily: AppFontFamily.gilroyMedium,
                ),
                hintStyle: AppFontStyle.text_14_400(
                  AppColors.black,
                  fontFamily: AppFontFamily.gilroyMedium,
                ),
                padding: 5.w,
                borderRadius: 9.r,
                btnHeight: 36.h,
                items: const [
                  "Last 7 days",
                  "Last 30 days",
                  "Last 3 months",
                  "Last 12 months"
                ],
                selectedValue: controller.chartSelectedDay.value,
                onChanged: (value) {
                  if (value != null) {
                    controller.chartSelectedDay.value = value;
                    pt("controller.chartSelectedDay.value ${controller.chartSelectedDay.value}");
                    controller.getWalletApi(range: controller.chartSelectedDay.value?.replaceAll(" ", "_").toLowerCase(),isSowChartLoading: true);
                  }
                },
              ),
            ),
          ],
        ),
        hBox(16.h),
        controller.isShowChartLoading.value == true ? walletOverviewShimmer() :
        AppContainer(
          // height: 500.h,
          radius: 14,
          width: double.infinity,
          boxShadow: const [],
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: _statCard(
                          "Total Earnings",
                          "\$${walletOverView?.totalEarnings ?? "0"}",
                          AppColors.primary.withAlpha(10))),
                  wBox(12.w),
                  Expanded(
                      child: _statCard(
                          "Average",
                          "\$${walletOverView?.average ?? "0"}",
                          AppColors.blueClr.withAlpha(10))),
                ],
              ),
              hBox(10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: _statCard(
                          "Peak Day",
                          "\$${walletOverView?.peekDay ?? "0"}",
                          AppColors.purpleColor.withAlpha(8))),
                  wBox(12.w),
                  Expanded(
                      child: _statCard(
                          "Growth",
                          (walletOverView?.growth?.contains("-") ?? false) ? "${walletOverView?.growth ?? "0"}%" : "+${walletOverView?.growth ?? "0"}%",
                          AppColors.greenClr.withAlpha(10),
                          valueColor: AppColors.greenClr)),
                ],
              ),
              hBox(12.h),
              Obx(() => SizedBox(
                    height: 240,
                    child: Stack(
                      children: [
                        BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            maxY: controller.amountForChart.isEmpty ? 100 : (controller.amountForChart.reduce((a, b) => a > b ? a : b) * 1.2),
                            gridData: const FlGridData(show: false),
                            borderData: FlBorderData(show: false),
                            titlesData: FlTitlesData(
                              leftTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 30,
                                  getTitlesWidget: (value, meta) {
                                    final index = value.toInt();

                                    if (index < 0 || index >= controller.chartAllDays.length) {
                                      return const SizedBox();
                                    }

                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Text(
                                        controller.chartAllDays[index],
                                        style: AppFontStyle.text_12_400(
                                          AppColors.grey,
                                          fontFamily: AppFontFamily.gilroyMedium,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            barGroups: List.generate(
                                controller.amountForChart.length, (index) {
                              return BarChartGroupData(
                                x: index,
                                barRods: [
                                  BarChartRodData(
                                    toY: controller.amountForChart[index],
                                    width:controller.walletApiData.value.data?.walletOverview?.range == "last_30_days" ? 50.w :
                                    controller.walletApiData.value.data?.walletOverview?.range == "last_3_months" ? 86.w :
                                    controller.walletApiData.value.data?.walletOverview?.range == "last_12_months" ? 20.w :
                                    controller.walletApiData.value.data?.walletOverview?.range == "last_7_days" ? 30.w : 22.w,
                                    borderRadius: BorderRadius.only(topLeft:Radius.circular(6.r),topRight: Radius.circular(6.r)),
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.primary,
                                        AppColors.greenLightClr,
                                      ],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                    ),
                                  ),
                                ],
                              );
                            }),
                            barTouchData: BarTouchData(
                              enabled: true,
                              touchTooltipData: BarTouchTooltipData(
                                getTooltipColor: (group) => AppColors.greenClr,
                                tooltipRoundedRadius: 8,
                                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                  final day = controller.chartAllDays.length > groupIndex ? controller.chartAllDays[groupIndex] : "";
                                  return BarTooltipItem(
                                    "\$${rod.toY.toStringAsFixed(1)}\n$day",
                                    AppFontStyle.text_12_500(
                                      Colors.white,
                                      fontFamily: AppFontFamily.gilroyMedium,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        if(controller.amountForChart.isEmpty || controller.amountForChart.every((e) => e == 0))...[
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.bar_chart_outlined,
                                  size: 40,
                                  color: AppColors.primary,
                                ),
                                hBox(8.h),
                                Text(
                                  "No Data Available",
                                  style: AppFontStyle.text_14_400(
                                    AppColors.greyClr,
                                    fontFamily: AppFontFamily.gilroyMedium,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
              ),
            ],
          ),
        ),
        hBox(8.h),
      ],
    );
  }

  Widget _statCard(String title, String value, Color bgColor,
      {Color valueColor = Colors.black}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              maxLines: 2,
              style: AppFontStyle.text_12_400(AppColors.greyClr,
                  fontFamily: AppFontFamily.gilroyMedium)),
          hBox(4.h),
          Text(value,
              style: AppFontStyle.text_13_500(valueColor,
                  fontFamily: AppFontFamily.gilroyMedium)),
        ],
      ),
    );
  }

  Widget toggleButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Obx(
            () => CustomDropDown(
              btnWidth: 90.w,
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
              selectedValue: controller.selectedAll.value ?? "All",
              onChanged: (value) {
                if (value != null) {
                  controller.selectedAll.value = value;
                }
              },
            ),
          ),
        ),
        wBox(5.w),
        Flexible(
          child: Obx(
            () => CustomDropDown(
              btnWidth: 90,
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
              selectedValue: controller.selectedDay.value ?? "Today",
              onChanged: (value) {
                if (value != null) {
                  controller.selectedDay.value = value;
                }
              },
            ),
          ),
        ),
        wBox(5.w),
        Container(
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.primary,
            border: Border.all(color: AppColors.primary, width: 1),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7.0),
            child: Row(
              children: [
                SvgPicture.asset(ImageConstants.downloadLogo),
                Text(
                  "Export Transaction",
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  productDetailsCard() {
    return GridView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: controller.iconList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.05,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15),
      itemBuilder: (context, index) {
        return CustomDetailsCard(
          onTap: () {
            // type send pending_earning, total_earning and last_payout
            if(index != 0){
              Get.toNamed(VendorAppRoutes.orderTransactionDetailsScreen,
                  arguments: {
                    "earningType" :index == 1 ? "pending_earning" : index == 2 ? "total_earning" : index == 3 ? "last_payout" : "",
                  }
              );
            }
          },
          containerClr: controller.cardColor[index].withAlpha(20),
          imageClr: controller.cardColor[index],
          image: controller.iconList[index],
          title: controller.cardSubTitle[index],
          subTitle: controller.cardTitle[index],
          widget: Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (index != 3) ...[
                  AppImage(
                    path: index == 1
                        ? ImageConstants.timer
                        : ImageConstants.upwardArrow,
                    svgColor: ColorFilter.mode(
                        index == 1 ? AppColors.orange : AppColors.primary,
                        BlendMode.srcIn),
                    height: index == 1 ? 16 : 12,
                    width: index == 1 ? 16 : 10,
                  ),
                  wBox(4),
                ],
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Text(
                      controller.carddesTitle[index],
                      style: AppFontStyle.text_14_400(
                        index == 1
                            ? AppColors.orange
                            : index == 3
                                ? AppColors.greyClr
                                : AppColors.primary,
                        fontFamily: AppFontFamily.gilroyMedium,
                      ),
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

  Widget searchField() {
    return CustomTextFormField(
      prefix: Padding(
        padding: const EdgeInsets.only(left: 15, right: 10),
        child: AppImage(
          path: ImageConstants.searchLogo,
          height: 24,
          width: 24,
        ),
      ),
      hintText: "Search...",
    );
  }

  Widget shimmerWallet() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          hBox(14),

          /// Search
          const ShimmerBox(width: double.infinity, height: 50),

          hBox(20),

          /// Grid cards
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              childAspectRatio: 1.05,
            ),
            itemBuilder: (_, __) =>
                const ShimmerBox(width: double.infinity, height: 140),
          ),

          hBox(25),

          /// Wallet Overview Title
          const ShimmerBox(width: 180, height: 20),

          hBox(15),

          /// Chart container
          const ShimmerBox(width: double.infinity, height: 300),

          hBox(25),

          /// Quick Action Title
          const ShimmerBox(width: 150, height: 20),

          hBox(12),

          /// Quick Action buttons
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            itemBuilder: (_, __) =>
                const ShimmerBox(width: double.infinity, height: 50),
            separatorBuilder: (_, __) => hBox(12),
          ),

          hBox(25),

          /// Payment Details Title
          const ShimmerBox(width: 200, height: 20),

          hBox(12),

          /// Payment cards
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 2,
            itemBuilder: (_, __) =>
                const ShimmerBox(width: double.infinity, height: 150),
            separatorBuilder: (_, __) => hBox(12),
          ),

          hBox(25),

          /// Recent Transactions Title
          const ShimmerBox(width: 180, height: 20),

          hBox(12),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            itemBuilder: (_, __) =>
                const ShimmerBox(width: double.infinity, height: 70),
            separatorBuilder: (_, __) => hBox(10),
          ),

          hBox(60),
        ],
      ),
    );
  }

  Widget walletOverviewShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Column(
            children: [

              /// First Row Stats
              Row(
                children: [
                  Expanded(
                    child: ShimmerBox(height: 70, width: double.infinity, radius: 12),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ShimmerBox(height: 70, width: double.infinity, radius: 12),
                  ),
                ],
              ),

              SizedBox(height: 10),

              /// Second Row Stats
              Row(
                children: [
                  Expanded(
                    child: ShimmerBox(height: 70, width: double.infinity, radius: 12),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ShimmerBox(height: 70, width: double.infinity, radius: 12),
                  ),
                ],
              ),

              SizedBox(height: 20),

              /// Chart Area
              ShimmerBox(
                width: double.infinity,
                height: 240,
                radius: 12,
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),
      ],
    );
  }

}
