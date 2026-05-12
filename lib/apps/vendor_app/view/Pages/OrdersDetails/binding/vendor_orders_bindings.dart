import 'package:get/get.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/OrdersDetails/controller/vendor_order_list_controller.dart';

class VendorOrdersBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => VendorOrderListController());
  }
}