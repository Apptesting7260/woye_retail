import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/FillVendorDetails/controller/vendor_profile_details_controller.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../../Core/Constant/image_constant.dart';
import '../../../../../../Data/components/general_exception.dart';
import '../../../../../../Data/components/internet_exception.dart';
import '../../../../../../Data/response/status.dart';
import '../../../../../../Utils/sized_box.dart';
import '../../../../../../Utils/validation.dart';
import '../../../../../../shared/theme/colors.dart';
import '../../../../../../shared/theme/font_family.dart';
import '../../../../../../shared/theme/font_style.dart';
import '../../../../../../shared/widgets/custom_appbar.dart';
import '../../../../../../shared/widgets/image.dart';
import '../../../../../../shared/widgets/vendor_widgets/app_container.dart';
import '../../../../../../shared/widgets/vendor_widgets/circular_progress_indicator.dart';
import '../../../../../../shared/widgets/vendor_widgets/custom_dropdown_api.dart';
import '../../../../../../shared/widgets/vendor_widgets/custom_elevated_button.dart';
import '../../../../../../shared/widgets/vendor_widgets/custom_text_form_field.dart';
import '../../../../../../shared/widgets/vendor_widgets/custom_time_picker1.dart';
import '../../../../../../shared/widgets/vendor_widgets/print.dart';
import '../../../vendor_common/Models/selected_delivery_type_model.dart';
import '../../../vendor_common/mapbox/view/mapbox_search_field.dart';

class ProfileDetailsScreen extends StatefulWidget {
  const ProfileDetailsScreen({super.key});

  @override
  State<ProfileDetailsScreen> createState() => _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState extends State<ProfileDetailsScreen> {

  final VendorProfileDetailsController controller = Get.find<VendorProfileDetailsController>();
  // final ResProfileDetailsDetailsController controller = Get.put(ResProfileDetailsDetailsController());

  @override
  void initState() {
    super.initState();
    controller.getInitData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundClr,
      child: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            controller.isImageBorderRedClr.value = false;
            controller.isValidAddress.value   = true;
            // controller.isAddressRedClr.value   = false;
            controller.image.value = null;
            controller.imageBase64.value = "";
            controller.clearHoursFields();
            await controller.getProfileDetailsApi();
          },
          child: Scaffold(
            body: Obx(() {
              switch (controller.rxGetProfileRequestStatus.value) {
                case ApiStatus.LOADING:
                  return Center(child: circularProgressIndicator());

                case ApiStatus.ERROR:
                  if (controller.error.value == 'No internet') {
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
                  return body();
              }
            }),
          ),
        ),
      ),
    );
  }

  PopScope<dynamic> body() {
    return PopScope(
      canPop: controller.userModel.step != 3 ? false : true,
      child: SingleChildScrollView(
        controller: controller.scrollController,
        child:Column(
            children: [
              if (controller.userModel.step == 3)
                CustomAppBar(
                  isLeading: controller.userModel.step == 3,
                ),
              if (controller.userModel.step == 1 ||
                  controller.userModel.step == 2)
                hBox(75.h),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Form(
                  key: controller.shopDetailsKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      header(
                        title: controller.userModel.step == 3
                            ? "Update Your Personal Details"
                            : "Fill Your Personal Details",
                        description:
                        "Fill your store basic details and contact information",
                      ),
                      hBox(30.h),
                      profileDetails(),
                      hBox(30.h),
                      header(
                        title: controller.userModel.step == 3
                            ? "Update Your Store Details"
                            : "Fill Your Store Details",
                        description:
                        "Lorem Ipsum is simply dummy text of the debugPrinting and typesetting industry.",
                      ),
                      hBox(30.h),
                      _profileImagePicker(context),
                      hBox(30.h),
                      shopNameField(),
                      hBox(15.h),
                      shopDescriptionField(),
                      hBox(10.h),
                      addressFromGoogleAPI(),
                      // hBox(15.h),
                      // selectedDelivery(),
                      hBox(30.h),
                      Text(
                        "Store Opening Hours",
                        style: AppFontStyle.customText(
                          AppColors.darkText,
                          18.sp,
                          FontWeight.w600,
                          fontFamily: AppFontFamily.gilroyRegular,
                        ),
                      ),
                      shopOpeningHoursBtn(),
                      hBox(20.h),
                      saveButton(),
                      hBox(20.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
      ),
    );
  }

  addressFromGoogleAPI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
      ],
    );
  }

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

  CustomTextFormField shopDescriptionField() {
    return CustomTextFormField(
      key: controller.descriptionKey,
      textInputType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      maxLength: 1000,
      controller: controller.shopDescriptionController.value,
      // errorTextStyle: AppFontStyle.text_12_400(
      //   controller.isRedClr.value ? AppColors.red :AppColors.darkText,
      //   fontFamily: AppFontFamily.gilroyMedium,
      // ),
      onTap: (){
        // controller.isSubmit.value = false;
      },
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          // if(controller.isSubmit.value){
          //   controller.scrollToField(controller.descriptionKey);
          // }
          return "Please enter description";
        }
        if (value.trim().length < 150) {
          // if(controller.isSubmit.value){
          //   controller.scrollToField(controller.descriptionKey);
          // }
          return "Description must contain at least 150 characters";
        }
        return null;
      },
      buildCounter: (context, {required currentLength, required isFocused, required maxLength}) {
        int actualLength = controller.shopDescriptionController.value.text.trim().length;
        return Text('$actualLength/$maxLength');
      },
      maxLines: 4,
      minLines: 4,
      hintText: 'Store Description',
    );
  }

  CustomTextFormField shopNameField() {
    return CustomTextFormField(
      key: controller.shopNameKey,
      controller: controller.shopNameController.value,
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
          return "Please enter Store name";
        }
        return null;

      },
      hintText: 'Store Name',
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
            print("selected delivery>>>>>>>>>>>> $value");
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
        isLoading:
        controller.rxUpdateProfileRequestStatus.value == ApiStatus.LOADING,
        onPressed: () {
          pt("👉 Button Clicked");
          // controller.isRedClr.value = true;
          // debugPrint("controller.isValidAddress.value : "+controller.isValidAddress.value.toString());
          // if (controller.isValidAddress.value) {
          //   controller.isAddressRedClr.value = false;
          // }
          if(controller.locationController.value.text.isEmpty){
            controller.isValidAddress.value = false;
          }else {
            pt("Address: ${controller.locationController.value.text}");
          }
          // controller.isSubmit.value = true;
          pt(" userModel.step: ${controller.userModel.step}");
          pt(" vendor.step: ${controller.profileApiData.value.vendor?.step}");
          pt("image path: ${controller.image.value?.path}");
          pt(" isValidAddress: ${controller.isValidAddress.value}");
          if (controller.userModel.step != 3) {
            controller.isImageBorderRedClr.value = true;
            pt("Step not 3, image required");

          }
          if ((controller.shopDetailsKey.currentState?.validate() ?? false)) {

            if ((controller.shopDetailsKey.currentState?.validate() ?? false) &&
                controller.profileApiData.value.vendor?.step == "1" &&
                (controller.image.value?.path.isNotEmpty ?? false) &&
                controller.isValidAddress.value != false ||
                controller.userModel.step == 3 &&
                    controller.isValidAddress.value != false) {
              print(" API CALLING NOW");
              controller.updateProfileDetailsApi(
                ownerName: controller.ownerNameController.value.text,
                // lastName: controller.lastNameController.value.text,
                personalEmailAddress:
                controller.personalEmailController.value.text,
                countryCode: controller.countryCode.toString(),
                phoneNumber: controller.mobNoCon.value.text,
                image: controller.imageBase64.value,
                restaurantName: controller.shopNameController.value.text,
                restaurantDescription:
                controller.shopDescriptionController.value.text,
                shopAddress: controller.locationController.text,
                startTime: controller.shopStartTimeControllers,
                closeTime: controller.shopClosedTimeControllers,
              );
            }
          } else if (controller.ownerNameController.value.text == "" ||
              controller.ownerNameController.value.text.isEmpty) {
            controller.scrollToField(controller.firstNameKey);
          } /*else if (controller.lastNameController.value.text == "" ||
              controller.lastNameController.value.text.isEmpty ||
              controller.lastNameController.value.text.length < 3) {
            controller.scrollToField(controller.lastNameKey);
          } */else if (controller.mobNoCon.value.text == "" ||
              controller.mobNoCon.value.text.isEmpty ||
              controller.mobNoCon.value.text.length !=
                  controller.checkCountryLength.value) {
            controller.scrollToField(controller.phoneKey);
          } else {
            if (controller.userModel.step != 3 &&
                (controller.image.value?.path.isEmpty ?? true)) {
              controller.scrollToField(controller.imageKey, alignment: 0.025);
            } else if (controller.shopNameController.value.text == "" ||
                controller.shopNameController.value.text.isEmpty) {
              controller.scrollToField(controller.shopNameKey);
            } else if (controller.shopDescriptionController.value.text == "" ||
                controller.shopDescriptionController.value.text.isEmpty ||
                controller.shopDescriptionController.value.text.length < 150) {
              controller.scrollToField(controller.descriptionKey);
            } else if (controller.isValidAddress.value == false || controller.locationController.value.text.isEmpty
                // ||controller.isAddressRedClr.value
            ) {
              pt("Scroll to address");
              controller.scrollToField(controller.addressKey, alignment: 0.05);
            }/*else if (controller.selectedDelivery.value.isEmpty) {
              controller.scrollToField(controller.selectedDeliveryKey, alignment: 0.01);
            }*/ else {
              for (int i = 0; i < controller.days.length; i++) {
                pt("Invalid start time at index $i");
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
                  pt("Invalid close time at index $i");
                  controller.scrollToField(controller.shopClosedTimeKey[i],
                      alignment: 0.09);
                  return;
                }
              }
            }
          }
        },
        text: controller.userModel.step == 3 ? "Update" : "Continue",
      ),
    );
  }

  Widget profileDetails() {
    return Obx(
          () => Column(
        children: [
          CustomTextFormField(
              key: controller.firstNameKey,
              controller: controller.ownerNameController.value,
              hintText: "Owner Name",
              // errorTextStyle: AppFontStyle.text_12_400(
              //   controller.isRedClr.value ? AppColors.red :AppColors.darkText,
              //   fontFamily: AppFontFamily.gilroyMedium,
              // ),
              onTap: (){
                // controller.isSubmit.value = false;
              },
              validator: (value) {
                if (value!.isEmpty || value == "") {
                  // if(controller.isSubmit.value){
                  //   controller.scrollToField(controller.firstNameKey);
                  // }
                  return "Please enter owner name";
                }else if(!isValidCharacters(value)){
                  // if(controller.isSubmit.value){
                  //   controller.scrollToField(controller.firstNameKey);
                  // }
                  return "Please enter a valid owner name";

                }
                return null;
              },
              prefix: Padding(
                padding: REdgeInsets.only(left: 20, right: 14),
                child: SvgPicture.asset(
                  ImageConstants.personSvg,
                  height: 18.h,
                  color: AppColors.hintText,
                ),
              )),
          hBox(15.h),
        /*  Obx(
                ()=> CustomTextFormField(
                key: controller.lastNameKey,
                controller: controller.lastNameController.value,
                // errorTextStyle: AppFontStyle.text_12_400(
                //   controller.isRedClr.value ? AppColors.red :AppColors.darkText,
                //   fontFamily: AppFontFamily.gilroyMedium,
                // ),
                onTap: (){
                  // controller.isSubmit.value = false;
                },
                hintText: "Last Name",
                validator: (value) {
                  if (value!.isEmpty || value == "") {
                    // if(controller.isSubmit.value){
                    //   controller.scrollToField(controller.lastNameKey);
                    // }
                    return "Please enter your last name";
                  }else if(value.length <3){
                    // if(controller.isSubmit.value){
                    //   controller.scrollToField(controller.lastNameKey);
                    // }
                    return "Last name must be at least 3 characters long";
                  }else if(!isValidCharacters(value)){
                    // if(controller.isSubmit.value){
                    //   controller.scrollToField(controller.lastNameKey);
                    // }
                    return "Please enter a valid last name";
                  }
                  return null;
                },

                prefix: Padding(
                  padding: REdgeInsets.only(left: 20, right: 14),
                  child: SvgPicture.asset(
                    ImageConstants.personSvg,
                    height: 18.h,
                  ),
                )),
          ),
          hBox(15.h),*/
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
              prefix: Padding(
                padding: REdgeInsets.only(left: 20, right: 14),
                child: SvgPicture.asset(
                  ImageConstants.email,
                  height: 18.h,
                ),
              )),
          hBox(15.h),
          Obx(() =>
              CustomTextFormField(
                key: controller.phoneKey,
                controller: controller.mobNoCon.value,
                // errorTextStyle: AppFontStyle.text_12_400(
                //   controller.isRedClr.value ? AppColors.red :AppColors.darkText,
                //   fontFamily: AppFontFamily.gilroyMedium,
                // ),
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
                      initialSelection: controller.profileApiData.value.vendor?.phoneCode ??
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
        ],
      ),
    );
  }

  Widget header({String? title, String? description}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        title!,
        style: AppFontStyle.customText(
          AppColors.darkText,
          23.sp,
          FontWeight.w500,
          fontFamily: AppFontFamily.gilroySemiBold,
        ),
        maxLines: 2,
      ),
      hBox(9.h),
      Text(
        description!,
        style: AppFontStyle.customText(
          AppColors.mediumText,
          16.sp,
          FontWeight.w400,
          fontFamily: AppFontFamily.gilroyRegular,
        ),
        maxLines: 2,
      ),
    ]);
  }

  GetBuilder<VendorProfileDetailsController> _profileImagePicker(
      BuildContext contexts) {
    return GetBuilder(
      init: controller,
      builder: (context) {
        return Obx(()=> Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: DottedBorder(
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
                                height: 200,
                                width: Get.width,
                                child: controller.image.value != null ? Image.file(
                                  controller.image.value!,
                                  fit: BoxFit.fill,
                                ) : controller.profileApiData.value.vendor?.step != "1" ? controller.profileApiData.value.vendor?.logoUrl != null
                                    ? CachedNetworkImage(
                                  imageUrl: controller.profileApiData.value.vendor!.logoUrl.toString(),
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
                                    :  AppContainer(
                                  boxShadow: const [],
                                  color:AppColors.greyBackground,
                                ) :
                                AppContainer(
                                  boxShadow: const [],
                                  color:AppColors.greyBackground,
                                )
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    wBox(10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Upload your store logo",
                            style: AppFontStyle.text_14_400(
                              AppColors.greyClr,
                              fontFamily: AppFontFamily.gilroyMedium,
                            ),
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
                              controller.pickImage(contexts).then((val){
                                controller.isImageBorderRedClr.value = false;
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
                if( controller.isImageBorderRedClr.value && controller.image.value?.path == null && controller.profileApiData.value.vendor?.step == "1") ...[
                  hBox(8.h),
                  Padding(
                    padding: REdgeInsets.only(left: 8.0),
                    child: Text("Please select store logo", style: AppFontStyle.text_12_200(AppColors.errorColor, fontFamily: AppFontFamily.gilroyMedium),),
                  ),
                ],
              ],
            ),
        );
      },
    );
  }

  @override
  void dispose() {
    for (var controller in controller.shopStartTimeControllers) {
      controller.clear();
      // controller.dispose();
    }
    for (var controller in controller.shopClosedTimeControllers) {
      controller.clear();
      // controller.dispose();
    }
    for (var isToggle in controller.isToggleList) {
      isToggle.value = false;
    }
    // controller.mobNoCon.value.cl();
    super.dispose();
  }

}
