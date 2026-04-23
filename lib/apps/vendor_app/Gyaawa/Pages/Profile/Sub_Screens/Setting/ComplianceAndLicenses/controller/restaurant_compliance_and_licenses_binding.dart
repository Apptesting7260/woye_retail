import 'package:get/get.dart';
import 'package:gyaawa/apps/vendor_app/Gyaawa/Pages/Profile/Sub_Screens/Setting/ComplianceAndLicenses/controller/restaurant_compliance_and_licenses_controller.dart';

class ComplianceAndLicensesBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => ComplianceAndLicensesController());
  }
}