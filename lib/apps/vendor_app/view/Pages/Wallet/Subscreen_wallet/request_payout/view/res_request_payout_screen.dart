import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../Core/Constant/image_constant.dart';
import '../../../../../../../../Data/components/general_exception.dart';
import '../../../../../../../../Data/components/internet_exception.dart';
import '../../../../../../../../Data/response/status.dart';
import '../../../../../../../../Utils/sized_box.dart';
import '../../../../../../../../routes/vendor_routes/vendor_app_routes.dart';
import '../../../../../../../../shared/theme/colors.dart';
import '../../../../../../../../shared/theme/font_family.dart';
import '../../../../../../../../shared/theme/font_style.dart';
import '../../../../../../../../shared/widgets/custom_appbar.dart';
import '../../../../../../../../shared/widgets/custom_elevated_button.dart';
import '../../../../../../../../shared/widgets/image.dart';
import '../../../../../../../../shared/widgets/shimmer_widget.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/app_container.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/custom_dropdown.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/custom_text_form_field.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/print.dart';
import '../../../../Profile/Sub_Screens/Setting/RestaurantInFormation/view/restaurant_information_screen.dart';
import '../controller/res_request_payout_controller.dart';

class ResRequestPayoutScreen extends GetView<ResRequestPayoutController>{
  const ResRequestPayoutScreen({super.key});

  @override
  build(BuildContext context){
    return Scaffold(
      appBar: const CustomAppBar(),
      body:Obx(() {
        switch(controller.payOutData.value.status){
          case ApiStatus.LOADING :
            return payoutShimmer();
          case ApiStatus.ERROR:
            if (controller.payOutData.value.message == 'No internet' ||
                controller.payOutData.value.message == 'InternetExceptionWidget') {
              return InternetExceptionWidget(
                onPress: () {
                  controller.getPayOutData();
                },
              );
            } else {
              return GeneralExceptionWidget(
                onPress: () {
                  controller.getPayOutData();
                },
              );
            }

          case ApiStatus.COMPLETED:
            return body();

          default :
            return const SizedBox.shrink();
        }
      },),
      bottomNavigationBar: Obx(
        ()=> controller.payOutData.value.status == ApiStatus.LOADING ? const SizedBox.shrink() : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10),
          child: CustomElevatedButton(
              isLoading: controller.withdrawData.value.status == ApiStatus.LOADING,
              onPressed: (){
            if(controller.formKey.currentState?.validate() ?? false){
              controller.withdrawMoney();
            }
          },text: "Withdraw"),
        ),
      ),
    );
  }

  body() {
    return RefreshIndicator(
      onRefresh: () {
        return controller.getPayOutData();
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // header(
                //   title: "Withdraw",
                //   description: "Request a payout from your restaurant earnings. Funds will be transferred to your selected payment method."
                // ),
                header(
                    title: "Withdraw Amount",
                    description: "Withdraw Amount from your restaurant earnings. The amount will be transferred to your selected payment method."
                ),
                hBox(24),
                availableBalance(),
                hBox(20),
                title("Payout Amount"),
                hBox(6),
                CustomTextFormField(
                  controller: controller.payoutController,
                  prefix:Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text("\$",style: AppFontStyle.text_18_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroySemiBold)),
                  ),
                  hintText: "0.00",
                    validator: (value) {
                      final enteredAmount =
                      double.tryParse(controller.payoutController.text.trim());

                      final minWithdraw = double.tryParse(
                          controller.payOutData.value.data?.data?.minWithdrawAmount?.toString() ?? "0") ??
                          0;

                      final availableBalance = double.tryParse(
                          controller.payOutData.value.data?.data?.availableBalance?.toString() ?? "0") ??
                          0;

                      if (value == null || value.trim().isEmpty) {
                        return "Please enter amount";
                      }

                      if (enteredAmount == null || enteredAmount <= 0) {
                        return "Enter a valid amount";
                      }

                      if (enteredAmount < minWithdraw) {
                        return "Minimum withdraw amount is \$${minWithdraw.toStringAsFixed(2)}";
                      }

                      if (enteredAmount > availableBalance) {
                        return "Amount cannot be greater than available balance (\$${availableBalance.toStringAsFixed(2)})";
                      }

                      return null;
                    }
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: List.generate(controller.payoutAmountList.length, (index) => Padding(
                        padding: const EdgeInsets.only(right: 10.0,top: 10),
                        child: AppContainer(
                          onTap: () {
                            controller.payoutController.text = controller.payoutAmountList[index];
                          },
                          radius: 10,
                          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
                          boxShadow: const [],
                          color: AppColors.cardBgColor,
                          child: Text(
                           /* index == controller.payoutAmountList.length - 1
                                ? "Max \$${controller.payoutAmountList[index]}"
                                :*/ "\$${controller.payoutAmountList[index]}",
                          style: AppFontStyle.text_15_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroyMedium),
                          ),
                        ),
                      ),
                    ),
                    ),
                    if(controller.maxWithdrawAmount.value != "" && (double.tryParse(controller.maxWithdrawAmount.value) ?? 0) > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: AppContainer(
                        onTap: () {
                          controller.payoutController.text = controller.maxWithdrawAmount.value;
                        },
                        radius: 10,
                        padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
                        boxShadow: const [],
                        color: AppColors.cardBgColor,
                        child: Text(
                          /* index == controller.payoutAmountList.length - 1
                              ? "Max \$${controller.payoutAmountList[index]}"
                              :*/ "\$${controller.maxWithdrawAmount.value}",
                          style: AppFontStyle.text_15_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroyMedium),
                        ),
                      ),
                    ),
                  ],
                ),
                hBox(20),
                title("Payment Method",isRequired: false),
                hBox(6),
                CustomDropDown(
                    btnHeight: 56,
                    selectedValue: controller.selectedPaymentMethod.value,
                    hintText:(controller.payOutData.value.data?.data?.paymentMethods?.isEmpty ?? false) ? "No Payment method found." : "Select a payment method",
                  items: controller.payOutData.value.data?.data?.paymentMethods?.map((e) => e.name?.replaceAll("_", " ").capitalize ?? "").toList() ?? [],
                  onChanged: (val) {

                    controller.selectedPaymentMethod.value = val ?? "";

                    final selected = controller.payOutData.value.data?.data?.paymentMethods?.firstWhere((e) =>(e.name?.replaceAll("_", " ").capitalize ?? "") == val);

                    controller.selectedAccountId.value = selected?.id ?? "";
                    controller.selectedAccountType.value = selected?.type ?? "";

                    pt("Selected Name: ${controller.selectedPaymentMethod.value}");
                    pt("Selected ID: ${controller.selectedAccountId.value}");
                    pt("Selected selectedAccountType: ${controller.selectedAccountType.value}");
                  },
                  validator: (value) {
                    if(controller.selectedPaymentMethod.value.isEmpty){
                      return "Please select payment method";
                    }
                    return null;
                  },
                ),
                if((controller.payOutData.value.data?.data?.paymentMethods?.length ?? 0) < 2)...[
                hBox(14),
                CustomElevatedButton(
                  height: 56,
                  color: AppColors.white,
                  borderSide: BorderSide(color: AppColors.blackClr),
                  onPressed: () {
                   Get.toNamed(VendorAppRoutes.resManagePaymentMethod);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.add,size: 22,color: AppColors.blackClr),
                      wBox(4),
                      Text("Add New Payment Method",
                      style: AppFontStyle.text_16_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroyMedium),
                      ),
                    ],
                  ),
                ),],
                hBox(20),
                // title("Processing Priority",isRequired: false),
                // hBox(6),
                // CustomDropDown(
                //   btnHeight: 56,
                //   hintText:"Standard (No additional fee)",
                //   items: const [],
                //   onChanged: (val){},
                // ),
                // hBox(20),
                // title("Notes (Optional)",isRequired: false),
                // hBox(6),
                // const CustomTextFormField(
                //   // controller: controller.payoutController,
                //   minLines: 4,
                //   maxLines: 4,
                //   hintText: "Any special instructions or notes for this payout...",
                // ),
                // hBox(20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget availableBalance() {
    return AppContainer(
      padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 14),
      radius: 10,
      color: AppColors.greenLightClr.withAlpha(30),
      boxShadow: const [],
      border: Border.all(color: AppColors.greenLightClr),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Available Balance",style: AppFontStyle.text_14_400(AppColors.primary,fontFamily: AppFontFamily.gilroyMedium),),
              Text("\$${controller.payOutData.value.data?.data?.availableBalance ?? ""}",style: AppFontStyle.text_20_400(AppColors.primary,fontFamily: AppFontFamily.gilroyBold)),
            ],
          ),
          AppImage(path: ImageConstants.availableBalance,svgColor: ColorFilter.mode(AppColors.primary,BlendMode.srcIn))
        ],
      ),
    );
  }

  Text title(name,{bool isRequired = true}) => Text(isRequired ? "$name *" : name,style: AppFontStyle.text_16_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroySemiBold));

  Widget payoutShimmer() {
    return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 22.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Header
            ShimmerBox(width: 120, height: 22),
            SizedBox(height: 8),
            ShimmerBox(width: double.infinity, height: 14),
            SizedBox(height: 24),

            /// Available Balance Card
            ShimmerBox(width: double.infinity, height: 80, radius: 12),
            SizedBox(height: 20),

            /// Payout Amount Title
            ShimmerBox(width: 140, height: 18),
            SizedBox(height: 8),

            /// Amount Field
            ShimmerBox(width: double.infinity, height: 56),
            SizedBox(height: 16),

            /// Quick Amount Buttons
            Row(
              children: [
                Expanded(child: ShimmerBox(width: double.infinity, height: 40, radius: 8)),
                SizedBox(width: 10),
                Expanded(child: ShimmerBox(width: double.infinity, height: 40, radius: 8)),
                SizedBox(width: 10),
                Expanded(child: ShimmerBox(width: double.infinity, height: 40, radius: 8)),
              ],
            ),

            SizedBox(height: 20),

            /// Payment Method Title
            ShimmerBox(width: 150, height: 18),
            SizedBox(height: 8),

            /// Dropdown
            ShimmerBox(width: double.infinity, height: 56),
            SizedBox(height: 14),

            /// Add Payment Button
            ShimmerBox(width: double.infinity, height: 56),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}