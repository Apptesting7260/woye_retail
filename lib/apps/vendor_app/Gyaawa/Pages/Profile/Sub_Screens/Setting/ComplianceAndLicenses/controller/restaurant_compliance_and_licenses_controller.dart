import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../../Core/Constant/image_constant.dart';
import '../../../../../../../../../Data/Repository/repository.dart';
import '../../../../../../../../../Data/response/api_response.dart';
import '../../../../../../../../../Utils/snack_bar.dart';
import '../../../../../../../../../shared/theme/colors.dart';
import '../../../../../../vendor_common/Models/common_response_model.dart';
import '../model/get_compliance_and_licenses_model.dart';

class ComplianceAndLicensesController extends GetxController{
  final List<Map<String, dynamic>> documentStatusList = [
    {
      "image": ImageConstants.done,
      "title": "Approved",
    },
    {
      "image": ImageConstants.pending,
      "title": "Pending Review",
    },
    {
      "image": ImageConstants.expired,
      "title": "Expiring Soon",
    },
    {
      "image": ImageConstants.documents,
      "title": "Total Documents",
    },
  ];

  final repo = Repository();

  @override
  void onInit() {
    getComplianceApi();
    super.onInit();
  }
  
  final Rx<ApiResponse<GetComplianceAndLicensesModel>> _complianceApiData = Rx<ApiResponse<GetComplianceAndLicensesModel>>(ApiResponse.loading());
  Rx<ApiResponse<GetComplianceAndLicensesModel>>  get complianceApiData => _complianceApiData;
  setComplianceData(ApiResponse<GetComplianceAndLicensesModel> apiData){
    _complianceApiData.value = apiData;
  }


  Future<void> getComplianceApi({bool isRefresh = true})async{
    if(isRefresh == true) {
      setComplianceData(ApiResponse.loading());
    }
      repo.getCompliance().then((value) async {
        if(value.status == true){
          setComplianceData(ApiResponse.completed(value));
        }else{
          setComplianceData(ApiResponse.error(value.message.toString()));
        }
      }).onError((error, stackTrace) {
        setComplianceData(ApiResponse.error(error.toString()));
        // Utils.showToast('Error: $error');
        debugPrint('Error: $error');
      },
      );

  }


  //delete

  RxInt selectedIndex = RxInt(-1);
  final Rx<ApiResponse<CommonResponseModel>> _deleteComplianceApiData = Rx<ApiResponse<CommonResponseModel>>(ApiResponse.completed(null));
  Rx<ApiResponse<CommonResponseModel>>  get deleteComplianceApiData => _deleteComplianceApiData;
  setDeleteComplianceData(ApiResponse<CommonResponseModel> apiData){
    _deleteComplianceApiData.value = apiData;
  }


  Future<void> deleteComplianceApi(String type)async{
      setDeleteComplianceData(ApiResponse.loading());
    var data = {
      "type" :type
    };
      repo.deleteComplianceDocDetails(data).then((value) async {
        if(value.status == true){
          setDeleteComplianceData(ApiResponse.completed(value));
          Utils.showToast(value.message?.replaceAll("_", " ") ?? "");
          getComplianceApi(isRefresh: false);
          Get.back();
        }else{
          Utils.showToast(value.message?.replaceAll("_", " ") ?? "");
          setDeleteComplianceData(ApiResponse.error(value.message.toString()));
        }
      }).onError((error, stackTrace) {
        setDeleteComplianceData(ApiResponse.error(error.toString()));
        // Utils.showToast('Error: $error');
        debugPrint('Error: $error');
      },
      );

  }

  Color getStatusBg(String? status) {
    switch (status) {
      case "":
        return AppColors.greyClr.withAlpha(20);

      case "pending":
        return AppColors.yellowClr.withAlpha(20);

      case "approved":
        return AppColors.greenClr.withAlpha(20);

      case "expired":
        return AppColors.red.withAlpha(20);

      default:
        return AppColors.cardBgColor;
    }
  }

  Color getStatusTextColor(String? status) {
    switch (status) {
      case "":
        return AppColors.greyClr;

      case "pending":
        return AppColors.yellowClr;

      case "approved":
        return AppColors.greenClr;

      case "expired":
        return AppColors.red;

      default:
        return AppColors.primary;
    }
  }

  String getStatusText(String? status) {
    if (status == "" || status == null) return "Optional";
    return status.capitalizeFirst.toString();
  }

}