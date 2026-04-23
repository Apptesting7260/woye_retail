import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../Core/Constant/image_constant.dart';
import '../../../Data/response/status.dart';
import '../../../Utils/sized_box.dart';
import '../../theme/colors.dart';
import '../../theme/font_family.dart';
import '../../theme/font_style.dart';
import '../custom_elevated_button.dart';
import '../custom_text_form_field.dart';
import 'app_container.dart';
import 'image.dart';

Future<void> showConfirmationDialog({
  required BuildContext context,
  required String title,
  String? description,
  String confirmText = "Yes",
  String cancelText = "No",
  Color? confirmColor,
  Color? cancelColor,
  required Future<void> Function()? onConfirmAsync,
  VoidCallback? onCancel,
  bool barrierDismissible = false,
  Rx<ApiStatus>? isLoading,
}) {
  return showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) {
      return PopScope(
        canPop: barrierDismissible,
        child: AlertDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 22),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
          backgroundColor: AppColors.white,
          titlePadding: REdgeInsets.only(top: 25.h, bottom: 10.h),
          contentPadding: REdgeInsets.fromLTRB(24.w, 10.h, 24.w, 25.h),
          title: Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: AppFontStyle.text_20_600(
                AppColors.black,
                fontFamily: AppFontFamily.gilroyMedium,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (description != null && description.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(bottom: 20.h),
                  child: Text(
                    description,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    style: AppFontStyle.text_15_400(
                      AppColors.greyColors,
                      fontFamily: AppFontFamily.gilroyMedium,
                    ),
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomElevatedButton(
                    width: Get.width * 0.3.w,
                    height: 40.h,
                    color: cancelColor ?? AppColors.white,
                    borderSide: BorderSide(
                      color: AppColors.grey.withAlpha(120),
                    ),
                    borderRadius: BorderRadius.circular(10),
                    onPressed: () {
                      if (onCancel != null) onCancel();
                      Get.back();
                    },
                    text: cancelText,
                    textStyle: AppFontStyle.text_16_400(
                      AppColors.black,
                      fontFamily: AppFontFamily.gilroyMedium,
                    ),
                  ),
                  SizedBox(width: 15.w),
                  Obx(() {
                    final loading = isLoading?.value == ApiStatus.LOADING;
                    return CustomElevatedButton(
                      width: Get.width * 0.3.w,
                      height: 40.h,
                      color: confirmColor ?? AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                      isLoading: loading,
                      onPressed: () async {
                        if (!loading && onConfirmAsync != null) {
                          await onConfirmAsync();
                        }
                      },
                      text: confirmText,
                      textStyle: AppFontStyle.text_16_400(
                        AppColors.white,
                        fontFamily: AppFontFamily.gilroyMedium,
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}


Future<void> showDeleteProductDialog({
  required BuildContext context,
  required String productName,
  required String productSubtitle,
  required Widget image,
  required int stock,
  required Future<void> Function(String reason) onDeleteAsync,
  required Rx<ApiStatus> isLoading,
  VoidCallback? onCancel,
  bool barrierDismissible = false,
}) {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController reasonController = TextEditingController();
  return showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async => barrierDismissible,
        child: AlertDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 22),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: AppColors.white,
          contentPadding: const EdgeInsets.all(16),
          content: SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Delete Product",
                  style: AppFontStyle.text_18_400(AppColors.red,
                      fontFamily: AppFontFamily.gilroySemiBold),
                ),
                const SizedBox(height: 6),
                Text(
                  'Are you sure you want to delete "$productName"? This action cannot be undone.',
                  style: AppFontStyle.text_14_400(AppColors.greyClr,
                      fontFamily: AppFontFamily.gilroyMedium),
                  maxLines: 4,
                ),
                const SizedBox(height: 18),
                AppContainer(
                  padding: const EdgeInsets.all(12),
                  // decoration: BoxDecoration(
                  //   border: Border.all(color: AppColors.greyClr.withAlpha(150)),
                  //   borderRadius: BorderRadius.circular(12),
                  // ),
                  border: Border.all(color: AppColors.greyClr.withAlpha(150)),
                  borderRadius: BorderRadius.circular(12),
                  child: Row(
                    children: [
                      image,
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              productName,
                              overflow: TextOverflow.fade,
                              style: AppFontStyle.text_16_400(AppColors.black,
                                  fontFamily: AppFontFamily.gilroySemiBold),
                            ),
                            Text(
                              productSubtitle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppFontStyle.text_14_400(AppColors.greyClr,
                                  fontFamily: AppFontFamily.gilroyMedium),
                            ),
                            Text(
                              "Stock: $stock units",
                              style: AppFontStyle.text_14_400(AppColors.greyClr,
                                  fontFamily: AppFontFamily.gilroyMedium),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                AppContainer(
                  padding: const EdgeInsets.all(12),
                  // decoration: BoxDecoration(
                  //   color: AppColors.cyanClr.withOpacity(0.1),
                  //   border: Border.all(color: AppColors.blueClr),
                  //   borderRadius: BorderRadius.circular(12),
                  // ),
                  color: AppColors.cyanClr.withOpacity(0.1),
                  border: Border.all(color: AppColors.blueClr),
                  borderRadius: BorderRadius.circular(12),


                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          AppImage(path:  ImageConstants.info,height: 16,width: 16,),
                          wBox(8),
                          Text(
                            "Inventory Notice",
                            style: AppFontStyle.text_14_400(AppColors.blueClr,
                                fontFamily: AppFontFamily.gilroySemiBold),
                          ),
                        ],
                      ),
                      hBox(5),
                      Text(
                        "You currently have $stock units in stock. Consider transferring to another location or processing returns.",
                        maxLines: 3,
                        style: AppFontStyle.text_12_400(AppColors.blueTextColor,
                            fontFamily: AppFontFamily.gilroyMedium),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Reason for Deletion",
                  style: AppFontStyle.text_14_400(AppColors.black,
                      fontFamily: AppFontFamily.gilroySemiBold),
                ),
                const SizedBox(height: 6),
                Form(
                  key: _formKey,
                  child: CustomTextFormField(
                    controller: reasonController,
                    maxLines: 3,
                    minLines: 3,
                    hintText:
                        "Please provide a reason for deleting this product...",
                    hintStyle: AppFontStyle.text_15_400(AppColors.black,
                        fontFamily: AppFontFamily.gilroyRegular),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Enter Reason";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: CustomElevatedButton(
                        height: 50,
                        color: AppColors.white,
                        borderSide: BorderSide(
                          color: AppColors.grey.withAlpha(120),
                        ),
                        onPressed: () {
                          onCancel?.call();
                          Get.back();
                        },
                        text: "Cancel",
                        textStyle: AppFontStyle.text_16_400(AppColors.black, fontFamily: AppFontFamily.gilroyMedium),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Obx(() {
                        final loading = isLoading.value == ApiStatus.LOADING;
                        return CustomElevatedButton(
                          height: 50,
                          color: AppColors.red,
                          isLoading: loading,
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await onDeleteAsync(
                                reasonController.value.text.trim(),
                              );
                            }
                          },
                          text: "Delete Product",
                          textStyle: AppFontStyle.text_16_400(AppColors.white, fontFamily: AppFontFamily.gilroyMedium),
                        );
                      }),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
