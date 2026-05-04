import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gyaawa/Data/response/status.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/Profile/Sub_Screens/Setting/RestaurantInformation/controller/restaurant_information_controller.dart';
import 'package:gyaawa/apps/vendor_app/view/vendor_common/AccountStatus/controller/vendor_account_status_controller.dart';
import 'package:gyaawa/apps/vendor_app/view/vendor_common/Models/common_response_model.dart';
import 'package:gyaawa/apps/vendor_app/view/vendor_common/Models/dashboard_model.dart';
import 'package:gyaawa/apps/vendor_app/view/vendor_navbar/controller/vendor_navbar_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../../Core/Constant/image_constant.dart';
import '../../../../../../Data/Repository/repository.dart';
import '../../../../../../Data/response/api_response.dart';
import '../../../../../../Utils/snack_bar.dart';
import '../../../../../../shared/theme/colors.dart';
import '../../../../../../shared/widgets/vendor_widgets/print.dart';

class RestaurantDashboardController extends GetxController {
  var selectedRevenueTrend =  Rxn<String>("");
  var recentOrderSelectedDay =Rxn<String>("");

  List<Color> recentOrderCardClr = [AppColors.primary,AppColors.lightBleColor,AppColors.yellowClr];

  FillRestaurantDetailsController fillRestaurantDetailsController =  Get.put(FillRestaurantDetailsController());
  VendorNavbarController vendorNavbarController = Get.put(VendorNavbarController());
  VendorAccountStatusController vendorAccountStatusController = Get.put(VendorAccountStatusController());
  RxBool getProfile = false.obs;


getInitData() async {
  // await  vendorAccountStatusController.getAccountStatusApi();

  SharedPreferences preferences = await SharedPreferences.getInstance();
    var isLogin = preferences.getBool("isLogin");
    var token = preferences.getString("token");
    if(isLogin != null  && isLogin == true && token != null) {
      await dashboardApi();
      // await chartApi();
      // if(!getProfile.value){
      //   await fillRestaurantDetailsController.getProfileDetailsApi();
      //   getProfile.value = true;
      // }
    }
  }



  RxList labels = [].obs;

  final rxRequestStatus = ApiStatus.COMPLETED.obs;
  final rxRequestStatusForRevenue = ApiStatus.COMPLETED.obs;
  final rxRequestStatusForOrder = ApiStatus.COMPLETED.obs;
  RxString error = ''.obs;
  final api = Repository();
  final apiData = DashboardModel().obs;

  void setRxRequestStatus(ApiStatus value) => rxRequestStatus.value = value;
  void setRxRequestStatusOrder(ApiStatus value) => rxRequestStatusForOrder.value = value;
  void setRxRequestStatusRevenue(ApiStatus value) => rxRequestStatusForRevenue.value = value;

  void dashboardSetData(DashboardModel value) => apiData.value = value;

  void setError(String value) => error.value = value;

  Future<void> dashboardApi({bool isRefresh = true,bool isRevenueLoading = false,bool isOrderLoading = false}) async {
    if(isRefresh == true) {
      setRxRequestStatus(ApiStatus.LOADING);
    }
    if(isRevenueLoading == true){
      setRxRequestStatusRevenue(ApiStatus.LOADING);
    }
    if(isOrderLoading == true){
      setRxRequestStatusOrder(ApiStatus.LOADING);
    }
    Map<String, dynamic>? queryParameters = {
      "revenue_filter":(selectedRevenueTrend.value?.isNotEmpty ?? false) ? selectedRevenueTrend.value?.toLowerCase().replaceAll(" ", "_") : "last_7_days",
      "order_status_filter" :(recentOrderSelectedDay.value?.isNotEmpty ?? false) ? recentOrderSelectedDay.value?.toLowerCase() : "today",
    };
    api.getDashboardApi(queryParameters: queryParameters).then((value) {
      dashboardSetData(value);
      setRxRequestStatus(ApiStatus.COMPLETED);
      setRxRequestStatusRevenue(ApiStatus.COMPLETED);
      setRxRequestStatusOrder(ApiStatus.COMPLETED);
      isShopOpen.value = apiData.value.dashboard?.shopStatus == "1" ? true : false;
      labels.assignAll(apiData.value.dashboard?.revenueTrend?.labels ?? []);
      // calculateMinAndMaxVal(peak: apiData.value.dashboard?.revenueTrend?.peak ?? "0", totalRevenue: apiData.value.dashboard?.revenueTrend?.toa)
      pt("labels>>>>>>>>>> $labels");
      debugPrint("response data $value ");
    }).onError((error, stackError) {
      setError(error.toString());
      debugPrint(error.toString());
      setRxRequestStatus(ApiStatus.ERROR);
      setRxRequestStatusRevenue(ApiStatus.ERROR);
      setRxRequestStatusOrder(ApiStatus.ERROR);
    });
  }

  // Toggle button switch

  final Rx<ApiResponse<CommonResponseModel>> _switchBtnData = Rx<ApiResponse<CommonResponseModel>>(ApiResponse.completed(null));
  Rx<ApiResponse<CommonResponseModel>> get switchBtnData => _switchBtnData;
  setSwitchData(ApiResponse<CommonResponseModel> response){
    _switchBtnData.value = response;
  }

  Future<void> toggleShopStatus() async {

    setSwitchData(ApiResponse.loading());

    var data = {
      "shop_status": isShopOpen.value == true ? "1" : "0",
    };

    await api.shopStatusApi(jsonEncode(data)).then((value) {
      if(value.status == true){
        setSwitchData(ApiResponse.completed(value));
        Utils.showToast(value.message ?? "");
        dashboardApi(isOrderLoading: false,isRefresh: false,isRevenueLoading: false);
      }else{
        setSwitchData(ApiResponse.completed(value));
        Utils.showToast(value.message ?? "");
      }
    },).onError((error, stackTrace) {
      pt("error while updating shop status $error  $stackTrace");
      Utils.showToast(error.toString());
    },);

  }

  RxBool isShopOpen = false.obs;

  void toggleSwitch(bool value) {
    isShopOpen.value = value;
    toggleShopStatus();
  }


  GlobalKey todayRevenueKey = GlobalKey();

  scrollToFields(GlobalKey key){
    final context = key.currentContext;
    if(context != null){
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
          alignment: 0.05
      );
    }
  }

  final List<String> iconList = [
    ImageConstants.revenue,
    ImageConstants.productImage,
    ImageConstants.save,
    ImageConstants.starLogo,
  ];

  List<Color> cardColor = [AppColors.primary,AppColors.blueClr,AppColors.purpleColor,AppColors.yellowClr];
  List<String> cardTitle = ["Today’s Revenue","Total Products","Avg Order Value","Customer Rating"];
  List<String> revenueTrend = ["Last 7 Days","Last 30 Days","Last 3 Month","Last 12 Months"];
  List<String> orderStatusList = ["Today","Week","Month","Year"];

  getOrdersCardClr(String type){
    switch(type){
      case "Delivered" :
       return AppColors.primary;
      case "Pending":
        return AppColors.yellowClr;
      case "Processing":
        return AppColors.blueClr;
      default:
        return AppColors.greenClr;
    }
  }

}
