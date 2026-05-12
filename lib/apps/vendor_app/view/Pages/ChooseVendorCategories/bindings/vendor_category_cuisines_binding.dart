import 'package:get/get.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/ChooseVendorCategories/controller/vendor_categories_controller.dart';


class VendorCategoriesCuisinesBinding extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut(() => VendorCategoriesController());
  }
}