import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/menu/model/vendor_menu_model.dart';
import 'package:gyaawa/apps/vendor_app/view/vendor_common/Models/product_delete_model.dart';

import '../../../../../../Core/Constant/image_constant.dart';
import '../../../../../../Data/Repository/repository.dart';
import '../../../../../../Data/response/api_response.dart';
import '../../../../../../Data/response/status.dart';
import '../../../../../../Utils/snack_bar.dart';
import '../../../../../../shared/theme/colors.dart';
import '../../../../../../shared/widgets/vendor_widgets/print.dart';
class VendorMenuController extends GetxController{

  Rx<TextEditingController> searchController = TextEditingController().obs;

  RxList<Color> categoryColors = [AppColors.blueClr,AppColors.redTextClr,AppColors.primary].obs;

  RxList<String> cardListTitle = ["Total Products","In Stock","Low Stock","Out of Stock",].obs;
  RxList<String> showList = ["5","10","50","100"].obs;
  RxList<String> priceRangeList =  ["0-10", "10-20", "20-30", "30-40","50+"].obs;
  RxList<String> preparationTimeList =  ["0-15", "10-20", "20-30", "30+"].obs;
  RxList<String> shortByList =  ["A-Z", "Z-A","Low to High", "High to Low", "Most Orders","Highest Rating"].obs;
  RxList<String> availabilityList = ["Availability","This Month","Last 3 Months", "Last 6 Months","This Year"].obs;
  RxList<String> cardListImage = [ImageConstants.greenCartSvg,ImageConstants.available,ImageConstants.alertSvgLogo,ImageConstants.favoriteSvg,].obs;
  List<Color> iconClr = [AppColors.greenLightClr,AppColors.greenTextClr,AppColors.yellow,AppColors.greenTextClr];

  final repo = Repository();
  RxInt currentPage = 1.obs;
  RxInt totalPages = 1.obs;
  RxInt perPage = 10.obs;
  RxInt totalItems = 0.obs;
  RxBool isLoadingMore = false.obs;
  RxBool hasMoreData = true.obs;
  RxBool paginationEnabled = true.obs;
  RxList<Products> loadedProducts = <Products>[].obs;

  RxString selectedStatus = "".obs;
  RxString selectedPriceRange = "".obs;
  RxString selectedShow = "".obs;
  RxString selectedMenuType = "".obs;
  RxString selectedShortBy = "".obs;
  RxString selectedPreparationTime = "".obs;

  @override
  void onInit() {
    getProductListApi();
    super.onInit();
  }
  void resetPagination() {
    currentPage.value = 1;
    totalPages.value = 1;
    allProducts.clear();
    filteredProducts.clear();
    isLoadingMore.value = false;
    hasMoreData.value = true;
    paginationEnabled.value = true; // important for scroll to work
  }

  final Rx<ApiResponse<MenuModel>> _menuData = ApiResponse<MenuModel>.completed(null).obs;
  Rx<ApiResponse<MenuModel>> get menuData => _menuData;
  setProductListApiData(ApiResponse<MenuModel> response)=> _menuData.value = response;
  RxBool isFilterLoading = false.obs;

  List<Products> allProducts = [];
  RxList<Products> filteredProducts = <Products>[].obs;
  Future<void> loadMoreData() async {
    if (!hasMoreData.value || isLoadingMore.value) return;

    isLoadingMore.value = true;
    currentPage.value++; // increment page

    await getProductListApi(
      isShowLoading: false,
      loadMore: true,
    );
  }


  void updateProductInList({
    required String id,
    Products? updatedData,
  }) {
    final index = filteredProducts.indexWhere((e) => e.id == id);

    if (index == -1) return;

    final oldProduct = filteredProducts[index];

    filteredProducts[index] = oldProduct.copyWith(
      title: updatedData?.title != null &&
          updatedData!.title!.isNotEmpty &&
          updatedData.title != oldProduct.title
          ? updatedData.title
          : oldProduct.title,

      description: updatedData?.description != null && updatedData!.description!.isNotEmpty && updatedData.description != oldProduct.description
          ? updatedData.description  : oldProduct.description,

      imageUrl: updatedData?.imageUrl != null && updatedData!.imageUrl!.isNotEmpty ? updatedData.imageUrl : oldProduct.imageUrl,

      categoryId: updatedData?.categoryId != null && updatedData!.categoryId != oldProduct.categoryId ? updatedData.categoryId : oldProduct.categoryId,

      categoryName: updatedData?.categoryName != null && updatedData!.categoryName != oldProduct.categoryName ? updatedData.categoryName : oldProduct.categoryName,

      status: updatedData?.status != null && updatedData!.status != oldProduct.status ? updatedData.status : oldProduct.status,

      rating: updatedData?.rating != null && updatedData!.rating != oldProduct.rating ? updatedData.rating : oldProduct.rating,

    );
  }


  void removeProductFromList(String id) => filteredProducts.removeWhere((p) => p.id ==id);

  Future<void> getProductListApi({bool isShowLoading = true,bool isShowLoadingFilter = false,bool loadMore = false,})async{
    if(isShowLoading == true) {
      setProductListApiData(ApiResponse.loading());
    }
    if (isShowLoadingFilter == true) {
      isFilterLoading.value = true;
    }

    Map<String,dynamic> data = {
      if(selectedShow.value.isEmpty)
      "page": currentPage.value,
      "show": selectedShow.value,

      // if(selectedShow.value.isEmpty)
      //   "per_page": perPage.value,

      if(selectedCategoryId.value != "" || selectedCategoryId.value.isNotEmpty)
      "category_id" : selectedCategoryId.value,

      if(selectedStatus.value != "" || selectedStatus.value.isNotEmpty)
      "status":selectedStatus.value.toLowerCase(),

      if(selectedCuisinesId.value != "" || selectedCuisinesId.value.isNotEmpty)
      "cuisine_id":selectedCuisinesId.value,

      if(selectedMenuType.value != "" || selectedMenuType.value.isNotEmpty)
      "menu_section":selectedMenuType.value.toLowerCase().replaceAll(" ", "_"),

      if(selectedPriceRange.value != "" || selectedPriceRange.value.isNotEmpty)
      "price_range":selectedPriceRange.value == "0-15" ? "under_15" : selectedPriceRange.value,

      if(selectedShortBy.value != "" || selectedShortBy.value.isNotEmpty)
      "sort_by":selectedShortBy.value.toLowerCase().replaceAll(" ", "_").replaceAll("-", "_"),

      if(selectedShow.value != "" || selectedShow.value.isNotEmpty)
      "show":selectedShow.value,

      if(selectedPreparationTime.value != "" || selectedPreparationTime.value.isNotEmpty)
      "prep_time":selectedPreparationTime.value == "0-15" ? "under_15" : selectedPreparationTime.value ,
    // prep_time - under_15,10-20,20-30,30+

      if(selectedAttributeIds.isNotEmpty)
        "attr_ids": selectedAttributeIds.map((e) => e.toString()).toList(),
      if(selectedCategoryId.value.isNotEmpty)
        "category_id" : selectedCategoryId.value,

      if(selectedStatus.value.isNotEmpty)
        "status": selectedStatus.value.toLowerCase(),
    };
    pt("API Request - Page: ${currentPage.value}, Data: $data");
    pt("Request Data: $data");
    pt("body >>> $data");
  pt("body >>> $data");
    try {
      final value = await repo.productListApi(jsonEncode(data));
      if (value.status == true) {
        final List<Products> newProducts = value.products ?? [];

        if (loadMore) {
          if (newProducts.isNotEmpty) {
            // Optional: filter out duplicates by ID
            newProducts.removeWhere((p) =>allProducts.any((e) => e.id == p.id));

            allProducts.addAll(newProducts);
            filteredProducts.addAll(newProducts);
          } else {
            hasMoreData.value = false; // no more items
          }
        } else {
          allProducts.assignAll(newProducts);
          filteredProducts.assignAll(newProducts);
        }



        if (newProducts.length < perPage.value) {
          hasMoreData.value = false;
        } else {
          hasMoreData.value = true;
        }
        if (!loadMore && value.pagination != null) {
          currentPage.value = value.pagination?.currentPage ?? 1;
          totalPages.value = value.pagination?.lastPage ?? 1;
          totalItems.value = value.pagination?.total ?? 0;}
        setProductListApiData(ApiResponse.completed(value));

        pt(name: "All products", allProducts.length.toString());

      } else {
        setProductListApiData(ApiResponse.error(value.message));
      }
    } catch (e, s) {
      pt("Error getting product list api $e $s");
      setProductListApiData(ApiResponse.error(e.toString()));
    } finally {
      isLoadingMore.value = false;
      isFilterLoading.value = false;
    }
  }

  void searchProduct(String query){
    if(query.isEmpty){
      filteredProducts.assignAll(allProducts);
    }else{
      filteredProducts.assignAll(allProducts.where((product) => (product.title?.trim() ?? "").toLowerCase().contains(query.toLowerCase())));
    }
  }


  RxList<String> selectedAttributeIds = <String>[].obs;

  void setSelectedAttributes(List<String> ids) {
    selectedAttributeIds.value = ids;
  }

  clearFilter() {
    selectedAttributeIds.clear();
    selectedPreparationTime.value = "";
    if (selectedAttributeIds.isEmpty && selectedPreparationTime.value.isEmpty) {
      getProductListApi(isShowLoading: false);
    }
  }


  //--------------------------------------------------------------------------------
  final rxRequestStatusDelete = ApiStatus.COMPLETED.obs;
  RxString errorDelete = ''.obs;
  final apiDataDelete = ProductDeleteModel().obs;

  void setRxRequestStatusDelete(ApiStatus value) =>
      rxRequestStatusDelete.value = value;

  void deleteProductSet(ProductDeleteModel value) =>
      apiDataDelete.value = value;

  void setErrorDelete(String value) => errorDelete.value = value;

  Future<void> productDeleteApi(String id) async {
    var data = {
      "id": id,
    };
    pt("Data body $data");
    setRxRequestStatusDelete(ApiStatus.LOADING);
    repo.productDeleteApi(data).then((value) {
      deleteProductSet(value);
      if (apiDataDelete.value.status == true) {
        setRxRequestStatusDelete(ApiStatus.COMPLETED);
        Get.back();
        // getProductListApi(isShowLoading: false);
        removeProductFromList(id);
        Utils.showToast(apiDataDelete.value.message.toString());
      } else {
        setErrorDelete(errorDelete.toString());
        setRxRequestStatusDelete(ApiStatus.ERROR);
        Utils.showToast(apiDataDelete.value.message.toString());
      }
      pt("response data $value ");
    }).onError((error, stackError) {
      setErrorDelete(error.toString());
      Utils.showToast(apiDataDelete.value.message.toString());
      pt(error.toString());
      setRxRequestStatusDelete(ApiStatus.ERROR);
    });
  }


  RxString selectedCategoryId = ''.obs;
  RxString selectedCategoryName = ''.obs;

  RxString selectedCuisinesId = ''.obs;
  RxString selectedCuisinesName = ''.obs;

  void onCategoryChanged(String? categoryId, String? categoryName) {
    selectedCategoryId.value = categoryId ?? '';
    selectedCategoryName.value = categoryName ?? '';
  }

  //--------------------------------------------------------------------------------
  GlobalKey totalMenuItemKey = GlobalKey();

  scrollToFields(GlobalKey key){
    final context = key.currentContext;
    if(context != null){
      Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: 0.01
      );
    }
  }
  //--------------------------------------------------------------------------------
  String? filePathCsv;
  RxString fileName = "".obs;
  RxBool isError = false.obs;

  Future<void> pickCsvFile() async {
    isError.value = false;
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.single;
        if (file.size > 10 * 1024 * 1024) {
          isError.value = true;
          filePathCsv = null;
          fileName.value = "";
          Utils.showToast("File must be less than 10MB");
          return;
        }
        if (!file.name.endsWith(".csv")) {
          isError.value = true;
          filePathCsv = null;
          fileName.value = "";
          Get.snackbar("Error", "Only CSV files allowed");
          return;
        }
        filePathCsv = file.path;
        fileName.value = file.name;
      }
    } catch (e) {
      isError.value = true;
    }
  }

  void removeCsv() {
    filePathCsv = null;
    fileName.value = "";
    isError.value = false;
  }

  bool validateCsv() {
    if (filePathCsv == null || filePathCsv!.isEmpty) {
      isError.value = true;
      Get.snackbar("Error", "Please upload a CSV file");
      return false;
    }
    return true;
  }


}