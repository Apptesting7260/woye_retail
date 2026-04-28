import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../../../../../../../../../Core/Constant/image_constant.dart';
import '../../../../../../../../../Data/components/general_exception.dart';
import '../../../../../../../../../Data/components/internet_exception.dart';
import '../../../../../../../../../Data/response/status.dart';
import '../../../../../../../../../Utils/account_type_card.dart';
import '../../../../../../../../../Utils/sized_box.dart';
import '../../../../../../../../../Utils/validation.dart';
import '../../../../../../../../../shared/theme/colors.dart';
import '../../../../../../../../../shared/theme/font_family.dart';
import '../../../../../../../../../shared/theme/font_style.dart';
import '../../../../../../../../../shared/widgets/custom_appbar.dart';
import '../../../../../../../../../shared/widgets/shimmer_widget.dart';
import '../../../../../../../../../shared/widgets/vendor_widgets/custom_dropdown.dart';
import '../../../../../../../../../shared/widgets/vendor_widgets/custom_elevated_button.dart';
import '../../../../../../../../../shared/widgets/vendor_widgets/custom_text_form_field.dart';
import '../../../../../../../../../shared/widgets/vendor_widgets/print.dart';
import '../../RestaurantInFormation/view/restaurant_information_screen.dart';
import '../controller/res_add_new_user_controller.dart';

class ResAddNewUserScreen extends GetView<ResAddNewUserController>{
  const ResAddNewUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Obx(() {
        switch(controller.userDetailsData.value.status){
          case ApiStatus.LOADING :
            return buildShimmer();
          case ApiStatus.COMPLETED:
           return  body();
          case ApiStatus.ERROR:
           if(controller.userDetailsData.value.message == "No Internet"){
             return InternetExceptionWidget(onPress: () => controller.getUserDetails());
           }else{
             return GeneralExceptionWidget(onPress: () =>controller.getUserDetails());
           }
            default:
              return const SizedBox.shrink();
        }
      },),
    );
  }

  SingleChildScrollView body() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              header(
                title: controller.userId.value == "" ? "Add New User" :  "Update User",
                description: controller.userId.value != "" ?
                "Edit team member and assign their role and permissions." :
                "Add a new team member and assign their role and permissions."
              ),
              hBox(20),
              title("Full Name"),
              hBox(5),
               CustomTextFormField(
                 key:  controller.nameKey,
                controller: controller.nameController.value,
                hintText: "Enter your full name",
                validator: (value) {
                  if(value?.isEmpty ?? false){
                    return "Please enter your full name";
                  }else if(value!.length < 3){
                    return "Please enter a valid name";
                  }
                  return null;
                },
              ),
              // hBox(16),
              // title("Last Name"),
              // hBox(5),
              // CustomTextFormField(
              //   hintText: "Enter last name",
              // ),
              hBox(16),
              title("Email Address"),
              hBox(5),
              CustomTextFormField(
                key: controller.emailKey,
                controller: controller.emailController.value,
                hintText: "Enter email address",
                validator: (value) {
                  if(controller.emailController.value.text.isEmpty || controller.emailController.value.text == ''){
                    return  "Please enter email" ;
                  }
                  if(!isValidEmail(controller.emailController.value.text)){
                    return  "Please enter valid email" ;
                  }
                  return null;
                },
              ),
              hBox(16),
              title("Phone Number"),
              hBox(5),
              Obx(() =>
                  CustomTextFormField(
                    controller: controller.mobNoCon.value,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(controller.checkCountryLength.value),
                    ],
                    borderDecoration:  OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(14.r)),
                    ),
                    prefix: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CountryCodePicker(
                          padding: const EdgeInsets.only(left: 10),
                          boxDecoration: BoxDecoration(color: AppColors.textFieldBorder),
                          onChanged: (CountryCode countryCode) {
                            debugPrint("country code===========> ${countryCode.code}");
                            controller.countryCode = countryCode.dialCode.toString();
                            controller.updateCountryCode(countryCode);
                            controller.showError.value = false;
                            int? countryLength = controller
                                .countryPhoneDigits[countryCode.code.toString()];
                            if(countryLength != null){
                              controller.checkCountryLength.value = countryLength;
                            }
                          },
                          // initialSelection: "IN"
                          initialSelection: controller.userDetailsData.value.data?.user?.phoneCode ??
                              controller.countryCode.toString(),
                        ),
                        const Icon(Icons.keyboard_arrow_down_rounded),

                        wBox(5),
                      ],
                    ),
                    hintText: "Phone Number",
                    textInputType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      if (value.length != controller.checkCountryLength.value) {
                        return 'Please enter a valid phone number (${controller.checkCountryLength.value} digits\nrequired)';
                      }
                      return null;
                    },
                    autoValidateMode: AutovalidateMode.onUserInteraction,
                  )),
              hBox(16),
              title("Role"),
              hBox(5),
              Obx(
                ()=> controller.userDetailsData.value.data?.user?.roleName == "Owner" ? CustomTextFormField(
                  readOnly: true,
                  enabled: false,
                  controller: TextEditingController(text: controller.userDetailsData.value.data?.user?.roleName),
                  ) : CustomDropDown(
                  btnHeight: 56,
                  selectedValue: controller.selectedRole.value,
                  hintText: "Select Role",
                  items: controller.roleList,
                  onChanged: (role){
                    if(role != null && role.isNotEmpty){
                      controller.selectedRole.value = role;
                      controller.selectedRoleId.value = controller.roleIdMap[role]?.toString() ?? "";
                      pt("$role ${controller.selectedRole.value} >>>> ${controller.selectedRoleId.value}");
                    }else{
                      controller.selectedRole.value = "";
                      controller.selectedRoleId.value = "";
                    }
                  },
                  validator: (value) {
                    if(controller.selectedRole.value.isEmpty){
                      return "Please select role";
                    }
                    return null;
                  },
                ),
              ),
            if(controller.userId.value != "")...[
              hBox(16),
              title("Status"),
              hBox(5),
              Obx(
                ()=> controller.userDetailsData.value.data?.user?.roleName == "Owner" ?
                CustomTextFormField(
                  readOnly: true,
                  enabled: false,
                  controller: TextEditingController(text: controller.userDetailsData.value.data?.user?.status?.capitalizeFirst.toString() ?? ""),
                ) : CustomDropDown(
                    btnHeight: 56,
                    hintText: "Status",
                    selectedValue: controller.selectedStatus.value,
                    items: controller.status,
                    onChanged: (val){
                      controller.selectedStatus.value = val ?? "";
                    },
                  validator: (val) {
                      if(controller.userId.value != ""){
                    if(controller.selectedStatus.value.isEmpty){
                      return "Please select status";
                    }
                    }
                    return null;
                  },
                ),
              ),
              ],
              hBox(28),
              accessControllerCard(
                image: ImageConstants.security,
                des: 'The user will receive an email invitation to set up their account and password. They will have access to the restaurant dashboard based on their assigned role and permissions.',
                bgClr: AppColors.white,
                borderClr: AppColors.borderClr,
                textClr: AppColors.blueLightColor,
              ),
              hBox(30),
              Obx(
                ()=> CustomElevatedButton(
                  isLoading: controller.createUpdateApiData.value.status  == ApiStatus.LOADING,
                  height: 56,
                    onPressed: (){
                    if(controller.nameController.value.text.isEmpty || controller.nameController.value.text.length < 3){
                      controller.scrollToFields(controller.nameKey);
                      controller.formKey.currentState?.validate();
                    } else if(controller.emailController.value.text.isEmpty){
                      controller.scrollToFields(controller.emailKey);
                      controller.formKey.currentState?.validate();
                    }
                     if(controller.formKey.currentState?.validate() ?? false){
                       controller.createAndUpdateUser();
                     }
                    },
                    text:controller.userId.value == "" ? "Send Invitation" : "Update",
                ),
              ),
              hBox(10),
            ],
          ),
        ),
      ),
    );
  }

  Text title(title) {
    return Text(
      title,
      style: AppFontStyle.text_16_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroySemiBold),
    );
  }

  Widget buildShimmer() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
      
            // Header shimmer
            const ShimmerBox(width: 180, height: 24),
            const SizedBox(height: 8),
            const ShimmerBox(width: 280, height: 18),
      
            hBox(20),
      
            // Full Name
            const ShimmerBox(width: 120, height: 20),
            hBox(5),
            const ShimmerBox(width: double.infinity, height: 56, radius: 14),
      
            hBox(16),
      
            // Email
            const ShimmerBox(width: 140, height: 20),
            hBox(5),
            const ShimmerBox(width: double.infinity, height: 56, radius: 14),
      
            hBox(16),
      
            // Phone Number
            const ShimmerBox(width: 150, height: 20),
            hBox(5),
            Row(
              children: [
                const ShimmerBox(width: 80, height: 56, radius: 14),
                wBox(10),
                const Expanded(
                  child: ShimmerBox(width: double.infinity, height: 56, radius: 14),
                ),
              ],
            ),
      
            hBox(16),
      
            // Role
            const ShimmerBox(width: 80, height: 20),
            hBox(5),
            const ShimmerBox(width: double.infinity, height: 56, radius: 14),
      
            hBox(16),
      
            // Status (optional)
            Obx(() => controller.userId.value != ""
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ShimmerBox(width: 80, height: 20),
                hBox(5),
                const ShimmerBox(width: double.infinity, height: 56, radius: 14),
                hBox(16),
              ],
            )
                : const SizedBox()),
      
            // Access control card shimmer
            const ShimmerBox(width: double.infinity, height: 110, radius: 16),
      
            hBox(20),
      
            // Button shimmer
            const ShimmerBox(width: double.infinity, height: 56, radius: 30),
          ],
        ),
      ),
    );
  }

}
