  import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gyaawa/Data/response/api_response.dart';
import 'package:gyaawa/apps/vendor_app/view/vendor_common/order_transaction_details/model/overview_model.dart';
import 'package:gyaawa/shared/theme/colors.dart';

import '../../../../../../Data/Repository/repository.dart';
import '../../../../../../shared/widgets/vendor_widgets/print.dart';


  class OverviewOrderTransactionDetailsController extends GetxController{

    final _repo =  Repository();

    List<String> orderType = ["Pending Earning","Total Earning","Last Payout"];


    final RxString _type = "".obs;
    setType(String data) {
      pt("data>> $data");
      _type.value = data.replaceAll("_", " ").capitalize ?? "";
    }
    RxString get type => _type;


    final Rx<ApiResponse<OverviewModel>>  _transactionData =  Rx<ApiResponse<OverviewModel>>(ApiResponse.loading());
    Rx<ApiResponse<OverviewModel>> get transactionData => _transactionData;
    setOverviewData(ApiResponse<OverviewModel> response)=>_transactionData.value = response;


    Future<void> getTransactionData() async {
      setOverviewData(ApiResponse.loading());
      var data = {
        "type" : _type.value.replaceAll(" ", "_").toLowerCase(),
      };
      await _repo.overviewTransaction(jsonEncode(data)).then((value) {
        if(value.status == true){
          setOverviewData(ApiResponse.completed(value));
        }else{
          pt("${value.status} >> when call transaction api");
          setOverviewData(ApiResponse.error(value.message));
        }
      },).onError((error, stackTrace) {
        setOverviewData(ApiResponse.error(error.toString()));
        pt("getting error when call transaction api");
      },);

    }


    Color getColors(String type) {
      switch (type) {
        case "paid":
          return AppColors.greenClrRatingBar;

        case "withdrawal":
        case "refund":
          return AppColors.red;

        case "last_payout":
          return AppColors.blueClr;

       case "pending":
          return AppColors.yellowClr;

        default:
          return AppColors.greyClr;
      }
    }

    IconData getIcons(String type) {
      switch (type.toLowerCase()) {
        case "paid":
          return Icons.add;

        case "pending":
          return Icons.hourglass_empty;

        case "withdrawal":
          return Icons.remove;

        case "refund":
          return Icons.replay_rounded;

        case "orders":
          return Icons.receipt_long_outlined;

        case "payment":
          return Icons.payments_outlined;

        case "last_payout":
          return Icons.arrow_forward_rounded;

        case "commission":
          return Icons.percent_rounded;

        default:
          return Icons.swap_horiz_rounded;
      }
    }

  }