import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../../shared/theme/colors.dart';
import '../../../../../../Utils/sized_box.dart';
import '../../../../../../routes/vendor_routes/vendor_app_routes.dart';
import '../../../../../../shared/theme/font_family.dart';
import '../../../../../../shared/theme/font_style.dart';
import '../../../../../../shared/widgets/vendor_widgets/custom_appbar.dart';
import '../../../../../../shared/widgets/vendor_widgets/custom_profile_list_tile.dart';
import '../controller/restaurant_help_center_controller.dart';

class RestaurantHelpCenterScreen extends GetView<RestaurantHelpCenterController> {
  const RestaurantHelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundClr,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.backgroundClr,
          appBar: CustomAppBar(
            title: Text(
              "Help",
              style: AppFontStyle.text_22_400(AppColors.darkText,
                  fontFamily: AppFontFamily.gilroySemiBold),
            ),
          ),
          body: SingleChildScrollView(//
            child: Padding(
              padding: REdgeInsets.symmetric(horizontal: 22.0),
              child: Column(
                children: [
                  _tileList(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _tileList() {
    return ListView.separated(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: controller.tileMapList.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return CustomProfileListTile(
          isImage: false,
          image: controller.tileMapList[index]['image'],
          title: controller.tileMapList[index]['title'],
          onTap: () {
            if (index == 0) {
              Get.toNamed(VendorAppRoutes.restaurantSupportScreen);
            }
            if (index == 1) {
              Get.toNamed(VendorAppRoutes.restaurantFaqScreen);
            }
            if (index == 2) {
              Get.toNamed(VendorAppRoutes.restaurantPrivacyPolicyScreen);
            }
            if (index == 3) {
              Get.toNamed(VendorAppRoutes.restaurantTnCScreen);
            } if (index == 4) {
              Get.toNamed(VendorAppRoutes.restaurantVendorAgreementCScreen);
            }
          },
        );
      },
      separatorBuilder: (context, index) => hBox(16.h),
    );
  }
}
