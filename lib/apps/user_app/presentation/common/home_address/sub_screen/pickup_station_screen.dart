import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gyaawa/apps/user_app/presentation/common/home_address/controller/pickup_station_controller.dart';
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
        backgroundColor: AppColors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(Icons.arrow_back_ios,
                        color: Colors.black, size: 22),
                  ),
                  wBox(10),
                  Text(
                    "Delivery Address",
                    style: AppFontStyle.text_22_600(
                      AppColors.black,
                      fontFamily: AppFontFamily.interBold,
                    ),
                  ),
                ],
              ),

              hBox(20),
              Container(
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.fillClr2,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.store_mall_directory_outlined,
                        color: AppColors.black),
                    wBox(8),
                    Text(
                      "Find A Pickup Station",
                      style: AppFontStyle.text_14_500(
                        AppColors.black,
                        fontFamily: AppFontFamily.interMedium,
                      ),
                    )
                  ],
                ),
              ),

              hBox(10),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.searchText,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Road, Greenfield, Abc Manchester",
                  style: AppFontStyle.text_12_400(
                    AppColors.greyTextColor,
                    fontFamily: AppFontFamily.interRegular,
                  ),
                ),
              ),

              hBox(15),
              Expanded(
                child: Obx(() => ListView.separated(
                  itemCount:  controller.stationList.length,
                  separatorBuilder: (_, __) => Divider(),
                  itemBuilder: (context, index) {
                    final item = controller.stationList[index];

                    return GestureDetector(
                      onTap: () {
                        controller.selectedIndex.value = index;
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              "https://images.unsplash.com/photo-1600585154340-be6161a56a0c",
                              height: 60,
                              width: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          wBox(10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item["title"],
                                  style: AppFontStyle.text_14_600(
                                    AppColors.black,
                                    fontFamily:
                                    AppFontFamily.interSemiBold,
                                  ),
                                ),
                                hBox(3),
                                Text(
                                  item["address"],
                                  style: AppFontStyle.text_12_400(
                                    AppColors.greyTextColor,
                                    fontFamily:
                                    AppFontFamily.interRegular,
                                  ),
                                ),
                                hBox(3),
                                Text(
                                  item["distance"],
                                  style: AppFontStyle.text_12_400(
                                    AppColors.greyTextColor,
                                    fontFamily:
                                    AppFontFamily.interRegular,
                                  ),
                                ),
                                hBox(5),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      item["type"],
                                      style:
                                      AppFontStyle.text_12_500(
                                        AppColors.black,
                                        fontFamily:
                                        AppFontFamily.interMedium,
                                      ),
                                    ),
                                    Text(
                                      "See on map",
                                      style:
                                      AppFontStyle.text_12_500(
                                        AppColors.buttonColor,
                                        fontFamily:
                                        AppFontFamily.interMedium,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Obx(() => Checkbox(
                            value:controller. selectedIndex.value == index,
                            onChanged: (_) {
                              controller.selectedIndex.value = index;
                            },
                            activeColor:
                            AppColors.buttonColor,
                          )),
                        ],
                      ),
                    );
                  },
                )),
              ),
              hBox(10),
              CustomElevatedButton(
                color: AppColors.buttonColor,
                height: 45,
                width: double.infinity,
                text: "Confirm & Continue",
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}