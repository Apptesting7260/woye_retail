import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:gyaawa/apps/vendor_app/Gyaawa/Pages/ChooseRestaurantCategories/model/res_category_cusion_model.dart';
import 'package:gyaawa/apps/vendor_app/Gyaawa/Pages/OrdersDetails/model/restro_order_list_model.dart';
import 'package:gyaawa/apps/vendor_app/Gyaawa/Pages/RestaurantAddProduct/Models/restaurant_get_addon_model.dart';
import 'package:gyaawa/apps/vendor_app/Gyaawa/Pages/RestaurantAddProduct/Models/restaurant_get_cuisine_type_model.dart';
import 'package:gyaawa/apps/vendor_app/Gyaawa/Pages/menu/model/restaurant_menu_model.dart';
import 'package:gyaawa/apps/vendor_app/Gyaawa/vendor_common/Models/common_add_product_model.dart';
import 'package:gyaawa/apps/vendor_app/Gyaawa/vendor_common/Models/common_export_model.dart';
import 'package:gyaawa/apps/vendor_app/Gyaawa/vendor_common/Models/common_get_category_model.dart';
import 'package:gyaawa/apps/vendor_app/Gyaawa/vendor_common/Models/common_response_model.dart';
import 'package:gyaawa/apps/vendor_app/Gyaawa/vendor_common/Models/dashboard_model.dart';
import 'package:gyaawa/apps/vendor_app/Gyaawa/vendor_common/Models/faq_privacy_term_condition_model.dart';
import 'package:gyaawa/apps/vendor_app/Gyaawa/vendor_common/Models/order_list_model.dart';
import 'package:gyaawa/apps/vendor_app/Gyaawa/vendor_common/Models/product_delete_model.dart';
import 'package:gyaawa/apps/vendor_app/Gyaawa/vendor_common/Models/support_chat_reply_model.dart';
import '../../Core/Constant/app_urls.dart';
import '../../apps/vendor_app/Gyaawa/Pages/ChooseRestaurantCategories/model/new_categories_model.dart';
import '../../apps/vendor_app/Gyaawa/Pages/ChooseRestaurantCategories/model/update_categories_model.dart';
import '../../apps/vendor_app/Gyaawa/Pages/FillRestaurantDetails/model/profile_details_model.dart';
import '../../apps/vendor_app/Gyaawa/Pages/OrdersDetails/SubScreens/OrderDetails/model/order_accept_reject_model.dart';
import '../../apps/vendor_app/Gyaawa/Pages/OrdersDetails/SubScreens/OrderDetails/model/resaurant_order_details_model.dart';
import '../../apps/vendor_app/Gyaawa/Pages/Products/Sub_screen/EditProduct/Model/res_single_product_model.dart';
import '../../apps/vendor_app/Gyaawa/Pages/Profile/Sub_Screens/OrderTransactionHistory/model/res_order_transaction_history.dart';
import '../../apps/vendor_app/Gyaawa/Pages/Profile/Sub_Screens/Product_Review/model/review_replay_model.dart';
import '../../apps/vendor_app/Gyaawa/Pages/Profile/Sub_Screens/Product_Review/model/reviews_model.dart';
import '../../apps/vendor_app/Gyaawa/Pages/Profile/Sub_Screens/RestaurantCategory/SubScreens/model/all_category_model.dart';
import '../../apps/vendor_app/Gyaawa/Pages/Profile/Sub_Screens/RestaurantCategory/model/category_model.dart';
import '../../apps/vendor_app/Gyaawa/Pages/Profile/Sub_Screens/Setting/AddMenuCategories/model/restaurant_get_selected_categories_model.dart';
import '../../apps/vendor_app/Gyaawa/Pages/Profile/Sub_Screens/Setting/AddNewUser/model/get_user_details_model.dart';
import '../../apps/vendor_app/Gyaawa/Pages/Profile/Sub_Screens/Setting/ComplianceAndLicenses/SubScreens/DocumentsDetail/model/res_document_details_model.dart';
import '../../apps/vendor_app/Gyaawa/Pages/Profile/Sub_Screens/Setting/ComplianceAndLicenses/model/get_compliance_and_licenses_model.dart';
import '../../apps/vendor_app/Gyaawa/Pages/Profile/Sub_Screens/Setting/RestaurantInFormation/model/profile_details_model.dart';
import '../../apps/vendor_app/Gyaawa/Pages/Profile/Sub_Screens/Setting/RestaurantInFormation/model/register_vendor_model.dart';
import '../../apps/vendor_app/Gyaawa/Pages/Profile/Sub_Screens/Setting/RestaurantInFormation/model/update_information_model.dart';
import '../../apps/vendor_app/Gyaawa/Pages/Profile/Sub_Screens/Setting/UserAccessControl/model/res_user_access_model.dart';
import '../../apps/vendor_app/Gyaawa/Pages/Wallet/Subscreen_wallet/manage_payment_method/model/all_bank_list_model.dart';
import '../../apps/vendor_app/Gyaawa/Pages/Wallet/Subscreen_wallet/manage_payment_method/model/bank_details_model.dart';
import '../../apps/vendor_app/Gyaawa/Pages/Wallet/Subscreen_wallet/request_payout/model/res_req_payout_model.dart';
import '../../apps/vendor_app/Gyaawa/Pages/Wallet/model/vender_wallet_model.dart';
import '../../apps/vendor_app/Gyaawa/Pages/review/model/reviews_model.dart';
import '../../apps/vendor_app/Gyaawa/Pages/review/subscreens/bulk_responds/model/get_bulk_review_res_model.dart';
import '../../apps/vendor_app/Gyaawa/vendor_common/HelpCenter/SubScreens/FAQ/model/faq_model.dart';
import '../../apps/vendor_app/Gyaawa/vendor_common/HelpCenter/SubScreens/RestaurantSupport/model/create_support_model.dart';
import '../../apps/vendor_app/Gyaawa/vendor_common/HelpCenter/SubScreens/RestaurantSupport/model/restaurant_get_support_model.dart';
import '../../apps/vendor_app/Gyaawa/vendor_common/Models/add_addon_model.dart';
import '../../apps/vendor_app/Gyaawa/vendor_common/Models/choose_common_categories_model.dart';
import '../../apps/vendor_app/Gyaawa/vendor_common/Models/status_check_model.dart';
import '../../apps/vendor_app/Gyaawa/vendor_common/Models/support_chat_model.dart';
import '../../apps/vendor_app/Gyaawa/vendor_common/Notifications/model/notification_model.dart';
import '../../apps/vendor_app/Gyaawa/vendor_common/UserPasswordChange/UpdatePasswordModel/update_password_model.dart';
import '../../apps/vendor_app/Gyaawa/vendor_common/mapbox/model/mapbox_model.dart';
import '../Model/user_model.dart';
import '../network/network_api_services.dart';
import '../user_preference_controller.dart';

class Repository {
  final _apiService = NetworkApiServices();

  String token = "5487|PahRTR7gf4yGxBwqovUXHF5zXm4o9uQotkrOcaAT0b3d6ef0";
  UserModel userModel = UserModel();
  var pref = UserPreference();
  String tokenFcm = "ehO2k6DKQlGPWuTZ8rjS0k:APA91bFcisbaa-IqSyojCtpolQxWrVKFRkmDA-7Qc_vyCY7tB0GtfF6GukQPtB-1ww-SgAwoJhMQO7SMPdPOn-xEfiAUYkTxjtLlm5r2yuV3Hayi_fr4fnk";

  // Future<void> initializeUser() async {
  //   // tokenFcm = await FirebaseMessaging.instance.getToken() ?? "";
  //   userModel = await pref.getUser();
  //   token = userModel.token ?? '';
  //   log("Token $token");
  //   log("Step ${userModel.step}");
  // }

  Future<void> initializeUser() async {
    // 👉 agar already static token set hai to override mat karo
    if (token.isNotEmpty) {
      log("⚠️ Using static token: $token");
      return;
    }

    // 👉 warna normal flow
    userModel = await pref.getUser();

    token = userModel.token ?? '';

    log("Token from pref: $token");
    log("Step from pref: ${userModel.step}");
  }
  Future<dynamic> getProfileApi() async {
     await initializeUser();
    dynamic response = await _apiService.getApi(AppUrls.getProfile, token);
    return ProfileDetailsModel.fromJson(response);
  }
  Future<RegisterVendorModel> profileDetailsApi(var data) async {
     await initializeUser();
    dynamic response =
    await _apiService.postApi2(data, AppUrls.profileDetails, token);
    return RegisterVendorModel.fromJson(response);
  }
  Future<dynamic> resGetProfileApi() async {
    await initializeUser();
    dynamic response = await _apiService.getApi(AppUrls.getProfile, token);
    return ResProfileDetailsModel.fromJson(response);
  }
  Future<CommonExportModel> exportProductApi(var data) async {
    await initializeUser();
    dynamic response = await _apiService.postApi2(data,AppUrls.productExportApi, token);
    return CommonExportModel.fromJson(response);
  }
  Future<dynamic> getDashboardApi({Map<String, dynamic>? queryParameters}) async {
    await initializeUser();
    dynamic response = await _apiService.getApiWithParams(AppUrls.dashboardUrl, token,queryParameters: queryParameters);
    // log("repo dash response ====>>> $response");
    return DashboardModel.fromJson(response);
  }
  Future<CommonResponseModel> markReadyApi(var data) async {
    await initializeUser();
    dynamic response = await _apiService.postApi2(data , AppUrls.markReadyUrl, token);
    return CommonResponseModel.fromJson(response);
  }
  Future<dynamic> rejectOrderApi(var data) async {
    await initializeUser();
    dynamic response = await _apiService.postApi2(data , AppUrls.rejectOrderUrl, token);
    log("single order response ====>>> $response");
    return OrderAcceptAndRejectModel.fromJson(response);
  }

  Future<CommonResponseModel> simulatePickupApi(var data) async {
    await initializeUser();
    dynamic response = await _apiService.postApi2(data , AppUrls.simulatePickupUrl, token);
    return CommonResponseModel.fromJson(response);
  }
  Future<CommonResponseModel> contactCustomer(var data) async {
    await initializeUser();
    dynamic response = await _apiService.postApi2(data,AppUrls.contactCustomer, token);
    return CommonResponseModel.fromJson(response);
  }
  Future<CommonResponseModel> simulateDeliveryApi(var data) async {
    await initializeUser();
    dynamic response = await _apiService.postApi2(data , AppUrls.simulateDelivery, token);
    return CommonResponseModel.fromJson(response);
  }

  Future<dynamic> productDeleteApi(var data) async {
    await initializeUser();
    dynamic response =
    await _apiService.postApi(data, AppUrls.productDeleteUrl, token);
    return ProductDeleteModel.fromJson(response);
  }
  Future<dynamic> getSingleProductsApi(var data) async {
    await initializeUser();
    dynamic response =
    await _apiService.postApi(data, AppUrls.vendorSingleProduct, token);
    return ResSingleProductModel.fromJson(response);
  }
  Future<dynamic> getOrderApi() async {  // remove it
    await initializeUser();
    dynamic response = await _apiService.getApi(AppUrls.orders, token);
    return OrderListModel.fromJson(response);
  }
  Future<OrdersModel> getOrderAPI({Map<String, dynamic>? queryParameters}) async {
    await initializeUser();
    dynamic response = await _apiService.getApiWithParams(AppUrls.orders, token,queryParameters: queryParameters);
    return OrdersModel.fromJson(response);
  }

  Future<CommonExportModel> orderExportApi(var data) async {  // remove it
    await initializeUser();
    dynamic response = await _apiService.postApi2(data,AppUrls.orderExport, token);
    return CommonExportModel.fromJson(response);
  }
  Future<dynamic> acceptOrderApi(var data) async {
    await initializeUser();
    dynamic response = await _apiService.postApi2(data , AppUrls.acceptOrderUrl, token);
    log("single order response ====>>> $response");
    return OrderAcceptAndRejectModel.fromJson(response);
  }

  Future<MenuModel> productListApi(var data) async {await initializeUser();
  Map<String, dynamic> requestData;if (data is String) {
    requestData = jsonDecode(data);
  } else {requestData = data as Map<String, dynamic>;}
  dynamic response = await _apiService.postApi2(jsonEncode(requestData), AppUrls.productListUrl, token
  );
  return MenuModel.fromJson(response);
  }
  Future<dynamic> commonGetCategoryApi() async {
    await initializeUser();
    dynamic response = await _apiService.getApi(AppUrls.getCategoryUrl, token);
    log("repo category response ====>>> $response");
    return CommonGetCategoryModel.fromJson(response);
  }


  Future<dynamic> getSingleOrderApi(var data) async {
    await initializeUser();
    dynamic response = await _apiService.postApi(data , AppUrls.singleOrderUrl, token);
    log("single order response ====>>> $response");
    return SingleOrderDetailsModel.fromJson(response);
  }


  Future<dynamic> restaurantGetAddOnApi() async {
    await initializeUser();
    dynamic response = await _apiService.getApi(AppUrls.getAddOnUrl, token);
    log("repo add on response ====>>> $response");
    return RestaurantGetAddOnModel.fromJson(response);
  }
  Future<dynamic> newAddOnApi(var data) async {
    await initializeUser();
    dynamic response = await _apiService.postApi(data, AppUrls.newAddOnUrl, token);
    return AddAddOnModel.fromJson(response);
  }
  Future<dynamic> editAddOnApi(var data) async {
    await initializeUser();
    dynamic response = await _apiService.postApi(data, AppUrls.editAddOnUrl, token);
    return AddAddOnModel.fromJson(response);
  }

  Future<dynamic> deleteAddOnApi(var data) async {
    await initializeUser();
    dynamic response = await _apiService.postApi(data, AppUrls.deleteAddOnUrl, token);
    return AddAddOnModel.fromJson(response);
  }
  Future<dynamic> getWalletApi() async {
    await initializeUser();
    dynamic response = await _apiService.getApi(AppUrls.getWalletUrl, token);
    return OrderTransactionHistoryModel.fromJson(response);
  }


  Future<dynamic> restaurantGetCuisineTypeApi() async {
    await initializeUser();
    dynamic response = await _apiService.getApi(AppUrls.getCuisineTypeUrl, token);
    log("repo CuisineType response ====>>> $response");
    return RestaurantCuisineTypeModel.fromJson(response);
  }
  Future<dynamic> editProductsApi(var data) async {
    await initializeUser();
    dynamic response =
    await _apiService.postApi2(jsonEncode(data), AppUrls.editRestaurantProduct, token);
    return CommonAddProductModel.fromJson(response);
  }
//review
  Future<dynamic> getReviewsApi() async {
    await initializeUser();
    dynamic response = await _apiService.getApi(AppUrls.reviews, token);
    return OrderReviewsModel.fromJson(response);
  }

  Future<ReviewsModel> getReviewsApiParams({Map<String, dynamic>? queryParameters}) async {
    await initializeUser();
    dynamic response = await _apiService.getApiWithParams(AppUrls.reviews, token,queryParameters: queryParameters);
    return ReviewsModel.fromJson(response);
  }
  // "3540|1A2d40oqTQWkPsfBFsvPAhhnHM6lkgFL9Wn0oxm5ba252e10"

  Future<GetBulkReviewResModel> reviewsPendingResponse() async {
    await initializeUser();
    dynamic response = await _apiService.getApi(AppUrls.reviewsPendingResponse, token);
    return GetBulkReviewResModel.fromJson(response);
  }

  Future<CommonResponseModel> bulkReviewResponse(var data) async {
    await initializeUser();
    dynamic response = await _apiService.postApi2(data,AppUrls.bulkReviewResponse, token);
    return CommonResponseModel.fromJson(response);
  }

  Future<CommonResponseModel> singleReviewResponse(var data) async {
    await initializeUser();
    dynamic response = await _apiService.postApi2(data,AppUrls.reviewResponse, token);
    return CommonResponseModel.fromJson(response);
  }

  Future<CommonExportModel> reviewsExportApi(var data) async {
    await initializeUser();
    dynamic response = await _apiService.postApi2(data,AppUrls.reviewsExport, token);
    return CommonExportModel.fromJson(response);
  }

  Future<dynamic> replyAndEditReviewsApi(data) async {
    await initializeUser();
    dynamic response = await _apiService.postApi(data, AppUrls.replyOnReviewUrl, token);
    return ReviewReplyModel.fromJson(response);
  }
  Future<GetUserDetailsModel> getUserDetails(var data) async {
    await initializeUser();
    dynamic response = await _apiService.postApi(data,AppUrls.getUserDetail,token);
    return GetUserDetailsModel.fromJson(response);
  }
  Future<CategoryAndCuisinesModel> getChooseCategoriesCuisinesApi() async {
    await initializeUser();
    dynamic response = await _apiService.getApi(AppUrls.categoryCuisineGet, token);
    return CategoryAndCuisinesModel.fromJson(response);
  }
  Future<CommonResponseModel> createUpdateUser(var data) async {
    await initializeUser();
    dynamic response = await _apiService.postApi2(data,AppUrls.createUpdateUser,token);
    return CommonResponseModel.fromJson(response);
  }

  Future<dynamic> getChooseCategoriesApi(var data) async {
    // await initializeUser();
    dynamic response =
    await _apiService.postApi(data, AppUrls.getChooseCategories, token);
    return ChooseCategoriesModel.fromJson(response);
  }
  Future<dynamic> categoriesCuisinesAddApi(var data) async {
    // await initializeUser();
    dynamic response =
    await _apiService.postApi2(data, AppUrls.categoryCuisineSave, token);
    return UpdateCategoriesModel.fromJson(response);
  }
  Future<dynamic> newCategoriesApi(var data) async {
    await initializeUser();
    dynamic response =
    await _apiService.postApi(data, AppUrls.newCategoryRequest, token);
    return NewCategoriesModel.fromJson(response);
  }
  Future<dynamic> getCategoryApi() async {
    await initializeUser();
    dynamic response = await _apiService.getApi(AppUrls.getCategories,token);
    return CategoryModel.fromJson(response);
  }


  Future<GetComplianceAndLicensesModel> getCompliance() async {
    await initializeUser();
    dynamic response = await _apiService.getApi(AppUrls.complianceDocuments, token);
    return GetComplianceAndLicensesModel.fromJson(response);
  }
  Future<CommonResponseModel> complianceDocumentsUpload(var data) async {
    await initializeUser();
    dynamic response = await _apiService.postApi2(data,AppUrls.complianceDocumentsUpload,token);
    return CommonResponseModel.fromJson(response);
  }
  Future<DocumentDetailsModel> getDocDetails(var data) async {
    await initializeUser();
    dynamic response = await _apiService.postApi(data,AppUrls.complianceDocumentsDetail, token);
    return DocumentDetailsModel.fromJson(response);
  }

  Future<CommonResponseModel> deleteComplianceDocDetails(var data) async {
    await initializeUser();
    dynamic response = await _apiService.postApi(data,AppUrls.complianceDocumentsDelete,token);
    return CommonResponseModel.fromJson(response);
  }
  Future<dynamic> getAllCategoriesApi(var data) async {
    await initializeUser();
    dynamic response = await _apiService.postApi(data, AppUrls.getProductByCategory, token);
    return AllCategoryModel.fromJson(response);
  }
  Future<CommonAddProductModel> configurationUpdate(var data) async {
    await initializeUser();
    dynamic response = await _apiService.postApi2(data, AppUrls.configurationUpdate, token);
    return CommonAddProductModel.fromJson(response);
  }

  Future<GetSelCategoryModel> getSelectedCategory() async {
    await initializeUser();
    dynamic response = await _apiService.getApi(AppUrls.selectCategory, token);
    return GetSelCategoryModel.fromJson(response);
  }
  Future<InformationUpdateModel> updateInformationApi(var data) async {
    await initializeUser();
    dynamic response = await _apiService.postApi2(data, AppUrls.updateInformation, token);
    return InformationUpdateModel.fromJson(response);
  }
  Future<CommonResponseModel> supportTicketCreate({Map<String, String>? fields,Map<String, File>? files} ) async {
    await initializeUser();
    dynamic response = await _apiService.multipartApi(url: AppUrls.supportTicketSubmit, token: token,fields:fields ,files: files);
    return CommonResponseModel.fromJson(response);
  }

  Future<CommonResponseModel> deleteCategory(var data) async {
    await initializeUser();
    dynamic response = await _apiService.postApi(data,AppUrls.removeCategory, token);
    return CommonResponseModel.fromJson(response);
  }

  Future<CommonResponseModel> emailSupport(var data) async {
    await initializeUser();
    dynamic response = await _apiService.postApi(data,AppUrls.emailSupport, token);
    return CommonResponseModel.fromJson(response);
  }

  Future<UserAccessModel> getUserAccess() async {
    await initializeUser();
    dynamic response = await _apiService.getApi(AppUrls.userAccessControl,token);
    return UserAccessModel.fromJson(response);
  }


  Future<CommonResponseModel> deleteUser(var data) async {
    await initializeUser();
    dynamic response = await _apiService.postApi(data,AppUrls.deleteUser,token);
    return CommonResponseModel.fromJson(response);
  }

  Future<CommonResponseModel> twoFactorAuthentication(var data) async {
    await initializeUser();
    dynamic response = await _apiService.postApi2(data,AppUrls.twoFactorAuthentication,token);
    return CommonResponseModel.fromJson(response);
  }
  Future<MapBoxModel> mapboxApi({Map<String, dynamic>? queryParameters}) async {
    dynamic response = await _apiService.getApiWithParams(AppUrls.mapboxApi,"", queryParameters: queryParameters);
    return MapBoxModel.fromJson(response);
  }
  Future<UpdatePasswordModel> updatePassword(var data) async {
    await initializeUser();
    dynamic response = await _apiService.postApi(data, AppUrls.updatePassword, token);
    return UpdatePasswordModel.fromJson(response);
  }
  /*----------------Add Product---------------------------*/
  Future<dynamic> restaurantAddProductApi(var data) async {
    await initializeUser();
    dynamic response = await _apiService.postApi2(data, AppUrls.restaurantAddProductUrl, token);
    return CommonAddProductModel.fromJson(response);
  }
  Future<CommonExportModel> downloadStatement(var data) async {
    await initializeUser();
    dynamic response = await _apiService.postApi2(data,AppUrls.statementDownload, token );
    return CommonExportModel.fromJson(response);
  }

  Future<VendorWalletModel> walletApi({Map<String, dynamic>? queryParameters}) async {
    await initializeUser();
    dynamic response = await _apiService.getApiWithParams(AppUrls.walletUrl, token,queryParameters: queryParameters);
    return VendorWalletModel.fromJson(response);
  }
  Future<CommonResponseModel> deletePaymentMethodApi(var data) async {
    await initializeUser();
    dynamic response = await _apiService.postApi(data,AppUrls.removePaymentMethod, token);
    return CommonResponseModel.fromJson(response);
  }

  Future<BankListModel> getAllBankListApi() async {
    await initializeUser();
    dynamic response = await _apiService.getApi(AppUrls.bankListUrl, token);
    return BankListModel.fromJson(response);
  }
  Future<CommonResponseModel> addPaymentMethodApi(var data) async {
    await initializeUser();
    dynamic response = await _apiService.postApi(data,AppUrls.addPaymentMethod, token);
    return CommonResponseModel.fromJson(response);
  }


  Future<BankDetailsModel> getBankDetailsApi({required String paymentM}) async {
    await initializeUser();
    dynamic response = await _apiService.getApi(AppUrls.paymentMethod+paymentM,token);
    return BankDetailsModel.fromJson(response);
  }

  Future<CommonResponseModel> updatePaymentMethodApi(var data) async {
    await initializeUser();
    dynamic response = await _apiService.postApi(data,AppUrls.updatePaymentMethod, token);
    return CommonResponseModel.fromJson(response);
  }
  Future<CommonResponseModel> withdrawalApi(var data) async {
    await initializeUser();
    dynamic response = await _apiService.postApi2(data,AppUrls.withdraw, token );
    return CommonResponseModel.fromJson(response);
  }

  Future<GetPayOutModel> withdrawalData() async {
    await initializeUser();
    dynamic response = await _apiService.getApi(AppUrls.getWalletUrl,token);
    return GetPayOutModel.fromJson(response);
  }

  /*------------------- notifications -----------------------*/


  Future<dynamic> getNotificationsApi({Map<String, dynamic>? queryParameters}) async {
    await initializeUser();
    dynamic response = await _apiService.getApiWithParams(AppUrls.notificationsUrl, token,queryParameters:queryParameters );
    return NotificationModel.fromJson(response);
  }

  Future<StatusCheckModel> markAllReadApi() async {
    await initializeUser();
    dynamic response = await _apiService.getApi(AppUrls.markAllRead, token);
    return StatusCheckModel.fromJson(response);
  }

  Future<StatusCheckModel> markAsReadApi(var data) async {
    await initializeUser();
    dynamic response = await _apiService.postApi(data,AppUrls.markAsRead, token);
    return StatusCheckModel.fromJson(response);
  }

  Future<StatusCheckModel> notificationRemove(var data) async {
    await initializeUser();
    dynamic response = await _apiService.postApi(data,AppUrls.notificationRemove, token);
    return StatusCheckModel.fromJson(response);
  }

  Future<dynamic> seenNotificationsApi() async {
    await initializeUser();
    dynamic response = await _apiService.getApi(AppUrls.notificationsSeenUrl, token);
    return StatusCheckModel.fromJson(response);
  }

  Future<CommonResponseModel> createNotificationsApi(var data) async {
    await initializeUser();
    dynamic response = await _apiService.postApi2(data,AppUrls.notificationSend, token);
    return CommonResponseModel.fromJson(response);
  }

  Future<CommonResponseModel> notificationSettings(var data) async {
    await initializeUser();
    dynamic response = await _apiService.postApi2(data,AppUrls.notificationPreferences, token);
    return CommonResponseModel.fromJson(response);
  }
  Future<CommonResponseModel> notificationTemplete() async {
    await initializeUser();
    final response = await _apiService.getApi(AppUrls.notificationsTemplate, token,);
    return CommonResponseModel.fromJson(response);
  }

 //<<<<<<<<<<<<<<<<<<<<<<<<<help support>>>>>>>>>>>>>>>>>>>>>>
  Future<dynamic> getFaqPrivacyTcApi() async {
    await initializeUser();
    dynamic response = await _apiService.getApi(AppUrls.faqPrivacyTcUrl, token);
    return FaqPrivacyTcModel.fromJson(response);
  }

  Future<GetPagesModel> getFaqPrivacyTc() async {
    await initializeUser();
    dynamic response = await _apiService.getApi(AppUrls.getPages, token);
    return GetPagesModel.fromJson(response);
  }

  /* ------------------------------ Support  ---------------------------------*/
  Future<dynamic> gatSupportApi() async {
    await initializeUser();
    dynamic response = await _apiService.getApi(AppUrls.getSupportUrl, token);
    log("repo support response ====>>> $response");
    return RestaurantGetSupportModel.fromJson(response);
  }

  Future<dynamic> createSupportApi(var data) async {
    await initializeUser();
    dynamic response = await _apiService.postApi(data, AppUrls.createSupportUrl, token);
    return CreateSupportModel.fromJson(response);
  }

  /*------------------- support chat api -----------------------*/

  Future<dynamic> supportChatApi(var data) async {
    await initializeUser();
    dynamic response = await _apiService.postApi(data, AppUrls.supportChatUrl, token);
    return SupportChatModel.fromJson(response);
  }

  Future<dynamic> markAsClosedChatApi(var data) async {
    await initializeUser();
    dynamic response = await _apiService.postApi(data, AppUrls.markAsClosedChatReplyUrl, token);
    return SupportChatReplyModel.fromJson(response);
  }


}
