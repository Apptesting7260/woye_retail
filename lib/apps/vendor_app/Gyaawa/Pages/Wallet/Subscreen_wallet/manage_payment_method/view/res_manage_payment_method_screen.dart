import 'package:country_code_picker/country_code_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../../../Core/Constant/image_constant.dart';
import '../../../../../../../../Data/components/general_exception.dart';
import '../../../../../../../../Data/components/internet_exception.dart';
import '../../../../../../../../Data/response/status.dart';
import '../../../../../../../../Utils/sized_box.dart';
import '../../../../../../../../shared/theme/colors.dart';
import '../../../../../../../../shared/theme/font_family.dart';
import '../../../../../../../../shared/theme/font_style.dart';
import '../../../../../../../../shared/widgets/custom_appbar.dart';
import '../../../../../../../../shared/widgets/custom_elevated_button.dart';
import '../../../../../../../../shared/widgets/image.dart';
import '../../../../../../../../shared/widgets/shimmer_widget.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/app_container.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/custom_checkbox.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/custom_dropdown.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/custom_text_form_field.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/print.dart';
import '../../../../Profile/Sub_Screens/Setting/RestaurantInFormation/view/restaurant_information_screen.dart';
import '../controller/res_manage_payment_method_controller.dart';

class ResManagePaymentMethod extends GetView<ResManagePaymentMethodController>{
  const ResManagePaymentMethod({super.key});

  @override
  build(BuildContext context){
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Obx(() {
        switch(controller.allBankData.value.status){
          case ApiStatus.LOADING :
            return shimmerView();
          case ApiStatus.COMPLETED :
            return body();
          case ApiStatus.ERROR :
            if (controller.allBankData.value.message == 'No internet' || controller.allBankData.value.message == 'InternetExceptionWidget') {
              return InternetExceptionWidget(onPress: () {controller.getAllBankList();});
            }else{
              return GeneralExceptionWidget(onPress: (){controller.getAllBankList();});
            }
          default :
            return const SizedBox();
        }
      },),
    );
  }

  Widget body() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          header(
            title: "Manage Payment Methods",
            description: "Add or update your payment methods for receiving restaurant earnings"
          ),
          hBox(18),
          catButton(),
          hBox(16),
          Expanded(
            child: Obx(() {
              return  controller.selectedTypeIndex.value == 0 ?  bankAccount()  : mobileMoney();
            },
            ),
          ),
        ],
      ),
    );
  }

    Widget bankAccount(){
      return Obx(
        ()=> SingleChildScrollView(
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                hBox(4),
                title("Bank Name"),
                hBox(6),
                bankName(),
                hBox(18),
                title("Account Type"),
                hBox(6),
                Obx(
                  ()=> CustomDropDown(
                    key: controller.accountTypeKey,
                    selectedValue: controller.selectedAccountType.value,
                    btnHeight: 56,
                    hintText: "Business",
                    hintStyle: AppFontStyle.text_15_400(AppColors.hintText,fontFamily: AppFontFamily.gilroyRegular),
                    items: controller.accountType,
                    onChanged: (value){
                      controller.selectedAccountType.value = value ?? "";
                      pt("controller.selectedAccountType.value ${controller.selectedAccountType.value}");
                    },
                    validator: (value) {
                      if (controller.selectedAccountType.value.isEmpty) {
                        return "Please select account type";
                      }
                      return null;
                    },
                  ),
                ),
                hBox(18),
                title("Bank Code"),
                hBox(6),
                CustomTextFormField(
                  key: controller.bankCodeKey,
                  readOnly: true,
                  controller: TextEditingController(text: controller.selectedAccountCode.value),
                  hintText: "Bank code",
                  validator: (value) {
                    if(controller.selectedAccountCode.value.isEmpty){
                      return "Please enter bank code";
                    }
                    return null;
                  },
                ),
                hBox(18),
                title("Account Holder Name"),
                hBox(6),
                CustomTextFormField(
                  key: controller.accountHolderKey,
                  controller: controller.accountHolderController,
                  hintText: "Account Holder Name",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter account holder name";
                    }
                    return null;
                  },
                ),
                hBox(18),
                // title("Routing Number"),
                // hBox(6),
                // const CustomTextFormField(
                //   hintText: "123456789  ",
                // ),
                // hBox(18),
                title("Account Number"),
                hBox(6),
                CustomTextFormField(
                  controller: controller.accountNumberController,
                  key: controller.accountNumberKey,
                  textInputType: const TextInputType.numberWithOptions(decimal: false,signed: false),
                  hintText: "Enter account number",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter account number";
                    }else if(value.length < 10){
                      return "Please enter a valid account number";
                    }
                    return null;
                  },
                ),
                hBox(18),
                title("Confirm Account Number"),
                hBox(6),
                CustomTextFormField(
                  key: controller.confirmAccountNumberKey,
                  controller: controller.confirmAccountNumberController,
                  textInputType: const TextInputType.numberWithOptions(decimal: false,signed: false),
                  hintText: "Confirm account number",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please re-enter your account number";
                    }else if(value != controller.accountNumberController.text){
                      return "Please enter correct account number(Account number not matched)";
                    }
                    return null;
                  },
                ),
                hBox(18),
                // title("Verification Method",isRequired: false),
                // hBox(6),
                // CustomDropDown(
                //   btnHeight: 56,
                //   hintText: "Business Checking",
                //   items: [],
                //   onChanged: (value){},
                // ),
                // hBox(14),
                agreement(),
                if(controller.error.value != "")...[
                hBox(4),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Text(controller.error.value,
                  style: AppFontStyle.text_12_400(
                    AppColors.errorColor,
                    fontFamily: AppFontFamily.gilroyMedium,
                  ),),
                ),
                ],
                hBox(20),
                Obx(
                  ()=> CustomElevatedButton(
                    isLoading: controller.paymentMethodData.value.status == ApiStatus.LOADING ||
                        controller.updatedBankDetailsData.value.status == ApiStatus.LOADING,
                    height: 56,
                    text: controller.paymentMethod.value != "" ? "Update Payment Method" : "Save Payment Method",
                    onPressed: () {
                      if ((controller.formKey.currentState?.validate() ?? false) && controller.isAgree.value == true) {
                        if(controller.paymentMethod.value != ""){
                          controller.updateBankDetails();
                        }else {
                          controller.addPaymentMethod();
                        }
                      } else {
                        controller.formKey.currentState?.validate();
                        if (controller.selectedBankName.value.isEmpty) {
                          controller.scrollToField(controller.bankNameKey);
                          return;
                        }
                        if (controller.selectedAccountType.value.isEmpty) {
                          controller.scrollToField(controller.accountTypeKey);
                          return;
                        }
                        if (controller.accountHolderController.text.isEmpty) {
                          controller.scrollToField(controller.accountHolderKey);
                          return;
                        }
                        if (controller.accountNumberController.text.isEmpty) {
                          controller.scrollToField(controller.accountNumberKey);
                          return;
                        }
                        if (controller.confirmAccountNumberController.text.isEmpty) {
                          controller.scrollToField(controller.confirmAccountNumberKey);
                          return;
                        }
                        if(controller.isAgree.value == false){
                          controller.addError("Please agree the term and condition");
                          return;
                        }
                      }
                    },
                  ),
                ),
                hBox(16),
              ],
            ),
          ),
        ),
      );
    }

      Obx bankName() {
        return Obx(
            () {
          return DropdownButtonFormField2<String>(
            key: controller.bankNameKey,
            isDense: true,
            isExpanded: true,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            value: controller.selectedAccountCode.value.isEmpty ? null : controller.selectedAccountCode.value,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please select bank";
              }
              return null;
            },

            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.filledClr.withAlpha(150),
              contentPadding: REdgeInsets.symmetric(
                vertical: 15,
                horizontal: 10,
              ),

              errorStyle: AppFontStyle.text_12_400(
                AppColors.errorColor,
                fontFamily: AppFontFamily.gilroyMedium,
              ),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.r),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.r),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.r),
                borderSide: BorderSide.none,
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.r),
                borderSide: BorderSide.none,
              ),
            ),

            hint: Text(
              "Choose Bank",
              style: AppFontStyle.text_16_400(
                AppColors.black,
                fontFamily: AppFontFamily.gilroyMedium,
              ),
            ),

            items: controller.allBankData.value.data?.paystackBank
                ?.map(
                  (bank) => DropdownMenuItem<String>(
                  value: bank.code ?? '',
                child: Text(
                  bank.name ?? "",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: AppFontStyle.text_14_400(
                    AppColors.black,
                    fontFamily: AppFontFamily.gilroyMedium,
                  ),
                ),
              ),
            )
                .toList() ??
                [],

            onChanged: (value) {
              if (value == null) {
                controller.selectedAccountCode.value = "";
                controller.selectedBankName.value = "";
                controller.selectedBankId.value = "";
                return;
              }

              final bank = controller.allBankData.value.data?.paystackBank
                  ?.firstWhere((e) => e.code == value);

              if (bank != null) {
                controller.selectedAccountCode.value = bank.code ?? "";
                controller.selectedBankName.value = bank.name ?? "";
                controller.selectedBankId.value = bank.id ?? "";
              }
            },

            iconStyleData: IconStyleData(
              icon:  Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 22,
                color: AppColors.black,
              ),
            ),

            dropdownStyleData: DropdownStyleData(
              maxHeight:  300.h,
              offset:  const Offset(0, 15),
              scrollPadding: EdgeInsets.zero,
              padding: REdgeInsets.only(left: 10, top: 12, bottom: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.r),
                border: Border.all(color: Colors.white, width: 1),
                color: AppColors.white,
              ),
              scrollbarTheme: ScrollbarThemeData(
                radius: const Radius.circular(40),
                thickness: WidgetStateProperty.all<double>(1),
                thumbVisibility: WidgetStateProperty.all<bool>(true),
              ),
            ),
            menuItemStyleData: const MenuItemStyleData(
              height:  35,
              padding: EdgeInsets.symmetric(horizontal: 0),
            ),
          );
        },
      );
      }


  Widget mobileMoney(){
    return SingleChildScrollView(
      child: Form(
        key: controller.formKeyForMM,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            hBox(4),
            title("Mobile Money Provider"),
            hBox(6),
            CustomDropDown(
              key: controller.moneyProviderKey,
              btnHeight: 56,
              hintText: "MTN Mobile Money",
              selectedValue: controller.selectedMobileMoneyProvider.value,
              items: controller.mobileMoneyProviderList,
              onChanged: (value){
                controller.selectedMobileMoneyProvider.value = value ?? "";
              },
              validator: (value) {
                if(controller.selectedMobileMoneyProvider.value == null || controller.selectedMobileMoneyProvider.value.isEmpty){
                  return "Please select mobile money provider";
                }
                return null;
              },
              hintStyle: AppFontStyle.text_15_400(AppColors.hintText,fontFamily: AppFontFamily.gilroyRegular),
            ),
            hBox(18),
            title("Mobile Number"),
            hBox(6),
            Obx(() =>
                CustomTextFormField(
                  key: controller.phoneKey,
                  controller: controller.mobNoCon.value,
                  onTap: (){
                    // controller.isSubmit.value = false;
                  },
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
                        showFlag: false,
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
                        initialSelection: controller.bankDetailsData.value.data?.data != null ? controller.bankDetailsData.value.data?.data?.first.phoneCode ??
                            controller.countryCode.toString() : controller.countryCode.toString(),
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
                ),
            ),
            hBox(18),
            title("Account Name"),
            hBox(6),
            CustomTextFormField(
              key: controller.accountNameMMKey,
              controller: controller.accountNameControllerMobileM,
              hintText: "Restaurant Business Account",
              validator: (value) {
                if(value == null || value.isEmpty){
                  return "Please enter account name";
                }
                return null;
              },
            ),
            hBox(18),
            title("Merchant ID",isRequired: false),
            hBox(6),
             CustomTextFormField(
               key: controller.merchantKey,
               controller: controller.merchantIdController,
               hintStyle: AppFontStyle.text_15_400(AppColors.greyClr.withAlpha(150),fontFamily: AppFontFamily.gilroyRegular),
              hintText: "Enter merchant ID (if applicable)",
            ),
            hBox(6),
            Text("Optional - Only required for business accounts or specific merchant setups",
              maxLines: 4,
              style: AppFontStyle.text_14_400(AppColors.greyClr.withAlpha(150),fontFamily: AppFontFamily.gilroyRegular),
            ),
            hBox(18),
            mobileMoneyInformation(),
            hBox(20),
            agreementForMobileMoney(),
            if(controller.errorMM.value != "")...[
              hBox(4),
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Text(controller.errorMM.value,
                  style: AppFontStyle.text_12_400(
                    AppColors.errorColor,
                    fontFamily: AppFontFamily.gilroyMedium,
                  ),
                ),
              ),
            ],
            hBox(20),
            Obx(
                ()=> CustomElevatedButton(
                height: 56,
                  isLoading: controller.paymentMethodData.value.status == ApiStatus.LOADING ||
                      controller.updatedBankDetailsData.value.status == ApiStatus.LOADING,
                  text: controller.paymentMethod.value == "mobile_money" ? "Update Payment Method" : "Save Payment Method",
                onPressed: () {
                  if(controller.formKeyForMM.currentState?.validate() ?? false){
                    if(controller.isAgreeForMobile.value == false ){
                      controller.addErrorMM("Please agree the term and condition");
                      return;
                    }else{
                      if(controller.paymentMethod.value == "mobile_money"){
                        controller.updateBankDetails();
                      }else {
                        controller.addPaymentMethod();
                      }
                    }
                  }else{
                    controller.formKeyForMM.currentState?.validate();
                    if(controller.selectedMobileMoneyProvider.value.isEmpty){
                      controller.scrollToField(controller.moneyProviderKey);
                      return;
                    }
                    if(controller.mobNoCon.value.text.isEmpty || controller.mobNoCon.value.text.length != controller.checkCountryLength.value){
                      controller.scrollToField(controller.phoneKey);
                      return;
                    }
                    if(controller.accountNameControllerMobileM.text.isEmpty){
                      controller.scrollToField(controller.accountNameMMKey);
                      return;
                    }
                    if(controller.merchantIdController.text.isEmpty){
                      controller.scrollToField(controller.merchantKey);
                      return;
                    }
                  }
                },
              ),
            ),
            hBox(16),
          ],
        ),
      ),
    );
  }

  AppContainer mobileMoneyInformation() {
    return AppContainer(
          boxShadow: const [],
          width: Get.width,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: Border.all(color: AppColors.grey.withAlpha(28)),
          borderRadius: BorderRadius.circular(10),
          color: AppColors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Mobile Money Information",
                style: AppFontStyle.text_15_400(AppColors.blueClr,fontFamily: AppFontFamily.gilroySemiBold),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 6.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    hBox(6),
                    text("Payouts are processed within 24 hours"),
                    text("Transaction fees may apply based on provider"),
                    text("Ensure your mobile money account is active and verified"),
                    text("Contact customer support if you encounter any issues"),
                  ],
                ),
              ),
            ],
          ),
        );
  }

  Widget text(name) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("• ",
          style: AppFontStyle.text_14_400(AppColors.blueClr,fontFamily: AppFontFamily.gilroyRegular),
        ),
        Expanded(
          child: Text(name,
            maxLines: 2,
            style: AppFontStyle.text_12_400(AppColors.blueClr,fontFamily: AppFontFamily.gilroyRegular),
          ),
        ),
      ],
    );
  }



  AppContainer agreement() {
    return AppContainer(
      boxShadow: const [],
      width: Get.width,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: Border.all(color: AppColors.grey.withAlpha(28)),
      borderRadius: BorderRadius.circular(10),
      color: AppColors.white,
      child: CustomCheckboxTile(
        maxLines: 10,
        style: AppFontStyle.text_14_400(AppColors.blueLightColor,fontFamily: AppFontFamily.gilroyRegular),
        title: "I agree to the payment processing terms and conditions. I confirm that this account is owned by the registered restaurant business and will be used only for legitimate restaurant transactions.",
        value: controller.isAgree,
         onChanged: (status) {
          controller.updateAgree(status);
          if(status == false){
            controller.addError("Please agree the term and condition");
          }else{
           controller.addError("");
         }
         },
      ),
    );
  }

  AppContainer agreementForMobileMoney() {
    return AppContainer(
      boxShadow: const [],
      width: Get.width,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: Border.all(color: AppColors.grey.withAlpha(28)),
      borderRadius: BorderRadius.circular(10),
      color: AppColors.white,
      child: CustomCheckboxTile(
        maxLines: 10,
        style: AppFontStyle.text_14_400(AppColors.blueClr,fontFamily: AppFontFamily.gilroyRegular),
        title: "I agree to the payment processing terms and conditions. I confirm that this account is owned by the registered restaurant business and will be used only for legitimate restaurant transactions.",
        value: controller.isAgreeForMobile,
         onChanged: (status) {
          controller.updateAgreeForMobile(status);
          if(status == false){
            controller.addErrorMM("Please agree the term and condition");
          }else{
           controller.addErrorMM("");
         }
         },
      ),
    );
  }

  Widget catButton() {
    return AppContainer(
      boxShadow: const [],
      radius: 100,
      color: AppColors.cardBgColor,
      width: Get.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(
            2,
                (index) => Obx(
                  () => InkWell(
                onTap: () {
                  controller.updateSelectedType(index);
                },
                child: AppContainer(
                  color: controller.selectedTypeIndex.value == index ? AppColors.white : AppColors.transparent,
                  radius: 100,
                  boxShadow: const [],
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                     Padding(
                       padding: const EdgeInsets.only(bottom: 2.0),
                       child: AppImage(path: index == 0 ?  ImageConstants.bankLogoNew : ImageConstants.mobile, height: 16,width: 16,),
                     ),
                      wBox(4),
                      Text(controller.categoryList[index],
                      style: AppFontStyle.text_14_400(AppColors.blackClr,
                      fontFamily: controller.selectedTypeIndex.value == index ? AppFontFamily.gilroySemiBold : AppFontFamily.gilroyMedium,
                      ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Text title(name,{bool isRequired = true}) => Text(isRequired ? "$name *" : name,style: AppFontStyle.text_16_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroySemiBold));

  Widget shimmerView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          hBox(20),

          /// Header
          const ShimmerBox(width: 220, height: 20),
          hBox(10),
          const ShimmerBox(width: 300, height: 14),
          hBox(25),

          /// Category Toggle
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShimmerBox(width: 150, height: 40, radius: 100),
              ShimmerBox(width: 150, height: 40, radius: 100),
            ],
          ),

          hBox(25),

          /// Form Fields
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  6,
                      (index) => const Padding(
                    padding: EdgeInsets.only(bottom: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerBox(width: 140, height: 16),
                        SizedBox(height: 8),
                        ShimmerBox(width: double.infinity, height: 56),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          hBox(20),
        ],
      ),
    );
  }
}