import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gyaawa/shared/widgets/custom_elevated_button.dart';
import '../../../../../../Utils/sized_box.dart';
import '../../../../../../shared/theme/colors.dart';
import '../../../../../../shared/theme/font_family.dart';
import '../../../../../../shared/theme/font_style.dart';
import '../../tab_bar/common_tab_bar.dart';
import '../controller/select_delivery_address_controller.dart';

class SelectDeliveryAddress extends StatefulWidget {
  const SelectDeliveryAddress({super.key});

  @override
  State<SelectDeliveryAddress> createState() => _SelectDeliveryAddressState();
}

class _SelectDeliveryAddressState extends State<SelectDeliveryAddress> {
  final SelectDeliveryAddressController controller = Get.put(SelectDeliveryAddressController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              CustomCategoryBar(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
                        ),
                        wBox(10),
                        Text(
                          "Select Delivery Address",
                          style: AppFontStyle.text_22_600(AppColors.black, fontFamily: AppFontFamily.interBold),
                        ),
                      ],
                    ),
                    hBox(24),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, size: 24, color: AppColors.black),
                        wBox(6),
                        Text("Door Delivery",
                          style: AppFontStyle.text_14_400(AppColors.black, fontFamily: AppFontFamily.interRegular),
                        ),
                      ],
                    ),
                    hBox(10),
                    Obx(() {
                      final selectedAddress = controller.selectedIndex.value;

                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: controller.addressList.length,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final item = controller. addressList[index];

                          return Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              border: Border.all(color: AppColors.borderClr, width: 1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: GestureDetector(
                              onTap: () => controller.selectedIndex.value = index,
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: selectedAddress == index
                                        ? AppColors.buttonColor
                                        : AppColors.borderClr,
                                    width: selectedAddress == index ? 1.5 : 0.6,
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Container(
                                      width: 22,
                                      height: 22,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: selectedAddress == index
                                            ? AppColors.buttonColor
                                            : Colors.transparent,
                                        border: Border.all(
                                          color: selectedAddress == index
                                              ? AppColors.buttonColor
                                              : AppColors.greyTextColor,
                                          width: 2,
                                        ),
                                      ),
                                      child: selectedAddress == index
                                          ? const Icon(Icons.check,
                                          size: 14, color: Colors.white)
                                          : null,
                                    ),

                                    wBox(12),

                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [

                                          Row(
                                            children: [
                                              Text(
                                                item.type,
                                                style: AppFontStyle.text_14_500(
                                                  AppColors.black,
                                                  fontFamily:
                                                  AppFontFamily.interMedium,
                                                ),
                                              ),

                                              if (item.isDefault) ...[
                                                wBox(8),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(
                                                      horizontal: 8, vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xFFEEEEFF),
                                                    borderRadius:
                                                    BorderRadius.circular(6),
                                                  ),
                                                  child: Text(
                                                    "default",
                                                    style:
                                                    AppFontStyle.text_10_500(
                                                      AppColors.buttonColor,
                                                      fontFamily:
                                                      AppFontFamily.interMedium,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),

                                          hBox(6),
                                          Text(
                                            item.name,
                                            style: AppFontStyle.text_13_400(
                                              AppColors.black,
                                              fontFamily:
                                              AppFontFamily.interRegular,
                                            ),
                                          ),
                                          hBox(4),
                                          Text(
                                            item.address,
                                            style: AppFontStyle.text_12_400(
                                              AppColors.buttonHideColor,
                                              fontFamily:
                                              AppFontFamily.interRegular,
                                            ),
                                          ),
                                          hBox(6),
                                          Text(
                                            item.phone,
                                            style: AppFontStyle.text_13_400(
                                              AppColors.black,
                                              fontFamily:
                                              AppFontFamily.interRegular,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    const Icon(Icons.edit_outlined,
                                        size: 18, color: Colors.grey),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }),
                    hBox(10),

                    CustomElevatedButton(
                        color: AppColors.btnClr,
                        borderSide: BorderSide(color: AppColors.borderClr),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.location_on_outlined, size: 22, color: AppColors.buttonColor),
                                  wBox(8),
                                  Text("Add a New Door Delivery Address",
                                    style: AppFontStyle.text_14_400(AppColors.blackTextColor, fontFamily: AppFontFamily.onestMedium),
                                  ),
                                ],
                              ),
                              Icon(Icons.chevron_right,size: 27, color: AppColors.buttonColor),
                            ],
                          ),
                        ),
                        onPressed: (){}),

                    hBox(28),

                    // ── PICKUP STATION ──
                    Row(
                      children: [
                        const Icon(Icons.storefront_outlined, size: 16, color: Colors.grey),
                        wBox(6),
                        Text("Pickup Station",
                          style: AppFontStyle.text_13_400(AppColors.buttonHideColor, fontFamily: AppFontFamily.interRegular),
                        ),
                      ],
                    ),

                    hBox(10),

                    Obx(() {
                      final selectedPickup = controller.selectedPickup.value;

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: controller.pickupList.length,
                        itemBuilder: (context, index) {
                          final item = controller.pickupList[index];

                          return GestureDetector(
                            onTap: () => controller.selectedPickup.value = index,
                            child: Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: selectedPickup == index
                                      ? AppColors.buttonColor
                                      : AppColors.borderClr,
                                  width: selectedPickup == index ? 1.5 : 0.6,
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Container(
                                    width: 22,
                                    height: 22,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: selectedPickup == index
                                          ? AppColors.buttonColor
                                          : Colors.transparent,
                                      border: Border.all(
                                        color: selectedPickup == index
                                            ? AppColors.buttonColor
                                            : AppColors.greyTextColor,
                                        width: 2,
                                      ),
                                    ),
                                    child: selectedPickup == index
                                        ? const Icon(Icons.check,
                                        size: 14, color: Colors.white)
                                        : null,
                                  ),

                                  wBox(12),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [

                                        Text(
                                          item.title,
                                          style: AppFontStyle.text_14_500(
                                            AppColors.black,
                                            fontFamily: AppFontFamily.interMedium,
                                          ),
                                        ),

                                        hBox(4),

                                        Text(
                                          item.address,
                                          style: AppFontStyle.text_12_400(
                                            AppColors.buttonHideColor,
                                            fontFamily: AppFontFamily.interRegular,
                                          ),
                                        ),

                                        hBox(6),

                                        GestureDetector(
                                          onTap: () {},
                                          child: Text(
                                            "See on map",
                                            style: AppFontStyle.text_12_400(
                                              AppColors.buttonColor,
                                              fontFamily: AppFontFamily.interRegular,
                                            ).copyWith(
                                              decoration: TextDecoration.underline,
                                              decorationColor: AppColors.buttonColor,
                                            ),
                                          ),
                                        ),

                                        hBox(4),

                                        Text(
                                          "Call: ${item.phone}",
                                          style: AppFontStyle.text_12_400(
                                            AppColors.black,
                                            fontFamily: AppFontFamily.interRegular,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const Icon(Icons.edit_outlined,
                                      size: 18, color: Colors.grey),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }),                    hBox(10),
                    CustomElevatedButton(
                        color: AppColors.btnClr,
                        borderSide: BorderSide(color: AppColors.borderClr),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.location_on_outlined, size: 22, color: AppColors.buttonColor),
                                  wBox(8),
                                  Text("Add New Pickup Station",
                                    style: AppFontStyle.text_14_400(AppColors.blackTextColor, fontFamily: AppFontFamily.onestMedium),
                                  ),
                                ],
                              ),
                              Icon(Icons.chevron_right,size: 27, color: AppColors.buttonColor),
                            ],
                          ),
                        ),
                        onPressed: (){}),

                    hBox(30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}