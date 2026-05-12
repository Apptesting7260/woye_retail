import 'package:get/get.dart';

import '../controller/retail_product_review_controller.dart';

class RetailProductReviewBinding extends Bindings{
  @override
  void dependencies() {
     Get.lazyPut(() => RetailProductReviewController());
  }
}