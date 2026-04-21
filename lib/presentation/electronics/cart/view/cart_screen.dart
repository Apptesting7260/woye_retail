import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:gyaawa/Routes/app_routes.dart';
import 'package:gyaawa/presentation/common/tab_bar/common_tab_bar.dart';
import 'package:gyaawa/presentation/electronics/cart/controller/cart_controller.dart';
import 'package:gyaawa/shared/widgets/custom_elevated_button.dart';
import 'package:gyaawa/shared/widgets/custom_text_form_field.dart';
import 'package:gyaawa/shared/widgets/image.dart';

import '../../../../Core/Constant/image_constant.dart';
import '../../../../Utils/sized_box.dart';
import '../../../../shared/theme/colors.dart';
import '../../../../shared/theme/font_family.dart';
import '../../../../shared/theme/font_style.dart';
import '../model/cart_model.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartController controller = Get.put(CartController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              CustomCategoryBar(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Shopping Cart",
                              style: AppFontStyle.text_26_600(
                                AppColors.black,
                                fontFamily: AppFontFamily.interBold,
                              ),
                            ),
                            hBox(2),
                            Text(
                              "4 items from 3 vendors",
                              style: AppFontStyle.text_14_400(
                                AppColors.buttonHideColor,
                                fontFamily: AppFontFamily.interRegular,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {},
                          icon: SvgPicture.asset(
                            ImageConstants.shareSvg,
                            height: 25,
                            width: 25,
                          ),
                        ),
                      ],
                    ),
                    hBox(20),
                    Container(
                      height: 70,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              width: 0.6, color: AppColors.borderClr)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox.adaptive(
                            value: true,
                            onChanged: null,
                            visualDensity: VisualDensity.compact,
                            checkColor: AppColors.white,
                            fillColor: MaterialStateProperty.all(
                                AppColors.buttonColor),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "Select All (4 items)",
                            style: AppFontStyle.text_14_500(
                              AppColors.black,
                              fontFamily: AppFontFamily.interMedium,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "4 selected",
                            style: AppFontStyle.text_14_500(
                              AppColors.greyTextColor,
                              fontFamily: AppFontFamily.interMedium,
                            ),
                          ),
                          wBox(10),
                        ],
                      ),
                    ),
                    hBox(10),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   children: [
                    //     Checkbox.adaptive(
                    //       value: true,
                    //       onChanged: null,
                    //       visualDensity: VisualDensity.compact,
                    //       checkColor: AppColors.white,
                    //       fillColor: MaterialStateProperty.all(AppColors.buttonColor),
                    //     ),
                    //     wBox(6),
                    //     Icon(Icons.home, size: 22, color: AppColors.greyTextColor),
                    //     wBox(6),
                    //     Expanded(
                    //       child: Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         mainAxisSize: MainAxisSize.min,
                    //         children: [
                    //           Text(
                    //             "StyleHub",
                    //             style: AppFontStyle.text_14_500(
                    //               AppColors.black,
                    //               fontFamily: AppFontFamily.interMedium,
                    //             ),
                    //           ),
                    //           Text(
                    //             "(4 items)",
                    //             style: AppFontStyle.text_12_400(
                    //               AppColors.buttonHideColor,
                    //               fontFamily: AppFontFamily.interRegular,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //     Row(
                    //       children: [
                    //         Icon(Icons.local_shipping_outlined, size: 22, color: AppColors.greyTextColor),
                    //         wBox(7),
                    //         Text(
                    //           "Free Shipping",
                    //           style: AppFontStyle.text_14_500(
                    //             AppColors.greenTextClr,
                    //             fontFamily: AppFontFamily.interMedium,
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //     wBox(10),
                    //   ],
                    // ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.cartStores.length,
                      itemBuilder: (context, index) {
                        return cartCardWidget(controller.cartStores[index]);
                      },
                    ),
                    hBox(20),
                    orderSummaryWidget(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget cartCardWidget(CartStore store) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.borderClr, width: 0.6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Checkbox.adaptive(
                  value: true,
                  onChanged: null,
                  visualDensity: VisualDensity.compact,
                  checkColor: AppColors.white,
                  fillColor: MaterialStateProperty.all(AppColors.buttonColor),
                ),
                wBox(6),
                Icon(Icons.home, size: 20, color: AppColors.greyTextColor),
                wBox(6),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        store.storeName,
                        style: AppFontStyle.text_14_500(
                          AppColors.black,
                          fontFamily: AppFontFamily.interMedium,
                        ),
                      ),
                      Text(
                        "${store.itemCount} item${store.itemCount > 1 ? 's' : ''}",
                        style: AppFontStyle.text_12_400(
                          AppColors.buttonHideColor,
                          fontFamily: AppFontFamily.interRegular,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      store.isFreeShipping
                          ? Icons.local_shipping_outlined
                          : Icons.info_outline,
                      size: 16,
                      color: store.isFreeShipping
                          ? AppColors.greenTextClr
                          : AppColors.greyTextColor,
                    ),
                    wBox(4),
                    SizedBox(
                      width: 110,
                      child: Text(
                        store.shippingInfo,
                        maxLines: 2,
                        style: AppFontStyle.text_12_400(
                          store.isFreeShipping
                              ? AppColors.greenTextClr
                              : AppColors.greyTextColor,
                          fontFamily: AppFontFamily.interRegular,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: store.products.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              return _productRow(store.products[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _productRow(CartProduct product) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox.adaptive(
            value: true,
            onChanged: null,
            visualDensity: VisualDensity.compact,
            checkColor: AppColors.white,
            fillColor: MaterialStateProperty.all(AppColors.buttonColor),
          ),
          wBox(3),
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: AppImage(
                  path: product.image,
                  width: 84,
                  height: 84,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 6,
                left: 6,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "${product.discount}% OFF",
                    style: AppFontStyle.text_10_500(
                      AppColors.white,
                      fontFamily: AppFontFamily.interMedium,
                    ),
                  ),
                ),
              ),
            ],
          ),
          wBox(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        product.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppFontStyle.text_14_500(
                          AppColors.black,
                          fontFamily: AppFontFamily.interMedium,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.delete_outline_rounded,
                      size: 22,
                      color: AppColors.greyTextColor,
                    ),
                  ],
                ),
                hBox(4),
                Text(
                  product.category,
                  style: AppFontStyle.text_12_400(
                    AppColors.buttonHideColor,
                    fontFamily: AppFontFamily.interRegular,
                  ),
                ),
                hBox(6),
                Row(
                  children: [
                    Text(
                      "GHS ${product.price.toStringAsFixed(2)}",
                      style: AppFontStyle.text_16_600(
                        AppColors.black,
                        fontFamily: AppFontFamily.interBold,
                      ),
                    ),
                    wBox(6),
                    Text(
                      "GHS ${product.oldPrice.toStringAsFixed(2)}",
                      style: AppFontStyle.text_14_400(
                        AppColors.buttonHideColor,
                        fontFamily: AppFontFamily.interRegular,
                      ).copyWith(decoration: TextDecoration.lineThrough),
                    ),
                  ],
                ),
                hBox(7),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 7),
                      decoration: BoxDecoration(
                        color: AppColors.overlayColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Icon(Icons.remove,
                                size: 20, color: AppColors.black),
                          ),
                          wBox(10),
                          Text(
                            "${product.quantity}",
                            style: AppFontStyle.text_14_500(
                              AppColors.black,
                              fontFamily: AppFontFamily.interMedium,
                            ),
                          ),
                          wBox(10),
                          GestureDetector(
                            onTap: () {},
                            child: Icon(Icons.add,
                                size: 20, color: AppColors.black),
                          ),
                        ],
                      ),
                    ),
                    wBox(10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "GHS ${product.price.toStringAsFixed(2)}",
                          style: AppFontStyle.text_14_600(
                            AppColors.black,
                            fontFamily: AppFontFamily.interBold,
                          ),
                        ),
                        Text(
                          "Save GHS ${product.savings.toStringAsFixed(0)}",
                          style: AppFontStyle.text_12_400(
                            AppColors.greenLightClr,
                            fontFamily: AppFontFamily.interRegular,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
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
              // hBox(8),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text("Coupon (SAVE20)", style: AppFontStyle.text_13_400(AppColors.buttonHideColor, fontFamily: AppFontFamily.interRegular)),
              //     Text("-GHS 150.00", style: AppFontStyle.text_13_500(Colors.red, fontFamily: AppFontFamily.interMedium)),
              //   ],
              // ),
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
                Get.toNamed(AppRoutes.shippingPaymentScreen);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Proceed to Checkout",
                    style: AppFontStyle.text_14_500(
                      AppColors.white,
                      fontFamily: AppFontFamily.interMedium,
                    ),
                  ),
                  wBox(8),
                  Icon(Icons.arrow_forward, color: AppColors.white, size: 18),
                ],
              ),
            ),
          ),
          hBox(10),
          CustomElevatedButton(
            onPressed: () {},
            color: AppColors.white,
              text: "Continue Shopping",
            borderSide: BorderSide(color: AppColors.borderClr, width: 1),
            textColor: AppColors.black,
            ),

          hBox(12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.yellowLightBtnClr,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.greenLightClr, width: 0.2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                wBox(6),
                Text(
                  "💡 Free Shipping Tip",
                  style: AppFontStyle.text_13_500(
                    AppColors.black,
                    fontFamily: AppFontFamily.interMedium,
                  ),
                ),
                hBox(6),
                Text(
                  "Add GHS 350.01 more from MensWear Plus for free shippingAdd GHS 300.01 more from SmartHome Plus for free shipping",
                  maxLines: 3,
                  style: AppFontStyle.text_10_500(
                    AppColors.greenTextClr,
                    fontFamily: AppFontFamily.interRegular,
                  ),
                ),
              ],
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
