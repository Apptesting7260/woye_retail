import 'package:get/get.dart';

import '../controller/res_review_controller.dart';

class ResReviewBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => ResReviewController());
  }
}