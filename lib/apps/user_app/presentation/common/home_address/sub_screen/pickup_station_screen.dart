import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gyaawa/apps/user_app/presentation/common/home_address/controller/pickup_station_controller.dart';
import 'package:gyaawa/apps/user_app/presentation/common/tab_bar/common_tab_bar.dart';
import 'package:gyaawa/shared/widgets/custom_text_form_field.dart';
import 'package:gyaawa/shared/widgets/image.dart';
import '../../../../../../shared/theme/colors.dart';
import '../../../../../../shared/theme/font_family.dart';
import '../../../../../../shared/theme/font_style.dart';
import '../../../../../../Utils/sized_box.dart';
import '../../../../../../shared/widgets/custom_elevated_button.dart';

class PickupStationScreen extends StatefulWidget {
  const PickupStationScreen({super.key});

  @override
  State<PickupStationScreen> createState() => _PickupStationScreenState();
}

class _PickupStationScreenState extends State<PickupStationScreen> {
  final PickupStationController controller = Get.find<PickupStationController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            CustomCategoryBar(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: const Icon(Icons.arrow_back_ios,
                                color: Colors.black, size: 22),
                          ),
                          wBox(10),
                          Text(
                            "Delivery Address", style: AppFontStyle.text_22_600(AppColors.black, fontFamily: AppFontFamily.interBold,),
                          ),
                        ],
                      ),
                      hBox(15),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.white, border: Border.all(color: AppColors.borderClr, width: 0.7), borderRadius: BorderRadius.circular(13),),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 22, vertical: 17),                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.store_mall_directory_outlined, color: AppColors.black),
                                  wBox(8),
                                  Text(
                                    "Find A Pickup Station", style: AppFontStyle.text_14_500(AppColors.black, fontFamily: AppFontFamily.interMedium,),
                                  ),
                                ],
                              ),
                              hBox(10),
                              CustomTextFormField(
                                height: 52.h,
                                width: 310.w,
                                fillColor:AppColors.searchText,
                                hintText: "Road, Greenfield, Abc Manchester",
                                hintStyle: AppFontStyle.text_14_400(AppColors.greyTextColor, fontFamily: AppFontFamily.interRegular,),
                              ),hBox(20),
                              ListView.separated(
                                  itemCount: controller.stationList.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  separatorBuilder: (_, __) => const Divider(height: 20),
                                  itemBuilder: (context, index) {
                                    final item = controller.stationList[index];
                                    return GestureDetector(
                                      onTap: () {
                                        controller.selectedIndex.value = index;
                                      },
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          AppImage(
                                          path:   "https://images.unsplash.com/photo-1600585154340-be6161a56a0c",
                                            height: 84,
                                            width: 84,
                                            borderRadius: 10,
                                            fit: BoxFit.cover,
                                          ),
                                          wBox(10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item["title"],
                                                  style:
                                                  AppFontStyle.text_14_600(
                                                    AppColors.black, fontFamily: AppFontFamily.interBold,
                                                  ),
                                                ),
                                                hBox(3),
                                                Text(
                                                  item["address"],
                                                  style: AppFontStyle.text_12_400(
                                                    AppColors.greyTextColor, fontFamily: AppFontFamily.onestRegular,
                                                  ),
                                                ),
                                                hBox(3),
                                                Text(
                                                  item["distance"],
                                                  style:
                                                  AppFontStyle.text_12_400(
                                                    AppColors.greyColors, fontFamily: AppFontFamily.interRegular,),
                                                ),
                                                hBox(5),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      item["type"], style: AppFontStyle.text_12_500(
                                                        AppColors.black, fontFamily: AppFontFamily.interMedium,
                                                      ),
                                                    ),
                                                    Text(
                                                      "See on map",
                                                      style: AppFontStyle.text_12_500(
                                                        AppColors.buttonColor, fontFamily: AppFontFamily.interRegular,
                                                      ).copyWith(decoration: TextDecoration.underline),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Obx(() => GestureDetector(
                                            onTap: () {
                                              controller.selectedIndex.value = index;
                                            },
                                            child: Container(
                                              height: 20, width: 20, decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(6), border: Border.all(color: AppColors.blackClr, width: 1,
                                                ),
                                                color: controller.selectedIndex.value == index ? AppColors.buttonColor : Colors.transparent,
                                              ),
                                              child: controller.selectedIndex.value == index ? Icon(Icons.check, size: 16, color: Colors.white,
                                              ) : null,
                                            ),
                                          )),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                            ],
                          ),
                        ),
                        ),
                      hBox(10),
                      CustomElevatedButton(
                        color: AppColors.buttonColor,
                        height: 45,
                        width: double.infinity,
                        text: "Confirm & Continue",
                        onPressed: () {},
                      ),
                      hBox(10),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}