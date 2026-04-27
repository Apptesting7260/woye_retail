import 'package:get/get.dart';

import '../controller/restaurant_faq_controller.dart';

class ResFaqsBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => RestaurantFAQController());
  }

}