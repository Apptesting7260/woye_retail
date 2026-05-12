import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/ChooseVendorCategories/model/new_categories_model.dart';

import 'package:gyaawa/apps/vendor_app/view/Pages/Profile/Sub_Screens/RestaurantCategory/model/category_model.dart';

import '../../../../../../../../Data/Repository/repository.dart';
import '../../../../../../../../Data/response/status.dart';
import '../../../../../../../../Utils/snack_bar.dart';
import '../../../../../../../../shared/theme/colors.dart';
import '../../../../../../../../shared/theme/font_family.dart';
import '../../../../../../../../shared/theme/font_style.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/custom_confirm_password_dialog.dart';

class RestaurantCategoryController extends GetxController {

  RxBool isBarrierDismissible = false.obs;
  // RxBool isRedClr = false.obs;

  TextEditingController searchController = TextEditingController();
  RxString searchQuery = ''.obs;
  RxList<Categories> searchListCategory = RxList<Categories>([]);
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void onInit() {
    getCategoriesApi();
    super.onInit();
  }


  //>>>>>>>>get category api <<<<<<<<<<<<<<<\\

  final _api = Repository();
  RxString error = ''.obs;
  final categoriesData = CategoryModel().obs;
  final rxCatRequestStatus = ApiStatus.COMPLETED.obs;

  void setCatRxRequestStatus(ApiStatus value) => rxCatRequestStatus.value = value;

  void categoriesSet(CategoryModel value) => categoriesData.value = value;

  void setError(String value) => error.value = value;

  getCategoriesApi() async {
    setCatRxRequestStatus(ApiStatus.LOADING);
    _api.getCategoryApi().then((value) {
      categoriesSet(value);
      if (categoriesData.value.status == true) {
        setCatRxRequestStatus(ApiStatus.COMPLETED);
        searchListCategory.value = categoriesData.value.categories!;
        searchQuery.value = "";
        searchController.clear();
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

//>>>>>>>>>>>>>>>>>>>New Category Request <<<<<<<<<<<<\\
  Rx<TextEditingController> requestNewCategoriesController = TextEditingController().obs;

  final newCategoriesData = NewCategoriesModel().obs;
  void newCategoriesSet(NewCategoriesModel value) => newCategoriesData.value = value;

  final rxNewCatRequestStatus = ApiStatus.COMPLETED.obs;
  void setNewCatRxRequestStatus(ApiStatus value) => rxNewCatRequestStatus.value = value;

  newCategoryRequestApi(context, {required String name}) async {
    final data = {"name": name, "role": "resto"};
    setNewCatRxRequestStatus(ApiStatus.LOADING);
    _api.newCategoriesApi(data).then((value) {
      newCategoriesSet(value);
      if (newCategoriesData.value.status == true) {
        Get.back();
        setNewCatRxRequestStatus(ApiStatus.COMPLETED);
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
                requestNewCategoriesController.value.clear();
                Get.back();
              },
            );
          },
        );
      } else {
        setNewCatRxRequestStatus(ApiStatus.ERROR);
        Utils.showToast(newCategoriesData.value.message.toString(),bgColor: AppColors.darkText);
        print('Error: $error');
      }
    }).onError(
          (error, stackTrace) {
            setNewCatRxRequestStatus(ApiStatus.ERROR);
        // Utils.showToast('Error: $error');
        print('Error: $error');
      },
    );
  }

}
