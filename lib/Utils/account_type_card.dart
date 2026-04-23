import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gyaawa/Utils/sized_box.dart';

import '../Core/Constant/image_constant.dart';
import '../Data/user_preference_controller.dart';
import '../shared/theme/colors.dart';
import '../shared/theme/font_family.dart';
import '../shared/theme/font_style.dart';
import '../shared/widgets/image.dart';

Widget accountTypeCard({String? des}) {
  return FutureBuilder<String>(
    future: UserPreference.getUserRole(),
    builder: (context, snapshot) {
      final role = snapshot.data;

      return Container(
        width: Get.width,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.cyanClr.withAlpha(180)),
          borderRadius: BorderRadius.circular(10),
          color: AppColors.cyanClr.withAlpha(40),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // AppImage(path: ImageConstants.owner, height: 20, width: 20),
                wBox(4),
                Flexible(
                  child: Text(
                    "👤 Current Access Level: ${role?.toString().capitalize ?? ""}",
                    maxLines: 2,
                    style: AppFontStyle.text_16_600(
                      AppColors.blueClr.withAlpha(220),
                      fontFamily: AppFontFamily.gilroySemiBold,
                    ),
                  ),
                ),
              ],
            ),
            hBox(10),
            Padding(
              padding: const EdgeInsets.only(left: 2.0),
              child: Text(
                getRoleDescription(role),
                maxLines: 100,
                style: AppFontStyle.text_14_400(
                  AppColors.blueClr.withAlpha(230),
                  fontFamily: AppFontFamily.gilroyRegular,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

String getRoleDescription(String? role) {
  switch (role?.toLowerCase().replaceAll(" ", "")) {

    case "owner":
      return "You have full access to all dashboard features including financial data.";

    case "vendormanager":
      return "All Access except User Access Control — You can manage operations, orders, products, and staff.";

    case "accountant":
      return "Access to Wallet and Information — You can view wallet details and financial information.";

    case "kitchenstaff":
      return "Access to Orders and Information — You can manage and update order preparation status.";

    case "servicestaff":
      return "Access to Reviews and Information — You can manage customer reviews and service-related details.";

    default:
      return "Limited access based on assigned permissions.";
  }
}


accessControllerCard({String? des,Color? borderClr,Color? bgClr,String? image,Color? textClr}) {
  return Container(
    width: Get.width,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    decoration: BoxDecoration(
      border: Border.all(color:borderClr?.withAlpha(180) ?? AppColors.cyanClr.withAlpha(180)),
      borderRadius: BorderRadius.circular(10),
      color:bgClr?.withAlpha(40) ??  AppColors.cyanClr.withAlpha(40),
    ),
    child: Padding(
      padding: const EdgeInsets.only(left: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppImage(path: image ?? ImageConstants.info,height: 16,width: 16),
          wBox(8),
          Expanded(
            child: Text(
              des ?? "",
              maxLines: 10,
              style: AppFontStyle.text_14_400(
                  textClr ?? AppColors.blueClr.withAlpha(230),
                fontFamily: AppFontFamily.gilroyRegular,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}