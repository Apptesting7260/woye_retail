import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/Products/controller/vendor_product_controller.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/Profile/Sub_Screens/RestaurantCategory/SubScreens/model/all_category_model.dart';

import '../../../../../../../../../Data/Repository/repository.dart';
import '../../../../../../../../../Data/response/status.dart';

class RestaurantAllCategoryController extends GetxController{
  RxString categoryId = ''.obs;
  RxString title = ''.obs;
  final VendorProductController productController = Get.put(VendorProductController());

  RxString searchQuery = ''.obs;
  RxList<Products> searchListCategory = RxList<Products>([]);
  TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    // TODO: implement onInit
    final args = Get.arguments ?? '';
    categoryId.value =args['id'];
    title.value =args['title'];
    getAllCategoriesApi(id:categoryId.value);
    super.onInit();
  }


  final _api = Repository();
  RxString error = ''.obs;
  final categoriesData = AllCategoryModel().obs;
  final rxCatRequestStatus = ApiStatus.COMPLETED.obs;

  void setCatRxRequestStatus(ApiStatus value) => rxCatRequestStatus.value = value;

  void categoriesSet(AllCategoryModel value) =>
      categoriesData.value = value;

  void setError(String value) => error.value = value;

  getAllCategoriesApi({required String id}) async {
    var data ={"category_id":id};
    setCatRxRequestStatus(ApiStatus.LOADING);
    _api.getAllCategoriesApi(data).then((value) {
      categoriesSet(value);
      if (categoriesData.value.status == true) {
        setCatRxRequestStatus(ApiStatus.COMPLETED);
        searchListCategory.value =categoriesData.value.products!;
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