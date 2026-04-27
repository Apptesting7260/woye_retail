import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../../../../../../Data/Repository/repository.dart';
import '../../../../../../../../Data/response/api_response.dart';
import '../../../../../../../../Utils/snack_bar.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/print.dart';
import '../../../../../vendor_common/Models/common_response_model.dart';
import '../model/res_req_payout_model.dart';

class ResRequestPayoutController extends GetxController{

  final formKey = GlobalKey<FormState>();
  final api = Repository();
  TextEditingController payoutController = TextEditingController();
  List<String> payoutAmountList = ["50","100"];


  @override
  void onInit() {
    getPayOutData();
    super.onInit();
  }

  RxString selectedPaymentMethod = "".obs;
  RxString selectedAccountId = "".obs;
  RxString selectedAccountType = "".obs;
  RxString maxWithdrawAmount = "".obs;

  //get data
  final Rx<ApiResponse<GetPayOutModel>> _payOutData = Rx<ApiResponse<GetPayOutModel>>(ApiResponse.completed(null));
  Rx<ApiResponse<GetPayOutModel>> get payOutData => _payOutData;
  setPayOutPaymentMethod(ApiResponse<GetPayOutModel> response) => _payOutData.value = response;

  Future<void> getPayOutData() async {

    setPayOutPaymentMethod(ApiResponse.loading());

    try{
      final value =await api.withdrawalData();

      if(value.status == true){
        setPayOutPaymentMethod(ApiResponse.completed(value));
        maxWithdrawAmount.value = getWithdrawAmount(value.data?.availableBalance ?? "0").toStringAsFixed(0);
      }else{
        setPayOutPaymentMethod(ApiResponse.error(value.message ?? ""));
      }
    }catch(e,s){
      setPayOutPaymentMethod(ApiResponse.error(e.toString() ?? ""));
      pt("Error setPayOutPaymentMethod  payment method $e \n $s");
    }

  }

  double getWithdrawAmount(balanceStr) {

    final balance = double.tryParse(balanceStr) ?? 0.0;

    double withdrawAmount = balance * 0.9;

    pt("withdrawAmount 90% $withdrawAmount");

    return withdrawAmount;
  }

  //withdraw
  final Rx<ApiResponse<CommonResponseModel>> _withdrawData = Rx<ApiResponse<CommonResponseModel>>(ApiResponse.completed(null));
  Rx<ApiResponse<CommonResponseModel>> get withdrawData => _withdrawData;
  setWithdrawPaymentMethod(ApiResponse<CommonResponseModel> response) => _withdrawData.value = response;

  Future<void> withdrawMoney() async {

    setWithdrawPaymentMethod(ApiResponse.loading());


    var data = {
      "amount": payoutController.value.text,
      "payment_method" : selectedAccountType.value.replaceAll(" ", "_").toLowerCase(),
      "account_id" : selectedAccountId.value,
    };

    try{
      final value =await api.withdrawalApi(jsonEncode(data));

      if(value.status == true){
        setWithdrawPaymentMethod(ApiResponse.completed(value));
        Utils.showToast(value.message ?? "");
      }else{
        setWithdrawPaymentMethod(ApiResponse.error(value.message ?? ""));
        Utils.showToast(value.message ?? "");
      }

    }catch(e,s){
      setWithdrawPaymentMethod(ApiResponse.error(e.toString() ?? ""));
      pt("Error setWithdrawPaymentMethod  payment method $e \n $s");
    }

  }

}