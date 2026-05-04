import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../../../../Data/response/status.dart';
import '../../../../../../../../Data/user_preference_controller.dart';
import '../../../../../../../../Utils/sized_box.dart';
import '../../../../../../../../routes/vendor_routes/vendor_app_routes.dart';
import '../../../../../../../../shared/theme/colors.dart';
import '../../../../../../../../shared/theme/font_family.dart';
import '../../../../../../../../shared/theme/font_style.dart';
import '../../../../../../../../shared/widgets/custom_appbar.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/app_container.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/print.dart';
class RestaurantSettingScreen extends StatefulWidget {
  const RestaurantSettingScreen({super.key});

  @override
  State<RestaurantSettingScreen> createState() => _RestaurantSettingScreenState();
}

class _RestaurantSettingScreenState extends State<RestaurantSettingScreen> {


  String userRole = "";

  RxList<String> mapList = <String>[
    "Store Information",
    "Store Configuration",
    "Compliance & Licenses",
    "User Access Control",
    "Security",
  ].obs;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      userRole = await UserPreference.getUserRole();

      if (userRole.toLowerCase() == UserType.accountant.name || userRole.replaceAll(" ", "").toLowerCase() == UserType.kitchenstaff.name || userRole.replaceAll(" ", "").toLowerCase() == UserType.servicestaff.name) {
        mapList.assignAll([ "Store Information","Security"]);
      }else if (userRole.replaceAll(" ", "").toLowerCase() == UserType.vendormanager.name) {
        mapList.assignAll(["Store Information","Store Configuration","Compliance & Licenses","Security",]);
      } else {
        mapList.assignAll(["Store Information","Store Configuration","Compliance & Licenses","User Access Control","Security",]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments ?? {};
    final vendorType = arguments['vendorType'] ?? "Store";
    return Container(
      color: AppColors.backgroundClr,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.backgroundClr,
          appBar: appBar(),
          body: listTile(),
        ),
      ),
    );
  }

  listTile() {
    return Obx(
      ()=> ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        padding: REdgeInsets.symmetric(horizontal: 22.w),
        itemCount: mapList.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              switch(index){
                case 0 :
                  Get.toNamed(VendorAppRoutes.restaurantInformationScreens);
                case 1 :
                  Get.toNamed(VendorAppRoutes.restaurantConfigurationScreen);
                case 2 :
                  Get.toNamed(VendorAppRoutes.restaurantComplianceAndLicensesScreen);
               case 3 :
                  Get.toNamed(VendorAppRoutes.resUserAccessScreen);
              case 4 :
                  Get.toNamed(VendorAppRoutes.resSecuritySettingsScreen);
              }
            },

            //   onTap: () {
            //     pt("${mapList[index]} clicked>>>>>>>>>>>>>>>>>");
            //     switch (mapList[index]) {
            //
            //       case "Store Information":
            //         Get.toNamed(VendorAppRoutes.restaurantInformationScreens);
            //         break;
            //
            //       case "Store Configuration":
            //         Get.toNamed(VendorAppRoutes.restaurantConfigurationScreen);
            //         break;
            //
            //       case "Compliance & Licenses":
            //         Get.toNamed(VendorAppRoutes.restaurantComplianceAndLicensesScreen);
            //         break;
            //
            //       case "User Access Control":
            //         Get.toNamed(VendorAppRoutes.resUserAccessScreen);
            //         break;
            //
            //       case "Security":
            //         Get.toNamed(VendorAppRoutes.resSecuritySettingsScreen);
            //         break;
            //     }
            //   },
              child: AppContainer(
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 14),
              boxShadow: const [],
              color: AppColors.white,
              borderRadius: BorderRadius.circular(14),
              child: Row(
                children: [
                  Text(
                    mapList[index],
                    style: AppFontStyle.text_16_400(
                      AppColors.blackClr,
                      fontFamily: AppFontFamily.gilroyMedium,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: AppColors.greyClr,
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => hBox(14.h),
      ),
    );
  }

  CustomAppBar appBar() {
    return CustomAppBar(
      centetTitle: true,
      title: Text(
        "Setting",
        style: AppFontStyle.text_22_400(
          AppColors.darkText,
          fontFamily: AppFontFamily.gilroySemiBold,
        ),
      ),
    );
  }
}
