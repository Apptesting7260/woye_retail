import 'package:get/get.dart';

import '../controller/result_filter_controller.dart';

class SearchResultBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => ResultFilterController());
  }
}