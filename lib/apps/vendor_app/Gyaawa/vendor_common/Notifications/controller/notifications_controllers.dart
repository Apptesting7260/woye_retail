import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gyaawa/Data/response/api_response.dart';
import '../../../../../../Data/Repository/repository.dart';
import '../../../../../../Data/response/status.dart';
import '../../../../../../Utils/date_format.dart';
import '../../../../../../Utils/snack_bar.dart';
import '../../../../../../shared/theme/colors.dart';
import '../../../../../../shared/widgets/vendor_widgets/print.dart';
import '../../Models/common_response_model.dart';
import '../../Models/status_check_model.dart';
import '../model/notification_model.dart';

class NotificationsController extends GetxController{

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RxList<String> btnName = ["Send Now","Schedule"].obs;
  RxInt selectedTypeIndex = 0.obs;
  Rx<TextEditingController> startDateController = TextEditingController().obs;
  Rx<TextEditingController> searchController = TextEditingController().obs;
  Rx<TextEditingController> endDateController = TextEditingController().obs;
  RxString selectedDateRange = "".obs;
  // Use normal TextEditingController
  TextEditingController subjectTitleController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  static const String customOption = "Custom Message";
  RxBool isSendingNotification = false.obs;

  RxString userRole = "".obs;

  bool get isAccountant => userRole.value.toLowerCase() == UserType.accountant.name;
  bool get isKitchenStaff => userRole.value.replaceAll(" ", "").toLowerCase() == UserType.kitchenstaff.name;
  bool get isServiceStaff => userRole.value.replaceAll(" ", "").toLowerCase() == UserType.servicestaff.name;

  void updateSelectedType(int index){
    selectedTypeIndex.value = index;
    update();
  }

  RxInt selectedIndexForRead = RxInt(-1);
  RxInt selectedIndex = 0.obs;
  updateIndex(int index){
    selectedIndex.value = index;
    getNotifications(isLoading: false,isFilterLoading: true);
  }

  @override
  void onInit() {
    getNotifications();
    super.onInit();
    fetchNotificationTemplates();
  }
  //
  final api = Repository();
  RxString error = ''.obs;
  final apiData = NotificationModel().obs;
  final rxRequestStatusFilter = ApiStatus.COMPLETED.obs;
  final rxRequestStatus = ApiStatus.COMPLETED.obs;
  void setRxRequestStatus(ApiStatus val)=>  rxRequestStatus.value = val;
  void setRxRequestStatusFilter(ApiStatus val)=>  rxRequestStatusFilter.value = val;
  void setError(String val)=>  error.value = val;
  void setNotification(NotificationModel value)=> apiData.value = value;
  List<Notifications> filteredNotifications = <Notifications>[].obs;
  var searchQuery = ''.obs;
  RxString selectedCat = "".obs;

  Future<void> getNotifications({bool? isLoading = true,bool? isFilterLoading = false}) async {
    if(isLoading == true) {
      setRxRequestStatus(ApiStatus.LOADING);
    }
    if(isFilterLoading == true) {
      setRxRequestStatusFilter(ApiStatus.LOADING);
    }
    Map<String, dynamic>? queryParameters = {
      if(searchController.value.text.isNotEmpty)
      "search" :searchController.value.text,
      if(selectedCat.isNotEmpty)
      "category" :selectedCat.value,
    };
    api.getNotificationsApi(queryParameters:queryParameters).then((value) {
      setNotification(value);
      if(apiData.value.status ==true){
        setRxRequestStatus(ApiStatus.COMPLETED);
        setRxRequestStatusFilter(ApiStatus.COMPLETED);
        filteredNotifications.assignAll(apiData.value.notifications ?? []);
        // Future.delayed(const Duration(milliseconds: 500),(){
        //   seenNotifications();
        // });
      }else{
        setError(error.toString());
        setRxRequestStatus(ApiStatus.ERROR);
        setRxRequestStatusFilter(ApiStatus.ERROR);
        debugPrint("Error notification 1 : $error");
      }
    },).onError((error, stackError) {
      setError(error.toString());
      debugPrint("Error notification 2 : $error");
      // Utils.showToast(apiData.value.status.toString());
      setRxRequestStatus(ApiStatus.ERROR);
      setRxRequestStatusFilter(ApiStatus.ERROR);
    });
  }

void searchNotification(String query) {
  searchQuery.value = query.trim().toLowerCase();
  if (searchQuery.value.isEmpty) {
    filteredNotifications.assignAll(apiData.value.notifications ?? []);
  } else {
    final filtered = apiData.value.notifications?.where((notification) {
      final subject = notification.subject?.toLowerCase() ?? '';
      final message = notification.message?.toLowerCase() ?? '';
      final search = searchQuery.value;
      return subject.contains(search) || message.contains(search);
    }).toList();

    filteredNotifications.assignAll(filtered ?? []);
  }
}

Color getPriorityColor(String priority) {
  switch (priority.toLowerCase()) {
    case "high":
      return AppColors.darkBurntOrange;
    case "medium":
      return AppColors.yellowClr;
    case "urgent":
      return AppColors.red;
    case "low":
      return AppColors.lightBlueTextClr; // or AppColors.greyClr
    default:
      return AppColors.greyClr;
  }
}

Color getCategoryColor(String category) {
  switch (category.toLowerCase()) {
    case "orders":
      return AppColors.darkBurntOrange;
    case "reviews":
      return AppColors.yellowClr;
    case "system":
      return AppColors.cyanClr;
    case "all":
      return AppColors.purpleDarkColor;
    default:
      return AppColors.greyClr;
  }
}

// String getCategoryIcon(String category) {
//   switch (category.toLowerCase()) {
//     case "orders":
//       return ImageConstants.doneLogo;
//     case "reviews":
//       return ImageConstants.info;
//     case "system":
//       return ImageConstants.notifications;
//     default:
//       return ImageConstants.notifications;
//   }
// }
//--------------------------mark as read notifications

  final seenNotificationApiData = StatusCheckModel().obs;
  final rxSeenNotificationRequestStatus = ApiStatus.COMPLETED.obs;
  void setSeenNotificationRequestStatus(ApiStatus val)=>  rxSeenNotificationRequestStatus.value = val;
  void setSeenNotification(StatusCheckModel value)=> seenNotificationApiData.value = value;


  seenNotifications({required String id}){
    var data = {
      "id" : id
    };
    setSeenNotificationRequestStatus(ApiStatus.LOADING);
    api.markAsReadApi(data).then((value) {
      setSeenNotification(value);
      if(seenNotificationApiData.value.status ==true){
        debugPrint("Notifications Seen");
        setSeenNotificationRequestStatus(ApiStatus.COMPLETED);
        getNotifications(isFilterLoading: false,isLoading: false);
      }else{
        setError(error.toString());
        setRxRequestStatus(ApiStatus.COMPLETED);
        debugPrint("Error seen notification 1 : $error");
      }
    },).onError((error, stackError) {
      setError(error.toString());
      debugPrint("Error seen notification 2 : $error");
      // if(seenNotificationApiData.value.status != null){
      // Utils.showToast(seenNotificationApiData.value.status.toString());
      // }
      setSeenNotificationRequestStatus(ApiStatus.ERROR);
    });
  }


  //--------------------------mark as read notifications

  final removeNotificationApiData = StatusCheckModel().obs;
  final rxRemoveNotificationRequestStatus = ApiStatus.COMPLETED.obs;
  void setRemoveNotificationRequestStatus(ApiStatus val)=>  rxRemoveNotificationRequestStatus.value = val;
  void setRemoveNotification(StatusCheckModel value)=> removeNotificationApiData.value = value;


  notificationRemove({required String id}){
    var data = {
      "id" : id
    };
    setRemoveNotificationRequestStatus(ApiStatus.LOADING);
    api.notificationRemove(data).then((value) {
      setRemoveNotification(value);
      if(removeNotificationApiData.value.status ==true){
        debugPrint("Notifications Seen");
        setRemoveNotificationRequestStatus(ApiStatus.COMPLETED);
        getNotifications(isFilterLoading: false,isLoading: false);
        Get.back();
      }else{
        setError(error.toString());
        setRemoveNotificationRequestStatus(ApiStatus.COMPLETED);
        debugPrint("Error seen notification 1 : $error");
      }
    },).onError((error, stackError) {
      setError(error.toString());
      debugPrint("Error seen notification 2 : $error");
      // if(seenNotificationApiData.value.status != null){
      // Utils.showToast(seenNotificationApiData.value.status.toString());
      // }
      setRemoveNotificationRequestStatus(ApiStatus.ERROR);
    });
  }
//--------------------------markAllReadApi

  final markAllReadApiNotificationApiData = StatusCheckModel().obs;
  final rxAllReadRequestStatus = ApiStatus.COMPLETED.obs;
  void setAllReadRequestStatus(ApiStatus val)=>  rxAllReadRequestStatus.value = val;
  void setAllReadNotification(StatusCheckModel value)=> markAllReadApiNotificationApiData.value = value;


  notificationAllRead(){
    setAllReadRequestStatus(ApiStatus.LOADING);
    api.markAllReadApi().then((value) {
      setAllReadNotification(value);
      if(markAllReadApiNotificationApiData.value.status ==true){
        debugPrint("Notifications Seen");
        setAllReadRequestStatus(ApiStatus.COMPLETED);
        getNotifications(isFilterLoading: false,isLoading: false);
      }else{
        setError(error.toString());
        setAllReadRequestStatus(ApiStatus.COMPLETED);
        debugPrint("Error seen notification 1 : $error");
      }
    },).onError((error, stackError) {
      setError(error.toString());
      debugPrint("Error seen notification 2 : $error");
      setAllReadRequestStatus(ApiStatus.ERROR);
    });
  }


  //create notifications

  GlobalKey recipientsKey = GlobalKey();
  GlobalKey templateKey = GlobalKey();
  GlobalKey subjectKey = GlobalKey();
  GlobalKey messageKey = GlobalKey();
  GlobalKey priorityKey = GlobalKey();
  GlobalKey dateKey = GlobalKey();
  GlobalKey timeKey = GlobalKey();

  RxString selectedRecipient = "".obs;
  RxString selectedTemplate = "".obs;
  RxString selectedPriority = "".obs;
  RxList<String> selectedNotificationChannel = <String>[].obs;
  RxBool isSelectedNotificationChannel = false.obs;
  RxBool isError = false.obs;
  List<String> recipientsList = ["Customers","Recent Customer","Loyal Customers"];
  // List<String> recipientsList = ["All Customers","Recent Customers (Last 30 days)","Loyal Customers (5+ orders)","All Staff Members","Managers Only","Specific Customer","Delivery Customers","Dine-in Customers","Catering Customers"];
  List<String> priorityList = ["Low","Medium","High","Urgent"];

  // List<Map<String,dynamic>> createNotificationTemplate = [
  //   {"subject" : "Exciting New Menu Items!","message":"We're excited to announce new additions to our menu! Come try our latest creations and taste something amazing.","template" :"New Menu Items"},
  //   {"subject" : "Special Offer Just for You!","message":"Don't miss out on our limited-time special offer. Enjoy great savings on your favorite items.","template" :"Special Offers"},
  //   {"subject" : "Special Offer Just for You!","message":"Don't miss out on our limited-time special offer. Enjoy great savings on your favorite items.","template" :"Event Announcement"},
  //   {"subject" : "Special Offer Just for You!","message":"Don't miss out on our limited-time special offer. Enjoy great savings on your favorite items.","template" :"Hours Change"},
  //   {"subject" : "Special Offer Just for You!","message":"Don't miss out on our limited-time special offer. Enjoy great savings on your favorite items.","template" :"Delivery Update"},
  //   {"subject" : "Special Offer Just for You!","message":"Don't miss out on our limited-time special offer. Enjoy great savings on your favorite items.","template" :"Custom Message"},
  // ];

  final isCustomMode = false.obs;

  void selectCustomMode() {
    isCustomMode.value = true;
    selectedTemplate.value = customOption;

    subjectTitleController.clear();
    messageController.clear();
  }


  final Rx<ApiResponse<CommonResponseModel>> _createNotificationData = Rx(ApiResponse.completed(null));
  Rx<ApiResponse> get notificationData => _createNotificationData;
  setCreateNotification(ApiResponse<CommonResponseModel> value){
    _createNotificationData.value = value;
  }


  RxList<Template> createNotificationTemplate = <Template>[].obs;
  Future<void> fetchNotificationTemplates() async {
    try {
      setCreateNotification(ApiResponse.loading());
      pt("Fetching notification templates...");
      final response = await api.notificationTemplete();
      pt("API response received: status=${response.status}, templates=${response.templates?.length ?? 0}");
      if (response.status == true && response.templates != null && response.templates!.isNotEmpty) {
        createNotificationTemplate.clear();
        createNotificationTemplate.addAll(
          response.templates!.map((e) => Template.fromJson(e)),
        );
      } else {
        createNotificationTemplate.clear();
        clearData();
      }
      setCreateNotification(ApiResponse.completed(null));
    } catch (e) {
      setCreateNotification(ApiResponse.error("Failed to fetch templates"));
      createNotificationTemplate.clear();
      Utils.showToast("Failed to fetch templates");
      pt("Error fetching templates: $e");
    }
  }

//   Future<void> fetchNotificationTemplates() async {
//     try {
//       setCreateNotification(ApiResponse.loading());
//       createNotificationTemplate.clear();
//       pt("Fetching notification templates...");
//       CommonResponseModel response = await api.notificationTemplete();
//       pt("API response received: status=${response.status}, templates=${response.templates?.length ?? 0}");
//       if (response.status == true && response.templates != null && response.templates!.isNotEmpty) {
//         createNotificationTemplate.value =
//             response.templates!.map((e) => Template.fromJson(e)).toList();
//       } else {
//         createNotificationTemplate.clear();
//         clearData();
//       }
//       setCreateNotification(ApiResponse.completed(null));
//     } catch (e) {
//       setCreateNotification(ApiResponse.error("Failed to fetch templates"));
//       createNotificationTemplate.clear();
//       Utils.showToast("Failed to fetch templates");
//       debugPrint("Error fetching templates: $e");
//     }
//   }
// //api call hone ke bad deta cler nhi ho rha h please solve it

  void selectTemplate(String templateName) {
    final selected = createNotificationTemplate.firstWhere(
          (t) => t.name == templateName,
      orElse: () => Template(
          name: '',
          subject: '',
          message: ''),
    );
    selectedTemplate.value = selected.name;
    subjectTitleController.text = selected.subject;
    messageController.text = selected.message;
  }

  createNotification(){
    if (isSendingNotification.value) return;
    isSendingNotification.value = true;
    // setCreateNotification(ApiResponse.loading());
    var data = {
      "recipients": selectedRecipient.value.toLowerCase().replaceAll(" ", "_"),
      "subject": subjectTitleController.value.text,
      "message": messageController.value.text,
      "priority": selectedPriority.value.toLowerCase(),
      "channels": selectedNotificationChannel,
      if(selectedTypeIndex.value == 1)
      "date": FormatDate.convertToApiFormat(startDateController.value.text),
      if(selectedTypeIndex.value == 1)
      "time": endDateController.value.text.toString()
    };
    pt("data body >>>>>>>>>>> $data");

    api.createNotificationsApi(jsonEncode(data)).then((value) {
      if (value.status == true) {
        setCreateNotification(ApiResponse.completed(value));
        Utils.showToast(value.message ?? "");
        clearData();
      } else {
        setError(error.toString());
        setCreateNotification(ApiResponse.error(value.message));
        clearData();
      }
    }).catchError((error) {
      setError(error.toString());
      debugPrint("Error createNotificationsApi: $error");
      setCreateNotification(ApiResponse.error(error.toString()));
    }).whenComplete(() {
      isSendingNotification.value = false;
    });
  }

  clearData(){
    startDateController.value.text = "";
    selectedRecipient.value = "";
    selectedTemplate.value = "";
    subjectTitleController.clear();
    messageController.clear();
    selectedPriority.value = "";
    selectedNotificationChannel.value = [];
    isSelectedNotificationChannel.value = false;
    endDateController.value.clear();
    isError.value = false;
  }

  scrollToField(GlobalKey key){
    final context = key.currentContext;
    if(context!= null){
      Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 200),
          alignment: 0.05
      );
    }
  }
}