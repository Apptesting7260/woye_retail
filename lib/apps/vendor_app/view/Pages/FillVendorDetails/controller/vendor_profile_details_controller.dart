import 'dart:convert';
import 'dart:developer';

import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geocoding/geocoding.dart';
export 'package:country_code_picker/country_code_picker.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../Data/Model/user_model.dart';
import '../../../../../../Data/Repository/repository.dart';
import '../../../../../../Data/response/status.dart';
import '../../../../../../Data/user_preference_controller.dart';
import '../../../../../../Utils/snack_bar.dart';
import '../../../../../../routes/vendor_routes/vendor_app_routes.dart';
import '../../../../../../shared/theme/colors.dart';
import '../../../../../../shared/widgets/vendor_widgets/address_fromgoogle/modal/google_location_model.dart';
import '../../../../../../shared/widgets/vendor_widgets/print.dart';
import '../../Profile/Sub_Screens/Setting/RestaurantInformation/model/register_vendor_model.dart';
import '../model/profile_details_model.dart';

class VendorProfileDetailsController extends GetxController {
  dynamic argumentData = Get.arguments;

  // RxBool isRedClr = false.obs;
  // RxBool isAddressRedClr = false.obs;
  RxBool isImageBorderRedClr = false.obs;

  final shopDetailsKey = GlobalKey<FormState>();

  Rx<TextEditingController> shopNameController = TextEditingController().obs;
  Rx<TextEditingController> shopDescriptionController = TextEditingController().obs;

  // Rx<TextEditingController> addressController = TextEditingController().obs;
  Rx<TextEditingController> ownerNameController = TextEditingController().obs;
  Rx<TextEditingController> lastNameController = TextEditingController().obs;
  Rx<TextEditingController> personalEmailController = TextEditingController().obs;
  Rx<TextEditingController> dobController = TextEditingController().obs;
  Rx<TextEditingController> passwordController = TextEditingController().obs;
  Rx<TextEditingController> confirmPasswordController = TextEditingController().obs;

  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  final locationController = TextEditingController();
  UserModel userModel = UserModel();
  UserPreference pref = UserPreference();

  void getInitData() async {
    userModel = await pref.getUser();
    isImageBorderRedClr.value = false;
    clearHoursFields();
    await getProfileDetailsApi();
  }


  RxInt radioValue = 0.obs;

  RxInt? selectedIndex;
  Rx<TextEditingController> mobNoCon = TextEditingController().obs;
  final RxList<RxBool> isToggleList = List.generate(7, (_) => true.obs).obs;
  final String defaultStartTime = "09:00 AM";
  final String defaultCloseTime = "09:00 PM";

  List<TextEditingController> shopStartTimeControllers =
      List.generate(7, (index) => TextEditingController()).obs;
  List<TextEditingController> shopClosedTimeControllers =
      List.generate(7, (index) => TextEditingController()).obs;

  List<GlobalKey> shopStartTimeKey = List.generate(7, (index) => GlobalKey()).obs;
  List<GlobalKey> shopClosedTimeKey = List.generate(7, (index) => GlobalKey()).obs;
  DateTime parseTime1 = DateTime.now();
  DateTime parseTime2 = DateTime.now();

  String countryValue = " ";
  String stateValue = " ";
  String cityValue = " ";
  String countryCode = "+91";
  RxString selectedDelivery = "".obs;

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

  final registerData = RegisterVendorModel().obs;

  void updateProfileData(RegisterVendorModel value) =>
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
  final GlobalKey firstNameKey = GlobalKey();
  final GlobalKey lastNameKey = GlobalKey();
  final GlobalKey phoneKey = GlobalKey();
  final GlobalKey imageKey = GlobalKey();
  final GlobalKey shopNameKey = GlobalKey();
  final GlobalKey descriptionKey = GlobalKey();
  final GlobalKey addressKey = GlobalKey();
  final GlobalKey selectedDeliveryKey = GlobalKey();
  // RxBool isSubmit = false.obs;

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

  final List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  // RxBool showDialog = false.obs;
  // RxBool isSuspendedDialogShown = false.obs;

  RxString addressError = "".obs;

  //<<---------------------- Get Profile Details ------------------>>
  final profileApiData = VendorProfileDetailsModel().obs;

  void personalDetailsSet(VendorProfileDetailsModel value) => profileApiData.value = value;


  getProfileDetailsApi() async {
    isValidAddress.value =true;
    rxGetProfileRequestStatus(ApiStatus.LOADING);
    api.resGetProfileApi().then((value) async {
      print("PROFILE RESPONSE: $value");

      personalDetailsSet(value);
      debugPrint("profile details: $value");
      if (profileApiData.value.status == true) {
        log("ResProfileDetailsDetailsController here Step ${profileApiData.value.vendor?.step} and Status ${profileApiData.value..vendor?.status}",name: ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
        ownerNameController.value.text = profileApiData.value.vendor?.ownerName ?? "";
        // lastNameController.value.text = profileApiData.value.vendor?.lastName ?? "";
        personalEmailController.value.text = profileApiData.value.vendor?.email ?? "";
        mobNoCon.value.text = profileApiData.value.vendor?.phone ?? "";
        // passwordController.value.text = profileApiData.value.vendor?.pPassword ?? "";
        // confirmPasswordController.value.text = profileApiData.value.vendor?.pPassword ?? "";
        shopNameController.value.text = profileApiData.value.vendor?.shopName ?? "";
        shopDescriptionController.value.text = profileApiData.value.vendor?.description ?? "";
        locationController.text = profileApiData.value.vendor?.address ?? "";
        latitude.value = double.parse(profileApiData.value.vendor?.latitude ?? "0.0");
        longitude.value = double.parse(profileApiData.value.vendor?.longitude ?? "0.0");
        pt("Latitude: ${latitude.value}");
        pt("Longitude: ${longitude.value}");
        selectedDelivery.value = profileApiData.value.vendor?.deliveryRadius ?? "";
        image.value = null;
        rxGetProfileRequestStatus(ApiStatus.COMPLETED);
      }else{
        rxGetProfileRequestStatus(ApiStatus.ERROR);
        Utils.showToast('Error: ${profileApiData.value.status}');
        debugPrint('Error: $error');      }
    }).onError(
      (error, stackTrace) {
        rxGetProfileRequestStatus(ApiStatus.ERROR);
        // Utils.showToast('Error: $error');
        debugPrint('Error: $error');
      },
    );
  }

  // Future<void> closeAllDialogs() async {
  //   while (Get.isDialogOpen ?? false) {
  //     Get.back();
  //     await Future.delayed(const Duration(milliseconds: 1)); // Wait a bit to ensure smooth closing
  //   }
  // }

  Map<String, Map<String, String>> openingHours = {};

  //<<---------------------- Update Profile Details ------------------>>

  updateProfileDetailsApi({
    required String ownerName,
    // required String lastName,
    required String personalEmailAddress,
    required String countryCode,
    required String phoneNumber,
    required String image,
    required String restaurantName,
    required String restaurantDescription,
    required String shopAddress,
    required List<TextEditingController> startTime,
    required List<TextEditingController> closeTime,
  }) async {
    for (int i = 0; i < 7; i++) {
      openingHours[days[i]] = {
        if (isToggleList[i].value == true) "status": "1",
        "open":isToggleList[i].value ? startTime[i].value.text : "",
        "close":isToggleList[i].value ? closeTime[i].value.text : "",
      };
      debugPrint(jsonEncode(openingHours));
    }
    var data = {
      "owner_name": ownerName,
      // "last_name": lastName,
      "email": personalEmailAddress,
      "phone_code": countryCode,
      "phone": phoneNumber,
      "shop_name": restaurantName,
      "description": restaurantDescription,
      "address": shopAddress,
      "opening_hours": openingHours,
      "latitude": latitude.value.toString(),
      "longitude": longitude.value.toString(),
      "logo": image,

      // "delivery" : selectedDelivery.value,
      // "type": userModel.step == 3 ? "update" : "create",
    };
    debugPrint("Data body: $data");
    rxUpdateProfileRequestStatus(ApiStatus.LOADING);
    api.profileDetailsApi(jsonEncode(data)).then((value) {
      updateProfileData(value);
      if (registerData.value.status == true) {
        rxUpdateProfileRequestStatus(ApiStatus.COMPLETED);
        pref.saveStep(int.parse(registerData.value.step.toString()));
        if (userModel.step == 3) {
          getProfileDetailsApi();
          Get.back();
        } else {
          Get.offAndToNamed(VendorAppRoutes.chooseRestaurantCategoriesScreen);
          Utils.showToast(registerData.value.message ?? "Registration successfully completed");
        }
        update();
      } else if (registerData.value.status == false) {
        rxUpdateProfileRequestStatus(ApiStatus.ERROR);
        Utils.showToast(registerData.value.message.toString());
      } else {
        rxUpdateProfileRequestStatus(ApiStatus.ERROR);
        Utils.showToast(registerData.value.message.toString());
      }
    }).onError(
      (error, stackTrace) {
        rxUpdateProfileRequestStatus(ApiStatus.ERROR);
        Utils.showToast(
          error.toString(),
          bgColor: AppColors.red,
        );
        debugPrint('Error: $error');
      },
    );
  }

  void updateCountryCode(CountryCode countryCode) {
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
  final ImagePicker _picker = ImagePicker();
  Rx<File?> image = Rx<File?>(null);
  RxString imageBase64 = ''.obs;
  CroppedFile? croppedFile;
  XFile? _pickedFile;

  Future<void> cropImage(BuildContext context) async {
    if (_pickedFile != null) {
      try {
        // final croppedFile = await ImageCropper().cropImage(
        //   sourcePath: _pickedFile!.path,
        //   aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        //   compressFormat: ImageCompressFormat.jpg,
        //   compressQuality: 100,
        //   uiSettings: [
        //     AndroidUiSettings(
        //       activeControlsWidgetColor: AppColors.primary,
        //       toolbarTitle: 'Image Cropper',
        //       toolbarColor: AppColors.primary,
        //       toolbarWidgetColor: Colors.white,
        //       initAspectRatio:CropAspectRatioPresetCustom1x1(),
        //       statusBarColor: AppColors.primary,
        //       lockAspectRatio: true,
        //       aspectRatioPresets: [CropAspectRatioPresetCustom1x1()],
        //     ),
        //     IOSUiSettings(
        //       title: 'Cropper',
        //       aspectRatioPresets: [
        //         CropAspectRatioPresetCustom1x1(),
        //       ],
        //     ),
        //     WebUiSettings(
        //       context: context,
        //       presentStyle: WebPresentStyle.dialog,
        //       size: const CropperSize(width: 520, height: 520),
        //     ),
        //   ],
        // );
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: _pickedFile!.path,
          aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
          compressQuality: 100,
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Image Cropper',
              toolbarColor: AppColors.primary,
              toolbarWidgetColor: Colors.white,
              activeControlsWidgetColor: AppColors.primary,
              lockAspectRatio: true,
              aspectRatioPresets: [CropAspectRatioPreset.square],
              initAspectRatio: CropAspectRatioPreset.square,
              statusBarColor: AppColors.primary,
            ),
            IOSUiSettings(
              title: 'Cropper',
              aspectRatioPresets: [
                CropAspectRatioPreset.square,
              ],
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

  Future<void> pickImage(BuildContext context) async {
    try {
      final XFile? pickedImage =
          await _picker.pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        _pickedFile = pickedImage;
        await cropImage(context);
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
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
          minWidth: 200,
          minHeight: 200,
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

  void clearHoursFields() {
    if (userModel.step != 3) {
      for (int i = 0; i < 7; i++) {
        shopStartTimeControllers[i].text = defaultStartTime;
        shopClosedTimeControllers[i].text = defaultCloseTime;
        isToggleList[i].value = true;
      }
    }
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
