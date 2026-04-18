import 'package:get/get.dart';
import 'package:gyaawa/presentation/electronics/category/sub_category/controller/departments_store_controller.dart';

class DepartmentsStoreBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => DepartmentsStoreController());
  }
}