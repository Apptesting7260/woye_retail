import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gyaawa/Core/Constant/image_constant.dart';
import 'package:gyaawa/shared/widgets/custom_elevated_button.dart';
import '../../../../../../Utils/sized_box.dart';
import '../../../../../../routes/user_routes/user_app_routes.dart';
import '../../../../../../shared/theme/colors.dart';
import '../../../../../../shared/theme/font_family.dart';
import '../../../../../../shared/theme/font_style.dart';
import '../../../../../../shared/widgets/custom_text_form_field.dart';
import '../../../common/app_bar/common_app_bar.dart';
import '../../../common/tab_bar/common_tab_bar.dart';
import '../controller/shipping_payment_controller.dart';

class PlaceOrderScreen extends StatefulWidget {

  const PlaceOrderScreen({super.key});

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  final ShippingPaymentController controller =
      Get.put(ShippingPaymentController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              CustomCategoryBar(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonAppBar(title: "Delivery Address",),
                Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.borderClr, width: 0.6),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.location_on_outlined, size: 16, color: AppColors.greyTextColor),
                                wBox(6),
                                Text(
                                  "Shipping Information",
                                  style: AppFontStyle.text_13_400(
                                      AppColors.greyTextColor, fontFamily: AppFontFamily.interRegular),
                                ),
                              ],
                            ),
                            hBox(16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Delivery Address",
                                  style: AppFontStyle.text_16_600(
                                      AppColors.black, fontFamily: AppFontFamily.interBold),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.toNamed(UserRoutes.selectDeliveryAddress);
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        "Change Address",
                                        style: AppFontStyle.text_12_400(
                                            AppColors.buttonColor, fontFamily: AppFontFamily.interRegular),
                                      ),
                                      wBox(2),
                                      Icon(Icons.arrow_forward, size: 12, color: AppColors.buttonColor),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            hBox(12),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: AppColors.white, borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.cardBorder, width: 1),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Home",
                                    style: AppFontStyle.text_15_600(
                                        AppColors.black, fontFamily: AppFontFamily.onestSemiBold),
                                  ),
                                  wBox(12),
                                  Expanded(
                                    child: Text(
                                      "D 888 Abc Road, Greenfield, Abc Manchester, 199, South Africa",
                                      maxLines: 2,
                                      style: AppFontStyle.text_13_400(
                                          AppColors.buttonHideColor, fontFamily: AppFontFamily.interRegular),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            hBox(20),
                            Text(
                              "Shipping Method",
                              style: AppFontStyle.text_14_500(
                                  AppColors.buttonHideColor, fontFamily: AppFontFamily.interMedium),
                            ),
                            hBox(10),
                            Obx(() => Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () =>
                                          controller.selectedShipping.value =
                                              "Standard Shipping (3-5 days)",
                                      child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 14, vertical: 14), decoration: BoxDecoration(
                                          color: AppColors.white,
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(color: AppColors.borderClr, width: 0.6),
                                        ),
                                        child: Row(
                                          children: [
                                            _shippingRadio(controller.selectedShipping.value == "Standard Shipping (3-5 days)"),
                                            wBox(12),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    "Standard Shipping (3-5 days)",
                                                    style: AppFontStyle.text_14_500(
                                                            AppColors.black, fontFamily: AppFontFamily.interMedium)),
                                                hBox(2),
                                                Text("Included",
                                                    style: AppFontStyle.text_12_400(
                                                        AppColors.buttonHideColor, fontFamily: AppFontFamily.interRegular)),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    hBox(10),
                                    GestureDetector(
                                      onTap: () =>
                                          controller.selectedShipping.value =
                                              "Express Shipping (2-3 days)",
                                      child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 14, vertical: 14),
                                        decoration: BoxDecoration(
                                          color: AppColors.white,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              color: AppColors.borderClr,
                                              width: 0.6),
                                        ),
                                        child: Row(
                                          children: [
                                            _shippingRadio(controller
                                                    .selectedShipping.value ==
                                                "Express Shipping (2-3 days)"),
                                            wBox(12),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    "Express Shipping (2-3 days)",
                                                    style: AppFontStyle
                                                        .text_14_500(
                                                            AppColors.black,
                                                            fontFamily:
                                                                AppFontFamily
                                                                    .interMedium)),
                                                hBox(2),
                                                Text("+GHS 25.00",
                                                    style: AppFontStyle.text_12_400(
                                                        AppColors
                                                            .buttonHideColor,
                                                        fontFamily:
                                                            AppFontFamily
                                                                .interRegular)),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    hBox(10),
                                    GestureDetector(
                                      onTap: () => controller.selectedShipping
                                          .value = "Overnight Shipping (1 day)",
                                      child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 14, vertical: 14),
                                        decoration: BoxDecoration(
                                          color: AppColors.white,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              color: AppColors.borderClr,
                                              width: 0.6),
                                        ),
                                        child: Row(
                                          children: [
                                            _shippingRadio(controller
                                                    .selectedShipping.value ==
                                                "Overnight Shipping (1 day)"),
                                            wBox(12),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    "Overnight Shipping (1 day)",
                                                    style: AppFontStyle
                                                        .text_14_500(
                                                            AppColors.black,
                                                            fontFamily:
                                                                AppFontFamily
                                                                    .interMedium)),
                                                hBox(2),
                                                Text("+GHS 70.00",
                                                    style: AppFontStyle.text_12_400(
                                                        AppColors
                                                            .buttonHideColor,
                                                        fontFamily:
                                                            AppFontFamily
                                                                .interRegular)),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                            hBox(24),
                            Text(
                              "Payment Method",
                              style: AppFontStyle.text_16_600(AppColors.black,
                                  fontFamily: AppFontFamily.interBold),
                            ),
                            hBox(12),
                            Obx(() => Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () =>
                                          controller.selectedPayment.value = 0,
                                      child: Container(
                                        height: 60,
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 14, vertical: 14),
                                        decoration: BoxDecoration(
                                          color: AppColors.white,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              color: AppColors.borderClr,
                                              width: 0.6),
                                        ),
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                              ImageConstants.walletSvg,
                                              width: 30,
                                            ),
                                            wBox(12),
                                            Expanded(
                                                child: Text("My Wallet (\$400)",
                                                    style: AppFontStyle.text_14_500(
                                                        AppColors.black,
                                                        fontFamily:
                                                            AppFontFamily
                                                                .interMedium))),
                                            _radioIcon(controller
                                                    .selectedPayment.value ==
                                                0),
                                          ],
                                        ),
                                      ),
                                    ),
                                    hBox(10),
                                    GestureDetector(
                                      onTap: () =>
                                          controller.selectedPayment.value = 1,
                                      child: Container(
                                        height: 60,
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 14, vertical: 14),
                                        decoration: BoxDecoration(
                                          color: AppColors.white,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              color: AppColors.borderClr,
                                              width: 0.6),
                                        ),
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                              ImageConstants.mtnSvg,
                                              width: 30,
                                            ),
                                            wBox(12),
                                            Expanded(
                                                child: Text("MTN  +34 •• 321",
                                                    style: AppFontStyle.text_14_500(
                                                        AppColors.black,
                                                        fontFamily:
                                                            AppFontFamily
                                                                .interMedium))),
                                            _radioIcon(controller
                                                    .selectedPayment.value ==
                                                1),
                                          ],
                                        ),
                                      ),
                                    ),
                                    hBox(10),
                                    GestureDetector(
                                      onTap: () =>
                                          controller.selectedPayment.value = 2,
                                      child: Container(
                                        height: 60,
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 14, vertical: 14),
                                        decoration: BoxDecoration(
                                          color: AppColors.white,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              color: AppColors.borderClr,
                                              width: 0.6),
                                        ),
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                              ImageConstants.moneySvg,
                                              width: 30,
                                            ),
                                            wBox(12),
                                            Expanded(
                                                child: Text("Cash on Delivery",
                                                    style: AppFontStyle.text_14_500(
                                                        AppColors.black, fontFamily: AppFontFamily.interMedium))),
                                            _radioIcon(controller.selectedPayment.value == 2),
                                          ],
                                        ),
                                      ),
                                    ),
                                    hBox(10),
                                    GestureDetector(
                                      onTap: () => controller.selectedPayment.value = 3,
                                      child: Container(
                                        width: double.infinity, height: 60,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 14, vertical: 14),
                                        decoration: BoxDecoration(
                                          color: AppColors.white, borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                              color: AppColors.borderClr, width: 0.6),
                                        ),
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                              ImageConstants.bubbleSvg, width: 30,
                                            ),
                                            wBox(12),
                                            Expanded(
                                                child: Text(
                                                    "•••• •••• •••• 8888",
                                                    style: AppFontStyle.text_14_500(
                                                        AppColors.black, fontFamily: AppFontFamily.interMedium))),
                                            _radioIcon(controller.selectedPayment.value == 3),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                            hBox(30),
                          ],
                        ),
                      ),
                    ),
                    hBox(20),
                    Center(
                      child: CustomElevatedButton(
                        width: 309,
                        color: AppColors.buttonColor,
                        onPressed: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Add New Payment Method",
                              style: AppFontStyle.text_14_500(
                                AppColors.white,
                                fontFamily: AppFontFamily.interMedium,
                              ),
                            ),
                            wBox(8),
                            Icon(Icons.arrow_forward_ios_sharp,
                                color: AppColors.white, size: 18),
                          ],
                        ),
                      ),
                    ),
                    hBox(20),
                    orderSummaryWidget()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _shippingRadio(bool isSelected) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? AppColors.buttonColor : AppColors.greyTextColor,
          width: 2,
        ),
      ),
      child: isSelected
          ? Center(
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: AppColors.buttonColor),
              ),
            )
          : null,
    );
  }

  Widget _radioIcon(bool isSelected) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? AppColors.buttonColor : Colors.transparent,
        border: Border.all(
          color: isSelected ? AppColors.buttonColor : AppColors.greyTextColor,
          width: 2,
        ),
      ),
      child: isSelected
          ? const Icon(Icons.check, size: 14, color: Colors.white)
          : null,
    );
  }

  Widget orderSummaryWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.borderClr, width: 0.6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.shopping_bag_outlined,
                  size: 20, color: AppColors.black),
              wBox(8),
              Text(
                "Order Summary",
                style: AppFontStyle.text_16_600(
                  AppColors.black,
                  fontFamily: AppFontFamily.interBold,
                ),
              ),
            ],
          ),

          hBox(14),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color:AppColors.fillClr2,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "4 of 4 items selected",
              style: AppFontStyle.text_13_500(
                AppColors.blueColor,
                fontFamily: AppFontFamily.interMedium,
              ),
            ),
          ),
          hBox(12),
          Row(
            children: [
              CustomTextFormField(
                height: 50,
                width: 260,
                hintText: "Enter code",
                borderRadius: BorderRadius.circular(10),
                fillColor: AppColors.searchText,
              ),
              wBox(6),
              CustomElevatedButton(
                  height: 50,
                  color: AppColors.searchText,
                  width: 70,
                  text: "Apply",textColor: AppColors.black,
                  onPressed: (){}
              )
            ],
          ),
          hBox(16),
          const Divider(height: 1),
          hBox(14),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Subtotal (4 items)", style: AppFontStyle.text_13_400(AppColors.buttonHideColor, fontFamily: AppFontFamily.interRegular)),
                  Text("GHS 949.96", style: AppFontStyle.text_13_500(AppColors.black, fontFamily: AppFontFamily.interMedium)),
                ],
              ),
              hBox(8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.local_offer_outlined,size: 16,color: AppColors.greenTextClr,),
                      wBox(4),
                      Text("Savings", style: AppFontStyle.text_13_400(AppColors.greenTextClr, fontFamily: AppFontFamily.interRegular)),
                    ],
                  ),
                  Text("-GHS 430", style: AppFontStyle.text_13_500(AppColors.greenTextClr, fontFamily: AppFontFamily.interMedium)),
                ],
              ),
              hBox(8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.local_shipping_outlined,size: 16,color: AppColors.buttonHideColor,),
                      wBox(4),
                      Text("StyleHub shipping", style: AppFontStyle.text_13_400(AppColors.buttonHideColor, fontFamily: AppFontFamily.interRegular)),
                    ],
                  ),
                  Text("FREE", style: AppFontStyle.text_13_500(AppColors.greenTextClr, fontFamily: AppFontFamily.interMedium)),
                ],
              ),
              hBox(8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.local_shipping_outlined,size: 16,color: AppColors.buttonHideColor,),
                      wBox(4),
                      Text("MensWear Plus shipping", style: AppFontStyle.text_13_400(AppColors.buttonHideColor, fontFamily: AppFontFamily.interRegular)),
                    ],
                  ),
                  Text("GHS 25.00", style: AppFontStyle.text_13_500(AppColors.black, fontFamily: AppFontFamily.interMedium)),
                ],
              ),
              hBox(8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.local_shipping_outlined,size: 16,color: AppColors.buttonHideColor,),
                      wBox(4),
                      Text("SmartHome Plus shipping", style: AppFontStyle.text_13_400(AppColors.buttonHideColor, fontFamily: AppFontFamily.interRegular)),
                    ],
                  ),
                  Text("GHS 25.00", style: AppFontStyle.text_13_500(AppColors.black, fontFamily: AppFontFamily.interMedium)),
                ],
              ),
              hBox(8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Tax (8%)", style: AppFontStyle.text_13_400(AppColors.buttonHideColor, fontFamily: AppFontFamily.interRegular)),
                  Text("GHS 76.00", style: AppFontStyle.text_13_500(AppColors.black, fontFamily: AppFontFamily.interMedium)),
                ],
              ),
              hBox(8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Coupon (SAVE20)", style: AppFontStyle.text_13_400(AppColors.buttonHideColor, fontFamily: AppFontFamily.interRegular)),
                  Text("-GHS 150.00", style: AppFontStyle.text_13_500(Colors.red, fontFamily: AppFontFamily.interMedium)),
                ],
              ),
            ],
          ),
          hBox(14),
          const Divider(height: 1),
          hBox(14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total",
                style: AppFontStyle.text_16_600(
                  AppColors.black,
                  fontFamily: AppFontFamily.interBold,
                ),
              ),
              Text(
                "GHS 1,075.957",
                style: AppFontStyle.text_16_600(
                  AppColors.buttonColor,
                  fontFamily: AppFontFamily.interBold,
                ),
              ),
            ],
          ),

          hBox(12),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.yellowLightBtnClr,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "You're saving GHS 430 on this order!",
              textAlign: TextAlign.center,
              style: AppFontStyle.text_13_500(
                AppColors.greenTextClr,
                fontFamily: AppFontFamily.interMedium,
              ),
            ),
          ),

          hBox(16),
          SizedBox(
            width: double.infinity,
            child: CustomElevatedButton(
              color: AppColors.buttonColor,
              onPressed: () {
                Get.toNamed(UserRoutes.shippingPaymentScreen);
              },
              text: "Place Order",
            ),
          ),
          hBox(14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shield_outlined,
                  size: 16, color: AppColors.greyTextColor),
              wBox(6),
              Text(
                "Secure Checkout",
                style: AppFontStyle.text_12_400(
                  AppColors.greyTextColor,
                  fontFamily: AppFontFamily.interRegular,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
