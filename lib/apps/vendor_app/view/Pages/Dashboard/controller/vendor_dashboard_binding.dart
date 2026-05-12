import 'package:get/get.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/Dashboard/controller/vendor_dashboard_controller.dart';

class VendorDashboardBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => VendorDashboardController());
  }
}