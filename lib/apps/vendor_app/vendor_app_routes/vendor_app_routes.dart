
import 'package:get/get_navigation/src/routes/get_route.dart';

import '../../user_app/presentation/acccount/view/profile_screen.dart';
import '../Gyaawa/Pages/Dashboard/controller/restaurant_dashboard_binding.dart';
import '../Gyaawa/Pages/Dashboard/view/restaurant_dashboard_screen.dart';
import '../Gyaawa/Pages/OrdersDetails/SubScreens/OrderDetails/view/resaurant_order_details_screen.dart';
import '../Gyaawa/Pages/OrdersDetails/SubScreens/OrderDetails/view/restaurant_more_order_details_screen.dart';
import '../Gyaawa/Pages/OrdersDetails/SubScreens/export_orders/view/res_export_orders_screen.dart';
import '../Gyaawa/Pages/OrdersDetails/binding/res_orders_bindings.dart';
import '../Gyaawa/Pages/OrdersDetails/view/restaurant_order_list_screen.dart';
import '../Gyaawa/Pages/Products/Sub_screen/EditProduct/view/restaurant_edit_menu_screen.dart';
import '../Gyaawa/Pages/Products/Sub_screen/Product_Details/view/restro_product_details_screen.dart';
import '../Gyaawa/Pages/Profile/Sub_Screens/AddOn_Screens/view/add_addon_screen.dart';
import '../Gyaawa/Pages/Profile/Sub_Screens/MyAccount/view/restaurant_my_account_screen.dart';
import '../Gyaawa/Pages/Profile/Sub_Screens/OrderTransactionHistory/res_order_transaction_history_screen.dart';
import '../Gyaawa/Pages/Profile/Sub_Screens/Product_Review/view/restaurant_product_review_screen.dart';
import '../Gyaawa/Pages/Profile/Sub_Screens/RestaurantCategory/SubScreens/view/restaurant_all_category_items.dart';
import '../Gyaawa/Pages/Profile/Sub_Screens/RestaurantCategory/view/restaurant_category_screen.dart';
import '../Gyaawa/Pages/Profile/Sub_Screens/Setting/AddMenuCategories/view/restaurant_add_menu_category_screen.dart';
import '../Gyaawa/Pages/Profile/Sub_Screens/Setting/AddNewUser/binding/res_add_new_user_binding.dart';
import '../Gyaawa/Pages/Profile/Sub_Screens/Setting/AddNewUser/view/res_add_new_user_screen.dart';
import '../Gyaawa/Pages/Profile/Sub_Screens/Setting/ComplianceAndLicenses/SubScreens/DocumentsDetail/binding/res_document_details_binding.dart';
import '../Gyaawa/Pages/Profile/Sub_Screens/Setting/ComplianceAndLicenses/SubScreens/DocumentsDetail/view/restaurant_document_details_screen.dart';
import '../Gyaawa/Pages/Profile/Sub_Screens/Setting/ComplianceAndLicenses/SubScreens/UploadComplianceDocuments/binding/res_upload_compliance_document_binding.dart';
import '../Gyaawa/Pages/Profile/Sub_Screens/Setting/ComplianceAndLicenses/SubScreens/UploadComplianceDocuments/view/res_upload_compliance_documents_screen.dart';
import '../Gyaawa/Pages/Profile/Sub_Screens/Setting/ComplianceAndLicenses/controller/restaurant_compliance_and_licenses_binding.dart';
import '../Gyaawa/Pages/Profile/Sub_Screens/Setting/ComplianceAndLicenses/view/restaurant_compliance_and_licenses_view.dart';
import '../Gyaawa/Pages/Profile/Sub_Screens/Setting/RestaurantConfiguration/view/restaurant_configuration.dart';
import '../Gyaawa/Pages/Profile/Sub_Screens/Setting/RestaurantInFormation/view/restaurant_information_screen.dart';
import '../Gyaawa/Pages/Profile/Sub_Screens/Setting/Security/binding/res_security_settings_bindings.dart';
import '../Gyaawa/Pages/Profile/Sub_Screens/Setting/Security/view/res_security_settings_screen.dart';
import '../Gyaawa/Pages/Profile/Sub_Screens/Setting/UserAccessControl/binding/res_user_access_binding.dart';
import '../Gyaawa/Pages/Profile/Sub_Screens/Setting/UserAccessControl/view/res_user_access_screen.dart';
import '../Gyaawa/Pages/Profile/Sub_Screens/Setting/controller/restaurant_setting_binding.dart';
import '../Gyaawa/Pages/Profile/Sub_Screens/Setting/view/restaurant_setting_screen.dart';
import '../Gyaawa/Pages/RestaurantAddProduct/view/restaurant_add_product_screen.dart';
import '../Gyaawa/Pages/Wallet/Subscreen_wallet/Restaurant_Bank_Account/Add_restaurant_bank_account/view/add_restaurant_bank_details_screen.dart';
import '../Gyaawa/Pages/Wallet/Subscreen_wallet/download_statement/view/res_download_satement_screen.dart';
import '../Gyaawa/Pages/Wallet/Subscreen_wallet/manage_payment_method/binding/res_payment_method_binding.dart';
import '../Gyaawa/Pages/Wallet/Subscreen_wallet/manage_payment_method/view/res_manage_payment_method_screen.dart';
import '../Gyaawa/Pages/Wallet/Subscreen_wallet/request_payout/binding/res_request_payout_binding.dart';
import '../Gyaawa/Pages/Wallet/Subscreen_wallet/request_payout/view/res_request_payout_screen.dart';
import '../Gyaawa/Pages/Wallet/Subscreen_wallet/view/restaurant_withdraw_screen.dart';
import '../Gyaawa/Pages/Wallet/view/restaurant_wallet_screen.dart';
import '../Gyaawa/Pages/menu/binding/restaurant_export_menu_binding.dart';
import '../Gyaawa/Pages/menu/binding/restaurant_menu_binding.dart';
import '../Gyaawa/Pages/menu/binding/restaurant_menu_item_details_binding.dart';
import '../Gyaawa/Pages/menu/filters/restaurant_menu_filter_screen.dart';
import '../Gyaawa/Pages/menu/view/restaurant_bulk_upload_menu_items.dart';
import '../Gyaawa/Pages/menu/view/restaurant_export_menu_item_screen.dart';
import '../Gyaawa/Pages/menu/view/restaurant_menu_item_details_screen.dart';
import '../Gyaawa/Pages/review/subscreens/bulk_responds/view/res_bulk_responds_screen.dart';
import '../Gyaawa/Pages/review/subscreens/export_reviews/view/export_reviews_screen.dart';
import '../Gyaawa/Pages/review/subscreens/single_response/view/res_single_review_respose_screen.dart';
import '../Gyaawa/Restaurant_navbar/view/restaurant_navbar.dart';

class VendorAppRoutes {
  static const String splashScreen = '/splashScreen';
  static const String loginScreen = '/loginScreen';
  static const String signUpScreen = '/signUpScreen';
  static const String twoFaScreen = '/twoFaScreen';
  static const String orderTransactionDetailsScreen = '/orderTransactionDetailsScreen';
  static const String createProfileScreen = '/createProfileScreen';
  static const String selectRoleScreen = '/selectRoleScreen';
  static const String chooseRestaurantCategoriesScreen = '/chooseRestaurantCategoriesScreen';
  static const String forgotPaswordScreen = '/forgotPaswordScreen';
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
  // static const String editRestaurantDetailsScreen = '/editRestaurantDetailsScreen';
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


  //---------------------------------Notification----------------------------------------
  static const String notificationScreen = '/notificationScreen';

  //Restaurant
  static List<GetPage> pages = <GetPage>[
  //
  //   GetPage(name: twoFaScreen, page: () => const TwoFaScreen()),
  //   GetPage(name: orderTransactionDetailsScreen, page: () => const OrderTransactionDetailsScreen(),binding: OrderTransactionDetailsBinding()),
  //   GetPage(name: signUpScreen, page: () => SignUpScreen(index: Get.parameters["index"] ?? ""),binding: SignUpBinding()),
  //   GetPage(name: createProfileScreen, page: () => CreateProfileScreen()),
  //   GetPage(name: selectRoleScreen, page: () => SelectRoleScreen()),
  //   GetPage(name: chooseRestaurantCategoriesScreen, page: () => ChooseRestaurantCategoriesScreen(),binding: ResCategoriesCuisinesBinding()),
  //   GetPage(name: forgotPaswordScreen, page: () => ForgotPaswordScreen()),
  //   GetPage(name: otpScreen, page: () => OtpScreen()),
  //   GetPage(name: changePasswordScreen, page: () => ChangePasswordScreen()),
  //   GetPage(name: restaurantDetailsScreen, page: () => RestaurantDetailsScreen()),
    GetPage(name: restaurantDashboardScreen, page: () => const RestaurantDashboardScreen(),binding: RestaurantDashBoardBinding()),
    GetPage(name: restaurantNavbarScreen, page: () => const RestaurantNavbarScreen(navbarInitialIndex: 0),bindings:
  [RestaurantDashBoardBinding(),RestaurantMenuBinding(),]),
      // SignOutBinding(),ResReviewBindings(),ResOrdersBinding(),ResWalletBinding(),ResInformationBindings(),]),
    // GetPage(name: restaurantWalletScreen, page: () => const WalletScreen(),bindings: [SignOutBinding(),ResWalletBinding(),ResInformationBindings()]),
    GetPage(name: restaurantProductDetailsScreen, page: () => RestaurantProductDetailsScreen()),
    GetPage(name: restaurantWithdrawScreen, page: () => RestaurantWithdrawScreen()),
    // GetPage(name: bankAccountDetailsScreen, page: () => RestaurantBankAccountDetailsScreen()),
    GetPage(name: addRestaurantBankDetails, page: () => AddRestaurantBankDetails()),
    GetPage(name: restaurantOrderDetailsScreen, page: () => RestaurantOrderDetailsScreen()),
    GetPage(name: restaurantOrderListScreen, page: () => const RestaurantOrderListScreen(),binding: ResOrdersBinding()),
    GetPage(name: restaurantMoreOrderDetailsScreen, page: () => RestaurantMoreOrderDetailsScreen()),
    GetPage(name: restaurantProductReviewScreen, page: () => RestaurantProductReviewScreen()),
    // GetPage(name: editRestaurantDetailsScreen,page: () => EditRestaurantDetailsScreen()),
    GetPage(name: restaurantCategoryScreen, page: () => RestaurantCategoryScreen()),
    GetPage(name: restaurantAllCategoryItems, page: () => RestaurantAllCategoryItems()),
    GetPage(name: restaurantSettingScreen, page: () => const RestaurantSettingScreen(),binding: RestaurantSettingBinding()),
    GetPage(name: restaurantAddOnScreen, page: () => RestaurantAddAddonScreen()),
    // GetPage(name: restaurantNotificationScreen, page: () => RestaurantNotificationScreen()),
    // GetPage(name: restaurantHelpCenterScreen, page: () => const RestaurantHelpCenterScreen(),binding: ResHelpCenterBinding()),
    // GetPage(name: restaurantFaqScreen, page: () => const RestaurantFaqScreen(),binding: ResFaqsBinding()),
    // GetPage(name: restaurantPrivacyPolicyScreen, page: () => const RestaurantPrivacyPolicyScreen(),binding: ResFaqsBinding()),
    // GetPage(name: restaurantSupportScreen, page: () => const RestaurantSupportScreen(),binding: ResSupportBinding()),
    // GetPage(name: restaurantTnCScreen, page: () => const RestaurantTncScreen(),binding: ResFaqsBinding()),
    GetPage(name: restaurantInformationScreens, page: () => const RestaurantInformationScreens()),
    GetPage(name: restaurantAddProductScreen, page: () => RestaurantAddProductScreen()),
    GetPage(name: restaurantMyAccountScreen, page: () => RestaurantMyAccountScreen()),
    // GetPage(name: userPasswordChangeScreen, page: () => UserPasswordChangeScreen()),
    // GetPage(name: restaurantSupportQueryReplayScreen, page: () => RestaurantSupportQuarryReplyScreen()),
    GetPage(name: restaurantProfileScreen, page: () => const ProfileScreen()),
    GetPage(name: restaurantEditProductScreen, page: () => RestaurantEditProductScreen()),
    GetPage(name: resOrderTranHisScreen, page: () => const ResOrderTransHistoryScreen()),
    // GetPage(name: prescriptionsScreen, page: () => const PrescriptionsScreen()),
    GetPage(name: restaurantMenuFilterScreen, page: () => const RestaurantMenuFilterScreen()),
    GetPage(name: restaurantBulkUploadMenuItems, page: () => const RestaurantBulkUploadMenuItems()),
    GetPage(name: restaurantExportMenuItemScreen, page: () => const RestaurantExportMenuItemScreen(),binding: RestaurantExportMenuBinding()),
    GetPage(name: restaurantMenuItemDetailsScreen, page: () => const RestaurantMenuItemDetailsScreen(),binding: RestaurantMenuItemDetailsBinding()),
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
    // GetPage(name: resProfileDetailsScreen, page: () =>  const ResProfileDetailsScreen(),binding: ResProfileDetailsBinding()),
    // GetPage(name: resCreateNotificationScreen, page: () =>  const ResCreateNotificationScreen()),
    // GetPage(name: resNotificationSettingsScreen, page: () =>  const ResNotificationSettingsScreen(),binding: ResNotificationSettingsBindings()),
    // GetPage(name: restaurantVendorAgreementCScreen, page: () =>  const RestaurantVendorAgreementCScreen(),binding: ResFaqsBinding()),
  //
  //   //>>>>>>>>>>Grocery<<<<<<<<<<<<<<<\\
  //   GetPage(name: groceryMenuFilterScreen, page: () => const GroceryMenuFilterScreen(),binding: GroceryMenuBinding()),
  //   GetPage(name: groceryExportMenuItemScreen, page: () => const GroceryExportMenuItemScreen(),binding: GroceryExportMenuBinding()),
  //   GetPage(name: fillGroceryShopDetailsScreen, page: () => const FillGroceryDetailsScreens()),
  //   GetPage(name: chooseGroceryCategoriesScreen, page: () => GroceryChooseCategoriesScreen()),
  //   GetPage(name: groceryProductDetailsScreen, page: () => GroceryProductDetailsScreen()),
  //   // GetPage(name: groceryWithdrawScreen, page: () => GroceryWithdrawScreen()),
  //   // GetPage(name: groceryBankAccDetailsScreen, page: () => GroceryBankAccountDetailsScreen()),
  //   // GetPage(name: addGroceryBankAccDetailsScreen, page: () => AddGroceryBankDetails()),
  //   GetPage(name: groceryOrderDetailsScreen, page: () => GroceryOrderDetailsScreen()),
  //   GetPage(name: groceryMoreOrderDetailsScreen, page: () => GroceryMoreOrderDetailsScreen()),
  //   GetPage(name: groceryNavBar, page: () => const GroceryNavbarScreen(navbarInitialIndex: 0),bindings: [GroceryReviewBindings(),SignOutBinding(),GroceryWalletBinding(),GroceryOrdersBinding(),GroceryDashboardBindings(),GroceryMenuBinding(),SignOutBinding(),GroceryInformationBindings()]),
  //   GetPage(name: groceryShopDetailsScreen, page: () => GroceryShopDetailsScreen()),
  //   GetPage(name: groceryProductReviewScreen, page: () => GroceryProductReviewScreen()),
  //   // GetPage(name: groceryBankAccountDetailsScreen, page: () => GroceryBankAccountDetailsScreen()),
  //   GetPage(name: groceryCategoryScreen, page: () => GroceryCategoryScreen()),
  //   GetPage(name: grocerySettingScreen, page: () => const GrocerySettingScreen(),bindings: [GrocerySettingBinding()]),
  //   GetPage(name: groceryAddMenuCategoryScreen, page: () => const GroceryAddMenuCategoryScreen()),
  //   GetPage(name: groceryRequestPayoutScreen, page: () => const GroceryRequestPayoutScreen(),binding: GroceryRequestPayloadBinding()),
  //   GetPage(name: groceryManagePaymentMethod, page: () => const GroceryManagePaymentMethod(),binding: GroceryPaymentMethodBinding()),
  //   GetPage(name: groceryDownloadStatementScreen, page: () => const GroceryDownloadStatementScreen()),
  //   GetPage(name: groceryExportReviewsScreen, page: () => const GroceryExportReviewsScreen(),binding: GroceryReviewBindings()),
  //   GetPage(name: groceryBulkRespondsScreen, page: () => const GroceryBulkRespondsScreen(),binding: GroceryReviewBindings()),
  //   GetPage(name: grocerySingleReviewResponseScreen, page: () => const GrocerySingleReviewResponseScreen(),binding: GroceryReviewBindings()),
  //
  //   GetPage(name: groceryComplianceAndLicensesScreen, page: () => const GroceryComplianceAndLicensesScreen(),binding: GroceryComplianceAndLicensesBinding()),
  //   GetPage(name: groceryUploadComplianceDocumentsScreen, page: () => const GroceryUploadComplianceDocumentsScreen(),binding: GroceryUploadComplianceDocumentBinding()),
  //   GetPage(name: groceryDocumentDetailsScreen, page: () => const GroceryDocumentDetailsScreen(),binding: GroceryDocumentDetailsBinding()),
  //   GetPage(name: groceryUserAccessScreen, page: () => const GroceryUserAccessScreen(),binding: GroceryUserAccessBinding()),
  //   GetPage(name: groceryAddNewUserScreen, page: () => const GroceryAddNewUserScreen(),binding: GroceryAddNewUserBinding()),
  //   GetPage(name: grocerySecuritySettingsScreen, page: () => const GrocerySecuritySettingsScreen(),bindings:[GrocerySecuritySettingBinding(),GroceryInformationBindings()]),
  //
  //
  //   GetPage(name: groceryConfigurationScreen, page: () => const GroceryConfigurationScreen(),binding: GrocerySettingBinding()),
  //   GetPage(name: groceryInformationScreens, page: () => const GroceryInformationScreens(),bindings: [GroceryInformationBindings()]),
  //   // GetPage(name: groceryHelpCenterScreen, page: () => GroceryHelpCenterScreen()),
  //   GetPage(name: groceryMyAccountScreen, page: () => GroceryMyAccountScreen()),
  //   GetPage(name: groceryEditProductScreen, page: () => GroceryEditProductScreen()),
  //   GetPage(name: groceryAllCategoryItems, page: () => GroceryAllCategoryItems()),
  //   GetPage(name: groceryNotificationScreen, page: () => GroceryNotificationScreen()),
  //   // GetPage(name: groceryFaqScreen, page: () => GroceryFaqScreen()),
  //   // GetPage(name: groceryPrivacyPolicyScreen, page: () => const GroceryPrivacyPolicyScreen()),
  //   // GetPage(name: grocerySupportScreen, page: () => GrocerySupportScreen()),
  //   // GetPage(name: groceryTncScreen, page: () => const GroceryTncScreen()),
  //   // GetPage(name: grocerySupportQuarryReplyScreen, page: () => GrocerySupportQuarryReplyScreen()),
  //   GetPage(name: groceryAddProductScreen, page: () => GroceryAddProductScreen()),
  //   GetPage(name: groceryOrderListScreen, page: () =>const GroceryOrderListScreen(),),
  //   GetPage(name: groceryMenuItemDetailsScreen, page: () =>const GroceryMenuItemDetailsScreen(),binding : GroceryMenuItemDetailsBinding()),
  //   GetPage(name: groceryBulkUploadMenuItems, page: () =>const GroceryBulkUploadMenuItems(),binding : GroceryMenuItemDetailsBinding()),
  //   GetPage(name: groceryExportOrdersScreen, page: () =>const GroceryExportOrdersScreen(),binding : GroceryOrdersBinding()),
  //
  //   ///Pharmacy routes
  //   GetPage(name: fillPharmacyDetailsScreen, page: () => const FillPharmacyDetailsScreen()),
  //   GetPage(name: choosePharmacyCategoriesScreen, page: () => ChoosePharmacyCategories()),
  //   GetPage(name: pharmacyNavBar, page: () =>  PharmacyNavbarScreen(navbarInitialIndex: 0),bindings: [PharmacyProductBinding(),SignOutBinding(),PharmacyReviewBinding()]),
  //   GetPage(name: pharmacyOrderDetails, page: () => const PharmacyOrderDetails()),
  //   GetPage(name: pharmacyMoreOrderDetails, page: () =>  PharmacyMoreOrderDetails()),
  //   GetPage(name: pharmacyAddProductScreen, page: () => PharmacyAddProductScreen()),
  //   // GetPage(name: pharmacyWithdrawScreen, page: () => PharmacyWithdrawScreen()),
  //   // GetPage(name: pharmacyBankAccountDetailsScreen, page: () => PharmacyBankAccountDetailsScreen()),
  //   GetPage(name: addPharmacyBankDetails, page: () => AddPharmacyBankDetails()),
  //   GetPage(name: pharmacyProductDetailsScreen, page: () => PharmacyProductDetailsScreen()),
  //   GetPage(name: pharmacyEditProfileScreen, page: () => PharmacyEditProfile()),
  //   GetPage(name: pharmacyCategoryScreen, page: () => PharmacyCategoryScreen()),
  //   GetPage(name: pharmacyBulkUploadMenuItems, page: () =>const PharmacyBulkUploadMenuItems(),binding : pharmacyMenuItemDetailsBinding()),
  //   GetPage(name: pharmacyMenuItemDetails, page: () => PharmacyMenuItemsScreen(),binding : PharmacyMenuItemDetailsBindings()),
  //   GetPage(name: pharmacyExportReviews, page: () => const PharmacyexportreviewsScreen(),binding: PharmacyReviewsBinding() ),
  //   GetPage(name: pharmacyRequestPayoutScreen, page: () => const PharmacyRequestPayoutScreen(),binding: PharmacyRequestPayloadBinding()),
  //   GetPage(name: pharmacyManagePaymentMethod, page: () => const PharmacyManagePaymentMethod(),binding: PharmacyPaymentMethodBinding()),
  //   GetPage(name: pharmacyDownloadStatement, page: () =>  const PharmacyDownloadStatementScreen()),
  //
  //
  //   // GetPage(name: pharmacyHelpCenterScreen, page: () => PharmacyHelpCenterScreen()),
  //   // GetPage(name: pharmacyFAQScreen, page: () => PharmacyFaqScreen()),
  //   // GetPage(name: pharmacyTnCScreen, page: () => const PharmacyTncScreen()),
  //   // GetPage(name: pharmacyPrivacyPolicyScreen, page: () => const PharmacyPrivacyPolicyScreen()),
  //   // GetPage(name: pharmacySupportScreen, page: () => PharmacySupportScreen()),
  //   GetPage(name: pharmacyProductReviewScreen, page: () => PharmacyProductReviewScreen()),
  //   GetPage(name: pharmacyMyAccountScreen, page: () => PharmacyMyAccountScreen()),
  //   GetPage(name: pharmacyNotificationScreen, page: () => PharmacyNotificationScreen()),
  //   GetPage(name: pharmacyProfileDetailsScreen, page: () => PharmacyProfileDetailsScreen()),
  //   GetPage(name: pharmacyMenuFilterScreen, page: () => const PharmacyMenuFilterScreen()),
  //   GetPage(name: pharmacyPrescriptionVerificationScreen, page: () => const PharmacyPrescriptionVerificationScreen(),binding: PrescriptionBinding()),
  //   // GetPage(name: editPharmacyDetailsScreen,page: () => EditPharmacyDetailsScreen()),
  //   // GetPage(name: pharmacySupportQueryReplyScreen, page: () => PharmacySupportQueryReplyScreen()),
  //   GetPage(name: pharmacySubCategoryItems, page: () => PharmacySubCategoryItems()),
  // GetPage(name: pharmacyEditProductScreen, page: () => const PharmacyEditProductScreen(),binding: PharmaEditProductBinding()),
  // GetPage(name: pharmacyOrderListScreen, page: () => const PharmacyOrderListScreen()),
  // GetPage(name: pharmacyBulkUploadMenuItems, page: () => const PharmacyOrderListScreen()),
  // GetPage(name: pharmacyExportMenuItemScreen, page: () => const Pharmacyexportmenuitemscreen(), binding: pharmacyPharmacyExportBinding()),
  //   GetPage(name: pharmacybulkrespondsscreen, page: () => const Pharmacybulkrespondsscreen(),binding: PharmacyReviewsBinding()),
  //   GetPage(name: pharmacySingleReview, page: () => const PharmacySingleReviewResponseScreen(),binding: PharmacyReviewsBinding()),
  //
  //
  //   GetPage(name: pharmacySettingScreen, page: () => const PharmacySettingScreen()),
  //   GetPage(name: pharmacyInformationScreens, page: () => const PharmacyInformationScreens(),bindings: [PharmacyInformationBindings()]),
  //   GetPage(name: pharmacyConfigurationScreen, page: () => const PharmacyConfigurationScreen(),binding: PharmacySettingBinding()),
  //   GetPage(name: pharmacyComplianceAndLicensesScreen, page: () => const PharmacyComplianceAndLicensesScreen(),binding: PharmacyComplianceAndLicensesBinding()),
  //   GetPage(name: pharmacyUserAccessScreen, page: () => const PharmacyUserAccessScreen(),binding: PharmacyUserAccessBinding()),
  //   GetPage(name: pharmacySecuritySettingsScreen, page: () => const PharmacySecuritySettingsScreen(),bindings: [PharmacySecuritySettingBinding(),PharmacyInformationBindings()]),
  //   GetPage(name: pharmacyAddMenuCategoryScreen, page: () => const PharmacyAddMenuCategoryScreen(),bindings:[PharmacySettingBinding()]),
  //   GetPage(name: pharmacyUploadComplianceDocumentsScreen, page: () => const PharmacyUploadComplianceDocumentsScreen(),binding:PharmacyUploadComplianceDocumentBinding()),
  //   GetPage(name: pharmacyDocumentDetailsScreen, page: () => const PharmacyDocumentDetailsScreen(),binding:PharmacyDocumentDetailsBinding()),
  //   GetPage(name: pharmacyAddNewUserScreen, page: () => const PharmacyAddNewUserScreen(),binding:PharmacyAddNewUserBinding()),
  //   GetPage(name: printPrescriptionLabelsScreen, page: () =>  const PrintPrescriptionLabelsScreen(),binding:PrintPrescriptionLabelsBinding()),
  //   GetPage(name: pharmacyExportScreen, page: () => const PharmacyExportScreen(),binding:pharmacyPharmacyExportBinding()),
  //


    // //---------------------------------Notification----------------------------------------
    // GetPage(name: notificationScreen, page: () => const NotificationScreen() , binding: NotificationsBinding()),
    //
    // GetPage(name: maintenance, page: () => const MaintenanceModeScreen(),binding: MaintenanceBinding()),

  ];
}
