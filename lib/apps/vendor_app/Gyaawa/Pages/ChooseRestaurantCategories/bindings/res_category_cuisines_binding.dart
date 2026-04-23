import 'package:get/get.dart';

import '../controller/restaurant_categories_controller.dart';

class ResCategoriesCuisinesBinding extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut(() => RestaurantCategoriesController());
  }
}