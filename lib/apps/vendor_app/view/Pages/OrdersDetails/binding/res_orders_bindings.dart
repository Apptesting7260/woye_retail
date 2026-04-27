import 'package:get/get.dart';

import '../controller/restaurant_order_list_controller.dart';

class ResOrdersBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => RestaurantOrderController());
  }
}