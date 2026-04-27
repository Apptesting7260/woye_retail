import 'package:get/get.dart';

import '../controller/restaurant_menu_controller.dart';

class RestaurantMenuBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => RestaurantMenuController(),);
  }
}