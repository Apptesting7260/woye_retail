import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../Core/Constant/image_constant.dart';
import '../../../../../../Data/Repository/repository.dart';
import '../../../../../../Data/response/api_response.dart';
import '../../../../../../shared/theme/colors.dart';
import '../../../../../../shared/widgets/vendor_widgets/print.dart';
import '../../../vendor_common/FileDownload/file_download_controller.dart';
import '../../../vendor_common/Models/common_export_model.dart';
import '../../../vendor_common/Models/common_response_model.dart';
import '../../Profile/Sub_Screens/Setting/RestaurantInFormation/controller/restaurant_information_controller.dart';
import '../model/vender_wallet_model.dart';

class RestaurantWalletsController extends GetxController {


  FillRestaurantDetailsController fillRestaurantDetailsController =  Get.put(FillRestaurantDetailsController());
  FileDownloadController fileDownloadController = Get.put(FileDownloadController());
  // VendorAccountStatusController vendorAccountStatusController = Get.put(VendorAccountStatusController());

  final api = Repository();

  final List<String> iconList = [ImageConstants.walletNew,ImageConstants.timerClock,ImageConstants.increaseGraph,ImageConstants.card  ];
  List<Color> cardColor = [AppColors.primary,AppColors.orange,AppColors.greenClr,AppColors.blueClr];
  List<String> cardTitle = ["Available Balance","Pending Earnings","Total Earnings","Last Payout"];
  List<String> carddesTitle = [];
  List<String> cardSubTitle = [];
  List<Map<String,dynamic>> btnList = [
    {"title":"Withdraw","image":ImageConstants.paySvgrepo},
    {"title":"Manage Payout Methods","image":ImageConstants.bankLogoNew},
    {"title":"Download Statement","image":ImageConstants.downloadState}
  ];

  //--------------------------------------------------------------------------Download statement screen code
  final formKeyDS = GlobalKey<FormState>();
  RxString selectedStatementPeriod = "".obs;
  RxString selectedFileFormat = "".obs;
  List<String> statementPeriodsList = ["Last 7 Days","Last 30 Days","Last 3 Months","Last 6 Months","Last Year"]; //custom
  List<String> includeStatement = ["Payouts & Withdrawals","Service Fees","Refunds & Adjustments","Order Sales"];
  List<String> fileFormat = ["PDF","CSV","XLSX"];

  RxList<bool> selectedIncludeStatement = <bool>[].obs;

  final Rx<ApiResponse<CommonExportModel>> _statementData = Rx<ApiResponse<CommonExportModel>>(ApiResponse.completed(null));
  Rx<ApiResponse<CommonExportModel>> get statementData => _statementData;
  setDownloadStatement(ApiResponse<CommonExportModel> response)=>_statementData.value = response;


  Future<void> downloadStatement()async{

    var data = {
      "period": selectedStatementPeriod.value.replaceAll(" ", "_").toLowerCase(),
      // ,"from": "",
      // "to": ""
      "format": selectedFileFormat.value.toLowerCase(),
      "order_sales": selectedIncludeStatement[0],
      "payouts_withdrawals": selectedIncludeStatement[1],
      "service_fees": selectedIncludeStatement[2],
      "refunds_adjustments": selectedIncludeStatement[3]
    };

    setDownloadStatement(ApiResponse.loading());

    try{
      final val =  await api.downloadStatement(jsonEncode(data));

      if(val.status ==  true){
        setDownloadStatement(ApiResponse.completed(val));
        if(val.downloadUrl != null && val.downloadUrl!.isNotEmpty){
          fileDownloadController.downloadAndSaveFile(val.downloadUrl);
        }
      }else{
        setDownloadStatement(ApiResponse.error(val.message));
      }
    }catch(e,s){
      setDownloadStatement(ApiResponse.error(e.toString()));
      pt("error downloading statement $e , $s");
    }

  }

  //--------------------------------------------------------------------------^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

  // RxBool isRedErrorClr = false.obs;
  RxInt radioValue = 0.obs;
  final Color leftBarColor = AppColors.primary;
  final Color rightBarColor = AppColors.yellow;
  final double barWidth = 5.0;
  RxList<String> days = [
    "Today",
    "Last 7 days",
    "Last 30 days",
    // "50 days",
    // "100 days",
  ].obs;
  var selectedAll = Rxn<String>("All");
  var selectedDay = Rxn<String>("Today");
  var chartSelectedDay = Rxn<String>("Last 12 months");

  getInitData()  async {
    chartSelectedDay.value = "Last 12 months";
    // vendorAccountStatusController.getAccountStatusApi();
    selectedIncludeStatement.value = List.generate(includeStatement.length, (_) => false);
    getWalletApi();
  }


  RxList<double> amountForChart = <double>[].obs;
  RxList<String> chartAllDays = <String>[].obs;

  final Rx<ApiResponse<VendorWalletModel>> _walletApiData = Rx<ApiResponse<VendorWalletModel>>(ApiResponse.loading());
  Rx<ApiResponse<VendorWalletModel>> get walletApiData => _walletApiData;
  setWalletData(ApiResponse<VendorWalletModel> response)=>_walletApiData.value = response;

  RxBool isShowChartLoading = false.obs;

  Future<void> getWalletApi({String? range,bool  isSowChartLoading = false,bool isShowLoading = true}) async {
    try {
      if(isSowChartLoading == false && isShowLoading == true) {
        setWalletData(ApiResponse.loading());
      }else{
        if(isSowChartLoading != false) {
          isShowChartLoading.value = true;
        }
      }
      final value = await api.walletApi(queryParameters: {"range": range ?? "last_12_months"});

      if (value.status == true) {
        setWalletData(ApiResponse.completed(value));
        isShowChartLoading.value = false;
        if (value.stats != null) {
          cardSubTitle.assignAll([value.stats?.availableBalance ?? "0",value.stats?.pendingEarnings ?? "0",value.stats?.totalEarnings ?? "0",value.stats?.lastPayout ?? "+0% this month"]);
          carddesTitle.assignAll(["Available for payout","Insurance processing","${value.stats?.monthlyPercentage ?? "0"}% this month",value.stats?.lastPayoutDate ?? ""]);
        }
        if (value.walletOverview?.charts != null) {
          final amount = value.walletOverview?.charts?.map((e) => double.tryParse(e.amount ?? "0") ?? 0.0).toList() ?? [];
          amountForChart.assignAll(amount);

          final days = value.walletOverview?.charts?.map((e) => e.label ?? "").toList() ?? [];
          chartAllDays.assignAll(days);
          pt("amountForChart: ${amountForChart}");
          pt("chartAllDays: ${chartAllDays}");        }
      } else {
        isShowChartLoading.value = false;
        setWalletData(ApiResponse.error(value.message ?? "Something went wrong"));
      }

    } catch (error, stackTrace) {
      pt("Error getting in wallet api $error $stackTrace");
      isShowChartLoading.value = false;
      setWalletData(ApiResponse.error(error.toString()));
    }
  }

  //delete payment method
  final Rx<ApiResponse<CommonResponseModel>> _deletePaymentMethodData = Rx<ApiResponse<CommonResponseModel>>(ApiResponse.completed(null));
  Rx<ApiResponse<CommonResponseModel>> get deletePaymentMethodData => _deletePaymentMethodData;
  setDeletePaymentMethod(ApiResponse<CommonResponseModel> response) => _deletePaymentMethodData.value = response;

  Future<void> deletePaymentMethod({required String paymentMethod,required String id}) async {

    setDeletePaymentMethod(ApiResponse.loading());

    var data = {
      "payment_method": paymentMethod,
      "id": id
    };

    try{
      final value =await api.deletePaymentMethodApi(data);

      if(value.status == true){
        Get.back();
        setDeletePaymentMethod(ApiResponse.completed(value));
        getWalletApi(isSowChartLoading: false,isShowLoading: false);
      }else{
        setDeletePaymentMethod(ApiResponse.error(value.message ?? ""));
      }

    }catch(e,s){
      setDeletePaymentMethod(ApiResponse.error(e.toString() ?? ""));
      pt("Error deleting payment method $e \n $s");
    }

  }


  String maskAccountNumber(String? accountNumber) {
    if (accountNumber == null || accountNumber.length <= 4) {
      return accountNumber ?? "";
    }

    return "**** **** **** ${accountNumber.substring(accountNumber.length - 4)}";
  }

  String maskPhoneNumber(String? number) {
    if (number == null || number.isEmpty) return "";
    String clean = number.replaceAll(" ", "");
    if (!clean.startsWith("+") || clean.length < 8) return number;
    String countryCode = clean.substring(0, 4);
    String remaining = clean.substring(4);
    if (remaining.length <= 3) return number;
    String firstDigit = remaining.substring(0, 1);
    String lastThree = remaining.substring(remaining.length - 3);
    return "$countryCode $firstDigit** *** $lastThree";
  }


  Color getColors(String type) {
    switch (type) {
      case "credit":
        return AppColors.greenClrRatingBar;

      case "withdrawal":
      case "refund":
        return AppColors.red;

      case "orders":
      case "payment":
      case "payout":
      case "commission":
        return AppColors.blueClr;

      default:
        return AppColors.greyClr;
    }
  }

  IconData getIcons(String type) {
    switch (type.toLowerCase()) {
      case "credit":
        return Icons.add;

      case "withdrawal":
        return Icons.remove;

      case "refund":
        return Icons.replay_rounded;

      case "orders":
        return Icons.receipt_long_outlined;

      case "payment":
        return Icons.payments_outlined;

      case "payout":
        return Icons.upload_rounded;

      case "commission":
        return Icons.percent_rounded;

      default:
        return Icons.swap_horiz_rounded;
    }
  }

}
