import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/menu/controller/vendor_export_menu_item_controller.dart';
import '../../../../../../Core/Constant/image_constant.dart';
import '../../../../../../Data/components/general_exception.dart';
import '../../../../../../Data/response/status.dart';
import '../../../../../../Utils/sized_box.dart';
import '../../../../../../shared/theme/colors.dart';
import '../../../../../../shared/theme/font_family.dart';
import '../../../../../../shared/theme/font_style.dart';
import '../../../../../../shared/widgets/custom_appbar.dart';
import '../../../../../../shared/widgets/image.dart';
import '../../../../../../shared/widgets/shimmer_widget.dart';
import '../../../../../../shared/widgets/vendor_widgets/circular_progress_indicator.dart';
import '../../../../../../shared/widgets/vendor_widgets/custom_dropdown.dart';
import '../../../../../../shared/widgets/vendor_widgets/custom_dropdown_api.dart';
import '../../../../../../shared/widgets/vendor_widgets/custom_elevated_button.dart';
import '../../../../../../shared/widgets/vendor_widgets/print.dart';

class VendorExportMenuItemScreen extends GetView<VendorExportMenuItemController> {
  const VendorExportMenuItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body:Obx(() {
        switch(controller.rxRequestCategoryStatus.value){
          case ApiStatus.LOADING :
            return loadingShimmer();
          case ApiStatus.ERROR:
            return GeneralExceptionWidget(onPress: () =>controller.getCategoryApi());
          case ApiStatus.COMPLETED :
            return  body();
          }
      }),
      bottomNavigationBar: exportBtn(),
    );
  }

  Padding body() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Export Menu Items",style: AppFontStyle.text_20_400(AppColors.black,fontFamily: AppFontFamily.gilroySemiBold)),
          hBox(2),
          Text("Export your complete menu with all item details.",
            maxLines: 3,
            style: AppFontStyle.text_16_400(AppColors.greyClr,fontFamily: AppFontFamily.gilroyRegular,
            ),
          ),
          hBox(16),
          Text("Export Format",
            style: AppFontStyle.text_15_400(AppColors.black,fontFamily: AppFontFamily.gilroySemiBold,
            ),
          ),
          hBox(6),
          fileTypeSelector(),
          hBox(16),
          Row(
            children: [
              AppImage(path: ImageConstants.filter,height: 17,width: 17),
              wBox(8),
              Text("Filters", style: AppFontStyle.text_16_400(AppColors.black,fontFamily: AppFontFamily.gilroySemiBold)),
            ],
          ),
          hBox(18),
          Text("Category", style: AppFontStyle.text_16_400(AppColors.black,fontFamily: AppFontFamily.gilroySemiBold)),
          hBox(4),
          category(),
          hBox(14),
          Text("Status", style: AppFontStyle.text_16_400(AppColors.black,fontFamily: AppFontFamily.gilroySemiBold)),
          hBox(4),
          status(),
          hBox(16),
          // includeImageUrl(),
        ],
      ),
    );
  }

  Widget category() {
    return Obx(
      ()=> CustomDropDownApi(
        showClearButton: true,
        offset: const Offset(0, 0),
        selectedValue: controller.selectedCategoryId.value,
        items: controller.apiCategoryData.value.categories ?? [],
        borderColor: AppColors.textFieldBorder,
        hintText: "Select Category",
        btnHeight: 50,
        onChanged: (value) {
          controller.selectedCategoryId.value = value ?? "";
          pt("value $value");
        },
        validator: (value) {
          return null;
        },
        onMenuStateChange: (isOpen){},
      ),
    );
  }

  Widget status() {
    return Obx(
      ()=> CustomDropDown(
        filledClr: AppColors.filledClr.withAlpha(150),
        showClearButton: true,
        selectedValue: controller.selectedStatus.value,
        items: const ["All Status","Active","Inactive"],
        borderColor: AppColors.textFieldBorder,
        hintText: "Select Status",
        btnHeight: 50,
        onChanged: (value) {
          controller.selectedStatus.value = value ?? "";
          pt("value $value");
        },
        validator: (value) {
          return null;
        },
      ),
    );
  }

  Widget includeImageUrl() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
            height: 16,
            width: 16,
            child: Obx(
              ()=> Checkbox(
                side: BorderSide(color: AppColors.black.withAlpha(200)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(4)),
                value: controller.isImageUrl.value, onChanged: (value){
                  controller.isImageUrl.value = value ?? false;
              },
              ),
            ),
        ),
        wBox(8),
        Text("Include image URLs", style: AppFontStyle.text_14_400(AppColors.greyClr,fontFamily: AppFontFamily.gilroyMedium)),
      ],
    );
  }

  Padding exportBtn() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Obx(
        ()=> controller.rxRequestCategoryStatus.value == ApiStatus.LOADING ? ShimmerBox(width: Get.width, height: 56) : CustomElevatedButton(
          onPressed: (){
            controller.exportProduct();
          },
          child:  controller.rxRequestStatusExProduct.value == ApiStatus.LOADING ? circularProgressIndicator(color: AppColors.white) : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            AppImage(path: ImageConstants.downloadLogo,svgColor: ColorFilter.mode(AppColors.white, BlendMode.srcIn),),
            wBox(10),
            const Text("Export Menu"),
          ],),
        ),
      ),
    );
  }

  Widget fileTypeSelector() {
    return Obx(() {
      return Row(
        children: List.generate(2, (index) {
          final isSelected = controller.selectedFormat.value == index;

          return Expanded(
            child: GestureDetector(
              onTap: () => controller.toggleFormat(index),
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.borderClr,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    AppImage(
                      path: ImageConstants.pdfIcon,
                      svgColor: ColorFilter.mode(isSelected ? AppColors.primary : AppColors.black, BlendMode.srcIn),
                      height: 22,
                      width: 22,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      index == 0 ? "CSV" : "Excel",
                      style: AppFontStyle.text_16_400(
                        isSelected ? AppColors.primary : AppColors.black,
                        fontFamily: AppFontFamily.gilroySemiBold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      );
    });
  }

  CustomAppBar _appBar() {
    return const CustomAppBar();
  }


  Widget loadingShimmer() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),

          // Title
          ShimmerBox(width: 180, height: 22),
          SizedBox(height: 10),

          // Subtitle
          ShimmerBox(width: double.infinity, height: 16),
          SizedBox(height: 4),
          ShimmerBox(width: 240, height: 16),
          SizedBox(height: 20),

          // Export Format
          ShimmerBox(width: 140, height: 18),
          SizedBox(height: 10),

          // File Type Buttons
          Row(
            children: [
              Expanded(child: ShimmerBox(height: 50, width: double.infinity, radius: 14)),
              SizedBox(width: 12),
              Expanded(child: ShimmerBox(height: 50, width: double.infinity, radius: 14)),
            ],
          ),

          SizedBox(height: 20),

          // Filters Title Row
          Row(
            children: [
              ShimmerBox(width: 20, height: 20, isCircle: true),
              SizedBox(width: 10),
              ShimmerBox(width: 100, height: 18),
            ],
          ),

          SizedBox(height: 20),

          // Category Label
          ShimmerBox(width: 120, height: 18),
          SizedBox(height: 6),

          // Category dropdown
          ShimmerBox(width: double.infinity, height: 50, radius: 10),
          SizedBox(height: 16),

          // Status Label
          ShimmerBox(width: 80, height: 18),
          SizedBox(height: 6),

          // Status dropdown
          ShimmerBox(width: double.infinity, height: 50, radius: 10),
          SizedBox(height: 20),

          // Include Image URL row
          Row(
            children: [
              ShimmerBox(width: 20, height: 20, radius: 4),
              SizedBox(width: 10),
              ShimmerBox(width: 150, height: 16),
            ],
          ),
        ],
      ),
    );
  }

}
