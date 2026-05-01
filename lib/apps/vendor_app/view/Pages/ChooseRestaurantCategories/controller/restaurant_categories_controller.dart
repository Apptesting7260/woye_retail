import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gyaawa/Data/Model/user_model.dart';
import 'package:gyaawa/Data/Repository/repository.dart';
import 'package:gyaawa/Data/user_preference_controller.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/ChooseRestaurantCategories/model/new_categories_model.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/ChooseRestaurantCategories/model/res_category_cusion_model.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/Profile/Sub_Screens/RestaurantCategory/controller/restaurant_category_controller.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/Profile/Sub_Screens/RestaurantCategory/model/category_model.dart' hide Categories;
import 'package:gyaawa/routes/vendor_routes/vendor_app_routes.dart';
import 'package:gyaawa/shared/widgets/vendor_widgets/custom_confirm_password_dialog.dart';
import 'package:intl/intl.dart';
import '../../../../../../Data/response/status.dart';
import '../../../../../../Utils/snack_bar.dart';
import '../../../../../../shared/theme/colors.dart';
import '../../../../../../shared/theme/font_family.dart';
import '../../../../../../shared/theme/font_style.dart';
import '../../../../../../shared/widgets/vendor_widgets/print.dart';
import '../../Profile/Sub_Screens/Setting/RestaurantInFormation/controller/restaurant_information_controller.dart';
import '../model/update_categories_model.dart';

class RestaurantCategoriesController extends GetxController {
  // final FillRestaurantDetailsController fillRestaurantDetailsController = Get.put(FillRestaurantDetailsController());
  FillRestaurantDetailsController fillRestaurantDetailsController =  Get.put(FillRestaurantDetailsController());
  final RestaurantCategoryController restaurantCategoryController =Get.put(RestaurantCategoryController());
  RxList selectedCategories = [].obs;
  RxList selectedCuisines = [].obs;
  RxList initialCategories = [].obs;
  UserPreference sp = UserPreference();
  UserModel userModel =UserModel();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // RxBool isRedClr = false.obs;

  Rx<TextEditingController> requestNewCategoriesController = TextEditingController().obs;

  Rx<TextEditingController> searchCategoriesController = TextEditingController().obs;
  Rx<TextEditingController> searchCuisinesController = TextEditingController().obs;
  RxString searchQuery = ''.obs;
  RxString searchQueryCuisines = ''.obs;
  RxList<Categories> searchListCategory = RxList<Categories>([]);
  // RxList<Cuisines> searchListCuisines = RxList<Cuisines>([]);

  // RxList<Categories> categoryList = RxList<Categories>([]);
  // RxList<Cuisines> cuisinesList = RxList<Cuisines>([]);


  final _api = Repository();
  final newCategoriesData = NewCategoriesModel().obs;
  RxString error = ''.obs;
  final rxRequestStatus1 = ApiStatus.COMPLETED.obs;
  final rxRequestStatus2 = ApiStatus.COMPLETED.obs;
  final rxCatRequestStatus = ApiStatus.COMPLETED.obs;


  final List<String> categoryLists = ['Select Categories','Select Cuisines'];

  RxInt selectedTypeIndex = 0.obs;

  ScrollController scrollCatController = ScrollController();
  ScrollController scrollCuisinesController = ScrollController();

  void updateSelectedType(int index){
    selectedTypeIndex.value = index;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
     scrollToTop(scrollCatController);
    },);
  }

  scrollToTop(ScrollController sController){
    sController.animateTo(0, duration: const Duration(milliseconds: 200), curve: Curves.bounceIn);
  }
  
  @override
  void onInit()async {
    // TODO: implement onInit
    userModel = await sp.getUser();
    requestNewCategoriesController.value = TextEditingController();
    fillRestaurantDetailsController.getProfileDetailsApi();
    await getCategoriesCuisinesApi();
    await getChoosesCategoriesApi();
    super.onInit();
  }




  void newCategoriesSet(NewCategoriesModel value) =>
      newCategoriesData.value = value;

  void setRxRequestStatus1(ApiStatus value) => rxRequestStatus1.value = value;
  void setRxRequestStatus2(ApiStatus value) => rxRequestStatus2.value = value;

  void setCatRxRequestStatus(ApiStatus value) => rxCatRequestStatus.value = value;

  void setError(String value) => error.value = value;


  final categoriesData = CategoryAndCuisinesModel().obs;

  void categoriesSet(CategoryAndCuisinesModel value) =>
      categoriesData.value = value;

  getCategoriesCuisinesApi() async {
    setRxRequestStatus1(ApiStatus.LOADING);
    _api.getChooseCategoriesCuisinesApi().then((value) {
      categoriesSet(value);
      if (categoriesData.value.status == true) {
        // if(categoriesData.value.data?.categories != null) {
        //   categoryList.value = categoriesData.value.data!.categories!;
        // }
        // if(categoriesData.value.data?.cuisines != null) {
        //   cuisinesList.value = categoriesData.value.data!.cuisines!;
        // }
        // for(int i=0;i<categoriesData.value.category!.length;i++){
        //   selectedCategories.add(categoriesData.value.category?[i].id);
        // }
        setRxRequestStatus1(ApiStatus.COMPLETED);
      } else {
        setRxRequestStatus1(ApiStatus.ERROR);
        print('Error: $error');
      }
    }).onError(
      (error, stackTrace) {
        setRxRequestStatus1(ApiStatus.ERROR);
        // Utils.showToast('Error: $error');
        print('Error: $error');
      },
    );
  }

  /*getCategoriesApi() async {
    final data = {"role": "resto"};
    setRxRequestStatus1(ApiStatus.LOADING);
    _api.getChooseCategoriesApi(data).then((value) {
      categoriesSet(value);
      if (categoriesData.value.status == true) {
        categoryList.value = categoriesData.value.category!;
        // for(int i=0;i<categoriesData.value.category!.length;i++){
        //   selectedCategories.add(categoriesData.value.category?[i].id);
        // }
        setRxRequestStatus1(ApiStatus.COMPLETED);
      } else {
        setRxRequestStatus1(ApiStatus.ERROR);
        print('Error: $error');
      }
    }).onError(
      (error, stackTrace) {
        setRxRequestStatus1(ApiStatus.ERROR);
        // Utils.showToast('Error: $error');
        print('Error: $error');
      },
    );
  }*/


  //>>>>>>>>>>>>>>>>>>>Update Category <<<<<<<<<<<<\\
  final updateCategoriesData = UpdateCategoriesModel().obs;
  void updateCategoriesSet(UpdateCategoriesModel value) => updateCategoriesData.value = value;

  categoriesCuisinesAddApi() async {
    RxList selectedIds = selectedCategories;
    String today = DateFormat('dd/MM/yyyy').format(DateTime.now());
    List<Map<String, dynamic>> categoryIds = selectedIds.map((id) {
      return {
        "id": int.tryParse(id.toString()) ?? id,
        "status": 1,
        "added": today,
      };
    }).toList();
    final data = {
      // "email": fillRestaurantDetailsController.profileApiData.value.vendor?.email,
      "category_ids":categoryIds,
      "cuisine_ids": selectedCuisines.map((id) => int.parse(id.toString())).toList(),
    };

    pt("data body >>>>> $data");

    setRxRequestStatus2(ApiStatus.LOADING);
    _api.categoriesCuisinesAddApi(jsonEncode(data)).then((value) async{
      updateCategoriesSet(value);
      if (updateCategoriesData.value.status == true && updateCategoriesData.value.step == "3") {
        setRxRequestStatus2(ApiStatus.COMPLETED);
        Utils.showToast(updateCategoriesData.value.message.toString());
        Get.offAndToNamed(VendorAppRoutes.restaurantNavbarScreen);
        sp.saveStep(int.parse(updateCategoriesData.value.step.toString()));
        sp.saveIsLogin(true);
        sp.saveLoginType("restaurant");
        await sp.saveUserRole(updateCategoriesData.value.role ?? "");
        print("Steps: ${updateCategoriesData.value.step}");
        update();
      } else {
        setRxRequestStatus2(ApiStatus.ERROR);
        Utils.showToast(updateCategoriesData.value.message.toString());
        print('Error: $error');
      }
    }).onError(
      (error, stackTrace) {
        setRxRequestStatus2(ApiStatus.ERROR);
        // Utils.showToast('Error: $error');
        print('Error: $error');
      },
    );
  }

  //--------------------------------------- New Category Request ---------------------------------------
  RxBool isShowError = false.obs;

  newCategoryRequestApi(context, {required String name}) async {
    final data = {"name": name, "role": "resto"};
    setCatRxRequestStatus(ApiStatus.LOADING);
    _api.newCategoriesApi(data).then((value) {
      newCategoriesSet(value);
      if (newCategoriesData.value.status == true) {
        setCatRxRequestStatus(ApiStatus.COMPLETED);
        showDialog(
          barrierDismissible: false,
          context: context,
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
                isShowError.value = false;
                // requestNewCategoriesController.value.text = '';
                requestNewCategoriesController.value.clear();
                // isRedClr.value = false;
                Get.back();
              },
            );
          },
        );
      } else if(newCategoriesData.value.status == false) {
        setCatRxRequestStatus(ApiStatus.ERROR);
        Utils.showToast(newCategoriesData.value.message.toString());
        print('Error: $error');
      }
    }).onError(
      (error, stackTrace) {
        setCatRxRequestStatus(ApiStatus.ERROR);
        // Utils.showToast('Error: $error');
        print('Error: $error');
      },
    );
  }

//>>>>>>>>>get all chooses category
  final choosesCategoriesData = CategoryModel().obs;
  final rxChoosesCatRequestStatus = ApiStatus.COMPLETED.obs;

  void setChoosesCatRxRequestStatus(ApiStatus value) => rxChoosesCatRequestStatus.value = value;

  void choosesCategoriesSet(CategoryModel value) => choosesCategoriesData.value = value;


  getChoosesCategoriesApi() async {
    setCatRxRequestStatus(ApiStatus.LOADING);
    _api.getCategoryApi().then((value) {
      choosesCategoriesSet(value);
      if (choosesCategoriesData.value.status == true) {
        setCatRxRequestStatus(ApiStatus.COMPLETED);
        for(int i=0;i<choosesCategoriesData.value.categories!.length;i++){
          selectedCategories.add(choosesCategoriesData.value.categories?[i].id);
          initialCategories.add(choosesCategoriesData.value.categories?[i].id);
        }
      } else {
        setCatRxRequestStatus(ApiStatus.ERROR);
        print('Error: $error');
      }
    }).onError(
          (error, stackTrace) {
        setCatRxRequestStatus(ApiStatus.ERROR);
        // Utils.showToast('Error: $error');
        print('Error: $error');
      },
    );
  }

}
