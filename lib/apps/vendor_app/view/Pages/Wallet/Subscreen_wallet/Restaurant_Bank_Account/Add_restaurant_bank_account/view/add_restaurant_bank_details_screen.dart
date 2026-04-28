import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../../../../shared/theme/colors.dart';
import '../../../../../../../../../shared/theme/font_family.dart';
import '../../../../../../../../../shared/theme/font_style.dart';
import '../../../../../../../../../shared/widgets/custom_appbar.dart';

class AddRestaurantBankDetails extends StatelessWidget {
  AddRestaurantBankDetails({super.key});

  // final AddRestaurantBankDetailsController controller = Get.put(AddRestaurantBankDetailsController());

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: SafeArea(
        child: Scaffold(
          appBar: appBar(),
        ),
      ),
    );
  }

  CustomAppBar appBar() {
    return CustomAppBar(
      centetTitle: true,
      title: Text(/*
        controller.bankId.value.isNotEmpty ? "Update Bank Account" : */"Add Bank Account",
        style: AppFontStyle.text_18_500(
          AppColors.darkText,
          fontFamily: AppFontFamily.gilroySemiBold,
        ),
      ),
    );
  }
}
