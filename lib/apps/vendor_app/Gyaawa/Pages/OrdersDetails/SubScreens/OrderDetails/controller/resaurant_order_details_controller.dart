import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:gyaawa/apps/vendor_app/Gyaawa/Pages/OrdersDetails/controller/restaurant_order_list_controller.dart';

import '../../../../../../../../Data/Repository/repository.dart';
import '../../../../../../../../Data/response/status.dart';
import '../../../../../../../../Utils/snack_bar.dart';
import '../model/resaurant_order_details_model.dart';


class RestaurantOrderDetailsController extends GetxController {
  var productId = '';
  RxDouble deliveryCharges = 50.0.obs;
  final RestaurantOrderController controller =  Get.put(RestaurantOrderController());

  GlobalKey<FormState> addCancelNotes = GlobalKey<FormState>();

  @override
  void onInit() {
    // TODO: implement onInit
    productId = Get.arguments ?? '';
    print("productId ------------------------------------------ $productId");
    singleOrdersApi();
    super.onInit();
  }

  //Get Order Details APi
  final api = Repository();
  final apiData = SingleOrderDetailsModel().obs;
  RxString error = ''.obs;
  final rxRequestStatus = ApiStatus.COMPLETED.obs;

  void setRxRequestStatus(ApiStatus value) => rxRequestStatus.value = value;

  void setError(String value) => error.value = value;

  void ordersSetData(SingleOrderDetailsModel value) => apiData.value = value;

  Future<void> singleOrdersApi({bool? isRefresh = false}) async {
    var data = {
      "id":productId.toString()
    };
    if(isRefresh != true) {
      setRxRequestStatus(ApiStatus.LOADING);
    }
    api.getSingleOrderApi(data).then((value) {
       ordersSetData(value);
       if(apiData.value.status == true){
       setRxRequestStatus(ApiStatus.COMPLETED);
     }
    }).onError((error, stackError) {
      setError(error.toString());
      log(error.toString(), name: "Error");
      setRxRequestStatus(ApiStatus.ERROR);
    });
  }



  //Delete Order APi

  Rx<TextEditingController> cancelProductController  = Rx(TextEditingController());

 final rxRequestRejectOrderStatus = ApiStatus.COMPLETED.obs;

  void setRxRequestRejectOrderStatus(ApiStatus value) => rxRequestRejectOrderStatus.value = value;

  Future<void> rejectOrderApi() async {
    var data = {
      "id":productId.toString(),
      "cancel_reason" :cancelProductController.value.text,
    };
    setRxRequestRejectOrderStatus(ApiStatus.LOADING);
    api.rejectOrderApi(data).then((value) {
      if(value.status == true){
        setRxRequestRejectOrderStatus(ApiStatus.COMPLETED);
        Get.back();
        singleOrdersApi();
        controller.orderApi(isRefresh:true);
        Utils.showToast("Order Rejected!");
        cancelProductController.value.clear();
      }
    }).onError((error, stackError) {
      setError(error.toString());
      log(error.toString(), name: "Error");
      setRxRequestRejectOrderStatus(ApiStatus.ERROR);
    });
  }


}
