import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gyaawa/apps/vendor_app/Gyaawa/Pages/Wallet/Subscreen_wallet/controller/restaurant_withdraw_controller.dart';
import 'package:gyaawa/apps/vendor_app/Gyaawa/Pages/Wallet/controller/restaurant_wallets_controller.dart';

import '../../../../../../../shared/theme/colors.dart';
import '../../../../../../../shared/theme/font_family.dart';
import '../../../../../../../shared/theme/font_style.dart';
import '../../../../../../../shared/widgets/custom_appbar.dart';

class RestaurantWithdrawScreen extends StatefulWidget {
  RestaurantWithdrawScreen({super.key});

  @override
  State<RestaurantWithdrawScreen> createState() => _RestaurantWithdrawScreenState();
}

class _RestaurantWithdrawScreenState extends State<RestaurantWithdrawScreen> {
  final RestaurantWithdrawController withdrawController =   Get.put(RestaurantWithdrawController());

  final RestaurantWalletsController restaurantWalletsController = Get.put(RestaurantWalletsController());

  // final  RestaurantBankAccountDetailsController  restaurantBankAccountDetailsController = Get.put(RestaurantBankAccountDetailsController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // restaurantBankAccountDetailsController.g/etSingleBankAccountDetailsApi(isRefresh: true);
      withdrawController.amountController.value.clear();
    },);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: SafeArea(
        child: Scaffold(
          appBar: CustomAppBar(
            title: Text(
              "Withdraw",
              style: AppFontStyle.text_20_600(
                AppColors.darkText,
                fontFamily: AppFontFamily.gilroyRegular,
              ),
            ),
          ),
          // body: Obx(
          //   () {
          //     switch (restaurantWalletsController.rxRequestStatus.value) {
          //       case ApiStatus.LOADING:
          //         return Center(child: circularProgressIndicator());
          //       case ApiStatus.ERROR:
          //         if (restaurantWalletsController.error.value ==
          //             'No internet') {
          //           return InternetExceptionWidget(
          //             onPress: () {
          //               restaurantWalletsController.getVendorWalletDetails();
          //             },
          //           );
          //         } else {
          //           return GeneralExceptionWidget(
          //             onPress: () {
          //               restaurantWalletsController.getVendorWalletDetails();
          //             },
          //           );
          //         }
          //       case ApiStatus.COMPLETED:
          //         return RefreshIndicator(
          //           onRefresh: () {
          //          return restaurantWalletsController.getVendorWalletDetails();
          //           },
          //           child: SingleChildScrollView(
          //             physics: const AlwaysScrollableScrollPhysics(),
          //             child: Padding(
          //               padding: const EdgeInsets.symmetric(horizontal: 20),
          //               child: Column(
          //                 children: [
          //                   currentBalanceCard(),
          //                   hBox(18.h),
          //                   amountEnterField(),
          //                   hBox(15.h),
          //                   // amountButton(),
          //                   hBox(10.h),
          //                   continueButton()
          //                 ],
          //               ),
          //             ),
          //           ),
          //         );
          //     }
          //     },
          // ),
        ),
      ),
    );
  }

  //  continueButton() {
  //   return Obx(
  //     ()=> CustomElevatedButton(
  //       isLoading: restaurantBankAccountDetailsController.rxWithdrawRequestStatus.value == ApiStatus.LOADING,
  //       onPressed: () {
  //         if(restaurantBankAccountDetailsController.rxGetBankAccountRequestStatus.value != ApiStatus.LOADING){
  //           if(withdrawController.amountController.value.text.isEmpty ||
  //               (double.tryParse(withdrawController.amountController.value.text) ?? 0)
  //                   <double.parse(restaurantWalletsController.apiData.value.minAmount.toString())){
  //             if(restaurantBankAccountDetailsController.getBankAccountData.value.account == null){
  //               Get.toNamed(AppRoutes.addRestaurantBankDetails);
  //             }else {
  //               withdrawController.isError.value = true;
  //               withdrawController.formKey.currentState?.validate();
  //             }
  //           }else{
  //          if((withdrawController.formKey.currentState?.validate()  ?? false )) {
  //            // Get.toNamed(AppRoutes.bankAccountDetailsScreen);
  //            if (restaurantBankAccountDetailsController.getBankAccountData.value.account == null) {
  //              Get.toNamed(AppRoutes.addRestaurantBankDetails);
  //            } else {
  //              restaurantBankAccountDetailsController.withdrawApi(context, withdrawController.amountController.value.text);
  //            }
  //          }
  //           }
  //         }
  //       },
  //       text: "Continue",
  //     ),
  //   );
  // }
  //
  // SizedBox amountButton() {
  //   return SizedBox(
  //     height: 48,
  //     child: Padding(
  //       padding: const EdgeInsets.symmetric(vertical: 5.0),
  //       child: ListView.separated(
  //         scrollDirection: Axis.horizontal,
  //         itemBuilder: (context, index) {
  //           return GestureDetector(
  //             onTap: () {
  //               index == 0
  //                   ? withdrawController.amountController.value.text = "50"
  //                   : index == 1
  //                       ? withdrawController.amountController.value.text = "100"
  //                       : index == 2
  //                           ? withdrawController.amountController.value.text =
  //                               "150"
  //                           : "";
  //               if (kDebugMode) {
  //                 print(withdrawController.amountController.value.text);
  //                 print(withdrawController.amountController.value.text.runtimeType);
  //               }
  //             },
  //             child: Container(
  //               height: 43,
  //               width: 100,
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(100),
  //                 border: Border.all(
  //                   color: AppColors.black,
  //                   width: 1,
  //                 ),
  //               ),
  //               child: Center(
  //                 child: Text(
  //                   index == 0
  //                       ? "\$50"
  //                       : index == 1
  //                           ? "\$100"
  //                           : index == 2
  //                               ? "\$150"
  //                               : "",
  //                   style: AppFontStyle.text_16_500(
  //                     AppColors.darkText,
  //                     fontFamily: AppFontFamily.gilroyRegular,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           );
  //         },
  //         separatorBuilder: (context, index) => wBox(10.h),
  //         itemCount: 3,
  //       ),
  //     ),
  //   );
  // }

  // amountEnterField() {
  //   return Obx(
  //     ()=> Form(
  //       key: withdrawController.formKey,
  //       child: CustomTextFormField(
  //           controller: withdrawController.amountController.value,
  //           hintText: "Enter Amount",
  //           textInputType: const TextInputType.numberWithOptions(decimal: true),
  //           validator: (value) {
  //             if(withdrawController.isError.value == true){
  //               if (value == null || value.isEmpty) {
  //               return "Please enter amount.";
  //             }else if ((double.tryParse(value) ?? 0) <double.parse(restaurantWalletsController.apiData.value.minAmount.toString())) {
  //                 return "Please enter at least \$${restaurantWalletsController.apiData.value.minAmount.toString()}";
  //               }
  //               else if ((double.tryParse(value) ?? 0) > (double.tryParse(restaurantWalletsController.apiData.value.wallet?.walletBalance ?? '0') ?? 0)) {
  //                 return restaurantWalletsController.apiData.value.wallet?.walletBalance == null? "Insufficient Balance": "Amount must be less than or equal to "
  //                     "${restaurantWalletsController.apiData.value.wallet?.walletBalance}";
  //               }}
  //             return null;
  //           },
  //           prefix: Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 15.0),
  //             child: Text(
  //               "＄",
  //               style:AppFontStyle.customText( AppColors.mediumText.withOpacity(0.6), 17.sp,  FontWeight.w800, fontFamily: AppFontFamily.gilroyBold)
  //             ),
  //           ),
  //         ),
  //       ),
  //   );
  // }

  // Container currentBalanceCard() {
  //   return Container(
  //     width: Get.width,
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(15),
  //       color: AppColors.primary.withOpacity(0.1),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         hBox(18.h),
  //         Text(
  //           "Wallet Balance",
  //           style: AppFontStyle.text_16_400(
  //             AppColors.darkText,
  //             fontFamily: AppFontFamily.gilroyMedium,
  //           ),
  //         ),
  //         hBox(8.h),
  //         // Text(
  //         //   "\$${restaurantWalletsController.apiData.value.wallet?.walletBalance.toString() ?? "0"}",
  //         //   style: AppFontStyle.text_26_600(
  //         //     AppColors.primary,
  //         //     fontFamily: AppFontFamily.gilroyRegular,
  //         //   ),
  //         // ),
  //         hBox(18.h),
  //       ],
  //     ),
  //   );
  // }
}
