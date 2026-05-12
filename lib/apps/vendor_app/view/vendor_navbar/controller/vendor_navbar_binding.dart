import 'package:get/get.dart';
import 'package:gyaawa/apps/vendor_app/view/vendor_navbar/controller/vendor_navbar_controller.dart';

class VendorNavbarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VendorNavbarController());
  }
}