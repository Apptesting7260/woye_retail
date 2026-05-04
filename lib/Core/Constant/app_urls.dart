class AppUrls {
  // static const String baseUrl = "https://nbttech.xyz/woy/vendor-api";
  static const String baseUrl = "https://nbttest.com/gyawaa/vendor-api";
  // static const String baseUrl = "http://127.0.0.1:8000";
  static const String baseUrlFroMaintenance = "https://nbturls.in/woy/api";
  static const String paymentBaseUrl = "https://api.paystack.co";


  // >>>>>>>>>>>>>>>>> vendor SignUp>>>>>>>>>>>>>>>>>>>>>>
  static String get vendorSignUp => '$baseUrl/sign-up';
  static String get vendorVerifyOtp => '$baseUrl/verify-otp';
  static String get vendorResendOtp => '$baseUrl/resend-otp';
  static String get vendorSignIn => '$baseUrl/sign-in';
  static String get vendorForgotPassword => '$baseUrl/forget-password';
  static String get verifyForgotOtp => '$baseUrl/verify-otp-forgot-password';
  static String get changePasswordApi => '$baseUrl/change-password';
  static String get vendorForgotResendOtp => '$baseUrl/resend-verify-otp-forgot-password';
  static const String numberValidation = "$baseUrl/verify-phone";

  /* ---------------- Mapbox -----------------------------------------  */

  static const String mapboxApi = "https://api.mapbox.com/search/geocode/v6/forward";

  /* ---------------- Authentication -----------------------------------------  */

  // static const String createVendor = "$baseUrl/vendor-create";
  static const String twoFactorOtpVerify = "$baseUrl/TwoFactorOtpVerify";
  static const String twoFactorOtpResend = "$baseUrl/TwoFactorOtpResend";
  // static const String login = "$baseUrl/vendor-login";
  static const String forgetPassword = "$baseUrl/forget-password";
  // static const String forgetPassword = "$baseUrl/vendor-forget-password";
  static const String verifyOtp = "$baseUrl/verify-otp";
  // static const String verifyOtp = "$baseUrl/vendor-verify-otp";
  static const String resendOtp = "$baseUrl/resend-otp";
  static const String vendorRegister = "$baseUrl/vendor-register";
  static const String changePassword = "$baseUrl/change-password";
  static const String updatePassword = "$baseUrl/update-password";
  static const String accountStatusUrl = "$baseUrl/get-status";
  static const String shopStatus = "$baseUrl/shop-status";
  static const String removeCategory = "$baseUrl/remove-category";
  static const String profileDetails = "$baseUrl/profile-details"; // fill details for first time


/* ------------------------------ sign-out ---------------------------------  */
  static const String signOut = "$baseUrl/sign-out";


/* ------------------------------ Profile ---------------------------------  */
  static const String getProfile = "$baseUrl/get-profile";
  static const String updateInformation = "$baseUrl/information-update";


  /* ------------------------------ setting/Configurations ---------------------------------  */

  static const String configurationUpdate = "$baseUrl/configuration-update";
  static const String selectCategory = "$baseUrl/select-category";
  static const String complianceDocuments = "$baseUrl/compliance-documents";
  static const String complianceDocumentsDetail = "$baseUrl/compliance-documents-detail";
  static const String complianceDocumentsDelete = "$baseUrl/compliance-documents-delete";
  static const String complianceDocumentsUpload = "$baseUrl/compliance-documents-upload";
  static const String userAccessControl = "$baseUrl/user-access-control";
  static const String createUpdateUser = "$baseUrl/create-update-user";
  static const String getUserDetail = "$baseUrl/get-user-detail";
  static const String deleteUser = "$baseUrl/delete-user";
  static const String twoFactorAuthentication = "$baseUrl/two-factor-authentication";


  /* ------------------------------ help ---------------------------------  */
  static const String supportTicketSubmit = "$baseUrl/support-ticket-submit";
  static const String emailSupport = "$baseUrl/email-support";
  static const String phoneSupport = "$baseUrl/phone-support";
  static const String getPages = "$baseUrl/get-pages";


  /* ------------------------------ maintenance ---------------------------------  */
  static const String maintenance = "$baseUrlFroMaintenance/maintenance";
  static const String appVersion = "$baseUrlFroMaintenance/app-version";

/* ------------------------------ Categories ---------------------------------  */

  static const String categoryCuisineGet = "$baseUrl/category-department-get";
  static const String getChooseCategories = "$baseUrl/get-category";
  static const String categoryUpdate = "$baseUrl/profile-category-update";
  static const String newCategoryRequest = "$baseUrl/category-request";
  static const String getCategories = "$baseUrl/get-categories";
  static const String getProductByCategory = "$baseUrl/get-product-by-category";
  static const String categoryCuisineSave = "$baseUrl/category-department-save";

/* ------------------------------ Products ----------------------------  */
  static const String productList = "$baseUrl/product-list";
  static const String vendorSingleProduct = "$baseUrl/single-product";
  static const String editRestaurantProduct = "$baseUrl/edit-product";

/* ------------------------------ Address Section ----------------------------  */

/* ------------------------------------------------ User Wallet ----------------------------------------------------  */

/* ------------------------------ Restaurant ---------------------------------*/

/* ------------------------------ Dashboard ---------------------------------*/
  static const String dashboardUrl = "$baseUrl/dashboard";
  // static const String dashboardUrl = "$baseUrl/vendor-dashboard";

  /* ------------------------------ Product List ---------------------------------*/
  static const String productListUrl = "$baseUrl/product-list";
  static const String productDeleteUrl = "$baseUrl/product-delete";

  /* ------------------------------ Order List ---------------------------------*/
  static const String orders = "$baseUrl/orders";
  static const String orderExport = "$baseUrl/order-export";
  static const String singleOrderUrl = "$baseUrl/single-order";
  static const String acceptOrderUrl = "$baseUrl/accept-order";
  static const String rejectOrderUrl = "$baseUrl/reject-order";
  static const String markReadyUrl = "$baseUrl/mark-ready";
  static const String simulatePickupUrl = "$baseUrl/simulate-pickup";
  static const String simulateDelivery = "$baseUrl/simulate-delivery";
  static const String contactCustomer = "$baseUrl/contact-customer";
  static const String verifyPrescription = "$baseUrl/verify-prescription";
  static const String getPrescription = "$baseUrl/get-prescription";
  static const String printPrescriptionLabel = "$baseUrl/print-prescription-label";
  static const String allPrintPrescriptionLabel = "$baseUrl/print-prescription-label-all";


  /* ------------------------------ Add Restaurant Product ---------------------------------*/
  static const String restaurantAddProductUrl = "$baseUrl/add-product";
  static const String getCategoryUrl = "$baseUrl/get-categories";
  static const String getAddOnUrl = "$baseUrl/get-addons";
  static const String getCuisineTypeUrl = "$baseUrl/get-cuisine";
  static const String newAddOnUrl = "$baseUrl/add-addon";
  static const String editAddOnUrl = "$baseUrl/edit-addon";
  static const String deleteAddOnUrl = "$baseUrl/delete-addon";

  /* ------------------------------ FAQ AND PRIVACY POLICY AND TERM CONDITION  ---------------------------------*/
 static const String faqPrivacyTcUrl = "$baseUrl/get-faqs";
 static const String getSupportUrl = "$baseUrl/get-support";
 static const String createSupportUrl = "$baseUrl/create-support";

 /* ------------------------------ Reviews  ---------------------------------*/
 static const String reviews = "$baseUrl/reviews";
 static const String reviewsPendingResponse = "$baseUrl/reviews-pending-response";
 static const String reviewsUrl = "$baseUrl/order-reviews";
 static const String replyOnReviewUrl = "$baseUrl/reply-on-review";
 static const String bulkReviewResponse = "$baseUrl/review-bulk-response";
 static const String reviewsExport = "$baseUrl/reviews-export";
 static const String reviewResponse = "$baseUrl/review-response";

 /* ------------------------------ Wallet  ---------------------------------*/
 static const String getWalletUrl = "$baseUrl/get-wallet";
 static const String getVendorWallet = "$baseUrl/get-vendor-wallet";
  static const String bankListUrl = "$baseUrl/get-bank-list";
  static const String addPaymentMethod = "$baseUrl/add-payment-method";
  static const String walletUrl = "$baseUrl/wallet";
  static const String paymentMethod = "$baseUrl/payment-method/";
  static const String updatePaymentMethod = "$baseUrl/update-payment-method";
  static const String removePaymentMethod = "$baseUrl/remove-payment-method";
  static const String statementDownload = "$baseUrl/statement-download";
  static const String withdraw = "$baseUrl/withdraw";
  static const String overviewUrl = "$baseUrl/overview";
  // static const String getWallet = "$baseUrl/get-wallet";


  /* ------------------------------ Add Pharmacy Product ---------------------------------*/

  static const String packageTypeUrl = "$baseUrl/get-packagingType";
  static const String brandTypeUrl = "$baseUrl/get-brands";
  static const String addPharmacyProductUrl = "$baseUrl/add-pharmacy-product";
  static const String getConsumeUrl = "$baseUrl/get-consume";
  static const String editPharmacyProductUrl = "$baseUrl/edit-pharmacy-product";


  /*---------------- grocery ---------------*/
  static const String getUnitTypeUrl = "$baseUrl/get-units";
  static const String addGroceryProductUrl = "$baseUrl/add-grocery-product";
  static const String editGroceryProductUrl = "$baseUrl/edit-grocery-product";

/*---------------- add Bank account  ---------------*/

  static const String addBankAccountUrl = "$baseUrl/add-bank-account";
  static const String getAllAccountsUrl = "$baseUrl/get-all-accounts";
  // static const String getSingleAccountsUrl = "$baseUrl/get-single-account";
  static const String updateBankAccountsUrl = "$baseUrl/update-bank-account";
  static const String withdrawRequestUrl = "$baseUrl/withdraw-request";
  static const String removeBankAccountUrl = "$baseUrl/remove-bank-account";
  static const String getBankAccountUrl = "$baseUrl/get-bank-account";
  static const String withdrawUrl = "$baseUrl/withdraw";

/*---------------- Calculate chart ---------------*/

  static const String calculateChart = "$baseUrl/calculate-chart";

/*---------------- supportChatUrl ---------------*/

  static const String supportChatUrl = "$baseUrl/get-support-chat";
  static const String supportChatReplyUrl = "$baseUrl/support-chat-reply";
  static const String markAsClosedChatReplyUrl = "$baseUrl/mark-as-close";


/*----------------Notifications  ---------------*/

  static const String notificationsUrl = "$baseUrl/notifications";
  // static const String notificationsUrl = "$baseUrl/get-notifications";
  static const String notificationsSeenUrl = "$baseUrl/notifications-seen";
  static const String markAllRead = "$baseUrl/mark-all-read";
  static const String markAsRead = "$baseUrl/mark-as-read";
  static const String notificationRemove = "$baseUrl/notification-remove";
    static const String notificationSend = "$baseUrl/notification-send";
    static const String notificationPreferences = "$baseUrl/notification-preferences";
    static const String notificationsTemplate = "$baseUrl/notifications-template";

/*---------------- calculate-wallet-chart  ---------------*/

  static const String calculateWalletChartUrl = "$baseUrl/calculate-wallet-chart";
//muje jo reponde diya h vo deta dekhana h

/*---------------- Export transaction---------------*/

  static const String exportTransactionUrl = "$baseUrl/export-transaction";
  static const String productExportApi = "$baseUrl/product-export";

  //Push notification on off

  static const String toggleNotifications = "$baseUrl/toggle-notifications";

//-------------------PAYMENT API FOR WITHDRAW
  static const String allBanksUrl = "$paymentBaseUrl/bank";
  static const String transferReceiptsUrl = "$paymentBaseUrl/transferrecipient";
  static const String transferUrl = "$paymentBaseUrl/transfer";



}

