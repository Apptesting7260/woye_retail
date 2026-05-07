import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:gyaawa/apps/vendor_app/view/vendor_common/Models/order_list_model.dart';
import '../../../../../../Core/Constant/image_constant.dart';
import '../../../../../../Data/Repository/repository.dart';
import '../../../../../../Data/response/api_response.dart';
import '../../../../../../Data/response/status.dart';
import '../../../../../../Data/user_preference_controller.dart';
import '../../../../../../Utils/snack_bar.dart';
import '../../../../../../shared/theme/colors.dart';
import '../../../../../../shared/widgets/vendor_widgets/print.dart';
import '../../../vendor_common/FileDownload/file_download_controller.dart';
import '../../../vendor_common/Models/common_export_model.dart';
import '../../../vendor_common/Models/common_response_model.dart';
import '../SubScreens/OrderDetails/model/order_accept_reject_model.dart';
import '../model/restro_order_list_model.dart';

class RestaurantOrderController extends GetxController {
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  Rx<TextEditingController> reasonForRejectionController = TextEditingController().obs;
  TextEditingController contactSupportController = TextEditingController();

  final GlobalKey<FormState> cancelFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> contactCustomerFormKey = GlobalKey<FormState>();

  RxString userRole = "".obs;

  final List<String> iconList = [ImageConstants.greenCartSvg,ImageConstants.timer,ImageConstants.done,ImageConstants.time];
  List<Color> cardColor = [AppColors.greenTextClr,AppColors.yellow,AppColors.greenClr,AppColors.purpleColor];
  List<String> cardTitle = ["Today's Orders","Pending Orders","Completed Orders","Avg Prep Time"];
  GlobalKey<FormState> fromKeyExport = GlobalKey<FormState>();

  RxString selectedCustomerSubject = "".obs;
  RxString selectedDateRange = "".obs;
  RxString selectedOrderType = "".obs;
  RxString selectedTime = "".obs;
  RxString selectedPaymentType = "".obs;
  RxString selectedRatingExport = "".obs;
  RxString selectedQuickResponse = "".obs;
  setSelectedQuickResponse(index){
    selectedQuickResponse.value = quickResponse[index];
    reasonForRejectionController.value.text = quickResponse[index];
  }

  RxInt selectedFormat = 0.obs;
  void toggleFormat(int index) {
    selectedFormat.value = index;
  }
  RxBool isRejectEnabled = false.obs;

  @override
  void onInit() async {
    userRole.value = await UserPreference.getUserRole();
    reasonForRejectionController.value.addListener(() {
      isRejectEnabled.value = reasonForRejectionController.value.text.trim().isNotEmpty;
    });
    super.onInit();
  }

  Map<String, String> orderTypeMap = {
    "All Orders": "all",
    "Pending": "pending",
    "Preparing": "preparing",
    "Ready For Pickup": "ready_for_pickup",
    "Out for Delivery": "out_for_delivery",
    "Delivered": "delivered",
    "Cancelled": "cancelled",
    "Preorder":"preorder"
  };

  Map<String, String> timeMap = {
    "Today": "today",
    "Yesterday": "yesterday",
    "This Week": "this_week",
    "Last Week": "last_week",
    "This Month": "this_month",
  };
  RxList<String> status =["All", "Pending", "Processing", "Delivered", "Cancelled"].obs;
  Map<String, String> paymentTypeMap = {
    "All Payment ": "all",
    "Credit Card": "credit_card",
    "Cash": "cash_on_delivery",
    "Digital Wallet": "wallet",
  };
  List<String> dateRangeList = ["All Time","Today","Yesterday","This Week","Last Week","This Month","Last Month","Custom Range"];
  List<String> quickResponse = ["Items currently unavailable","Restaurant is too busy","Kitchen equipment malfunction","Insufficient staff","Outside delivery area"];
  List<String> contactCustomerSubList = ["Order Delay Notification","Ingredient Substitution","Special Dietary Request","Delivery Update","Order Confirmation","Custom Message"];

  RxString selectedStatus = "All".obs;

  RxString fromNotification = "".obs;

  final List<String> subTitleList = [
    "All Orders",
    "Delivered Orders",
    "Pending Orders",
    "Cancelled Orders"
  ];

  final List<String> imagePath = [
    ImageConstants.productLogo,
    ImageConstants.checkCircleLogo,
    ImageConstants.balanceImage,
    ImageConstants.cancelPngImage
  ];

  final rxRequestStatus = ApiStatus.COMPLETED.obs;
  final rxRequestStatusForFilter = ApiStatus.COMPLETED.obs;
  RxString error = ''.obs;
  final api = Repository();
  final apiData = OrdersModel().obs;

  void setRxRequestStatus(ApiStatus value) => rxRequestStatus.value = value;
  void setRxRequestStatusForFilter(ApiStatus value) => rxRequestStatusForFilter.value = value;

  void orderSetData(OrdersModel value) => apiData.value = value;

  void setError(String value) => error.value = value;

  Future<void> orderApi({bool? isRefresh = true,String? selectedPaymentMethod,String? status,String? time,bool isLoadingRecentOrders = false}) async {
    if(isRefresh == true) {
      setRxRequestStatus(ApiStatus.LOADING);
    }
    if(isLoadingRecentOrders == true){
      setRxRequestStatusForFilter(ApiStatus.LOADING);
    }
    Map<String, dynamic>? queryParameters = {
      if(status?.isNotEmpty ?? false)
      "status": status,
      if(time?.isNotEmpty ?? false)
      "time": time,
      if(selectedPaymentMethod?.isNotEmpty ?? false)
      "payment_method":selectedPaymentMethod,
    };
    api.getOrderAPI(queryParameters: queryParameters).then((value) {
      orderSetData(value);
      setRxRequestStatus(ApiStatus.COMPLETED);
      setRxRequestStatusForFilter(ApiStatus.COMPLETED);
      // log(value.toString(), name: "All orders data");
    }).onError((error, stackError) {
      setError(error.toString());
      pt(error.toString());
      setRxRequestStatus(ApiStatus.ERROR);
      setRxRequestStatusForFilter(ApiStatus.ERROR);
    });
  }

  //Search
  var searchQuery = ''.obs;
  var searchResultList = <dynamic>[].obs;
  Rx<TextEditingController> searchController = TextEditingController().obs;
  RxList<OrderAll> filterListOfProducts = RxList<OrderAll>([]);

  //------------------------------------review export
  final Rx<ApiResponse<CommonExportModel>> _reviewsExportApiData = Rx<ApiResponse<CommonExportModel>>(ApiResponse.completed(null));
  Rx<ApiResponse<CommonExportModel>> get reviewsExportApiData => _reviewsExportApiData;
  setReviewsExportApiData(ApiResponse<CommonExportModel> data){
    _reviewsExportApiData.value = data;
  }

  Future<void> orderExport({bool showLoading = true})async{
    if(showLoading == true) {
      setReviewsExportApiData(ApiResponse.loading());
    }

    var data ={
      "format" : selectedFormat.value == 0 ? "csv" : "excel",
      "date_range" : selectedDateRange.value == "All Time" ? selectedDateRange.value.toLowerCase().split(" ").first.toString()
          : selectedDateRange.value.toLowerCase().replaceAll(" ","_"),
      if(selectedDateRange.value == "Custom Range" && startDateController.text.isNotEmpty)
        "start_date" : convertDate(startDateController.text),
      if(selectedDateRange.value == "Custom Range" && endDateController.text.isNotEmpty)
        "end_date" : convertDate(endDateController.text),
      if(selectedRatingExport.value.isNotEmpty)
        "status" : selectedRatingExport.value.toLowerCase().split(" ").first.toString(),
    };

    pt("data >>>>> $data");

    api.orderExportApi(jsonEncode(data)).then((value) {
      if(value.status == true){
        FileDownloadController fileDownloadController = Get.put(FileDownloadController());
        fileDownloadController.downloadAndSaveFile(
            value.downloadUrl ?? "",
            saveInDownload: true).then((val) {
          // Utils.showToast(value.message ?? "");
          setReviewsExportApiData(ApiResponse.completed(value));
        },);
      }else{
        Utils.showToast(value.message ?? "");
        setReviewsExportApiData(ApiResponse.error(value.message.toString()));
      }
    },).onError((error, stackTrace) {
      pt("error in setReviewsExportApiData $error");
      setReviewsExportApiData(ApiResponse.error(error.toString()));
    },);
  }




  //Accept Order APi
  final rxRequestAcceptOrderStatus = ApiStatus.COMPLETED.obs;

  void setRxRequestAcceptOrderStatus(ApiStatus value) => rxRequestAcceptOrderStatus.value = value;
  final orderAcceptApiData = OrderAcceptAndRejectModel().obs;
  void ordersAcceptData(OrderAcceptAndRejectModel value) => orderAcceptApiData.value = value;

  Future<void> acceptOrderApi({required String id}) async {
    var data = {
      "id": id
    };
    setRxRequestAcceptOrderStatus(ApiStatus.LOADING);
    api.acceptOrderApi(jsonEncode(data)).then((value) {
      ordersAcceptData(value);
      if(orderAcceptApiData.value.status==true){
        setRxRequestAcceptOrderStatus(ApiStatus.COMPLETED);
        Utils.showToast(orderAcceptApiData.value.message.toString());
        orderApi(isRefresh: false,isLoadingRecentOrders: false);
        Get.back();
      }else{
        setRxRequestAcceptOrderStatus(ApiStatus.COMPLETED);
        Utils.showToast(orderAcceptApiData.value.message.toString());
      }
    }).onError((error, stackError) {
      setError(error.toString());
      pt(error.toString(), name: "Error");
      setRxRequestAcceptOrderStatus(ApiStatus.ERROR);
    });
  }

//Mark ready
 final rxRequestMarkReady = ApiStatus.COMPLETED.obs;

  void setRxRequestMarkReady(ApiStatus value) => rxRequestMarkReady.value = value;
  final markReadyApiData = CommonResponseModel().obs;
  void markReadyData(CommonResponseModel value) => markReadyApiData.value = value;

  Future<void> markReadyApi({required String id}) async {
    var data = {
      "id": id
    };
    setRxRequestMarkReady(ApiStatus.LOADING);
    api.markReadyApi(jsonEncode(data)).then((value) {
      markReadyData(value);
      if(markReadyApiData.value.status==true){
        setRxRequestMarkReady(ApiStatus.COMPLETED);
        Utils.showToast(markReadyApiData.value.message.toString());
        orderApi(isRefresh: false,isLoadingRecentOrders: false);
        Get.back();
      }else{
        setRxRequestSimulateDelivery(ApiStatus.COMPLETED);
      }
    }).onError((error, stackError) {
      setError(error.toString());
      pt(error.toString(), name: "Error");
      setRxRequestMarkReady(ApiStatus.ERROR);
    });
  }

//Reject Order APi


  Rx<TextEditingController> cancelProductController  = Rx(TextEditingController());

  final rxRequestRejectOrderStatus = ApiStatus.COMPLETED.obs;

  void setRxRequestRejectOrderStatus(ApiStatus value) => rxRequestRejectOrderStatus.value = value;

  Future<void> rejectOrderApi({required String orederId}) async {
    var data = {
      "id":orederId.toString(),
      "reason" :reasonForRejectionController.value.text,
    };
    pt("data >>>>>> $data");
    setRxRequestRejectOrderStatus(ApiStatus.LOADING);
    api.rejectOrderApi(jsonEncode(data)).then((value) {
      if(value.status == true || value.errors.isEmpty){
        setRxRequestRejectOrderStatus(ApiStatus.COMPLETED);
        Get.back();
        orderApi(isRefresh: false,isLoadingRecentOrders: false);
        Utils.showToast(value.message ?? "Order Rejected!");
        reasonForRejectionController.value.clear();
      }
      if(value.errors.isNotEmpty){
        setRxRequestRejectOrderStatus(ApiStatus.COMPLETED);
        Utils.showToast(value.message);
      }
    }).onError((error, stackError) {
      setError(error.toString());
      pt(error.toString(), name: "Error");
      setRxRequestRejectOrderStatus(ApiStatus.ERROR);
    });
  }


  //Simulate Pickup
  final rxRequestSimulatePickup = ApiStatus.COMPLETED.obs;

  void setRxRequestSimulatePickup(ApiStatus value) => rxRequestSimulatePickup.value = value;
  final simulatePickupApiData = CommonResponseModel().obs;
  void simulatePickupData(CommonResponseModel value) => simulatePickupApiData.value = value;

  Future<void> simulatePickupApi({required String id}) async {
    var data = {
      "id": id
    };
    setRxRequestSimulatePickup(ApiStatus.LOADING);
    api.simulatePickupApi(jsonEncode(data)).then((value) {
      simulatePickupData(value);
      if(simulatePickupApiData.value.status==true){
        setRxRequestSimulatePickup(ApiStatus.COMPLETED);
        Utils.showToast(simulatePickupApiData.value.message.toString());
        orderApi(isRefresh: false,isLoadingRecentOrders: false);
        Get.back();
      }else{
        setRxRequestSimulateDelivery(ApiStatus.COMPLETED);

      }
    }).onError((error, stackError) {
      setError(error.toString());
      pt(error.toString(), name: "Error");
      setRxRequestSimulatePickup(ApiStatus.ERROR);
    });
  }


 //Simulate delivery
  final rxRequestSimulateDelivery = ApiStatus.COMPLETED.obs;

  void setRxRequestSimulateDelivery(ApiStatus value) => rxRequestSimulateDelivery.value = value;
  final simulateDeliveryApiData = CommonResponseModel().obs;
  void simulateDeliveryData(CommonResponseModel value) => simulateDeliveryApiData.value = value;

  Future<void> simulateDeliveryApi({required String id}) async {
    var data = {
      "id": id
    };
    setRxRequestSimulateDelivery(ApiStatus.LOADING);
    api.simulateDeliveryApi(jsonEncode(data)).then((value) {
      simulateDeliveryData(value);
      if(simulateDeliveryApiData.value.status==true){
        setRxRequestSimulateDelivery(ApiStatus.COMPLETED);
        Utils.showToast(simulateDeliveryApiData.value.message.toString());
        orderApi(isRefresh: false,isLoadingRecentOrders: false);
        Get.back();
      }else{
        setRxRequestSimulateDelivery(ApiStatus.COMPLETED);
      }
    }).onError((error, stackError) {
      setError(error.toString());
      pt(error.toString(), name: "Error");
      setRxRequestSimulateDelivery(ApiStatus.ERROR);
    });
  }


 //Contact Support
  final rxRequestContactCustomer = ApiStatus.COMPLETED.obs;

  void setRxRequestContactCustomer(ApiStatus value) => rxRequestContactCustomer.value = value;
  final contactCustomerApiData = CommonResponseModel().obs;
  void contactCustomerSet(CommonResponseModel value) => contactCustomerApiData.value = value;

  Future<void> contactCustomerApi({required String id}) async {
    var data = {
      "id": id,
      "subject" : selectedCustomerSubject.value,
      "message" : contactSupportController.text
    };
    setRxRequestContactCustomer(ApiStatus.LOADING);
      api.contactCustomer(jsonEncode(data)).then((value) {
      contactCustomerSet(value);
      if(contactCustomerApiData.value.status==true){
        setRxRequestContactCustomer(ApiStatus.COMPLETED);
        Utils.showToast(contactCustomerApiData.value.message.toString());
        selectedCustomerSubject.value = "";
        contactSupportController.clear();
        Get.back();
      }else{
        setRxRequestContactCustomer(ApiStatus.COMPLETED);
      }
    }).onError((error, stackError) {
      setError(error.toString());
      pt(error.toString(), name: "Error");
      setRxRequestContactCustomer(ApiStatus.ERROR);
    });
  }


  String convertDate(String input) {
    final parts = input.split("/");
    return "${parts[2]}-${parts[0]}-${parts[1]}";
  }


  Color getColors(String type) {
    switch (type) {
      case "pending":
        return AppColors.yellowClr;

      case "preparing":
        return AppColors.blueClr;

      case "pending_pick_up":
        return AppColors.orange;

      case "ready_for_pickup":
              return AppColors.orange;

      case "out_for_delivery":
        return AppColors.purpleColor;

      case "delivered":
        return AppColors.primary;

      case "cancelled":
          return AppColors.red;

      default:
        return AppColors.greyClr;
    }
  }



   getIcons(String type) {
    switch (type) {
      case "pending":
        return ImageConstants.timer;

      case "preparing":
        return ImageConstants.kitchen ;

       case "cancelled":
        return ImageConstants.cancelPngImage ;

      default:
        return ImageConstants.timer;
    }
  }

  GlobalKey todayOrdersKey = GlobalKey();

  scrollToFields(GlobalKey key){
    final context = key.currentContext;
    if(context != null){
      Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: 0.01
      );
    }
  }

}
