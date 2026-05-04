import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../../../../../../../Core/Constant/image_constant.dart';
import '../../../../../../../../../../../Data/response/status.dart';
import '../../../../../../../../../../../Utils/account_type_card.dart';
import '../../../../../../../../../../../Utils/sized_box.dart';
import '../../../../../../../../../../../shared/theme/colors.dart';
import '../../../../../../../../../../../shared/theme/font_family.dart';
import '../../../../../../../../../../../shared/theme/font_style.dart';
import '../../../../../../../../../../../shared/widgets/custom_appbar.dart';
import '../../../../../../../../../../../shared/widgets/image.dart';
import '../../../../../../../../../../../shared/widgets/vendor_widgets/app_container.dart';
import '../../../../../../../../../../../shared/widgets/vendor_widgets/circular_progress_indicator.dart';
import '../../../../../../../../../../../shared/widgets/vendor_widgets/custom_dropdown.dart';
import '../../../../../../../../../../../shared/widgets/vendor_widgets/custom_elevated_button.dart';
import '../../../../../../../../../../../shared/widgets/vendor_widgets/custom_text_form_field.dart';
import '../../../../RestaurantInformation/view/restaurant_information_screen.dart';
import '../controller/res_upload_compliance_document_controller.dart';

class ResUploadComplianceDocumentsScreen extends GetView<ResUploadComplianceDocumentController> {
  const ResUploadComplianceDocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: body(),
    );
  }

  Widget body() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22.0),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             header(
               title: "Upload Compliance Document",
               description: "Add a new certificate or license for review",
             ),
             hBox(20),
             title("Document Type *"),
             hBox(6),
             Obx(
               ()=> CustomDropDown(
                 key: controller.docTypeKey,
                 btnHeight: 56,
                 items: controller.docType,
                 selectedValue: controller.selectedDocType.value,
                 hintText: "Select document type",
                 onChanged: (val) {
                   controller.selectedDocType.value = val ?? "";
                   if(val != null || (val?.isNotEmpty ?? false)){
                     controller.isErrorDocType.value = false;
                   }
                },
               ),
             ),
             Obx(
               ()=> controller.isErrorDocType.value == true ? Padding(
                 padding: const EdgeInsets.only(left: 8.0,top: 4),
                 child: Text("Please select document type",
                   style: AppFontStyle.text_12_400(
                     AppColors.errorColor,
                     fontFamily: AppFontFamily.gilroyMedium,
                   ),
                 ),
               ) : const SizedBox.shrink(),
             ),
             hBox(18),
             title("Document/License Number *"),
             hBox(6),
            CustomTextFormField(
              key: controller.licenseNoKey,
              controller:controller.docLicenceNoController.value ,
              hintText: 'e.g., HP-2024-12345',
              validator: (value) {
                if(value == null || value.isEmpty){
                  return "Please enter a valid document/license number";
                }
                return null;
              },
            ),
             hBox(18),
             title("Issuing Authority *"),
             hBox(6),
             CustomTextFormField(
               key: controller.issuingAuthorityKey,
              controller:controller.issuingAuthorityController.value ,
              validator: (value) {
                if(value?.isEmpty ?? false){
                  return "Please enter issuing authority";
                }
                return null;
              },
              hintText: 'e.g., Department of Health',
            ),
             hBox(18),
             issueAndExpiryDate(),
             hBox(18),
             title("Upload Document *"),
             hBox(6),
            uploadDocuments(),
             Obx(
                 ()=> controller.isErrorColor.value == true ? Padding(
                 padding: const EdgeInsets.only(left: 8.0,top: 4),
                 child: Text("Please choose file",
                   style: AppFontStyle.text_12_400(
                     AppColors.errorColor,
                     fontFamily: AppFontFamily.gilroyMedium,
                   ),
                 ),
               ) : const SizedBox.shrink(),
             ),
            hBox(18),
             title("Additional Notes"),
             hBox(6),
             CustomTextFormField(
               controller: controller.additionalController.value,
               maxLines: 5,
               minLines: 5,
               hintText: 'Add any relevant notes about this document...',
             ),
             hBox(20),
             accessControllerCard(des:"Your document will be reviewed by our compliance team. You'll be notified once it's approved."),
             hBox(20),
             CustomElevatedButton(
               height: 56,
               onPressed: (){
                 controller.isErrorDocType.value = false;
                 controller.isErrorColor.value = false;

                 if(controller.selectedDocType.value.isEmpty){
                   controller.isErrorDocType.value = true;
                   controller.scrollToFields(controller.docTypeKey);
                   controller.formKey.currentState?.validate();
                 }else if(controller.docLicenceNoController.value.text.isEmpty){
                   controller.scrollToFields(controller.licenseNoKey);
                   controller.formKey.currentState?.validate();
                 }else if(controller.issuingAuthorityController.value.text.isEmpty){
                   controller.scrollToFields(controller.issuingAuthorityKey);
                   controller.formKey.currentState?.validate();
                 }else if(controller.issueDateController.value.text.isEmpty){
                   controller.scrollToFields(controller.issueKey);
                   controller.formKey.currentState?.validate();
                 }else if(controller.expiryDateController.value.text.isEmpty){
                   controller.scrollToFields(controller.expiryDateKey);
                   controller.formKey.currentState?.validate();
                 } if (controller.image.value == null || (controller.image.value?.path.isEmpty ?? true)) {
                   controller.isErrorColor.value = true;
                   controller.scrollToFields(controller.uploadDocKey);
                 } else if(controller.formKey.currentState?.validate() ?? false){
                   controller.complianceDocumentsUploadApi();
                 }
               },
               child: Obx(() {
                 return controller.uploadDoc.value.status == ApiStatus.LOADING ? circularProgressIndicator(color: AppColors.white)  :
                  Text("Upload Document",
                 style: AppFontStyle.text_16_400(
                   AppColors.white,
                   fontFamily: AppFontFamily.gilroySemiBold,
                 ),);
               }),
             ),
             hBox(10),
           ],
          ),
        ),
      ),
    );
  }


  Widget uploadDocuments() {
    return Obx(
      ()=> SizedBox(
            height: 224,
            child: InkWell(
              onTap: () => controller.pickImage(Get.context!),
              child: DottedBorder(
                borderType: BorderType.RRect,
                radius: const Radius.circular(12),
                padding: const EdgeInsets.all(6),
                dashPattern: const [4],
                color: controller.isErrorColor.value
                    ? AppColors.red
                    : AppColors.borderClr,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  child: Center(
                    child: Obx(() {
                      final imageFile = controller.image.value;


                      // Check if the current file is PDF by its path
                      final isPdf = imageFile?.path.toLowerCase().endsWith('.pdf') ?? false;

                      return SizedBox(
                        width: Get.width,
                        height: Get.width * .7,

                        child: isPdf
                            ? Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AppImage(
                                  path: ImageConstants.pdfPng,
                                  height: 110,width: 110,
                                ),
                                hBox(14),
                                Text(imageFile?.path.split('/').last.toString() ?? "",
                                  style: AppFontStyle.text_14_500(
                                    AppColors.blackClr,
                                    fontFamily: AppFontFamily.gilroyMedium,
                                  ),
                                ),
                              ],
                            )
                            : imageFile != null
                            ? Image.file(
                          imageFile,
                          width: 130,
                          height: 130,
                          fit: BoxFit.fill,
                        )

                            : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppContainer(
                              color: AppColors.backgroundClr,
                              radius: 10,
                              boxShadow: const [],
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                child: SvgPicture.asset(
                                  ImageConstants.uploadImage,
                                  height: 24,
                                  width: 24,
                                  colorFilter: ColorFilter.mode(
                                    AppColors.hintText,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 15),

                            Text(
                              "Click to upload or drag and drop",
                              style: AppFontStyle.text_14_500(
                                AppColors.blackClr,
                                fontFamily: AppFontFamily.gilroyMedium,
                              ),
                            ),

                            const SizedBox(height: 2),

                            Text(
                              "PDF, JPG, PNG up to 10MB",
                              style: AppFontStyle.text_13_400(
                                AppColors.hintText,
                                fontFamily: AppFontFamily.gilroyMedium,
                              ),
                            ),

                            const SizedBox(height: 16),

                            CustomElevatedButton(
                              height: 40,
                              width: 107,
                              padding: EdgeInsets.zero,
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.white,
                              borderSide: BorderSide(
                                color: AppColors.blackClr,
                              ),
                              onPressed: () {
                                controller.pickImage(Get.context!);
                              },
                              child: Text(
                                "Choose File",
                                style: AppFontStyle.text_14_500(
                                  AppColors.blackClr,
                                  fontFamily: AppFontFamily.gilroySemiBold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
          ),
    );
  }

  Widget issueAndExpiryDate() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Expanded(
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   title("Issue Date *"),
                   hBox(6),
                   CustomTextFormField(
                     key: controller.issueKey,
                     controller: controller.issueDateController.value,
                     readOnly: true,
                     hintText: 'dd/mm/yyyy',
                     validator: (value) {
                       if(value?.isEmpty ?? false){
                         return "Please select issue date";
                       }
                       return null;
                     },
                     onChanged: (value) {
                       if (controller.expiryDateController.value.text.isNotEmpty) {
                         controller.formKey.currentState?.validate();
                       }
                     },
                     suffix: InkWell(
                          onTap: () {
                            controller.pickDate(controller: controller.issueDateController.value);
                          },
                         child: const Icon(Icons.calendar_today,size: 22)),
                   ),
                 ],
               ),
             ),

             wBox(12), // spacing between fields

             Expanded(
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   title("Expiry Date *"),
                   hBox(6),
                   CustomTextFormField(
                     key: controller.expiryDateKey,
                     readOnly: true,
                     controller: controller.expiryDateController.value,
                     hintText: 'dd/mm/yyyy',
                     validator: (value) {
                       if(value?.isEmpty ?? false){
                         return "Please select expiry date";
                       }
                       if(controller.issueDateController.value.text.isNotEmpty){
                         final issueDate = DateFormat("dd/MM/yyyy").parse(controller.issueDateController.value.text);
                         final expiryDate = DateFormat("dd/MM/yyyy").parse(value ?? "");
                         if(expiryDate.isBefore(issueDate)){
                           return "Expiry date cannot be before issue date";
                         }
                       }
                       return null;
                     },
                     onChanged: (value) {
                       if (controller.expiryDateController.value.text.isNotEmpty) {
                         WidgetsBinding.instance.addPostFrameCallback((_) {
                           controller.formKey.currentState?.validate();
                         });
                       }
                     },
                     suffix: InkWell(
                         onTap: () {
                           controller.pickDate(controller: controller.expiryDateController.value);
                         },
                         child: const Icon(Icons.calendar_today,size: 22)),
                   ),
                 ],
               ),
             ),
           ],
         );
  }

  title(String title) {
    return Text(
      title,
      style: AppFontStyle.text_16_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroySemiBold),
    );
  }

}
