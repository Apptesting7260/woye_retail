import 'package:get/get.dart';

import '../controller/restaurant_export_menu_item_controller.dart';

class RestaurantExportMenuBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => RestaurantExportMenuController(),);
  }
}