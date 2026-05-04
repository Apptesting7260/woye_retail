import 'dart:convert';
import 'dart:developer';

import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:gyaawa/apps/vendor_app/view/vendor_common/Models/common_response_model.dart';
import 'package:gyaawa/routes/vendor_routes/vendor_app_routes.dart';
import 'package:gyaawa/shared/widgets/vendor_widgets/address_fromgoogle/modal/google_location_model.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geocoding/geocoding.dart';
export 'package:country_code_picker/country_code_picker.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../../../../Data/Model/user_model.dart';
import '../../../../../../../../../Data/Repository/repository.dart';
import '../../../../../../../../../Data/response/api_response.dart';
import '../../../../../../../../../Data/response/status.dart';
import '../../../../../../../../../Data/user_preference_controller.dart';
import '../../../../../../../../../Utils/check_routes_popup.dart';
import '../../../../../../../../../Utils/snack_bar.dart';
import '../../../../../../../../../shared/theme/colors.dart';
import '../../../../../../../../../shared/widgets/vendor_widgets/custom_confirm_password_dialog.dart';
import '../../../../../../../../../shared/widgets/vendor_widgets/custom_image_cropper.dart';
import '../../../../../../../../../shared/widgets/vendor_widgets/print.dart';
import '../../../../../../vendor_common/GetProfileController/controller/common_get_profile_controller.dart';
import '../model/profile_details_model.dart';
import '../model/register_vendor_model.dart';
import '../model/update_information_model.dart';

class FillRestaurantDetailsController extends GetxController {
  dynamic argumentData = Get.arguments;

  // RxBool isRedClr = false.obs;
  // RxBool isAddressRedClr = false.obs;
  RxBool isImageBorderRedClr = false.obs;
  RxBool isLogoImageBorderRedClr = false.obs;

  final shopDetailsKey = GlobalKey<FormState>();

  Rx<TextEditingController> shopDescriptionController = TextEditingController().obs;
  Rx<TextEditingController> websiteController = TextEditingController().obs;

  // Rx<TextEditingController> addressController = TextEditingController().obs;
  Rx<TextEditingController> restaurantNameController = TextEditingController().obs;
  Rx<TextEditingController> ownerNameController = TextEditingController().obs;
  Rx<TextEditingController> personalEmailController = TextEditingController().obs;
  Rx<TextEditingController> dobController = TextEditingController().obs;
  Rx<TextEditingController> passwordController = TextEditingController().obs;
  Rx<TextEditingController> confirmPasswordController = TextEditingController().obs;
  Rx<TextEditingController> businessLicenceController = TextEditingController().obs;
  Rx<TextEditingController> taxIdController = TextEditingController().obs;
  Rx<TextEditingController> establishController = TextEditingController().obs;
  Rx<TextEditingController> facebookController = TextEditingController().obs;
  Rx<TextEditingController> instagramController = TextEditingController().obs;
  Rx<TextEditingController> twitterController = TextEditingController().obs;
  Rx<TextEditingController> youtubeController = TextEditingController().obs;
  Rx<TextEditingController> blogController = TextEditingController().obs;
  Rx<TextEditingController> deliveryRadiusController = TextEditingController().obs;
  Rx<TextEditingController> minimumOrderController = TextEditingController().obs;
  Rx<TextEditingController> deliveryFeeController = TextEditingController().obs;
  Rx<TextEditingController> minimumOrderForFreeDeliveryController = TextEditingController().obs;
// Controller mein
  RxString selectedNumberOfEmployees = ''.obs;

// Display options and their API values
  final Map<String, String> employeeOptionsMap = {
    '1-5 employees': '1-5',
    '6-10 employees': '6-10',
    '11-20 employees': '11-20',
    '21-50 employees': '21-50',
    '51+ employees': '51+'
  };

// Get display options list
  List<String> get employeeOptions => employeeOptionsMap.keys.toList();

// API value ko dropdown value mein convert karein
  String? mapApiValueToDropdown(String? apiValue) {
    if (apiValue == null || apiValue.isEmpty) return null;

    // Find display value for API value
    for (var entry in employeeOptionsMap.entries) {
      if (entry.value == apiValue) {
        return entry.key;
      }
    }

    return null;
  }

// Initialize method
  void initializeNumberOfEmployees(String? noOfEmployees) {
    selectedNumberOfEmployees.value = mapApiValueToDropdown(noOfEmployees) ?? "";
  }

// Dropdown value ko API format mein convert karein
  String getNumberOfEmployeesForApi() {
    return employeeOptionsMap[selectedNumberOfEmployees.value] ?? '';
  }

  RxString selectedAvgPreFillTime = "".obs;
  RxString selectedLastOrderTime = "".obs;

  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  final locationController = TextEditingController();
  UserModel userModel = UserModel();
  UserPreference pref = UserPreference();

  RxString userRole = "".obs;

  void getInitData() async {
    userModel = await pref.getUser();
    isImageBorderRedClr.value = false;
    userRole.value = userModel.userRole?.toLowerCase() ?? "";
    // clearHoursFields();
    await getProfileDetailsApi();
  }

  bool get isAccountant => userRole.value.toLowerCase() == UserType.accountant.name;
  bool get isKitchenStaff => userRole.value.replaceAll(" ", "").toLowerCase() == UserType.kitchenstaff.name;
  bool get isServiceStaff => userRole.value.replaceAll(" ", "").toLowerCase() == UserType.servicestaff.name;

  RxInt radioValue = 0.obs;

  RxInt? selectedIndex;
  Rx<TextEditingController> mobNoCon = TextEditingController().obs;

  DateTime parseTime1 = DateTime.now();
  DateTime parseTime2 = DateTime.now();

  String countryValue = " ";
  String stateValue = " ";
  String cityValue = " ";
  String countryCode = "+91";
  RxString selectedDelivery = "".obs;

  RxBool isPreOrder = false.obs;
  updatePreOrderValue(bool preorder){
    isPreOrder.value = preorder;
    pt("isPreOrder ${isPreOrder.value}");
    update();
  }


// Inside the controller class, add:
  var showErrors = RxBool(false);
  var phoneNumberErrorMessage = ''.obs;

  String address = "";

  RxBool isShowPassword = true.obs;
  RxBool isShowConfirmPassword = true.obs;

  final rxGetProfileRequestStatus = ApiStatus.COMPLETED.obs;
  final rxUpdateProfileRequestStatus = ApiStatus.COMPLETED.obs;
  RxString error = ''.obs;
  final api = Repository();
  final profileApiData = ProfileDetailsModel().obs;

  void personalDetailsSet(ProfileDetailsModel value) =>
      profileApiData.value = value;

  final registerData = InformationUpdateModel().obs;

  void updateProfileData(InformationUpdateModel value) =>
      registerData.value = value;

  void setRxGetProfileRequestStatus(ApiStatus value) =>
      rxGetProfileRequestStatus.value = value;

  void setRxUpdateProfileRequestStatus(ApiStatus value) =>
      rxUpdateProfileRequestStatus.value = value;

  void setError(String value) => error.value = value;

  togglePasswordVisibility({bool? isConfirmPassword}) {
    if (isConfirmPassword == true) {
      isShowConfirmPassword.value = !isShowConfirmPassword.value;
    } else {
      isShowPassword.value = !isShowPassword.value;
    }
  }

  //<< --------------------Scroll Functionality ------------------------->>
  final ScrollController scrollController = ScrollController();

  //---------keys for scroll
  final GlobalKey restaurantNameKey = GlobalKey();
  final GlobalKey ownerNameKey = GlobalKey();
  final GlobalKey phoneKey = GlobalKey();
  final GlobalKey imageKey = GlobalKey();
  final GlobalKey shopNameKey = GlobalKey();
  final GlobalKey descriptionKey = GlobalKey();
  final GlobalKey addressKey = GlobalKey();
  final GlobalKey selectedDeliveryKey = GlobalKey();
  final GlobalKey websiteKey = GlobalKey();
  // RxBool isSubmit = false.obs;
// In your FillRestaurantDetailsController
  final GlobalKey logoImageKey = GlobalKey();
  final GlobalKey coverImageKey = GlobalKey();
  final GlobalKey deliveryRadiusKey = GlobalKey();
  final GlobalKey deliveryFeeKey = GlobalKey();
  final GlobalKey preparationTimeKey = GlobalKey();
  final GlobalKey minimumOrderKey = GlobalKey();
  final GlobalKey facebookKey = GlobalKey();
  final GlobalKey instagramKey = GlobalKey();
  final GlobalKey twitterKey = GlobalKey();
  final GlobalKey youtubeKey = GlobalKey();
  final GlobalKey businessLicenseKey = GlobalKey();
  final GlobalKey taxIDKey = GlobalKey();
  final GlobalKey minimumOrderForFreeDeliveryKey = GlobalKey();
  final GlobalKey orderCutoffMinutesBeforeClosing = GlobalKey();

  void scrollToField(GlobalKey key, {alignment}) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment:alignment ?? 0,
      );
    }
  }

  void scrollToTop() {
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  //<<---------------------- Check Phone number ------------------>>

  final Rx<ApiResponse<CommonResponseModel>> _checkPhoneNumberValidation = Rx<ApiResponse<CommonResponseModel>>(ApiResponse.loading());
  Rx<ApiResponse<CommonResponseModel>> get checkPhoneNumberValidation => _checkPhoneNumberValidation;
  setPhoneValidation(ApiResponse<CommonResponseModel> value) => _checkPhoneNumberValidation.value = value;

  RxString phoneNumberError = "".obs;
  setPhoneNumberError(String value) {
    phoneNumberError.value = value;
    update();
  }

  Future<void> checkNumberValidation()async{
    setPhoneValidation(ApiResponse.loading());
    var data  ={
      "phone_code": countryCode,
      "phone": mobNoCon.value.text,
    };
    try{
      await api.phoneNumberValidation(data).then((value) {
        if(value.status == true){
          setPhoneValidation(ApiResponse.completed(value));
          setPhoneNumberError("");
        }else{
          setPhoneValidation(ApiResponse.completed(value));
          setPhoneNumberError(value.message.toString());
        }
      },).onError((error, stackTrace) {
        setPhoneValidation(ApiResponse.error(error.toString()));
      },);
    }catch(e){
      setPhoneValidation(ApiResponse.error(e.toString()));
    }
  }

  //<<----------------------Hop hours time ------------------>>

  RxString addressError = "".obs;
  RxString apiMinOrderAmount = "".obs;
  //<<---------------------- Get Profile Details ------------------>>

  getProfileDetailsApi({bool isShowLoading = true,bool? fromUpdateProfile,bool? fromNotification}) async {
    isValidAddress.value =true;
    if(isShowLoading == true) {
      rxGetProfileRequestStatus(ApiStatus.LOADING);
    }
    api.getProfileApi().then((value) async {
      personalDetailsSet(value);
      debugPrint("profile details: $value");
      if (profileApiData.value.status == true) {
        log("res information controller here Step ${profileApiData.value.vendor?.step} and Status ${profileApiData.value.vendor?.status}",name: ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
        final vendor =  profileApiData.value.vendor;
        pt(vendor?.website.toString() ??"",name: "Profile information website");
        restaurantNameController.value.text = vendor?.shopName ?? "";
        ownerNameController.value.text = vendor?.ownerName ?? "";
        shopDescriptionController.value.text = vendor?.description ?? "";
        websiteController.value.text = vendor?.website ?? "";
        businessLicenceController .value.text = vendor?.licenseNumber ?? "";
        taxIdController.value.text = vendor?.taxNumber ?? "";
        selectedNumberOfEmployees.value =vendor?.noOfEmployees != null ? "${vendor?.noOfEmployees} employees" : "";
        facebookController.value.text = vendor?.facebook ?? "";
        instagramController.value.text = vendor?.instagram ?? "";
        twitterController.value.text = vendor?.twitter ?? "";
        blogController.value.text = vendor?.website ?? "";
        deliveryRadiusController.value.text = vendor?.deliveryRadius ?? "";
        deliveryFeeController.value.text = vendor?.deliveryFee ?? "";
        minimumOrderController.value.text = vendor?.minOrderAmount ?? "";
        youtubeController.value.text = vendor?.youtube ?? "";
        selectedAvgPreFillTime.value = normalizeForDropdown(vendor?.avgPreparationTime ?? "");
        initializeServicesFromApi(value);
        if (vendor?.noOfEmployees != null) {
          initializeNumberOfEmployees(vendor?.noOfEmployees);
        }
        personalEmailController.value.text = profileApiData.value.vendor?.email ?? "";
        mobNoCon.value.text = profileApiData.value.vendor?.phone ?? "";
        countryCode = profileApiData.value.vendor?.phoneCode ?? "";
        checkCountryLength.value = int.parse(profileApiData.value.vendor?.phone?.length.toString() ?? "10");
        if (vendor?.establishedDate != null) {
          initializeEstablishDateFromApi(vendor?.establishedDate);
        }
        // passwordController.value.text = profileApiData.value.vendor?.pPassword ?? "";
        // confirmPasswordController.value.text = profileApiData.value.vendor?.pPassword ?? "";
        // shopDescriptionController.value.text = profileApiData.value.vendor?.shopDes ?? "";
        locationController.text = profileApiData.value.vendor?.address ?? "";
        latitude.value = double.parse(profileApiData.value.vendor?.latitude ?? "0.0");
        longitude.value = double.parse(profileApiData.value.vendor?.longitude ?? "0.0");
        selectedDelivery.value = profileApiData.value.vendor?.delivery ?? "";
        updatePreOrderValue(profileApiData.value.vendor?.isPreOrder == "1" ? true : false);
        minimumOrderForFreeDeliveryController.value.text = profileApiData.value.vendor?.freeDelAmount ?? "";
        apiMinOrderAmount.value = profileApiData.value.vendor?.freeDelAmount ?? "";
        selectedLastOrderTime.value = profileApiData.value.vendor?.orderCutoffMinutesBeforeClosing ?? "";
        image.value = null;
        rxGetProfileRequestStatus(ApiStatus.COMPLETED);

        pt("profileApiData.value.isProfileComplete 11 ${profileApiData.value.isProfileComplete}  $fromUpdateProfile");

        String titleDocs =  (value?.isRequiredVerified == false && value?.isRequiredUploaded == false) ? "Documents Required"  :  "Documents Submitted";
        String subTitleDocs = (value?.isRequiredVerified == false && value?.isRequiredUploaded == false) ? "Please upload required documents. Your account will be activated after admin approval." :
        "You have successfully uploaded your documents. They are currently under verification. Please wait for approval.";


        if(isUploadDocsScreen()){
          return;
        }
        if (profileApiData.value.vendor?.step == '3' && (profileApiData.value.vendor?.status == 'suspended' || profileApiData.value.vendor?.status == 'inactive'|| profileApiData.value.vendor?.status == 'pending')) {
          await closeAllDialogs();
          pt("profileApiData.value.isProfileComplete 222 ${profileApiData.value.isProfileComplete}");

          if (profileApiData.value.vendor?.status == 'suspended') {
            if(profileApiData.value.isRequiredUploaded == false || profileApiData.value.isRequiredVerified == false){
              await closeAllDialogs().then((value) {
                Get.dialog(
                  CustomConfirmPasswordDialog(
                    isUploadDocs: true,
                    isError: true,
                    title: titleDocs,
                    subTitle: subTitleDocs,
                    isContactBtn: true,
                    isDocsBtnOnTap: () {
                      if(profileApiData.value.vendor?.type == "restaurant"){
                        Get.toNamed(VendorAppRoutes.restaurantComplianceAndLicensesScreen);
                      }
                    //   else if(profileApiData.value.vendor?.type == "pharmacy"){
                    //     Get.toNamed(AppRoutes.pharmacyComplianceAndLicensesScreen);
                    //   }else if(profileApiData.value.vendor?.type == 'grocery'){
                    //     Get.toNamed(AppRoutes.groceryComplianceAndLicensesScreen);
                    //   }
                     },
                  ),
                  barrierDismissible: false,
                );
              },);
            }
            else {
              Get.dialog(
                const CustomConfirmPasswordDialog(
                  isError: true,
                  title: "Account Suspended",
                  subTitle: "Your account has been suspended.",
                  isContactBtn: true,
                ),
                barrierDismissible: false,
              );
            }
            } else if (profileApiData.value.vendor?.status == 'pending') {
            if(profileApiData.value.isRequiredUploaded == false || profileApiData.value.isRequiredVerified == false){
              await closeAllDialogs().then((value) {
                Get.dialog(
                  CustomConfirmPasswordDialog(
                    isUploadDocs: true,
                    isError: true,
                    title: titleDocs,
                    subTitle: subTitleDocs,
                    isContactBtn: true,
                    isDocsBtnOnTap: () {
                      if(profileApiData.value.vendor?.type == "restaurant"){
                        Get.toNamed(VendorAppRoutes.restaurantComplianceAndLicensesScreen);
                      }
                    },
                  ),
                  barrierDismissible: false,
                );
              },);
            }
            else {
              Get.dialog(
                const CustomConfirmPasswordDialog(
                  isUploadDocs: false,
                  isError: true,
                  title: "Under Approval",
                  subTitle:
                  "Your account is not activated, wait for admin approval",
                  isContactBtn: false,
                ),
                barrierDismissible: false,
              );
            }
            }else if ( profileApiData.value.vendor?.status == 'inactive') {
            if(profileApiData.value.isRequiredUploaded == false || profileApiData.value.isRequiredVerified == false){
              await closeAllDialogs().then((value) {
                Get.dialog(
                  CustomConfirmPasswordDialog(
                    isUploadDocs: true,
                    isError: true,
                    title: titleDocs,
                    subTitle: subTitleDocs,
                    isContactBtn: true,
                    isDocsBtnOnTap: () {
                      if(profileApiData.value.vendor?.type == "restaurant"){
                        Get.toNamed(VendorAppRoutes.restaurantComplianceAndLicensesScreen);
                      }
                    },
                  ),
                  barrierDismissible: false,
                );
              },);
            }
            else {
              Get.dialog(
                const CustomConfirmPasswordDialog(
                  isError: true,
                  title: "Account Inactive",
                  subTitle:
                  "Your account is not activated",
                  isContactBtn: false,
                ),
                barrierDismissible: false,
              );
            }
            }
        }
        else if(profileApiData.value.vendor?.step == '3' &&
            profileApiData.value.vendor?.status == 'active' &&
            profileApiData.value.isProfileComplete == false && (fromUpdateProfile == true || fromNotification == true)){
          pt("profileApiData.value.isProfileComplete inside dialog ${profileApiData.value.isProfileComplete}  $fromUpdateProfile");
          if(fromNotification == true){
            await closeAllDialogs().then((value) {
              if(profileApiData.value.isRequiredUploaded == false || profileApiData.value.isRequiredVerified == false){
                Get.dialog(
                  CustomConfirmPasswordDialog(
                    isUploadDocs: true,
                    isError: true,
                    title: titleDocs,
                    subTitle: subTitleDocs,
                    isContactBtn: true,
                    isDocsBtnOnTap: () {
                      if(profileApiData.value.vendor?.type == "restaurant"){
                        Get.toNamed(VendorAppRoutes.restaurantComplianceAndLicensesScreen);
                      }
                    },
                  ),
                  barrierDismissible: false,
                );
              }
              else {
                showProfileIncompleteDialog();
              }
            },);
          }else{
            await closeAllDialogs().then((value) {
              if(profileApiData.value.isRequiredUploaded == false || profileApiData.value.isRequiredVerified == false){
                Get.dialog(
                  CustomConfirmPasswordDialog(
                    isUploadDocs: true,
                    isError: true,
                    title: titleDocs,
                    subTitle: subTitleDocs,
                    isContactBtn: true,
                    isDocsBtnOnTap: () {
                      if(profileApiData.value.vendor?.type == "restaurant"){
                        Get.toNamed(VendorAppRoutes.restaurantComplianceAndLicensesScreen);
                      }
                    },
                  ),
                  barrierDismissible: false,
                );
              }
              else {
                Get.dialog(
                  const CustomConfirmPasswordDialog(
                    isShowCancelCircleBtn: true,
                    isError: true,
                    title: "Profile Incomplete",
                    subTitle: "Please complete your profile to continue.",
                    isContactBtn: false,
                  ),
                  barrierDismissible: true,
                );
              }
              },
            );
          }
          return;
        // } else{
        } else if(profileApiData.value.isProfileComplete == true && profileApiData.value.vendor?.status == 'active'){
          pt("profileApiData.value.isProfileComplete 33 step ${profileApiData.value.vendor?.step} >>>  ${profileApiData.value.isProfileComplete}");
          if(profileApiData.value.isRequiredUploaded == false || profileApiData.value.isRequiredVerified == false){
            await closeAllDialogs().then((value) {
              Get.dialog(
              CustomConfirmPasswordDialog(
                isUploadDocs: true,
                isError: true,
                title: titleDocs,
                subTitle: subTitleDocs,
                isContactBtn: true,
                isDocsBtnOnTap: () {
                  if(profileApiData.value.vendor?.type == "restaurant"){
                    Get.toNamed(VendorAppRoutes.restaurantComplianceAndLicensesScreen);
                  }
                },
              ),
              barrierDismissible: false,
            );
              },);
          }
          else {
          await closeAllDialogs(fromUpdateProfile: fromUpdateProfile);
          }
        }
      }
    })
      .onError(
      (error, stackTrace) {
        rxGetProfileRequestStatus(ApiStatus.ERROR);
        // Utils.showToast('Error: $error');
        setError(error.toString());
        debugPrint('Error res information: $error');
      },
    );
  }

  Future<void> closeAllDialogs({bool? fromUpdateProfile}) async {
    while (Get.isDialogOpen ?? false) {
      Get.back();
      await Future.delayed(const Duration(milliseconds: 1)); // Wait a bit to ensure smooth closing
    }
    if(profileApiData.value.vendor?.step == '3' && profileApiData.value.isProfileComplete == false && fromUpdateProfile == true){{
      await Future.delayed(const Duration(milliseconds: 200));
      if(profileApiData.value.isRequiredUploaded == false || profileApiData.value.isRequiredVerified == false){
        Get.dialog(
          CustomConfirmPasswordDialog(
            isUploadDocs: true,
            isError: true,
             title : (profileApiData.value.isRequiredVerified == false && profileApiData.value.isRequiredUploaded == false) ? "Documents Required"  :  "Documents Submitted",
              subTitle :  (profileApiData.value.isRequiredVerified == false && profileApiData.value.isRequiredUploaded == false) ?
                        "Please upload required documents. Your account will be activated after admin approval." :
                        "You have successfully uploaded your documents. They are currently under verification. Please wait for approval.",
        isContactBtn: true,
            isDocsBtnOnTap: () {
              if(profileApiData.value.vendor?.type == "restaurant"){
                Get.toNamed(VendorAppRoutes.restaurantComplianceAndLicensesScreen);
              }
            },
          ),
          barrierDismissible: false,
        );
      }else {
        Get.dialog(
          const CustomConfirmPasswordDialog(
            isShowCancelCircleBtn: true,
            isError: true,
            title: "Profile Incomplete",
            subTitle: "Please complete your profile to continue.",
            isContactBtn: false,
          ),
          barrierDismissible: true,
        );
      }
      return;
    }}
  }

  void showProfileIncompleteDialog() {
    if (Get.isDialogOpen ?? false) return;
    Future.delayed(Duration.zero, () {
      Get.dialog(
        PopScope(
          canPop: false,
          child: CustomConfirmPasswordDialog(
            isError: true,
            title: "Profile Incomplete",
            subTitle: "Please complete your profile to continue.",
            isContactBtn: true,
            contactBtnTitle: "OK",
            isContactBtnOnTap: () async {
              closeAllDialogs();
              await Future.delayed(const Duration(milliseconds: 200));

              final type = profileApiData.value.vendor?.type;

              if (type == "restaurant") {
                Get.toNamed(VendorAppRoutes.restaurantInformationScreens);
              }
            },
          ),
        ),
        barrierDismissible: false,
      );
    });
  }

  RxList<String> serviceTypesFromApi = <String>[].obs;

  // Selected services
  RxList<String> selectedServiceTypes = <String>[].obs;

  // Initialize services from API data
  void initializeServicesFromApi(ProfileDetailsModel profileData) {
    // Available services
    serviceTypesFromApi.value = profileData.serviceTypeOptions ?? [];

    // Pre-select services from vendor profile
    if (profileData.vendor?.serviceType != null) {
      selectedServiceTypes.value = profileData.vendor!.serviceType!;
    }

    final hasDelivery = serviceTypesFromApi.any((e) => e == "Delivery");

    if (hasDelivery && !selectedServiceTypes.any((e) => e == "Delivery")) {
      selectedServiceTypes.add("Delivery");
    }
  }

  // Toggle service selection
  void toggleService(String type) {
    if (selectedServiceTypes.contains(type)) {
      selectedServiceTypes.remove(type);
    } else {
      selectedServiceTypes.add(type);
    }
    pt("Selected Services: $selectedServiceTypes");
  }

  // Check if service is selected
  bool isServiceSelected(String type) {
    return selectedServiceTypes.contains(type);
  }

  Map<String, Map<String, String>> openingHours = {};

  //<<---------------------- Update Profile Details ------------------>>

  updateProfileDetailsApi() async {
    String establishDate = getEstablishDateForApi();
    var data = {
      "shop_name": restaurantNameController.value.text,
      "owner_name": ownerNameController.value.text,
      "description": shopDescriptionController.value.text,
      "phone_code": countryCode,
      "phone": mobNoCon.value.text,
      "email": personalEmailController.value.text,
      "website": websiteController.value.text,
      "address": locationController.text,
      "latitude":latitude.toString(),
      "longitude": longitude.toString(),
      "license_number": businessLicenceController.value.text,
      "tax_number": taxIdController.value.text,
      "dea_registration_number": "",
      "established_date":establishDate,
      "no_of_employees": getNumberOfEmployeesForApi(),
      "facebook": facebookController.value.text,
      "instagram": instagramController.value.text,
      "twitter": twitterController.value.text,
      "youtube": youtubeController.value.text,
      "delivery_radius": deliveryRadiusController.value.text,
      "min_order_amount":minimumOrderController.value.text,
      "delivery_fee": deliveryFeeController.value.text,
      "avg_preparation_time": selectedAvgPreFillTime.value.split(" ").first.toString(),
      "service_type": selectedServiceTypes,
      // "service_type": selectedServiceTypes.map((e) => e.isNotEmpty ? e[0].toUpperCase() + e.substring(1).toLowerCase(): e).toList(),
      "delivery":int.tryParse(selectedDelivery.value),
      "is_pre_order": isPreOrder.value ==  false ? "0" : "1",
      "free_del_amount" : minimumOrderForFreeDeliveryController.value.text,
      "order_cutoff_minutes_before_closing" : selectedLastOrderTime.value,
      "logo": logoImageBase64.value,
      "cover_photo":coverImageBase64.value,
    };
    debugPrint("Data body: $data");
    rxUpdateProfileRequestStatus(ApiStatus.LOADING);
    api.updateInformationApi(jsonEncode(data)).then((value)async {
      updateProfileData(value);
      if (registerData.value.status == true) {
        rxUpdateProfileRequestStatus(ApiStatus.COMPLETED);
        pref.saveStep(int.parse(registerData.value.data?.step.toString() ?? ""));
        if (userModel.step == 3) {
          scrollToTop();
          getProfileDetailsApi(isShowLoading: false,fromUpdateProfile: true);
          if(value.message != "") {
            Utils.showToast(value.message ?? "");
          }
          // Get.back();
          final profileController = Get.find<CommonProfileController>();
          await profileController.getProfileDetailsApi();
        } else {
          Get.offAndToNamed(VendorAppRoutes.chooseRestaurantCategoriesScreen);
          Utils.showToast("Registration successfully completed");
        }

        update();
      } else if (registerData.value.status == false) {
        rxUpdateProfileRequestStatus(ApiStatus.ERROR);
        Utils.showToast("${registerData.value.message.toString()} ${registerData.value.errorMessage ?? ""}");
      } else {
        rxUpdateProfileRequestStatus(ApiStatus.ERROR);
        Utils.showToast("${registerData.value.message.toString()} ${registerData.value.errorMessage ?? ""}");
      }
    }).onError(
      (error, stackTrace) {
        rxUpdateProfileRequestStatus(ApiStatus.ERROR);
        Utils.showToast(error.toString() ?? 'Something went wrong please try again',
          bgColor: AppColors.red,
        );
        debugPrint('Error: $error');
      },
    );
  }


// Add these to your controller
  Rx<DateTime?> selectedEstablishDate = Rx<DateTime?>(null);

// Single formatter for both display and API
  final DateFormat dateFormatter = DateFormat('yyyy-MM-dd');

// Method to initialize date from API (handles "2015-06-20" format)
  void initializeEstablishDateFromApi(String? apiDate) {
    if (apiDate != null && apiDate.isNotEmpty) {
      try {
        // Parse the date from API in "2015-06-20" format
        DateTime parsedDate = dateFormatter.parse(apiDate);
        selectedEstablishDate.value = parsedDate;
        establishController.value.text = _formatDateForDisplay(parsedDate); // Show in DD/MM/YYYY for user
      } catch (e) {
        debugPrint("Error parsing date from API: $e");
        // Fallback parsing
        try {
          DateTime parsedDate = DateTime.parse(apiDate);
          selectedEstablishDate.value = parsedDate;
          establishController.value.text = _formatDateForDisplay(parsedDate);
        } catch (e2) {
          debugPrint("Fallback parsing also failed: $e2");
        }
      }
    }
  }

// Format date for display (DD/MM/YYYY)
  String _formatDateForDisplay(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

// Method to show date picker
  Future<void> selectEstablishDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedEstablishDate.value ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedEstablishDate.value) {
      selectedEstablishDate.value = picked;
      establishController.value.text = _formatDateForDisplay(picked); // Display in DD/MM/YYYY
    }
  }

// Method to get date in API format "2015-06-20"
  String getEstablishDateForApi() {
    if (selectedEstablishDate.value != null) {
      return dateFormatter.format(selectedEstablishDate.value!); // Returns "2015-06-20"
    }
    return '';
  }

  void setEstablishDateFromApi(String apiDateString) {
    try {
      DateTime date = dateFormatter.parse(apiDateString);
      selectedEstablishDate.value = date;
      establishController.value.text = _formatDateForDisplay(date);
      debugPrint("Error setting date from API: ${establishController.value.text}");
    } catch (e) {
      debugPrint("Error setting date from API: $e");
    }
  }

  void updateCountryCode(CountryCode countryCode) {
    pt("countryCode>>>>>>> $countryCode");
    selectedCountryCode.value = countryCode;
  }

  RxBool showError = true.obs;

  Rx<CountryCode> selectedCountryCode =
      CountryCode(dialCode: '+91', code: 'IN').obs;

  RxInt checkCountryLength = 10.obs;
  final Map<String, int> countryPhoneDigits = {
    'AF': 9, // Afghanistan
    'AL': 9, // Albania
    'DZ': 9, // Algeria
    'AD': 6, // Andorra
    'AO': 9, // Angola
    'AG': 10, // Antigua and Barbuda
    'AR': 10, // Argentina
    'AM': 8, // Armenia
    'AU': 9, // Australia
    'AT': 10, // Austria
    'AZ': 9, // Azerbaijan
    'BS': 10, // Bahamas
    'BH': 8, // Bahrain
    'BD': 10, // Bangladesh
    'BB': 10, // Barbados
    'BY': 9, // Belarus
    'BE': 9, // Belgium
    'BZ': 7, // Belize
    'BJ': 8, // Benin
    'BT': 8, // Bhutan
    'BO': 8, // Bolivia
    'BA': 8, // Bosnia and Herzegovina
    'BW': 7, // Botswana
    'BR': 11, // Brazil
    'BN': 7, // Brunei
    'BG': 9, // Bulgaria
    'BF': 8, // Burkina Faso
    'BI': 8, // Burundi
    'CV': 7, // Cape Verde
    'KH': 9, // Cambodia
    'CM': 9, // Cameroon
    'CA': 10, // Canada
    'CF': 8, // Central African Republic
    'TD': 8, // Chad
    'CL': 9, // Chile
    'CN': 11, // China
    'CO': 10, // Colombia
    'KM': 7, // Comoros
    'CG': 9, // Congo
    'CR': 8, // Costa Rica
    'HR': 9, // Croatia
    'CU': 8, // Cuba
    'CY': 8, // Cyprus
    'CZ': 9, // Czech Republic
    'DK': 8, // Denmark
    'DJ': 8, // Djibouti
    'DM': 10, // Dominica
    'DO': 10, // Dominican Republic
    'EC': 9, // Ecuador
    'EG': 10, // Egypt
    'SV': 8, // El Salvador
    'GQ': 9, // Equatorial Guinea
    'ER': 7, // Eritrea
    'EE': 7, // Estonia
    'ET': 9, // Ethiopia
    'FJ': 7, // Fiji
    'FI': 10, // Finland
    'FR': 9, // France
    'GA': 7, // Gabon
    'GM': 7, // Gambia
    'GE': 9, // Georgia
    'DE': 10, // Germany
    'GH': 9, // Ghana
    'GR': 10, // Greece
    'GD': 10, // Grenada
    'GT': 8, // Guatemala
    'GN': 9, // Guinea
    'GW': 7, // Guinea-Bissau
    'GY': 7, // Guyana
    'HT': 8, // Haiti
    'HN': 8, // Honduras
    'HU': 9, // Hungary
    'IS': 7, // Iceland
    'IN': 10, // India
    'ID': 10, // Indonesia
    'IR': 10, // Iran
    'IQ': 10, // Iraq
    'IE': 9, // Ireland
    'IL': 9, // Israel
    'IT': 10, // Italy
    'JM': 10, // Jamaica
    'JP': 10, // Japan
    'JO': 9, // Jordan
    'KZ': 10, // Kazakhstan
    'KE': 10, // Kenya
    'KI': 8, // Kiribati
    'KP': 10, // North Korea
    'KR': 10, // South Korea
    'KW': 8, // Kuwait
    'KG': 9, // Kyrgyzstan
    'LA': 9, // Laos
    'LV': 8, // Latvia
    'LB': 8, // Lebanon
    'LS': 8, // Lesotho
    'LR': 7, // Liberia
    'LY': 10, // Libya
    'LI': 7, // Liechtenstein
    'LT': 8, // Lithuania
    'LU': 9, // Luxembourg
    'MG': 9, // Madagascar
    'MW': 9, // Malawi
    'MY': 10, // Malaysia
    'MV': 7, // Maldives
    'ML': 8, // Mali
    'MT': 8, // Malta
    'MH': 7, // Marshall Islands
    'MR': 8, // Mauritania
    'MU': 8, // Mauritius
    'MX': 10, // Mexico
    'FM': 7, // Micronesia
    'MD': 8, // Moldova
    'MC': 8, // Monaco
    'MN': 8, // Mongolia
    'ME': 8, // Montenegro
    'MA': 9, // Morocco
    'MZ': 9, // Mozambique
    'MM': 9, // Myanmar
    'NA': 9, // Namibia
    'NR': 7, // Nauru
    'NP': 10, // Nepal
    'NL': 9, // Netherlands
    'NZ': 9, // New Zealand
    'NI': 8, // Nicaragua
    'NE': 8, // Niger
    'NG': 10, // Nigeria
    'MK': 8, // North Macedonia
    'NO': 8, // Norway
    'OM': 8, // Oman
    'PK': 10, // Pakistan
    'PW': 7, // Palau
    'PA': 8, // Panama
    'PG': 8, // Papua New Guinea
    'PY': 9, // Paraguay
    'PE': 9, // Peru
    'PH': 10, // Philippines
    'PL': 9, // Poland
    'PT': 9, // Portugal
    'QA': 8, // Qatar
    'RO': 10, // Romania
    'RU': 10, // Russia
    'RW': 9, // Rwanda
    'KN': 10, // Saint Kitts and Nevis
    'LC': 10, // Saint Lucia
    'VC': 10, // Saint Vincent and the Grenadines
    'WS': 7, // Samoa
    'SM': 8, // San Marino
    'ST': 7, // Sao Tome and Principe
    'SA': 9, // Saudi Arabia
    'SN': 9, // Senegal
    'RS': 9, // Serbia
    'SC': 7, // Seychelles
    'SL': 8, // Sierra Leone
    'SG': 8, // Singapore
    'SK': 9, // Slovakia
    'SI': 9, // Slovenia
    'SB': 7, // Solomon Islands
    'SO': 8, // Somalia
    'ZA': 9, // South Africa
    'ES': 9, // Spain
    'LK': 10, // Sri Lanka
    'SD': 9, // Sudan
    'SR': 7, // Suriname
    'SE': 9, // Sweden
    'CH': 9, // Switzerland
    'SY': 9, // Syria
    'TW': 9, // Taiwan
    'TJ': 9, // Tajikistan
    'TZ': 9, // Tanzania
    'TH': 9, // Thailand
    'TG': 8, // Togo
    'TO': 7, // Tonga
    'TT': 10, // Trinidad and Tobago
    'TN': 8, // Tunisia
    'TR': 10, // Turkey
    'TM': 8, // Turkmenistan
    'TV': 7, // Tuvalu
    'UG': 9, // Uganda
    'UA': 9, // Ukraine
    'AE': 9, // United Arab Emirates
    'GB': 10, // United Kingdom
    'US': 10, // United States
    'UY': 9, // Uruguay
    'UZ': 9, // Uzbekistan
    'VU': 7, // Vanuatu
    'VA': 8, // Vatican City
    'VE': 10, // Venezuela
    'VN': 10, // Vietnam
    'YE': 9, // Yemen
    'ZM': 9, // Zambia
    'ZW': 9,
  };




  // <<---------------------- Images functionality ------------------>>
  /*
  Future<void> cropImage(BuildContext context,{CropAspectRatioPresetData? initAspectRatio, List<CropAspectRatioPresetData>? aspectRatioPresets }) async {
    if (_pickedFile != null) {
      try {
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: _pickedFile!.path,
          compressFormat: ImageCompressFormat.jpg,
          compressQuality: 100,
          uiSettings: [
            AndroidUiSettings(
              activeControlsWidgetColor: AppColors.primary,
              toolbarTitle: 'Image Cropper',
              toolbarColor: AppColors.primary,
              toolbarWidgetColor: Colors.white,
              initAspectRatio:initAspectRatio ?? CropAspectRatioPresetCustom9x6(),
              statusBarColor: AppColors.primary,
              lockAspectRatio: true,
              aspectRatioPresets: aspectRatioPresets ??  [CropAspectRatioPresetCustom9x6()],
            ),
            IOSUiSettings(
              title: 'Cropper',
              aspectRatioPresets: [
                CropAspectRatioPresetCustom9x6(),
              ],
            ),
            WebUiSettings(
              context: context,
              presentStyle: WebPresentStyle.dialog,
              size: const CropperSize(width: 520, height: 520),
            ),
          ],
        );

        if (croppedFile != null) {
          image.value = File(croppedFile.path);
          final compressedFile = await compressImage(imageFile: image.value!);
          final compressedFileAsFile = File(compressedFile.path);

          final base64String = await convertImageToBase64(compressedFileAsFile);
          if (base64String.isNotEmpty) {
            debugPrint("Base64 Image: --->>>$base64String<<<-----");
            imageBase64.value = base64String;
          } else {
            debugPrint("Failed to convert image to Base64");
          }
        }
      } catch (e) {
        debugPrint("Error during image cropping: $e");
      }
    }
  }
*/

  /*
  Future<void> pickImage(BuildContext context, {required bool isLogo}) async {
    try {
      final XFile? pickedImage =
          await _picker.pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        if (isLogo) {
          logoImage.value = File(croppedFile!.path);
        } else {
          _pickedFile = pickedImage;
        }
        await cropImage(context,aspectRatioPresets:isLogo ?  [CropAspectRatioPresetCustom1x1()] : [CropAspectRatioPresetCustom2x1()],
            initAspectRatio:isLogo ? CropAspectRatioPresetCustom1x1() : CropAspectRatioPresetCustom2x1());
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }
*/

  final ImagePicker _picker = ImagePicker();
  Rx<File?> image = Rx<File?>(null);
  RxString imageBase64 = ''.obs;
  CroppedFile? croppedFile;
  XFile? _pickedFile;
  Rx<File?> logoImage = Rx<File?>(null);
  Rx<File?> coverImage = Rx<File?>(null);

  RxString logoImageBase64 = ''.obs;
  RxString coverImageBase64 = ''.obs;

  Future<void> cropImage(
      BuildContext context, {
        CropAspectRatioPresetData? initAspectRatio,
        List<CropAspectRatioPresetData>? aspectRatioPresets,
        required bool isLogo,
      }) async {
    if (_pickedFile == null) return;

    try {
      croppedFile = await ImageCropper().cropImage(
        sourcePath: _pickedFile?.path ?? "",
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        aspectRatio: isLogo ?  const CropAspectRatio(ratioX: 1, ratioY: 1) :  const CropAspectRatio(ratioX: 9, ratioY: 6),
        uiSettings: [
          AndroidUiSettings(
            activeControlsWidgetColor: AppColors.primary,
            toolbarTitle: 'Image Cropper',
            toolbarColor: AppColors.primary,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: initAspectRatio ?? CropAspectRatioPresetCustom9x6(),
            lockAspectRatio: true,
            aspectRatioPresets: aspectRatioPresets ?? [CropAspectRatioPresetCustom9x6()],
            cropFrameStrokeWidth: 2,
            hideBottomControls: false,
            showCropGrid: false,
            cropFrameColor: AppColors.white,
            cropGridColor: AppColors.white,
          ),
          IOSUiSettings(
            title: 'Cropper',
            aspectRatioPresets: aspectRatioPresets ?? [CropAspectRatioPresetCustom9x6()],
          ),
          WebUiSettings(
            context: context,
            presentStyle: WebPresentStyle.dialog,
            size: const CropperSize(width: 520, height: 520),
          ),
        ],
      );

      if (croppedFile != null) {
        final file = File(croppedFile!.path);
        image.value = file;

        final compressed = await compressImage(imageFile: file);
        final compressedFile = File(compressed.path);

        final base64String = await convertImageToBase64(compressedFile);
        if (base64String.isNotEmpty) {
          // imageBase64.value = base64String;
          if (isLogo) {
            logoImage.value = file;
            logoImageBase64.value = base64String;
          } else {
            coverImage.value = file;
            coverImageBase64.value = base64String;
          }
        }
      }
    } catch (e) {
      debugPrint("Error during image cropping: $e");
    }
  }

  Future<void> pickImage(BuildContext context, {required bool isLogo}) async {
    try {
      final XFile? pickedImage =
      await _picker.pickImage(source: ImageSource.gallery);

      if (pickedImage == null) return;

      _pickedFile = pickedImage;

      // crop according to type
      await cropImage(
        isLogo: isLogo,
        context,
        aspectRatioPresets:
        isLogo ? [CropAspectRatioPresetCustom1x1()] : [CropAspectRatioPresetCustom16x9()],
        initAspectRatio:
        isLogo ? CropAspectRatioPresetCustom1x1() : CropAspectRatioPresetCustom16x9(),
      );

      if (croppedFile != null) {
        final File finalFile = File(croppedFile!.path);

        if (isLogo) {
          // logoImage.value = finalFile;
          logoImage.value = finalFile;
        } else {
          coverImage.value = finalFile;
        }
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  void clearImages() {
    logoImage.value = null;
    coverImage.value = null;
    logoImageBase64.value = '';
    coverImageBase64.value = '';
  }

  Future<String> convertImageToBase64(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final base64String = base64Encode(bytes);
      log(base64String, name: "Base64IMAGE");
      return base64String;
    } catch (e) {
      debugPrint("Error converting image to Base64: $e");
      return '';
    }
  }

  static Future<XFile> compressImage({
    required File imageFile,
    int quality = 35,
    CompressFormat format = CompressFormat.jpeg,
  }) async {
    try {
      final String targetPath =
          p.join(Directory.systemTemp.path, 'temp.${format.name}');
      final XFile? compressedImage =
          await FlutterImageCompress.compressAndGetFile(
        imageFile.path,
        targetPath,
        quality: quality,
        format: format,
      );

      if (compressedImage == null) {
        throw ("Failed to compress the image");
      }

      debugPrint("Compressed Image: ${compressedImage.path}");
      return compressedImage;
    } catch (e) {
      debugPrint("Error during image compression: $e");
      rethrow;
    }
  }

  RxBool isValidAddress = true.obs;
  final List<Predictions> searchPlace = [];
  String? selectedLocation;

  String googleAPIKey = "${dotenv.env['googleAPIKey']}";

  Future<List<Predictions>> searchAutocomplete(String query) async {
    Uri uri =
        Uri.https("maps.googleapis.com", "maps/api/place/autocomplete/json", {
      "input": query,
      "key": googleAPIKey,
    });

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final parse = jsonDecode(response.body);
        if (parse['status'] == "OK") {
          SearchPlaceModel searchPlaceModel = SearchPlaceModel.fromJson(parse);
          return searchPlaceModel.predictions ?? [];
        }
      }
    } catch (err) {
      debugPrint("Error: $err");
    }
    return [];
  }

  Future<void> getLatLang(String address) async {
    List<Location> locations = await locationFromAddress(address);
    if (locations.isNotEmpty) {
      var first = locations.first;
      latitude.value = first.latitude;
      longitude.value = first.longitude;
      debugPrint("Latitude: ${latitude.value}, Longitude: ${longitude.value}");
    }
  }


  String normalizeForDropdown(String value) {
    if (value.isEmpty) return "";

    String v = value.toLowerCase().trim();

    // Remove "min", "minutes", "minute", "mins"
    v = v
        .replaceAll("minutes", "")
        .replaceAll("minute", "")
        .replaceAll("mins", "")
        .replaceAll("min", "")
        .replaceAll(" ", "");

    // Now possible values:
    // 15, 15-20, 20-30

    if (!v.contains("-")) {
      // single value like "15" → return exactly "15"
      return v;
    }

    // Range → convert to "15-20 minutes"
    var parts = v.split("-");
    if (parts.length == 2) {
      return "${parts[0]}-${parts[1]} minutes";
    }

    return value; // fallback
  }


// @override
// void dispose() {
//   for (var controller in shopStartTimeControllers) {
//     controller.clear();
//     controller.dispose();
//   }
//   for (var controller in shopClosedTimeControllers) {
//     controller.clear();
//     controller.dispose();
//
//   }
//   mobNoCon.value.dispose();
//   super.dispose();
// }
}
