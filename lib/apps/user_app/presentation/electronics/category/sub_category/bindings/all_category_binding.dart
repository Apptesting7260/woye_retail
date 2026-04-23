import 'package:get/get.dart';

import '../controller/all_category_controller.dart';

class AllCategoryBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => AllCategoryController());
  }
}