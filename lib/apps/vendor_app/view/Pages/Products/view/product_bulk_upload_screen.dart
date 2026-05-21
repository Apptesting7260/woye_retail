import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/Products/controller/product_bulk_upload_controller.dart';
import 'package:gyaawa/shared/widgets/vendor_widgets/custom_appbar.dart';

import '../../../../../../Core/Constant/image_constant.dart';
import '../../../../../../Data/response/status.dart';
import '../../../../../../Utils/sized_box.dart';
import '../../../../../../shared/theme/colors.dart';
import '../../../../../../shared/theme/font_family.dart';
import '../../../../../../shared/theme/font_style.dart';
import '../../../../../../shared/widgets/vendor_widgets/custom_elevated_button.dart';

class ProductBulkUploadScreen extends StatelessWidget {
  const ProductBulkUploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductBulkUploadController());
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: REdgeInsets.symmetric(horizontal: 22, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Bulk Upload Store Products",
              style: AppFontStyle.text_20_400(
                AppColors.blackTextColor,
                fontFamily: AppFontFamily.interRegular,
              ),
            ),
            hBox(10.h),
            Text(
              "Upload multiple products using a CSV or Excel file."
                  "Ensure your file includes required fields such as Title, Condition, and Stock Unit along with other product details.",
              maxLines: 5,
              style: AppFontStyle.text_16_400(
                AppColors.mediumText,
                fontFamily: AppFontFamily.gilroyRegular,
              ),
            ),
            hBox(24.h),
            Text(
              "Select File",
              style: AppFontStyle.text_16_400(
                AppColors.blackTextColor,
                fontFamily: AppFontFamily.interRegular,
              ),
            ),
            hBox(12.h),
            Obx(() => dropZone(controller)),
            hBox(24.h),
            _templateCard(controller),
            hBox(10.h),
          ],
        ),
      ),

      bottomNavigationBar: Padding(
        padding: REdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Obx(() => CustomElevatedButton(
            height: 50.h,
            color: AppColors.primary,
            isLoading:
                controller.rxUploadStatus.value == ApiStatus.LOADING,
            onPressed: () => controller.uploadProducts(),
            text: "Upload Products",
            textStyle: AppFontStyle.text_16_400(
              AppColors.white,
              fontFamily: AppFontFamily.gilroySemiBold,
            ),
          ),
        ),
      ),
    );
  }
  Widget dropZone(ProductBulkUploadController controller) {
    final hasFile = controller.fileName.value.isNotEmpty;
    return DottedBorder(
      strokeCap: StrokeCap.square,
      borderType: BorderType.RRect,
      radius: const Radius.circular(10),
      padding: const EdgeInsets.all(6),
      dashPattern: const [6, 4],
      strokeWidth: 1.8,
      color: controller.isFileError.value
          ? AppColors.errorColor
          : AppColors.borderClr,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        child: SizedBox(
          width: double.infinity,
          height: 200.h,
          child: hasFile ? fileSelectedView(controller) : emptyDropView(controller),
        ),
      ),
    );
  }
  Widget emptyDropView(ProductBulkUploadController controller) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
       SvgPicture.asset(ImageConstants.pdfIcon,width: 25,color: AppColors.pdfIconColor,),
        hBox(10.h),
        Text(
          "Drop your CSV/Excel file here or click to browse",
          textAlign: TextAlign.center,
          style: AppFontStyle.text_13_500(
            AppColors.textClr,
            fontFamily: AppFontFamily.interMedium,
          ),
        ),
        hBox(16.h),
        CustomElevatedButton(
          width: 120.w,
          height: 40.h,
          color: AppColors.backgroundClr,
          borderSide: BorderSide(color: AppColors.borderClr),
          borderRadius: BorderRadius.circular(10.r),
          onPressed: () => controller.pickFile(),
          text: "Choose file",
          textColor: AppColors.darkText,
          textStyle: AppFontStyle.text_14_500(
            AppColors.blackClr,
            fontFamily: AppFontFamily.interMedium,
          ),
        ),
      ],
    );
  }
  Widget fileSelectedView(
      ProductBulkUploadController controller) {
    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                ImageConstants.uploadImage, height: 48.r, width: 48.r,
                colorFilter: ColorFilter.mode(AppColors.primary, BlendMode.srcIn,
                ),
              ),
              hBox(12.h),
              Padding(padding: REdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  controller.fileName.value, maxLines: 2, textAlign: TextAlign.center, overflow:
                  TextOverflow.ellipsis, style: AppFontStyle.text_14_500(AppColors.darkText, fontFamily: AppFontFamily.gilroyMedium,),
                ),
              ),
              hBox(10.h),
              GestureDetector(
                onTap: () => controller.pickFile(),
                child: Text("Change file", style: AppFontStyle.text_13_400(AppColors.blueClr, fontFamily: AppFontFamily.gilroyMedium)),
              ),
              Obx(
                    () => controller.uploadErrorMessage.value.isNotEmpty ? Padding(
                  padding: REdgeInsets.only(top: 6, left: 20, right: 20,),
                  child: Text(controller.uploadErrorMessage.value,
                    maxLines: 2,
                    textAlign: TextAlign.center, style: AppFontStyle
                        .text_12_400(AppColors.errorColor, fontFamily: AppFontFamily.gilroyRegular,
                    ),
                  ),
                )
                    : const SizedBox(),
              ),
            ],
          ),
        ),
        // Remove Button
        Positioned(
          top: 8.h,
          right: 8.w,
          child: GestureDetector(
            onTap: () => controller.removeFile(),
            child: Icon(Icons.cancel_outlined, size: 24.r, color: AppColors.errorColor),
          ),
        ),
      ],
    );
  }
  Widget _templateCard(ProductBulkUploadController controller) {
    return Container(
      width: double.infinity,
      padding: REdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.fillClr2,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.blueClr.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Need a template?",
            style: AppFontStyle.text_16_600(
              AppColors.blueColor,
              fontFamily: AppFontFamily.gilroySemiBold,
            ),
          ),
          hBox(6.h),
          Text(
            "Download our CSV template with the required columns for products.",
            maxLines: 2,
            style: AppFontStyle.text_14_400(
              AppColors.mediumText,
              fontFamily: AppFontFamily.gilroyRegular,
            ),
          ),
          hBox(12.h),
          Obx(
            () => GestureDetector(
              onTap: controller.rxTemplateStatus.value == ApiStatus.LOADING
                  ? null
                  : () => controller.downloadTemplate(),
              child: controller.rxTemplateStatus.value == ApiStatus.LOADING
                  ? Row(
                      children: [
                        SizedBox(
                          height: 16.h,
                          width: 16.h,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.blueColor,
                          ),
                        ),
                        wBox(8.w),
                        Text(
                          "Downloading...",
                          style: AppFontStyle.text_14_600(
                            AppColors.blueColor,
                            fontFamily: AppFontFamily.gilroySemiBold,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      "Download Template",
                      style: AppFontStyle.text_14_600(
                        AppColors.blueColor,
                        fontFamily: AppFontFamily.gilroySemiBold,
                      ).copyWith(
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.blueColor,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
