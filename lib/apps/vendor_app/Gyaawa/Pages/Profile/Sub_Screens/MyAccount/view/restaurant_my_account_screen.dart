import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gyaawa/shared/widgets/vendor_widgets/custom_profile_list_tile.dart';
import '../../../../../../../../Utils/sized_box.dart';
import '../../../../../../../../shared/theme/colors.dart';
import '../../../../../../../../shared/theme/font_family.dart';
import '../../../../../../../../shared/theme/font_style.dart';
import '../../../../../../../../shared/widgets/custom_appbar.dart';
import '../../../../../../vendor_app_routes/vendor_app_routes.dart';
import '../controller/restaurant_my_account_controller.dart';

class RestaurantMyAccountScreen extends StatelessWidget {
  RestaurantMyAccountScreen({super.key});

  final RestaurantMyAccountController resMyAccountController =
      Get.put(RestaurantMyAccountController());

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: SafeArea(
        child: Scaffold(
            appBar: appBar(),
            body: ListView.separated(
              padding: REdgeInsets.symmetric(horizontal: 22.w, vertical: 5.h),
              itemCount: resMyAccountController.mapList.length,
              itemBuilder: (context, index) {
                return CustomProfileListTile(
                  isPngImage: index == 1 ? true : false,
                  image: resMyAccountController.mapList[index]['image'],
                  title: resMyAccountController.mapList[index]['title'],
                  onTap: () {
                    if (index == 0) {
                      Get.toNamed(VendorAppRoutes.restaurantInformationScreens);
                    } else if (index == 1) {
                      Get.toNamed(VendorAppRoutes.userPasswordChangeScreen);
                    }
                  },
                );
              },
              separatorBuilder: (context, index) => hBox(20.h),
            )),
      ),
    );
  }

  CustomAppBar appBar() {
    return CustomAppBar(
      centetTitle: true,
      title: Text("My Accounts",
          style: AppFontStyle.text_20_600(AppColors.darkText,
              fontFamily: AppFontFamily.gilroyRegular)),
    );
  }
}
