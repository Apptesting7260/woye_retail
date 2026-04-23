import 'package:get/get.dart';

import '../controller/restaurant_document_detils_controller.dart';

class ResDocumentDetailsBinding extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut(() => RestaurantDocDetailsController());
  }

}