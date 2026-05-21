import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/Products/view/product_bulk_upload_screen.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/ChooseVendorCategories/bindings/vendor_category_cuisines_binding.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/ChooseVendorCategories/view/choose_vendor_categories_screen.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/Dashboard/controller/vendor_dashboard_binding.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/Dashboard/view/vendor_dashboard_screen.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/FillVendorDetails/binding/profile_details_binding.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/FillVendorDetails/view/profile_details_screen.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/OrdersDetails/binding/vendor_orders_bindings.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/menu/binding/vendor_export_menu_binding.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/menu/binding/vendor_menu_binding.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/menu/binding/vendor_menu_item_details_binding.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/menu/filters/vendor_menu_filter_screen.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/menu/view/vendor_bulk_upload_menu_items.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/menu/view/vendor_export_menu_item_screen.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/menu/view/vendor_menu_item_details_screen.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/vendor_add_product/sub_screen/view/vendor_product_review_screen.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/vendor_add_product/view/restaurant_add_product_screen.dart';
import '../../apps/vendor_app/view/Pages/OrdersDetails/SubScreens/OrderDetails/view/vendor_more_order_details_screen.dart';
import '../../apps/vendor_app/view/Pages/OrdersDetails/SubScreens/OrderDetails/view/vendor_order_details_screen.dart';
import '../../apps/vendor_app/view/Pages/OrdersDetails/SubScreens/export_orders/view/res_export_orders_screen.dart';
import '../../apps/vendor_app/view/Pages/OrdersDetails/view/restaurant_order_list_screen.dart';
import '../../apps/vendor_app/view/Pages/Products/Sub_screen/EditProduct/view/restaurant_edit_menu_screen.dart';
import '../../apps/vendor_app/view/Pages/Products/Sub_screen/Product_Details/view/restro_product_details_screen.dart';
import '../../apps/vendor_app/view/Pages/Profile/Sub_Screens/AddOn_Screens/view/add_addon_screen.dart';
import '../../apps/vendor_app/view/Pages/Profile/Sub_Screens/MyAccount/view/restaurant_my_account_screen.dart';
import '../../apps/vendor_app/view/Pages/Profile/Sub_Screens/OrderTransactionHistory/res_order_transaction_history_screen.dart';
import '../../apps/vendor_app/view/Pages/Profile/Sub_Screens/Product_Review/view/restaurant_product_review_screen.dart';
import '../../apps/vendor_app/view/Pages/Profile/Sub_Screens/RestaurantCategory/SubScreens/view/restaurant_all_category_items.dart';
import '../../apps/vendor_app/view/Pages/Profile/Sub_Screens/RestaurantCategory/view/restaurant_category_screen.dart';
import '../../apps/vendor_app/view/Pages/Profile/Sub_Screens/Restaurant_Details/view/restaurant_details_screen.dart';
import '../../apps/vendor_app/view/Pages/Profile/Sub_Screens/Setting/AddMenuCategories/view/restaurant_add_menu_category_screen.dart';
import '../../apps/vendor_app/view/Pages/Profile/Sub_Screens/Setting/AddNewUser/binding/res_add_new_user_binding.dart';
import '../../apps/vendor_app/view/Pages/Profile/Sub_Screens/Setting/AddNewUser/view/res_add_new_user_screen.dart';
import '../../apps/vendor_app/view/Pages/Profile/Sub_Screens/Setting/ComplianceAndLicenses/SubScreens/DocumentsDetail/binding/res_document_details_binding.dart';
import '../../apps/vendor_app/view/Pages/Profile/Sub_Screens/Setting/ComplianceAndLicenses/SubScreens/DocumentsDetail/view/restaurant_document_details_screen.dart';
import '../../apps/vendor_app/view/Pages/Profile/Sub_Screens/Setting/ComplianceAndLicenses/SubScreens/UploadComplianceDocuments/binding/res_upload_compliance_document_binding.dart';
import '../../apps/vendor_app/view/Pages/Profile/Sub_Screens/Setting/ComplianceAndLicenses/SubScreens/UploadComplianceDocuments/view/res_upload_compliance_documents_screen.dart';
import '../../apps/vendor_app/view/Pages/Profile/Sub_Screens/Setting/ComplianceAndLicenses/controller/restaurant_compliance_and_licenses_binding.dart';
import '../../apps/vendor_app/view/Pages/Profile/Sub_Screens/Setting/ComplianceAndLicenses/view/restaurant_compliance_and_licenses_view.dart';
import '../../apps/vendor_app/view/Pages/Profile/Sub_Screens/Setting/RestaurantConfiguration/view/restaurant_configuration.dart';
import '../../apps/vendor_app/view/Pages/Profile/Sub_Screens/Setting/RestaurantInformation/binding/res_information_bindings.dart';
import '../../apps/vendor_app/view/Pages/Profile/Sub_Screens/Setting/RestaurantInformation/view/restaurant_information_screen.dart';
import '../../apps/vendor_app/view/Pages/Profile/Sub_Screens/Setting/Security/binding/res_security_settings_bindings.dart';
import '../../apps/vendor_app/view/Pages/Profile/Sub_Screens/Setting/Security/view/res_security_settings_screen.dart';
import '../../apps/vendor_app/view/Pages/Profile/Sub_Screens/Setting/UserAccessControl/binding/res_user_access_binding.dart';
import '../../apps/vendor_app/view/Pages/Profile/Sub_Screens/Setting/UserAccessControl/view/res_user_access_screen.dart';
import '../../apps/vendor_app/view/Pages/Profile/Sub_Screens/Setting/controller/restaurant_setting_binding.dart';
import '../../apps/vendor_app/view/Pages/Profile/Sub_Screens/Setting/view/restaurant_setting_screen.dart';
import '../../apps/vendor_app/view/Pages/Profile/view/restaurant_user_profile_screen.dart';
import '../../apps/vendor_app/view/Pages/Wallet/Subscreen_wallet/Restaurant_Bank_Account/Add_restaurant_bank_account/view/add_restaurant_bank_details_screen.dart';
import '../../apps/vendor_app/view/Pages/Wallet/Subscreen_wallet/download_statement/view/res_download_satement_screen.dart';
import '../../apps/vendor_app/view/Pages/Wallet/Subscreen_wallet/manage_payment_method/binding/res_payment_method_binding.dart';
import '../../apps/vendor_app/view/Pages/Wallet/Subscreen_wallet/manage_payment_method/view/res_manage_payment_method_screen.dart';
import '../../apps/vendor_app/view/Pages/Wallet/Subscreen_wallet/request_payout/binding/res_request_payout_binding.dart';
import '../../apps/vendor_app/view/Pages/Wallet/Subscreen_wallet/request_payout/view/res_request_payout_screen.dart';
import '../../apps/vendor_app/view/Pages/Wallet/Subscreen_wallet/view/restaurant_withdraw_screen.dart';
import '../../apps/vendor_app/view/Pages/review/subscreens/bulk_responds/view/res_bulk_responds_screen.dart';
import '../../apps/vendor_app/view/Pages/review/subscreens/export_reviews/view/export_reviews_screen.dart';
import '../../apps/vendor_app/view/Pages/review/subscreens/single_response/view/res_single_review_respose_screen.dart';
import '../../apps/vendor_app/view/Pages/vendor_add_product/sub_screen/binding/retail_product_review_binding.dart';
import '../../apps/vendor_app/view/vendor_common/HelpCenter/SubScreens/FAQ/binding/res_faqs_binding.dart';
import '../../apps/vendor_app/view/vendor_common/HelpCenter/SubScreens/FAQ/view/restaurant_faq_screen.dart';
import '../../apps/vendor_app/view/vendor_common/HelpCenter/SubScreens/Res_Vendor_Agreement/res_vedor_areement.dart';
import '../../apps/vendor_app/view/vendor_common/HelpCenter/SubScreens/RestaurantPrivacyPolicy/view/restaurant_privacy_policy_screen.dart';
import '../../apps/vendor_app/view/vendor_common/HelpCenter/SubScreens/RestaurantT&C/view/restaurant_tnc_screen.dart';
import '../../apps/vendor_app/view/vendor_common/HelpCenter/binding/res_help_center_binding.dart';
import '../../apps/vendor_app/view/vendor_common/HelpCenter/view/restaurant_help_center_screen.dart';
import '../../apps/vendor_app/view/vendor_common/Notifications/controller/notifications_binding.dart';
import '../../apps/vendor_app/view/vendor_common/Notifications/sub_screens/create_notification/view/res_create_notification_screen.dart';
import '../../apps/vendor_app/view/vendor_common/Notifications/sub_screens/notification_settings/binding/res_notification_settings_bindings.dart';
import '../../apps/vendor_app/view/vendor_common/Notifications/sub_screens/notification_settings/view/res_notification_settings_screen.dart';
import '../../apps/vendor_app/view/vendor_common/Notifications/view/notification_screen.dart';
import '../../apps/vendor_app/view/vendor_common/order_transaction_details/binding/order_transaction_details_binding.dart';
import '../../apps/vendor_app/view/vendor_common/order_transaction_details/view/order_transaction_details_screen.dart';
import '../../apps/vendor_app/view/vendor_navbar/view/vendor_navbar.dart';

class VendorAppRoutes {
  static const String splashScreen = '/splashScreen';
  static const String loginScreen = '/loginScreen';
  static const String signUpScreen = '/signUpScreen';
  static const String twoFaScreen = '/twoFaScreen';
  static const String orderTransactionDetailsScreen = '/orderTransactionDetailsScreen';
  static const String createProfileScreen = '/createProfileScreen';
  static const String selectRoleScreen = '/selectRoleScreen';
  static const String chooseRestaurantCategoriesScreen = '/chooseRestaurantCategoriesScreen';
  static const String otpScreen = '/otpScreen';
  static const String changePasswordScreen = '/changePasswordScreen';
  static const String restaurantDetailsScreen = '/restaurantDetailsScreen';
  static const String restaurantDashboardScreen = '/restaurantDashboardScreen';
  static const String restaurantNavbarScreen = '/restaurantNavbarScreen';
  static const String restaurantWalletScreen = '/restaurantWalletScreen';
  static const String restaurantProductDetailsScreen = '/restaurantProductDetailsScreen';
  static const String restaurantWithdrawScreen = '/restaurantWithdrawScreen';
  static const String bankAccountDetailsScreen = '/bankAccountDetailsScreen';
  static const String addRestaurantBankDetails = '/addRestaurantBankDetails';
  static const String restaurantOrderListScreen = '/restaurantOrderListScreen';
  static const String restaurantOrderDetailsScreen ='/restaurantOrderDetailsScreen';
  static const String restaurantMoreOrderDetailsScreen = '/restaurantMoreOrderDetailsScreen';
  static const String restaurantAddProductScreen = '/RestaurantAddProductScreen';
  static const String restaurantInformationScreens = '/restaurantInformationScreens';
  static const String restaurantProductReviewScreen = '/restaurantProductReviewScreen';
  static const String editRestaurantDetailsScreen = '/editRestaurantDetailsScreen';
  static const String restaurantCategoryScreen = '/restaurantCategoryScreen';
  static const String resOrderTranHisScreen = '/resOrderTranHisScreen';
  static const String restaurantAllCategoryItems = '/restaurantAllCategoryItems';
  static const String restaurantMyAccountScreen = '/restaurantMyAccountScreen';
  static const String userPasswordChangeScreen = '/userPasswordChangeScreen';
  static const String restaurantSettingScreen = '/restaurantSettingScreen';
  static const String restaurantAddOnScreen = '/restaurantAddOnScreen';
  static const String restaurantNotificationScreen = '/restaurantNotificationScreen';
  static const String restaurantHelpCenterScreen = '/restaurantHelpCenterScreen';
  static const String restaurantFaqScreen = '/restaurantFaqScreen';
  static const String restaurantPrivacyPolicyScreen = '/restaurantPrivacyPolicyScreen';
  static const String restaurantSupportScreen = '/restaurantSupportScreen';
  static const String restaurantTnCScreen = '/restaurantTnCScreen';
  static const String restaurantVendorAgreementCScreen = '/restaurantVendorAgreementCScreen';
  static const String resManagePaymentMethod = '/resManagePaymentMethod';
  static const String resExportOrdersScreen = '/resExportOrdersScreen';

  static const String restaurantSupportQueryReplayScreen = '/restaurantSupportQueryReplayScreen';
  static const String restaurantProfileScreen = '/restaurantProfileScreen';
  static const String restaurantEditProductScreen = '/restaurantEditProductScreen';
  static const String maintenance = "/maintenance";
  static const String restaurantMenuFilterScreen = "/restaurantMenuFilterScreen";
  static const String restaurantMenuItemDetailsScreen = "/restaurantMenuItemDetailsScreen";
  static const String restaurantBulkUploadMenuItems = "/restaurantBulkUploadMenuItems";
  static const String restaurantExportMenuItemScreen = "/restaurantExportMenuItemScreen";
  static const String restaurantConfigurationScreen = "/restaurantConfigurationScreen";
  static const String restaurantAddMenuCategoryScreen = "/restaurantAddMenuCategoryScreen";
  static const String restaurantComplianceAndLicensesScreen = "/restaurantComplianceAndLicensesScreen";
  static const String restaurantDocumentDetailsScreen = "/restaurantDocumentDetailsScreen";
  static const String resUploadComplianceDocumentsScreen = "/resUploadComplianceDocumentsScreen";
  static const String resUserAccessScreen = "/resUserAccessScreen";
  static const String resAddNewUserScreen = "/resAddNewUserScreen";
  static const String resSecuritySettingsScreen = "/resSecuritySettingsScreen";
  static const String resLiveChatSupportScreen = "/resLiveChatSupportScreen";
  static const String resEmailSupportScreen = "/resEmailSupportScreen";
  static const String resPhoneSupportScreen = "/resPhoneSupportScreen";
  static const String resBulkRespondsScreen = "/resBulkRespondsScreen";
  static const String exportReviewsScreen = "/exportReviewsScreen";
  static const String resRequestPayoutScreen = "/resRequestPayoutScreen";
  static const String resDownloadStatementScreen = "/resDownloadStatementScreen";
  static const String resSingleReviewResponseScreen = "/resSingleReviewResponseScreen";
  static const String resProfileDetailsScreen = "/resProfileDetailsScreen";
  static const String resCreateNotificationScreen = "/resCreateNotificationScreen";
  static const String resNotificationSettingsScreen = "/resNotificationSettingsScreen";
  static const String vendorProductReviewScreen = "/retailProductReviewScreen";

  // Bulk Upload Products
  static const String productBulkUploadScreen = "/productBulkUploadScreen";


  //---------------------------------Notification----------------------------------------
  static const String notificationScreen = '/notificationScreen';

  //Retail
  static List<GetPage> pages = <GetPage>[
  //
  //   GetPage(name: twoFaScreen, page: () => const TwoFaScreen()),
    GetPage(name: orderTransactionDetailsScreen, page: () => const OrderTransactionDetailsScreen(),binding: OrderTransactionDetailsBinding()),
  //   GetPage(name: signUpScreen, page: () => SignUpScreen(index: Get.parameters["index"] ?? ""),binding: SignUpBinding()),
  //  GetPage(name: createProfileScreen, page: () => CreateProfileScreen()),
  //    GetPage(name: selectRoleScreen, page: () => SelectRoleScreen()),
     GetPage(name: chooseRestaurantCategoriesScreen, page: () => ChooseVendorCategoriesScreen(),binding: VendorCategoriesCuisinesBinding()),
  //   GetPage(name: forgotPaswordScreen, page: () => ForgotPaswordScreen()),
  //   GetPage(name: otpScreen, page: () => OtpScreen()),
  //   GetPage(name: changePasswordScreen, page: () => ChangePasswordScreen()),
     GetPage(name: restaurantDetailsScreen, page: () => RestaurantDetailsScreen()),
    GetPage(name: restaurantDashboardScreen, page: () => const VendorDashboardScreen(),binding: VendorDashboardBinding()),
    GetPage(name: restaurantNavbarScreen, page: () => const VendorNavbar(navbarInitialIndex: 0),bindings:
  [VendorDashboardBinding(),VendorMenuBinding(),]),
      // SignOutBinding(),ResReviewBindings(),ResOrdersBinding(),ResWalletBinding(),ResInformationBindings(),]),
    // GetPage(name: restaurantWalletScreen, page: () => const WalletScreen(),bindings: [SignOutBinding(),ResWalletBinding(),ResInformationBindings()]),
    GetPage(name: restaurantProductDetailsScreen, page: () => RestaurantProductDetailsScreen()),
    GetPage(name: restaurantWithdrawScreen, page: () => RestaurantWithdrawScreen()),
    // GetPage(name: bankAccountDetailsScreen, page: () => RestaurantBankAccountDetailsScreen()),
    GetPage(name: addRestaurantBankDetails, page: () => AddRestaurantBankDetails()),
    GetPage(name: restaurantOrderDetailsScreen, page: () => VendorOrderDetailsScreen()),
    GetPage(name: restaurantOrderListScreen, page: () => const RestaurantOrderListScreen(),binding: VendorOrdersBindings()),
    GetPage(name: restaurantMoreOrderDetailsScreen, page: () => VendorMoreOrderDetailsScreen()),
    GetPage(name: restaurantProductReviewScreen, page: () => RestaurantProductReviewScreen()),
      // GetPage(name: editRestaurantDetailsScreen,page: () => EditRestaurantDetailsScreen()),
    GetPage(name: restaurantCategoryScreen, page: () => RestaurantCategoryScreen()),
    GetPage(name: restaurantAllCategoryItems, page: () => RestaurantAllCategoryItems()),
    GetPage(name: restaurantSettingScreen, page: () => const RestaurantSettingScreen(),binding: RestaurantSettingBinding()),
    GetPage(name: restaurantAddOnScreen, page: () => RestaurantAddAddonScreen()),
     // GetPage(name: restaurantNotificationScreen, page: () => RestaurantNotificationScreen()),
     GetPage(name: restaurantHelpCenterScreen, page: () => const RestaurantHelpCenterScreen(),binding: ResHelpCenterBinding()),
     GetPage(name: restaurantFaqScreen, page: () => const RestaurantFaqScreen(),binding: ResFaqsBinding()),
     GetPage(name: restaurantPrivacyPolicyScreen, page: () => const RestaurantPrivacyPolicyScreen(),binding: ResFaqsBinding()),
      // GetPage(name: restaurantSupportScreen, page: () => const RestaurantSupportScreen(),binding: ResSupportBinding()),
     GetPage(name: restaurantTnCScreen, page: () => const RestaurantTncScreen(),binding: ResFaqsBinding()),
    GetPage(name: restaurantInformationScreens, page: () =>  RestaurantInformationScreens(),binding: ResInformationBindings()),
    GetPage(name: restaurantAddProductScreen, page: () => RestaurantAddProductScreen()),
    GetPage(name: vendorProductReviewScreen, page: () => RetailProductReviewScreen(),binding: RetailProductReviewBinding()),
    GetPage(name: restaurantMyAccountScreen, page: () => RestaurantMyAccountScreen()),
    // GetPage(name: userPasswordChangeScreen, page: () => UserPasswordChangeScreen()),
    // GetPage(name: restaurantSupportQueryReplayScreen, page: () => RestaurantSupportQuarryReplyScreen()),
    GetPage(name: restaurantProfileScreen, page: () => const ProfileScreen()),
    GetPage(name: restaurantEditProductScreen, page: () => RestaurantEditProductScreen()),
    GetPage(name: resOrderTranHisScreen, page: () => const ResOrderTransHistoryScreen()),
    GetPage(name: restaurantMenuFilterScreen, page: () =>  VendorMenuFilterScreen()),
    GetPage(name: restaurantBulkUploadMenuItems, page: () => const ProductBulkUploadScreen()),
    GetPage(name: restaurantExportMenuItemScreen, page: () => const VendorExportMenuItemScreen(),binding: VendorExportMenuBinding()),
    GetPage(name: restaurantMenuItemDetailsScreen, page: () => const VendorMenuItemDetailsScreen(),binding: VendorMenuItemDetailsBinding()),
    GetPage(name: restaurantConfigurationScreen, page: () =>  const RestaurantConfigurationScreen(),binding: RestaurantSettingBinding()),
    GetPage(name: restaurantAddMenuCategoryScreen, page: () =>  RestaurantAddMenuCategoryScreen(),binding: RestaurantSettingBinding()),
    GetPage(name: restaurantComplianceAndLicensesScreen, page: () =>  const RestaurantComplianceAndLicensesScreen(),binding: ComplianceAndLicensesBinding()),
    GetPage(name: restaurantDocumentDetailsScreen, page: () =>  const RestaurantDocumentDetailsScreen(),binding: ResDocumentDetailsBinding()),
    GetPage(name: resUploadComplianceDocumentsScreen, page: () =>  const ResUploadComplianceDocumentsScreen(),binding: ResUploadComplianceDocumentBinding()),
    GetPage(name: resUserAccessScreen, page: () =>  const ResUserAccessScreen(),binding: ResUserAccessBinding()),
    GetPage(name: resAddNewUserScreen, page: () =>  const ResAddNewUserScreen(),binding: ResAddNewUserBinding()),
    GetPage(name: resSecuritySettingsScreen, page: () =>  const ResSecuritySettingsScreen(),bindings:[ ResSecuritySettingBinding()]),
    // GetPage(name: resLiveChatSupportScreen, page: () =>  ResLiveChatSupportScreen(),),
    // GetPage(name: resEmailSupportScreen, page: () =>  const ResEmailSupportScreen(),binding: ResEmailSupportBinding()),
    // GetPage(name: resPhoneSupportScreen, page: () =>  const ResPhoneSupportScreen(),binding: ResPhoneSupportBinding()),
    GetPage(name: resBulkRespondsScreen, page: () =>  const ResBulkRespondsScreen()),
    GetPage(name: exportReviewsScreen, page: () =>  const ExportReviewsScreen()),
    GetPage(name: resSingleReviewResponseScreen, page: () =>  const ResSingleReviewResponseScreen()),
     GetPage(name: resExportOrdersScreen, page: () =>  const ResExportOrdersScreen()),
    GetPage(name: resManagePaymentMethod, page: () =>  const ResManagePaymentMethod(),binding: ResPaymentMethodBinding()),
    GetPage(name: resRequestPayoutScreen, page: () =>  const ResRequestPayoutScreen(),binding: ResRequestPayloadBinding()),
    GetPage(name: resDownloadStatementScreen, page: () =>  const ResDownloadStatementScreen()),
     GetPage(name: resProfileDetailsScreen, page: () =>  const ProfileDetailsScreen(),binding: ProfileDetailsBinding()),
     GetPage(name: resCreateNotificationScreen, page: () =>  const ResCreateNotificationScreen()),
     GetPage(name: resNotificationSettingsScreen, page: () =>  const ResNotificationSettingsScreen(),binding: ResNotificationSettingsBindings()),
     GetPage(name: restaurantVendorAgreementCScreen, page: () =>  const RestaurantVendorAgreementCScreen(),binding: ResFaqsBinding()),
     GetPage(name: productBulkUploadScreen, page: () => const ProductBulkUploadScreen()),
  //
    // //---------------------------------Notification----------------------------------------
    GetPage(name: notificationScreen, page: () => const NotificationScreen() , binding: NotificationsBinding()),
    //
    //  GetPage(name: maintenance, page: () => const MaintenanceModeScreen(),binding: MaintenanceBinding()),

  ];
}
