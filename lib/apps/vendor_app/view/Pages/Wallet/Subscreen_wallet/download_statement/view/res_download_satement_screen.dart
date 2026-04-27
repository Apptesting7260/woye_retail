import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../../Core/Constant/image_constant.dart';
import '../../../../../../../../Data/response/status.dart';
import '../../../../../../../../Utils/sized_box.dart';
import '../../../../../../../../shared/theme/colors.dart';
import '../../../../../../../../shared/theme/font_family.dart';
import '../../../../../../../../shared/theme/font_style.dart';
import '../../../../../../../../shared/widgets/custom_appbar.dart';
import '../../../../../../../../shared/widgets/image.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/circular_progress_indicator.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/custom_checkbox.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/custom_dropdown.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/custom_elevated_button.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/print.dart';
import '../../../../Profile/Sub_Screens/Setting/RestaurantInFormation/view/restaurant_information_screen.dart';
import '../../../controller/restaurant_wallets_controller.dart';

class ResDownloadStatementScreen extends StatefulWidget {
  const ResDownloadStatementScreen({super.key});

  @override
  State<ResDownloadStatementScreen> createState() => _ResDownloadStatementScreenState();
}

class _ResDownloadStatementScreenState extends State<ResDownloadStatementScreen> {
  final controller = Get.find<RestaurantWalletsController>();

  @override
  void initState() {
    super.initState();
    controller.selectedStatementPeriod.value = "";
    controller.selectedFileFormat.value = "";
    controller.selectedIncludeStatement.value = List.generate(controller.includeStatement.length, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0),
          child: Form(
            key: controller.formKeyDS,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                header(
                  title: "Download Statement",
                  description: "Generate and download a financial statement for your restaurant with customizable date ranges and transaction types."
                ),
                hBox(20),
                title("Statement Period",isRequired: false),
                hBox(6),
                Obx(
                  ()=>CustomDropDown(
                    btnHeight: 56,
                    selectedValue: controller.selectedStatementPeriod.value,
                    hintText:"Last 30 days",
                    items: controller.statementPeriodsList,
                    onChanged: (val){
                      controller.selectedStatementPeriod.value = val ?? "";
                    },
                    validator:(val) {
                      if(controller.selectedStatementPeriod.value == ""){
                        return "Please select statement period";
                      }
                      return null;
                    },
                  ),
                ),
                hBox(18),
                title("File Format",isRequired: false),
                hBox(6),
                Obx(
                  ()=> CustomDropDown(
                    btnHeight: 56,
                    hintText:"PDF",
                    selectedValue: controller.selectedFileFormat.value,
                    items: controller.fileFormat,
                    onChanged: (val){
                      controller.selectedFileFormat.value = val ?? "";
                    },
                    validator:(val) {
                      if(controller.selectedFileFormat.value == ""){
                        return "Please select statement period";
                      }
                      return null;
                    },
                  ),
                ),
                hBox(18),
                title("Include in Statement",isRequired: false),
                hBox(10),
              ListView.separated(
                separatorBuilder: (context, index) => hBox(8),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.includeStatement.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Obx(() => CustomCheckboxTile(
                    title: controller.includeStatement[index],
                    value: controller.selectedIncludeStatement[index].obs,
                    onChanged: (value) {
                      controller.selectedIncludeStatement[index] = value;
                      pt("Updated List: ${controller.selectedIncludeStatement}");
                    },
                  ));
                },
              ),
                hBox(20),
               statementDetails(),
                hBox(20),
                CustomElevatedButton(
                  onPressed: (){
                  if(controller.formKeyDS.currentState?.validate() ?? false){
                    controller.downloadStatement();
                  }
                },
                  child:Obx(
                      ()=> controller.statementData.value.status == ApiStatus.LOADING ? circularProgressIndicator(color: AppColors.white) :  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppImage(path: ImageConstants.downloadLogo,svgColor: ColorFilter.mode(AppColors.white, BlendMode.srcIn)),
                        wBox(6),
                        Text("Download",style: AppFontStyle.customText(AppColors.white,18, FontWeight.w400,fontFamily: AppFontFamily.gilroyMedium),),
                      ],
                    ),
                  ),
                ),
                hBox(12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget statementDetails() {
    return Container(
        width: Get.width,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color:AppColors.cyanClr.withAlpha(180)),
          borderRadius: BorderRadius.circular(10),
          color:AppColors.cyanClr.withAlpha(40),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 2.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             Icon(Icons.info_outline,color: AppColors.blueClr,size: 20),
              wBox(8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Statement Details",
                      maxLines: 3,
                      style: AppFontStyle.text_14_400(
                       AppColors.blueClr,
                        fontFamily: AppFontFamily.gilroySemiBold,
                      ),
                    ),Text(
                      "Your statement will include all selected transaction types for last 30 days. Large date ranges may take longer to generate.",
                      maxLines: 10,
                      style: AppFontStyle.text_12_400(
                       AppColors.blueClr.withAlpha(230),
                        fontFamily: AppFontFamily.gilroyRegular,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
  }

  Text title(name,{bool isRequired = true}) => Text(isRequired ? "$name *" : name,style: AppFontStyle.text_16_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroySemiBold));
}
