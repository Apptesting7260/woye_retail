import 'package:get/get.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/menu/controller/vendor_menu_controller.dart';


class VendorMenuBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => VendorMenuController(),);
  }
}