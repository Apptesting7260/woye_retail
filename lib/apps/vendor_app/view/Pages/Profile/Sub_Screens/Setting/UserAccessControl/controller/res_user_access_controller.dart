import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../../Core/Constant/image_constant.dart';
import '../../../../../../../../../Data/Repository/repository.dart';
import '../../../../../../../../../Data/response/api_response.dart';
import '../../../../../../../../../Utils/snack_bar.dart';
import '../../../../../../../../../shared/theme/colors.dart';
import '../../../../../../../../../shared/widgets/vendor_widgets/print.dart';
import '../../../../../../vendor_common/Models/common_response_model.dart';
import '../model/res_user_access_model.dart';

class ResUserAccessController extends GetxController{

  final repo = Repository();

  @override
  void onInit() {
    getUserAccessApi();
    super.onInit();
  }


  List<Map<String,dynamic>> userList = [
    {"userRole":"Owner","accessType":"Full Access","description":"Complete control over all restaurant operations","color" : AppColors.redBgClr},
    {"userRole":"Manager","accessType":"Full access except user control","description":"Manage orders, menu, and staff","color" : AppColors.yellowClr},
    {"userRole":"Accountant","accessType":"Wallet","description":"View orders and update status","color" : AppColors.primary},
    {"userRole":"Kitchen Staff","accessType":"Orders","description":"Managing kitchen tasks, and updating order preparation status.","color" : AppColors.blueClr},
    {"userRole":"Service Staff","accessType":"Reviews","description":"Manages table service or deliveries, and ensures smooth order fulfillment.","color" : AppColors.greenClr},
  ];

  List<Map<String,dynamic>> quickActionList = [
    {"name":"Add New User","icon":ImageConstants.adduser},
    {"name":"Manage Roles","icon":ImageConstants.manageRole},
    {"name":"Reset Passwords","icon":ImageConstants.key},
    {"name":"View Activity Log","icon":ImageConstants.history},
  ];



  final Rx<ApiResponse<UserAccessModel>> _userAccessData = Rx<ApiResponse<UserAccessModel>>(ApiResponse.loading());
  Rx<ApiResponse<UserAccessModel>>  get userAccessData => _userAccessData;
  setUserAccessData(ApiResponse<UserAccessModel> apiData){
    _userAccessData.value = apiData;
  }


  Future<void> getUserAccessApi({bool isRefresh = true})async{
    if(isRefresh == true) {
      setUserAccessData(ApiResponse.loading());
    }
    repo.getUserAccess().then((value) async {
      if(value.status == true){
        setUserAccessData(ApiResponse.completed(value));
      }else{
        setUserAccessData(ApiResponse.error(value.message.toString()));
      }
    }).onError((error, stackTrace) {
      setUserAccessData(ApiResponse.error(error.toString()));
      // Utils.showToast('Error: $error');
      debugPrint('Error: $error');
    },
    );

  }


  //get user details
  final Rx<ApiResponse<CommonResponseModel>> _deleteUserDetails = Rx<ApiResponse<CommonResponseModel>>(ApiResponse.completed(null));
  Rx<ApiResponse<CommonResponseModel>> get deleteUserDetails => _deleteUserDetails;
  setDeleteUserApiData(ApiResponse<CommonResponseModel> value){
    _deleteUserDetails.value = value;
  }

  Future<void> deleteUserDetailsApi(String userId)async{
    setDeleteUserApiData(ApiResponse.loading());
    var data = {
      "id" : userId
    };
    repo.deleteUser(data).then((value) {
      if(value.status == true){
        setDeleteUserApiData(ApiResponse.completed(value));
        Utils.showToast(value.message ?? "");
        getUserAccessApi(isRefresh: false);
        Get.back();
      }else{
        setDeleteUserApiData(ApiResponse.error(value.message.toString()));
        Utils.showToast(value.message ?? "");
      }
    },).onError((error, stackTrace) {
      setDeleteUserApiData(ApiResponse.error(error.toString()));
      pt(error.toString());
    },);

  }


}