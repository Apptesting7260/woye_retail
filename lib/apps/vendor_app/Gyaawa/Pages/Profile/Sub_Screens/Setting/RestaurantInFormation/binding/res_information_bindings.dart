import 'package:get/get.dart';

import '../controller/restaurant_information_controller.dart';

class ResInformationBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => FillRestaurantDetailsController());
  }

}