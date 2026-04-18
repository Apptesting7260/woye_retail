import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ResultFilterController extends GetxController {

  List<String> selectedQuick = [];
  List<String> selectedCategories = [];
  List<String> selectedPriceRange = [];
  List<String> selectedBrands = [];

  List<String> brands = ["Nike", "Adidas", "Samsung", "Apple"];
  List<String> quickFilters = ["In Stock", "On Sale", "Trending", "Free Ship"];
  List<String> categories = ["Electronics", "Fashion", "Home & Garden", "Sports", "Beauty", "Books", "Kids", "Pets"];
  List<String> prizeRange = ["Under GHS 500", "GHS 500 - GHS 1,000", "GHS 2,500 - GHS 5,000"];

  void updatePriceRange(List<String> val) {
    selectedPriceRange = val;
    update();
  }
  void toggleQuickFilter(String item) {
    selectedQuick.contains(item)
        ? selectedQuick.remove(item)
        : selectedQuick.add(item);
    update();
  }
  void updateCategories(List<String> val) {
    selectedCategories = val;
    update();
  }

  void updateBrands(List<String> val) {
    selectedBrands = val;
    update();
  }
}