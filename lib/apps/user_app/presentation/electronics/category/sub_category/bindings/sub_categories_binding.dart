import 'package:get/get.dart';
import '../controller/subcategories_controller.dart';

class SubCategoriesBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => SubcategoriesController());
  }
}