import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/menu/controller/vendor_menu_controller.dart';
import '../../../../../../Core/Constant/image_constant.dart';
import '../../../../../../Utils/sized_box.dart';
import '../../../../../../shared/theme/colors.dart';
import '../../../../../../shared/theme/font_family.dart';
import '../../../../../../shared/theme/font_style.dart';
import '../../../../../../shared/widgets/custom_appbar.dart';
import '../../../../../../shared/widgets/image.dart';
import '../../../../../../shared/widgets/vendor_widgets/custom_elevated_button.dart';

class VendorBulkUploadMenuItems extends GetView<VendorMenuController> {
  const VendorBulkUploadMenuItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child:  SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Bulk Upload Store Items",style: AppFontStyle.text_20_400(AppColors.black,fontFamily: AppFontFamily.gilroySemiBold)),
              hBox(2),
              Text("Upload a CSV file with your store items to add multiple items at once.",
                  maxLines: 3,
                  style: AppFontStyle.text_16_400(AppColors.greyClr,fontFamily: AppFontFamily.gilroyRegular,
                  ),
              ),
            hBox(6),
            uploadInstructor(),
            hBox(20),
            downloadTemplete(),
            hBox(10),
            // uploadCsvWidget(),
            hBox(50),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomElevatedButton(
          onPressed: (){},
          text: "Upload Store Items",
        ),
      ),
    );
  }

  // Widget uploadCsvWidget() {
  //   return Obx(() {
  //     return Stack(
  //       children: [
  //         DottedBorder(
  //           strokeCap: StrokeCap.square,
  //           borderType: BorderType.RRect,
  //           radius: const Radius.circular(12),
  //           padding: const EdgeInsets.all(6),
  //           dashPattern: const [5],
  //           strokeWidth: 1.5,
  //           color: AppColors.borderClr,
  //           child: ClipRRect(
  //             borderRadius: const BorderRadius.all(Radius.circular(12)),
  //             child: SizedBox(
  //               height: 210,
  //               width: Get.width,
  //               child: controller.fileName.isNotEmpty
  //                   ? Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   AppImage(path: ImageConstants.csvImage,height: 100,),
  //                   hBox(10),
  //                   Text(
  //                     controller.fileName.value,
  //                     maxLines: 1,
  //                     overflow: TextOverflow.ellipsis,
  //                     style: AppFontStyle.text_14_500(
  //                       AppColors.blackTextColor,
  //                       fontFamily: AppFontFamily.gilroyMedium,
  //                     ),
  //                   ),
  //                 ],
  //               )
  //                   : Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   SvgPicture.asset(
  //                     ImageConstants.uploadImage,
  //                     height: 40,
  //                     width: 40,
  //                   ),
  //                   hBox(20),
  //                   Text(
  //                     "Drop your CSV file here, or click to browse",
  //                     style: AppFontStyle.text_14_500(
  //                       AppColors.lightBlackClr,
  //                       fontFamily: AppFontFamily.gilroyMedium,
  //                     ),
  //                   ),
  //                   hBox(5),
  //                   Text(
  //                     "Supports CSV files up to 10MB",
  //                     style: AppFontStyle.text_14_400(
  //                       AppColors.hintText,
  //                       fontFamily: AppFontFamily.gilroyMedium,
  //                     ),
  //                   ),
  //                   hBox(16),
  //                   CustomElevatedButton(
  //                     borderSide: BorderSide(color: AppColors.borderClr),
  //                     borderRadius: BorderRadius.circular(10),
  //                     width: 110.w,
  //                     height: 36.h,
  //                     color: AppColors.transparent,
  //                     onPressed: () => controller.pickCsvFile(),
  //                     text: "Choose File",
  //                     textStyle: AppFontStyle.text_15_400(
  //                       AppColors.lightBlackClr,
  //                       fontFamily: AppFontFamily.gilroySemiBold,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //
  //         // REMOVE BUTTON
  //         if (controller.fileName.isNotEmpty)
  //           Positioned(
  //             right: 3.w,
  //             top: 5.h,
  //             child: GestureDetector(
  //               onTap: () => controller.removeCsv(),
  //               child: Icon(
  //                 Icons.cancel_outlined,
  //                 size: 25,
  //                 color: AppColors.red,
  //               ),
  //             ),
  //           ),
  //       ],
  //     );
  //   });
  // }

  Widget downloadTemplete() {
    return Container(
        width: Get.width,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.borderClr.withAlpha(200), width: 1),
          borderRadius: BorderRadius.circular(10),
          color: AppColors.white,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppImage(path: ImageConstants.pdfIcon,height: 24,width: 24),
            wBox(10),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Download Template",
                    overflow: TextOverflow.ellipsis, style: AppFontStyle.text_16_600(AppColors.black.withAlpha(220), fontFamily: AppFontFamily.gilroyMedium)),
                  Text(
                    "Get the correct CSV format",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppFontStyle.text_14_400(AppColors.black.withAlpha(220), fontFamily: AppFontFamily.gilroyRegular)),
                ],
              ),
            ),

            wBox(10),
            CustomElevatedButton(
              width: 100,
              borderRadius: BorderRadius.circular(8),
              height: 38,
              color: AppColors.white,
              borderSide: BorderSide(color: AppColors.black, width: 1),
              onPressed: () {},
              text: "Download",
              textColor: AppColors.black,
              textStyle: AppFontStyle.text_12_600(
                AppColors.black,
                fontFamily: AppFontFamily.gilroyMedium,
              ),
            ),
          ],
        ),
      );
  }

  Widget uploadInstructor() {
    return Container(
        width: Get.width,
        padding: const EdgeInsetsGeometry.symmetric(horizontal: 14,vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.cyanClr),
          borderRadius: BorderRadius.circular(10),
          color: AppColors.cyanClr.withAlpha(40),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.info_outline,size: 17,color: AppColors.blueClr,),
                wBox(8),
                Column(
                  children: [
                    Text("Upload Instruction",style: AppFontStyle.text_16_600(AppColors.blueClr.withAlpha(220),fontFamily: AppFontFamily.gilroyMedium),),
                  ],
                ),
              ],
            ),
            hBox(4),
            Padding(
              padding: const EdgeInsets.only(left: 24.0),
              child: Text(
                "Upload a CSV file with your store items. Make sure to include columns for name, description, category, price, status, availability, and allergens.",
                maxLines: 6,
                style: AppFontStyle.text_14_400(AppColors.blueClr.withAlpha(230),fontFamily: AppFontFamily.gilroyRegular),),
            ),
          ],
        ),
      );
  }

  CustomAppBar _appBar() {
    return const CustomAppBar();
  }

}
