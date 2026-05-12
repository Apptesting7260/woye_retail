import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/ChooseVendorCategories/model/new_categories_model.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/Profile/Sub_Screens/Setting/RestaurantInformation/model/profile_details_model.dart';
import 'package:intl/intl.dart';

import '../../../../../../../../Data/Model/user_model.dart';
import '../../../../../../../../Data/Repository/repository.dart';
import '../../../../../../../../Data/response/api_response.dart';
import '../../../../../../../../Data/response/status.dart';
import '../../../../../../../../Data/user_preference_controller.dart';
import '../../../../../../../../Utils/date_format.dart';
import '../../../../../../../../Utils/sized_box.dart';
import '../../../../../../../../Utils/snack_bar.dart';
import '../../../../../../../../shared/theme/colors.dart';
import '../../../../../../../../shared/theme/font_family.dart';
import '../../../../../../../../shared/theme/font_style.dart';
import '../../../../../../../../shared/widgets/custom_elevated_button.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/custom_confirm_password_dialog.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/print.dart';
import '../../../../../vendor_common/Models/common_add_product_model.dart';
import '../../../../../vendor_common/Models/common_response_model.dart';
import '../AddMenuCategories/model/restaurant_get_selected_categories_model.dart';

class  RestaurantSettingController extends GetxController {

  UserModel userModel = UserModel();

  final api = Repository();

  UserPreference pref = UserPreference();


  RxString TimeError = "".obs;

  SetTimeError (String value){
    TimeError.value = value;
    update();
  }

  RxList<int> selectedCuisineIds = <int>[].obs;

  void getInitData() async {
    userModel = await pref.getUser();
    clearHoursFields();
    await getProfileDetailsApi();
  }

  final rxGetProfileRequestStatus = ApiStatus.COMPLETED.obs;
  void personalDetailsSet(ProfileDetailsModel value) =>
      profileApiData.value = value;
  final profileApiData = ProfileDetailsModel().obs;
  RxString error = ''.obs;

  void setError(String value) => error.value = value;

  getProfileDetailsApi({bool isRefresh = true}) async {
    if(isRefresh == true) {
      rxGetProfileRequestStatus(ApiStatus.LOADING);
    }
    api.getProfileApi().then((value) async {
      personalDetailsSet(value);
      debugPrint("profile details: $value");
      if (profileApiData.value.status == true) {
        pt("res setting controller here Step ${profileApiData.value.vendor?.step} and Status ${profileApiData.value.vendor?.status}",name: ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
        final vendor =  profileApiData.value.vendor;
        pt(vendor?.website.toString() ??"",name: "Profile information");
        setApiWorkingHoursFromProfile();
        calculateActiveRate();
        allCategories.value = profileApiData.value.vendor?.categoryIds ?? <CategoryIds>[];
        activeCategories.value = allCategories.where((cat) => cat.status == "1").toList();
        inactiveCategories.value = allCategories.where((cat) => cat.status != "1").toList();
        selectedCuisineIds.value = profileApiData.value.vendor?.cuisineIds?.map((e) => int.parse(e.id.toString())).toList() ?? [];
        rxGetProfileRequestStatus(ApiStatus.COMPLETED);
        captureInitialState();
        if (profileApiData.value.vendor?.step == '3' && (profileApiData.value.vendor?.status == 'suspended' || profileApiData.value.vendor?.status == 'inactive'|| profileApiData.value.vendor?.status == 'pending')) {
          await closeAllDialogs();
          if (profileApiData.value.vendor?.status == 'suspended') {
            Get.dialog(
              const CustomConfirmPasswordDialog(
                isError: true,
                title: "Account Suspended",
                subTitle: "Your account has been suspended.",
                isContactBtn: true,
              ),
              barrierDismissible: false,
            );
          } else if (profileApiData.value.vendor?.status == 'pending') {
            Get.dialog(
              const CustomConfirmPasswordDialog(
                isError: true,
                title: "Under Approval",
                subTitle:
                "Your account is not activated, wait for admin approval",
                isContactBtn: false,
              ),
              barrierDismissible: false,
            );
          }else if ( profileApiData.value.vendor?.status == 'inactive') {
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
        } else {
          await closeAllDialogs();
        }
      }else{
        setError(error.toString());
        rxGetProfileRequestStatus(ApiStatus.COMPLETED);
      }
    }).onError((error, stackTrace) {
        setError(error.toString());
        rxGetProfileRequestStatus(ApiStatus.ERROR);
        // Utils.showToast('Error: $error');
        debugPrint('Error res setting contre: $error');
      },
    );
  }

  void setEmergencyService24x7() {
    const String open = "12:00 AM";
    const String close = "11:59 PM";

    for (int i = 0; i < 7; i++) {
      openingTimes[i] = open;
      closingTimes[i] = close;

      shopStartTimeControllers[i].text = open;
      shopClosedTimeControllers[i].text = close;

      isSwitchActive[i].value = true;
      isToggleList[i].value = false;
    }

    update();
  }

  ///----------------------------------------------------------------------------------Update Configuration

  final Rx<ApiResponse<CommonAddProductModel>> _updateConfiguration = Rx<ApiResponse<CommonAddProductModel>>(ApiResponse.completed(null));
  Rx<ApiResponse<CommonAddProductModel>> get updateConfiguration => _updateConfiguration;
  setUpdateConfiguration(ApiResponse<CommonAddProductModel> response)=> _updateConfiguration.value = response;

  Future<void> updateConfigurationApi()async{
    setUpdateConfiguration(ApiResponse.loading());
    var openingHours = generateOpeningHoursPayloadForApi();
    pt(jsonEncode(openingHours),name: "openingHours>>>before>>>" );
    var category = sendCategoriesToApi();

    var data = {
      "category_ids": category,
      "opening_hours": openingHours,
      "cuisine_ids": selectedCuisineIds
    };

    pt(data.toString(),name: "data>>>body>>>");


    api.configurationUpdate(jsonEncode(data)).then((value) {
      if(value.status == true){
        setUpdateConfiguration(ApiResponse.completed(value));
        getProfileDetailsApi(isRefresh: false).then((_) {
          resetUnsavedChanges(); // Reset after successful save
        });
        if(selectedCategories.isNotEmpty) {
          selectedCategories.clear();
        }
        Utils.showToast(value.message ?? '');
      }else{
        Utils.showToast(value.message ?? "");
        setUpdateConfiguration(ApiResponse.error(value.message.toString()));
      }
    },).onError(
          (error, stackTrace) {
            setUpdateConfiguration(ApiResponse.error(error.toString()));
        debugPrint('Error: $error');
      },
    );

  }

  ///----------------------------------------------------------------------------------


  RxList<CategoryIds> activeCategories = <CategoryIds>[].obs;
  RxList<CategoryIds> inactiveCategories = <CategoryIds>[].obs;
  RxList<CategoryIds> allCategories = <CategoryIds>[].obs;

  void toggleCategoryStatus(CategoryIds category, bool newStatus) {
    category.status = newStatus ? "1" : "0";
    allCategories.value = profileApiData.value.vendor?.categoryIds ?? [];
    activeCategories.value = allCategories.where((cat) => cat.status == "1").toList();
    inactiveCategories.value = allCategories.where((cat) => cat.status != "1").toList();
    onDataChanged(); // Single method call
  }

  Future<void> closeAllDialogs() async {
    while (Get.isDialogOpen ?? false) {
      Get.back();
      await Future.delayed(const Duration(milliseconds: 1)); // Wait a bit to ensure smooth closing
    }
  }

  double calculateActiveRate() {
    final categories = profileApiData.value.vendor?.categoryIds;
    if (categories == null || categories.isEmpty) return 0.0;

    int activeCount = categories.where((cat) => cat.status == "1").length;
    return (activeCount / categories.length) * 100;
  }

///----------------------------------------------------------------------------------Add menu categories screen
  final List<String> categoryList = ['Select Categories','Request Category'];
  final ScrollController scrollCatController = ScrollController();
  final ScrollController scrollReqCatController = ScrollController();

  RxInt selectedTypeIndex = 0.obs;

  void updateSelectedType(int index){
    selectedTypeIndex.value = index;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (index == 0) {
        scrollToTop(scrollCatController);
      } else {
        scrollToTop(scrollReqCatController);
      }
    });
  }

  scrollToTop(ScrollController controller){
    controller.animateTo(0, duration: const Duration(milliseconds: 100), curve: Curves.bounceInOut);
  }

  RxString searchQuery = "".obs;

  RxList<Map<String, dynamic>> selectedCategories = <Map<String, dynamic>>[].obs;

  void toggleCategorySelection(Map<String, dynamic> category) {
    int index = selectedCategories.indexWhere((e) => e['id'] == category['id']);

    if (index >= 0) {
      selectedCategories.removeAt(index);
    } else {
      selectedCategories.add({
        "id": category["id"],
        "name": category["name"],
        "status": "1",
        "added": FormatDate.formatDate(DateTime.now()),
      });
    }
    pt("Selected Categories>>>>>>>>>>>> $selectedCategories");
  }


  void appendSelectedCategoriesToProfile() {
    final vendor = profileApiData.value.vendor;

    if (vendor == null) return;

    List<CategoryIds> newItems = selectedCategories.map((e) {
      return CategoryIds(
        id: e["id"].toString(),
        name: e["name"].toString(),
        status: e["status"].toString(),
        added: e["added"].toString(),
      );
    }).toList();

    vendor.categoryIds ??= [];

    bool hasNewCategories = false;

    for (var item in newItems) {
      bool exists = vendor.categoryIds!.any((x) => x.id == item.id);
      if (!exists) {
        vendor.categoryIds!.add(item);
        hasNewCategories = true;
      }
    }

    if (hasNewCategories) {
      // Refresh UI
      profileApiData.refresh();

      // Update the lists
      allCategories.value = profileApiData.value.vendor?.categoryIds ?? [];
      activeCategories.value = allCategories.where((cat) => cat.status == "1").toList();
      inactiveCategories.value = allCategories.where((cat) => cat.status != "1").toList();

      // IMPORTANT: Call onDataChanged to detect changes
      onDataChanged();

      pt("Updated Categories in Profile >>> ${vendor.categoryIds!.map((e) => e.toJson()).toList()}");
    }
  }

  // List<Map<String, dynamic>>? sendCategoriesToApi() {
  //   final vendor = profileApiData.value.vendor;
  //
  //   if (vendor == null || vendor.categoryIds == null) return null;
  //
  //   final List<Map<String, dynamic>> finalList =
  //   vendor.categoryIds!.map((e) {
  //     final data = e.toJson();
  //
  //     // REMOVE NAME IF EXISTS
  //     data.remove("name");
  //
  //     return data;
  //   }).toList();
  //
  //
  //   pt("FINAL API BODY category>>>>>>> $finalList");
  //
  //   return finalList;
  // }
  List<Map<String, dynamic>>? sendCategoriesToApi() {
    final vendor = profileApiData.value.vendor;

    if (vendor == null || vendor.categoryIds == null) return null;

    final List<Map<String, dynamic>> finalList =
    vendor.categoryIds!.map((e) {
      final data = e.toJson();

      // REMOVE NAME IF EXISTS
      data.remove("name");

      // FORCE CONVERT id & status TO INT
      data["id"] = int.tryParse("${data["id"]}") ?? data["id"];
      data["status"] = int.tryParse("${data["status"]}") ?? data["status"];

      return data;
    }).toList();

    pt("FINAL API BODY category>>>>>>> $finalList");

    return finalList;
  }


  final Rx<ApiResponse<GetSelCategoryModel>>  _selCategoryData = Rx<ApiResponse<GetSelCategoryModel>>(ApiResponse.completed(null));
  Rx<ApiResponse<GetSelCategoryModel>> get selCategoryData => _selCategoryData;
  setSelectedCategories(ApiResponse<GetSelCategoryModel> response)=> _selCategoryData.value = response;

  Future<void> getSelectedCategory()async{
    setSelectedCategories(ApiResponse.loading());

    api.getSelectedCategory().then((value) {
      if(value.status == true){
        setSelectedCategories(ApiResponse.completed(value));
        filteredList.value = value.categories ?? [];
      }else{
        setSelectedCategories(ApiResponse.error(value.message));
      }
    },
    ).onError((error, stackTrace) {
      setSelectedCategories(ApiResponse.error(error.toString()));
      debugPrint('Error: $error');
      },
    );

  }

  RxList<Categories> filteredList = <Categories>[].obs;
  final searchController = TextEditingController().obs;

  void filterCategories(String value) {
    searchQuery.value = value;

    final allCategories = selCategoryData.value.data?.categories ?? [];

    if (value.isEmpty) {
      filteredList.value = allCategories;
      return;
    }

    filteredList.value = allCategories
        .where((cat) =>
        (cat.name ?? "").toLowerCase().contains(value.toLowerCase()))
        .toList();
  }


  void clearSearch() {
    searchController.value.clear();
    searchQuery.value = "";
    filteredList.value = selCategoryData.value.data?.categories ?? [];
  }

  ///----------------------------------------------------------------------------------delete category

  final Rx<ApiResponse<CommonResponseModel>>  _deleteCategoryData = Rx<ApiResponse<CommonResponseModel>>(ApiResponse.completed(null));
  Rx<ApiResponse<CommonResponseModel>> get deleteCategoryData => _deleteCategoryData;
  setDeleteCategories(ApiResponse<CommonResponseModel> response)=> _deleteCategoryData.value = response;

  Future<void> deleteCategoryApi(String catId)async{
    setDeleteCategories(ApiResponse.loading());
    var data = {
      "id" : catId
    };

    api.deleteCategory(data).then((value) {
      if(value.status == true){
        setDeleteCategories(ApiResponse.completed(value));
        Utils.showToast(value.message ?? "");
        getProfileDetailsApi(isRefresh: false);
        Get.back();
      }else{
        setDeleteCategories(ApiResponse.error(value.message));
        Utils.showToast(value.message ?? "");
      }
    },
    ).onError((error, stackTrace) {
      setDeleteCategories(ApiResponse.error(error.toString()));
      debugPrint('Error: $error');
    },
    );

  }


  RxBool isLocalDeleting = false.obs;

  void deleteCategory(String categoryId, {Map<String, dynamic>? categoryData}) {
    try {
      bool removedFromSelection = selectedCategories.any((e) => e['id'] == categoryId);

      if (removedFromSelection) {
        isLocalDeleting.value = true;
        Future.delayed(const Duration(milliseconds: 500), () {
        selectedCategories.removeWhere((e) => e['id'] == categoryId);
        pt("✅ Removed category $categoryId from selected categories");
        Utils.showToast("Category removed successfully.");
        isLocalDeleting.value = false;
        selectedCategories.refresh();
        Get.back();
        });
      } else {
        deleteCategoryApi(categoryId);
      }
      _removeFromProfileData(categoryId);
    } catch (e) {
      isLocalDeleting.value = false;
      pt("Error deleting category: $e");
      Utils.showToast( "Failed to delete category");
    }
  }

  void _removeFromProfileData(String categoryId) {
    try {
      // Create a new list to trigger observable update
      final currentCategories = profileApiData.value.vendor?.categoryIds ?? [];
      final updatedCategories = currentCategories.where((category) => category.id != categoryId).toList();

      profileApiData.value.vendor?.categoryIds = updatedCategories;

      // Force UI update
      profileApiData.refresh();

      // Also update the allCategories observable list
      allCategories.value = updatedCategories;
      activeCategories.value = updatedCategories.where((cat) => cat.status == "1").toList();
      inactiveCategories.value = updatedCategories.where((cat) => cat.status != "1").toList();

      onDataChanged();

      pt("✅ Removed category $categoryId from profile data");

    } catch (e) {
      pt("Error removing from profile data: $e");
    }
  }

  ///----------------------------------------------------------------------------------New category

  Rx<TextEditingController> catNameController = TextEditingController().obs;
  Rx<TextEditingController> catDescriptionController = TextEditingController().obs;
  Rx<TextEditingController> businessJustificationController  = TextEditingController().obs;
  RxString selectedDepartment = "".obs;
  RxString selectedPriority = "".obs;

  var isSubmitted = false.obs;

  final Rx<ApiResponse<NewCategoriesModel>>  _newCategoriesData = Rx<ApiResponse<NewCategoriesModel>>(ApiResponse.completed(null));
  Rx<ApiResponse<NewCategoriesModel>> get newCategoriesData => _newCategoriesData;
  newCategoriesSet(ApiResponse<NewCategoriesModel> response)=> _newCategoriesData.value = response;

  newCategoryRequestApi() async {
    newCategoriesSet(ApiResponse.loading());
    final data = {
      "name": catNameController.value.text,
      // "department": "Food & Beverages",
      "description": catDescriptionController.value.text,
      "business_justification": businessJustificationController.value.text,
      "priority": selectedPriority.value.toLowerCase()
    };
    api.newCategoriesApi(data).then((value) {
      newCategoriesSet(ApiResponse.completed(value));
      if (value.status == true) {
        newCategoriesSet(ApiResponse.completed(value));
        showDialog(
          barrierDismissible: false,
          context: Get.context!,
          builder: (context) {
            return CustomConfirmPasswordDialog(
              isTitle: false,
              isError: true,
              isShowCloseBtn: true,
              subTitle: "Your request has been sent wait for admin approval.",
              subtitleTxtStyle: AppFontStyle.text_16_400(
                AppColors.darkText,
                fontFamily: AppFontFamily.gilroyRegular,
              ),
              onTap: () {
                isSubmitted.value = true;
                catNameController.value.clear();
                catDescriptionController.value.clear();
                businessJustificationController.value.clear();
                selectedPriority.value = "";
                Get.back();
              },
            );
          },
        );
      }
      else {
        newCategoriesSet(ApiResponse.error(value.message));
        Utils.showToast(value.message);
      }
    }).onError((error, stackTrace) {
      newCategoriesSet(ApiResponse.error(error.toString()));
      // Utils.showToast('Error: $error');
        pt('Error: $error');
      },
    );
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey nameKey = GlobalKey();

  void scrollToFields(GlobalKey key){
    final context = key.currentContext;
    if(context != null){
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: 0.5,
      );
    }
  }

  ///----------------------------------------------------------------------------------Opening hours
  // Days
  List<String> days = [
    "Monday", "Tuesday", "Wednesday", "Thursday",
    "Friday", "Saturday", "Sunday"
  ];

  /// -------------------- FORM KEYS --------------------
  List<GlobalKey<FormState>> formKeys =
  List.generate(7, (index) => GlobalKey<FormState>());

  /// -------------------- SWITCH ON/OFF --------------------
  RxList<RxBool> isSwitchActive =
      List.generate(7, (index) => false.obs).obs;

  /// -------------------- EDIT MODE --------------------
  RxList<RxBool> isToggleList =
      List.generate(7, (index) => false.obs).obs;

  /// -------------------- CONTROLLERS --------------------
  RxList<TextEditingController> shopStartTimeControllers =
      List.generate(7, (index) => TextEditingController()).obs;

  RxList<TextEditingController> shopClosedTimeControllers =
      List.generate(7, (index) => TextEditingController()).obs;

  /// -------------------- STORED DISPLAY VALUES --------------------
  RxList<String> openingTimes = List.generate(7, (index) => "").obs;
  RxList<String> closingTimes = List.generate(7, (index) => "").obs;

  /// -------------------- FOR RESET FEATURE --------------------
  List<String> apiOpeningTimes = List.generate(7, (index) => "");
  List<String> apiClosingTimes = List.generate(7, (index) => "");

  /// -------------------- VALIDATION KEYS --------------------
  RxList<GlobalKey<FormFieldState>> shopStartTimeKey =
      List.generate(7, (index) => GlobalKey<FormFieldState>()).obs;

  RxList<GlobalKey<FormFieldState>> shopClosedTimeKey =
      List.generate(7, (index) => GlobalKey<FormFieldState>()).obs;

  RxList<GlobalKey> dayContainerKeys = List.generate(7, (index) => GlobalKey()).obs;
  String errorMessage = "";

  void scrollToDay(int index) {
    final key = dayContainerKeys[index];
    if (key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        alignment: 0.005, // Adjust this value as needed
      );
    }
  }
  /// ---------------------- SET API VALUES -----------------------
  ///
  /// Store original switch states from API for reset functionality
  List<bool> apiSwitchStates = List.generate(7, (index) => false);

  void setApiWorkingHoursFromProfile() {
    var openingHour = profileApiData.value.vendor?.openingHours;

    if (openingHour != null) {
      for (int i = 0; i < 7; i++) {
        String day = days[i];
        bool isOpen = false;
        String openTime = "";
        String closeTime = "";

        switch (day) {
          case 'Sunday':
            isOpen = openingHour.sunday?.status == "1";
            openTime = openingHour.sunday?.open ?? "";
            closeTime = openingHour.sunday?.close ?? "";
            break;
          case 'Monday':
            isOpen = openingHour.monday?.status == "1";
            openTime = openingHour.monday?.open ?? "";
            closeTime = openingHour.monday?.close ?? "";
            break;
          case 'Tuesday':
            isOpen = openingHour.tuesday?.status == "1";
            openTime = openingHour.tuesday?.open ?? "";
            closeTime = openingHour.tuesday?.close ?? "";
            break;
          case 'Wednesday':
            isOpen = openingHour.wednesday?.status == "1";
            openTime = openingHour.wednesday?.open ?? "";
            closeTime = openingHour.wednesday?.close ?? "";
            break;
          case 'Thursday':
            isOpen = openingHour.thursday?.status == "1";
            openTime = openingHour.thursday?.open ?? "";
            closeTime = openingHour.thursday?.close ?? "";
            break;
          case 'Friday':
            isOpen = openingHour.friday?.status == "1";
            openTime = openingHour.friday?.open ?? "";
            closeTime = openingHour.friday?.close ?? "";
            break;
          case 'Saturday':
            isOpen = openingHour.saturday?.status == "1";
            openTime = openingHour.saturday?.open ?? "";
            closeTime = openingHour.saturday?.close ?? "";
            break;
        }

        /// save API data for future reset()
        apiOpeningTimes[i] = openTime;
        apiClosingTimes[i] = closeTime;
        apiSwitchStates[i] = isOpen;

        /// update UI lists
        openingTimes[i] = openTime;
        closingTimes[i] = closeTime;

        /// switch ON only if both time exist
        // isSwitchActive[i].value =
        //     isOpen && openTime.isNotEmpty && closeTime.isNotEmpty;
        isSwitchActive[i].value = isOpen;
        /// edit mode off
        isToggleList[i].value = false;

        /// prefill text controllers
        shopStartTimeControllers[i].text = openTime;
        shopClosedTimeControllers[i].text = closeTime;
      }
    }
  }

  /// ---------------------- SWITCH CHANGE -----------------------
  // void toggleSwitch(int index, bool value) {
  //   isSwitchActive[index].value = value;
  //
  //   if (value) {
  //     /// SWITCH ON
  //     if (openingTimes[index].isEmpty || closingTimes[index].isEmpty) {
  //       isToggleList[index].value = true; // open edit
  //     } else {
  //       isToggleList[index].value = false; // keep showing text
  //     }
  //   } else {
  //     /// SWITCH OFF
  //     isToggleList[index].value = false;
  //
  //     // clear only the controller UI values
  //     shopStartTimeControllers[index].text = "";
  //     shopClosedTimeControllers[index].text = "";
  //   }
  // }

  void toggleSwitch(int index, bool value) {
    isSwitchActive[index].value = value;

    if (value) {
      /// SWITCH ON

      String start = shopStartTimeControllers[index].text.trim();
      String end = shopClosedTimeControllers[index].text.trim();

      // ✅ Agar controllers empty hain → openingTimes se refill karo (API data)
      if (start.isEmpty && end.isEmpty) {
        shopStartTimeControllers[index].text = openingTimes[index];
        shopClosedTimeControllers[index].text = closingTimes[index];
      }

      // ✅ Decide edit mode
      if (shopStartTimeControllers[index].text.isNotEmpty &&
          shopClosedTimeControllers[index].text.isNotEmpty) {
        isToggleList[index].value = false; // show text
      } else {
        isToggleList[index].value = true; // open edit
      }
    } else {
      /// SWITCH OFF
      isToggleList[index].value = false;
    }

    TimeError.value = "";
    onDataChanged(); // Single method call
  }

  /// ---------------------- ENABLE EDIT -----------------------
  void enableEditMode(int index) {
    if (isSwitchActive[index].value) {
      shopStartTimeControllers[index].text = openingTimes[index];
      shopClosedTimeControllers[index].text = closingTimes[index];
      isToggleList[index].value = true;
      onDataChanged(); // Single method call
    }
  }

  // For cuisine selection
  void toggleCuisineSelection(int id, bool isSelected) {
    if (isSelected) {
      selectedCuisineIds.add(id);
    } else {
      selectedCuisineIds.remove(id);
    }
    onDataChanged(); // Single method call
  }

  /// ---------------------- SAVE LOGIC -----------------------
  bool saveTiming(int index) {
    openingTimes[index] = shopStartTimeControllers[index].text;
    closingTimes[index] = shopClosedTimeControllers[index].text;

    isSwitchActive[index].value = true;
    isToggleList[index].value = false;

    onDataChanged(); // Single method call
    update();
    return true;
  }

  /// ---------------------- CANCEL LOGIC -----------------------
  void cancelEdit(int index) {
    shopStartTimeControllers[index].text = openingTimes[index];
    shopClosedTimeControllers[index].text = closingTimes[index];
    isToggleList[index].value = false;

    if (openingTimes[index].isEmpty && closingTimes[index].isEmpty) {
      isSwitchActive[index].value = false;
    }
    onDataChanged(); // Single method call
    update();
  }

  /// ---------------------- COPY TO ALL DAYS -----------------------
  void copyToAllDays() {
    int index = openingTimes.indexWhere((e) => e.isNotEmpty);

    if (index == -1) {
      Get.snackbar("Alert", "Please enter at least one day's time");
      return;
    }

    String open = openingTimes[index];
    String close = closingTimes[index];

    for (int i = 0; i < 7; i++) {
      openingTimes[i] = open;
      closingTimes[i] = close;

      shopStartTimeControllers[i].text = open;
      shopClosedTimeControllers[i].text = close;

      isSwitchActive[i].value = true;
      isToggleList[i].value = false;
    }

    onDataChanged(); // Single method call


    update();
  }

  /// ---------------------- RESET TO DEFAULT -----------------------
  // void resetToDefault() {
  //   bool apiHasData = apiOpeningTimes.any((t) => t.isNotEmpty);
  //
  //   if (apiHasData) {
  //     /// RESTORE API DATA
  //     for (int i = 0; i < 7; i++) {
  //       openingTimes[i] = apiOpeningTimes[i];
  //       closingTimes[i] = apiClosingTimes[i];
  //
  //       shopStartTimeControllers[i].text = apiOpeningTimes[i];
  //       shopClosedTimeControllers[i].text = apiClosingTimes[i];
  //
  //       isSwitchActive[i].value = apiOpeningTimes[i].isNotEmpty;
  //       isToggleList[i].value = false;
  //     }
  //   } else {
  //     /// CLEAR EVERYTHING
  //     for (int i = 0; i < 7; i++) {
  //       openingTimes[i] = "";
  //       closingTimes[i] = "";
  //       shopStartTimeControllers[i].clear();
  //       shopClosedTimeControllers[i].clear();
  //       isSwitchActive[i].value = false;
  //       isToggleList[i].value = false;
  //     }
  //   }
  //   onDataChanged(); // Single method call
  //   update();
  // }
  void resetToDefault() {
    bool apiHasData = apiOpeningTimes.any((t) => t.isNotEmpty);

    if (apiHasData) {
      /// RESTORE API DATA - Restore times AND switch states from original API
      for (int i = 0; i < 7; i++) {
        // Restore times
        openingTimes[i] = apiOpeningTimes[i];
        closingTimes[i] = apiClosingTimes[i];

        // Restore controllers
        shopStartTimeControllers[i].text = apiOpeningTimes[i];
        shopClosedTimeControllers[i].text = apiClosingTimes[i];

        // Restore switch state from stored API status
        isSwitchActive[i].value = apiSwitchStates[i];
        isToggleList[i].value = false;
      }
    } else {
      /// CLEAR EVERYTHING
      for (int i = 0; i < 7; i++) {
        openingTimes[i] = "";
        closingTimes[i] = "";
        shopStartTimeControllers[i].clear();
        shopClosedTimeControllers[i].clear();
        isSwitchActive[i].value = false;
        isToggleList[i].value = false;
        apiSwitchStates[i] = false;
      }
    }
    onDataChanged();
    update();
  }
  // Map<String, dynamic> generateOpeningHoursPayloadForApi() {
  //   Map<String, dynamic> data = {};
  //
  //   for (int i = 0; i < days.length; i++) {
  //     String day = days[i];
  //
  //     bool saved = isSwitchActive[i].value;
  //     bool editing = isToggleList[i].value;
  //     String start = openingTimes[i];
  //     String end = closingTimes[i];
  //
  //     // ------------------------------------------------------
  //     // CASE 1: SAVE NOT PRESSED → STATUS = 0
  //     // ------------------------------------------------------
  //     if (!saved) {
  //       data[day] = {
  //         "status": "0",
  //         "open": null,
  //         "close": null
  //       };
  //       continue;
  //     }
  //
  //     // ------------------------------------------------------
  //     // CASE 2: SAVE PRESSED → STATUS = 1 + VALID TIMES
  //     // ------------------------------------------------------
  //     data[day] = {
  //       "status": "1",
  //       "open": start,
  //       "close": end,
  //     };
  //   }
  //
  //   return data;
  // }

  Map<String, dynamic> generateOpeningHoursPayloadForApi() {
    Map<String, dynamic> data = {};

    for (int i = 0; i < days.length; i++) {
      String day = days[i];

      bool isActive = isSwitchActive[i].value;
      String start = openingTimes[i];
      String end = closingTimes[i];

      if (isActive) {
        // Day is OPEN - send status 1 with times
        data[day] = {
          "status": "1",
          "open": start.isNotEmpty ? start : null,
          "close": end.isNotEmpty ? end : null,
        };
      } else {
        // Day is CLOSED - send status 0 BUT ALSO send the times (preserve them)
        data[day] = {
          "status": "0",
          "open": start.isNotEmpty ? start : null,  // Send time even if closed
          "close": end.isNotEmpty ? end : null,      // Send time even if closed
        };
      }
    }

    return data;
  }

  clearHoursFields(){
    if(userModel.step != 3 ){
      for (var controller in shopStartTimeControllers) {
        controller.clear();
      }
      for (var controller in shopClosedTimeControllers) {
        controller.clear();
      }
      for (var isToggle in isToggleList) {
        isToggle.value = false;
      }
      debugPrint("clear fields");
    }
  }
  ///----------------------------------------------------------------------------------Opening hours

  // Add this observable to track if there are unsaved changes
  RxBool hasUnsavedChanges = false.obs;

  // Store initial state as JSON string for easy comparison
  String _initialStateHash = '';

  // Single method to capture initial state
  void captureInitialState() {
    _initialStateHash = _getCurrentStateHash();
    hasUnsavedChanges.value = false;
  }

  // Single method to get current state hash
  String _getCurrentStateHash() {
    final currentState = {
      'categories': _serializeCategoriesForComparison(),
      'opening_hours': _serializeOpeningHoursForComparison(),
      'cuisine_ids': List<int>.from(selectedCuisineIds),
    };
    return jsonEncode(currentState);
  }

  // Single method to check for any changes
  void checkForChanges() {
    final currentStateHash = _getCurrentStateHash();
    hasUnsavedChanges.value = currentStateHash != _initialStateHash;
  }

  // Serialize categories
  List<Map<String, dynamic>> _serializeCategoriesForComparison() {
    final vendor = profileApiData.value.vendor;
    if (vendor == null || vendor.categoryIds == null) return [];

    return vendor.categoryIds!.map((e) {
      return {
        'id': e.id,
        'status': e.status,
      };
    }).toList();
  }

  // Serialize opening hours
  Map<String, Map<String, dynamic>> _serializeOpeningHoursForComparison() {
    Map<String, Map<String, dynamic>> hours = {};

    for (int i = 0; i < days.length; i++) {
      String day = days[i];
      hours[day] = {
        'status': isSwitchActive[i].value,
        'open': openingTimes[i],
        'close': closingTimes[i],
      };
    }

    return hours;
  }

  // Single method to handle navigation with confirmation
  Future<bool> onWillPop() async {
    if (hasUnsavedChanges.value) {
      final result = await Get.dialog<bool>(
        PopScope(
          canPop: false,
          child: AlertDialog(
            backgroundColor: AppColors.white,
            surfaceTintColor: AppColors.white,
            insetPadding: const EdgeInsets.symmetric(horizontal: 22),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            contentPadding: EdgeInsets.zero,
            content: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      hBox(20.h),

                      // Warning Icon
                      Container(
                        padding: EdgeInsets.all(16.r),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withAlpha(20),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.warning_rounded,
                          color: AppColors.primary,
                          size: 40.sp,
                        ),
                      ),

                      hBox(20.h),

                      // Title
                      Text(
                        "Unsaved Changes",
                        style: AppFontStyle.text_22_400(
                          AppColors.darkText,
                          fontFamily: AppFontFamily.gilroySemiBold,
                        ),
                      ),

                      hBox(10.h),

                      // Subtitle
                      Text(
                        "You have unsaved changes. Do you want to save before leaving?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.mediumText,
                          fontFamily: AppFontFamily.gilroyRegular,
                        ),
                        maxLines: 2,
                      ),

                      hBox(24.h),

                      // Buttons Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Discard Button
                          Expanded(
                            child: CustomElevatedButton(
                              onPressed: () => Get.back(result: false),
                              height: 55,
                              width: double.infinity,
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: AppColors.borderClr),
                              color: AppColors.white,
                              child: Text(
                                "Discard",
                                style: AppFontStyle.text_16_400(
                                  AppColors.blackClr,
                                  fontFamily: AppFontFamily.gilroySemiBold,
                                ),
                              ),
                            ),
                          ),
                          wBox(12.w),
                          // Save Button
                          Expanded(
                            child: CustomElevatedButton(
                              onPressed: ()async {
                                await updateConfigurationApi().then((value) {
                                  Get.back(result: true);
                                },);
                              },
                              height: 55,
                              width: double.infinity,
                              borderRadius: BorderRadius.circular(12),
                              color: AppColors.primary,
                              child: Text(
                                "Save",
                                style: AppFontStyle.text_16_400(
                                  AppColors.white,
                                  fontFamily: AppFontFamily.gilroySemiBold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      hBox(12.h),

                      // Cancel Button
                      TextButton(
                        onPressed: () => Get.back(result: null),
                        child: Text(
                          "Cancel",
                          style: AppFontStyle.text_14_400(
                            AppColors.greyClr,
                            fontFamily: AppFontFamily.gilroyMedium,
                          ),
                        ),
                      ),

                      hBox(20.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        barrierDismissible: false,
      );

      if (result == true) {
        // await updateConfigurationApi();
        return true;
      } else if (result == false) {
        return true;
      } else {
        return false;
      }
    }
    return true;
  }

  // Reset after successful save
  void resetUnsavedChanges() {
    captureInitialState();
  }

  // Call this method after ANY change in your UI
  void onDataChanged() {
    checkForChanges();
  }

}