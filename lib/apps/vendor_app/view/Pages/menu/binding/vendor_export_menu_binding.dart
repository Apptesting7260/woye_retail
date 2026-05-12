import 'package:get/get.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/menu/controller/vendor_export_menu_item_controller.dart';

class VendorExportMenuBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => VendorExportMenuItemController(),);
  }
}