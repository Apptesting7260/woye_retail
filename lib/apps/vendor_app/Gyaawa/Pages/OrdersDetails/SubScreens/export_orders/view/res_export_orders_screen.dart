import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../../../../../Core/Constant/image_constant.dart';
import '../../../../../../../../Data/response/status.dart';
import '../../../../../../../../Utils/sized_box.dart';
import '../../../../../../../../shared/theme/colors.dart';
import '../../../../../../../../shared/theme/font_family.dart';
import '../../../../../../../../shared/theme/font_style.dart';
import '../../../../../../../../shared/widgets/custom_appbar.dart';
import '../../../../../../../../shared/widgets/image.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/circular_progress_indicator.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/custom_date_picker_field.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/custom_dropdown.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/custom_elevated_button.dart';
import '../../../../Profile/Sub_Screens/Setting/RestaurantInFormation/view/restaurant_information_screen.dart';
import '../../../controller/restaurant_order_list_controller.dart';

class ResExportOrdersScreen extends StatefulWidget {
  const ResExportOrdersScreen({super.key});

  @override
  State<ResExportOrdersScreen> createState() => _ResExportOrdersScreenState();
}

class _ResExportOrdersScreenState extends State<ResExportOrdersScreen> {

  RestaurantOrderController controller = Get.find<RestaurantOrderController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback( (timeStamp) {
      controller.startDateController.clear();
      controller.endDateController.clear();
      controller.selectedDateRange.value = "";
    },);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Form(
          key: controller.fromKeyExport,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                header(
                    title: "Export Orders",
                    description: "Export order history with customer and payment information"
                ),
                hBox(16),
                Text("Export Format",
                  style: AppFontStyle.text_15_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroySemiBold,
                  ),
                ),
                hBox(6),
                fileTypeSelector(),
                hBox(16),
                Text("Date Range", style: AppFontStyle.text_16_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroySemiBold)),
                hBox(4),
                dateRange(),
                hBox(14),
                Obx(() {
                  return controller.selectedDateRange.value == "Custom Range" ?
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Start Date",
                            style: AppFontStyle.text_13_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroySemiBold,
                            ),
                          ),
                          hBox(2),
                          SizedBox(
                            width: Get.width * 0.43,
                            child: CustomDatePickerField(
                              dateController:controller.startDateController,
                              prefixIcon: wBox(10),
                              hintText: "mm/dd/yyyy",
                              onChanged: (p0) {},
                              validator: (value) {
                                if(controller.selectedDateRange.value == "Custom Range"){
                                  if(value == null || value.isEmpty){
                                    return "Please select start date";
                                  }
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("End Date",
                            style: AppFontStyle.text_13_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroySemiBold,
                            ),
                          ),
                          hBox(2),
                          SizedBox(
                            // height: 56,
                            width: Get.width * 0.43,
                            child: CustomDatePickerField(
                              dateController:controller.endDateController,
                              prefixIcon: wBox(10),
                              hintText: "mm/dd/yyyy",
                              validator: (value) {
                                if (controller.selectedDateRange.value != "Custom Range") return null;

                                final end = value?.trim() ?? "";
                                final start = controller.startDateController.text.trim();

                                if (end.isEmpty) return "End date is required.";
                                if (start.isEmpty) return null;

                                try {
                                  final startDate = DateFormat("M/d/yyyy").parseLoose(start);  // Flexible
                                  final endDate = DateFormat("M/d/yyyy").parseLoose(end);

                                  if (endDate.isBefore(startDate)) {
                                    return "End date cannot be\nearlier than start date.";
                                  }
                                } catch (e) {
                                  return "Invalid date format.";
                                }
                                return null;
                              },
                              onChanged: (val) {
                                controller.endDateController.text = val ?? "";
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                      : const SizedBox.shrink();
                },
                ),
                hBox(16),
                Row(
                  children: [
                    AppImage(path: ImageConstants.filter,height: 17,width: 17,),
                    wBox(8),
                    Text("Filters", style: AppFontStyle.text_16_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroySemiBold,)),
                  ],
                ),
                hBox(16),
                Text("Order Status", style: AppFontStyle.text_16_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroySemiBold)),
                hBox(4),
                rating(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22,vertical: 8),
        child:Obx(
          ()=>  CustomElevatedButton(
            height: 56,
            onPressed: (){
              print(controller.fromKeyExport.currentState?.validate().toString());
              if(controller.fromKeyExport.currentState?.validate() ?? false){
                controller.orderExport();
              }
            },
            child:controller.reviewsExportApiData.value.status == ApiStatus.LOADING ? circularProgressIndicator(color: AppColors.white) : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppImage(path: ImageConstants.downloadLogo,svgColor: ColorFilter.mode(AppColors.white, BlendMode.srcIn)),
                wBox(6),
                Text("Export Orders",style: AppFontStyle.customText(AppColors.white,17, FontWeight.w400,fontFamily: AppFontFamily.gilroyMedium),),
              ],
            ),),
        ),
      ),
    );
  }

  Widget dateRange() {
    return Obx(
          ()=> CustomDropDown(
        showClearButton: true,
        selectedValue: controller.selectedDateRange.value,
        items:  controller.dateRangeList,
        borderColor: AppColors.textFieldBorder,
        hintText: "All Time",
        btnHeight: 56,
        onChanged: (value) {
          controller.selectedDateRange.value = value ?? "";
          // pt("value $value");
        },
        validator: (value) {
          return null;
        },
      ),
    );
  }

  Widget rating() {
    return Obx(
          ()=> CustomDropDown(
        showClearButton: true,
        selectedValue: controller.selectedRatingExport.value,
        items:  controller.orderTypeMap.keys.toList(),
        borderColor: AppColors.textFieldBorder,
        hintText: "All Orders",
        btnHeight: 56,
        onChanged: (value) {
          controller.selectedRatingExport.value = value ?? "";
        },
        validator: (value) {
          return null;
        },
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
                      svgColor: ColorFilter.mode(isSelected ? AppColors.primary : AppColors.blackClr, BlendMode.srcIn),
                      height: 22,
                      width: 22,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      index == 0 ? "CSV" : "Excel",
                      style: AppFontStyle.text_16_400(
                        isSelected ? AppColors.primary : AppColors.blackClr,
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
}
