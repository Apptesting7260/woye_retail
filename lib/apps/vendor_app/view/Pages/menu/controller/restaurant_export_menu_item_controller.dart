import 'dart:convert';

import 'package:get/get.dart';
import '../../../../../../Data/Repository/repository.dart';
import '../../../../../../Data/response/status.dart';
import '../../../../../../Utils/snack_bar.dart';
import '../../../../../../shared/widgets/vendor_widgets/print.dart';
import '../../../vendor_common/FileDownload/file_download_controller.dart';
import '../../../vendor_common/Models/common_export_model.dart';
import '../../../vendor_common/Models/common_get_category_model.dart';

class RestaurantExportMenuController extends GetxController{

  FileDownloadController fileDownloadController = Get.put(FileDownloadController());

  @override
  void onInit() {
    getCategoryApi();
    super.onInit();
  }

  final repo = Repository();

  RxString selectedCategoryId = "".obs;
  RxString selectedStatus = "".obs;
  RxInt selectedFormat = 0.obs;
  RxBool isImageUrl = false.obs;

  void toggleFormat(int index) {
    selectedFormat.value = index;
  }

  Rx<ApiStatus> rxRequestStatusExProduct = ApiStatus.COMPLETED.obs;
  void setRxRequestStatusExPro(ApiStatus value)=> rxRequestStatusExProduct.value = value;

  final exportProductData = CommonExportModel().obs;
  void setApiDataExport(CommonExportModel value)=> exportProductData.value = value;

  Future<void> exportProduct()async{
    var data = {
      "format":selectedFormat.value == 0 ? "csv" : "excel",
      if(selectedCategoryId.value.isNotEmpty)"category": selectedCategoryId.value,
      if(selectedStatus.value.isNotEmpty) "status":selectedStatus.value == "All Status" ? "all_status" : selectedStatus.value.toLowerCase(),
      // "field":"",
      // "date_range":"",
      // "start_date":"",
      // "end_date":"",
    };
    setRxRequestStatusExPro(ApiStatus.LOADING);
    repo.exportProductApi(jsonEncode(data)).then((value) {
      setApiDataExport(value);
      if(exportProductData.value.status == true){
        pt("exportTransData.value.downloadUrl ${exportProductData.value.downloadUrl}");
        fileDownloadController.downloadAndSaveFile(
            exportProductData.value.downloadUrl.toString(),
            saveInDownload: true).then((value) {
          setRxRequestStatusExPro(ApiStatus.COMPLETED);
        },);

      }else{
        setRxRequestStatusExPro(ApiStatus.COMPLETED);
        Utils.showToast(exportProductData.value.message.toString());
      }
      pt('downloaded pdf>>>>>>>> $value');
    },).onError((error, stackTrace) {
      // setError(error.toString());
      pt('Error $error');
      setRxRequestStatusExPro(ApiStatus.ERROR);
    },);

  }


//------------------------------------------get categories--------------------------------------
  RxString error = ''.obs;

  void setError(String value) => error.value = value;

  final rxRequestCategoryStatus = ApiStatus.COMPLETED.obs;
  RxString categoryError = ''.obs;
  final apiCategoryData = CommonGetCategoryModel().obs;
  void setRxRequestCategoryStatus(ApiStatus value) => rxRequestCategoryStatus.value = value;
  void categorySetData(CommonGetCategoryModel value) => apiCategoryData.value = value;
  void setCategoryError(String value) => categoryError.value = value;

  Future<void> getCategoryApi() async {

    setRxRequestCategoryStatus(ApiStatus.LOADING);
  //
  //   repo.commonGetCategoryApi().then((value) {
  //     categorySetData(value);
  //     if(apiCategoryData.value.status == true){
  //       setRxRequestCategoryStatus(ApiStatus.COMPLETED);
  //     }else{
  //       pt(categoryError.toString());
  //       setRxRequestCategoryStatus(ApiStatus.ERROR);
  //     }
  //   }).onError((error, stackError) {
  //     setCategoryError(error.toString());
  //     pt(error.toString());
  //     setRxRequestCategoryStatus(ApiStatus.ERROR);
  //   });
  // }

}}