import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
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
import '../../../../../../../../../shared/widgets/image.dart';
import '../../../../../../../../../shared/widgets/shimmer_widget.dart';
import '../../../../../../../../../shared/widgets/vendor_widgets/app_container.dart';
import '../../../../../../../../../shared/widgets/vendor_widgets/custom_checkbox.dart';
import '../../../../../../../../../shared/widgets/vendor_widgets/custom_dropdown.dart';
import '../../../../../../../../../shared/widgets/vendor_widgets/custom_dropdown_api.dart';
import '../../../../../../../../../shared/widgets/vendor_widgets/custom_elevated_button.dart';
import '../../../../../../../../../shared/widgets/vendor_widgets/custom_text_form_field.dart';
import '../../../../../../../../../shared/widgets/vendor_widgets/print.dart';
import '../../../../../../vendor_common/Models/selected_delivery_type_model.dart';
import '../../../../../../vendor_common/mapbox/view/mapbox_search_field.dart';
import '../controller/restaurant_information_controller.dart';

class RestaurantInformationScreens extends StatefulWidget {
  const RestaurantInformationScreens({super.key});

  @override
  State<RestaurantInformationScreens> createState() => _RestaurantInformationScreensState();
}

class _RestaurantInformationScreensState extends State<RestaurantInformationScreens> {

  final FillRestaurantDetailsController controller = Get.put(FillRestaurantDetailsController());

  @override
  void initState() {
    super.initState();
    controller.getInitData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            controller.isImageBorderRedClr.value = false;
            controller.isValidAddress.value   = true;
            // controller.isAddressRedClr.value   = false;
            controller.image.value = null;
            controller.imageBase64.value = "";
            // controller.clearHoursFields();
            await controller.getProfileDetailsApi();
          },
          child: Scaffold(
            body: Obx(() {
              switch (controller.rxGetProfileRequestStatus.value) {
                case ApiStatus.LOADING:
                  return buildRestaurantInformationShimmer();

                case ApiStatus.ERROR:
                  if (controller.error.value == 'No internet' || controller.error.value == 'InternetExceptionWidget') {
                    return InternetExceptionWidget(
                      onPress: () {
                        controller.getProfileDetailsApi();
                      },
                    );
                  } else {
                    return GeneralExceptionWidget(
                      onPress: () {
                        controller.getProfileDetailsApi();
                      },
                    );
                  }

                case ApiStatus.COMPLETED:
                  return PopScope(
                    canPop:controller.userModel.step != 3 ? false : (controller.userModel.step == 3 && controller.profileApiData.value.isProfileComplete == true) ?  true : false,
                    // canPop: controller.userModel.step != 3 ? false : true,
                    child: SingleChildScrollView(
                      controller: controller.scrollController,
                      child: Column(
                          children: [
                            if (controller.userModel.step == 3)
                              CustomAppBar(
                                isPop: controller.profileApiData.value.isProfileComplete == true ? true : false,
                                isLeading: controller.userModel.step == 3,
                              ),
                            if (controller.userModel.step == 1 || controller.userModel.step == 2)
                            hBox(75.h),
                            IgnorePointer(
                              ignoring: (controller.isAccountant || controller.isKitchenStaff || controller.isServiceStaff) ? true  : false,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                child: Form(
                                  key: controller.shopDetailsKey,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      header(
                                        title:  "Restaurant Information",
                                        description: "Update your restaurant's basic details and contact information",
                                      ),
                                      hBox(14.h),
                                      Text(
                                        'Basic Details',
                                        style: AppFontStyle.customText(
                                          AppColors.darkText,
                                          20.sp,
                                          FontWeight.w600,
                                          fontFamily: AppFontFamily.gilroyMedium,
                                        ),
                                        maxLines: 2,
                                      ),
                                      hBox(20.h),
                                      profileDetails(),
                                      const Divider(height: 46),
                                      Text(
                                        "Address & Visual Assets",
                                        style: AppFontStyle.customText(
                                          AppColors.darkText,
                                          20.sp,
                                          FontWeight.w600,
                                          fontFamily: AppFontFamily.gilroyMedium,
                                        ),
                                        maxLines: 2,
                                      ),
                                      addressFromGoogleAPI(),
                                      hBox(16.h),
                                      title("Restaurant Logo"),
                                      hBox(6.h),
                                      restaurantLogo(),
                                      hBox(16.h),
                                      title("Cover Photo"),
                                      hBox(6.h),
                                      _profileImagePicker(context),
                                      hBox(30.h),
                                      // shopNameField(),
                                      // hBox(15.h),
                                      // // shopDescriptionField(),
                                      // // hBox(10.h),
                                      // hBox(15.h),
                                      // hBox(30.h),
                                      // Text(
                                      //   "Shop Opening Hours",
                                      //   style: AppFontStyle.customText(
                                      //     AppColors.darkText,
                                      //     18.sp,
                                      //     FontWeight.w600,
                                      //     fontFamily: AppFontFamily.gilroyRegular,
                                      //   ),
                                      // ),
                                      // shopOpeningHoursBtn(),
                                      const Divider(height: 46),
                                      businessInformation(),
                                      const Divider(height: 46),
                                      socialMedia(),
                                      const Divider(height: 46),
                                      deliveryAndServiceInformation(),
                                      hBox(20.h),
                                      CustomCheckboxTile(
                                          title: "Pre Order",
                                          style: AppFontStyle.text_16_400(AppColors.black,fontFamily: AppFontFamily.gilroyMedium),
                                          value: controller.isPreOrder,
                                          onChanged: (value) {
                                            controller.updatePreOrderValue(value);
                                          },
                                      ),
                                      hBox(20.h),
                                      serviceType(),
                                      if(!controller.isAccountant && !controller.isKitchenStaff&& !controller.isServiceStaff)...[
                                      hBox(50.h),
                                      accountTypeCard(),
                                      hBox(40.h),
                                      saveButton(),
                                      ],
                                      hBox(20.h),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                  );
              }
            }),
          ),
        ),
      ),
    );
  }

  Column serviceType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title("Service Type"),
        hBox(6),

        Obx(() {
          if (controller.serviceTypesFromApi.isEmpty) {
            return const SizedBox.shrink();
          }

          return Wrap(
            spacing: 50,
            runSpacing: 20,
            children: controller.serviceTypesFromApi.map((type) {
              final isDelivery = type.toLowerCase() == "delivery";

              final isSelected = isDelivery  ? true : controller.isServiceSelected(type);

              return Opacity(
                opacity: isDelivery ? 0.8 : 1,
                child: IgnorePointer(
                  ignoring: isDelivery,
                  child: CustomCheckboxTile(
                    title: type,
                    value: isSelected.obs,
                    onChanged: (_) {
                      controller.toggleService(type);
                    },
                  ),
                ),
              );
            }).toList(),
          );
        }),
      ],
    );
  }

  Widget socialMedia() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Social Media & Online Presence",
          style: AppFontStyle.customText(
            AppColors.darkText,
            20.sp,
            FontWeight.w600,
            fontFamily: AppFontFamily.gilroyMedium,
          ),
          maxLines: 2,
        ),
        hBox(14.h),
        title('Facebook Profile'),
        hBox(5.h),
        CustomTextFormField(
          key: controller.facebookKey,
          controller: controller.facebookController.value,
          hintText: "https://facebook.com/...",
         validator: (value) => validateSocialUrl(value, "Facebook"),
          prefix: Padding(
            padding: const EdgeInsets.only(left: 12.0,right: 4),
            child: Icon(Icons.facebook,color: AppColors.blueClr,size: 24,),
          ),
        ),
        hBox(14.h),
        title('Instagram Profile'),
        hBox(5.h),
        CustomTextFormField(
          key: controller.instagramKey,
          controller: controller.instagramController.value,
          hintText: "https://instagram.com/.....",
          validator: (value) => validateSocialUrl(value, "Instagram"),
          prefix: Padding(
            padding: const EdgeInsets.only(left: 12.0,right: 4),
            child: AppImage(path: ImageConstants.instagram),
          ),
        ),
        hBox(14.h),
        title('Twitter Profile'),
        hBox(5.h),
        CustomTextFormField(
          key: controller.twitterKey,
          controller: controller.twitterController.value,
          hintText: "https://twitter.com/.....",
          validator: (value) => validateSocialUrl(value, "Twitter"),
          prefix: Padding(
            padding: const EdgeInsets.only(left: 12.0,right: 4),
            child: AppImage(path: ImageConstants.twitter),
          ),
        ),
        hBox(14.h),
        title('Youtube'),
        hBox(5.h),
        CustomTextFormField(
          key: controller.youtubeKey,
          controller: controller.youtubeController.value,
          hintText: "https://youtube.com/.....",
          validator: (value) => validateSocialUrl(value, "YouTube"),
          prefix: Padding(
            padding: const EdgeInsets.only(left: 12.0,right: 4),
            child: AppImage(path: ImageConstants.ytLogo,height: 24)
          ),
        ),
      ],
    );
  }

  Widget deliveryAndServiceInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Delivery & Service Information",
          style: AppFontStyle.customText(
            AppColors.darkText,
            20.sp,
            FontWeight.w600,
            fontFamily: AppFontFamily.gilroyMedium,
          ),
          maxLines: 2,
        ),
        hBox(14.h),
        title('Delivery Radius (miles)'),
        hBox(5.h),
        CustomTextFormField(
          key: controller.deliveryRadiusKey,
          controller: controller.deliveryRadiusController.value,
          hintText: "10",
          textInputType: const TextInputType.numberWithOptions(
            decimal: true,
            signed: false,
          ),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,3}')),
          ],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter delivery radius";
            }

            // Final validation check
            final regex = RegExp(r'^\d+(\.\d{1,3})?$');

            if (!regex.hasMatch(value)) {
              return "Enter valid number (max 3 decimals (99.999))";
            }

            final number = double.tryParse(value);

            if (number == null || number <= 0) {
              return "Delivery radius must be greater than 0";
            }
            return null;
          },
          prefix: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 0),
            child: Icon(
              Icons.pin_drop_outlined,
              size: 20,
              color: AppColors.blackClr,
            ),
          ),
          // prefix: Padding(
          //   padding: const EdgeInsets.only(left: 16.0,right: 0),
          //   child: Text('\$',style:AppFontStyle.text_18_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroySemiBold) ,),
          // ),
        ),
        hBox(14.h),
        title('Minimum Order for Delivery'),
        hBox(5.h),
        CustomTextFormField(
          controller: controller.minimumOrderController.value,
          hintText: "15",
          textInputType: const TextInputType.numberWithOptions(
            decimal: true,
            signed: false,
          ),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,3}')),
          ],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return null;
            }

            // Final validation check
            final regex = RegExp(r'^\d+(\.\d{1,3})?$');

            if (!regex.hasMatch(value)) {
              return "Enter valid amount (max 3 decimals (99.999))";
            }

            return null;
          },
          prefix: Padding(
            padding: const EdgeInsets.only(left: 16.0,right: 0),
            child: Text('\$',style:AppFontStyle.text_18_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroySemiBold) ,),
          ),
        ),
        hBox(14.h),
        title('Delivery Type'),
        hBox(5.h),
        selectedDelivery(),
        if(controller.selectedDelivery.value == "0")...[
        hBox(14.h),
        title('Delivery Fee'),
        hBox(5.h),
        deliveryFee(),
        ],
        hBox(14.h),
        if(controller.selectedDelivery.value == "0")...[
          title('Minimum Amount for Free Delivery'),
          hBox(5.h),
          CustomTextFormField(
            key: controller.minimumOrderForFreeDeliveryKey,
            controller: controller.minimumOrderForFreeDeliveryController.value,
            hintText: "15",
            textInputType: const TextInputType.numberWithOptions(
              decimal: true,
              signed: false,
            ),
            inputFormatters: [
              LengthLimitingTextInputFormatter(6),
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,3}')),
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return null;
              }

              // Final validation check
              final regex = RegExp(r'^\d+(\.\d{1,3})?$');

              if (!regex.hasMatch(value)) {
                return "Enter valid amount (max 3 decimals (99.999))";
              }

              if (controller.selectedDelivery.value != "1") {
                final double amount = double.tryParse(value.toString()) ?? 0.0;

                if (amount <= 0) {
                  return "Amount must be greater than 0";
                }
              }

              return null;
            },
            prefix: Padding(
              padding: const EdgeInsets.only(left: 16.0,right: 0),
              child: Text('\$',style:AppFontStyle.text_18_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroySemiBold) ,),
            ),
          ),
          hBox(14.h),
        ],
        title('Average Preparation Time'),
        hBox(5.h),
        CustomDropDown(
            key: controller.preparationTimeKey,
            selectedValue: controller.selectedAvgPreFillTime.value,
            borderRadius: 14,
            btnHeight: 56,
            hintText: "15-20 minutes",
            items: const ['10-15 minutes','15-20 minutes','15-25 minutes','20-25 minutes','25-30 minutes','30+'],
            validator:(value) {
              if(controller.selectedAvgPreFillTime.value.isEmpty){
                return "Please select preparation time";
              }
              return null;
            } ,
            onChanged: (val){
              controller.selectedAvgPreFillTime.value = val ?? "";
            },
        ),
        hBox(12.h),
        title('Last Order Time'),
        hBox(5.h),
        CustomDropDown(
            key: controller.orderCutoffMinutesBeforeClosing,
            selectedValue: controller.selectedLastOrderTime.value,
            borderRadius: 14,
            btnHeight: 56,
          hintText: "15 min",
            items: const ['15 min','30 min','45 min','1 hour','2 hour'],
            validator:(value) {
              if(controller.selectedLastOrderTime.value.isEmpty){
                return "Please select last order time";
              }
              return null;
            } ,
            onChanged: (val){
              controller.selectedLastOrderTime.value = val ?? "";
            },
        ),

      ],
    );
  }

  CustomTextFormField deliveryFee() {
    return CustomTextFormField(
        readOnly: controller.selectedDelivery.value == "1" ? true : false,
        controller: controller.deliveryFeeController.value,
        hintText: "0.00",
        textInputType: const TextInputType.numberWithOptions(
          decimal: true,
          signed: false,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,3}')),
        ],
        validator: (value) {
          if (controller.selectedDelivery.value == "1") {
            return null;
          }

          // if (value == null || value.isEmpty) {
          //   return null;
          // }
          if (value == null || value.isEmpty) {
            return "Please enter delivery fee";
          }
          // Final validation check
          final regex = RegExp(r'^\d+(\.\d{1,3})?$');

          if (!regex.hasMatch(value)) {
            return "Enter valid amount (max 3 decimals (99.999))";
          }
          if (controller.selectedDelivery.value != "1") {
            final double amount = double.tryParse(value.toString()) ?? 0.0;

            if (amount <= 0) {
              return "Amount must be greater than 0";
            }
          }

          return null;
        },
        prefix: Padding(
          padding: const EdgeInsets.only(left: 16.0,right: 0),
          child: Text('\$',style:AppFontStyle.text_18_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroySemiBold) ,),
        ),
      );
  }

  Widget businessInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Business Information",
          style: AppFontStyle.customText(
            AppColors.darkText,
            20.sp,
            FontWeight.w600,
            fontFamily: AppFontFamily.gilroyMedium,
          ),
          maxLines: 2,
        ),
        hBox(14.h),
        title('Business License Number'),
        hBox(5.h),
        CustomTextFormField(
          key: controller.businessLicenseKey,
          hintText: "BL-2025-000000",
          controller: controller.businessLicenceController.value,
          validator: (value) {
            // if (value == null || value.trim().isEmpty) {
            //   return null;
            // }

            // final blRegex = RegExp(r'^BL-\d{4}-\d{6}$');
            //
            // if (!blRegex.hasMatch(value.trim())) {
            //   return "Enter valid format (BL-YYYY-XXXXXX)";
            // }

            return null;
          },
        ),
        hBox(14.h),
        title('Tax ID Number'),
        hBox(5.h),
        CustomTextFormField(
          key: controller.taxIDKey,
          controller: controller.taxIdController.value,
          hintText: "BL-2025-000000",
          validator: (value) {
            // if (value == null || value.trim().isEmpty) {
            //   return null;
            // }
            //
            // final blRegex = RegExp(r'^BL-\d{4}-\d{6}$');
            //
            // if (!blRegex.hasMatch(value.trim())) {
            //   return "Enter valid format (BL-YYYY-XXXXXX)";
            // }

            return null;
          },
        ),
        hBox(14.h),
        title('Established Date'),
        hBox(5.h),
        InkWell(
          onTap: () {
            pt(controller.establishController.value.text);
            controller.selectEstablishDate(context);
          },
          child: CustomTextFormField(
            controller: controller.establishController.value,
            readOnly: true,
            enabled: false,
            hintText: "15/03/2008",
            // validator: (value) {
            //   if (value == null || value.isEmpty) {
            //     return "Please select established date";
            //   }
            //   return null;
            // },
          ),
        ),
        hBox(14.h),
        title('Number of Employees'),
        hBox(5.h),
        SizedBox(
          height: 56,
          child: Obx(
                () => CustomDropDown(
                selectedValue: controller.selectedNumberOfEmployees.value,
                btnHeight: 56,
                borderRadius: 14,
                items: controller.employeeOptions,
                onChanged: (val) {
                  controller.selectedNumberOfEmployees.value = val ?? "";

                  // Debug print
                  pt("UI Display: ${controller.selectedNumberOfEmployees.value}");
                  pt("API Value: ${controller.getNumberOfEmployeesForApi()}");
                }
            ),
          ),
        )      ],
    );
  }

/*
  Widget restaurantLogo() {
    return Obx(() {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100.w,
            height: 100.w,
            child: DottedBorder(
              borderType: BorderType.RRect,
              radius: const Radius.circular(12),
              padding: EdgeInsets.all(6.w),
              dashPattern: const [4],
              color: controller.isLogoImageBorderRedClr.value &&
                  controller.logoImage.value == null &&
                  controller.profileApiData.value.vendor?.step == "1"
                  ? AppColors.errorColor
                  : AppColors.borderClr,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: controller.logoImage.value == null && controller.profileApiData.value.vendor?.logo == null
                    ? AppContainer(
                  color: AppColors.filledClr.withAlpha(150),
                )
                    : controller.profileApiData.value.vendor?.logo != null ?
                AppImage(path: controller.profileApiData.value.vendor?.logo ?? "",
                  fit: BoxFit.cover,
                  height: 100.w,
                  width: 100.w,
                ) :
                Image.file(
                  controller.logoImage.value  ?? File(controller.logoImage.value?.path ?? ""),
                  fit: BoxFit.cover,
                  height: 100.w,
                  width: 100.w,
                ),
              ),
            ),
          ),

          SizedBox(width: 14.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Upload your restaurant logo",
                style: AppFontStyle.text_14_400(
                  AppColors.greyClr,
                  fontFamily: AppFontFamily.gilroyMedium,
                ),
                ),
                SizedBox(height: 4.h),
                Text("Recommended: 200x200px, PNG or JPG",
                style: AppFontStyle.text_14_400(
                AppColors.greyClr,
                fontFamily: AppFontFamily.gilroyMedium,
                ),
                ),
                SizedBox(height: 10.h),
                CustomElevatedButton(
                  width: 140.w,
                  height: 40.h,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  color: AppColors.white,
                  borderSide: BorderSide(color: AppColors.borderClr),
                  borderRadius: BorderRadius.circular(8.r),

                  onPressed: () {
                    controller.pickImage(Get.context!, isLogo: true).then((_) {
                      controller.isLogoImageBorderRedClr.value = false;
                    });
                  },

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppImage(
                        path: ImageConstants.uploadImg,
                        svgColor: ColorFilter.mode(AppColors.blackClr, BlendMode.srcIn),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        "Choose File",
                        style: AppFontStyle.text_14_400(
                          AppColors.blackClr,
                          fontFamily: AppFontFamily.gilroyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
*/

  Widget restaurantLogo() {
    return Obx(() {
      bool isError = controller.isLogoImageBorderRedClr.value &&
          controller.logoImage.value == null &&
          controller.profileApiData.value.vendor?.logo == null &&
          controller.profileApiData.value.vendor?.step == "1";

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo Image Container
              Container(
                key: controller.logoImageKey, // Make sure this key is properly set
                child: SizedBox(
                  width: 100.w,
                  height: 100.w,
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(12),
                    padding: EdgeInsets.all(6.w),
                    dashPattern: const [4],
                    color: isError ? AppColors.errorColor : AppColors.borderClr,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: _buildLogoImage(),
                    ),
                  ),
                ),
              ),

              SizedBox(width: 14.w),

              // Logo Upload Info and Button
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Upload your restaurant logo",
                      style: AppFontStyle.text_14_400(
                        AppColors.greyClr,
                        fontFamily: AppFontFamily.gilroyMedium,
                      ),
                    ),
                    SizedBox(height: 4.h),

                    if (isError)
                      Text(
                        "Please upload your restaurant logo",
                        style: AppFontStyle.text_12_400(AppColors.errorColor),
                      ),

                    SizedBox(height: 4.h),

                    Text(
                      "Recommended: 200x200px, PNG or JPG",
                      style: AppFontStyle.text_14_400(
                        AppColors.greyClr,
                        fontFamily: AppFontFamily.gilroyMedium,
                      ),
                    ),

                    SizedBox(height: 10.h),

                    CustomElevatedButton(
                      width: 140.w,
                      height: 40.h,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      color: AppColors.white,
                      borderSide: BorderSide(color: AppColors.borderClr),
                      borderRadius: BorderRadius.circular(8.r),
                      onPressed: () {
                        controller.pickImage(Get.context!, isLogo: true).then((_) {
                          controller.isLogoImageBorderRedClr.value = false;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppImage(
                            path: ImageConstants.uploadImg,
                            svgColor: ColorFilter.mode(
                                AppColors.blackClr, BlendMode.srcIn),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            "Choose File",
                            style: AppFontStyle.text_14_400(
                              AppColors.blackClr,
                              fontFamily: AppFontFamily.gilroyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

// Helper method to build logo image
  Widget _buildLogoImage() {
    if (controller.logoImage.value != null) {
      return Image.file(
        controller.logoImage.value!,
        fit: BoxFit.cover,
        width: 100.w,
        height: 100.w,
      );
    } else if (controller.profileApiData.value.vendor?.logoUrl != null) {
      return AppImage(
        path: controller.profileApiData.value.vendor?.logoUrl ?? "",
        fit: BoxFit.cover,
        width: 100.w,
        height: 100.w,
      );
    } else {
      return AppContainer(
        color: AppColors.filledClr.withAlpha(150),
      );
    }
  }
  Text title(String title) {
    return Text(
      title,
      style: AppFontStyle.customText(
        AppColors.darkText,
        16.sp,
        FontWeight.w400,
        fontFamily: AppFontFamily.gilroySemiBold,
      ),
      maxLines: 2,
    );
  }

  addressFromGoogleAPI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Obx(() {
        //   if (controller.isValidAddress.value == false) {
        //     return  Padding(
        //       padding: REdgeInsets.only(left: 10),
        //       child: Text(
        //         'Please select a valid address',
        //         style: AppFontStyle.text_12_400(controller.isValidAddress.value  ? AppColors.darkText : AppColors.errorColor,fontFamily: AppFontFamily.gilroyMedium),
        //       ),
        //     );
        //   }else if(controller.locationController.text.isEmpty && controller.isAddressRedClr.value ){
        //     return  Padding(
        //       padding: REdgeInsets.only(left: 5),
        //       child: Text(
        //         'Enter your address',
        //         style:AppFontStyle.text_12_400( AppColors.errorColor, fontFamily: AppFontFamily.gilroyMedium),
        //       ),
        //     );
        //   }
        //   return const SizedBox.shrink();
        // }),
        hBox(16.h),
        title("Restaurant Address "),
        hBox(8.h),
        MapboxSearchField(
          key: controller.addressKey,
          controller: controller.locationController,
          validator: (value) {
            if (controller.isValidAddress.value == false) {
              return  'Please select a valid address';
            }else if(controller.locationController.text.isEmpty){
              return 'Enter your address';
            }
            return null;
          },
          onLocationSelected: (location) {
            // selectedLocation = location;
            controller.locationController.text = location;
          },
          onCoordinatesSelected: (lat, long) {
            controller.latitude.value = double.parse(lat ?? "");
            controller.longitude.value = double.parse(long ?? "");
            controller.isValidAddress.value = true;
            Text("Selected Location: ${controller.locationController.text}");
            Text("Latitude: ${controller.latitude.value}, Longitude: ${controller.longitude.value}");
          },
        ),
       /* AddressFromGoogleAPI(
          key: controller.addressKey,
          controller: controller.locationController,
          onChanged: (value) {
            // // controller.isSubmit.value = false;
            controller.isValidAddress.value = false;

            // debugPrint("SelectedLocation 1${controller.isValidAddress.value}");
            // addressSetController.house_noController.value.clear();
          },
          onTapOutSide: (event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          suggestionsCallback: (query) async {
            return await controller.searchAutocomplete(query);
          },
          itemBuilder: (context, Predictions suggestion) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text(
                    suggestion.description ?? "",
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Divider(
                  height: 0,
                ),
              ],
            );
          },
          onSelected: (Predictions selectedAddress) {
            controller.locationController.text = selectedAddress.description ?? "";
            controller.getLatLang(controller.locationController.text);
            controller.selectedLocation = controller.locationController.text;
            controller.isValidAddress.value = true;
            controller.searchPlace.clear();
            debugPrint("SelectedLocation :  ${controller.selectedLocation}");
            debugPrint("isValidAddress 2 : ${controller.isValidAddress}");
            return;
          },
          hintText: 'Address',

          validator: (value) {
            if (controller.isValidAddress.value == false) {
              return  'Please select a valid address';
            }else if(controller.locationController.text.isEmpty){
              return 'Enter your address';
            }
            return null;
          },
        ),*/
      ],
    );
  }

/*
  shopOpeningHoursBtn() {
    return Column(
      children: [
        ListView.separated(
          padding: EdgeInsets.only(top: 20.h),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      controller.days[index],
                      style: AppFontStyle.text_16_400(
                        AppColors.darkText,
                        fontFamily: AppFontFamily.gilroyMedium,
                      ),
                    ),
                    const Spacer(),
                    Obx(
                          () => AdvancedSwitch(
                        initialValue: controller.isToggleList[index].value,
                        width: 55.h,
                        controller:
                        ValueNotifier(controller.isToggleList[index].value),
                        inactiveColor: AppColors.hintText.withOpacity(0.7),
                        activeColor: AppColors.primary,
                        onChanged: (value) {
                          // controller.isSubmit.value = false;
                          controller.isToggleList[index].value = value;
                          // if (!value) {
                          //   controller.shopStartTimeControllers[index].clear();
                          //   controller.shopClosedTimeControllers[index].clear();
                          // }
                        },
                      ),
                    ),
                  ],
                ),
                Obx(
                      () => Padding(
                    padding: REdgeInsets.only(
                        left: 0,
                        top: controller.isToggleList[index].value ? 20 : 0,
                        bottom: 8),
                    child: Column(
                      children: [
                        if (controller.isToggleList[index].value) ...[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: CustomTimePickerField1(
                                  key: controller.shopStartTimeKey[index],
                                  // initialTimes:getTimeOfDayFromController( controller.shopStartTimeControllers[index]) ,
                                  timeController: controller
                                      .shopStartTimeControllers[index],
                                  onChanged: (value) {
                                    // controller.isSubmit.value = false;
                                  },
                                  borderColor: AppColors.textFieldBorder,
                                  validator: (value) {
                                    if (controller.isToggleList[index].value) {
                                      if (controller.shopStartTimeControllers[index].text.isEmpty) {
                                        return "Please select start time";
                                      }
                                      return null;
                                    }
                                    return null;
                                  },
                                  prefixIcon: Padding(
                                    padding:
                                    REdgeInsets.only(left: 15.0, right: 10),
                                    child: Text(
                                      "Start",
                                      style: AppFontStyle.text_16_400(
                                        AppColors.hintText,
                                        fontFamily: AppFontFamily.gilroyRegular,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              wBox(16.w),
                              Expanded(
                                child: CustomTimePickerField1(
                                  key: controller.shopClosedTimeKey[index],
                                  // initialTimes: getTimeOfDayFromController( controller.shopClosedTimeControllers[index]),
                                  timeController: controller.shopClosedTimeControllers[index],
                                  onChanged: (value) {
                                    // controller.isSubmit.value = false;
                                  },
                                  borderColor: AppColors.textFieldBorder,
                                  validator: (value) {
                                    if (controller.isToggleList[index].value) {
                                      if (controller.shopClosedTimeControllers[index].text.isEmpty) {
                                        return "Please select close time";
                                      }
                                      // DateTime parseTime1 = DateFormat('hh:mm a')
                                      controller.parseTime1 = DateFormat('hh:mm a').parse(controller.shopStartTimeControllers[index].value.text != ''
                                          ? controller.shopStartTimeControllers[index].value.text : "00:00 AM");
                                      controller.parseTime2 = DateFormat('hh:mm a').parse(controller.shopClosedTimeControllers[index].value.text !=''
                                          ? controller.shopClosedTimeControllers[index].value.text: "00:00 AM");
                                      if (controller.parseTime1.isAfter(controller.parseTime2)) {
                                        return "Invalid close time";
                                      }
                                      if (controller.shopStartTimeControllers[index].value.text == controller.shopClosedTimeControllers[index].value.text) {
                                        return "Invalid close time";
                                      }
                                      return null;
                                    }
                                    return null;
                                  },
                                  prefixIcon: Padding(
                                    padding:
                                    REdgeInsets.only(left: 15.0, right: 10),
                                    child: Text(
                                      "Closed",
                                      style: AppFontStyle.text_16_400(
                                        AppColors.hintText,
                                        fontFamily: AppFontFamily.gilroyRegular,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                        hBox(8.h),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
          separatorBuilder: (context, index) => hBox(10.h),
          itemCount: controller.days.length,
        ),
      ],
    );
  }
*/

  CustomTextFormField shopDescriptionField() {
    return CustomTextFormField(
      key: controller.descriptionKey,
      textInputType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      maxLength: 1000,
      controller: controller.shopDescriptionController.value,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Please enter description";
        }
        if (value.trim().length < 20) {
          return "Description must contain at least 50 characters";
        }
        return null;
      },
      buildCounter: (context, {required currentLength, required isFocused, required maxLength}) {
        int actualLength = controller.shopDescriptionController.value.text.trim().length;
        return Text('$actualLength/$maxLength');
      },
      maxLines: 4,
      minLines: 4,
      hintText: 'Restaurant Description',
    );
  }

  CustomTextFormField shopNameField() {
    return CustomTextFormField(
      key: controller.shopNameKey,
      controller: controller.ownerNameController.value,
      // errorTextStyle: AppFontStyle.text_12_400(
      //   controller.isRedClr.value ? AppColors.red :AppColors.darkText,
      //   fontFamily: AppFontFamily.gilroyMedium,
      // ),
      onTap: (){
        // controller.isSubmit.value = false;
      },
      validator: (value) {
        if(value == null || value.isEmpty){
          // if(controller.isSubmit.value){
          //   controller.scrollToField(controller.shopNameKey);
          // }
          return "Please enter shop name";
        }
        return null;

      },
      hintText: 'Shop Name',
    );
  }

  Widget selectedDelivery() {
    return Obx(
          ()=> CustomDropDownApi(
        key: controller.selectedDeliveryKey,
        btnHeight: 55.h,
        hintText: "Select Delivery",
        borderColor: AppColors.textFieldBorder,
        hintStyle: AppFontStyle.text_15_500(AppColors.hintText,fontFamily: AppFontFamily.gilroyMedium),
        textStyle: AppFontStyle.text_16_400(AppColors.darkText, fontFamily: AppFontFamily.gilroyRegular),
        items: selectedDeliveryItems,
        selectedValue: controller.selectedDelivery.value,
        // labelText: "Select Delivery",
        onChanged: (value){
          if(value != null) {
            controller.selectedDelivery.value = value;
            if(value == "1"){
              controller.deliveryFeeController.value.text = "0";
              controller.minimumOrderForFreeDeliveryController.value.text = "";
            }
            if(value == "0"){
              controller.deliveryFeeController.value.text = "";
              controller.minimumOrderForFreeDeliveryController.value.text = controller.apiMinOrderAmount.isNotEmpty ? controller.apiMinOrderAmount.value  : "";
            }
            pt("selected delivery>>>>>>>>>>>> $value");
          }
        },
        validator: (value) {
          if(value?.isEmpty ??  true){
            return "Please select your delivery type";
          }
          return null;
        },
      ),
    );
  }


  saveButton() {
    return Obx(
          () => CustomElevatedButton(
        height: 56,
        isLoading: controller.rxUpdateProfileRequestStatus.value == ApiStatus.LOADING,
/*
        onPressed: () {
          debugImageStatus();
          if (controller.locationController.value.text.isEmpty) {
            controller.isValidAddress.value = false;
          }

          if (controller.userModel.step != 3) {
            controller.isImageBorderRedClr.value = true;
          }


          // ---------- FORM VALID ----------
          if ((controller.shopDetailsKey.currentState?.validate() ?? false)) {

            bool conditionStep1 = (
                controller.profileApiData.value.vendor?.step == "1" &&
                    (controller.coverImage.value != null && controller.coverImage.value!.path.isNotEmpty) &&
                    (controller.logoImage.value != null && controller.logoImage.value!.path.isNotEmpty) &&
                    controller.isValidAddress.value != false
            );
            bool conditionStep3 = (
                controller.userModel.step == 3 && controller.isValidAddress.value != false &&
                    controller.coverImage.value?.path != null && controller.profileApiData.value.vendor?.coverPhotoUrl != null
                    && controller.logoImage.value?.path != null && controller.profileApiData.value.vendor?.logoUrl != null
            );


            if (conditionStep1 || conditionStep3) {
              pt(" CALL API HERE");
              controller.updateProfileDetailsApi();

              return;
            }
          }

          // ---------- MANUAL FOCUS VALIDATIONS BELOW ----------

          if (controller.restaurantNameController.value.text.isEmpty) {
            controller.scrollToField(controller.restaurantNameKey);
            pt("restaurantNameController");
          }

          else if (controller.ownerNameController.value.text.isEmpty ||
              controller.ownerNameController.value.text.length < 3) {
            controller.scrollToField(controller.ownerNameKey);
            pt("ownerNameKey");

          }

          else if (controller.shopDescriptionController.value.text.isEmpty ||
              controller.shopDescriptionController.value.text.length < 20) {
            controller.scrollToField(controller.descriptionKey);
            pt("descriptionKey");

          }

          else if (controller.mobNoCon.value.text.isEmpty ||
              controller.mobNoCon.value.text.length != controller.checkCountryLength.value) {
            controller.scrollToField(controller.phoneKey);
            pt("phoneKey");

          }

          else if (controller.websiteController.value.text.isNotEmpty &&
              !RegExp(r"^(https?://)?(www\.)?[a-zA-Z0-9\-]+\.[a-zA-Z]{2,}(/.*)?$")
                  .hasMatch(controller.websiteController.value.text.trim())) {

            controller.scrollToField(controller.websiteKey);
          }

          else if (controller.isValidAddress.value == false ||
              controller.locationController.value.text.isEmpty) {

            controller.scrollToField(controller.addressKey, alignment: 0.05);
          }else if (controller.logoImage.value == null &&controller.profileApiData.value.vendor?.logo == null) {
          controller.isLogoImageBorderRedClr.value = true;
          controller.scrollToField(controller.logoImageKey, alignment: 0.074);
          pt("logoImageKey");
          }else if (controller.userModel.step == 3 &&(controller.coverImage.value?.path.isEmpty ?? true)) {
              controller.scrollToField(controller.coverImageKey, alignment: 0.074);
              pt("coverImageKey");
              return;
            }
        },
*/

            onPressed: () {
              // Reset validations
              if (controller.locationController.value.text.isEmpty) {
                controller.isValidAddress.value = false;
              }

              // Step 1 ke liye hi image validation strict hai
              if (controller.userModel.step == 1) {
                controller.isImageBorderRedClr.value = true;
                controller.isLogoImageBorderRedClr.value = true;
              }

              // ---------- FORM VALID ----------
              if ((controller.shopDetailsKey.currentState?.validate() ?? false)) {

                bool hasLogoImage = controller.logoImage.value != null ||
                    (controller.profileApiData.value.vendor?.logo != null &&
                        controller.profileApiData.value.vendor!.logo!.isNotEmpty);

                bool hasCoverImage = controller.coverImage.value != null ||
                    (controller.profileApiData.value.vendor?.coverPhoto != null &&
                        controller.profileApiData.value.vendor!.coverPhoto!.isNotEmpty);

                pt("🔍 Validation Check:");
                pt("Step: ${controller.userModel.step}");
                pt("Has Logo: $hasLogoImage (API: ${controller.profileApiData.value.vendor?.logo}, New: ${controller.logoImage.value?.path})");
                pt("Has Cover: $hasCoverImage (API: ${controller.profileApiData.value.vendor?.coverPhoto}, New: ${controller.coverImage.value?.path})");
                pt("Valid Address: ${controller.isValidAddress.value}");

                bool conditionStep1 = (
                    controller.userModel.step == 1 &&
                        hasCoverImage &&
                        hasLogoImage &&
                        controller.isValidAddress.value != false
                );

                bool conditionStep3 = (
                    controller.userModel.step == 3 &&
                        controller.isValidAddress.value != false
                    // Step 3 mein images optional hain, API images already hain
                );

                pt("Condition Step 1: $conditionStep1");
                pt("Condition Step 3: $conditionStep3");

                if (conditionStep1 || conditionStep3) {
                  pt("✅ CALL API HERE - All validations passed");
                  controller.updateProfileDetailsApi();
                  return;
                }
              }

              // ---------- MANUAL FOCUS VALIDATIONS BELOW ----------

              if (controller.restaurantNameController.value.text.isEmpty) {
                controller.scrollToField(controller.restaurantNameKey);
                pt("❌ restaurantNameController");
              }
              else if (controller.ownerNameController.value.text.isEmpty ||
                  controller.ownerNameController.value.text.length < 3) {
                controller.scrollToField(controller.ownerNameKey);
                pt("❌ ownerNameKey");
              }
              else if (controller.shopDescriptionController.value.text.isEmpty ||
                  controller.shopDescriptionController.value.text.length < 20) {
                controller.scrollToField(controller.descriptionKey);
                pt("❌ descriptionKey");
              }
              else if (controller.mobNoCon.value.text.isEmpty ||
                  controller.mobNoCon.value.text.length != controller.checkCountryLength.value) {
                controller.scrollToField(controller.phoneKey);
                pt("❌ phoneKey");
              }
              else if (controller.websiteController.value.text.isNotEmpty &&
                  !RegExp(r"^(https?://)?(www\.)?[a-zA-Z0-9\-]+\.[a-zA-Z]{2,}(/.*)?$")
                      .hasMatch(controller.websiteController.value.text.trim())) {
                controller.scrollToField(controller.websiteKey);
                pt("❌ websiteKey");
              }
              else if (controller.isValidAddress.value == false ||
                  controller.locationController.value.text.isEmpty) {
                controller.scrollToField(controller.addressKey, alignment: 0.05);
                pt("❌ addressKey");
              } else if (controller.deliveryRadiusController.value.text.isEmpty ||  !RegExp(r'^\d+(\.\d{1,3})?$').hasMatch(controller.deliveryRadiusController.value.text) ||
                  (double.tryParse(controller.deliveryRadiusController.value.text) ?? 0) <= 0) {
                controller.scrollToField(controller.deliveryRadiusKey, alignment: 0.052);
                pt("❌ deliveryRadiusKey");
              }else if (controller.minimumOrderController.value.text.isNotEmpty && !RegExp(r'^\d+(\.\d{1,3})?$').hasMatch(controller.minimumOrderController.value.text)) {
                controller.scrollToField(controller.minimumOrderKey, alignment: 0.05);
                pt("❌ minimumOrderKey");
              }else if (controller.deliveryFeeController.value.text.isNotEmpty && !RegExp(r'^\d+(\.\d{1,3})?$').hasMatch(controller.deliveryFeeController.value.text)) {
                controller.scrollToField(controller.deliveryFeeKey, alignment: 0.05);
                pt("❌ deliveryFeeKey");
              }else if (controller.minimumOrderForFreeDeliveryController.value.text.isEmpty || !RegExp(r'^\d+(\.\d{1,3})?$').hasMatch(controller.minimumOrderForFreeDeliveryController.value.text)) {
                controller.scrollToField(controller.minimumOrderForFreeDeliveryKey, alignment: 0.05);
                pt("❌ minimumOrderForFreeDeliveryKey");
              }else if (controller.selectedAvgPreFillTime.value.isEmpty) {
                controller.scrollToField(controller.preparationTimeKey, alignment: 0.05);
                pt("❌ preparationTimeKey");
              }
              else if (controller.selectedLastOrderTime.value.isEmpty) {
                controller.scrollToField(controller.orderCutoffMinutesBeforeClosing, alignment: 0.05);
                pt("❌ minimumOrderForFreeDeliveryController");
              }

              // else if (controller.businessLicenceController.value.text.isNotEmpty && !RegExp(r'^BL-\d{4}-\d{6}$').hasMatch(controller.businessLicenceController.value.text)) {
              //   controller.scrollToField(controller.businessLicenseKey, alignment: 0.05);
              //   pt("❌ businessLicenseKey");
              // } else if (controller.taxIdController.value.text.isNotEmpty && !RegExp(r'^BL-\d{4}-\d{6}$').hasMatch(controller.taxIdController.value.text)) {
              //   controller.scrollToField(controller.taxIDKey, alignment: 0.05);
              //   pt("❌ taxIDKey");
              // }

              else if (controller.facebookController.value.text.isNotEmpty && validateSocialUrl(controller.facebookController.value.text, "Facebook") != null) {
                controller.scrollToField(controller.facebookKey, alignment: 0.05);
                pt("❌ facebookKey");
              }else if (controller.instagramController.value.text.isNotEmpty && validateSocialUrl(controller.instagramController.value.text, "Instagram") != null) {
                controller.scrollToField(controller.instagramKey, alignment: 0.05);
                pt("❌ instagramKey");
              }else if (controller.twitterController.value.text.isNotEmpty && validateSocialUrl(controller.twitterController.value.text, "Twitter") != null) {
                controller.scrollToField(controller.twitterKey, alignment: 0.05);
                pt("❌ twitterKey");
              }else if (controller.youtubeController.value.text.isNotEmpty && validateSocialUrl(controller.youtubeController.value.text, "YouTube") != null) {
                controller.scrollToField(controller.youtubeKey, alignment: 0.05);
                pt("❌ youtubeKey");
              }
              // Step 1 ke liye hi image validation karein
              else if (controller.userModel.step == 1 &&
                  (controller.logoImage.value == null &&
                      (controller.profileApiData.value.vendor?.logo == null ||
                          controller.profileApiData.value.vendor!.logo!.isEmpty))) {
                controller.isLogoImageBorderRedClr.value = true;
                controller.scrollToField(controller.logoImageKey, alignment: 0.074);
                pt("❌ logoImageKey - Required for step 1");
              }
              else if (controller.userModel.step == 1 &&
                  (controller.coverImage.value == null &&
                      (controller.profileApiData.value.vendor?.coverPhoto == null ||
                          controller.profileApiData.value.vendor!.coverPhoto!.isEmpty))) {
                controller.isImageBorderRedClr.value = true;
                controller.scrollToField(controller.coverImageKey, alignment: 0.074);
                pt("❌ coverImageKey - Required for step 1");
              }
              else {
                pt("❌ Unknown validation error - All checks passed but API not called");
                debugImageStatus();
              }
            },
            text: controller.userModel.step == 3 ? "Save Changes" : "Continue",
      ),
    );
  }

  void debugImageStatus() {
    print("🔍 Image Status Debug:");
    print("Step: ${controller.userModel.step}");
    print("Cover Image from API: ${controller.profileApiData.value.vendor?.coverPhoto}");
    print("New Cover Image: ${controller.coverImage.value?.path}");
    print("Logo from API: ${controller.profileApiData.value.vendor?.logo}");
    print("New Logo Image: ${controller.logoImage.value?.path}");
    print("Has Cover Image: ${controller.coverImage.value != null || controller.profileApiData.value.vendor?.coverPhoto != null}");
    print("Has Logo Image: ${controller.logoImage.value != null || controller.profileApiData.value.vendor?.logo != null}");
  }
  /*
  saveButton() {
    return Obx(
          () => CustomElevatedButton(
            height: 56,
        isLoading:
        controller.rxUpdateProfileRequestStatus.value == ApiStatus.LOADING,
        onPressed: () {
          // controller.isRedClr.value = true;
          // debugPrint("controller.isValidAddress.value : "+controller.isValidAddress.value.toString());
          // if (controller.isValidAddress.value) {
          //   controller.isAddressRedClr.value = false;
          // }
          if(controller.locationController.value.text.isEmpty){
            controller.isValidAddress.value = false;
          }
          // controller.isSubmit.value = true;

          if (controller.userModel.step != 3) {
            controller.isImageBorderRedClr.value = true;
          }
          if ((controller.shopDetailsKey.currentState?.validate() ?? false)) {

            if ((controller.shopDetailsKey.currentState?.validate() ?? false) &&
                controller.profileApiData.value.vendor?.step == "1" &&
                (controller.image.value?.path.isNotEmpty ?? false) &&
                controller.isValidAddress.value != false ||
                controller.userModel.step == 3 &&
                    controller.isValidAddress.value != false) {
              // controller.updateProfileDetailsApi(
                // firstName: controller.restaurantNameController.value.text,
                // lastName: controller.ownerNameController.value.text,
                // personalEmailAddress:
                // controller.personalEmailController.value.text,
                // countryCode: controller.countryCode.toString(),
                // phoneNumber: controller.mobNoCon.value.text,
                // image: controller.imageBase64.value,
                // restaurantName: controller.locationController.value.text,
                // restaurantDescription:
                // controller.shopDescriptionController.value.text,
                // shopAddress: controller.locationController.text,
                // startTime: controller.shopStartTimeControllers,
                // closeTime: controller.shopClosedTimeControllers,
              // );
            }
          } else if (controller.restaurantNameController.value.text == "" ||
              controller.restaurantNameController.value.text.isEmpty) {
            controller.scrollToField(controller.restaurantNameKey);
          } else if (controller.ownerNameController.value.text == "" ||
              controller.ownerNameController.value.text.isEmpty ||
              controller.ownerNameController.value.text.length < 3) {
            controller.scrollToField(controller.ownerNameKey);
          } else if (controller.shopDescriptionController.value.text == "" ||
              controller.shopDescriptionController.value.text.isEmpty ||
              controller.shopDescriptionController.value.text.length < 20) {
            controller.scrollToField(controller.descriptionKey);
          } else if (controller.mobNoCon.value.text == "" || controller.mobNoCon.value.text.isEmpty ||
              controller.mobNoCon.value.text.length != controller.checkCountryLength.value) {
            controller.scrollToField(controller.phoneKey);
          }else if (controller.websiteController.value.text.isNotEmpty &&
              !RegExp(r"^(https?://)?(www\.)?[a-zA-Z0-9\-]+\.[a-zA-Z]{2,}(/.*)?$")
                  .hasMatch(controller.websiteController.value.text.trim())) {
            controller.scrollToField(controller.websiteKey);
            return;
          }else if (controller.isValidAddress.value == false || controller.locationController.value.text.isEmpty
          // ||controller.isAddressRedClr.value
          ) {
            controller.scrollToField(controller.addressKey, alignment: 0.05);
          } else {
            if (controller.userModel.step != 3 && (controller.image.value?.path.isEmpty ?? true)) {
              controller.scrollToField(controller.coverImageKey, alignment: 0.025);
            } */
/*else if (controller.shopNameController.value.text == "" ||
                controller.shopNameController.value.text.isEmpty) {
              controller.scrollToField(controller.shopNameKey);
            }*//*
 */
/*else if (controller.selectedDelivery.value.isEmpty) {
              controller.scrollToField(controller.selectedDeliveryKey, alignment: 0.01);
            } else {
              for (int i = 0; i < controller.days.length; i++) {
                if (controller.shopStartTimeControllers[i].value.text == '' &&
                    controller.isToggleList[i].value ||
                    controller.shopStartTimeControllers[i].value.text.isEmpty &&
                        controller.isToggleList[i].value ||
                    controller.shopStartTimeControllers[i].value.text ==
                        controller.shopClosedTimeControllers[i].value.text ||
                    controller.parseTime1.isAfter(controller.parseTime2)) {
                  controller.scrollToField(controller.shopStartTimeKey[i],
                      alignment: 0.09);
                  return;
                }
                if (controller.shopClosedTimeControllers[i].value.text == '' &&
                    controller.isToggleList[i].value ||
                    controller
                        .shopClosedTimeControllers[i].value.text.isEmpty &&
                        controller.isToggleList[i].value ||
                    controller.shopStartTimeControllers[i].value.text ==
                        controller.shopClosedTimeControllers[i].value.text ||
                    controller.parseTime1.isAfter(controller.parseTime2)) {
                  controller.scrollToField(controller.shopClosedTimeKey[i],
                      alignment: 0.09);
                  return;
                }
              }
            }*//*

          }
        },
        text: controller.userModel.step == 3 ? "Save Changes" : "Continue",
      ),
    );
  }
*/

  Widget profileDetails() {
    return Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title('Restaurant Name'),
          hBox(5.h),
          CustomTextFormField(
              key: controller.restaurantNameKey,
              controller: controller.restaurantNameController.value,
              hintText: "Restaurant Name",
              validator: (value) {
                if (value!.isEmpty || value == "") {
                  return "Please enter restaurant name";
                }else if(value.length < 3){
                  return "Please enter a valid restaurant name";
                }
                return null;
              },
             ),
          hBox(16.h),
          title("Owner Name"),
          hBox(5.h),
          Obx(
                ()=> CustomTextFormField(
                key: controller.ownerNameKey,
                controller: controller.ownerNameController.value,
                hintText: "Owner Name",
                validator: (value) {
                  if (value!.isEmpty || value == "") {
                    return "Please enter owner name";
                  }else if(value.length <3){
                    return "Owner name must be at least 3 characters long";
                  }else if(!isValidCharacters(value)){
                    return "Please enter a valid owner name";
                  }
                  return null;
                },
                ),
          ),
          hBox(16.h),
          title("Restaurant Description"),
          hBox(5.h),
          shopDescriptionField(),
          title("Phone Number"),
          hBox(5.h),
          Obx(() =>
              CustomTextFormField(
                key: controller.phoneKey,
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
                        initialSelection: controller.countryCode.toString(),
                      ),
                    const Icon(Icons.keyboard_arrow_down_rounded),

                    wBox(5),
                  ],
                ),
                hintText: "Phone Number",
                textInputType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    // if(controller.isSubmit.value){
                    //   controller.scrollToField(controller.phoneKey);
                    // }
                    return 'Please enter your phone number';
                  }
                  if (value.length != controller.checkCountryLength.value) {
                    // if(controller.isSubmit.value){
                    //   controller.scrollToField(controller.phoneKey);
                    // }
                    return 'Please enter a valid phone number (${controller.checkCountryLength.value} digits\nrequired)';
                  }
                  return null;
                },

                autoValidateMode: AutovalidateMode.onUserInteraction,
              ),
          ),
          hBox(16.h),
          title("Email Address"),
          hBox(5.h),
          CustomTextFormField(
              enabled: false,
              controller: controller.personalEmailController.value,
              contentPadding:
              REdgeInsets.symmetric(horizontal: 20, vertical: 18),
              hintText: "yourname@gmail.com",
              textInputType: TextInputType.emailAddress,
              validator: (value) {
                if (value!.isEmpty ||
                    !isValidEmail(value, isRequired: true) ||
                    value == "") {
                  return "Please enter a valid Email";
                }

                return null;
              },
              ),

          hBox(16.h),
          title("Website"),
          hBox(5.h),
          CustomTextFormField(
            key: controller.websiteKey,
              controller: controller.websiteController.value,
              contentPadding:
              REdgeInsets.symmetric(horizontal: 20, vertical: 18),
              hintText: "www.example.com",
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return null; // ❗ Not required → No validation
              }

              // Trim input
              value = value.trim();

              // Valid website formats:
              const urlPattern =
                  r'^(https?:\/\/)?(www\.)?[a-zA-Z0-9\-]+\.[a-zA-Z]{2,}(\/.*)?$';
              final regex = RegExp(urlPattern);

              if (!regex.hasMatch(value)) {
                return "Please enter valid website URL";
              }

              return null;
            },
              ),
          hBox(4.h),
        ],
      ),
    );
  }


  GetBuilder<FillRestaurantDetailsController> _profileImagePicker(
      BuildContext contexts) {
    return GetBuilder(
      init: controller,
      builder: (context) {
        return Obx(
              () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DottedBorder(
                borderType: BorderType.RRect,
                radius: const Radius.circular(12),
                padding: const EdgeInsets.all(6),
                dashPattern: const [4],
                color: controller.isImageBorderRedClr.value &&
                    controller.coverImage.value?.path == null &&
                    controller.profileApiData.value.vendor?.step == "1"
                    ? AppColors.errorColor
                    : AppColors.primary.withOpacity(0.5),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  child: Center(
                    child: Obx(
                          () => SizedBox(
                            key: controller.coverImageKey,
                        height: 190,
                        width: Get.width,
                        child: controller.coverImage.value != null
                            ? Image.file(
                          controller.coverImage.value!,
                          fit: BoxFit.fill,
                        )
                            : controller.profileApiData.value.vendor?.step != "1"
                            ? controller.profileApiData.value.vendor?.coverPhotoUrl != null
                            ? CachedNetworkImage(
                          imageUrl: controller.profileApiData.value.vendor?.coverPhotoUrl.toString() ?? "",
                          fit: BoxFit.fill,
                          errorWidget: (context, url, error) =>
                              Icon(
                                Icons.error_outline,
                                color: AppColors.red,
                              ),
                          placeholder: (context, url) =>
                              Shimmer.fromColors(
                                baseColor:
                                AppColors.textFieldBorder,
                                highlightColor:
                                AppColors.lightText,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.grey,
                                    borderRadius:
                                    BorderRadius.circular(20.r),
                                  ),
                                ),
                              ),
                        )
                            : AppContainer(
                          color:
                          AppColors.filledClr.withAlpha(150),
                        )
                            : AppContainer(
                          color: AppColors.filledClr.withAlpha(150),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              /// Error message
              if (controller.isImageBorderRedClr.value &&
                  controller.coverImage.value?.path == null &&
                  controller.profileApiData.value.vendor?.step == "1") ...[
                hBox(8.h),
                Padding(
                  padding: REdgeInsets.only(left: 8.0),
                  child: Text(
                    "Please select image",
                    style: AppFontStyle.text_12_200(
                      AppColors.errorColor,
                      fontFamily: AppFontFamily.gilroyMedium,
                    ),
                  ),
                ),
              ],

              hBox(14),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Upload cover photo",
                    maxLines: 2,
                    style: AppFontStyle.text_14_400(
                      AppColors.greyClr,
                      fontFamily: AppFontFamily.gilroyMedium,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "Recommended: 1200x600px, JPG or PNG",
                    maxLines: 1,
                    style: AppFontStyle.text_14_400(
                      AppColors.greyClr,
                      fontFamily: AppFontFamily.gilroyMedium,
                    ),
                  ),
                  SizedBox(height: 10.h),

                  CustomElevatedButton(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    color: AppColors.white,
                    borderSide: BorderSide(color: AppColors.borderClr),
                    width: 140.w,
                    height: 40.h,
                    borderRadius: BorderRadius.circular(8.r),
                    onPressed: () {
                      controller
                          .pickImage(contexts, isLogo: false)
                          .then((_) {
                        controller.isImageBorderRedClr.value = false;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppImage(
                          path: ImageConstants.uploadImg,
                          svgColor: ColorFilter.mode(
                            AppColors.blackClr,
                            BlendMode.srcIn,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          "Choose File",
                          style: AppFontStyle.text_14_400(
                            AppColors.blackClr,
                            fontFamily: AppFontFamily.gilroyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

 /* GetBuilder<FillRestaurantDetailsController> _profileImagePicker(
      BuildContext contexts) {
    return GetBuilder(
      init: controller,
      builder: (context) {
        return Obx(()=>
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 DottedBorder(
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(12),
                  padding: const EdgeInsets.all(6),
                  dashPattern: const [4],
                  color: controller.isImageBorderRedClr.value && controller.image.value?.path == null && controller.profileApiData.value.vendor?.step == "1"  ?
                  AppColors.errorColor :
                  AppColors.primary.withOpacity(0.5),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    child: Center(
                      child: Obx(
                            () => SizedBox(
                          key:controller.imageKey,
                          height: 190,
                          width: Get.width,
                          child: controller.image.value != null
                              ? Image.file(

                            controller.image.value!,
                            fit: BoxFit.fill,
                          )
                              : controller.profileApiData.value.vendor?.step != "1" ?
                          controller.profileApiData.value.vendor?.coverPhoto != null
                              ? CachedNetworkImage(
                            imageUrl: controller.profileApiData.value.vendor!.coverPhoto.toString(),
                            fit: BoxFit.fill,
                            errorWidget: (context, url, error) => Icon(
                              Icons.error_outline,
                              color: AppColors.red,
                            ),
                            placeholder: (context, url) =>
                                Shimmer.fromColors(
                                  baseColor: AppColors.textFieldBorder,
                                  highlightColor: AppColors.lightText,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.grey,
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                  ),
                                ),
                          )
                              : AppContainer(
                            color: AppColors.filledClr.withAlpha(150),
                          )
                              :
                          AppContainer(
                            color: AppColors.filledClr.withAlpha(150),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if( controller.isImageBorderRedClr.value && controller.image.value?.path == null && controller.profileApiData.value.vendor?.step == "1") ...[
                  hBox(8.h),
                  Padding(
                    padding: REdgeInsets.only(left: 8.0),
                    child: Text("Please select image", style: AppFontStyle.text_12_200(AppColors.errorColor, fontFamily: AppFontFamily.gilroyMedium),),
                  ),
                ],
                hBox(14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Upload cover photo",
                      maxLines: 2,
                      style: AppFontStyle.text_14_400(
                        AppColors.greyClr,
                        fontFamily: AppFontFamily.gilroyMedium,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "Recommended: 1200x600px, JPG or PNG",
                      maxLines: 1,
                      style: AppFontStyle.text_14_400(
                        AppColors.greyClr,
                        fontFamily: AppFontFamily.gilroyMedium,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    CustomElevatedButton(
                      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                      color: AppColors.white,
                      borderSide: BorderSide(color: AppColors.borderClr),
                      width: 140.w,
                      height: 40.h,
                      borderRadius: BorderRadius.circular(8.r),
                      onPressed: () {
                        controller.pickImage(contexts,isLogo: false).then((val){
                          controller.isImageBorderRedClr.value = false;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppImage(
                            path: ImageConstants.uploadImg,
                            svgColor:
                            ColorFilter.mode(AppColors.blackClr, BlendMode.srcIn),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            "Choose File",
                            style: AppFontStyle.text_14_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroyMedium),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
        );
      },
    );
  }*/

  @override
  void dispose() {
    // for (var controller in controller.shopStartTimeControllers) {
    //   controller.clear();
    //   // controller.dispose();
    // }
    // for (var controller in controller.shopClosedTimeControllers) {
    //   controller.clear();
    //   // controller.dispose();
    // }
    // for (var isToggle in controller.isToggleList) {
    //   isToggle.value = false;
    // }
    // controller.mobNoCon.value.cl();
    super.dispose();
  }

  Widget buildRestaurantInformationShimmer() {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Bar Area
            Container(height: 75, color: Colors.white),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerBox(width: 200, height: 24, radius: 4),
                      SizedBox(height: 8),
                      ShimmerBox(width: 300, height: 16, radius: 4),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Basic Details Section
                  const ShimmerBox(width: 250, height: 20, radius: 4),
                  const SizedBox(height: 20),

                  // Profile Details Fields
                  ...List.generate(6, (index) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      const ShimmerBox(width: 150, height: 16, radius: 4),
                      const SizedBox(height: 5),
                      const ShimmerBox(width: double.infinity, height: 56, radius: 14),
                      if (index < 5) const SizedBox(height: 16),
                    ],
                  )),

                  const Divider(height: 46),

                  // Address & Visual Assets
                  const ShimmerBox(width: 250, height: 20, radius: 4),
                  const SizedBox(height: 14),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerBox(width: 150, height: 16, radius: 4),
                      SizedBox(height: 8),
                      ShimmerBox(width: double.infinity, height: 56, radius: 14),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Restaurant Logo
                  const ShimmerBox(width: 150, height: 16, radius: 4),
                  const SizedBox(height: 6),
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerBox(width: 100, height: 100, radius: 12),
                      SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShimmerBox(width: 200, height: 14, radius: 4),
                            SizedBox(height: 4),
                            ShimmerBox(width: 250, height: 14, radius: 4),
                            SizedBox(height: 10),
                            ShimmerBox(width: 140, height: 40, radius: 8),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Cover Photo
                  const ShimmerBox(width: 150, height: 16, radius: 4),
                  const SizedBox(height: 6),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerBox(width: double.infinity, height: 190, radius: 12),
                      SizedBox(height: 14),
                      ShimmerBox(width: 150, height: 14, radius: 4),
                      SizedBox(height: 4),
                      ShimmerBox(width: 200, height: 14, radius: 4),
                      SizedBox(height: 10),
                      ShimmerBox(width: 140, height: 40, radius: 8),
                    ],
                  ),
                  const SizedBox(height: 30),

                  const Divider(height: 46),

                  // Business Information
                  const ShimmerBox(width: 250, height: 20, radius: 4),
                  const SizedBox(height: 14),
                  ...List.generate(5, (index) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      const ShimmerBox(width: 150, height: 16, radius: 4),
                      const SizedBox(height: 5),
                      const ShimmerBox(width: double.infinity, height: 56, radius: 14),
                      if (index < 4) const SizedBox(height: 14),
                    ],
                  )),

                  const Divider(height: 46),

                  // Social Media
                  const ShimmerBox(width: 250, height: 20, radius: 4),
                  const SizedBox(height: 14),
                  ...List.generate(4, (index) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      const ShimmerBox(width: 150, height: 16, radius: 4),
                      const SizedBox(height: 5),
                      const ShimmerBox(width: double.infinity, height: 56, radius: 14),
                      if (index < 3) const SizedBox(height: 14),
                    ],
                  )),

                  const Divider(height: 46),

                  // Delivery Information
                  const ShimmerBox(width: 250, height: 20, radius: 4),
                  const SizedBox(height: 14),
                  ...List.generate(4, (index) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      const ShimmerBox(width: 150, height: 16, radius: 4),
                      const SizedBox(height: 5),
                      const ShimmerBox(width: double.infinity, height: 56, radius: 14),
                      if (index < 3) const SizedBox(height: 14),
                    ],
                  )),

                  const SizedBox(height: 20),

                  // Service Type
                  const ShimmerBox(width: 150, height: 16, radius: 4),
                  const SizedBox(height: 6),
                  const ShimmerBox(width: double.infinity, height: 24, radius: 4),

                  const SizedBox(height: 50),

                  // Account Type Card
                  const ShimmerBox(width: double.infinity, height: 100, radius: 12),

                  const SizedBox(height: 40),

                  // Save Button
                  const ShimmerBox(width: double.infinity, height: 56, radius: 14),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
Widget header({String? title, String? description}) {
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(
      title!,
      style: AppFontStyle.customText(
        AppColors.darkText,
        19.sp,
        FontWeight.w600,
        fontFamily: AppFontFamily.gilroyMedium,
      ),
      maxLines: 2,
    ),
    hBox(6.h),
    Text(
      description!,
      style: AppFontStyle.customText(
        AppColors.mediumText,
        16.sp,
        FontWeight.w400,
        fontFamily: AppFontFamily.gilroyRegular,
      ),
      maxLines: 5,
    ),
  ]);
}

