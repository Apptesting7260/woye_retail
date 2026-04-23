

import 'dart:developer';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gyaawa/Data/Repository/repository.dart';
import '../../../../../../../../Data/response/status.dart';
import '../../../../../../../../shared/theme/colors.dart';
import '../model/res_order_transaction_history.dart';

class ResOrderTransactionController extends GetxController {

  RxInt radioValue = 0.obs;
  final Color leftBarColor = AppColors.primary;
  final Color rightBarColor = AppColors.yellow;
  final double barWidth = 5.0;
  RxList<String> days = [
    "Today",
    "10 days",
    "25 days",
    "50 days",
    "100 days",
  ].obs;
  var selectedAll = Rxn<String>("All");
  var selectedDay = Rxn<String>("10 days");
  var chartSelectedDay = Rxn<String>("Today");
  RxList<BarChartGroupData> barGroups = <BarChartGroupData>[].obs;

  @override
  void onInit() {
    getWalletDetails();
    super.onInit();
    loadBarGroups();
  }

  //---------------------Wallet transaction---------------------------
  RxString error  = ''.obs;
  Repository api = Repository();
  Rx<OrderTransactionHistoryModel> apiData =OrderTransactionHistoryModel().obs;
  Rx<ApiStatus> rxRequestStatus = ApiStatus.COMPLETED.obs;
  void setRxRequestStatus(ApiStatus value) => rxRequestStatus.value = value;
  void setError(String value) => error.value = value;
  void setApiData(OrderTransactionHistoryModel value) => apiData.value = value;
  // void setApiData(OrderTransactionHistoryModelOrderTransactionHistoryModel value) => apiData.value = value;

  Future<void> getWalletDetails() async {
    setRxRequestStatus(ApiStatus.LOADING);
    api.getWalletApi().then((value){
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



  void loadBarGroups() {
    final items = [
      makeGroupData(0, 50, 40),
      makeGroupData(1, 50, 40),
      makeGroupData(2, 50, 40),
      makeGroupData(3, 50, 40),
      makeGroupData(4, 50, 40),
      makeGroupData(5, 50, 40),
      makeGroupData(6, 50, 40),
      makeGroupData(7, 50, 40),
      makeGroupData(8, 50, 40),
    ];
    barGroups.assignAll(items);
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(
      barsSpace: 2,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: leftBarColor,
          width: barWidth,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(7.0),
            topRight: Radius.circular(7.0),
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(0),
          ),
        ),
        BarChartRodData(
          toY: y2,
          color: rightBarColor,
          width: barWidth,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(7.0),
            topRight: Radius.circular(7.0),
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(0),
          ),
        ),
      ],
    );
  }
}
