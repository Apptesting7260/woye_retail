import 'package:get/get.dart';
import 'package:gyaawa/routes/vendor_routes/vendor_app_routes.dart';

bool isOnInformationScreen() {
  final route = Get.currentRoute;

  return route == VendorAppRoutes.restaurantInformationScreens;
}

bool isUploadDocsScreen() {
  final route = Get.currentRoute;

  return route == VendorAppRoutes.restaurantComplianceAndLicensesScreen ||
        route == VendorAppRoutes.resUploadComplianceDocumentsScreen;

}


bool isSupportScreen() {
  final route = Get.currentRoute;

  return route == VendorAppRoutes.restaurantSupportScreen ||
        route == VendorAppRoutes.resEmailSupportScreen ||
        route == VendorAppRoutes.resPhoneSupportScreen;
}
