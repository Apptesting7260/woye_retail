import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../../../../../Data/Repository/repository.dart';
import '../../../../../../../../Data/response/status.dart';
import '../model/review_replay_model.dart';
import '../model/reviews_model.dart';

class RestaurantProductReviewController extends GetxController {
  var sortOption = 'Latest'.obs;

  Rx<TextEditingController> replayController = TextEditingController().obs;
  RxString reviewId = "".obs;
  final  GlobalKey<FormState> replayFormKey = GlobalKey<FormState>();
  RxBool isReplay = true.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getOrderReviews();
    super.onInit();
  }

  RxString error  = ''.obs;
  Repository api = Repository();
  Rx<OrderReviewsModel> apiData =OrderReviewsModel().obs;
  Rx<ApiStatus> rxRequestStatus = ApiStatus.COMPLETED.obs;
  void setRxRequestStatus(ApiStatus value) => rxRequestStatus.value = value;
  void setError(String value) => error.value = value;
  void setApiData(OrderReviewsModel value) => apiData.value = value;

  Future<void> getOrderReviews() async {
    setRxRequestStatus(ApiStatus.LOADING);
    api.getReviewsApi().then((value){
      setApiData(value);
      if(apiData.value.status == true){
        setRxRequestStatus(ApiStatus.COMPLETED);
      }
    }).onError((error, stackError) {
      setError(error.toString());
      log('Error $error');
      setRxRequestStatus(ApiStatus.ERROR);
    });
  }

  //----------------------------Edit and Replay Review--------------------------


  Rx<ReviewReplyModel> replayApiData =ReviewReplyModel().obs;
  Rx<ApiStatus> rxReplyRequestStatus = ApiStatus.COMPLETED.obs;
  void setReplyRxRequestStatus(ApiStatus value) => rxReplyRequestStatus.value = value;
  void setReplyApiData(ReviewReplyModel value) => replayApiData.value = value;

  Future<void> replayAndEditReviews({required String replay}) async {
    var data = {
      "review_id":reviewId.value,
      "reply":replay,
    };
    setReplyRxRequestStatus(ApiStatus.LOADING);
    api.replyAndEditReviewsApi(data).then((value){
      setReplyApiData(value);
      if(apiData.value.status == true){
        getOrderReviews();
        setReplyRxRequestStatus(ApiStatus.COMPLETED);
        Get.back();
      }
    }).onError((error, stackError) {
      setError(error.toString());
      log('Error $error');
      setReplyRxRequestStatus(ApiStatus.ERROR);
    });
  }

}
