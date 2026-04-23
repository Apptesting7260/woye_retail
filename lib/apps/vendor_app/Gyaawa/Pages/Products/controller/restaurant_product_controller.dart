import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:gyaawa/apps/vendor_app/Gyaawa/vendor_common/Models/product_delete_model.dart';
import 'package:gyaawa/apps/vendor_app/Gyaawa/vendor_common/Models/product_list_model.dart';
import '../../../../../../Data/Repository/repository.dart';
import '../../../../../../Data/response/status.dart';
import '../../../../../../Utils/snack_bar.dart';
import '../../Profile/Sub_Screens/Setting/RestaurantInFormation/controller/restaurant_information_controller.dart';

class RestaurantProductController extends GetxController {

  // FillRestaurantDetailsController fillRestaurantDetailsController =  Get.put(FillRestaurantDetailsController());
  FillRestaurantDetailsController fillRestaurantDetailsController =  Get.put(FillRestaurantDetailsController());
  // VendorAccountStatusController vendorAccountStatusController = Get.put(VendorAccountStatusController());

  RxString selectedTab = "All Products".obs;

  RxList<String> productList = ["All","Active","Inactive"].obs;

  TextEditingController searchController = TextEditingController();
  RxString searchQuery = ''.obs;


  // var selectedDay = Rxn<String>();
  RxString selectedStatus = "All".obs;
  RxList<ProductListFromModel> filterListOfProducts = RxList<ProductListFromModel>([]);


  getInitData(){
    // vendorAccountStatusController.getAccountStatusApi();
  }

  final rxRequestStatus = ApiStatus.COMPLETED.obs;
  RxString error = ''.obs;
  final api = Repository();
  final apiData = ProductListModel().obs;

  void setRxRequestStatus(ApiStatus value) => rxRequestStatus.value = value;

  void productSetData(ProductListModel value) => apiData.value = value;

  void setError(String value) => error.value = value;


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
    print("Data body $data");
    setRxRequestStatusDelete(ApiStatus.LOADING);
    api.productDeleteApi(data).then((value) {
      deleteProductSet(value);
      if (apiDataDelete.value.status == true) {
        setRxRequestStatusDelete(ApiStatus.COMPLETED);
       Utils.showToast(apiDataDelete.value.message.toString());
      } else {
        setErrorDelete(errorDelete.toString());
        setRxRequestStatusDelete(ApiStatus.ERROR);
        Utils.showToast(apiDataDelete.value.message.toString());
      }
      print("response data $value ");
    }).onError((error, stackError) {
      setErrorDelete(error.toString());
      Utils.showToast(apiDataDelete.value.message.toString());
      print(error);
      setRxRequestStatusDelete(ApiStatus.ERROR);
    });
  }
}
