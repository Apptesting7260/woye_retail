import 'package:get/get.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/menu/controller/vendor_menu_item_details_controller.dart';


class VendorMenuItemDetailsBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => VendorMenuItemDetailsController(),);
  }


}